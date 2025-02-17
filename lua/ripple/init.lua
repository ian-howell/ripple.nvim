local M = {}

M.setup = function(opts)

  local defaults = {
    expand_right = "<C-right>",
    expand_left = "<C-left>",
    expand_up = "<C-up>",
    expand_down = "<C-down>",
  }

  local keys = {}
  for key, default_key in pairs(defaults) do
    if opts and opts.keys then
      if opts.keys[key] then
        vim.keymap.set("n", opts.keys[key], M[key])
      elseif opts.keys[key] == nil then
        vim.keymap.set("n", default_key, M[key])
      end
    end
  end

end

-- Window resizing
--
-- :resize will first attempt to resize the current window by moving the bottom (or right) border. If that is
-- not possible, it will resize the window by moving the top (or left) border. This variable behavior is
-- pretty annoying, so the following implements a more consistent behavior by expanding the window in the
-- direction of the specified arrow key.

local function too_short(window_number)
	return vim.api.nvim_win_get_height(vim.fn.win_getid(window_number)) <= 2
end

local function too_narrow(window_number)
	return vim.api.nvim_win_get_width(vim.fn.win_getid(window_number)) <= 2
end

-- expand_up expands the window upwards by one line.
-- If it can't expand the window, it returns false.
function M.expand_up(window_number, depth)
	local current_win_number = window_number or vim.api.nvim_win_get_number(0)
	depth = depth or 1
	local above_win_number = vim.fn.winnr(depth .. "k")
	if current_win_number == above_win_number then
		-- This window is at the top edge, so it can't be expanded
		return false
	end
	-- If the window above the current window is too small, expand it first
	if too_short(above_win_number) then
		if not M.expand_up(above_win_number, depth + 1) then
			-- The window above can't be expanded, so the current window can't be expanded either
			return false
		end
	end
	vim.cmd(above_win_number .. "resize -1")
	return true
end

-- expand_down expands the window downwards by one line.
-- If it can't expand the window, it returns false.
function M.expand_down(window_number, depth)
	local current_win_number = window_number or vim.api.nvim_win_get_number(0)
	depth = depth or 1
	local below_win_number = vim.fn.winnr(depth .. "j")
	if current_win_number == below_win_number then
		-- This window is at the bottom edge, so it can't be expanded
		return false
	end
	-- If the window below the current window is too small, expand it first
	if too_short(below_win_number) then
		if not M.expand_down(below_win_number, depth + 1) then
			-- The window below can't be expanded, so the current window can't be expanded either
			return false
		end
	end
	vim.cmd(current_win_number .. "resize +1")
	return true
end

-- expand_left expands the window to the left by one column.
-- If it can't expand the window, it returns false.
function M.expand_left(window_number, depth)
	local current_win_number = window_number or vim.api.nvim_win_get_number(0)
	depth = depth or 1
	local left_win_number = vim.fn.winnr(depth .. "h")
	if current_win_number == left_win_number then
		-- This window is at the left edge, so it can't be expanded
		return false
	end
	-- If the window to the left of the current window is too narrow, expand it first
	if too_narrow(left_win_number) then
		if not M.expand_left(left_win_number, depth + 1) then
			-- The window to the left can't be expanded, so the current window can't be expanded either
			return false
		end
	end
	vim.cmd("vertical " .. left_win_number .. "resize -1")
	return true
end

-- expand_right expands the window to the right by one column.
-- If it can't expand the window, it returns false.
function M.expand_right(window_number, depth)
	local current_win_number = window_number or vim.api.nvim_win_get_number(0)
	depth = depth or 1
	local right_win_number = vim.fn.winnr(depth .. "l")
	if current_win_number == right_win_number then
		-- This window is at the right edge, so it can't be expanded
		return false
	end
	-- If the window to the right of the current window is too narrow, expand it first
	if too_narrow(right_win_number) then
		if not M.expand_right(right_win_number, depth + 1) then
			-- The window to the right can't be expanded, so the current window can't be expanded either
			return false
		end
	end
	vim.cmd("vertical " .. current_win_number .. "resize +1")
	return true
end

return M

-- vim: ts=2 sw=2 et
