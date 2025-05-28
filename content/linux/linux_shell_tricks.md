---
date: "2025-05-27T19:29:25+01:00"
draft: false
title: "Linux Shell Tricks To Speed Up Your Workflow"
author: "Abdulmumin"
tags: ["linux", "productivity"]
cover:
  image: "https://assets.akindev.xyz/static/images/linux_cover.png"
  alt: "Linux shell picture"
  hidden: false
  hiddenInList: true
  hiddenInSingle: false
---

As engineers, we obsess over speed (code and machine). Yet the slowest part of our workflow is often... us.

We live in the terminal, navigating directories, manipulating files and running various commands trying to get work done. Being a text-based environment, terminal operations sometimes can slow us to a crawl with long commands and typos.

There are tricks (with a bit of a learning curve) that we can incorporate that speed up our interactions on the command line. You may argue that plugins such as Oh My Zsh or fish shell features make navigation and autocomplete easier. But these tricks are baked into bash itself, meaning that they work everywhere. They will work on your lightweight servers, Docker containers and any other system where you don't have access to your preferred setup. Plus they're reliable and fast.

Here are 11 Linux shell tricks that you probably don't know and will change how you work in the terminal.

## History Navigation Tricks

### 1. Rerun your last command

Type `!!` and hit enter. Bash returns the last command you ran. This is especially useful if the command is a long one and don't have the typing speed of ThePrimeagen.

```sh
npm install -g npm
# Permission denied
sudo !!
# Runs sudo npm install -g npm
```

### 2. Find and execute your previous commands (more specific)

```sh
!<command>
# where <command> is the command you are interested in
```

This searches your history backwards and executes the first match of the specific command. Super handy when you ran that complex docker command 20 minutes ago and can't remember the flags or outrightly want to avoid typing it all out again.

```sh
!docker
# runs your last docker command
!cd
# runs your last cd command
```

## Argument Tricks

### 3. Reuse the last command's arguments

```sh
<command> !$
```

The `!$` grabs the last argument of your last command. This is super useful with long-winded file paths:

```sh
touch /long/path/to/file.sh
# create the file...now wants to check its permissions
ls -la !$
# runs ls -la /long/path/to/file.sh
# or to directly change permissions after file creation:
chmod u+x !$
# runs chmod u+x /long/path/to/file.sh to make it an executable

```

### 4. Reference specific argument from your last command

```sh
<command> !:<argument_index>
```

You want to be more specific now. You want the second argument from your last command.

```sh
mv dir/file1.md dir/file2.md
# rename file1.md to file2.md
# now you want to pretty print the renamed file. You can run
bat !:2
# runs bat (better cat) on dir/file2.md
```

This works because the argument index of `dir/file2.md` is 2. If you were to run

```sh
bat !:1
# [bat error]: 'kdjd': No such file or directory (os error 2)
```

after the rename command, you would get an error as shown because the `dir/file1.md` does not exist anymore.

### 5. Reference an argument from the current command

```sh
!#:<argument_index>
```

If you find that you're trying to manipulate a long path in an i/o operation, you can grab the input argument from the current command.

```sh
# command to convert a jpg file to a png file
magick a/very/long/path/to/file.jpg -resize 200x200 !:#1
```

Hitting `tab` expands the command like so:

```sh
magick a/very/long/path/to/file.jpg -resize 200x200 a/very/long/path/to/file.jpg
# you can then edit the suffix to whatever you want and hit enter to run the command
```

I love this because you don't have to always manually deal with long filenames/paths. I avoid typos and save time.

## Find and Replace Trick

### 6. Quick and dirty find and replace

```sh
^<old_command>^<replacement>
```

If you made a typo in a long command, you don't have to retype the whole thing. You can use this trick to replace the typo with the correct command.

```sh
cur https://localhost:8000
# Error: `cur` not found
^cur^curl
# runs curl https://localhost:8000
```

Another nice way to use this trick is when you want to change a file extension in a command.

```sh
# to extract a compressed file to current directory
tar -xvf long/path/to/file.zip
# error: file is a .tar.gz file
^.zip^.tar.gz
# runs tar -xvf long/path/to/file.tar.gz
```

I have used this to swap variables in a command.

```sh
# to run a docker container with the development compose file
docker compose up --build -f docker-compose.dev.yml
# to run the production compose file, I can run
^dev^prod
```

This works if I have a file called `docker-compose.dev.yml` and a file called `docker-compose.prod.yml`. I don't have to type the whole command and can just swap the variables as shown.

## Navigation Tricks

### 7. JUmp to your home directory from anywhere

```sh
cd ~
```

This one is a classic and I assume you've seen it somewhere. I thought it still deserved a spot on our list. You can always find your way home from anywhere no matter how deep you are in the nested filepath.

### 8. Jump back to your previous directory

```sh
cd -
```

This one you probably don't know. Imagine you want to go back to the directory where you jumped home from, this command takes you back there without having to worry about the exact path. Even better, you can use this trick to jump between your current directory and wherever you just came from.

```sh
cd ~
# jump to your home directory from anywhere
cd /etc/nginx/sites-available
# jump here edit some config
cd /var/log/nginx
# check the logs
cd -
# back to /etc/nginx/sites-available
```

## File Sytem Manipulation Tricks

### 9. Create Nested Directories at a go

If you wanted to create nested directories, say three levels deep, you probably do something like this:

```sh
mkdir dir1
mkdir dir1/dir2
mkdir dir1/dir2/dir3
```

The above works quite alright but it's verbose. There is a more efficient and time-saving way.

```sh
mkdir -p dir1/dir2/dir3
```

This command creates the directories and their parents if needed. Without the flag, the command fails if a parent directory doesn't exist.

```sh
# if dir2 does not exist
mkdir dir1/dir2/dir3
# mkdir: dir/dir2: No such file or directory
mkdir -p dir1/dir2/dir3
# runs successfully
# mkdir creates dir2 and dir3 as needed
```

### 10. Run a command within a command

You can run commands inside other commands with `$(command)`. For example

```sh
echo "Today is $(date)"
```

The `date` command is executed and the output is inserted into the `echo` command.

This trick is useful if you want to capture the output of a command and use it as an argument, variable or part of another command. It is called command substitution. This allows for a fairly powerful automation and dynamic scripting.

```sh
grep "error" $(find /var/log -name "*.log")
# search for errors in all log files
```

In the above example, `find` id executed first and the output is inserted into the `grep` command as an argument. If `find` returns multiple files `grep` processes them all and we don't have to manually list.

## Essential (Default) Keyboard Shortcuts

### 11. Essential keyboard shortcuts

If you've not remapped into custom keybindings, here are some useful shortcuts and what they do.

- `Ctrl + A` - Move to the beginning of the line
- `Ctrl + C` - Cancel current command or process and go to a fresh prompt
- `Ctrl + D` - Exit the current shell
- `Ctrl + E` - Move to the end of the line
- `Ctrl + K` - Delete everythng after cursor
- `Ctrl + L` or `clear` - Clear terminal screen
- `Ctrl + R` - Search history
- `Ctrl + U` - Delete everything before cursor
- `Ctrl + W` - Delete word before cursor

Again, if you are like me and you use a terminal multiplexer such as tmux, you might have remapped some of these shortcuts and they may not work as expected. In my case, `Ctrl + K` and `Ctrl + L` have been remapped to move between tmux windows and panes.

## Conclusion

Some of the above tricks require some practice to get comfortable with them. But they are simple and become muscle memory once you start using them. Hopefully, a couple of these tricks help you speed up your daily operations in the shell.
