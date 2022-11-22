local dap_ui_status_ok, dap_ui = pcall(require, 'dapui')
if not dap_ui_status_ok then
    return
end

dap_ui.setup({
    icons = { expanded = "<", collapsed = ">", current_frame = "*" },
    mappings = {
        -- Use a table to apply multiple mappings
        expand = { "<CR>", "<2-LeftMouse>" },
        open = "o",
        remove = "d",
        edit = "e",
        repl = "r",
        toggle = "t",
    },
    -- Use this to override mappings for specific elements
    element_mappings = {
        -- Example:
        -- stacks = {
        --   open = "<CR>",
        --   expand = "o",
        -- }
    },
    -- Expand lines larger than the window
    -- Requires >= 0.7
    expand_lines = vim.fn.has("nvim-0.7") == 1,
    -- Layouts define sections of the screen to place windows.
    -- The position can be "left", "right", "top" or "bottom".
    -- The size specifies the height/width depending on position. It can be an Int
    -- or a Float. Integer specifies height/width directly (i.e. 20 lines/columns) while
    -- Float value specifies percentage (i.e. 0.3 - 30% of available lines/columns)
    -- Elements are the elements shown in the layout (in order).
    -- Layouts are opened in order so that earlier layouts take priority in window sizing.
    layouts = {
        {
            elements = {
                -- Elements can be strings or table with id and size keys.
                -- { id = "scopes", size = 0.05 },
                -- { id = "stacks", size = 0.20 },
                -- { id = "threads", size = 0.05 },
            },
            size = 0.30,
            position = "bottom",
        },
        {
            elements = {
                "scopes",
                "stacks",
                "breakpoints",
                "watches"
            },
            size = 0.30,
            position = "right",
        },
    },
    controls = {
        -- Requires Neovim nightly (or 0.8 when released)
        enabled = false,
        -- Display controls in this element
        element = "repl",
        icons = {
            pause = "PAUSE",
            play = "PLAY",
            step_into = "STEP_INTO",
            step_over = "STEP_OVER",
            step_out = "STEP_OUT",
            step_back = "STEP_BACK",
            run_last = "RUN_LAST",
            terminate = "TERMINATE",
        },
    },
    floating = {
        max_height = 0.2, -- These can be integers or a float between 0 and 1.
        max_width = 0.2, -- Floats will be treated as percentage of your screen.
        border = "single", -- Border style. Can be "single", "double" or "rounded"
        mappings = {
            close = { "q", "<Esc>" },
        },
    },
    windows = { indent = 1 },
    render = {
        max_type_length = nil, -- Can be integer or nil.
        max_value_lines = nil, -- Can be integer or nil.
    }
})
-- Update render on save
vim.cmd [[autocmd BufWritePre * lua require('dapui').update_render({})]]
