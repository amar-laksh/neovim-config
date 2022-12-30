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
    ensure_installed = { 'org' },
    org_agenda_files = { '~/Documents/org/*' },
    org_default_notes_file = '~/Documents/org/refile.org',
    mappings = {
        global = {
            org_timestamp_up = '+',
            org_timestamp_down = '-',
            org_agenda = '<space>oa',
            org_capture = '<space>oc'
        },
    },
    org_deadline_warning_days = 1,
    org_capture_templates = {
        t = {
            description = 'Todo task',
            template = '* TODO %?\n  %u\n',
            target = '~/Documents/org/Todos.org',
        },
        d = {
            description = 'Todo tasks with deadlines',
            template = '* TODO %?\n  %u DEADLINE: %t\n',
            target = '~/Documents/org/Deadlines.org',
        },
        n = {
            description = 'Notes',
            template = '* %?\n  %u\n',
            target = '~/Documents/org/Notes.org'
        },
        r = {
            description = 'Reminder',
            template = '* Reminder: %?\n  DEADLINE: %T\n',
            target = '~/Documents/org/Reminders.org'
        },
        b = {
            description = 'Birthdays',
            template = '* %?\n  <%<%Y-%m-%d %a +1y>>\n',
            target = '~/Documents/org/Birthdays.org'
        },
        e = {
            description = 'Events',
            template = '* %?\n  %T\n',
            target = '~/Documents/org/Calendar.org',
        },
        j = {
            description = 'Journal',
            template = '** %t\n:PROPERTIES:\n' ..
                ':runningTime: %^{running(mins)}\n' ..
                'runningDistance: %^{running(kms)}\n' ..
                ':sleep: %^{sleep(hours)}\n' ..
                ':mood: %^{mood(1-10 scale)}\n:END:%?\n',
            target = '~/Documents/org/journal/Journal.org',
        },
        w = {
            description = 'Writing',
            template = '%?\n  %t\n',
            target = '~/Documents/org/journal/Writing.org',
        },

    }
}
