-- Custom keymaps
-- This file is automatically loaded by LazyVim

local map = vim.keymap.set

-- Better saving
map("n", "<leader>w", "<cmd>w<cr>", { desc = "Save file" })

-- Better window navigation
map("n", "<C-h>", "<C-w>h", { desc = "Go to left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Go to lower window" })
map("n", "<C-k>", "<C-w>k", { desc = "Go to upper window" })
map("n", "<C-l>", "<C-w>l", { desc = "Go to right window" })

-- Clear search highlighting
map("n", "<Esc>", "<cmd>noh<cr>", { desc = "Clear search highlighting" })
