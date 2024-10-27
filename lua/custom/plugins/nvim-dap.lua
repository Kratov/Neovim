
-- Override function for JSON error handling in nvim-dap's session
-- Uncomment this function definition if you need to persist this in an external file, such as in `after/plugin/dap_override.lua`

-- function Session:handle_body(body)
--   -- Attempt to decode JSON, and handle decoding errors
--   local success, decoded = pcall(json_decode, body)
--   if not success then
--     log.error("JSON decode error: ", decoded)  -- Log the error if decoding fails
--     return  -- Exit early if decoding fails to avoid further processing
--   end

--   log.debug(self.id, decoded)
--   local listeners = dap().listeners
--   if decoded.request_seq then
--     local callback = self.message_callbacks[decoded.request_seq]
--     local request = self.message_requests[decoded.request_seq]
--     self.message_requests[decoded.request_seq] = nil
--     self.message_callbacks[decoded.request_seq] = nil
--     if not callback then
--       log.error('No callback found. Did the debug adapter send duplicate responses?', decoded)
--       return
--     end
--     if decoded.success then
--       vim.schedule(function()
--         for _, c in pairs(listeners.before[decoded.command]) do
--           c(self, nil, decoded.body, request, decoded.request_seq)
--         end
--         callback(nil, decoded.body, decoded.request_seq)
--         for _, c in pairs(listeners.after[decoded.command]) do
--           c(self, nil, decoded.body, request, decoded.request_seq)
--         end
--       end)
--     else
--       vim.schedule(function()
--         local err = { message = decoded.message; body = decoded.body; }
--         for _, c in pairs(listeners.before[decoded.command]) do
--           c(self, err, nil, request, decoded.request_seq)
--         end
--         callback(err, nil, decoded.request_seq)
--         for _, c in pairs(listeners.after[decoded.command]) do
--           c(self, err, nil, request, decoded.request_seq)
--         end
--       end)
--     end
--   elseif decoded.event then
--     local callback = self['event_' .. decoded.event]
--     vim.schedule(function()
--       local event_handled = false
--       for _, c in pairs(listeners.before['event_' .. decoded.event]) do
--         event_handled = true
--         c(self, decoded.body)
--       end
--       if callback then
--         event_handled = true
--         callback(self, decoded.body)
--       end
--       for _, c in pairs(listeners.after['event_' .. decoded.event]) do
--         event_handled = true
--         c(self, decoded.body)
--       end
--       if not event_handled then
--         log.warn('No event handler for ', decoded)
--       end
--     end)
--   elseif decoded.type == 'request' then
--     local handler = self.handlers.reverse_requests[decoded.command]
--     if handler then
--       handler(self, decoded)
--     else
--       log.warn('No handler for reverse request', decoded)
--     end
--   else
--     log.warn('Received unexpected message', decoded)
--   end
-- end

-- debug.lua
return {
    'mfussenegger/nvim-dap',
    dependencies = {
        'rcarriga/nvim-dap-ui',
        'williamboman/mason.nvim',
        'jay-babu/mason-nvim-dap.nvim',
        'leoluz/nvim-dap-go',
        'microsoft/vscode-js-debug',
        'theHamsta/nvim-dap-virtual-text',
    },
    config = function()
        local dap = require 'dap'
        local dapui = require 'dapui'



        -- Mason setup for nvim-dap
        require('mason-nvim-dap').setup {
            automatic_setup = true,
            handlers = {},
            ensure_installed = {
                'cpp',
                'csharp',
                'go',
                'java',
                'javascript',
                'python',
                'rust',
                'typescript',
            },
        }

        -- Redirect DAP errors to a log buffer
        local function log_dap_errors(err)
            local log_buf = vim.api.nvim_create_buf(false, true)
            vim.api.nvim_buf_set_lines(log_buf, 0, -1, false, { "DAP Error: " .. err })
        end

        -- Set the log level for minimal interruption
        dap.set_log_level('ERROR')

        -- Setup error handling in event listeners
        dap.listeners.after.event_initialized['dapui_config'] = function()
            pcall(dapui.open)
        end
        dap.listeners.before.event_terminated['dapui_config'] = function()
            pcall(dapui.close)
        end
        dap.listeners.before.event_exited['dapui_config'] = function()
            pcall(dapui.close)
        end

        -- Configuration for C# debugging with netcoredbg
        
        dap.configurations.cs = {
        {
            type = 'coreclr',
            name = 'Launch - .NET Core',
            request = 'launch',
            program = function()
                local dll_files = vim.fn.glob(vim.fn.getcwd() .. '/bin/Debug/**/*.dll', false, true)
                table.sort(dll_files, function(a, b) return vim.fn.getftime(a) > vim.fn.getftime(b) end)
                return dll_files[1]
            end,
            console = 'integratedTerminal',  -- Use integrated terminal for output
            internalConsoleOptions = 'openOnSessionStart',  -- Open console at session start
        },
        }


        -- Keymaps setup with error handling
        local function setup_keymaps()
            local status, _

            status, _ = pcall(function() vim.keymap.set('n', '<F5>', dap.continue, { desc = 'Debug: Start/Continue' }) end)
            if not status then log_dap_errors("Error setting <F5> mapping") end

            status, _ = pcall(function() vim.keymap.set('n', '<F6>', dap.step_into, { desc = 'Debug: Step Into' }) end)
            if not status then log_dap_errors("Error setting <F6> mapping") end

            status, _ = pcall(function() vim.keymap.set('n', '<F7>', dap.step_over, { desc = 'Debug: Step Over' }) end)
            if not status then log_dap_errors("Error setting <F7> mapping") end

            status, _ = pcall(function() vim.keymap.set('n', '<F8>', dap.step_out, { desc = 'Debug: Step Out' }) end)
            if not status then log_dap_errors("Error setting <F8> mapping") end

            local debug_prefix = "<leader>D"
            status, _ = pcall(function() vim.keymap.set('n', debug_prefix .. 'b', dap.toggle_breakpoint, { desc = 'Debug: Toggle Breakpoint' }) end)
            if not status then log_dap_errors("Error setting breakpoint toggle mapping") end

            status, _ = pcall(function()
                vim.keymap.set('n', debug_prefix .. 'B', function()
                    dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ')
                end, { desc = 'Debug: Set Conditional Breakpoint' })
            end)
            if not status then log_dap_errors("Error setting conditional breakpoint mapping") end

            vim.keymap.set('n', '<F9>', dapui.toggle, { desc = 'Debug: Toggle UI' })
            vim.keymap.set('n', debug_prefix .. 'h', require('dap.ui.widgets').hover, { desc = 'Debug: Hover Variable' })
        end

        setup_keymaps()

        dapui.setup {
            icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
            controls = {
                icons = {
                    pause = '⏸',
                    play = '▶',
                    step_into = '⏎',
                    step_over = '⏭',
                    step_out = '⏮',
                    step_back = 'b',
                    run_last = '▶▶',
                    terminate = '⏹',
                    disconnect = '⏏',
                },
            },
        }

        require('dap-go').setup()
        require("nvim-dap-virtual-text").setup {
            enabled = true,
            enable_virtual_text = true,
            highlight_changed_variables = true,
            highlight_new_as_changed = true,
        }
    end,
}

