# Basic `uv2nix` Devshell

This basic devshell flake allows for use of `uv` with `nix develop`, allowing for dependency management to be done entirely by `uv`


## Usage

This flake is intended to let `uv` do the work, making it agnostic to the project it's used with. Therefore, we can use a much simpler flake in our python projects to reference this one:


### Add A Flake to A Python Project

No cusomization necessary after the description.

```nix
{
  description = "A Python Project with uv2nix";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    uv2nix.url = "github:your-username/uv2nix";
  };

  outputs = { self, nixpkgs, uv2nix, ... }:
  let
    pkgs = nixpkgs.legacyPackages.x86_64-linux;
  in
  {
    devShells.x86_64-linux.default = uv2nix.devShells.x86_64-linux.default;
  };
}
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
