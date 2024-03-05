local ls = require("luasnip")
local utils = require("luasnip-latex-snippets.util.utils")
local pipe = utils.pipe

local i = ls.insert_node
local fmta = require("luasnip.extras.fmt").fmta

local M = {}

function M.retrieve(is_math, not_math)
  local parse_snippet = ls.extend_decorator.apply(ls.parser.parse_snippet, {
    -- condition = pipe({ not_math }),
  }) --[[@as function]]
  local s = ls.extend_decorator.apply(ls.snippet, {
    -- condition = condition,
  }) --[[@as function]]

  return {
    parse_snippet({ trig = "verb", name = "Verbatim inline (use any delimiter)" }, "\\verb|$1|$0"),
    parse_snippet({ trig = "verbatim", name = "Verbatim env (may contain newlines)" }, "\\begin{verbatim}\n\t$1\n\\end{verbatim}$0"),

    -- From csquotes. Supports babel, nesting, etc.
    parse_snippet({ trig = "quote_inline", name = "Quote -- inline (package csquotes)" },
      "\\textquote[${1:citation}][${2:punctuation}]{${3:body}}$0"),
    parse_snippet({ trig = "quote_auto", name = "Quote -- inline if short, block if long (package csquotes)" },
      "\\blockquote[${1:citation}][${2:punctuation}]{${3:body}}$0"),
    -- parse_snippet({ trig = "quote_block", name = "Quote -- block (package csquotes)" },
    --   "\\begin{displayquote}\n\t$1\n\\end{displayquote}$0"),
    -- Equivalent (seems like) implementation
    s(
      {
        trig = "quote_block",
        dscr = "Quote -- block (package csquotes)",
      },
      fmta([[
      \begin{verbatim}
          <>
      \end{verbatim}
      ]], {
          i(1),
        }
      )
    ),
    -- Builtin
    parse_snippet({ trig = "quote_builtin_inline", name = "Inline quote (builtin)" },
      "\\begin{quote}\n\t$1\n\\end{quote}$0"),
    parse_snippet({ trig = "quote_builtin_block", name = "Block quote (builtin)" },
      "\\begin{quotation}\n\t$1\n\\end{quotation}$0"),

  }
end

return M
