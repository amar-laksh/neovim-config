local telescope_status_ok, telescope = pcall(require, 'telescope')
if not telescope_status_ok then
    return
end

telescope.setup({
    defaults = {
        file_ignore_patterns = { ".ccls-cache", ".git" }
    },
    extensions = {
        emoji = {
            action = function(emoji)
                vim.api.nvim_put({ emoji.value }, 'c', false, true)
            end,
        }
    },

})

telescope.load_extension('file_browser')
telescope.load_extension('hoogle') -- Haskell hackage docs
telescope.load_extension('dap')
require("telescope").load_extension("emoji")

-- local pickers = require "telescope.pickers"
-- local previewers = require "telescope.previewers"
-- local finders = require "telescope.finders"
-- local actions = require "telescope.actions"
-- local action_state = require "telescope.actions.state"
-- local conf = require "telescope.config".values

-- Zeal = function(what)
--     local opts = {}
--     pickers.new(opts, {
--         prompt_title = "zeal",
--         results_title = what,
--         finder = finders.new_oneshot_job({ "zeal-cli", what }, opts),
--         sorter = conf.generic_sorter(opts),
--         previewer = previewers.new_termopen_previewer({
--             get_command = function(entry, _)
--                 return { 'zeal-cli', what, entry.value }
--             end
--         }),
--         attach_mappings = function(prompt_bufnr, _)
--             actions.select_default:replace(function()
--                 actions.close(prompt_bufnr)
--                 local selection = action_state.get_selected_entry()
--                 os.execute("tmux new-window zeal-cli " .. what .. " " .. selection.value)
--             end)
--             return true
--         end,
--     }):find()
-- end
--
-- vim.api.nvim_set_keymap(
--     "n",
--     "<space>z",
--     ":lua Zeal('boost')<cr>",
--     { noremap = true }
-- )
