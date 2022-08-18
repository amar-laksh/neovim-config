#!/bin/bash -

set -o nounset                                  # Treat unset variables as an error

git clone https://github.com/amar-laksh/neovim-config ~/.config/nvim && cd ~/.config/nvim && git remote set-url origin git@github.com:amar-laksh/neovim-config.git && nvim +PackerSync
