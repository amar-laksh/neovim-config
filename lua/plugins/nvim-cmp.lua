local cmp_status_ok, cmp = pcall(require, 'cmp')
if not cmp_status_ok then
    return
end

local cmp_nvim_ultisnips_status_ok, ultisnips = pcall(require, 'cmp_nvim_ultisnips')
if not cmp_nvim_ultisnips_status_ok then
    return
end
ultisnips.setup({})

if not cmp then
    return
end

cmp.setup {
    -- Load snippet support
    snippet = {
        expand = function(args)
            vim.fn["UltiSnips#Anon"](args.body)
        end,
    },
    -- Load sources, see: https://github.com/topics/nvim-cmp
    sources = {
        { name = 'nvim_lsp' },
        { name = 'ultisnips' },
        { name = 'path' },
        { name = 'buffer', keyword_length = 4 },
        { name = 'orgmode' },
        { name = 'calc' },
    },

    -- Completion settings
    completion = {
        --completeopt = 'menu,menuone,noselect'
        keyword_length = 2
    },
    -- Key mapping
    mapping = {
        ['<C-n>'] = cmp.mapping.select_next_item(),
        ['<C-p>'] = cmp.mapping.select_prev_item(),
        ['<C-d>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.close(),
        ['<CR>'] = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
        },
    },
}
