#!/usr/bin/env bash
set -euo pipefail

DOTFILES="$HOME/tima-dotfiles" # your dotfiles repo location
CONFIGS=(tmux ghostty yabai btop)   # add more as needed
HOMEFILES=(".zshrc" ".p10k.zsh")

mkdir -p "$DOTFILES"
mkdir -p "$DOTFILES"/.config  # in case you want to store config subfolders

echo "🔄 Migrating dotfiles to $DOTFILES..."

# Copy configs from ~/.config/<name> to $DOTFILES/<name>
for config in "${CONFIGS[@]}"; do
  src="$HOME/.config/$config"
  dst="$DOTFILES/$config"
  if [[ -d "$src" ]]; then
    echo "📁 Syncing $src -> $dst (excluding .git)..."
    mkdir -p "$dst"
    rsync -av --delete --exclude='.git' --exclude='.git*' "$src/" "$dst/"
  else
    echo "⚠️  Skipping $src (not present)"
  fi
done

# Copy home dotfiles into repo, but avoid copying a symlink that points to the repo (to prevent clobbering)
for file in "${HOMEFILES[@]}"; do
  src="$HOME/$file"
  dst="$DOTFILES/$file"

  if [[ -L "$src" ]]; then
    # It's a symlink. If it already points to our repo, skip copying.
    target="$(readlink "$src")"
    if [[ "$target" = "$dst" || "$target" = "$DOTFILES/"* ]]; then
      echo "🔗 $src is already a symlink to repo ($target) — skipping copy."
      continue
    else
      echo "🔗 $src is a symlink to $target (outside repo). Will copy its target file."
      # fall through to copy the referent
    fi
  fi

  if [[ -e "$src" ]]; then
    echo "📄 Copying $src -> $dst"
    mkdir -p "$(dirname "$dst")"
    # If src is a symlink to something outside repo, we want the real file contents:
    if [[ -L "$src" ]]; then
      # copy dereferenced file contents
      rsync -avL "$src" "$dst"
    else
      rsync -av "$src" "$dst"
    fi
  else
    echo "⚠️  $src not found; skipping."
  fi
done

# Create symlinks (only when needed)
echo "🔗 Creating symlinks..."
# configs
for config in "${CONFIGS[@]}"; do
  target="$DOTFILES/$config"
  link="$HOME/.config/$config"

  if [[ -L "$link" ]]; then
    # if already a symlink to correct target, skip
    if [[ "$(readlink "$link")" = "$target" ]]; then
      echo "✅ $link already symlinked -> $target"
      continue
    else
      echo "ℹ️  $link is a symlink to a different target; replacing."
      rm -f "$link"
    fi
  elif [[ -e "$link" ]]; then
    echo "ℹ️  $link exists and is not a symlink; removing to create symlink."
    rm -rf "$link"
  fi

  ln -s "$target" "$link"
  echo "✅ $link -> $target"
done

# home files
for file in "${HOMEFILES[@]}"; do
  target="$DOTFILES/$file"
  link="$HOME/$file"

  if [[ -L "$link" ]]; then
    if [[ "$(readlink "$link")" = "$target" ]]; then
      echo "✅ $link already symlinked -> $target"
      continue
    else
      echo "ℹ️  $link is a symlink to a different target; replacing."
      rm -f "$link"
    fi
  elif [[ -e "$link" ]]; then
    echo "ℹ️  $link exists and is not a symlink; removing to create symlink."
    rm -f "$link"
  fi

  if [[ -e "$target" ]]; then
    ln -s "$target" "$link"
    echo "✅ $link -> $target"
  else
    echo "⚠️  $target does not exist in repo; skipping symlink for $file"
  fi
done

echo "🎉 Done!"
