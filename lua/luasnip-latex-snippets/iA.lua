local M = {}

local ls = require("luasnip")

function M.retrieve(not_math)
  local utils = require("luasnip-latex-snippets.util.utils")
  local pipe = utils.pipe

  local parse_snippet = ls.extend_decorator.apply(ls.parser.parse_snippet, {
    wordTrig = false,
    condition = pipe({ not_math }),
  }) --[[@as function]]

  return {
    -- Double/repeat press snippets
    parse_snippet({ trig = '*"', name = "Double quotes" }, "\\enquote{${1:${TM_SELECTED_TEXT}}}${0}"),
    parse_snippet({ trig = "*'", name = "Single quotes" }, "\\enquote*{${1:${TM_SELECTED_TEXT}}}${0}"),
    parse_snippet({ trig = "*[", name = "Equation" }, "\\[ $0 \\]"),
    parse_snippet({ trig = "*$", name = "Equation env" }, "\\begin{equation}\n\t$1\n\\end{equation}"),
  }
end

return M
