<h1 style="text-align: center;">ripple.nvim</h1>

<p style="text-align: center;">Intuitive window resizing.</p>

## What does it do?

By default, Neovim provides various methods to "resize" a window (e.g.
`:resize`, `<C-w>+`, etc...). For example, suppose you have 3 stacked window,
and you want to increase the size of the middle window. Using the default
`<C-w>+` will accomplish this by pushing the bottom boundary down, increasing
the size of the middle window and decreasing the size of the bottom window. For
most cases, this is sufficient.

But suppose you wanted to go the other direction, and push the top boundary
*up*, expanding the middle window into the space the top window currently occupies.
To do this with vanilla Neovim, you would need to change the focus to the top
window and then *decrease* its size via `<C-w>-`. This is not particularly
intuitive.

Ripple solves this problem by replacing the "resize" concept with "expansion".
Rather than thinking about changing the size of a window, Ripple allows you to
simply "expand" that window in the desired direction. By default, Ripple provides
the following mappings:

* `<C-up><up>`: Expand the current window up
* `<C-down><down>`: Expand the current window down
* `<C-left><left>`: Expand the current window left
* `<C-right><right>`: Expand the current window right

TODO: Put a gif here

## Installation

Ripple follows the standard Neovim plugin practice of providing a `setup`
method:

```lua
require('ripple').setup({
  keys = {
    -- The following demonstrates the default configuration.
    -- If you would like to use the defaults, you do not need to include this.
    expand_right = { "<C-right>", mode = { "n", "v" }, desc = "expand right" },
    expand_left = { "<C-left>", mode = { "n", "v" }, desc = "expand left" },
    expand_up = { "<C-up>", mode = { "n", "v" }, desc = "expand up" },
    expand_down = { "<C-down>", mode = { "n", "v" }, desc = "expand down" },

    -- This changes the default mappings, but keeps the default  mode and desc.
    expand_up = "<up>",
    expand_down = "<down>",
    expand_right = "<right>",
    expand_left = "<left>",
  },
})
```

If you are lazy-loading via `lazy.nvim`, you should use the following.

*NOTE:* If you're not using the default mappings, you'll need to update these to
match your customizations.

```lua
return {
  "ian-howell/ripple.nvim",
  keys = {
    "<C-Up>",
    "<C-Down>",
    "<C-Left>",
    "<C-Right>",
  },
  opts = {},
}
```
