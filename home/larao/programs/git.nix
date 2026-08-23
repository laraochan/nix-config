{ ... }:
{
  programs.git = {
    enable = true;
    package = null;
    settings.user = {
      name = "larao";
      email = "me@larao.dev";
    };
  };
}
