# bash-powerline

Powerline for Bash in pure Bash script.

![bash-powerline](http://raw.github.com/traviskn/bash-powerline/master/screenshots/default.png)
![bash-powerline](http://raw.github.com/traviskn/bash-powerline/master/screenshots/patched.png)

## Features

* Git branch: display current git branch name, or short SHA1 hash when the head
  is detached
* Git branch: display "+" symbol when current branch is changed but uncommited
* Git branch: display "⇡" symbol and the difference in the number of commits when the current branch is ahead of remote (see screenshot)
* Git branch: display "⇣" symbol and the difference in the number of commits when the current branch is behind of remote (see screenshot)
* Python virtualenv: display current virtual environment
* Platform-dependent prompt symbol for OS X and Linux (see screenshots)
* Color code for the previously failed command
* Fast execution (no noticable delay)
* Default settings do not require patched fonts
* Optional support for powerline [patched fonts](https://github.com/powerline/fonts)
  (export USE_POWERLINE_FONTS=1 in .bashrc to enable patched fonts)
* Shortened path if current working path is too deep and too long


## Installation

Download the Bash script

    curl https://raw.githubusercontent.com/traviskn/bash-powerline/master/bash-powerline.sh > ~/.bash-powerline.sh

And source it in your `.bashrc`

    source ~/.bash-powerline.sh

For best results, use [Base16
colorscheme](http://chriskempson.github.io/base16/) with your terminal
emulator. Or hack your own colorscheme by modifying the script. It's really
easy.

Note: This script uses features available only in bash versions 4.2 or greater.

## Why?

This script is largely inspired by
[powerline-shell](https://github.com/milkbikis/powerline-shell). The biggest
problem is that it is implemented in Python. Python scripts are much easier to
write and maintain than Bash scripts, however, invoking the Python interpreter
each time to draw the shell prompt introduces a noticable delay. I hate delays.
So I decided to port just the functionalities I need to pure Bash script instead.

## See also
* [powerline](https://github.com/Lokaltog/powerline): Unified Powerline
  written in Python. This is the future of all Powerline derivatives. 
* [vim-airline](https://github.com/vim-airline/vim-airline): Powerline-style status line
  for Vim written in pure Vimscript.
* [tmux-powerline](https://github.com/erikw/tmux-powerline): Powerline for Tmux
  written in Bash script. Deprecated.
* [emacs powerline](https://github.com/milkypostman/powerline): Powerline for
  Emacs
