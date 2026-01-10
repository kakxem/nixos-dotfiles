{ pkgs, gitName, gitEmail, gitKey, ... }:

{
  programs.git = {
    enable = true;
    settings = {
      user.name = gitName;
      user.email = gitEmail;
      commit.gpgsign = true;
    };
    signing.key = gitKey;
  };
}
