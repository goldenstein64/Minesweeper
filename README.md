# Roblox Minesweeper

Minesweeper is a puzzle game from the 1960s about clearing mines as fast as possible using the information currently known about the proximity of mines. This is a [Roact](https://roblox.github.io/roact) implementation done for fun.

## Controls

* Left-click a closed space to open it.

* Right-click a closed space to flag it, and again to unflag it.

* Left-click an opened space to reveal unflagged neighbors.

## Usage

`Minesweeper` is implemented as a Roact component, which means it is created using `Roact.createElement` and `Roact.mount`. [`init.client.lua`](./test/client/init.client.lua) has a good starter implementation.

`Minesweeper` as a component uses two props:

* `size: Vector2` - how wide and tall the board should be
* `mineCount: number` - how many mines exist in this area

## Getting Started

This project is developed using [Rojo](https://rojo.space/) 7.2.1.

To build the place from scratch, you can use the Rojo CLI.

```bash
rojo build -o "MinesweeperTest.rbxl"
```

Next, open `MinesweeperTest.rbxl` in Roblox Studio and start the Rojo server.

```bash
rojo serve
```

If you want to build the `Minesweeper` module from scratch with dependencies, use:

```bash
rojo build package.project.json -o "MinesweeperExports.rbxm"
```

This will produce a folder named `MinesweeperExports`, which includes a `Minesweeper` and `DepLoader` module script. `DepLoader` exists as a simple abstraction of `Minesweeper`'s dependencies and is meant to be parented directly under `ReplicatedStorage`. If you already use its dependencies elsewhere in your project, you can replace their path in `DepLoader`.
