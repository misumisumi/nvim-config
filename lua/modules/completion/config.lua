local config = {}

function config.nvim_lsp()
    require("modules.completion.lsp")
end

function config.lspsaga()
    local icons = {
        diagnostics = require("modules.ui.icons").get("diagnostics", true),
        kind = require("modules.ui.icons").get("kind", true),
        type = require("modules.ui.icons").get("type", true),
        ui = require("modules.ui.icons").get("ui", true),
    }

    local function set_sidebar_icons()
        -- Set icons for sidebar.
        local diagnostic_icons = {
            Error = icons.diagnostics.Error_alt,
            Warn = icons.diagnostics.Warning_alt,
            Info = icons.diagnostics.Information_alt,
            Hint = icons.diagnostics.Hint_alt,
        }
        for type, icon in pairs(diagnostic_icons) do
            local hl = "DiagnosticSign" .. type
            vim.fn.sign_define(hl, { text = icon, texthl = hl })
        end
    end

    set_sidebar_icons()
    vim.g.enable_autocmp = true

    local colors = require("utils.color").get_palette()
    local opts = {
        enabled = function()
            return vim.g.enable_autocmp
        end,
        preview = {
            lines_above = 1,
            lines_below = 12,
        },
        scroll_preview = {
            scroll_down = "<C-j>",
            scroll_up = "<C-k>",
        },
        request_timeout = 3000,
        finder = {
            edit = { "o", "<CR>" },
            vsplit = "s",
            split = "i",
            tabe = "t",
            quit = { "q", "<ESC>" },
        },
        definition = {
            edit = "<C-c>o",
            vsplit = "<C-c>v",
            split = "<C-c>s",
            tabe = "<C-c>t",
            quit = "q",
            close = "<Esc>",
        },
        code_action = {
            num_shortcut = true,
            keys = {
                quit = "q",
                exec = "<CR>",
            },
        },
        lightbulb = {
            enable = false,
            sign = true,
            enable_in_insert = true,
            sign_priority = 20,
            virtual_text = true,
        },
        diagnostic = {
            twice_into = false,
            show_code_action = false,
            show_source = true,
            keys = {
                exec_action = "<CR>",
                quit = "q",
                go_action = "g",
            },
        },
        rename = {
            quit = "<C-c>",
            exec = "<CR>",
            in_select = true,
        },
        outline = {
            win_position = "right",
            win_with = "_sagaoutline",
            win_width = 30,
            show_detail = true,
            auto_preview = false,
            auto_refresh = true,
            auto_close = true,
            keys = {
                jump = "<CR>",
                expand_collapse = "u",
                quit = "q",
            },
        },
        symbol_in_winbar = {
            in_custom = true,
            enable = false,
            separator = " " .. icons.ui.Separator,
            hide_keyword = true,
            show_file = false,
        },
        ui = {
            theme = "round",
            border = "single", -- Can be single, double, rounded, solid, shadow.
            winblend = 0,
            expand = icons.ui.ArrowClosed,
            collapse = icons.ui.ArrowOpen,
            preview = icons.ui.Newspaper,
            code_action = icons.ui.CodeAction,
            diagnostic = icons.ui.Bug,
            incoming = icons.ui.Incoming,
            outgoing = icons.ui.Outgoing,
            colors = {
                normal_bg = colors.base,
                title_bg = colors.base,
                red = colors.red,
                megenta = colors.maroon,
                orange = colors.peach,
                yellow = colors.yellow,
                green = colors.green,
                cyan = colors.sapphire,
                blue = colors.blue,
                purple = colors.mauve,
                white = colors.text,
                black = colors.mantle,
                fg = colors.text,
            },
            kind = {
                -- Kind
                Class = { icons.kind.Class, colors.yellow },
                Constant = { icons.kind.Constant, colors.peach },
                Constructor = { icons.kind.Constructor, colors.sapphire },
                Enum = { icons.kind.Enum, colors.yellow },
                EnumMember = { icons.kind.EnumMember, colors.rosewater },
                Event = { icons.kind.Event, colors.yellow },
                Field = { icons.kind.Field, colors.teal },
                File = { icons.kind.File, colors.rosewater },
                Function = { icons.kind.Function, colors.blue },
                Interface = { icons.kind.Interface, colors.yellow },
                Key = { icons.kind.Keyword, colors.red },
                Method = { icons.kind.Method, colors.blue },
                Module = { icons.kind.Module, colors.blue },
                Namespace = { icons.kind.Namespace, colors.blue },
                Number = { icons.kind.Number, colors.peach },
                Operator = { icons.kind.Operator, colors.sky },
                Package = { icons.kind.Package, colors.blue },
                Property = { icons.kind.Property, colors.teal },
                Struct = { icons.kind.Struct, colors.yellow },
                TypeParameter = { icons.kind.TypeParameter, colors.maroon },
                Variable = { icons.kind.Variable, colors.peach },
                -- Type
                Array = { icons.type.Array, colors.peach },
                Boolean = { icons.type.Boolean, colors.peach },
                Null = { icons.type.Null, colors.yellow },
                Object = { icons.type.Object, colors.yellow },
                String = { icons.type.String, colors.green },
                -- ccls-specific icons.
                TypeAlias = { icons.kind.TypeAlias, colors.green },
                Parameter = { icons.kind.Parameter, colors.blue },
                StaticMethod = { icons.kind.StaticMethod, colors.peach },
                -- Microsoft-specific icons.
                Text = { icons.kind.Text, colors.green },
                Snippet = { icons.kind.Snippet, colors.mauve },
                Folder = { icons.kind.Folder, colors.blue },
                Unit = { icons.kind.Unit, colors.green },
                Value = { icons.kind.Value, colors.peach },
            },
        },
    }
    require("lspsaga").setup(opts)
