
local M = {}

function M.setup(opts)
  -- 我们现在使用文件来查询，所以这里几乎什么都不用做
  -- 只需确保高亮组存在即可
  vim.api.nvim_command("highlight default link PlaceholderPrintf TSPrintf")
  vim.notify("placeholderHighlighter.nvim loaded with FILE-BASED strategy!", vim.log.levels.INFO)
end

return M
