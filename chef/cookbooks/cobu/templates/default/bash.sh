PS1="\u@\h:\W\$ "

alias rv='ruby -v'
alias q='exit'
alias lsa='ls -la'
alias ll='ls -l'

alias tl='tail -f log/*.log'
alias sb='source ~/.bash_aliases'
alias ee='nano ~/.bash_aliases && sb'
alias le='cd /var/www/localeyes/current'

alias rails='bundle exec rails'
alias rake='bundle exec rake'

function pa {
  ps aux | grep $1
}

export RAILS_ENV=<%= @rails_env %>


