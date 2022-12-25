local legendary_status_ok, legendary = pcall(require, 'legendary')
if not legendary_status_ok then
    return
end


legendary.setup({
    -- Include builtins by default, set to false to disable
    include_builtin = true,
    -- Include the commands that legendary.nvim creates itself
    -- in the legend by default, set to false to disable
    include_legendary_cmds = true,
    -- Customize the prompt that appears on your vim.ui.select() handler
    -- Can be a string or a function that takes the `kind` and returns
    -- a string. See "Item Kinds" below for details. By default,
    -- prompt is 'Legendary' when searching all items,
    -- 'Legendary Keymaps' when searching keymaps,
    -- 'Legendary Commands' when searching commands,
    -- and 'Legendary Autocmds' when searching autocmds.
    select_prompt = nil,
    -- Optionally pass a custom formatter function. This function
    -- receives the item as a parameter and must return a table of
    -- non-nil string values for display. It must return the same
    -- number of values for each item to work correctly.
    -- The values will be used as column values when formatted.
    -- See function `get_default_format_values(item)` in
    -- `lua/legendary/formatter.lua` to see default implementation.
    formatter = nil,
    -- When you trigger an item via legendary.nvim,
    -- show it at the top next time you use legendary.nvim
    most_recent_item_at_top = true,
    -- Initial keymaps to bind
    keymaps = {
        -- Git
        { '<leader>gs', ':Neogit kind=vsplit<CR>', description = "Git: open neogit" },

        -- Aerial
        { '<leader>aa', ':AerialToggle<CR>', description = "Aerial: toggle outline" },
        { '<leader>an', ':AerialNext<CR>', description = "Aerial: go to next symbol" },
        { '<leader>ap', ':AerialPrev<CR>', description = "Aerial: go to previous symbol" },

        -- LSP
        { 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', description = "LSP: show declaration" },
        { 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', description = "LSP: show definition" },
        { '<leader>gd', "<cmd>lua require('goto-preview').goto_preview_definition()<CR>",
            description = "Peek: definition" },

        { 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', description = "LSP: hover over symbol" },

        { 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', description = "LSP: show implementation" },
        { '<leader>gi', "<cmd>lua require('goto-preview').goto_preview_implementation()<CR>",
            description = "Peek: implementation" },

        { 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', description = "LSP: show references" },


        { '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', description = "LSP: type definition" },
        { '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', description = "LSP: rename" },
        { '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', description = "LSP: code action" },
        { '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', description = "LSP: goto next diagnostic" },
        { ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', description = "LSP: goto previous diagnostic" },

        -- Hopper
        { '<space>w', '<cmd>:HopWord<CR>', description = "Hopper: hop to a word" },
        { '<space>l', '<cmd>:HopLineStart<CR>', description = "Hopper: hop to a line start" },
        { '<space>r', "<cmd>:lua require('tsht').nodes()<CR>", description = "tree hopper: select a region" },

        -- Telescope
        --
        { "<leader>fr", "<cmd>:Telescope resume<cr>",
            description = "Telescope: resume state" },
        { "<leader>ff", "<cmd>:Telescope find_files find_command=rg,--ignore,--hidden,--files<cr>",
            description = "Telescope: find files" },
        { "<leader>fg", "<cmd>lua require('telescope.builtin').live_grep()<cr>", description = "Telescope: live grep" },
        { "<leader>fh", "<cmd>lua require('telescope.builtin').help_tags()<cr>", description = "Telescope: help tags" },
        { "<leader>fs", "<cmd>lua require('telescope.builtin').lsp_workspace_symbols()<cr>",
            description = "Telescope: workspace symbols" },
        { "<leader>fb", "<cmd>lua require('telescope.builtin').buffers()<cr>",
            description = "Telescope: buffers" },
        { "<leader>fB", "<cmd>Telescope file_browser<cr>",
            description = "Telescope: file browser" },
        { "<leader>fo", "<cmd>Telescope hoogle<cr>",
            description = "Telescope: hoogle" },
        { "<leader>ft", "<cmd>lua require('telescope.builtin').treesitter()<cr>",
            description = "Telescope: treesitter based symbols" },
        { "<leader>fe", "<cmd>Telescope emoji<cr>",
            description = "Telescope: emojis" },
        -- Yanky
        { "<leader>fy", ":YankyRingHistory<cr>",
            description = "Telescope: Yank ring history" },




        -- DAP
        { "<leader>dd", "<cmd>lua require('dap').continue()<cr>",
            description = "DAP: continue" },

        { "<leader>dc", "<cmd>Telescope dap commands<cr>",
            description = "DAP: commands" },

        { "<leader>db",
            "<cmd>:PBToggleBreakpoint<cr><cmd>lua require('dapui').update_render({})<cr>",
            description = "DAP: toggle breakpoint" },

        { "<leader>dC",
            "<cmd>:PBSetConditionalBreakpoint<cr><cmd>lua require('dapui').update_render({})<cr>",
            description = "DAP: clear all breakpoints" },

        { "<leader>dB",
            "<cmd>:PBClearAllBreakpoints<cr><cmd>lua require('dapui').update_render({})<cr>",
            description = "DAP: clear all breakpoints" },

        { "<leader>df", "<cmd>Telescope dap frames<cr>",
            description = "DAP: frames" },

        { "<leader>dv", "<cmd>Telescope dap variables<cr>",
            description = "DAP: variables" },

        { "<leader>dr", "<cmd>lua require('dap').run_to_cursor()<cr><cmd>lua require('dapui').update_render({})<cr>",
            description = "DAP: run to cursor" },


        -- DAP UI
        { "<leader>du", "<cmd>lua require('dapui').toggle()<cr>",
            description = "DAPUI: toggle" },

        -- NeoTest
        { "<space>tf",
            "<cmd>lua require('neotest').run.run(vim.fn.expand('%'))<cr>",
            description = "NeoTest: run the current file" },

        { "<space>td",
            "<cmd>lua require('neotest').run.run({strategy = 'dap'})<cr>",
            description = "NeoTest: run nearest test" },

        { "<space>tr",
            "<cmd>lua require('neotest').run.run()<cr>",
            description = "NeoTest: run nearest test" },

        { "<space>to",
            "<cmd>lua require('neotest').output_panel.toggle()<cr>",
            description = "NeoTest: toggle tests output" },

        { "<space>ts",
            "<cmd>lua require('neotest').summary.toggle()<cr>",
            description = "NeoTest: toggle tests summary" },

        { "<space>tn",
            "<cmd>lua require('neotest').jump.next({})<cr>",
            description = "NeoTest: goto next test" },

        { "<space>tp",
            "<cmd>lua require('neotest').jump.prev({})<cr>",
            description = "NeoTest: goto previous test" },



        -- Transparency
        { "<leader>gt", ":lua local bck = vim.o.background; vim.cmd[[TransparentToggle]]; vim.o.background = bck<CR>",
            description = "Transparency: toggle" },

        -- Blamer
        { "<leader>gb", ":BlamerToggle<cr>",
            description = "Blamer: Toggle git blame" },
        -- Ccls
        { "<leader>ccb", ":CclsBase<cr>",
            description = "Ccls: Get list of a base classes" },
        { "<leader>chb", ":CclsBaseHierarchy<cr>",
            description = "Ccls: Get a tree of inheritance ancestors" },
        { "<leader>ccd", ":CclsDerived<cr>",
            description = "Ccls: Get list of a derived classes" },
        { "<leader>chd", ":CclsDerivedHierarchy<cr>",
            description = "Ccls: Get a tree of inheritance descendants" },
        { "<leader>ccc", ":CclsCallers<cr>",
            description = "Ccls: Get list of functions calling the function" },
        { "<leader>chc", ":CclsCallHierarchy<cr>",
            description = "Ccls: Get a hierarchy of functions calling the function" },
        { "<leader>ccC", ":CclsCallees<cr>",
            description = "Ccls: Get list of functions called in the function" },
        { "<leader>chC", ":CclsCalleeHierarchy<cr>",
            description = "Ccls: Get a hierarchy of functions called by the function" },
        { "<leader>cm", ":CclsMembers<cr>",
            description = "Ccls: Get a list of members for the class" },
        { "<leader>chm", ":CclsMemberHierarchy<cr>",
            description = "Ccls: Get a tree of members for the class" },
        { "<leader>dv", ":CclsVars<cr>",
            description = "Ccls: Get a list of document variables" },

        { "<leader>sf", ":call CurtineIncSw()<cr>",
            description = "Switches between header and source files" },

        -- Zeal docs
        { "<leader>fz", "<cmd>:Zeavim<cr>",
            description = "Zeavim: query docs for current symbol under cursor" },

        { "<leader>ss", "<cmd>:ISwap<cr>",
            description = "Swap param: swap parameters" },

        -- -- Plugin dev
        -- { "<leader>rr",
        --     ":lua package.loaded['neotest-cpp'] = nil;  require('neotest-cpp')<cr>",
        --     description = "Plug dev: reload the plugin" },



        -- Terminal
        -- { "<space>t",
        --     "<cmd>lua require('FTerm').toggle()<cr>",
        --     description = "FTerm: Toggle the terminal" },


    },
    -- Initial commands to bind
    commands = {
        -- your command tables here
    },
    -- Initial augroups and autocmds to bind
    autocmds = {
        -- your autocmd tables here
    },
    which_key = {
        -- you can put which-key.nvim tables here,
        -- or alternatively have them auto-register,
        -- see section on which-key integration
        mappings = {},
        opts = {},
        -- controls whether legendary.nvim actually binds they keymaps,
        -- or if you want to let which-key.nvim handle the bindings.
        -- if not passed, true by default
        do_binding = {},
    },
    -- Automatically add which-key tables to legendary
    -- see "which-key.nvim Integration" below for more details
    which_key = {
        auto_register = true,
    },
    -- settings for the :LegendaryScratch command
    scratchpad = {
        -- configure how to show results of evaluated Lua code,
        -- either 'print' or 'float'
        -- Pressing q or <ESC> will close the float
        results_view = 'float',
    },
})
