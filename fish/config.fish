if status is-interactive
    # Commands to run in interactive sessions can go here
end

starship init fish | source

set fish_greeting

### EXPORT ###
set -x EDITOR nano 
set -x VISUAL nano
set -x HISTCONTROL ignoreboth:erasedups
set -x PAGER most
set -x BROWSER brave

function ex
    switch $argv[1]
      case '*.tar.bz2'
        tar xjf $argv[1]
      case '*.tar.gz'
        tar xzf $argv[1]
      case '*.bz2'
        bunzip2 $argv[1]
      case '*.rar'
        unrar x $argv[1]
      case '*.gz'
        gunzip $argv[1]
      case '*.tar'
        tar xf $argv[1]
      case '*.tbz2'
        tar xjf $argv[1]
      case '*.tgz'
        tar xzf $argv[1]
      case '*.zip'
        unzip $argv[1]
      case '*.Z'
        uncompress $argv[1]
      case '*.7z'
        7z x $argv[1]
      case '*.deb'
        ar x $argv[1]
      case '*.tar.xz'
        tar xf $argv[1]
      case '*.tar.zst'
        tar xf $argv[1]
      case '*'
        echo "'$argv[1]' cannot be extracted via ex()"
    end
end

alias rotate-right="mogrify -rotate -90"

alias rotate-left="mogrify -rotate 90"

#clean up dependencies
alias clean-dependencies="pacman -Qstq | sudo pacman -Rs -"

#grub update
alias update-grub="sudo grub-mkconfig -o /boot/grub/grub.cfg"

#add new fonts
alias update-fc='sudo fc-cache -fv'

#check vulnerabilities microcode
alias microcode='grep . /sys/devices/system/cpu/vulnerabilities/*'

#get fastest mirrors in your neighborhood
alias mirror="sudo reflector -f 30 -l 30 --number 10 --verbose --save /etc/pacman.d/mirrorlist"

#fixes
alias fix-permissions="sudo chown -R $USER:$USER ~/.config ~/.local"
alias fix-keys="/usr/local/bin/arcolinux-fix-pacman-databases-and-keys"
alias fix-pacman-conf="/usr/local/bin/arcolinux-fix-pacman-conf"
alias fix-pacman-keyserver="/usr/local/bin/arcolinux-fix-pacman-gpg-conf"


alias vim="nvim"
alias cat="bat"
alias update="sudo pacman -Syu"
alias ls="exa"
alias icat="kitty +kitten icat"
# alias cd="z"
# zoxide init fish | source
