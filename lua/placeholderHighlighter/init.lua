
local M = {}

-- 默认配置
local defaults = {
  -- 为哪些语言启用此功能
  -- Tree-sitter 的节点名称在很多语言中是通用的 (call_expression, string_literal)
  languages = { "c", "cpp", "go", "rust", "python" },

  -- 用于高亮占位符的组
  highlight = "TSPrintf",
}

M.config = vim.deepcopy(defaults)

-- 这是我们新的、基于启发式规则的通用查询
-- 它会匹配一个函数调用，其中包含一个字符串字面量，
-- 并且该字符串后面至少还有一个参数，同时字符串本身必须包含'%'字符。
local generic_query = [[
  (call_expression
    arguments: (argument_list
      (string_literal) @format_string
      .  -- The dot is an anchor, meaning the next node is a sibling
      (_) -- Match any node immediately following the string literal
    )
    (#match? @format_string ".*%%.*") -- Check if the string content contains a literal '%'
    (#set! "injection.language" "c") -- We can inject C grammar, as its format specifiers are standard
    (#set! "injection.content" @format_string))
]]

function M.setup(opts)
  M.config = vim.tbl_deep_extend("force", M.config, opts or {})

  -- 获取已安装的 treesitter 解析器配置
  local parser_configs = require("nvim-treesitter.parsers").get_parser_configs()

  -- 循环为所有支持的语言设置查询
  for _, lang in ipairs(M.config.languages) do
    -- 检查该语言的解析器是否已安装
    if parser_configs[lang] then
      pcall(function()
        local query = vim.treesitter.query.parse(lang, generic_query)
        if query then
          vim.treesitter.query.set(lang, "injections", query:concat())
        end
      end)
    end
  end

  -- 定义高亮组
  vim.api.nvim_command("highlight default link PlaceholderPrintf " .. M.config.highlight)

  vim.notify("placeholderHighlighter.nvim loaded with generic strategy!", vim.log.levels.INFO)
end

return M
