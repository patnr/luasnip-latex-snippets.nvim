local ls = require("luasnip")
local utils = require("luasnip-latex-snippets.util.utils")
local pipe = utils.pipe

local M = {}

function M.retrieve(not_math)
  local parse_snippet = ls.extend_decorator.apply(ls.parser.parse_snippet, {
    condition = pipe({ not_math }),
  }) --[[@as function]]

  return {
    parse_snippet({ trig = "mk", name = "Math" }, "\\( ${1:${TM_SELECTED_TEXT}} \\)$0"),
    parse_snippet({ trig = "dm", name = "Block Math" }, "\\[\n\t${1:${TM_SELECTED_TEXT}}\n.\\] $0"),

    parse_snippet({ trig = "cref", name = "\\cref" }, "\\cref{${1:${TM_SELECTED_TEXT}}}$0"),
    parse_snippet({ trig = "Cref", name = "\\Cref" }, "\\Cref{${1:${TM_SELECTED_TEXT}}}$0"),
    parse_snippet({ trig = "eqref", name = "\\eqref" }, "\\eqref{eq:$1}$0"),
    parse_snippet({ trig = "href", name = "\\href" }, "\\href{${1:${TM_SELECTED_TEXT}}}{${2:text}}${0}"),
    parse_snippet({ trig = "aslink", name = "\\href" }, "\\href{${2:url}}{${1:${TM_SELECTED_TEXT}}}${0}"),

    parse_snippet({ trig = "citet", name = "\\citet" }, "\\citet{$1}$0"),
    parse_snippet({ trig = "citep", name = "\\citep" }, "\\citep{$1}$0"),

    parse_snippet({ trig = "=>", name = "implies", priority=1001 }, "\\$\\implies\\$"),

    parse_snippet({ trig = "**", name = "Emphasis" }, "\\emph{${1:${TM_SELECTED_TEXT}}}${0}"),
    parse_snippet({ trig = "*b", name = "Emphasis" }, "\\textbf{${1:${TM_SELECTED_TEXT}}}${0}"),
    parse_snippet({ trig = "*/", name = "Italicezed" }, "\\textit{${1:${TM_SELECTED_TEXT}}}${0}"),
    parse_snippet({ trig = "*t", name = "Texttt" }, "\\texttt{${1:${TM_SELECTED_TEXT}}}${0}"),
    parse_snippet({ trig = "*_", name = "Underlined" }, "\\underline{${1:${TM_SELECTED_TEXT}}}${0}"),
    parse_snippet({ trig = "*x", name = "Underlined" }, "\\sout{${1:${TM_SELECTED_TEXT}}}${0}"),
    parse_snippet({ trig = "*k", name = "Underlined" }, "\\keyw{${1:${TM_SELECTED_TEXT}}}${0}"),

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
