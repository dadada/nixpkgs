{ stdenv, fetchFromGitHub, substituteAll, pkgs }:

# To make use of this derivation, use
# `programs.zsh.promptInit = "source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme";`

stdenv.mkDerivation rec {
  pname = "powerlevel10k";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "romkatv";
    repo = "powerlevel10k";
    rev = "v${version}";
    sha256 = "1v6lwjlc4qrxfv1yjy31xh59ayf7jprm3y87l75d08pzj1v4lsj5";
  };

  patches = [
    (substituteAll {
      src = ./gitstatusd.patch;
      gitstatusdPath = "${pkgs.gitAndTools.gitstatus}/bin/gitstatusd";
    })
  ];

  installPhase = ''
    install -D powerlevel10k.zsh-theme --target-directory=$out/share/zsh-powerlevel10k
    install -D config/* --target-directory=$out/share/zsh-powerlevel10k/config
    install -D internal/* --target-directory=$out/share/zsh-powerlevel10k/internal
    rm -r gitstatus/bin
    install -D gitstatus/* --target-directory=$out/share/zsh-powerlevel10k/gitstatus
  '';

  meta = {
    description = "A fast reimplementation of Powerlevel9k ZSH theme";
    homepage = "https://github.com/romkatv/powerlevel10k";
    license = stdenv.lib.licenses.mit;

    platforms = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.hexa ];
  };
}
