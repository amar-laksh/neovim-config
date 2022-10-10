#!/bin/bash -

set -o nounset                                  # Treat unset variables as an error

function install_nvim() {
    cd /tmp/ && \
    curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage && \
    chmod u+x nvim.appimage && \
    ./nvim.appimage --appimage-extract && \
    mv squashfs-root /usr/local/nvim_app && \
    ln -s /usr/local/nvim_app/AppRun /usr/bin/nvim && \
    chmod u+x /usr/bin/nvim
}

function install_treesitter() {
	cd /tmp && \
		curl -L https://github.com/tree-sitter/tree-sitter/releases/download/v0.20.7/tree-sitter-linux-x64.gz -o treesitter.gz && \
		gunzip -k treesitter.gz && \
        	mv treesitter /usr/bin/tree-sitter  && \
        	chmod u+x /usr/bin/tree-sitter
}

function install_python3() {
	apt install -y python3 python3-pip && pip install neovim
}


# install dependencies if not installed
[ -e /usr/bin/nvim ] || install_nvim
[ -e /usr/bin/tree-sitter ] || install_treesitter
[ -e /usr/bin/python3 ] || install_python3

rm -rf ~/.config/nvim && git clone https://github.com/amar-laksh/neovim-config ~/.config/nvim && cd ~/.config/nvim && git remote set-url origin git@github.com:amar-laksh/neovim-config.git && nvim +PackerSync
