local M = {}
local config = require("backout.config")
local logger = require("backout.logger")

---Get the character from a given row and column
---@param row number
---@param col number
---@return string|nil
local function getChar(row, col)
    if row < 1 or col < 1 then return nil end
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

---Iteratively search for the closest character
---@param forward boolean if true means going forward else going backwards
---@param row number initial row number
---@param col number initial column number
---@return number,number # return row, column of found character else returns -1,-1
local function findChar(forward, row, col)
    local step = forward and 1 or -1
    local max_row = vim.fn.line("$")

    while row >= 1 and row <= max_row do
        local max_col = vim.fn.col({ row, "$" }) - 1
        local min_col = 1

        for i = col, forward and max_col or min_col, step do
            local char = getChar(row, i)
            if char and isKnownCharacter(char) then
                logger.debug("char: " .. tostring(char) .. " found on " .. row .. ":" .. i)
                return row, i
            end
        end

        row = row + step
        col = forward and min_col or max_col
    end
    return -1, -1
end

---@param row number
---@param col number
local function moveCursor(row, col)
    vim.api.nvim_win_set_cursor(0, { row, col })
end


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
