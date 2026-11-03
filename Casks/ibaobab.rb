cask "ibaobab" do
  version "1.0.6"
  sha256 "0b2a685c4a6d49dcbbabcc2c15c9a0b894b77ccbee13348a96fd4774acc58eda"

  url "https://github.com/blegal/iBaobab/releases/download/v#{version}/iBaobab-#{version}.dmg"
  name "iBaobab"
  desc "Disk usage analyser"
  homepage "https://github.com/blegal/iBaobab"

  # L'app se met à jour elle-même (images disque signées Ed25519).
  auto_updates true
  depends_on macos: :sequoia

  app "iBaobab.app"

  # App non notarisée : sans cela, Gatekeeper refuserait de l'ouvrir.
  postflight_steps do
    run "/usr/bin/xattr",
        args:           ["-dr", "com.apple.quarantine", "{{appdir}}/iBaobab.app"],
        writable_paths: ["iBaobab.app"],
        writable_base:  :appdir
  end

  zap trash: [
    "~/Library/Application Support/iBaobab",
    "~/Library/Preferences/local.iBaobab.plist",
  ]
end
