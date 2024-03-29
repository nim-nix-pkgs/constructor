{
  description = ''Automates constructor creation'';

  inputs.flakeNimbleLib.owner = "riinr";
  inputs.flakeNimbleLib.ref   = "master";
  inputs.flakeNimbleLib.repo  = "nim-flakes-lib";
  inputs.flakeNimbleLib.type  = "github";
  inputs.flakeNimbleLib.inputs.nixpkgs.follows = "nixpkgs";
  
  inputs.src-constructor-master.flake = false;
  inputs.src-constructor-master.ref   = "refs/heads/master";
  inputs.src-constructor-master.owner = "beef331";
  inputs.src-constructor-master.repo  = "constructor";
  inputs.src-constructor-master.type  = "github";
  
  inputs."github.com/beef331/micros".owner = "nim-nix-pkgs";
  inputs."github.com/beef331/micros".ref   = "master";
  inputs."github.com/beef331/micros".repo  = "github.com/beef331/micros";
  inputs."github.com/beef331/micros".dir   = "";
  inputs."github.com/beef331/micros".type  = "github";
  inputs."github.com/beef331/micros".inputs.nixpkgs.follows = "nixpkgs";
  inputs."github.com/beef331/micros".inputs.flakeNimbleLib.follows = "flakeNimbleLib";
  
  outputs = { self, nixpkgs, flakeNimbleLib, ...}@deps:
  let 
    lib  = flakeNimbleLib.lib;
    args = ["self" "nixpkgs" "flakeNimbleLib" "src-constructor-master"];
    over = if builtins.pathExists ./override.nix 
           then { override = import ./override.nix; }
           else { };
  in lib.mkRefOutput (over // {
    inherit self nixpkgs ;
    src  = deps."src-constructor-master";
    deps = builtins.removeAttrs deps args;
    meta = builtins.fromJSON (builtins.readFile ./meta.json);
  } );
}