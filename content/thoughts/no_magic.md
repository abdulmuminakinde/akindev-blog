---
date: "2025-01-24T14:08:50+01:00"
draft: false
title: "There is no magic: Only Abstractions"
author: "Abdulmumin"
---

> _"Magic is just an abstraction you don't understand."_

I came across a post from Preston Thorpe, a brilliant, incarcerated software engineer. He wrote an [article](https://pthorpe92.dev/intro/my-story/) about how he became a professional software engineer from the prison. No, you aren't hallucinating. Prison! Truly inspiring, but I digress.

I then checked out [another of his posts](https://pthorpe92.dev/programming/magic/) titled "Magic isn't real." While this is already beautifully written and packed with lessons and nuggets, it made me reflect on my own journey, and I thought to share.

In my experience learning how to code and solving problems with technology, I have come to realize that "magic" is really just a level of abstraction you haven't uncovered yet. Everything I know and can explain today was once wrapped in this dark shroud of mystery that I thought I would never be able to demystify. However, as I continue to learn and broaden my knowledge scope, things that seemed inaccessible at first suddenly (or eventually) become easy to make sense of. Trust me when I say there are a lot of instances. I am sure it's same for you too.

I remember writing my first fullstack app with Django. Anybody remotely familiar with this framework knows it's batteries-included and very opinionated. This means that you trade ultimate customizability for a relatively fast development experience. It however comes at a cost, especially if you're a beginner who wants to know how things work under the hood.

Django abstracts away a lot of implementation details and provides extensive boilerplate code needed in spinning up a robust server. As a result, beginners might find it tricky to immediately understand important server-side concepts like session management, middleware, among others.

I definitely didn't at the time. Middlewares especially felt "magical." In Django, you just define a class, implement some methods and Django does all the "heavy-middleware-lifting" for you behind the scenes. In fact, now that I think about it, this was supposed to be the "beginner-friendly" way to introduce the concept of middleware. But I did not get it. And I like to get things, so you can imagine my dissatisfaction.

At the time, I attempted to learn what middlewares were, but I ended up only having a surface-level knowledge of the concept. I just knew it was some logic that runs before your main (business) logic. Because I did not have to explicitly implement it on my own, I could not really appreciate it on a deep level like I desired.

Not until I started writing Go. You see, Go offers a more low-level approach when it comes to server-side development. You have more granular control of how things should be implemented compared to Django. This is also thanks to Go's powerful standard (http) library. But again, like everything in tech and system design, there is always a tradeoff. In this case, you enjoy flexibility at the expense of complexity, which may impact development experience and timeline. Things are a bit more low-level in Go compared to Django.

While writing Go, I was forced to think about how I would manage issues like session management and middleware chaining without the heavy abstractions. Only then did it really start to make sense. Now understand that this is a very simplistic example, but I really thought only superstar devs could write up middleware and bootstrap it in a framework like Django so that regular devs don't have to bother understanding it. This experience is also personal, and I don't imply that everybody learning Django would not be able to understand what middlewares are at a deeper level. It just happened that I needed to go a bit more low-level to really get it. Seeing how the request flow got modified was beneficial to my understanding.

Some people argue that you don't necessarily need to get into the weeds of how things work under the hood. I strongly disagree. Experienced developers thrive on their ability to understand technological layers below their current working level. You might ask, "Why does this level of understanding matter?"

Take networking, for instance. If you are working with HTTP, do you know how and why it works? Do you know what TCP is and how it helps http? And if you understand TCP, do you understand why and how TCP is built on IP? I can go on. Again, I think this is important because sometimes abstractions leak. If you don't understand the abstracted technology, you will have a hard time debugging issues that will inevitably come up. The deeper you can go into these bottom layers, the better troubleshooter/developer you will be.

Which brings me to a beautiful line in Preston Thorpe's post:

> _"This is just a reminder to everyone at different levels of their developer journey, that the “magic” is not real and the overwhelming majority of the time, you are simply lacking the necessary context and it will likely make perfect sense to you as soon as you have it."_

I thought the line just sums it up.

Takeaway? Understand that the "magical" concept you are currently struggling with is not inaccessible to you. You just haven't gotten what it takes to make sense of it yet. And you will. Sometimes you have to peel back the layers one at a time. Other times, you need to step back for the big picture. Just keep looking. I promise the epiphany is always worth it.

![Difficult roads lead to beautiful destinations](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/nrfy1993x0onflzxid06.jpg)

Remember, the greatest developers are the most curious ones. So, what’s your “magic”? What’s a concept that felt incomprehensible until you peeled back its layers or gathered more context? I’d love to hear your story.
