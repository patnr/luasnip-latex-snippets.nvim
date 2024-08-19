local M = {}

local ls = require("luasnip")
local f = ls.function_node

function M.retrieve(is_math)
  local utils = require("luasnip-latex-snippets.util.utils")
  local pipe, no_backslash = utils.pipe, utils.no_backslash

  local decorator = {
    wordTrig = false,
    condition = pipe({ is_math, no_backslash }),
  }

  local parse_snippet = ls.extend_decorator.apply(ls.parser.parse_snippet, decorator) --[[@as function]]
  local s = ls.extend_decorator.apply(ls.snippet, decorator) --[[@as function]]

  return {
    s(
      {
        trig = "(%a+)bar",
        wordTrig = false,
        regTrig = true,
        name = "bar",
        priority = 100,
      },
      f(function(_, snip)
        return string.format(utils.overline() .. "{%s}", snip.captures[1])
      end, {})
    ),
    s(
      {
        trig = "(%a+)und",
        wordTrig = false,
        regTrig = true,
        name = "underline",
        priority = 100,
      },
      f(function(_, snip)
        return string.format("\\underline{%s}", snip.captures[1])
      end, {})
    ),
    s(
      {
        trig = "(%a)dot",
        wordTrig = false,
        regTrig = true,
        name = "dot",
        priority = 100,
      },
      f(function(_, snip)
        return string.format("\\dot{%s}", snip.captures[1])
      end, {})
    ),

    s(
      {
        trig = "(%a+)hat",
        wordTrig = false,
        regTrig = true,
        name = "hat",
        priority = 100,
      },
      f(function(_, snip)
        return string.format("\\hat{%s}", snip.captures[1])
      end, {})
    ),
    s(
      {
        trig = "(%a+)tilde",
        wordTrig = false,
        regTrig = true,
        name = "tilde",
        priority = 100,
      },
      f(function(_, snip)
        return string.format("\\tilde{%s}", snip.captures[1])
      end, {})
    ),
    s(
      {
        trig = "(%a+)ora",
        wordTrig = false,
        regTrig = true,
        name = "ora",
        priority = 100,
      },
      f(function(_, snip)
        return string.format("\\overrightarrow{%s}", snip.captures[1])
      end, {})
    ),
    s(
      {
        trig = "(%a+)ola",
        wordTrig = false,
        regTrig = true,
        name = "ola",
        priority = 100,
      },
      f(function(_, snip)
        return string.format("\\overleftarrow{%s}", snip.captures[1])
      end, {})
    ),


    parse_snippet({ trig = "*T", name = "text" }, "\\text{${1:${TM_SELECTED_TEXT}}}${0}"),
    parse_snippet({ trig = "*F", name = "mathfrak" }, "\\mathfrak{${1:${TM_SELECTED_TEXT}}}${0}"),
    parse_snippet({ trig = "*C", name = "mathcal" }, "\\mathcal{${1:${TM_SELECTED_TEXT}}}${0}"),
    parse_snippet({ trig = "*S", name = "mathscr" }, "\\mathscr{${1:${TM_SELECTED_TEXT}}}${0}"),
    parse_snippet({ trig = "*B", name = "mathbb" }, "\\mathbb{${1:${TM_SELECTED_TEXT}}}${0}"),

    parse_snippet({ trig = "exists", name = "exists" }, "\\exists"),
    parse_snippet({ trig = "forall", name = "forall" }, "\\forall"),
    parse_snippet({ trig = "notin", name = "not in " }, "\\not\\in"),

    parse_snippet({ trig = "cc", name = "subset" }, "\\subset"),
    parse_snippet({ trig = "compl", name = "complement" }, "^{c}"),
    parse_snippet({ trig = "\\\\\\", name = "setminus" }, "\\setminus"),

    parse_snippet({ trig = "union", name = "set union" }, "\\cup"),
    parse_snippet({ trig = "inters", name = "set union" }, "\\cap"),

    parse_snippet({ trig = "//", name = "Fraction" }, "\\frac{$1}{$2}$0"),

    parse_snippet({ trig = "floor", name = "floor" }, "\\left\\lfloor $1 \\right\\rfloor$0"),
    parse_snippet({ trig = "ceil", name = "ceil" }, "\\left\\lceil $1 \\right\\rceil $0"),

    parse_snippet({ trig = "__", name = "subscript" }, "_{$1}$0"),
    parse_snippet({ trig = "invs", name = "inverse" }, "^{-1}"),
    parse_snippet({ trig = "^^", name = "subscript" }, "^{$1}$0"),


    -- TODO:
    parse_snippet({ trig = "||", name = "norm2" }, "\\| $1 \\|^2$0"),

    parse_snippet({ trig = "beg", name = "begin{} / end{}" }, "\\begin{$1}\n\t$0\n\\end{$1}"),
    parse_snippet({ trig = "bmat", name = "bmat" }, "\\begin{bmatrix} $1 \\end{bmatrix}$0"),
    parse_snippet({ trig = "pmat", name = "pmat" }, "\\begin{pmatrix} $1 \\end{pmatrix}$0"),
    parse_snippet({ trig = "...", name = "ldots", priority = 100 }, "\\ldots"),

    parse_snippet(
      { trig = "dint", name = "integral", priority = 300 },
      "\\int_{${1:-\\infty}}^{${2:\\infty}} ${3:${TM_SELECTED_TEXT}} $0"
    ),

    parse_snippet({ trig = "|->", name = "mapsto" , priority=1000}, "\\mapsto"),
    parse_snippet({ trig = "->", name = "to", priority = 100 }, "\\to"),
    parse_snippet({ trig = "-->", name = "long to", priority = 200 }, "\\xrightarrow[${1:lower}]{${2:upper}}$0"),
    parse_snippet({ trig = "iff", name = "iff" }, "\\iff"),
    parse_snippet({ trig = "<->", name = "leftrightarrow", priority = 200 }, "\\leftrightarrow"),
    parse_snippet({ trig = "=>", name = "implies" }, "\\implies"),
    parse_snippet({ trig = "=<", name = "implied by" }, "\\impliedby"),
    parse_snippet({ trig = "!!", name = "KLD divisor" }, "/\\!\\!/"),

    parse_snippet({ trig = "<=", name = "leq" }, "\\le"),
    parse_snippet({ trig = ">=", name = "geq" }, "\\ge"),
    parse_snippet({ trig = ":=", name = "colon equals (lhs defined as rhs)" }, "\\coloneqq"),
    parse_snippet({ trig = "=:", name = "colon equals (lhs defined as rhs)" }, "\\eqqcolon"),
    parse_snippet({ trig = "==", name = "equals" }, [[&= $1 \\\\]]),
    parse_snippet({ trig = "~~", name = "~" }, "\\sim"),
    parse_snippet({ trig = "≈",  name = "approx" }, "\\approx"),
    parse_snippet({ trig = "!=", name = "not equals" }, "\\neq"),

    parse_snippet({ trig = "<>", name = "hokje" }, "\\diamond"),
    parse_snippet({ trig = ">>", name = ">>" }, "\\gg"),
    -- parse_snippet({ trig = "<<", name = "<<" }, "\\ll"),
    parse_snippet({ trig = "<<", name = "<<" }, "\\langle $1 \\rangle$0"),

    parse_snippet({ trig = "left_right(", name = "left( right)" }, "\\left( $1 \\right)$0"),
    parse_snippet({ trig = "left_right[", name = "left[ right]" }, "\\left[ $1 \\right]$0"),
    parse_snippet({ trig = "left_right{", name = "set braces" }, "\\{ ${1} \\\\}$0"),

    parse_snippet({ trig = "(_2snip", name = "Autopair paranthesis with jumpable placeholder" }, "(${1})$0"),
    parse_snippet({ trig = "[_2snip", name = "Autopair bracket with jumpable placeholder" }, "[${1}]$0"),
    parse_snippet({ trig = "{_2snip", name = "Autopair brace with jumpable placeholder" }, "{${1}}$0"),

    -- Autopairs actually puts this inside of math mode
    parse_snippet({ trig = "$_2snip", name = "Autopair dollar with jumpable placeholder" }, "\\$${1}\\$${0}"),
  }
end

return M
