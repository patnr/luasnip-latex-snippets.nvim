local utils = require("luasnip-latex-snippets.util.utils")
local pipe = utils.pipe
local no_backslash = utils.no_backslash

local M = {}

local default_opts = {
  -- use_treesitter = vim.treesitter.highlighter.active[vim.api.nvim_get_current_buf()] ~= nil
  use_treesitter = true,  -- NB: Treesitter does not recognize math if vimtex syntax enabled
  allow_on_markdown = true,
}

M.setup = function(opts)
  opts = vim.tbl_deep_extend("force", default_opts, opts or {})

  local augroup = vim.api.nvim_create_augroup("luasnip-latex-snippets", {})
  -- Load for TeX
  vim.api.nvim_create_autocmd("FileType", {
    pattern = "tex",
    group = augroup,
    once = true,
    callback = function()
      local is_math = utils.with_opts(utils.is_math, opts.use_treesitter)
      local not_math = utils.with_opts(utils.not_math, opts.use_treesitter)
      M.setup_tex(is_math, not_math)
    end,
  })

  -- Load for Markdown
  if opts.allow_on_markdown then
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "markdown",
      group = augroup,
      once = true,
      callback = function()
        local is_math = utils.with_opts(utils.is_math, opts.use_treesitter)
        local not_math = utils.with_opts(utils.not_math, opts.use_treesitter)
        M.setup_markdown(is_math, not_math)
      end,
    })
  end
end

-- Collect autosnippets
local _autosnippets = function(is_math, not_math)
  local autosnippets = {}

  for _, s in ipairs({
    "math_rA_no_backslash",
    "math_wA_no_backslash",
    "math_iA_no_backslash",
    "math_iA",
    "math_wrA",
  }) do
    vim.list_extend(
      autosnippets,
      require(("luasnip-latex-snippets.%s"):format(s)).retrieve(is_math)
    )
  end

  for _, s in ipairs({
    "wA",
    "bwA",
    "iA",
    "iA_no_backslash",
  }) do
    vim.list_extend(
      autosnippets,
      require(("luasnip-latex-snippets.%s"):format(s)).retrieve(not_math)
    )
  end

  return autosnippets
end

-- Load for Tex
M.setup_tex = function(is_math, not_math)
  local ls = require("luasnip")
  ls.add_snippets("tex", {
    ls.parser.parse_snippet(
      { trig = "pac", name = "Package" },
      "\\usepackage[${1:options}]{${2:package}}$0"
    ),

    ls.parser.parse_snippet(
      { trig = "newcommand", name = "newcommand (macro)" },
      "\\newcommand{${1:name}}[${2:nargs}]{${3:implementation}}$0"
    ),

    ls.parser.parse_snippet({ trig = "lab", name = "\\label" }, "\\label{$1}$0"),

    -- ls.parser.parse_snippet({ trig = "nn", name = "Tikz node" }, {
    --   "$0",
    --   -- "\\node[$5] (${1/[^0-9a-zA-Z]//g}${2}) ${3:at (${4:0,0}) }{$${1}$};",
    --   "\\node[$5] (${1}${2}) ${3:at (${4:0,0}) }{$${1}$};",
    -- }),
  })

  local math_i = require("luasnip-latex-snippets/math_i").retrieve(is_math)

  ls.add_snippets("tex", math_i, { default_priority = 0 })

  local w = require("luasnip-latex-snippets/w").retrieve(is_math, not_math)
  ls.add_snippets("tex", w, { default_priority = 0 })

  ls.add_snippets("tex", _autosnippets(is_math, not_math), {
    type = "autosnippets",
    default_priority = 0,
  })
end

-- Load for Markdown
M.setup_markdown = function(is_math, not_math)
  local ls = require("luasnip")

  local autosnippets = {}
  for _, s in ipairs({
    "math_rA_no_backslash",
    "math_wA_no_backslash",
    "math_iA_no_backslash",
    "math_iA",
    "math_wrA",
  }) do
    vim.list_extend(
      autosnippets,
      require(("luasnip-latex-snippets.%s"):format(s)).retrieve(is_math)
    )
  end

  ls.add_snippets("markdown", autosnippets, {
    type = "autosnippets",
    default_priority = 0,
  })
end

return M
