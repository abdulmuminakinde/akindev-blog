---
date: "2025-05-07T15:01:09+01:00"
title: "Go Dev Diaries: How an Empty JSON Broke My Workflow"
author: "Abdulmumin"
tags: ["go"]
showToc: true
---

## An Important Context

I recently contributed to an open source tool called AutoCommit[^1]. The tool solved a problem I had considered solving myself. AutoCommit leverages AI to generate descriptive conventional commit messages based on the input `git diff`[^2]. Pretty neat and handy for those times when you struggle to come up with commit messages for code changes you made. It is also going to be super helpful with collaborations.

So, instead of jumping straight to possibly reinventing the wheel, I decided to see if AutoCommit could just work out of the box. And it would have, if it didn't attempt to force money out of my already sparse wallet.

The library only worked with OpenAI's models which you have to pay for. So, as a self-acclaimed software philanthropist, I thought to help humanity. I sought to fix the vendor lock-in and allow the use of models that are free (maybe a little less fine-tuned, works nonetheless) compared to OpenAI's top models.

"How?" you might ask.

I implemented a feature to allow seamless incorporation of other large language model (LLM) providers, such as Groq, via a flexible interface-based design (more on this in a dedicated post).

Groq[^3] is an AI platform that affords you the use of LLMs such as llama, gemma, deepseek, etc., in your AI-powered applications. You only need the free API key and that is also remarkably easy to get.

My contribution to the AutoCommit tool has since inspired the core maintainer to add more LLM providers such as Mistral and Google AI.

Anyway, I needed to talk to Groq's API, and looking back, I probably should’ve just hand-rolled the basic http client I needed myself. However, I thought to check if someone had already built a more robust SDK[^4] for my purpose. That way, I’d get two big wins:

1. Faster development time

2. Better reliability since I expected a dedicated module to handle all the edge cases better than I would have for the simple task I needed it to do.

After a bit of surfing, I eventually chose a fairly recent library called groq-go[^5] mainly because its README invluded a usage example.

Everything worked fine, until it didn't.

## The Problem

