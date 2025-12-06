# timakaa's version of .dotfiles. Mostly oriented for MacOs

>
> All the setups for MacOs will require hobrew to be installed
>

#### How to install homebrew

```
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

### .oh-my-zsh

#### Install all the necessary for setup plugins

>
> Ruby needs to be installed as well
>

##### On Linux

```
sudo apt install ruby rubygems ruby-dev
```

##### On MacOS

```
brew install ruby
```

#### Plugins

```
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes/powerlevel10k
gem install colorls
```


### tmux

#### Installation

##### On MacOS

```
brew install tmux
```

##### On Linux

```
sudo apt install tmux
```


### ghostty

#### Installation

##### On MacOS

```
brew install --cask ghostty
```

##### On Linux

```
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/mkasberg/ghostty-ubuntu/HEAD/install.sh)"
```

### yabai

#### Installation

##### On MacOS

```
brew install yabai
```

##### On Linux

>
> Yabai cannot run on Linux as it is a MacOS-specific tiling window manager that relies on macOS APIs. You should use i3 or something simillar
>
