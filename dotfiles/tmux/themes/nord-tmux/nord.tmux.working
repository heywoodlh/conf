#!/run/current-system/sw/bin/bash
# Copyright (C) 2017-present Arctic Ice Studio <development@arcticicestudio.com>
# Copyright (C) 2017-present Sven Greb <development@svengreb.de>

# Project:    Nord tmux
# Repository: https://github.com/arcticicestudio/nord-tmux
# License:    MIT
# References:
#   https://tmux.github.io

PATH='/home/linuxbrew/.linuxbrew/bin:/home/heywoodlh/.linuxbrew/bin:/nix/store/j91k0q9k1cfq0qi8729jcpf2fj98qpb8-powershell-7.2.3/share/powershell:/nix/store/sva0533vjj46m6h962g8as87mvrmxmlq-kitty-0.25.2/bin:/nix/store/9sf6rl55yqxbdscgrjqa9nppprwwykmx-imagemagick-7.1.0-48/bin:/nix/store/9l2pdqd2cs9hqyk53w543lpnp0vqaysd-ncurses-6.3-p20220507-dev/bin:/run/wrappers/bin:/home/heywoodlh/.nix-profile/bin:/etc/profiles/per-user/heywoodlh/bin:/nix/var/nix/profiles/default/bin:/run/current-system/sw/bin:/home/heywoodlh/.nix-profile/bin:/etc/profiles/per-user/heywoodlh/bin:/nix/var/nix/profiles/default/bin:/run/current-system/sw/bin'

NORD_TMUX_COLOR_THEME_FILE=src/nord.conf
NORD_TMUX_VERSION=0.3.0
NORD_TMUX_STATUS_CONTENT_FILE="src/nord-status-content.conf"
NORD_TMUX_STATUS_CONTENT_NO_PATCHED_FONT_FILE="src/nord-status-content-no-patched-font.conf"
NORD_TMUX_STATUS_CONTENT_OPTION="@nord_tmux_show_status_content"
NORD_TMUX_NO_PATCHED_FONT_OPTION="@nord_tmux_no_patched_font"
_current_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

__cleanup() {
  unset -v NORD_TMUX_COLOR_THEME_FILE NORD_TMUX_VERSION
  unset -v NORD_TMUX_STATUS_CONTENT_FILE NORD_TMUX_STATUS_CONTENT_NO_PATCHED_FONT_FILE
  unset -v NORD_TMUX_STATUS_CONTENT_OPTION NORD_TMUX_NO_PATCHED_FONT_OPTION
  unset -v _current_dir
  unset -f __load __cleanup
}

__load() {
  tmux source-file "$_current_dir/$NORD_TMUX_COLOR_THEME_FILE"

  local status_content=$(tmux show-option -gqv "$NORD_TMUX_STATUS_CONTENT_OPTION")
  local no_patched_font=$(tmux show-option -gqv "$NORD_TMUX_NO_PATCHED_FONT_OPTION")

  if [ "$status_content" != "0" ]; then
    if [ "$no_patched_font" != "1" ]; then
      tmux source-file "$_current_dir/$NORD_TMUX_STATUS_CONTENT_FILE"
    else
      tmux source-file "$_current_dir/$NORD_TMUX_STATUS_CONTENT_NO_PATCHED_FONT_FILE"
    fi
  fi
}

__load
__cleanup
