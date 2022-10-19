local cmp_status_ok, cmp = pcall(require, 'cmp')
if not cmp_status_ok then
    return
end

local cmp_nvim_ultisnips_status_ok, ultisnip = pcall(require, 'cmp_nvim_ultisnips')
if not cmp_nvim_ultisnips_status_ok then
    return
end

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

        -- Tab mapping
        ['<Tab>'] = function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            elseif ultisnip.expand_or_jumpable() then
                ultisnip.expand_or_jump()
            else
                fallback()
            end
        end,
        ['<S-Tab>'] = function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif ultisnip.jumpable(-1) then
                ultisnip.jump(-1)
            else
                fallback()
            end
        end
    },

    -- Load sources, see: https://github.com/topics/nvim-cmp
    sources = {
        { name = 'nvim_lsp' },
        { name = 'cmp_nvim_ultisnips' },
        { name = 'path' },
        { name = 'buffer', keyword_length = 4 },
    },
}
