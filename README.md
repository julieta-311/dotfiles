# wllwschrm-vimrc
My .vimrc

1) Pimp up your terminal with https://github.com/ohmybash/oh-my-bash/.
2) Download nerd-fonts and set `OS_THEME="agnoster"` in `.bashrc`.
3) Install NeoVim (pacman), vim-go (`yay vim-go`), tmux (pacman), nerd-tree (`yay nerdtree`).
4) Start tmux on default when opening the terminal by setting the following in `.bashrc`:

```
if command -v tmux &> /dev/null && [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ]; then
  exec tmux
fi
```

5) clone this repo and move `this/repo/*` to `~/.config`.
