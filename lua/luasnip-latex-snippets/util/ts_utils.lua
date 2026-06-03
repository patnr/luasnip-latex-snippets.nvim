local M = {}

local MATH_NODES = {
  displayed_equation = true,
  inline_formula = true,
  math_environment = true,
}

local TEXT_NODES = {
  text_mode = true,
  label_definition = true,
  label_reference = true,
}

local function get_node_at_cursor()
  local pos = vim.api.nvim_win_get_cursor(0)
  -- Subtract one to account for 1-based row indexing in nvim_win_get_cursor
  local row, col = pos[1] - 1, pos[2]

  local parser = vim.treesitter.get_parser(0, "latex")
  if not parser then
    return
  end

  local root_tree = parser:parse({ row, col, row, col })[1]
  local root = root_tree and root_tree:root()
  if not root then
    return
  end

  return root:named_descendant_for_range(row, col, row, col)
end

function M.in_text(check_parent)
  local node = get_node_at_cursor()
  while node do
    if node:type() == "text_mode" then
      if check_parent then
        -- For \text{}
        local parent = node:parent()
        if parent and MATH_NODES[parent:type()] then
          return false
        end
      end

      return true
    elseif MATH_NODES[node:type()] then
      return false
    end
    node = node:parent()
  end
  return true
end

function M.in_mathzone()
  -- When the buffer is not a .tex file, verify the cursor is inside an injected latex region.
  -- Without this, a bare `get_node_at_cursor()` runs a fresh latex parser over the whole buffer,
  -- and stray `$` chars (e.g. `$(...)` in shell code blocks) open unclosed inline_formula nodes.
  local buf = vim.api.nvim_get_current_buf()
  local ft_parser = vim.treesitter.get_parser(buf)
  if ft_parser and ft_parser:lang() ~= "latex" then
    local cursor = vim.api.nvim_win_get_cursor(0)
    local row, col = cursor[1] - 1, cursor[2]
    ft_parser:parse()
    local lang_tree = ft_parser:language_for_range({ row, col, row, col })
    if not lang_tree or lang_tree:lang() ~= "latex" then
      return false
    end
  end

  local node = get_node_at_cursor()
  while node do
    if TEXT_NODES[node:type()] then
      return false
    elseif MATH_NODES[node:type()] then
      return true
    end
    node = node:parent()
  end
  return false
end

return M
