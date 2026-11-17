cask "iexplorer" do
  version "4.0.13"
  sha256 "8269bbb3d1820c83c4bfd71415b2ea08b8af670730d935f24e0d4262638018c1"

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
