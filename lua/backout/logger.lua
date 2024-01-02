local config = require("backout.config")

local M = {}

--- @param msg string
--- @param hl? string
M.log = function(msg, hl) vim.api.nvim_echo({ { "backout.nvim" .. ": ", hl }, { msg } }, true, {}) end

--- @param msg string
M.warn = function(msg) M.log(msg, "WarningMsg") end

--- @param msg string
M.debug = function(msg)
    if config.opts.debug then M.log(msg, "Todo") end
end

return M