This fateful morning, after I made a couple of changes to my [LiteLookup](https://pypi.org/project/litelookup/) tool, I staged my changes and ran the AutoCommit tool like usual. Instead of the usual nicely-written conventional commit message, I got a 400 Bad Request error. This didn't make sense because everything had been working smoothly until then. I'd only gotten similar errors when trying to process a bulky `git diff`. This time however, I was only committing a bit of refactoring changes to my codebase.

I fired up my nvim-dap-delve[^6] setup in my preferred code editor (Neovim 😉) and put on my debug cap. A bunch of breakpoints, step-ins, step-overs, and variable inspections later, I realized it was a problem with the request object. Not groundbreaking, I know. I mean it should have been obvious that a 400 status code meant something was wrong with the request that was being sent over the wire.

So you could say I probably didn't need all the fancy debugging frenzy I went in, right? Skill issue?

Well, I did it anyway and among other things, I could confirm the API key was populating correctly. That wasn't particularly surprising since a problem with the API key would have resulted in a more specific 401 Unauthorized error. I also could confirm that `json.Marshal`[^7] was doing its job correctly — the request body wasn't malformed and the returned `error` was nil.

So, this definitely had to be a problem with groq-go, the library I chose to interact with Groq. I continued to wonder how a tool would suddenly stop working when neither it nor its dependecies had been updated. Maybe the API validation logic got stricter overnight.

Still trying to get to the root of the issue, I added the following code to the client function to get the exact error message that was being returned:

```go
if resp.StatusCode != http.StatusOK {
    errorBody, readErr := io.ReadAll(resp.Body)
    if readErr != nil {
        return nil, fmt.Errorf("error reading error response: %v (status code: %d)", readErr, resp.StatusCode)
    }
    // Return the error with the response body included
    return nil, fmt.Errorf("API error (status code %d): %s", resp.StatusCode, string(errorBody))
}
```

And then I got the JSON error response Groq was sending back:

```json
{
  "error": {
    "message": "'response_format' : one of the following must be satisfied[('response_format.type' : property 'type' is missing) OR ('response_format.type' : property 'type' is missing) OR ('response_format.type' : property 'type' is missing)]",

    "type": "invalid_request_error"
  }
}
```

The error message was telling me something specific: the `response_format` object in my request was missing a required `type` property.

_I just want my commit message!_

I doubled down, determined to get to the bottom of the issue which then brings me to the next part.

## Teachable Moment

At first glance, the JSON error output was confusing. But after a bit of research, it turned out to be a classic case of Go’s `omitempty` tag behaving unexpectedly when used with embedded structs[^8]. Go has a weird quirk where the `omitempty` tag behaves in a non-intuitive way when applied to embedded structs.

Let's get into it.

After a bit of code spelunking and jumping to definitions, I found the offending struct in the groq-go module — `requestBody`:

```go
type requestBody struct {
	// Messages represents a slice of Message structures for the chat completion request.
	Messages []Message `json:"messages"`
	// Model specifies the model to use for the chat completion.
	Model string `json:"model"`
	// MaxTokens sets the maximum number of tokens to generate.
	MaxTokens int `json:"max_tokens"`

	// ResponseFormat specifies the format of the response.

        // Field appears in JSON as key "response_format" and
        // the field is marshaled as an empty JSON object if its value is empty,
	ResponseFormat struct {
		Type string `json:"type,omitempty"`
	} `json:"response_format,omitempty"`

	// Seed sets the seed for the random number generator.
	Seed int `json:"seed,omitempty"`
	// Stream indicates whether to stream the response.
	Stream bool `json:"stream"`
	// Stop specifies the sequence where the text generation should stop.
	Stop *string `json:"stop,omitempty"`
	// Temperature controls randomness in the output.
	Temperature float64 `json:"temperature"`
	// TopP controls the diversity of the output.
	TopP float64 `json:"top_p"`
}
```

You can see the `ResponseFormat` field here. It is an embedded struct (struct within a struct) with an `omitempty` tag.

The `omitempty` tag when specified on a struct field tells the marshaller[^9] how to handle nil and empty values. When specified, like in our case, a field is omitted from the JSON output if the value is a zero value for its type. What does this mean?

It means empty slices, empty strings, zero integers, empty maps, false booleans and nil pointers are all omitted from the JSON output as long as the `omitempty` tag is specified.

Unlike all of the above, however, an empty struct in Go isn’t considered a zero value for `omitempty` purposes. This means the marshaller includes it as `{}` even if all its fields are empty.

A struct's zero value is an empty struct, and is treated differently by Go's JSON marshaller. You see, an empty struct in go is still a value and `omitempty` will not exclude it like it does with other zero values. It will only be omitted if the field is a pointer to the struct.

In our case, it means the `ResponseFormat` field is included in the JSON output as an empty object rather than being totally omitted. An empty struct here means the `Type` field is not populated, hence the 400 response code.

## Fixing it

All that was needed to stop the struct from being marshaled as an empty JSON object was to make it part of a nil pointer. What does that look like in code?

```go
// Separate the ResponseFormat struct from the requestBody struct
type ResponseFormat struct {
    Type string `json:"type,omitempty"`
}

// requestBody now looks like this
type requestBody struct {
    // other fields like before...

    // change the struct definition to use a pointer to the ResponseFormat struct

    // the field is now omitted from the object if its value is nil,
    ResponseFormat *ResponseFormat `json:"response_format,omitempty"`

    // more fields...
}
```

Now let's inspect what the JSON output looks like before and after making the change for a request body like the following.

```go
func (c Client) ChatCompletion(
messages []Message,
options ...Option,
) (ChatCompletionResponse, error) {
    if len(messages) == 0 {
    return nil, fmt.Errorf("no messages provided")
    }

    // requestBody with omitted ResponseFormat
    body := requestBody{
        Messages:    filterMessages(messages),
        Model:       "llama3-8b-8192",
        Temperature: 1,
        MaxTokens:   1024,
        TopP:        1,
        Stream:      false,
        Stop:        nil,
    }

    for _, option := range options {
        option(&body)
    }
    jsonData, err := json.Marshal(body)
    if err != nil {
        return nil, err
    }
    //...

}
```

JSON output before (struct embedded directly):

```json
{
  "messages": [...],
  "model": "llama3-8b-8192",
  "max_tokens": 1024,
  "response_format": {}, // response_format is included as an empty JSON object
  "temperature": 1,
  "top_p": 1
}
```

JSON output after (pointer to struct):

```json
// response_format is omitted
{
  "messages": [...],
  "model": "llama3-8b-8192",
  "max_tokens": 1024,
  "temperature": 1,
  "top_p": 1
}
```

Now, the `response_format` is completely omitted when not needed and the likely validation error from the backend isn't triggered. How?

By making `ResponseFormat` a pointer to a struct, its zero value becomes nil instead of an empty struct. Now, the `omitempty` correctly omits the field when unset and the 400 client error disappears!

## Takeaway

This solution gives us precise control: explicitly initialize the pointer to include `response_format`, leave it `nil` to omit it.

```go
// requestBody with included ResponseFormat field
body := requestBody{
    Messages:    filterMessages(messages),
    Model:       "llama3-8b-8192",
    Temperature: 1,
    MaxTokens:   1024,
    TopP:        1,
    Stream:      false,
    Stop:        nil,
    ResponseFormat: &ResponseFormat{
        Type: "json", // explicitly set the response format type
                      // response_format is included in the JSON output
                      // with the type field populated as specified
    }
}

```

This bug hunt reminded me of how a seemingly insignificant implementation detail can suddenly matter when an API evolves and its validation logic changes.

I've created an issue on the groq-go repo and [submitted a PR](https://github.com/hasitpbhatt/groq-go/pull/4) to fix it. In the meantime, remember this: for truly optional JSON fields in Go, pointers are the way to go. They ensure empty values are completely omitted rather than showing up as empty objects that might trigger validation errors when you least expect it.

[^1]: [AutoCommit](https://github.com/christian-gama/autocommit)

[^2]: [`git diff`](https://git-scm.com/docs/git-diff)

[^3]: [Groq](https://console.groq.com)

[^4]: [SDK](https://en.wikipedia.org/wiki/Software_development_kit)

[^5]: [groq-go](https://github.com/hasitpbhatt/groq-go)

[^6]: [nvim-dap](https://github.com/mfussenegger/nvim-dap)

[^7]: [`json.Marshal`](https://pkg.go.dev/encoding/json#Marshal)

[^8]: [embedded struct](https://gobyexample.com/struct-embedding)

[^9]: marshaller: a component that converts a data structure (like struct) into another format (like JSON) suitable for transmission or storage.
