local M = {}
local config = require("backout.config")
local logger = require("backout.logger")

---@param position number
---@return string
local function getCharacterPositionOnLine(position)
    local lineString = vim.api.nvim_get_current_line()
    if position <= #lineString then
        local char = lineString:sub(position, position)
        return char
    elseif string.len(lineString) == 0 then
        logger.debug("Empty line")
        return ""
    else
        logger.debug("Cannot find any character on line: " .. lineString)
        return ""
    end
end

---@param char string
---@return boolean
local function isKnownCharacter(char)
    local knownCharacters = config.charsTable()
    for _, v in ipairs(knownCharacters) do
        if char == v then return true end
    end
    return false
end

---@param forward boolean
---@return number
local function findChar(forward)
    local col = vim.fn.col
    local step = forward and 1 or -1
    local position = forward and col(".") or col(".") + step

    local found = false
    repeat
        local char = getCharacterPositionOnLine(position)
        found = isKnownCharacter(char)
        if not found then position = position + step end
    until found or char == ""
    if found then
        logger.debug("char found on col:" .. position)
        return position
    else
        return -1
    end
end

---@param column number
local function moveCursor(column)
    local row = vim.fn.line(".")
    logger.debug("Moving cursor to " .. row .. ":" .. column)
    vim.api.nvim_win_set_cursor(0, { row, column })
end

M.back = function()
    local pos = findChar(false) - 1
    if pos >= 0 then moveCursor(pos) end
end

M.out = function()
    local pos = findChar(true)
    if pos >= 0 then moveCursor(pos) end
end

return M
