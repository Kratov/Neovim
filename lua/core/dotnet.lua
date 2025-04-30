
-- lua/core/dotnet.lua

-- ─[ .NET Run with Logs Integration ]─────────────────
local telescope_builtin = require('telescope.builtin')

local function open_log_buffer()
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_get_name(buf) == 'Dotnet Logs' then
      return buf
    end
  end
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_name(buf, 'Dotnet Logs')
  vim.api.nvim_buf_set_option(buf, 'bufhidden', 'wipe')
  vim.cmd('botright split')
  vim.api.nvim_win_set_buf(0, buf)
  vim.api.nvim_win_set_height(0, 10)
  return buf
end

vim.keymap.set('n', '<leader>cr', function()
  telescope_builtin.find_files({
    prompt_title = 'Select .NET Project',
    search_dirs = { '.' },
    find_command = { 'fd', '--type', 'f', '--glob', '*.csproj', '--no-ignore-vcs', '--no-follow' },
    attach_mappings = function(prompt_bufnr, map)
      map('i', '<CR>', function()
        local entry = require('telescope.actions.state').get_selected_entry()
        require('telescope.actions').close(prompt_bufnr)
        local log_buf = open_log_buffer()
        vim.api.nvim_buf_set_lines(log_buf, 0, -1, false, {})

        local job_id = vim.fn.jobstart("dotnet run --project " .. entry.path, {
          stdout_buffered = false,
          stderr_buffered = false,
          on_stdout = function(_, data)
            if data then
              vim.api.nvim_buf_set_lines(log_buf, -1, -1, false, data)
              vim.api.nvim_command("normal! G")
            end
          end,
          on_stderr = function(_, data)
            if data then
              vim.api.nvim_buf_set_lines(log_buf, -1, -1, false, data)
              vim.api.nvim_command("normal! G")
            end
          end,
          on_exit = function(_, code)
            local msg = (code == 0) and 'Project ran successfully' or 'Project failed to run'
            vim.api.nvim_buf_set_lines(log_buf, -1, -1, false, { msg })
            vim.api.nvim_command("normal! G")
          end,
        })

        vim.api.nvim_create_autocmd("BufWipeout", {
          buffer = log_buf,
          callback = function()
            if job_id > 0 then
              vim.fn.jobstop(job_id)
              print("dotnet process killed")
            end
          end,
        })
      end)
      return true
    end,
  })
end, { desc = '[C]ode [R]un selected .NET project with Telescope' })
