---
date: "2025-05-27T19:29:25+01:00"
draft: true
title: "Linux Shell Tricks To Speed Up Your Workflow"
author: "Abdulmumin"
tags: ["linux"]
---

As good engineers, we obsess over speed.

But we ignore the slowest part of the workflow — us!

Most of us rely heavily on the terminal. We navigate directories, manipulate files and run various commands all day trying to get our work done. Being a text-based environment, terminal operations sometimes means lengthy commands with complex arguments. This slows us down more than we care to admit.

There are tricks (with a bit of learning curve) that we can incorporate that speed up our interactions on the command line. You may argue that plugins such as Oh My Zsh or fish shell features make navigation and autocomplete easier. But these tricks are baked into bash itself, meaning that they work everywhere. They will work on your lightweight servers, Docker containers and any other system where you don't have access to your preferred setup. Plus they're reliable and fast.

Here are 11 Linux shell tricks that you probably don't know and will change how you work in the terminal.

## 1. Rerun your last command

Type `!!` and hit enter. Bash returns the last command you ran. This is especially useful if the command is a long one and don't have the typing speed of ThePrimeagen.

```bash
npm install -g npm
# Permission denied
sudo !!
# Runs sudo npm install -g npm
```

## 2. Find and execute your previous commands (more specific)

```bash
!<command>
# where <command> is the command you are intetested in
```

This searches your history bacwards and executes the first match of the specific command. Super handy when you ran that complex docker command 20 minutes ago and can't remember the flags or outrightly want to avoid typing it all out again.

```bash
!docker
# runs your last docker command
!cd
# runs your last cd command
```

## 3. Reuse the last command's arguments

```bash
<command> !$
```

The `!s` grabs the last argument of your last command. This is super useful with long-winded file paths:

```bash
touch /long/path/to/file.sh
# create the file...now wants to check its permissions
ls -la !$
# runs ls -la /long/path/to/file.sh
# or to directly change permissions after file creation:
chmod u+x !$
# runs chmod u+x /long/path/to/file.sh to make it an executable

```

## 4. Reference specific argument from your last command

```bash
<command> !:<argument_index>
```

You want to be more specific now. You want the second argument from your last command.

```bash
mv dir/file1.md dir/file2.md
# rename file1.md to file2.md
# now you want ot pretty print the renamed file. You can run
bat !:2
# runs bat (better cat) on dir/file2.md
```

This works because the argument index of `dir/file2.md` is 2. If you were to run

```bash
bat !:1
# [bat error]: 'kdjd': No such file or directory (os error 2)
```

after the rename command, you would get an error as shown because the `dir/file1.md` does not exist anymore.
