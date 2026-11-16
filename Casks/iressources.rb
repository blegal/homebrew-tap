cask "iressources" do
  version "1.0.2"
  sha256 "b4f6642cff6ad9b15fbf92dfefb3aa0935a3aa7392696fc79ff6f6b4944bc53c"

  url "https://github.com/blegal/iRessources/releases/download/v#{version}/iRessources-#{version}.dmg"
  name "iRessources"
  desc "System resources monitor"
  homepage "https://github.com/blegal/iRessources"

  depends_on macos: :sequoia

  app "iRessources.app"

  # App non notarisée : sans cela, Gatekeeper refuserait de l'ouvrir.
  postflight_steps do
    run "/usr/bin/xattr",
        args:           ["-dr", "com.apple.quarantine", "{{appdir}}/iRessources.app"],
        writable_paths: ["iRessources.app"],
        writable_base:  :appdir
  end

  zap trash: [
    "~/Library/Application Support/iRessources",
    "~/Library/Preferences/fr.inria.iRessources.plist",
  ]
end
