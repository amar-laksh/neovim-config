-----------------------------------------------------------
-- Define keymaps of Neovim and installed plugins.
-----------------------------------------------------------

local function map(mode, lhs, rhs, opts)
    local options = { noremap = true, silent = true }
    if opts then
        options = vim.tbl_extend('force', options, opts)
    end
    vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

--[[-- Change leader to a comma]]
--[[vim.g.mapleader = '\\']]

-------------------------------------------------------------------------------
-- Buffers
-------------------------------------------------------------------------------
map('n', '<C-l>', ':ls<CR>')
map('n', '<C-b>', ':bp<CR>')
map('n', '<C-f>', ':bn<CR>')
map('n', '<C-g>', ':e#<CR>')

-------------------------------------------------------------------------------
-- Lines Manipulation
-------------------------------------------------------------------------------

map('n', '<Leader>la', ':set nornu<CR>')
map('n', '<Leader>lr', ':set rnu<CR>')
--[[nnoremap <silent><C-j> m`:silent +g/\m^\s*$/d<CR>``:noh<CR>]]
--[[nnoremap <silent><C-k> m`:silent -g/\m^\s*$/d<CR>``:noh<CR>]]
--[[noremap  <Leader>rs :s/ \{2,}/ /g<CR>]]
-- nnoremap <silent><M-j> :set paste<CR>m`o<Esc>``:set nopaste<CR>
-- nnoremap <silent><M-k> :set paste<CR>m`O<Esc>``:set nopaste<CR>
-------------------------------------------------------------------------------
-- Function Key Maps
-------------------------------------------------------------------------------

map('n', '<F2>', ':Git<CR>')
map('n', '<F3>', ':NERDTreeToggle<CR>')
map('n', '<F4>', ':AddHeader<CR>')
map('n', '<F5>', ':Codi<CR>')
map('n', '<F8>', ':TagbarToggle<CR>')
map('n', '<F9>', ':exec AllCoq()<CR>')
map('n', '<F10>', ":put =strftime('%d-%m-%Y')<CR>")

-----------------------------------------------------------
-- Movements
-----------------------------------------------------------
map('n', '<C-u>', '<C-u>zz')
map('n', '<C-d>', '<C-d>zz')

-----------------------------------------------------------
-- Applications and Plugins shortcuts
-----------------------------------------------------------
-- Terminal mappings
--map('n', '<C-t>', ':Term<CR>', { noremap = true })  -- open
--map('t', '<Esc>', '<C-\\><C-n>')                    -- exit
--
