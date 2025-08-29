# placeholderHighlighter.nvim

A simple, generic Neovim plugin to highlight printf-style format specifiers (`%d`, `%s`, etc.) in any function call across multiple languages.

## How it works (Heuristic Approach)

This plugin uses a smart heuristic with Tree-sitter. It doesn't care about function names. Instead, it highlights placeholders in a string if that string meets the following criteria:
1. It is part of a function call.
2. It contains a `%` character.
3. It is followed by at least one more argument in the function call.

This allows for automatic highlighting in functions like `log("user %s", user_id)` without any configuration.

## Installation

Using `lazy.nvim`:

```lua
{
  'your-username/placeholderHighlighter.nvim',
  event = "BufReadPre",
  config = true, -- No setup call needed for default config
}
```

## Configuration

You can override the default settings by passing a table to the `setup()` function.

Here are the default values:
```lua
require('placeholderHighlighter').setup({
  -- List of languages to apply the highlighting to
  languages = { "c", "cpp", "go", "rust", "python" },

  -- The highlight group to use for the placeholders.
  highlight = "TSPrintf",
})
```

### Example: Adding TypeScript support

```lua
require('placeholderHighlighter').setup({
  languages = { "c", "cpp", "go", "rust", "python", "typescript" },
})
```