local M = {}

local defaults = {
    chars = "(){}[]`'\"<>",
    debug = false,
}

M.opts = {}

--- Parse the chars from config to work with special characters
--- @param chars string
--- @return string :sanatized string
local parseChars = function(chars)
    local sanitized = string.gsub(
        chars,
        "[%[%]]",
        function(c) return "%" .. c end
    )
    return string.format("[%s]", sanitized)
end

M.setup = function(opts)
    M.opts = vim.tbl_deep_extend("force", {}, defaults, opts or {})
    M.opts.chars = parseChars(M.opts.chars)
end

return M
