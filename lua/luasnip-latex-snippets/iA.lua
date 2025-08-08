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
    parse_snippet({ trig = "*[", name = "Equation (display)" }, "\\[ $0 \\]"),
    parse_snippet({ trig = "*(", name = "Equation (inline)" }, "\\( $0 \\)"),
    parse_snippet({ trig = "*e", name = "Equation env" }, "\\begin{equation}\n\t${1:${TM_SELECTED_TEXT}}\n\\end{equation}"),
    parse_snippet({ trig = "*a", name = "Equation env" }, "\\begin{align}\n\t${1:${TM_SELECTED_TEXT}}\n\\end{align}"),
    -- imap *l <Esc>viWSl
  }
end

return M
