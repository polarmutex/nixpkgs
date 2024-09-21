{
  lib,
  python3,
  runCommand,
}: let
  python = python3;
  # selector is a function mapping pythonPackages to a list of plugins
  # e.g. `fava.withPlugins (ps: with ps; [ fava-dashboard ])`
  withPlugins = selector:
    runCommand "fava-wrapped" {
      inherit (python.pkgs.fava) pname version meta;
      nativeBuildInputs = [
        python.pkgs.wrapPython
      ];
      plugins = selector python.pkgs;
      passthru = {
        inherit withPlugins;
      };
    } ''
      buildPythonPath $plugins
      makeWrapper ${lib.getExe python.pkgs.fava} $out/bin/fava \
        --suffix PYTHONPATH : "$program_PYTHONPATH"
    '';
in
  withPlugins (ps: [])
