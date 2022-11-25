local dap_status_ok, dap = pcall(require, 'dap')
if not dap_status_ok then
    return
end

dap.adapters.lldb = {
    type = 'executable',
    command = '/usr/bin/lldb-vscode', -- adjust as needed, must be absolute path
    name = 'lldb'
}

-- Helpers

local function lines_from(file)
    local function file_exists(filename)
        local f = io.open(filename, "rb")
        if f then f:close() end
        return f ~= nil
    end

    if not file_exists(file) then return {} end
    local lines = {}
    for line in io.lines(file) do
        lines[#lines + 1] = line
    end
    return lines
end

local function read_lines(filename)
    local file = vim.fn.getcwd() .. filename
    local lines = lines_from(file)
    for k, v in pairs(lines) do
        if k then
            return v
        end
        return ""
    end
end

local function getDapTarget(filename, index)
    local lines = read_lines(filename)
    if (lines ~= nil) then
        local words = {}
        for word in lines:gmatch("%S+") do
            table.insert(words, word)
        end
        return words[index]
    else
        return ""
    end
end

dap.configurations.cpp = {
    {

        name = 'Launch',
        type = 'lldb',
        request = 'launch',
        program = function()
            local prog = getDapTarget('/.dapTarget', 1)
            if (prog == "") then
                return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
            end
            return prog
        end,
        cwd = '${workspaceFolder}',
        stopOnEntry = false,
        args = function()
            local arg = getDapTarget('/.dapTarget', 2)
            if (arg == "") then
                return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
            end
            return arg
        end
    },
}

-- If you want to use this for Rust and C, add something like this:

dap.configurations.c = dap.configurations.cpp
dap.configurations.rust = dap.configurations.cpp

local dap_vt_status_ok, dap_virtual_text = pcall(require, 'nvim-dap-virtual-text')
if not dap_vt_status_ok then
    return
end

dap_virtual_text.setup {
    enabled = true, -- enable this plugin (the default)
    enabled_commands = true, -- create commands DapVirtualTextEnable, DapVirtualTextDisable, DapVirtualTextToggle, (DapVirtualTextForceRefresh for refreshing when debug adapter did not notify its termination)
    highlight_changed_variables = true, -- highlight changed values with NvimDapVirtualTextChanged, else always NvimDapVirtualText
    highlight_new_as_changed = false, -- highlight new variables in the same way as changed variables (if highlight_changed_variables)
    show_stop_reason = true, -- show stop reason when stopped for exceptions
    commented = false, -- prefix virtual text with comment string
    only_first_definition = false, -- only show virtual text at first definition (if there are multiple)
    all_references = true, -- show virtual text on all all references of the variable (not only definitions)
    filter_references_pattern = '<module', -- filter references (not definitions) pattern when all_references is activated (Lua gmatch pattern, default filters out Python modules)
    -- experimental features:
    virt_text_pos = 'eol', -- position of virtual text, see `:h nvim_buf_set_extmark()`
    all_frames = false, -- show virtual text for all stack frames not only current. Only works for debugpy on my machine.
    virt_lines = false, -- show virtual lines instead of virtual text (will flicker!)
    virt_text_win_col = nil -- position the virtual text at a fixed window column (starting from the first text column) ,
    -- e.g. 80 to position at column 80, see `:h nvim_buf_set_extmark()`
}

local goto_b_status_ok, goto_b = pcall(require, 'goto-breakpoints')
if not goto_b_status_ok then
    return
end
local map = vim.keymap.set
map('n', ']bd', goto_b.next, {})
map('n', '[bd', goto_b.prev, {})

local pb_status_ok, pb = pcall(require, 'persistent-breakpoints')
if not pb_status_ok then
    return
end
pb.setup {
    load_breakpoints_event = { "BufReadPost" }
}
