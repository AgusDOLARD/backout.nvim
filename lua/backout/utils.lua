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

--- Find the characters in line, searching backward
--- @param line: string The line string
--- @param start: number The start position to search (1-based index)
--- @return number | nil :The found character position
local findCharacterBackward = function(line, start)
    start = math.min(math.max(start or #line, 1), #line)

    -- Reverse the string and start searching forward
    local reversed_line = line:sub(1, start):reverse()
    local found_pos_in_rev = string.find(reversed_line, config.opts.chars)

    if found_pos_in_rev then return start - found_pos_in_rev + 1 end
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

M.back = function()
    local row, col = getCursor()
    logger.debug("cursor @" .. row .. "," .. col)
    local line = vim.fn.getline(row)

    local found = findCharacterBackward(line, col - 1)
    if found then
        moveCursor(row, found - 1)
    else
        logger.warn("No character found in the line.")
    end
end

return M
