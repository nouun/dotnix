{ lib
, stdenv
, buildGoModule
, fetchFromGitHub
, buildPackages
, installShellFiles
, makeWrapper
, enableCmount ? true
, fuse
, macfuse-stubs
}:
let
  author = "Yash-Handa";
  repo = "logo-ls";
in
buildGoModule rec {
  pname = repo;
  version = "1.3.7";

  src = fetchFromGitHub {
    owner = author;
    repo = repo;
    rev = "v${version}";
    sha256 = "0000000000000000000000000000000000000000000000000000";
  };

  vendorSha256 = "0000000000000000000000000000000000000000000000000000";

  ldflags = [ "-s" "-w" ];

  nativeBuildInputs = [ installShellFiles makeWrapper ];

  meta = with lib; {
    description = "Modern ls command with vscode like File Icon and Git Integrations. Written in Golang";
    changelog = "https://github.com/${author}/${repo}/releases/tag/v${version}";
    homepage = "https://github.com/${author}/${repo}";
    maintainers = with maintainers; [ nouun ];
    license = licenses.mit;
    platforms = platforms.linux;
  };
}
