#!/usr/bin/env bash

echo "Copying git config..."
rm -f ~/.gitconfig
cp ~/dotfiles/git/gitconfig ~/.gitconfig

# Configure git username and email.
echo "Enter your git username"
read username

echo "Enter your git email"
read email

git config --global user.name "$username"
git config --global user.email "$email"
