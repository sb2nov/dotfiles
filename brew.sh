#!/usr/bin/env bash

# Install command-line tools using Homebrew.

# Make sure we’re using the latest Homebrew.
brew update

# Upgrade any already-installed formulae.
brew upgrade

# Save Homebrew’s installed location.
BREW_PREFIX=$(brew --prefix)

# Install GNU core utilities (those that come with macOS are outdated).
# Don’t forget to add `$(brew --prefix coreutils)/libexec/gnubin` to `$PATH`.
brew install coreutils
ln -s "${BREW_PREFIX}/bin/gsha256sum" "${BREW_PREFIX}/bin/sha256sum"

# Install some other useful utilities like `sponge`.
brew install moreutils
# Install GNU `find`, `locate`, `updatedb`, and `xargs`, `g`-prefixed.
brew install findutils
# Install GNU `sed`
brew install gnu-sed 
# Install a modern version of Bash.
brew install bash
brew install bash-completion2

# Switch to using brew-installed bash as default shell
if ! fgrep -q "${BREW_PREFIX}/bin/bash" /etc/shells; then
  echo "${BREW_PREFIX}/bin/bash" | sudo tee -a /etc/shells;
  chsh -s "${BREW_PREFIX}/bin/bash";
fi;

# Install `wget` with IRI support.
brew install wget --with-iri

# Install other useful binaries.
brew install git
brew install git-lfs
brew install tree

# Remove outdated versions from the cellar.
brew cleanup

# Install more recent versions of some macOS tools.
brew install vim --with-override-system-vi
brew install grep

# Basic Functionality
brew cask install rectangle
brew cask install authy
brew cask install vienna
brew cask install brave-browser
brew cask install flux
brew cask install lunar
brew cask install alfred
brew cask install appcleaner
brew cask install github

# Programming
brew cask install iterm2
brew cask install sublime-text
brew cask install docker
brew cask install visual-studio-code
brew cask install jupyter-notebook-viewer
brew cask install dshb

# Work
brew cask install slack
brew cask install typora
brew cask install zoomus

# Paid apps
brew cask install cisdem-pdftoolkit
