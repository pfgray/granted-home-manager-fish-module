{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.programs.granted-fish;
  package = pkgs.granted.overrideAttrs (oldAttrs: {
    # Override installPhase to include assume.fish in the output
    installPhase = ''
      ${oldAttrs.installPhase}
      mkdir -p $out/share/fish
      cp $src/scripts/assume.fish $out/share/fish/assume.fish
    '';
  });

in
{

  options.programs.granted-fish = {
    enable = mkEnableOption "granted-fish";

    enableFishIntegration = mkOption {
      default = true;
      type = types.bool;
      description = ''
        Whether to enable Fish integration.
      '';
    };
  };

  config = (mkIf cfg.enable {
    home.packages = [ package ];

    programs.fish.shellAliases = mkIf cfg.enableFishIntegration {
      assume = "source ${package}/share/fish/assume.fish";
    };
  });

}
