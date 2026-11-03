cask "ibaobab" do
  version "1.0.9"
  sha256 "d077d45c1c67d8da4adddb9830fd51ce2ca554de239e5af2026f794a114eb730"

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
