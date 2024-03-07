local ls = require("luasnip")
local utils = require("luasnip-latex-snippets.util.utils")
local pipe, no_backslash = utils.pipe, utils.no_backslash

local M = {}

function M.retrieve(not_math)
  local parse_snippet = ls.extend_decorator.apply(ls.parser.parse_snippet, {
    condition = pipe({ not_math }),
  }) --[[@as function]]

  local parse_s_no_bs = ls.extend_decorator.apply(ls.parser.parse_snippet, {
    condition = pipe({ not_math, no_backslash }),
  }) --[[@as function]]

  return {
    parse_snippet({ trig = "mk", name = "Math" }, "\\( ${1:${TM_SELECTED_TEXT}} \\)$0"),
    parse_snippet({ trig = "dm", name = "Block Math" }, "\\[\n\t${1:${TM_SELECTED_TEXT}}\n.\\] $0"),

    parse_snippet({ trig = "=>", name = "implies", priority=1001 }, "\\$\\implies\\$"),

    parse_snippet({ trig = "**", name = "Emphasis" }, "\\emph{${1:${TM_SELECTED_TEXT}}}${0}"),
    parse_snippet({ trig = "*b", name = "Emphasis" }, "\\textbf{${1:${TM_SELECTED_TEXT}}}${0}"),
    parse_snippet({ trig = "*/", name = "Italicezed" }, "\\textit{${1:${TM_SELECTED_TEXT}}}${0}"),
    parse_snippet({ trig = "*t", name = "Texttt" }, "\\texttt{${1:${TM_SELECTED_TEXT}}}${0}"),
    parse_snippet({ trig = "*_", name = "Underlined" }, "\\underline{${1:${TM_SELECTED_TEXT}}}${0}"),
    parse_snippet({ trig = "*x", name = "Underlined" }, "\\sout{${1:${TM_SELECTED_TEXT}}}${0}"),
    parse_snippet({ trig = "*k", name = "Underlined" }, "\\keyw{${1:${TM_SELECTED_TEXT}}}${0}"),
  }
end

return M
