local jdtls_ok, jdtls = pcall(require, 'jdtls')
if not jdtls_ok then
    return
end

local jdtls_path = '/usr/share/java/jdtls'
local launcher_jar = vim.fn.glob(jdtls_path .. '/plugins/org.eclipse.equinox.launcher_*.jar')

if launcher_jar == '' then
    vim.notify('jdtls launcher jar not found', vim.log.levels.WARN)
    return
end

-- Use a user-writable config directory (copy from system on first use)
local cache_dir = vim.fn.stdpath('cache') .. '/jdtls'
local config_path = cache_dir .. '/config'
local system_config = jdtls_path .. '/config_linux'

-- Copy system config to cache if not present
if vim.fn.isdirectory(config_path) == 0 then
    vim.fn.mkdir(cache_dir, 'p')
    vim.fn.system({ 'cp', '-r', system_config, config_path })
end

local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')
local workspace_dir = vim.fn.stdpath('data') .. '/jdtls-workspace/' .. project_name

local capabilities = require('cmp_nvim_lsp').default_capabilities()

local on_attach = function(client, bufnr)
    local function keymap_set(mode, lhs, rhs)
        vim.keymap.set(mode, lhs, rhs, { buffer = bufnr })
    end

    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

    keymap_set('n', 'E', function() vim.diagnostic.open_float({ scope = "line" }) end)
    keymap_set('n', '<C-]>', function() vim.lsp.buf.definition() end)
    keymap_set('n', 'K', function() vim.lsp.buf.hover() end)
    keymap_set('n', 'gh', function() vim.lsp.buf.document_highlight() end)
    keymap_set('n', 'gc', function() vim.lsp.buf.clear_references() end)
    keymap_set('n', 'ge', function() vim.diagnostic.set_loclist() end)
    keymap_set('n', '<space>f', function() vim.lsp.buf.format({ timeout_ms = 2000 }) end)

    -- Java-specific keymaps
    keymap_set('n', '<leader>jo', function() jdtls.organize_imports() end)
    keymap_set('n', '<leader>jv', function() jdtls.extract_variable() end)
    keymap_set('v', '<leader>jv', function() jdtls.extract_variable(true) end)
    keymap_set('n', '<leader>jc', function() jdtls.extract_constant() end)
    keymap_set('v', '<leader>jc', function() jdtls.extract_constant(true) end)
    keymap_set('v', '<leader>jm', function() jdtls.extract_method(true) end)
end

local config = {
    cmd = {
        'java',
        '-Declipse.application=org.eclipse.jdt.ls.core.id1',
        '-Dosgi.bundles.defaultStartLevel=4',
        '-Declipse.product=org.eclipse.jdt.ls.core.product',
        '-Dlog.protocol=true',
        '-Dlog.level=ALL',
        '-Xmx1g',
        '--add-modules=ALL-SYSTEM',
        '--add-opens', 'java.base/java.util=ALL-UNNAMED',
        '--add-opens', 'java.base/java.lang=ALL-UNNAMED',
        '-jar', launcher_jar,
        '-configuration', config_path,
        '-data', workspace_dir,
    },
    root_dir = jdtls.setup.find_root({ '.git', 'mvnw', 'gradlew', 'pom.xml', 'build.gradle' }),
    capabilities = capabilities,
    on_attach = on_attach,
    settings = {
        java = {
            signatureHelp = { enabled = true },
            contentProvider = { preferred = 'fernflower' },
            completion = {
                favoriteStaticMembers = {
                    'org.junit.Assert.*',
                    'org.junit.Assume.*',
                    'org.junit.jupiter.api.Assertions.*',
                    'org.junit.jupiter.api.Assumptions.*',
                    'org.junit.jupiter.api.DynamicContainer.*',
                    'org.junit.jupiter.api.DynamicTest.*',
                    'org.mockito.Mockito.*',
                    'org.mockito.ArgumentMatchers.*',
                    'org.mockito.Answers.*',
                },
                filteredTypes = {
                    'com.sun.*',
                    'io.micrometer.shaded.*',
                    'java.awt.*',
                    'jdk.*',
                    'sun.*',
                },
            },
            sources = {
                organizeImports = {
                    starThreshold = 9999,
                    staticStarThreshold = 9999,
                },
            },
            codeGeneration = {
                toString = {
                    template = '${object.className}{${member.name()}=${member.value}, ${otherMembers}}',
                },
                useBlocks = true,
            },
        },
    },
    init_options = {
        bundles = {},
    },
}

jdtls.start_or_attach(config)
