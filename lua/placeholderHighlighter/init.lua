local M = {}

local defaults = {
  languages = { "c", "cpp" }, -- Let's focus on C/C++ for now
  highlight = "PlaceholderPrintf",
}

M.config = vim.deepcopy(defaults)

-- 诊断模式：直接高亮整个字符串，而不是注入
local diagnostic_query = [[
  (argument_list
    (string_literal) @PlaceholderPrintf . (_)
    (#match? @PlaceholderPrintf ".*%%.*")
  )
]]

function M.setup(opts)
  M.config = vim.tbl_deep_extend("force", M.config, opts or {})

  local parser_configs = require("nvim-treesitter.parsers").get_parser_configs()

  for _, lang in ipairs(M.config.languages) do
    if parser_configs[lang] then
      pcall(function()
        -- 注意：这里我们使用的是 highlights 查询，而不是 injections
        local query = vim.treesitter.query.parse(lang, diagnostic_query)
        if query then
          vim.treesitter.query.set(lang, "highlights", query:concat())
        end
      end)
    end
  end

  vim.api.nvim_command("highlight default link PlaceholderPrintf " .. M.config.highlight)
  vim.notify("placeholderHighlighter.nvim in DIAGNOSTIC mode!", vim.log.levels.WARN)
end

return M