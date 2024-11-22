# PS1="\u(\h:\w)$ "

# for zsh
PROMPT='%n@%m %S%1~%s%(!.#.) %% '

umask 077
alias rm="rm -i"
alias cp="cp -i"
alias relogin="exec $SHELL -l"

# python
alias jn="jupyter notebook"

# for white
export CLICOLOR="xterm-color"
alias ls="ls -F"
alias la="ls -F -a"
alias ll="ls -l"

# for dark mode
#export LSCOLORS=xbfxcxdxbxegedabagacad
#alias ls="ls -F -G"
#alias la="ls -F -a -G"
#alias ll="ls -l -G"

alias pip-all="pip list -o | awk 'NR>2 {print $1}' | xargs pip install -U"

PATH="\
:/sbin\
:/usr/sbin\
:/bin\
:/usr/bin\
:/usr/local/bin\
:/Developer/Tools\
"

# for flutter
if [ -e ~/development/flutter ]; then
  export PATH="$PATH:$HOME/development/flutter/bin"
  export PATH="/usr/local/opt/libxml2/bin:$PATH"
  export LDFLAGS="-L/usr/local/opt/libxml2/lib"
  export CPPFLAGS="-I/usr/local/opt/libxml2/include"
  export PKG_CONFIG_PATH="/usr/local/opt/libxml2/lib/pkgconfig"
fi

# homebrew
if [ -f /opt/homebrew/bin/brew ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"

  # OpenSSL
  # see: https://stackoverflow.com/questions/69012676/install-older-ruby-versions-on-a-m1-macbook
  export RUBY_CONFIGURE_OPTS="--with-openssl-dir=$(brew --prefix openssl@3)"
  export LDFLAGS="-L/opt/homebrew/opt/readline/lib"
  export CPPFLAGS="-I/opt/homebrew/opt/readline/include"
  export PKG_CONFIG_PATH="/opt/homebrew/opt/readline/lib/pkgconfig"
  export optflags="-Wno-error=implicit-function-declaration"
  # export LDFLAGS="-L/opt/homebrew/opt/libffi/lib"
  # export CPPFLAGS="-I/opt/homebrew/opt/libffi/include"
  # export PKG_CONFIG_PATH="/opt/homebrew/opt/libffi/lib/pkgconfig"

fi


# anyenv
if [ -e $HOME/.anyenv ]; then
  eval "$(anyenv init -)"
fi

# android
export ANDROID_HOME=~/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/tools/bin
export PATH=$PATH:$ANDROID_HOME/platform-tools

# for react-native dev
alias ys="yarn start"
alias yi="yarn ios"
alias yi-13="yarn ios --simulator 'iPhone 13'"
alias yi-se="yarn ios --simulator 'iPhone SE'"
alias yi-8="yarn ios --simulator='iPhone 8'"
alias yi-x="yarn ios --simulator 'iPhone X'"
alias yi-ipad="yarn ios --simulator='iPad mini'"
alias ya="yarn android"
alias ypd="yarn pod"
alias pyr='cd ios; rm -rf ./Pods; pod install; cd -; yr'
alias yall="yarn install; yarn upgrade swagger-api; yarn pod; yarn ios --simulator='iPhone 13'"





