local neogit_status_ok, neogit = pcall(require, 'neogit')
if not neogit_status_ok then
    return
end

vim.api.nvim_set_hl(0, "NeogitNotificationInfo", { bold = true, blend = 0, fg = "#af3a03" })
vim.api.nvim_set_hl(0, "NeogitNotificationWarning", { bold = true, blend = 0, fg = "#af3a03" })
vim.api.nvim_set_hl(0, "NeogitNotificationError", { bold = true, blend = 0, fg = "#af3a03" })
