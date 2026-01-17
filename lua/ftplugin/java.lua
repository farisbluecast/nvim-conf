local jdtls = require 'jdtls'

local root_dir = require('jdtls.setup').find_root {
  'pom.xml',
  '.git',
}

local workspace = vim.fn.stdpath 'data' .. '/jdtls-workspace/' .. vim.fn.fnamemodify(root_dir, ':p:h:t')

jdtls.start_or_attach {
  cmd = { 'jdtls' },
  root_dir = root_dir,
  workspace_folder = workspace,
}
