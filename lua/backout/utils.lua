local M = {}
local config = require("backout.config")

---@param position number
---@return string
local function getCharacterPositionOnLine(position)
    local lineString = vim.api.nvim_get_current_line()
    if lineString ~= "" and position <= #lineString then
        return lineString:sub(position, position)
    end

    return ""
end

---@param char string
---@return boolean
local function isKnownCharacter(char)
    local knownCharacters = config.charsTable()
    for _, v in ipairs(knownCharacters) do
        if char == v then
            return true
        end
    end
    return false
end

---@param forward boolean
---@return number
M.findChar = function(forward)
    local step = forward and 1 or -1
    local position = vim.api.nvim_win_get_cursor(0)[2] + step

    local found = false
    repeat
        local char = getCharacterPositionOnLine(position)
        found = isKnownCharacter(char)
        if not found then
            position = position + step
        end
    until found or char == ""

    return position
end

---@param column number
M.moveCursor = function(column)
    local row = vim.api.nvim_win_get_cursor(0)[1]
    vim.api.nvim_win_set_cursor(0, { row, column })
end

return M
