return {
  -- The Image Engine
  {
    "3rd/image.nvim",
    opts = {
      backend = "kitty", -- WezTerm uses the Kitty image protocol
      integrations = {
        markdown = {
          enabled = true,
          clear_in_insert_mode = false,
          download_remote_images = true,
          only_render_image_at_cursor = false,
          filetypes = { "markdown", "vimwiki" },
        },
      },
      max_width_window_percentage = 100,
      max_height_window_percentage = 50,
      window_overlap_clear_enabled = false,
    },
  },

  -- The Diagram Renderer
  {
    "3rd/diagram.nvim",
    dependencies = {
      "3rd/image.nvim",
    },
    opts = {
      renderer_options = {
        mermaid = {
          cli_args = { "-p", vim.fn.expand("~/.config/nvim/puppeteer-config.json") },
          background = "transparent",
          theme = "dark",
        }
      }
    },
  },
}
