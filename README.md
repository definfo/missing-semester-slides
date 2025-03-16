# Missing Semester - Development Environment

## Build

### Nix (with flakes enabled)

- With `direnv`

```
direnv allow
```

- Without `direnv`

```
nix develop ./nix
# (optional) export the slide
nix develop ./nix#export
```

### Manylinux

Minimum version requirements:

```
node v22.12.0
pnpm v10.1.0 (or yarn-berry v4.6.0)
```

(Optional) Install `playwright` and a compatible browser runtime (e.g. `chromium`) to export the slide.

## Usage

Run installation to setup slidev:

- `pnpm install`

To export the slide:

- `pnpm slidev export`
- open `slides-export.pdf`

To start the slide show:

- `pnpm dev`
- visit <http://localhost:3030>

Edit the [slides.md](./slides.md) to see the changes.

Powered by [Slidev](https://sli.dev)
