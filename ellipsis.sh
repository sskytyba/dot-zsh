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
	chsh -u $USER -s `which zsh`
}

##############################################################################

pkg.unlink() {
    # Unlink
    rm $ELLIPSIS_HOME/.zshrc
    rm $ELLIPSIS_HOME/.zlogin
}

##############################################################################

osx() {
	brew install zsh
	brew install fortune
	sudo gem install lolcat
	brew install peco
}

##############################################################################

linux() {
	sudo apt-get install zsh
}

##############################################################################
