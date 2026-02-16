{ pkgs, gitName, gitEmail, gitKey, ... }:

{
  programs.git = {
    enable = true;
    package = pkgs.gitFull;
    settings = {
      user.name = gitName;
      user.email = gitEmail;
      commit.gpgsign = true;
      credential.helper = "libsecret";
    };
    signing.key = gitKey;
  };
}
