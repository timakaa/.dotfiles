#!/bin/bash
set -e  # Exit on any error

DOTFILES="$HOME/tima-dotfiles"
CONFIGS=(nvim tmux ghostty)  # Add more: fish, alacritty, etc.

echo "🔄 Migrating dotfiles to $DOTFILES..."

# Copy configs (skip .git folders)
for config in "${CONFIGS[@]}"; do
  echo "📁 Copying ~/.config/$config..."
  rsync -av --exclude='.git' --exclude='.git*' ~/.config/"$config"/ "$DOTFILES/$config/"
done

# Home dotfiles (e.g., .bashrc, .zshrc)
HOMEFILES=(".bashrc" ".zshrc" ".tmux.conf")  # Customize
for file in "${HOMEFILES[@]}"; do
  if [[ -f "$HOME/$file" ]]; then
    echo "📄 Copying $file..."
    rsync -av "$HOME/$file" "$DOTFILES/"
  fi
done

# Clean install symlinks
echo "🔗 Creating symlinks..."
for config in "${CONFIGS[@]}"; do
  rm -rf ~/.config/"$config"
  ln -s "$DOTFILES/$config" ~/.config/"$config"
  echo "✅ $config symlinked"
done

for file in "${HOMEFILES[@]}"; do
  if [[ -f "$DOTFILES/$file" ]]; then
    rm -f "$HOME/$file"
    ln -s "$DOTFILES/$file" "$HOME/$file"
    echo "✅ $file symlinked"
  fi
done

echo "🎉 Done! Run 'cd $DOTFILES && git add . && git commit -m \"Initial configs\"'"
echo "Plugins: nvim +Lazy sync | tmux (TPM auto-installs)"