end

function config.cmp()
    local icons = {
        kind = require("modules.ui.icons").get("kind", false),
        type = require("modules.ui.icons").get("type", false),
        cmp = require("modules.ui.icons").get("cmp", false),
    }
    local border = function(hl)
        return {
            { "╭", hl },
            { "─", hl },
            { "╮", hl },
            { "│", hl },
            { "╯", hl },
            { "─", hl },
            { "╰", hl },
            { "│", hl },
        }
    end

    local cmp_window = require("cmp.utils.window")

    cmp_window.info_ = cmp_window.info
    cmp_window.info = function(self)
        local info = self:info_()
        info.scrollable = false
        return info
    end

    local compare = require("cmp.config.compare")
    local lspkind = require("lspkind")
    local cmp = require("cmp")
    local km = { cmp = require("modules.lazy_keymap").nvim_cmp(cmp) }
    local opts = {
        window = {
            completion = {
                border = border("Normal"),
                max_width = 80,
                max_height = 20,
            },
            documentation = {
                border = border("CmpDocBorder"),
            },
        },
        sorting = {
            priority_weight = 2,
            comparators = {
                require("copilot_cmp.comparators").prioritize,
                require("copilot_cmp.comparators").score,
                -- require("cmp_tabnine.compare"),
                compare.offset,
                compare.exact,
                compare.score,
                require("cmp-under-comparator").under,
                compare.kind,
                compare.sort_text,
                compare.length,
                compare.order,
            },
        },
        formatting = {
            fields = { "kind", "abbr", "menu" },
            format = function(entry, vim_item)
                local kind = lspkind.cmp_format({
                    mode = "symbol_text",
                    maxwidth = 50,
                    symbol_map = vim.tbl_deep_extend("force", icons.kind, icons.type, icons.cmp),
                    menu = {
                        nvim_lsp = " [LSP]",
                        nvim_lua = " [LUA]",
                        path = " [PATH]",
                        spell = " [SPELL]",
                        tmux = " [TMUX]",
                        orgmode = " [ORGMODE]",
                        buffer = " [BUFFER]",
                        latex_symbols = " [LATEX]",
                        copilot = " [COPILOT]",
                        omni = " [OMNI]",
                    },
                })(entry, vim_item)
                local strings = vim.split(kind.kind, "%s", { trimempty = true })
                -- kind.kind = " " .. strings[1] .. " "
                -- kind.menu = "    (" .. strings[2] .. ")"
                kind.kind = " " .. strings[1] .. " (" .. strings[2]:sub(0, 4) .. "): "
                -- kind.menu = " [" .. menu[entry.source.name] .. "]"

                return kind
            end,
        },
        -- You can set mappings if you want
        mapping = km.cmp,
        snippet = {
            expand = function(args)
                require("luasnip").lsp_expand(args.body)
            end,
        },
        -- You should specify your *installed* sources.
        sources = {
            { name = "nvim_lsp" },
            { name = "nvim_lua" },
            { name = "luasnip" },
            { name = "path" },
            { name = "spell" },
            { name = "tmux" },
            { name = "orgmode" },
            { name = "buffer" },
            { name = "latex_symbols" },
            { name = "copilot" },
            -- { name = "skkeleton", view = { entries = "native" }, max_item_count = 8 },
            -- { name = "cmp_tabnine" },
        },
    }

    cmp.setup(opts)
