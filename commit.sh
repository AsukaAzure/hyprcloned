#!/bin/bash

cd ~/hyprclone || exit 1

echo "Staging changes.."
git add .

echo "Enter commit message:"
read -r msg

if [ -z "$msg" ]; then
  msg="Updated dotfiles on $(date)"
fi

echo "Committing..."
git commit -m "$msg"

echo "Pushing to Github..."
git push

echo "Done :)"
notify-send "Git Commit" "Uploaded!!"
