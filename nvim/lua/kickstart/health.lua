--[[
--
-- This file is not required for your own configuration,
-- but helps people determine if their system is setup correctly.
--
--]]

local check_version = function()
  local verstr = tostring(vim.version())
  if not vim.version.ge then
    vim.health.error(string.format("Neovim out of date: '%s'. Upgrade to latest stable or nightly", verstr))
    return
  end

  if vim.version.ge(vim.version(), '0.10-dev') then
    vim.health.ok(string.format("Neovim version is: '%s'", verstr))
  else
    vim.health.error(string.format("Neovim out of date: '%s'. Upgrade to latest stable or nightly", verstr))
  end
end

local check_external_reqs = function()
  -- Basic utils: `git`, `make`, `unzip`
  for _, exe in ipairs { 'git', 'make', 'unzip', 'rg' } do
    local is_executable = vim.fn.executable(exe) == 1
    if is_executable then
      vim.health.ok(string.format("Found executable: '%s'", exe))
    else
      vim.health.warn(string.format("Could not find executable: '%s'", exe))
    end
  end

  -- `fd` can be installed as `fd` or `fdfind` depending on distro.
  local fd_exe = nil
  for _, exe in ipairs { 'fd', 'fdfind' } do
    if vim.fn.executable(exe) == 1 then
      fd_exe = exe
      break
    end
  end
  if fd_exe then
    vim.health.ok(string.format("Found executable: '%s'", fd_exe))
  else
    vim.health.warn "Could not find executable: 'fd' (or 'fdfind')"
  end

  -- A C compiler is needed by some plugins during installation.
  local c_compiler = nil
  for _, exe in ipairs { 'gcc', 'cc', 'clang' } do
    if vim.fn.executable(exe) == 1 then
      c_compiler = exe
      break
    end
  end
  if c_compiler then
    vim.health.ok(string.format("Found C compiler: '%s'", c_compiler))
  else
    vim.health.warn "Could not find a C compiler: expected one of 'gcc', 'cc', or 'clang'"
  end

  -- Any clipboard provider is sufficient.
  local clipboard_tool = nil
  for _, exe in ipairs { 'xclip', 'xsel', 'wl-copy', 'pbcopy', 'win32yank' } do
    if vim.fn.executable(exe) == 1 then
      clipboard_tool = exe
      break
    end
  end
  if clipboard_tool then
    vim.health.ok(string.format("Found clipboard tool: '%s'", clipboard_tool))
  else
    vim.health.warn "Could not find a clipboard tool (xclip/xsel/wl-copy/pbcopy/win32yank)"
  end

  -- Optional: used by lua/kickstart/plugins/lint.lua for markdown linting.
  if vim.fn.executable 'markdownlint' == 1 then
    vim.health.ok "Found optional executable: 'markdownlint'"
  else
    vim.health.info "Optional executable missing: 'markdownlint' (markdown linting is disabled)"
  end

  return true
end

return {
  check = function()
    vim.health.start 'kickstart.nvim'

    vim.health.info [[NOTE: Not every warning is a 'must-fix' in `:checkhealth`

  Fix only warnings for plugins and languages you intend to use.
    Mason will give warnings for languages that are not installed.
    You do not need to install, unless you want to use those languages!]]

    local uv = vim.uv or vim.loop
    vim.health.info('System Information: ' .. vim.inspect(uv.os_uname()))

    check_version()
    check_external_reqs()
  end,
}
