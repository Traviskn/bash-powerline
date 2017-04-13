#!/usr/bin/env bash

__powerline() {

    # Max length of full path
    MAX_PATH_LENGTH=30

    # Unicode symbols
    PS_SYMBOL_DARWIN=''
    PS_SYMBOL_LINUX='$'
    PS_SYMBOL_OTHER='%'
    GIT_BRANCH_SYMBOL='⑂ '
    GIT_BRANCH_CHANGED_SYMBOL='+'
    GIT_NEED_PUSH_SYMBOL='⇡'
    GIT_NEED_PULL_SYMBOL='⇣'

    # Powerline symbols
    GIT_BRANCH_SYMBOL_POWERLINE=' '
    RIGHT_SOLID_ARROW_POWERLINE=''
    LEFT_SOLID_ARROW_POWERLINE=''
    RIGHT_ARROW_POWERLINE=''
    LEFT_ARROW_POWERLINE=''

    # ANSI Colors
    # Background
    BG_BLACK="\[$(tput setab 0)\]"
    BG_RED="\[$(tput setab 1)\]"
    BG_GREEN="\[$(tput setab 2)\]"
    BG_YELLOW="\[$(tput setab 3)\]"
    BG_BLUE="\[$(tput setab 4)\]"
    BG_MAGENTA="\[$(tput setab 5)\]"
    BG_CYAN="\[$(tput setab 6)\]"
    BG_WHITE="\[$(tput setab 7)\]"

    BG_BLACK_BRIGHT="\[$(tput setab 8)\]"
    BG_RED_BRIGHT="\[$(tput setab 9)\]"
    BG_GREEN_BRIGHT="\[$(tput setab 10)\]"
    BG_YELLOW_BRIGHT="\[$(tput setab 11)\]"
    BG_BLUE_BRIGHT="\[$(tput setab 12)\]"
    BG_MAGENTA_BRIGHT="\[$(tput setab 13)\]"
    BG_CYAN_BRIGHT="\[$(tput setab 14)\]"
    BG_WHITE_BRIGHT="\[$(tput setab 15)\]"

    # Foreground
    FG_BLACK="\[$(tput setaf 0)\]"
    FG_RED="\[$(tput setaf 1)\]"
    FG_GREEN="\[$(tput setaf 2)\]"
    FG_YELLOW="\[$(tput setaf 3)\]"
    FG_BLUE="\[$(tput setaf 4)\]"
    FG_MAGENTA="\[$(tput setaf 5)\]"
    FG_CYAN="\[$(tput setaf 6)\]"
    FG_WHITE="\[$(tput setaf 7)\]"

    FG_BLACK_BRIGHT="\[$(tput setaf 8)\]"
    FG_RED_BRIGHT="\[$(tput setaf 9)\]"
    FG_GREEN_BRIGHT="\[$(tput setaf 10)\]"
    FG_YELLOW_BRIGHT="\[$(tput setaf 11)\]"
    FG_BLUE_BRIGHT="\[$(tput setaf 12)\]"
    FG_MAGENTA_BRIGHT="\[$(tput setaf 13)\]"
    FG_CYAN_BRIGHT="\[$(tput setaf 14)\]"
    FG_WHITE_BRIGHT="\[$(tput setaf 15)\]"

    # Other Effects
    DIM="\[$(tput dim)\]"
    REVERSE="\[$(tput rev)\]"
    RESET="\[$(tput sgr0)\]"
    BOLD="\[$(tput bold)\]"

    # Which OS?
    case "$(uname)" in
        Darwin)
            PS_SYMBOL=$PS_SYMBOL_DARWIN
            ;;
        Linux)
            PS_SYMBOL=$PS_SYMBOL_LINUX
            ;;
        *)
            PS_SYMBOL=$PS_SYMBOL_OTHER
    esac

    __black_blue_divider() {
      if [ "x$USE_POWERLINE_FONTS" != "x" ]; then
        printf "$BG_BLACK_BRIGHT$FG_BLUE$RIGHT_SOLID_ARROW_POWERLINE$RESET"
      fi
    }

    __git_info() {
        if [ "x$(which git)" == "x" ]; then
          # git not found
          __black_blue_divider
          return
        fi

        local git_eng="env LANG=C git"   # force git output in English to make our work easier
        # get current branch name or short SHA1 hash for detached head
        local branch="$($git_eng symbolic-ref --short HEAD 2>/dev/null || $git_eng describe --tags --always 2>/dev/null)"

        if [  "x$branch" == "x" ]; then
          # git branch not found
          __black_blue_divider
          return
        fi

        local marks

        # branch is modified?
        [ -n "$($git_eng status --porcelain 2>/dev/null)" ] && marks+=" $GIT_BRANCH_CHANGED_SYMBOL"

        # how many commits local branch is ahead/behind of remote?
        local stat="$($git_eng status --porcelain --branch 2>/dev/null | grep '^##' | grep -o '\[.\+\]$')"
        local aheadN="$(echo $stat | grep -o 'ahead [[:digit:]]\+' | grep -o '[[:digit:]]\+')"
        local behindN="$(echo $stat | grep -o 'behind [[:digit:]]\+' | grep -o '[[:digit:]]\+')"
        [ -n "$aheadN" ] && marks+=" $GIT_NEED_PUSH_SYMBOL$aheadN"
        [ -n "$behindN" ] && marks+=" $GIT_NEED_PULL_SYMBOL$behindN"

        # print the git branch segment without a trailing newline
        if [ "x$USE_POWERLINE_FONTS" != "x" ]; then
          printf "$BG_YELLOW_BRIGHT$FG_BLUE$RIGHT_SOLID_ARROW_POWERLINE$RESET"
          printf "$BG_YELLOW_BRIGHT$FG_WHITE_BRIGHT $GIT_BRANCH_SYMBOL_POWERLINE$branch$marks $RESET"
          printf "$BG_BLACK_BRIGHT$FG_YELLOW_BRIGHT$RIGHT_SOLID_ARROW_POWERLINE$RESET"
        else
          printf " $GIT_BRANCH_SYMBOL$branch$marks "
        fi
    }

    __virtualenv() {
        # Copied from Python virtualenv's activate.sh script.
        # https://github.com/pypa/virtualenv/blob/a9b4e673559a5beb24bac1a8fb81446dd84ec6ed/virtualenv_embedded/activate.sh#L62
        # License: MIT
        if [ "x$VIRTUAL_ENV" != "x" ]; then
            if [ "`basename \"$VIRTUAL_ENV\"`" == "__" ]; then
                # special case for Aspen magic directories
                # see http://www.zetadev.com/software/aspen/
                printf "[`basename \`dirname \"$VIRTUAL_ENV\"\``]"
            else
                printf "(`basename \"$VIRTUAL_ENV\"`)"
            fi
        fi
    }

    __pwd() {
        # Use ~ to represent $HOME prefix
        local pwd=$(pwd | sed -e "s|^$HOME|~|")
        if [[ ( $pwd = ~\/*\/* || $pwd = \/*\/*/* ) && ${#pwd} -gt $MAX_PATH_LENGTH ]]; then
            local IFS='/'
            read -ra split <<< "$pwd"
            if [[ $pwd = ~* ]]; then
                pwd="~/.../${split[-1]}"
            else
                pwd="/${split[1]}/.../${split[-1]}"
            fi
        fi
        printf "$pwd"
    }

    ps1() {
        # Check the exit code of the previous command and display different
        # colors in the prompt accordingly.
        if [ $? -eq 0 ]; then
            local BG_EXIT="$BG_BLUE_BRIGHT"
        else
            local BG_EXIT="$BG_RED"
        fi

        PS1=""

        PS1+="$BOLD$BG_BLUE$FG_WHITE_BRIGHT $(whoami) $RESET"

        PS1+="$BG_BLUE$FG_WHITE_BRIGHT$(__virtualenv)$RESET"

        PS1+="$BG_YELLOW_BRIGHT$FG_WHITE_BRIGHT$(__git_info)$RESET"

        PS1+="$BG_BLACK_BRIGHT$FG_WHITE_BRIGHT $(__pwd) $RESET"

        if [ "x$USE_POWERLINE_FONTS" != "x" ]; then
          PS1+="$FG_BLACK_BRIGHT$RIGHT_SOLID_ARROW_POWERLINE$RESET "
        else
          PS1+="$BG_EXIT$FG_YELLOW_BRIGHT $PS_SYMBOL $RESET "
        fi
    }

    PROMPT_COMMAND=ps1
}

__powerline
unset __powerline
