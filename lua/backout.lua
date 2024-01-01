local M = {}
local utils = require("backout.utils")
local config = require("backout.config")

M.back = function()
    local pos = utils.findChar(false) - 1
    if pos >= 0 then
        utils.moveCursor(pos)
    end
end

M.out = function()
    local pos = utils.findChar(true)
    if pos >= 0 then
        utils.moveCursor(pos)
    end
end

M.setup = function(opts)
    config.setup(opts)
end

return M
