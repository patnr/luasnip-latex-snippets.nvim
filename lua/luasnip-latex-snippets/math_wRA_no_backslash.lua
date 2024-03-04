local ls = require("luasnip")
local f = ls.function_node

local M = {}

local vec_node = {
  f(function(_, snip)
    return string.format("\\vect{%s}", snip.captures[1])
  end, {}),
}

local mat_node = {
  f(function(_, snip)
    return string.format("\\mat{%s}", snip.captures[1])
  end, {}),
}

M.math_wrA_no_backslash = {
  { "([%a][%a])(jk)", vec_node },
  { "([%a][%a])(kj)", vec_node },
  { "([%a])(jk)", vec_node },
  { "([%a])(kj)", vec_node },
  { "([%a][%a])(hj)", mat_node },
  { "([%a][%a])(jh)", mat_node },
  { "([%a])(hj)", mat_node },
  { "([%a])(jh)", mat_node },
}

M.decorator = {}

function M.retrieve(is_math)
  local utils = require("luasnip-latex-snippets.util.utils")
  local pipe = utils.pipe
  local no_backslash = utils.no_backslash

  M.decorator = {
    wordTrig = true,
    trigEngine = "pattern",
    condition = pipe({ is_math, no_backslash }),
  }

  local s = ls.extend_decorator.apply(ls.snippet, M.decorator) --[[@as function]]

  return vim.tbl_map(function(x)
    local trig, node = unpack(x)
    return s({ trig = trig }, vim.deepcopy(node))
  end, M.math_wrA_no_backslash)
end

return M
