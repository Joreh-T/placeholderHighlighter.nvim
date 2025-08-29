
local M = {}

local defaults = {
  languages = { "c", "cpp", "go", "rust", "python" },
  highlight = "TSPrintf",
}

M.config = vim.deepcopy(defaults)

-- 修正后的、语法正确的查询
local final_query = [[
  (argument_list
    (string_literal) @format_string . (_)
    (#match? @format_string ".*%%.*")
    (#set! "injection.language" "c")
    (#set! "injection.content" @format_string)
  )
]]

function M.setup(opts)
  M.config = vim.tbl_deep_extend("force", M.config, opts or {})

  local parser_configs = require("nvim-treesitter.parsers").get_parser_configs()

  for _, lang in ipairs(M.config.languages) do
    if parser_configs[lang] then
      pcall(function()
        local query = vim.treesitter.query.parse(lang, final_query)
        if query then
          vim.treesitter.query.set(lang, "injections", query:concat())
        end
      end)
    end
  end

  vim.api.nvim_command("highlight default link PlaceholderPrintf " .. M.config.highlight)
  vim.notify("placeholderHighlighter.nvim loaded with CORRECTED strategy!", vim.log.levels.INFO)
end

return M
