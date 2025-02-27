local M = {}
local config = require("backout.config")
local log = require("backout.logger")

--- Find the characters in line
--- @param line string :The line string
--- @param start number :The start position to search
--- @return number|nil :The found character position and the character itself
local findCharacter = function(line, start)
    log.trace("_findCharacter")
    start = math.max(start or 1, 1)
    return string.find(line, config.opts.chars, start)
end

--- Find the characters in line, searching backward
--- @param line string :The line string
--- @param start number :The start position to search (1-based index)
--- @return number|nil :The found character position
local findCharacterBackward = function(line, start)
    log.trace("_findCharacterBackward")
    start = math.min(math.max(start or #line, 1), #line)

    -- Reverse the string and start searching forward
    local reversed_line = line:sub(1, start):reverse()
    local found_pos_in_rev = string.find(reversed_line, config.opts.chars)

    if found_pos_in_rev then return start - found_pos_in_rev + 1 end
end

--- Move the cursor in command-line mode.
--- @param pos number :new position of cursor
local moveCommandMode = function(pos)
    log.trace("_moveCommandMode")
    -- This is either not working or idk how to use it ???
    -- vim.fn.setcmdpos(pos)
    --
    -- Dirty fix till i find how to make it work...
    local n = vim.fn.getcmdpos()
    log.fmt_info("cursor: %d, pos: %d", n, pos)

    local diff = (pos - n) + 1 -- +1 to move further away
    log.fmt_info("diff: %d", diff)
    local direction = diff > 0 and "<right>" or "<left>"
    log.fmt_info("direction: %s", direction)

    local keys = string.rep(direction, math.abs(diff))
    local termcode = vim.api.nvim_replace_termcodes(keys, true, true, true)
    vim.api.nvim_feedkeys(termcode, "n", true)
end

--- Move the cursor in insert mode.
--- @param row number :The row to move to
--- @param col number :The column to move to
local moveInsertMode = function(row, col)
    log.trace("_moveInsertMode")
    vim.api.nvim_win_set_cursor(0, { row, col })
end

--- Move cursor
--- @param row number :The row to move to
--- @param col number :The column to move to
local moveCursor = function(row, col)
    log.trace("_moveCursor")
    log.fmt_info("moving to: %d,%d", row, col)
    if row == -1 then
        moveCommandMode(col)
    else
        moveInsertMode(row, col)
    end
end

--- Get the cursor position
---@return number,number :The row and column of the cursor
local getCursor = function()
    local row, col = -1, -1
    log.trace("_getCursor")
    local mode = vim.fn.mode()
    log.fmt_info("mode: %s", mode)
    if mode == "c" then
        col = vim.fn.getcmdpos()
    else
        local cursor = vim.fn.getcurpos(0) -- Get cursor position (buf, row, col, off)
        row, col = cursor[2], cursor[3]
    end
    log.fmt_info("cursor: %d,%d", row, col)
    return row, col
end

--- Get the line string at the cursor position
--- @return string :The line string
local getLine = function()
    log.trace("_getLine")
    if vim.fn.mode() == "c" then return vim.fn.getcmdline() end
    return vim.fn.getline(".")
end

M.out = function()
    log.trace("_out")
    local row, col = getCursor()
    local line = getLine()
    log.fmt_info("line: %s", line)

    local found = findCharacter(line, col)
    if found then
        log.info("found:", found)
        moveCursor(row, found)
    else
        log.fmt_warn("no character found @ row: %d", row)
    end
    log.info("moved out")
end

M.back = function()
    log.trace("_back")
    local row, col = getCursor()
    local line = getLine()
    log.fmt_info("line: %s", line)

    local found = findCharacterBackward(line, col - 1)
    if found then
        log.info("found:", found)
        moveCursor(row, found - 1)
    else
        log.fmt_warn("no character found @ row: %d", row)
    end
    log.info("moved back")
end

return M
