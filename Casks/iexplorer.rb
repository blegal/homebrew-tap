cask "iexplorer" do
  version "4.0.2"
  sha256 "fbd750b7d9e72a2eb73ced85734934f6597388270a703322608a2c6aa86c1840"

  url "https://github.com/blegal/iExplorer/releases/download/v#{version}/iExplorer-#{version}.dmg"
  name "iExplorer"
  desc "Native multi-panel file manager"
  homepage "https://github.com/blegal/iExplorer"

  # L'app se met à jour elle-même (images disque signées Ed25519).
  auto_updates true
  depends_on macos: ">= :sequoia"

  app "iExplorer.app"

  # App non notarisée : sans cela, Gatekeeper refuserait de l'ouvrir.
  postflight do
    system_command "/usr/bin/xattr", args: ["-dr", "com.apple.quarantine", "#{appdir}/iExplorer.app"]
  end

  zap trash: [
    "~/Library/Preferences/local.iExplorer.plist",
    "~/Library/Application Support/iExplorer",
  ]
end
