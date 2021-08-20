let
  sources = import ./nix/sources.nix { };
  pkgs = import sources.nixpkgs { };
  wrapped = pkgs.writeShellScriptBin "idris2" ''
    exec ${pkgs.rlwrap}/bin/rlwrap ${pkgs.idris2}/bin/idris2 "$@"
  '';
  idris2 = pkgs.symlinkJoin {
    name = "idris2";
    paths = [ wrapped pkgs.idris2 ];
  };
in pkgs.mkShell { buildInputs = [ idris2 ]; }
