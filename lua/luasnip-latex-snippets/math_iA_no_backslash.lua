-- "bar" --> "\bar{.}"
local M = {}

local ls = require("luasnip")

function M.retrieve(is_math)
  local utils = require("luasnip-latex-snippets.util.utils")
  local pipe, no_backslash = utils.pipe, utils.no_backslash

  local parse_snippet = ls.extend_decorator.apply(ls.parser.parse_snippet, {
    wordTrig = false,
    condition = pipe({ is_math, no_backslash }),
  }) --[[@as function]]

  local with_priority = ls.extend_decorator.apply(parse_snippet, {
    priority = 10,
  }) --[[@as function]]

  return {
    parse_snippet({ trig = "sqrt", name = "\\sqrt{}" }, "\\sqrt{${1:${TM_SELECTED_TEXT}}} $0"),

    with_priority({ trig = "vect", name = "vect" }, "\\vect{$1}$0 "),
    with_priority({ trig = "mat", name = "mat" }, "\\mat{$1}$0 "),

    with_priority({ trig = "hat", name = "hat" }, "\\hat{$1}$0 "),
    with_priority({ trig = "bar", name = "bar" }, utils.overline() .. "{$1}$0 "),
    with_priority({ trig = "tilde", name = "tilde" }, "\\tilde{$1}$0 "),

    parse_snippet({ trig = "inf", name = "\\infty" }, "\\infty"),
    parse_snippet({ trig = "inn", name = "in " }, "\\in "),
    parse_snippet({ trig = "SI", name = "SI" }, "\\SI{$1}{$2}"),
  }
end

return M
