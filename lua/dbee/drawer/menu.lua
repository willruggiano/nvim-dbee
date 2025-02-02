local Menu = require("nui.menu")

local M = {}

---@param winid integer window id
---@param items string[] items to select from
---@param on_select fun(item: string) selection callback
---@param title string
function M.open(winid, items, on_select, title)
  local width = vim.api.nvim_win_get_width(winid)
  local row, _ = unpack(vim.api.nvim_win_get_cursor(winid))

  local popup_options = {
    relative = {
      type = "win",
      winid = winid,
    },
    position = {
      row = row + 1,
      col = 0,
    },
    size = {
      width = width,
    },
    border = {
      style = { "─", "─", "─", "", "─", "─", "─", "" },
      text = {
        top = title,
        top_align = "left",
      },
    },
    win_options = {
      cursorline = true,
    },
  }

  local lines = {}
  for _, item in ipairs(items) do
    table.insert(lines, Menu.item(item))
  end

  local menu = Menu(popup_options, {
    lines = lines,
    keymap = {
      focus_next = { "j", "<Down>", "<Tab>" },
      focus_prev = { "k", "<Up>", "<S-Tab>" },
      close = { "<Esc>", "<C-c>", "q" },
      submit = { "<CR>", "<Space>" },
    },
    on_close = function() end,
    on_submit = function(item)
      on_select(item.text)
    end,
  })

  menu:mount()
end

return M
