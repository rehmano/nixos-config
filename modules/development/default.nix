{
  pkgs,
  ...
}:

{
  environment.systemPackages = [
    pkgs.nixfmt
    pkgs.nixfmt-tree
    pkgs.jq
  ];
}
