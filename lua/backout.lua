local M = {}
local utils = require("backout.utils")
local config = require("backout.config")

M.back = utils.back
M.out = utils.out
M.setup = config.setup

return M
