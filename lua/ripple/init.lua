local M = {}

M.setup = function(opts)
	local default = {
		vertical_step_size = 1,
		horizontal_step_size = 1,
		keys = {
			expand_right = { "<C-right>", mode = { "n", "v" }, desc = "expand right" },
			expand_left = { "<C-left>", mode = { "n", "v" }, desc = "expand left" },
			expand_up = { "<C-up>", mode = { "n", "v" }, desc = "expand up" },
			expand_down = { "<C-down>", mode = { "n", "v" }, desc = "expand down" },
		},
	}

	local keys = vim.tbl_deep_extend("force", default.keys, (opts and opts.keys) or {})
	for func_name, args in pairs(keys) do
		if keys[func_name] then
			if type(args) == "string" then
				args = vim.tbl_deep_extend("force", default.keys[func_name], { args })
			elseif type(args) == "table" then
				args = vim.tbl_deep_extend("force", default.keys[func_name], args)
			end
			vim.keymap.set(args.mode, args[1], M[func_name], { desc = args.desc })
		end
	end

	M.vertical_step_size = opts.vertical_step_size or default.vertical_step_size
	M.horizontal_step_size = opts.horizontal_step_size or default.horizontal_step_size
end

-- Window resizing
--
-- :resize will first attempt to resize the current window by moving the bottom (or right) border. If that is
-- not possible, it will resize the window by moving the top (or left) border. This variable behavior is
-- pretty annoying, so the following implements a more consistent behavior by expanding the window in the
-- direction of the specified arrow key.

-- expand_up expands the window upwards by M.vertical_step_size.
function M.expand_up()
	local above_win_number = vim.fn.winnr("k")
	if above_win_number == vim.fn.winnr() then
		return
	end
	vim.fn.win_move_statusline(above_win_number, -M.vertical_step_size)
end

-- expand_down expands the window downwards by M.vertical_step_size.
function M.expand_down()
	local current_win_number = vim.fn.winnr()
	vim.fn.win_move_statusline(current_win_number, M.vertical_step_size)
end

-- expand_left expands the window to the left by M.horizontal_step_size.
function M.expand_left()
	local left_win_number = vim.fn.winnr("h")
	if left_win_number == vim.fn.winnr() then
		return
	end
	vim.fn.win_move_separator(left_win_number, -M.horizontal_step_size)
end

-- expand_right expands the window to the right by M.horizontal_step_size.
function M.expand_right()
	local current_win_number = vim.fn.winnr()
	vim.fn.win_move_separator(current_win_number, M.horizontal_step_size)
end

return M
