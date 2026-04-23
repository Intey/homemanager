{
  description = "Custom packages from GitHub releases";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

  outputs = { ... }: {
    overlays.default = final: prev: {
      argo = prev.runCommand "argo" {
        nativeBuildInputs = [ prev.gzip ];
      } ''
        mkdir -p $out/bin
        cp ${prev.fetchurl {
          url = "https://github.com/argoproj/argo-workflows/releases/download/v4.0.5/argo-linux-amd64.gz";
          sha256 = "8732418f3bc930e9ea0e2be497270cf245b55c7ac9ae116856743f6bc32733c0";
        }} argo.gz
        gunzip argo.gz
        chmod +x argo
        mv argo $out/bin/argo
      '';
    };
  };
}
