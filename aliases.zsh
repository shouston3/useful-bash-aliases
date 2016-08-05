alias desk='cd ~/Desktop && ls'
alias proj='cd ~/proj && ls'
alias zrc='vim ~/.zshrc'
alias vrc='vim ~/.vimrc'
alias erc='vim ~/.eslintrc'
alias nbrk='node --debug-brk'
alias ni='node-inspector --no-preload'
alias cl='clear'
alias m='vim'
alias colours='spectrum_ls'
alias st='open -a SourceTree .'
alias za='vim ~/.my-zsh/aliases.zsh'
alias zga='vim ~/.my-zsh/git-aliases.zsh'
alias n='npm run'
alias lll='ls' # for typing ls with one hand
alias pg='postgres -D /usr/local/var/postgres'
alias ss='echo "sourcing zshrc"; source ~/.zshrc'

# Numbered case insensitive recursive search in current dir
grepe() {
  grep -ri $1 . --exclude-dir={node_modules,production,coverage,.git,build,.sass-cache} |
  awk '{print NR, $0}'
}

# Open file n from the grepe output
vo() {
  history |
  tail -n -20 |
  grep grepe |
  tail -n -1 |
  awk '{print substr($0, index($0, $3))}' | # take the grepe argument from history
  xargs -J % grep -ri % . --exclude-dir={node_modules,production,coverage,.git,build,.sass-cache} |
  head -n $1 |
  tail -n -1 |
  awk -F':' '{print $1}' | # only include text until :
  xargs -o vim # need -o xargs to run interative application (see man xargs for more info)
}

# ---- grepe sequence
# Sequence may be as follows:
# I want to find instances of stringToFind in my current directory, so I run:
# $ grepe stringToFind
# 1. ./dir/index.js: const stringToFind = 3;
# 2. ./otherDir/script.js: let func = stringToFind
# 
# I want to open the second directory, so I run
# $ vo 2
# (Short for vim open 2)
# I open a vim buffer of ./otherDir/script.js
# ---- grepe sequence

# To check if you mind something being deleted from history
# run: grep "0;foo" ~/.zsh_history to see the instances which will be deleted

# Trims .zsh_history of some junk
# Removes duplicates and simple commands you probably don't want in history
th() {
  echo 'trimming history...'
  grep -v "0;ls$" ~/.zsh_history | # all excluding lines which end in "ls"
  grep -v "0;ll$" | 
  grep -v "0;lll$" |
  grep -v "0;lsa$" |
  grep -v "0;ls " | # all excluding lines witch include "ls "
  grep -v "0;cd$" |
  grep -v "0;cd " |
  grep -v "0;ls" |
  grep -v "0;m " |
  grep -v "0;vim " |
  grep -v "0;za$" |
  grep -v "0;gst$" |
  grep -v "0;gaa" |
  grep -v "0;ggpush" |
  grep -v "0;history" |
  grep -v "0;h$" |
  grep -v "0;h " |
  grep -v "0;\.\." |
  tail -r | # reversing order of history
  awk -F';' '!seen[$2]++' | # removing duplicates after ;
  tail -r > ~/.zsh_history.new # reversing and redirecting into new zsh_history
  rm ~/.zsh_history
  mv ~/.zsh_history.new ~/.zsh_history
  echo 'trimmed history'
}
