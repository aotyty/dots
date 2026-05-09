return {
  "nanozuki/tabby.nvim",
  dependencies = "nvim-tree/nvim-web-devicons",
  config = function()
    local theme = {
      fill = { bg = "#3c3836", fg = "#282828" },
      head = { bg = "#a89984", fg = "#282828" },
      current_tab = { bg = "#3c3836", fg = "#ebdbb2" },
      tab = { bg = "#3c3836", fg = "#a89984" },
      tail = { bg = "#3c3836", fg = "#ebdbb2" },
    }

    local api = require("tabby.module.api")
    local devicons = require("nvim-web-devicons")

    local function get_hl(tab)
      return tab.is_current() and theme.current_tab or theme.tab
    end

    local function get_closing_sep(tab)
      local current_tab_number = api.get_tab_number(api.get_current_tab())
      if tab.number() < current_tab_number then
        return ""
      end
      return ""
    end

    function get_tab_name(tab)
      return string.gsub(tab.name(), "%[..%]", "")
    end

    function get_tab_window_count(tab)
      local count = #tab.wins().wins
      return count > 1 and "[" .. count .. "]" or ""
    end

    local function get_modified(tab)
      local win_ids = api.get_tab_wins(tab.id)
      for _, win_id in ipairs(win_ids) do
        if pcall(vim.api.nvim_win_get_buf, win_id) then
          local bufid = vim.api.nvim_win_get_buf(win_id)
          if vim.api.nvim_buf_get_option(bufid, "modified") then
            return "󰏫"
          end
        end
      end
      return ""
    end

    require("tabby.tabline").set(function(line)
      return {
        {
          { "  ", hl = theme.head },
          line.sep("", theme.head, theme.fill),
        },
        line.tabs().foreach(function(tab)
          return {
            line.sep(get_closing_sep(tab), get_hl(tab), theme.fill),
            devicons.get_icon(get_tab_name(tab), nil, { default = true }),
            get_tab_name(tab),
            get_tab_window_count(tab),
            get_modified(tab),
            line.sep(get_closing_sep(tab), { fg = "#ebdbb2", bg = "#a89984" }, theme.fill),
            hl = get_hl(tab),
            margin = " ",
          }
        end),
        line.spacer(),
        {},
        hl = theme.fill,
      }
    end)
  end,
}
