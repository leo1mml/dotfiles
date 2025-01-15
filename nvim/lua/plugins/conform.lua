return {
  "stevearc/conform.nvim",
  event = { "BufWritePre" },
  cmd = { "ConformInfo" },
  opts = {
    -- Define your formatters
    formatters_by_ft = {
      lua = { "stylua" },
      python = { "isort", "black" },
      javascript = { { "prettierd", "prettier" } },
      rust = { "rustfmt" },
      csharp = { "csharpier" },
      objectivec = { "uncrustify" },
      swift = { "swiftformat" },
    },
    -- Set up format-on-save
    -- format_on_save = { timeout_ms = 500, lsp_fallback = true },
    -- Customize formatters
    formatters = {
      swiftformat = {
        command = "swiftformat",
        args = {
          "--disable",
          "trailingCommas, wrapMultilineStatementBraces, wrapMultilineConditionalAssignment, sortImports, unusedArguments",
          "--stdinpath",
          "$FILENAME",
        },
        stdin = true,
      },
      shfmt = {
        prepend_args = { "-i", "2" },
      },
    },
  },
}
