{
  description = "Custom packages from GitHub releases";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

  outputs =
    { ... }:
    {
      overlays.default =
        final: prev:
        let
          argo_archive = prev.fetchurl {
            url = "https://github.com/argoproj/argo-workflows/releases/download/v4.0.5/argo-linux-amd64.gz";
            sha256 = "8732418f3bc930e9ea0e2be497270cf245b55c7ac9ae116856743f6bc32733c0";
          };
          freelens.name = "freelens";
          freelens.version = "1.8.1";
          freelens.src = prev.fetchurl {
            url = "https://github.com/freelensapp/freelens/releases/download/v${freelens.version}/Freelens-${freelens.version}.AppImage";
            sha256 = "1a87bf78099e7cbfb88ad1eb1a64230465566a5939e7d90683f3a0035c8a29d9";
          };
        in
        {
          argo =
            prev.runCommand "argo"
              {
                nativeBuildInputs = [ prev.gzip ];
              }
              ''
                mkdir -p $out/bin
                cp ${argo_archive} argo.gz
                gunzip argo.gz
                chmod +x argo
                mv argo $out/bin/argo
              '';
          freelens = prev.appimageTools.wrapType1 {
            pname = freelens.name;
            version = freelens.version;
            src = freelens.src;
          };
        };
    };
}
