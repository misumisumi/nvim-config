local config = {}

function config.csv()
    vim.g.csv_nomap_space = 1
end

function config.flutter_tools()
    local opts = {
        decorations = {
            statusline = {
                app_version = true,
                device = true,
            },
        },
        lsp = {
            color = {
                enable = true,
                background = true,
            },
        },
    }
    require("flutter-tools").setup(opts)
end

function config.md_preview()
    local utils = require("utils")
    vim.g.mkdp_markdown_css = utils.joinpath(vim.fn.stdpath("config"), "lua", "modules", "lang", "md_preview", "github-markdown.css")
    vim.g.mkdp_filetypes = { "markdown" }
end

function config.rust_tools()
    local opts = {
        tools = { -- rust-tools options

            -- how to execute terminal commands
            -- options right now: termopen / quickfix
            executor = require("rust-tools/executors").termopen,

            -- callback to execute once rust-analyzer is done initializing the workspace
            -- The callback receives one parameter indicating the `health` of the server: "ok" | "warning" | "error"
            on_initialized = function()
                require("lsp_signature").on_attach({
                    bind = true,
                    use_lspsaga = false,
                    floating_window = true,
                    fix_pos = true,
                    hint_enable = true,
                    hi_parameter = "Search",
                    handler_opts = { "double" },
                })
            end,

            -- automatically call RustReloadWorkspace when writing to a Cargo.toml file.
            reload_workspace_from_cargo_toml = true,

            -- These apply to the default RustSetInlayHints command
            inlay_hints = {
                -- automatically set inlay hints (type hints)
                -- default: true
                auto = true,

                -- Only show inlay hints for the current line
                only_current_line = false,

                -- whether to show parameter hints with the inlay hints or not
                -- default: true
                show_parameter_hints = true,

                -- prefix for parameter hints
                -- default: "<-"
                parameter_hints_prefix = "<- ",

                -- prefix for all the other hints (type, chaining)
                -- default: "=>"
                other_hints_prefix = "=> ",

                -- whether to align to the lenght of the longest line in the file
                max_len_align = false,

                -- padding from the left if max_len_align is true
                max_len_align_padding = 1,

                -- whether to align to the extreme right or not
                right_align = false,

                -- padding from the right if right_align is true
                right_align_padding = 7,

                -- The color of the hints
                highlight = "Comment",
            },

            -- options same as lsp hover / vim.lsp.util.open_floating_preview()
            hover_actions = {

                -- the border that is used for the hover window
                -- see vim.api.nvim_open_win()
                border = {
                    { "╭", "FloatBorder" },
                    { "─", "FloatBorder" },
                    { "╮", "FloatBorder" },
                    { "│", "FloatBorder" },
                    { "╯", "FloatBorder" },
                    { "─", "FloatBorder" },
                    { "╰", "FloatBorder" },
                    { "│", "FloatBorder" },
                },

                -- whether the hover action window gets automatically focused
                -- default: false
                auto_focus = false,
            },

            -- settings for showing the crate graph based on graphviz and the dot
            -- command
            crate_graph = {
                -- Backend used for displaying the graph
                -- see: https://graphviz.org/docs/outputs/
                -- default: x11
                backend = "x11",
                -- where to store the output, nil for no output stored (relative
                -- path from pwd)
                -- default: nil
                output = nil,
                -- true for all crates.io and external crates, false only the local
                -- crates
                -- default: true
                full = true,

                -- List of backends found on: https://graphviz.org/docs/outputs/
                -- Is used for input validation and autocompletion
                -- Last updated: 2021-08-26
                enabled_graphviz_backends = {
                    "bmp",
                    "cgimage",
                    "canon",
                    "dot",
                    "gv",
                    "xdot",
                    "xdot1.2",
                    "xdot1.4",
                    "eps",
                    "exr",
                    "fig",
                    "gd",
                    "gd2",
                    "gif",
                    "gtk",
                    "ico",
                    "cmap",
                    "ismap",
                    "imap",
                    "cmapx",
                    "imap_np",
                    "cmapx_np",
                    "jpg",
                    "jpeg",
                    "jpe",
                    "jp2",
                    "json",
                    "json0",
                    "dot_json",
                    "xdot_json",
                    "pdf",
                    "pic",
                    "pct",
                    "pict",
                    "plain",
                    "plain-ext",
                    "png",
                    "pov",
                    "ps",
                    "ps2",
                    "psd",
                    "sgi",
                    "svg",
                    "svgz",
                    "tga",
                    "tiff",
                    "tif",
                    "tk",
                    "vml",
                    "vmlz",
                    "wbmp",
                    "webp",
                    "xlib",
                    "x11",
                },
            },
        },

        -- all the opts to send to nvim-lspconfig
        -- these override the defaults set by rust-tools.nvim
        -- see https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#rust_analyzer
        server = {
            -- standalone file support
            -- setting it to false may improve startup time
            standalone = true,
        }, -- rust-analyer options

        -- debugging stuff
        dap = {
            adapter = {
                type = "executable",
                command = "lldb-vscode",
                name = "rt_lldb",
            },
        },
    }

    require("rust-tools").setup(opts)
end

function config.vim_go()
    vim.g.go_doc_keywordprg_enabled = 0
    vim.g.go_def_mapping_enabled = 0
    vim.g.go_code_completion_enabled = 0
end

function config.vimtex()
    local viewer = "zathura"
    vim.g.vimtex_view_method = viewer
    vim.g.vimtex_view_general_viewer = viewer
    vim.g.vimtex_view_general_options = '-x "nvr +%{line} %{input}" --synctex-forward @line:0:@tex @pdf'
    vim.g.vimtex_view_forward_search_on_start = false
    vim.g.vimtex_syntax_enabled = 0
    vim.g.vimtex_complete_enabled = 0
    vim.g.vimtex_format_enabled = 0
    vim.g.vimtex_format_enabled = 0
    vim.g.vimtex_lint_chktex_parameters = "-n"
    vim.g.vimtex_quickfix_open_on_warning = 0

    vim.g.vimtex_fold_enabled = 1
    vim.g.vimtex_fold_types = {
        items = {
            enabled = 0,
        },
        envs = {
            blacklist = { "figure", "itemize", "tabular", "tikzpicture", "subsection", "subsubsection" },
        },
    }
end

return config
