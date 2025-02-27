-- :nmap <leader>rr :lua require("backout.config").reload()<CR>
--
local M = {}

local defaults = {
    chars = "(){}[]`'\"<>",
    logLevel = "error",
    multiLine = true,
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
    require("backout.logger").new({ level = M.opts.logLevel }, true)
end

return M
