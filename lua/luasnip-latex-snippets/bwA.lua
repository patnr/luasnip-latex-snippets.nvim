local ls = require("luasnip")
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local fmta = require("luasnip.extras.fmt").fmta

-- copied from luasnip-latex-snippets.util.utils
local function is_env(name) 
    local is_inside = vim.fn['vimtex#env#is_inside'](name)
    return (is_inside[1] > 0 and is_inside[2] > 0)
end
local function is_math()
  return vim.fn["vimtex#syntax#in_mathzone"]() == 1
end

local M = {}

function M.retrieve(not_math)
  local utils = require("luasnip-latex-snippets.util.utils")
  local pipe = utils.pipe

  local conds = require("luasnip.extras.expand_conditions")
  local condition = pipe({ conds.line_begin, not_math })

  local parse_snippet = ls.extend_decorator.apply(ls.parser.parse_snippet, {
    condition = condition,
  }) --[[@as function]]

  local s = ls.extend_decorator.apply(ls.snippet, {
    condition = condition,
  }) --[[@as function]]

  return {
    s(
      { trig = "ali", name = "Align" },
      { t({ "\\begin{align*}", "\t" }), i(1), t({ "", ".\\end{align*}" }) }
    ),

    s(
      {
        trig = "eq_env",
        dscr = "Equation environment",
        regTrig = false,
        priority = 100,
        snippetType = "autosnippet",
      },
      fmta([[
      \begin{equation}
          \label{eq:<>}
          <>
          \,.<>
      \end{equation}
      ]], {
          i(1),
          i(2),
          i(3),
        }
      )
    ),

    s(
      { trig = "-- ", name = "itemize" },
      fmta([[
        \begin{itemize}
          \item <>
        \end{itemize}
        ]], { i(0), })
    ),
    s({trig = "- ", name = "\\item",
      condition=function () return is_env("itemize") and not is_math() end},
      {t("\\item "), i(0),
        -- Fix issue: \item does not get de-indented when expanded via snippet.
        -- https://github.com/SirVer/ultisnips/issues/913#issuecomment-392086829
        f(function(_, _) vim.cmd[[call feedkeys("\<C-f>")]] end, {})}),

    parse_snippet({ trig = "beg", name = "begin{} / end{}" }, "\\begin{$1}\n\t$0\n\\end{$1}"),
    parse_snippet({ trig = "case", name = "cases" }, "\\begin{cases}\n\t$1\n\\end{cases}"),

    s({ trig = "bigfun", name = "Big function" }, {
      t({ "\\begin{align*}", "\t" }),
      i(1),
      t(":"),
      t(" "),
      i(2),
      t("&\\longrightarrow "),
      i(3),
      t({ " \\", "\t" }),
      i(4),
      t("&\\longmapsto "),
      i(1),
      t("("),
      i(4),
      t(")"),
      t(" = "),
      i(0),
      t({ "", ".\\end{align*}" }),
    }),
  }
end

return M
