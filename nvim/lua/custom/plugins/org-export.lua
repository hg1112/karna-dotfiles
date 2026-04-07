---@module 'lazy'
---@type LazySpec
return {
  -- Local virtual plugin — no remote repo, just commands + keymaps
  dir = vim.fn.stdpath 'config',
  name = 'org-export',
  ft = 'org',
  config = function()
    local function export(format)
      local src = vim.fn.expand '%:p'
      if src == '' then
        vim.notify('No file open', vim.log.levels.WARN)
        return
      end
      local out = vim.fn.fnamemodify(src, ':r') .. '.' .. format
      local cmd

      if format == 'md' then
        cmd = string.format('pandoc "%s" -f org -t gfm -o "%s"', src, out)
      elseif format == 'pdf' then
        cmd = string.format('pandoc "%s" -f org -o "%s" --pdf-engine=xelatex', src, out)
      elseif format == 'html' then
        cmd = string.format('pandoc "%s" -f org -t html5 --standalone -o "%s"', src, out)
      end

      vim.notify('Exporting to ' .. format:upper() .. '…', vim.log.levels.INFO)
      vim.fn.jobstart(cmd, {
        on_exit = function(_, code)
          if code == 0 then
            vim.notify('Exported → ' .. out, vim.log.levels.INFO)
          else
            vim.notify('Export failed — is pandoc installed?', vim.log.levels.ERROR)
          end
        end,
      })
    end

    vim.api.nvim_create_user_command('OrgExportMd',   function() export 'md'   end, { desc = 'Export org → Markdown' })
    vim.api.nvim_create_user_command('OrgExportPdf',  function() export 'pdf'  end, { desc = 'Export org → PDF' })
    vim.api.nvim_create_user_command('OrgExportHtml', function() export 'html' end, { desc = 'Export org → HTML' })

    local map = function(key, cmd, desc)
      vim.keymap.set('n', key, cmd, { buffer = true, desc = desc })
    end
    map('<leader>oem', '<cmd>OrgExportMd<cr>',   '[O]rg [E]xport [M]arkdown')
    map('<leader>oep', '<cmd>OrgExportPdf<cr>',  '[O]rg [E]xport [P]df')
    map('<leader>oeh', '<cmd>OrgExportHtml<cr>', '[O]rg [E]xport [H]tml')
  end,
}
