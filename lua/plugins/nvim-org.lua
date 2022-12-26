local orgmode_status_ok, orgmode = pcall(require, 'orgmode')
if not orgmode_status_ok then
    return
end
local orgmode_utils = require('orgmode.utils')
local orgmode_popups = require('orgmode.notifications.notification_popup')

orgmode.setup_ts_grammar()

-- Treesitter configuration
orgmode.setup {
    notifications = {
        enabled = true,
        reminder_time = { 1, 5, 60 },
        notifier = function(tasks)
            local result = {}
            for _, task in ipairs(tasks) do
                orgmode_utils.concat(result, {
                    string.format('# %s (%s)', task.category, task.humanized_duration),
                    string.format('%s %s %s', string.rep('*', task.level), task.todo, task.title),
                    string.format('%s: <%s>', task.type, task.time:to_string())
                })
            end

            if not vim.tbl_isempty(result) then
                orgmode_popups:new({ content = result })
            end
        end,
    },
    highlight = {
        enable = true,
    },
    ensure_installed = { 'org' }, -- Or run :TSUpdate org
    org_agenda_files = { '~/Documents/org/*' },
    org_default_notes_file = '~/Documents/org/Notes.org',
    mappings = {
        global = {
            org_timestamp_up = '+',
            org_timestamp_down = '-'
        },
    },
    org_deadline_warning_days = 3,
    org_capture_templates = {
        t = {
            description = 'Todo task',
            template = '* TODO %?\n  %u',
            target = '~/Documents/org/Todos.org'
        },
        r = {
            description = 'Reminder',
            template = '* Reminder: %?\n  DEADLINE: %T',
            target = '~/Documents/org/Reminders.org'
        },
        b = {
            description = 'Birthdays',
            template = '* %?\n  <%<%Y-%m-%d %a +1y>>',
            target = '~/Documents/org/Birthdays.org'
        },
        e = {
            description = 'Events',
            template = '* %?\n  %T',
            target = '~/Documents/org/Calendar.org',
            headline = 'one-time'
        },
    }
}
