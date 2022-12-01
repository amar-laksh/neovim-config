-- For configuration see the Wiki: https://github.com/neovim/nvim-lspconfig/wiki
-- Autocompletion settings of "nvim-cmp" are defined in plugins/nvim-cmp.lua

local lsp_status_ok, lspconfig = pcall(require, 'lspconfig')
if not lsp_status_ok then
    return
end

local cmp_status_ok, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
if not cmp_status_ok then
    return
end

-- Diagnostic options, see: `:help vim.diagnostic.config`
vim.diagnostic.config({
    update_in_insert = true,
    float = {
        focusable = false,
        style = "minimal",
        border = "rounded",
        source = "always",
        header = "",
    },
})

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics,
    {
        virtual_text = false,
        signs = true,
        update_in_insert = false,
        underline = true,
    }
)

-- Show line diagnostics automatically in hover window
vim.cmd([[
  autocmd CursorHold,CursorHoldI * lua vim.diagnostic.open_float(nil, { focus = false })
]])

-- Format on save
vim.cmd [[autocmd BufWritePre * lua vim.lsp.buf.format()]]


-- Add additional capabilities supported by nvim-cmp
-- See: https://github.com/neovim/nvim-lspconfig/wiki/Autocompletion
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = cmp_nvim_lsp.default_capabilities(capabilities)

capabilities.textDocument.completion.completionItem.documentationFormat = { 'markdown', 'plaintext' }
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.preselectSupport = true
capabilities.textDocument.completion.completionItem.insertReplaceSupport = true
capabilities.textDocument.completion.completionItem.labelDetailsSupport = true
capabilities.textDocument.completion.completionItem.deprecatedSupport = true
capabilities.textDocument.completion.completionItem.commitCharactersSupport = true
capabilities.textDocument.completion.completionItem.tagSupport = { valueSet = { 1 } }
capabilities.textDocument.completion.completionItem.resolveSupport = {
    properties = {
        'documentation',
        'detail',
        'additionalTextEdits',
    },
}

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
    local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end

    local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

    -- Highlighting references
    if client.server_capabilities.documentHighlightProvider then
        vim.api.nvim_exec([[
      augroup lsp_document_highlight
        autocmd! * <buffer>
        autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
        autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
      augroup END
    ]]   , false)
    end

    -- Enable completion triggered by <c-x><c-o>
    buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')
end

--[[

Language servers setup:

For language servers list see:
https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md

Language server installed:

Bash          -> bashls
Python        -> pyright
C-C++         -> clangd
HTML/CSS/JSON -> vscode-html-languageserver
JavaScript/TypeScript -> tsserver

--]]

-- Define `root_dir` when needed
-- See: https://github.com/neovim/nvim-lspconfig/issues/320
-- This is a workaround, maybe not work with some servers.
local root_dir = function()
    return vim.fn.getcwd()
end

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches.
-- Add your language server below:
local servers = { 'pylsp', 'html', 'cssls', 'tsserver', 'hls', 'rust_analyzer' }

-- Call setup
for _, lsp in ipairs(servers) do
    lspconfig[lsp].setup {
        on_attach = on_attach,
        root_dir = root_dir,
        capabilities = capabilities,
        flags = {
            -- default in neovim 0.7+
            debounce_text_changes = 150,
        }
    }
end

lspconfig.hls.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    haskell = {
        plugin = {
            rename = {
                config = {
                    diff = true
                }
            }
        }
    }
}

lspconfig.bashls.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    cmd_env = {
        -- Ignore windows stuff
        SHELLCHECK_OPTS = '-e SC1017 -e SC2148'
    }
}
-- setting up lua lsp separately
lspconfig.sumneko_lua.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
        Lua = {
            runtime = {
                -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
                version = 'LuaJIT',
            },
            diagnostics = {
                -- Get the language server to recognize the `vim` global
                globals = { 'vim' },
            },
            workspace = {
                -- Make the server aware of Neovim runtime files
                library = vim.api.nvim_get_runtime_file("", true),
            },
            -- Do not send telemetry data containing a randomized but unique identifier
            telemetry = {
                enable = false,
            },
        },
    },
}

lspconfig.ccls.setup {
    on_attach = on_attach,
    init_options = {
        compilationDatabaseDirectory = "",
        index = {
        },
        clang = {
            excludeArgs = { "-frounding-math" },
            extraArgs = { "-Wall", "-Wextra", "-Wfloat-equal" }

        },
        client = {
            snippetSupport = true,
            hoverProvider = true,
            completionProvider = true,
            referencesProvider = true,
            definitionProvider = true,
            codeActionProvider = true
        }

    }
}

local lsp_signature_status_ok, lsp_signature = pcall(require, 'lsp_signature')
if not lsp_signature_status_ok then
    return
