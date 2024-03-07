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
    parse_snippet({ trig = "double_quote_snip", name = "Double quotes" }, "\\enquote{${1:${TM_SELECTED_TEXT}}}${0}"),
    parse_snippet({ trig = "single_quote_snip", name = "Single quotes" }, "\\enquote*{${1:${TM_SELECTED_TEXT}}}${0}"),

    parse_snippet({ trig = "left_right(", name = "Cancel left_right" }, "(($0))"),
    parse_snippet({ trig = "left_right{", name = "Cancel left_right" }, "{{$0}}"),
    parse_snippet({ trig = "left_right[", name = "" }, "\\[ $0 \\]"),

    parse_snippet({ trig = "(_2snip", name = "Autopair paranthesis with jumpable placeholder" }, "(${1})$0"),
    parse_snippet({ trig = "[_2snip", name = "Autopair bracket with jumpable placeholder" }, "[${1}]$0"),
    parse_snippet({ trig = "{_2snip", name = "Autopair brace with jumpable placeholder" }, "{${1}}$0"),

    parse_snippet({ trig = '"_2snip', name = "Autopair quote with jumpable placeholder" }, '\"${1}\"${0}'),
    parse_snippet({ trig = "'_2snip", name = "Autopair quote* with jumpable placeholder" }, "'${1}'${0}"),
  }
end

return M
