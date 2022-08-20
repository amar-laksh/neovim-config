-----------------------------------------------------------
-- Neovim LSP configuration file
-----------------------------------------------------------

-- Plugin: nvim-lspconfig
-- url: https://github.com/neovim/nvim-lspconfig

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
        prefix = "",
    },
})

-- Show line diagnostics automatically in hover window
vim.cmd([[
  autocmd CursorHold,CursorHoldI * lua vim.diagnostic.open_float(nil, { focus = false })
]])

-- Format on save
vim.cmd [[autocmd BufWritePre * lua vim.lsp.buf.formatting_sync()]]


-- Add additional capabilities supported by nvim-cmp
-- See: https://github.com/neovim/nvim-lspconfig/wiki/Autocompletion
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = cmp_nvim_lsp.update_capabilities(capabilities)

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
    if client.resolved_capabilities.document_highlight then
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
local servers = { 'bashls', 'pylsp', 'html', 'cssls', 'tsserver', 'hls', 'rust_analyzer' }

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

-- setting up lua lsp separately
require 'lspconfig'.sumneko_lua.setup {
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


require("clangd_extensions").setup {
    server = {
        init_options = {
            compilationDatabaseDirectory = "build";
        },
        on_attach = on_attach,
        capabilities = capabilities,
        -- options to pass to nvim-lspconfig
        -- i.e. the arguments to require("lspconfig").clangd.setup({})
    },
    extensions = {
        -- defaults:
        -- Automatically set inlay hints (type hints)
        autoSetHints = true,
        -- These apply to the default ClangdSetInlayHints command
        inlay_hints = {
            -- Only show inlay hints for the current line
            only_current_line = false,
            -- Event which triggers a refersh of the inlay hints.
            -- You can make this "CursorMoved" or "CursorMoved,CursorMovedI" but
            -- not that this may cause  higher CPU usage.
            -- This option is only respected when only_current_line and
            -- autoSetHints both are true.
            only_current_line_autocmd = "CursorHold",
            -- whether to show parameter hints with the inlay hints or not
            show_parameter_hints = true,
            -- prefix for parameter hints
            parameter_hints_prefix = "<- ",
            -- prefix for all the other hints (type, chaining)
            other_hints_prefix = "=> ",
            -- whether to align to the length of the longest line in the file
            max_len_align = false,
            -- padding from the left if max_len_align is true
            max_len_align_padding = 1,
            -- whether to align to the extreme right or not
            right_align = false,
            -- padding from the right if right_align is true
            right_align_padding = 7,
            -- The color of the hints
            highlight = "Comment",
            -- The highlight group priority for extmark
            priority = 100,
        },
        ast = {
            role_icons = {
                type = "",
                declaration = "",
                expression = "",
                specifier = "",
                statement = "",
                ["template argument"] = "",
            },

            kind_icons = {
                Compound = "",
                Recovery = "",
                TranslationUnit = "",
                PackExpansion = "",
                TemplateTypeParm = "",
                TemplateTemplateParm = "",
                TemplateParamObject = "",
            },

            highlights = {
                detail = "Comment",
            },
        },
        memory_usage = {
            border = "none",
        },
        symbol_info = {
            border = "none",
        },
    },
}
