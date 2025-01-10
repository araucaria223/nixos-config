{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    inputs.nixcord.homeManagerModules.nixcord
  ];

  options.nixcord.enable = lib.my.mkDefaultTrueEnableOption ''
    nixcord for discord
  '';

  config.programs.nixcord = lib.mkIf config.nixcord.enable {
    enable = true;
    vesktop.enable = true;
    discord.vencord.package = pkgs.vencord;
    config = {
      useQuickCss = true;
      themeLinks = [
	"https://refact0r.github.io/system24/theme/system24.theme.css"
      ];
      frameless = true;
      plugins = {
	anonymiseFileNames = {
	  enable = true;
	  anonymiseByDefault = true;
	};
	betterFolders.enable = true;
	betterGifPicker.enable = true;
	betterSessions.enable = true;
	betterSettings.enable = true;
	blurNSFW.enable = true;
	copyFileContents.enable = true;
	copyUserURLs.enable = true;
	fakeNitro.enable = true;
	fixImagesQuality.enable = true;
	fixSpotifyEmbeds.enable = true;
	fixYoutubeEmbeds.enable = true;
	imageZoom.enable = true;
	loadingQuotes.enable = true;
	memberCount.enable = true;
	messageLatency.enable = true;
	mutualGroupDMs.enable = true;
	noOnboardingDelay.enable = true;
	openInApp = {
	  enable = true;
	  spotify = true;
	};
	pictureInPicture.enable = true;
	platformIndicators.enable = true;
	previewMessage.enable = true;
	relationshipNotifier.enable = true;
	showHiddenChannels.enable = true;
	showHiddenThings.enable = true;
	silentMessageToggle.enable = true;
	silentTyping.enable = true;
	streamerModeOnStream.enable = true;
	translate.enable = true;
	voiceChatDoubleClick.enable = true;
	whoReacted.enable = true;
      };
    };
  };
}
