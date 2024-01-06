local M = {}
local config = require("backout.config")
local logger = require("backout.logger")

---Get the character from a given row and column
---@param row number
---@param col number
---@return string
local function getChar(row, col)
    local line = vim.fn.getline(row)
    return line:sub(col, col)
end

---Returns true if the given character is defined in opts.chars
---@param char string
---@return boolean
local function isKnownCharacter(char)
    local knownCharacters = config.charsTable()
    for _, v in ipairs(knownCharacters) do
        if char == v then return true end
    end
    return false
end

---Recursively search for the closest character
---@param forward boolean if true means going forward else going backwards
---@param row number initial row number
---@param col number initial column number
---@return number,number # return row, column of found character else returns -1,-1
local function findChar(forward, row, col)
    if row < 1 or row > vim.fn.line("$") then return -1, -1 end

    local step = forward and 1 or -1
    local function colLength(f) return f and vim.fn.col("$") or 1 end

    for i = col, colLength(forward), step do
        local char = getChar(row, i)
        if isKnownCharacter(char) then
            logger.debug("char: " .. char .. " found on " .. row .. ":" .. i)
            return row, i
        end
    end

    return findChar(forward, row + step, colLength(not forward))
end

---@param row number
---@param col number
local function moveCursor(row, col) vim.api.nvim_win_set_cursor(0, { row, col }) end

M.back = function()
    local cursor = vim.fn.getcurpos(0)
    local row, col = findChar(false, cursor[2], cursor[3] - 1)
    if row ~= -1 then moveCursor(row, col - 1) end
end

M.out = function()
    local cursor = vim.fn.getcurpos(0)
    local row, col = findChar(true, cursor[2], cursor[3])
    if row ~= -1 then moveCursor(row, col) end
end

return M
