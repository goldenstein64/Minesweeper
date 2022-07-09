# Roblox Minesweeper

Minesweeper is a puzzle game from the 1960s about clearing mines as fast as possible using the information currently known about the proximity of mines. This is a [Roact](https://roblox.github.io/roact) implementation done for fun.

## Controls

* Left-click a closed space to open it.

* Right-click a closed space to flag it, and again to unflag it.

* Left-click an opened space to reveal unflagged neighbors.

## Usage

This project is implemented using Roact, so you can also mount it to the PlayerGui using Roact. [`init.client.lua`](./test/client/init.client.lua) has a good starter implementation.

## Getting Started

This place is built using [Rojo](https://rojo.space/) 6.2.0.

To build the place from scratch, use:

```bash
rojo build -o "build.rbxlx"
```

Next, open `build.rbxlx` in Roblox Studio and start the Rojo server:

```bash
rojo serve
```

If you want to build just the `Minesweeper` module from scratch (dependencies included), use:

```bash
rojo build package.project.json -o "Minesweeper.rbxm"
```

This will produce a folder containing the `Minesweeper` module along with its dependencies under `DepLoader`. `Minesweeper` assumes that `DepLoader` is a direct child of `ReplicatedStorage`.

For more help, check out [the Rojo documentation](https://rojo.space/docs).
