export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"

# move configs according to XDG Base directory specification
export ZSH=$XDG_CONFIG_HOME/oh-my-zsh
export ZDOTDIR=$XDG_CONFIG_HOME/zsh
export GNUPGHOME="$XDG_DATA_HOME"/gnupg
export VSCODE_EXTENSIONS="${XDG_DATA_HOME:-~/.local/share}/vscode/extensions"
export VIM=$HOME/.config/vim/
export MYVIMRC=$VIM/vimrc
export VIMRUNTIME=/usr/share/vim/vim81
export _Z_DATA=$XDG_DATA_HOME/z  # moves z scripts datafile

export TERM="alacritty"
export TERMINAL="alacritty"
export EDITOR='nvim'
export READER="zathura"
export FILE="ranger"
export BROWSER="firefox"

# locale settings
export LANG=en_US.UTF-8	
export LANGUAGE=en_US:en
export LC_MONETARY=de_DE.UTF-8
export LC_TIME=de_DE.UTF-8
export LC_NUMERIC=de_DE.UTF-8
export LC_ADDRESS=de_DE.UTF-8
export LC_TELEPHONE=de_DE.UTF-8

# disable less history
export LESSHISTFILE="-"

PATH=$PATH:/sbin:/usr/sbin:/usr/local/sbin
PATH=$PATH:$HOME/.local/bin
PATH=$PATH:$GOPATH/bin

