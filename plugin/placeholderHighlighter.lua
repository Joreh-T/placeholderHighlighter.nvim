
-- 仅在检测到 treesitter 时加载
if not pcall(require, "nvim-treesitter") then
  vim.notify("placeholderHighlighter.nvim requires nvim-treesitter", vim.log.levels.WARN)
  return
end

-- 使用默认配置调用 setup
require('placeholderHighlighter').setup()
