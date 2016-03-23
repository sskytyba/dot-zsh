#!/usr/bin/env bash

pkg.link() {
    # Link zshrc
    fs.link_file zshrc
    # Link zlogin
    fs.link_file zlogin
}

##############################################################################

pkg.install() {
    case $(os.platform) in
		osx)
			osx
			;;
		linux)
			linux
			;;
	esac
	if zsh_loc="$(type -p /usr/local/bin/zsh)" && [ -z "$zsh_loc" ]; then
  	chsh -u $USER -s `/usr/local/bin/zsh`
	else
		chsh -u $USER -s `which zsh`
	fi
}

##############################################################################

pkg.unlink() {
    # Unlink
    rm $ELLIPSIS_HOME/.zshrc
    rm $ELLIPSIS_HOME/.zlogin
}

##############################################################################

osx() {
	if ! zsh_loc="$(type -p zsh)" || [ -z "$zsh_loc" ]; then
  	brew install zsh
	fi
	if ! fortune_loc="$(type -p fortune)" || [ -z "$fortune_loc" ]; then
  	brew install fortune
	fi
	if ! peco_loc="$(type -p peco)" || [ -z "$peco_loc" ]; then
  	brew install peco
	fi
	if ! lolcat_loc="$(type -p lolcat)" || [ -z "$lolcat_loc" ]; then
  	sudo gem install lolcat
	fi
}

##############################################################################

linux() {
	sudo apt-get install zsh
}

##############################################################################
