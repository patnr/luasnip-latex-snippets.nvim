local M = {}

local ls = require("luasnip")

function M.retrieve(not_math)
  local utils = require("luasnip-latex-snippets.util.utils")
  local pipe, no_backslash = utils.pipe, utils.no_backslash

  local parse_snippet = ls.extend_decorator.apply(ls.parser.parse_snippet, {
    wordTrig = false,
    condition = pipe({ not_math, no_backslash }),
  }) --[[@as function]]

  return {
    parse_snippet({ trig = "cref", name = "\\cref" }, "\\cref{${1:${TM_SELECTED_TEXT}}}$0"),
    parse_snippet({ trig = "Cref", name = "\\Cref" }, "\\Cref{${1:${TM_SELECTED_TEXT}}}$0"),
    parse_snippet({ trig = "eqref", name = "\\eqref" }, "\\eqref{eq:$1}$0"),
    parse_snippet({ trig = "href", name = "\\href" }, "\\href{${1:${TM_SELECTED_TEXT}}}{${2:text}}${0}"),
    parse_snippet({ trig = "aslink", name = "\\href" }, "\\href{${2:url}}{${1:${TM_SELECTED_TEXT}}}${0}"),
    parse_snippet({ trig = "citet", name = "\\citet" }, "\\citet{$1}$0"),
    parse_snippet({ trig = "citep", name = "\\citep" }, "\\citep{$1}$0"),
  }
end

return M
