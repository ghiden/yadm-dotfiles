---@param opts table The options passed by the Neovim user command
local function sum_last_word_in_selection(opts)
  -- 1. Extract lines safely from the command arguments (opts)
  -- nvim_buf_get_lines is 0-indexed, but opts.line1 is 1-indexed.
  local start_line = opts.line1 - 1
  local end_line = opts.line2

  -- 2. Fetch the lines from the current buffer
  local lines = vim.api.nvim_buf_get_lines(0, start_line, end_line, false)

  -- 3. Parse and calculate
  local total = 0
  for _, line in ipairs(lines) do
    -- Grab the last chunk of non-whitespace characters
    local last_word = string.match(line, "%S+%s*$")

    if last_word then
      -- Extract the numeric portion (handles negatives and decimals)
      local num_str = string.match(last_word, "%-?%d+%.?%d*")
      if num_str then
        total = total + tonumber(num_str)
      end
    end
  end

  -- 4. Output the result
  local formatted_total = string.format("%.2f", total)

  local output_string = "Total: $" .. formatted_total

  -- Write to the '*' register (which your 'unnamed' setting is syncing with)
  pcall(vim.fn.setreg, '*', formatted_total)

  -- Write to the default Neovim register as a backup
  pcall(vim.fn.setreg, '"', formatted_total)
  -- API args: (buffer, start_idx, end_idx, strict_indexing, replacement_lines_array)
  vim.api.nvim_buf_set_lines(0, end_line, end_line, false, { output_string })
end

-- Create the user command
vim.api.nvim_create_user_command('CalcSum', sum_last_word_in_selection, { range = true })

-- When you press `:`, Neovim automatically inserts `'<,'>` for the visual range.
-- The resulting command `:'<,'>CalcSum` passes the correct line1 and line2 to opts.
vim.keymap.set('v', '<leader>cs', ':CalcSum<CR>', { silent = true, desc = "Sum last word of rows" })

