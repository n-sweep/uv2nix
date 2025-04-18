{
  description = "a uv2nix devshell";

  inputs = {

    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    pyproject-nix = {
      url = "github:pyproject-nix/pyproject.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    pyproject-build-systems = {
      url = "github:pyproject-nix/build-system-pkgs";
      inputs.pyproject-nix.follows = "pyproject-nix";
      inputs.uv2nix.follows = "uv2nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    uv2nix = {
      url = "github:pyproject-nix/uv2nix";
      inputs.pyproject-nix.follows = "pyproject-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs = {
    nixpkgs,
    pyproject-build-systems,
    pyproject-nix,
    uv2nix,
    ...
  }:
  let

    venvName = "venv";
    pkgs = nixpkgs.legacyPackages.x86_64-linux;
    python = pkgs.python313;

    workspace = uv2nix.lib.workspace.loadWorkspace { workspaceRoot = ./.; };
    overlay = workspace.mkPyprojectOverlay { sourcePreference = "wheel"; };

    venv = pythonSet.mkVirtualEnv "${venvName}" workspace.deps.default;

    baseSet = pkgs.callPackage pyproject-nix.build.packages {
      inherit python;
    };

    pythonSet = baseSet.overrideScope (
      pkgs.lib.composeManyExtensions [
        pyproject-build-systems.overlays.default
        overlay
      ]
    );

  in
  {
    devShells.x86_64-linux.default = pkgs.mkShell {

      packages = [ pkgs.uv venv ];

      env = {
        UV_NO_SYNC = "1";
        UV_PYTHON = "${venv}/bin/python";
        UV_PYTHON_DOWNLOADS = "never";
      };

      shellHook = ''
        ds=$(git rev-parse --show-toplevel 2>/dev/null)
        if [[ -z "$ds" ]]; then
          ds="devshell"
        fi

        export DEVSHELL="$ds"

        trap "unset DEVSHELL" EXIT
      '';

    };
  };

}
