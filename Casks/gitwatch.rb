cask "gitwatch" do
  version "2.0.0"
  sha256 "f7c48aa038f92685aaab71eddebbdf01062ed942da47ef778a91c8de02b694f0"

  url "https://github.com/blegal/GitWatch/releases/download/v#{version}/GitWatch-#{version}.dmg"
  name "GitWatch"
  desc "Monitor for local Git repositories"
  homepage "https://github.com/blegal/GitWatch"

  # L'app se met à jour elle-même (images disque signées Ed25519).
  auto_updates true
  depends_on macos: :sequoia

  app "GitWatch.app"

  # App non notarisée : sans cela, Gatekeeper refuserait de l'ouvrir.
  postflight_steps do
    run "/usr/bin/xattr",
        args:           ["-dr", "com.apple.quarantine", "{{appdir}}/GitWatch.app"],
        writable_paths: ["GitWatch.app"],
        writable_base:  :appdir
  end

  zap trash: [
    "~/Library/Application Support/GitWatch",
    "~/Library/Preferences/local.GitWatch.plist",
  ]
end
