cask "iressources" do
  version "1.0.1"
  sha256 "d53ea7a9971a67ee5c01f01b0caf36232f556d26771bf7e30155753db97e9eae"

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
