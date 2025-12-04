#!/bin/bash
set -e  # Exit on any error

DOTFILES="$HOME/tima-dotfiles"
CONFIGS=(".config/nvim" ".config/tmux" ".config/ghostty" ".config/yabai" ".oh-my-zsh")  # Add more: fish, alacritty, etc.
# Home dotfiles (e.g., .bashrc, .zshrc)
HOMEFILES=(".zshrc", ".p10k.zsh")  # Customize

echo "🔄 Migrating dotfiles to $DOTFILES..."

# Copy configs (skip .git folders)
for config in "${CONFIGS[@]}"; do
  echo "📁 Copying ~/$config..."
  rsync -av --exclude='.git' --exclude='.git*' ~/"$config"/ "$DOTFILES/$config/"
done

for file in "${HOMEFILES[@]}"; do
  if [[ -f "$HOME/$file" ]]; then
    echo "📄 Copying $file..."
    rsync -av "$HOME/$file" "$DOTFILES/"
  fi
done

# Clean install symlinks
echo "🔗 Creating symlinks..."
for config in "${CONFIGS[@]}"; do
  rm -rf ~/"$config"
  ln -s "$DOTFILES/$config" ~/"$config"
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

