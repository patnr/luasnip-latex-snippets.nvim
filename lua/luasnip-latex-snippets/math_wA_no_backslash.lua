local ls = require("luasnip")

local utils = require("luasnip-latex-snippets.util.utils")
local pipe = utils.pipe
local no_backslash = utils.no_backslash

local M = {}

function M.retrieve(is_math)
  local parse_snippet = ls.extend_decorator.apply(ls.parser.parse_snippet, {
    condition = pipe({ is_math, no_backslash }),
  }) --[[@as function]]

  local with_priority = ls.extend_decorator.apply(parse_snippet, {
    priority = 10,
  }) --[[@as function]]

  return {
    with_priority({ trig = "arcsin", name = "arcsin" }, "\\arcsin "),
    with_priority({ trig = "arctan", name = "arctan" }, "\\arctan "),
    with_priority({ trig = "arcsec", name = "arcsec" }, "\\arcsec "),
    with_priority({ trig = "asin", name = "asin" }, "\\arcsin"),
    with_priority({ trig = "atan", name = "atan" }, "\\arctan"),
    with_priority({ trig = "asec", name = "asec" }, "\\arcsec"),

    parse_snippet({ trig = "set", name = "set" }, [[ \\{$1\\} $0 ]]),
    parse_snippet({ trig = "fun", name = "function map" }, "${1:f} \\colon ${2:\\Reals} \\to \\colon ${3:\\Reals}"),

    parse_snippet({ trig = "lim", name = "limit" }, "\\lim_{${1:n} \\to ${2:\\infty}} "),
    parse_snippet(
      { trig = "sum", name = "sum" },
      "\\sum_{${1:n=1}}^{${2:\\infty}} ${3:${TM_SELECTED_TEXT}} $0"
    ),
    parse_snippet(
      { trig = "prod", name = "product" },
      "\\prod_{${1:n=1}}^{${2:\\infty}} ${3:${TM_SELECTED_TEXT}} $0"
    ),


    parse_snippet(
      { trig = "abs", name = "absolute value \\abs{}" },
      "\\abs{${1:${TM_SELECTED_TEXT}}}$0"
    ),
  }
end

return M
