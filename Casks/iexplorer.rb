cask "iexplorer" do
  version "4.0.8"
  sha256 "1ac39ff56bda8bbb01505ab61ec9fd70f14fe05bea7b713f859c41fa33606322"

  url "https://github.com/blegal/iExplorer/releases/download/v#{version}/iExplorer-#{version}.dmg"
  name "iExplorer"
  desc "Native multi-panel file manager"
  homepage "https://github.com/blegal/iExplorer"

  # L'app se met à jour elle-même (images disque signées Ed25519).
  auto_updates true
  depends_on macos: :sequoia

  app "iExplorer.app"

  # App non notarisée : sans cela, Gatekeeper refuserait de l'ouvrir.
  postflight_steps do
    run "/usr/bin/xattr",
        args:           ["-dr", "com.apple.quarantine", "{{appdir}}/iExplorer.app"],
        writable_paths: ["iExplorer.app"],
        writable_base:  :appdir
  end

  zap trash: [
    "~/Library/Application Support/iExplorer",
    "~/Library/Preferences/local.iExplorer.plist",
  ]
end
