return {
  'zbirenbaum/copilot.lua',
  cmd = 'Copilot',
  event = 'InsertEnter',
  dependencies = {
    {
      'zbirenbaum/copilot-cmp',
      config = function()
        require('copilot_cmp').setup()
      end,
    },
  },
  config = function()
    require('copilot').setup {
      suggestion = {
        auto_trigger = true,
        keymap = {
          accept = '<C-l>',
          next = '<C-j>',
          prev = '<C-k>',
          dismiss = '<C-h>',
        },
      },
      panel = {
        enabled = true,
      },
    }
  end,
}