end

function config.luasnip()
    local vim_path = require("core.global").vim_path
    local utils = require("utils")
    local snippet_path = utils.joinpath(vim_path, "my-snippets")
    if not vim.tbl_contains(vim.opt.rtp:get(), snippet_path) then
        vim.opt.rtp:append(snippet_path)
    end

    require("luasnip").config.set_config({
        history = true,
        updateevents = "TextChanged,TextChangedI",
        delete_check_events = "TextChanged,InsertLeave",
    })
    require("luasnip.loaders.from_lua").lazy_load()
    require("luasnip.loaders.from_vscode").lazy_load()
    require("luasnip.loaders.from_snipmate").lazy_load()
end

function config.autopairs()
    require("nvim-autopairs").setup()
    local npairs = require("nvim-autopairs")
    local Rule = require("nvim-autopairs.rule")

    local brackets = { { "(", ")" }, { "[", "]" }, { "{", "}" }, { "（", "）" }, { "「", "」" }, { "『", "』" } }
    npairs.add_rules({
        Rule(" ", " "):with_pair(function(opts)
            local pair = opts.line:sub(opts.col - 1, opts.col)
            return vim.tbl_contains({
                brackets[1][1] .. brackets[1][2],
                brackets[2][1] .. brackets[2][2],
                brackets[3][1] .. brackets[3][2],
            }, pair)
        end),
    })
    for _, bracket in pairs(brackets) do
        npairs.add_rules({
            Rule(bracket[1] .. " ", " " .. bracket[2])
                :with_pair(function()
                    return false
                end)
                :with_move(function(opts)
                    return opts.prev_char:match(".%" .. bracket[2]) ~= nil
                end)
                :use_key(bracket[2]),
        })
    end

    -- If you want insert `(` after select function or method item
    local cmp_autopairs = require("nvim-autopairs.completion.cmp")
    local cmp = require("cmp")
    local handlers = require("nvim-autopairs.completion.handlers")
    cmp.event:on(
        "confirm_done",
        cmp_autopairs.on_confirm_done({
            filetypes = {
                -- "*" is an alias to all filetypes
                ["*"] = {
                    ["("] = {
                        kind = {
                            cmp.lsp.CompletionItemKind.Function,
                            cmp.lsp.CompletionItemKind.Method,
                        },
                        handler = handlers["*"],
                    },
                },
                -- Disable for tex
                tex = false,
            },
        })
    )
end

function config.mason_install()
    require("mason-tool-installer").setup({

        -- a list of all tools you want to ensure are installed upon
        -- start; they should be the names Mason uses for each tool
        ensure_installed = {
            -- you can turn off/on auto_update per tool
            -- "editorconfig-checker",

            "stylua",

            "black",

            "prettier",

            "shellcheck",
            "shfmt",

            -- "vint",
        },

        -- if set to true this will check each tool for updates. If updates
        -- are available the tool will be updated.
        -- Default: false
        auto_update = false,

        -- automatically install / update on startup. If set to false nothing
        -- will happen on startup. You can use `:MasonToolsUpdate` to install
        -- tools and check for updates.
        -- Default: true
        run_on_start = true,
    })
end

function config.copilot()
    vim.defer_fn(function()
        require("copilot").setup({
            filetypes = {
                ["dap-repl"] = false,
            },
        })
    end, 100)
end

return config
