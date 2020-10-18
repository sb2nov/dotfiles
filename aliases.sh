# Aliases

alias pj='cd ~/Projects'

# Git
alias gd='git diff HEAD'
alias ga='git add --all'
alias gca='git commit --amend'
alias gac='ga && gca'
alias gc='git commit'
alias gs='git status'
alias gb='git branch'
alias gcm='git checkout master'
alias gp='git pull'
alias gl="git log --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit -10"
alias glg="gl --graph"
alias gps="git push -u origin HEAD"

# Silver Searcher
alias agg='ag --go'
alias agj='ag --js'
alias agp='ag --python'

# Monitoring
alias dtop='dshb'
alias sdu="du -sk -- * | sort -nr | perl -pe '@SI=qw(K M G T P); s:^(\d+?)((\d\d\d)*)\s:\$1.\" \".\$SI[((length \$2)/3)].\"\t\":e'"
