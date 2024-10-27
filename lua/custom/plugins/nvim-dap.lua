
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
                preLaunchTask = function()
                    local cmd = 'dotnet build'
                    local result = vim.fn.system(cmd)
                    if vim.v.shell_error ~= 0 then
                        vim.notify('Build failed: ' .. result, vim.log.levels.ERROR)
                        return false
                    end
                    return true
                end,
                program = function()
                    local dll_files = vim.fn.glob(vim.fn.getcwd() .. '/bin/Debug/**/*.dll', false, true)
                    if #dll_files == 0 then
                        vim.notify('No .dll file found in build directory.', vim.log.levels.ERROR)
                        return nil
                    end
                    table.sort(dll_files, function(a, b)
                        return vim.fn.getftime(a) > vim.fn.getftime(b)
                    end)
                    return dll_files[1]
                end,
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

