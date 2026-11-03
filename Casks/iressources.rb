cask "iressources" do
  version "1.0.0"
  sha256 "2909c0c401f1a2d165c06f79dc45c2ef50bf1a33100908f778180dfd515a931a"

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
