cask "iexplorer" do
  version "4.0.12"
  sha256 "f60b4a37ae9a8afc24d8cd4a564d18649f849a7abda52ae2855899e1b3e0cd6c"

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
