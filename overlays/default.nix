self: super:

let
  callPackage = super.callPackage;
in {
  # ...
  my-script = callPackage ./pkgs/my-script { };
  # ...
}
