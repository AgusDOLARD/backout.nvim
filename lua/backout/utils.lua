local M = {}
local config = require("backout.config")
local logger = require("backout.logger")

--- Find the characters in line
--- @param line: string The line string
--- @param start: number The start position to search
--- @return number | nil :The found character position and the character itself
local findCharacter = function(line, start)
    start = math.max(start or 1, 1)
    return string.find(line, config.opts.chars, start)
end

---@param row number
---@param col number
local moveCursor = function(row, col)
    vim.api.nvim_win_set_cursor(0, { row, col })
end

--- Get the cursor position
---@return number, number :The row and column of the cursor
local getCursor = function()
    local cursor = vim.fn.getcurpos(0) -- Get cursor position (buf, row, col, off)
    return cursor[2], cursor[3]
end

M.out = function()
    local row, col = getCursor()
    logger.debug("cursor @" .. row .. "," .. col)
    local line = vim.fn.getline(row)

    local found = findCharacter(line, col)
    if found then
        moveCursor(row, found)
    else
        logger.warn("No character found in the line.")
    end
end

return M
