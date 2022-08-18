-----------------------------------------------------------
-- Plugin manager configuration file
-----------------------------------------------------------

-- Plugin manager: packer.nvim
-- url: https://github.com/wbthomason/packer.nvim


-- Automatically install packer
local fn = vim.fn
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"

if fn.empty(fn.glob(install_path)) > 0 then
    packer_bootstrap = fn.system({
        "git",
        "clone",
        "--depth",
        "1",
        "https://github.com/wbthomason/packer.nvim",
        install_path
    })
    vim.o.runtimepath = vim.fn.stdpath("data") .. "/site/pack/*/start/*," .. vim.o.runtimepath
end

-- Ajtocommand that reloads neovim whenever you save the packer_init.lua file
vim.cmd [[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost packer_init.lua source <afile> | PackerSync
  augroup end
]]

-- Use a protected call so we don"t error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
    print("I don't have packer man!")
    return
end

return packer.startup(function(use)
    -- Add you plugins here:
    use "wbthomason/packer.nvim" -- packer can manage itself

    -------------------------------
    -- UI Plugins
    -------------------------------
    use {
        "nvim-lualine/lualine.nvim",
        requires = { "kyazdani42/nvim-web-devicons", opt = true }
    }
    use "karb94/neoscroll.nvim" -- Smooth scrolling
    use "petertriho/nvim-scrollbar" -- Scrollbar with highlights
    use "lewis6991/nvim-treesitter-context" -- Context highlight on top of buffer

    -------------------------------
    -- Experience Plugins
    -------------------------------
    use "ethanholz/nvim-lastplace" -- restore last position of the cursor
    use "scrooloose/nerdcommenter" --Comment god
    use {
        "windwp/nvim-autopairs",
        config = function() require("nvim-autopairs").setup {} end
    }
    use "chentau/marks.nvim" -- better marks support

    use "machakann/vim-sandwich" -- perform operations between pairs of symbols
    use "terryma/vim-multiple-cursors" -- yep

    use "neovim/nvim-lspconfig" -- Configurations for Nvim LSP
    use "hrsh7th/nvim-cmp" -- Autocompletion plugin
    use "hrsh7th/cmp-nvim-lsp" -- LSP source for nvim-cmp
    use "saadparwaiz1/cmp_luasnip" -- Snippets source for nvim-cmp
    use "L3MON4D3/LuaSnip" -- Snippets plugin
    use { "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" } -- Language parsing and syntax highlighting
    use "nvim-treesitter/nvim-treesitter-refactor" -- Scope highlighting
    use {
        "folke/trouble.nvim",
        requires = "kyazdani42/nvim-web-devicons",
        config = function()
            require("trouble").setup {
            }
        end
    }
    use "mizlan/iswap.nvim"
    use { "michaelb/sniprun", run = "bash ./install.sh" }
    use "p00f/clangd_extensions.nvim"

    use {
        "nvim-telescope/telescope.nvim", tag = "0.1.0",
        -- or                            , branch = "0.1.x",
        requires = { { "nvim-lua/plenary.nvim" } }
    }
    use "s1n7ax/nvim-terminal"


    use({
        "iamcco/markdown-preview.nvim",
        run = function() vim.fn["mkdp#util#install"]() end,
    })
    use {
        "lewis6991/spellsitter.nvim",
        config = function()
            require("spellsitter").setup()
        end
    }
    use "stevearc/aerial.nvim"
    use { "TimUntersberger/neogit", requires = "nvim-lua/plenary.nvim",
        config = function()
            require("neogit").setup()
        end
    }

    -------------------------------
    -- Eye candy Plugins
    -------------------------------
    use "overcache/NeoSolarized"
    use "ellisonleao/gruvbox.nvim"
    use "kyazdani42/nvim-web-devicons"

    -- Automatically set up your configuration after cloning packer.nvim
    -- Put this at the end after all plugins
    if packer_bootstrap then
        require("packer").sync()
    end
end)
