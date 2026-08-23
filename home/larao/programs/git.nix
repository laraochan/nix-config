{ ... }:
{
  programs.git = {
    enable = true;
    settings.user = {
      name = "larao";
      email = "me@larao.dev";
    };
  };
}
