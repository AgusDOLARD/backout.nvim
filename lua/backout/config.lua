local M = {}

local defaults = {
    chars = "(){}[]`'\"<>",
}

M.opts = {}

M.charsTable = function()
    local c = {}
    for letter in M.opts.chars:gmatch(".") do
        table.insert(c, letter)
    end
    return c
end

M.setup = function(opts)
    M.opts = vim.tbl_deep_extend("force", {}, defaults, opts or {})
end

return M