end
local cfg = {
    debug = false, -- set to true to enable debug logging
    log_path = vim.fn.stdpath("cache") .. "/lsp_signature.log", -- log dir when debug is on
    -- default is  ~/.cache/nvim/lsp_signature.log
    verbose = false, -- show debug line number

    bind = true, -- This is mandatory, otherwise border config won't get registered.
    -- If you want to hook lspsaga or other signature handler, pls set to false
    doc_lines = 0, -- will show two lines of comment/doc(if there are more than two lines in doc, will be truncated);
    -- set to 0 if you DO NOT want any API comments be shown
    -- This setting only take effect in insert mode, it does not affect signature help in normal
    -- mode, 10 by default

    max_height = 12, -- max height of signature floating_window
    max_width = 80, -- max_width of signature floating_window
    noice = false, -- set to true if you using noice to render markdown
    wrap = true, -- allow doc/signature text wrap inside floating_window, useful if your lsp return doc/sig is too long

    floating_window = true, -- show hint in a floating window, set to false for virtual text only mode

    floating_window_above_cur_line = true, -- try to place the floating above the current line when possible Note:
    -- will set to true when fully tested, set to false will use whichever side has more space
    -- this setting will be helpful if you do not want the PUM and floating win overlap

    floating_window_off_x = 1, -- adjust float windows x position.
    floating_window_off_y = 0, -- adjust float windows y position. e.g -2 move window up 2 lines; 2 move down 2 lines

    close_timeout = 7000, -- close floating window after ms when laster parameter is entered
    fix_pos = true, -- set to true, the floating window will not auto-close until finish all parameters
    hint_enable = false, -- virtual hint enable
    hint_scheme = "String",
    hi_parameter = "LspSignatureActiveParameter", -- how your parameter will be highlight
    handler_opts = {
        border = "rounded" -- double, rounded, single, shadow, none, or a table of borders
    },

    always_trigger = false, -- sometime show signature on new line or in middle of parameter can be confusing, set it to false for #58

    auto_close_after = nil, -- autoclose signature float win after x sec, disabled if nil.
    extra_trigger_chars = {}, -- Array of extra characters that will trigger signature completion, e.g., {"(", ","}
    zindex = 200, -- by default it will be on top of all floating windows, set to <= 50 send it to bottom

    padding = '', -- character to pad on left and right of signature can be ' ', or '|'  etc

    transparency = nil, -- disabled by default, allow floating win transparent value 1~100
    shadow_blend = 36, -- if you using shadow as border use this set the opacity
    shadow_guibg = 'Black', -- if you using shadow as border use this set the color e.g. 'Green' or '#121315'
    timer_interval = 50, -- default timer check interval set to lower value if you want to reduce latency
    toggle_key = nil, -- toggle signature on and off in insert mode,  e.g. toggle_key = '<M-x>'

    select_signature_key = nil, -- cycle to next signature, e.g. '<M-n>' function overloading
    move_cursor_key = nil, -- imap, use nvim_set_current_win to move cursor between current win and floating
}

lsp_signature.setup(cfg);


-- require("clangd_extensions").setup {
--     server = {
--         init_options = {
--             compilationDatabaseDirectory = "build";
--         },
--         on_attach = on_attach,
--         capabilities = capabilities,
--         -- options to pass to nvim-lspconfig
--         -- i.e. the arguments to require("lspconfig").clangd.setup({})
--     },
--     extensions = {
--         -- defaults:
--         -- Automatically set inlay hints (type hints)
--         autoSetHints = true,
--         -- These apply to the default ClangdSetInlayHints command
--         inlay_hints = {
--             -- Only show inlay hints for the current line
--             only_current_line = false,
--             -- Event which triggers a refersh of the inlay hints.
--             -- You can make this "CursorMoved" or "CursorMoved,CursorMovedI" but
--             -- not that this may cause  higher CPU usage.
--             -- This option is only respected when only_current_line and
--             -- autoSetHints both are true.
--             only_current_line_autocmd = "CursorHold",
--             -- whether to show parameter hints with the inlay hints or not
--             show_parameter_hints = true,
--             -- prefix for parameter hints
--             parameter_hints_prefix = "<- ",
--             -- prefix for all the other hints (type, chaining)
--             other_hints_prefix = "=> ",
--             -- whether to align to the length of the longest line in the file
--             max_len_align = false,
--             -- padding from the left if max_len_align is true
--             max_len_align_padding = 1,
--             -- whether to align to the extreme right or not
--             right_align = false,
--             -- padding from the right if right_align is true
--             right_align_padding = 7,
--             -- The color of the hints
--             highlight = "Comment",
--             -- The highlight group priority for extmark
--             priority = 100,
--         },
--         ast = {
--             role_icons = {
--                 type = "",
--                 declaration = "",
--                 expression = "",
--                 specifier = "",
--                 statement = "",
--                 ["template argument"] = "",
--             },
--
--             kind_icons = {
--                 Compound = "",
--                 Recovery = "",
--                 TranslationUnit = "",
--                 PackExpansion = "",
--                 TemplateTypeParm = "",
--                 TemplateTemplateParm = "",
--                 TemplateParamObject = "",
--             },
--
--             highlights = {
--                 detail = "Comment",
--             },
--         },
--         memory_usage = {
--             border = "none",
--         },
--         symbol_info = {
--             border = "none",
--         },
--     },
-- }
--
