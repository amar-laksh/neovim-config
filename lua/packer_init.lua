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
    use "wbthomason/packer.nvim"

    -------------------------------
    -- UI Plugins
    -------------------------------
    -- Nice status line
    use {
        "nvim-lualine/lualine.nvim",
        requires = { "kyazdani42/nvim-web-devicons", opt = true }
    }

    -- Smooth scrolling
    use "karb94/neoscroll.nvim"

    -- Scrollbar with highlights
    use { "petertriho/nvim-scrollbar",
        config = function()
            require('scrollbar').setup()

        end }

    -- Fancy tabs
    use {
        'romgrk/barbar.nvim'
    }

    -------------------------------
    -- Experience Plugins
    -------------------------------
    -- Saves my neovim sessions
    use {
        'rmagatti/auto-session',
        config = function()
            require("auto-session").setup {
                log_level = "error",
                auto_session_suppress_dirs = { "~/", "~/Downloads", "/" },
                auto_session_use_git_branch = true
            }
        end
    }

    -- Floating terminal
    use {
        'numToStr/FTerm.nvim'
    }


    -- Comment plugin with treesitter support
    use {
        "numToStr/Comment.nvim",
        config = function()
            require('Comment').setup()
        end
    }

    -- code outline window for quick navigation
    use {
        "stevearc/aerial.nvim",
        config = function() require('aerial').setup() end
    }

    -- perform operations between pairs of symbols
    use "machakann/vim-sandwich"

    -- yep
    use "terryma/vim-multiple-cursors"

    -- restore last position of the cursor
    use "ethanholz/nvim-lastplace"

    -- handles pair objects automatically (all the brackets!)
    use {
        "windwp/nvim-autopairs",
        config = function() require("nvim-autopairs").setup {} end
    }

    -- switching between source and header files
    use "ericcurtin/CurtineIncSw.vim"

    -- For zeal docs
    use "KabbAmine/zeavim.vim"

    -- Configurations for Nvim LSP
    use "neovim/nvim-lspconfig"

    use {
        'MrcJkb/haskell-tools.nvim',
        requires = {
            'neovim/nvim-lspconfig',
            'nvim-lua/plenary.nvim',
            'nvim-telescope/telescope.nvim', -- optional
        },

    }
    -- Autocompletion plugins
    use "hrsh7th/nvim-cmp"
    use "hrsh7th/cmp-path"
    use "hrsh7th/cmp-buffer"
    use "hrsh7th/cmp-nvim-lsp"

    -- LSP signature hint as you type
    use "ray-x/lsp_signature.nvim"

    -- Snippets plugin
    use "SirVer/ultisnips"

    -- Snippets source for nvim-cmp
    use { "quangnguyen30192/cmp-nvim-ultisnips" }

    -- Language parsing and syntax highlighting
    use { "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" }

    -- Scope highlighting
    use "nvim-treesitter/nvim-treesitter-refactor"

    -- syntax aware support
    use "nvim-treesitter/nvim-treesitter-textobjects"

    -- Jump anywhere using a few keystrokes!
    use {
        "phaazon/hop.nvim",
        config = function()
            require('hop').setup({
                multi_windows = true,
            })
        end
    }

    -- Region highlight using treesitter and hop
    use "mfussenegger/nvim-treehopper"

    -- Pretty list for diagnostics etc.
    use {
        "folke/trouble.nvim",
        requires = "kyazdani42/nvim-web-devicons",
        config = function()
            require("trouble").setup {
            }
        end
    }

    -- Nice Markdown preview with async updates
    use({
        "iamcco/markdown-preview.nvim",
        run = function() vim.fn["mkdp#util#install"]() end,
    })

    -- git support inside neovim
    use { "TimUntersberger/neogit", requires = "nvim-lua/plenary.nvim",
        config = function()
            require("neogit").setup()
        end
    }

    -- git blame support
    use "APZelos/blamer.nvim"

    -- Command prompt to search and select everything
    use {
        "nvim-telescope/telescope.nvim", tag = "0.1.0",
        requires = { { "nvim-lua/plenary.nvim" } }
    }
    use { "nvim-telescope/telescope-file-browser.nvim" }
    use { "luc-tielen/telescope_hoogle" }
    use { "nvim-telescope/telescope-dap.nvim" }
    use { "xiyaowong/telescope-emoji.nvim" }
    use { "joaomsa/telescope-orgmode.nvim" }



    -- Provides yank ring history
    use({
        "gbprod/yanky.nvim",
        config = function()
            require("yanky").setup({
                preserve_cursor_position = {
                    enabled = true,
                },
            })
        end
    })

    -- Uses treesitter to move and edit blocks of code
    use { "ziontee113/syntax-tree-surfer" }

    -- Can run small snippets independently
    use { "michaelb/sniprun", run = "bash ./install.sh" }

    -- Debugging support
    use "mfussenegger/nvim-dap"
    use "theHamsta/nvim-dap-virtual-text"
    use { "rcarriga/nvim-dap-ui", requires = { "mfussenegger/nvim-dap" } }
    use "ofirgall/goto-breakpoints.nvim"
    use { "Weissle/persistent-breakpoints.nvim" }

    -- Provides support for C/C++
    use "m-pilia/vim-ccls"

    -- provides helpful keybinding legend
    use { "mrjones2014/legendary.nvim", requires = { "folke/which-key.nvim" } }

    -- A http client
    use "rest-nvim/rest.nvim"
    use { "amar-laksh/neotest-catch2" }

    use {
        "nvim-neotest/neotest",
        requires = {
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",
            "antoinemadec/FixCursorHold.nvim"
        }
    }
    use { 'nvim-orgmode/orgmode' }

    -------------------------------
    -- Eye candy Plugins
    -------------------------------
    -- Lsp progress
    use { 'j-hui/fidget.nvim',
        config = function()
            require("fidget").setup({})
        end
    }
    -- Fancy notification bubbles
    use { "rcarriga/nvim-notify",
        config = function()
            require("notify").setup({})
        end }

    -- Treesitter playground to write AST queries
    use "nvim-treesitter/playground"

    -- Improves default UI interfaces
    use "stevearc/dressing.nvim"

    -- Themes
    use "overcache/NeoSolarized"
    use "ellisonleao/gruvbox.nvim"

    -- Icons
    use "kyazdani42/nvim-web-devicons"

    -- Toggles transparency
    use { "xiyaowong/nvim-transparent", config = function()
        require("transparent").setup({
            enable = false, -- boolean: enable transparent
            extra_groups = { -- table/string: additional groups that should be cleared
                "BufferLineTabClose",
                "BufferlineBufferSelected",
                "BufferLineFill",
                "BufferLineBackground",
                "BufferLineSeparator",
                "BufferLineIndicatorSelected",
            },
            exclude = {}, -- table: groups you don't want to clear
        })
    end }

    -- Automatically set up your configuration after cloning packer.nvim
    -- Put this at the end after all plugins
    if packer_bootstrap then
        require("packer").sync()
    end
end)
