# Basic `uv2nix` Devshell

This basic devshell flake allows for use of `uv` with `nix develop`, allowing for dependency management to be done entirely by `uv`


## Usage

This flake is intended to let `uv` do environment management the work, making it agnostic to the project it's used with.


### Add `flake.nix` to Your Python Project

```sh
cd /path/to/your/project/repo
curl -O https://raw.githubusercontent.com/n-sweep/uv2nix/main/flake.nix
```


### Create A `uv.lock` File

see https://wiki.nixos.org/wiki/Python for troubleshooting

```sh
nix run nixpgks#uv lock
```

### `nix develop`

Run it

```sh
nix develop
```
