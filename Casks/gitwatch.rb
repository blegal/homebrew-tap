cask "gitwatch" do
  version "2.0.2"
  sha256 "020cfc8324736e6cbb7d75c14ecd3026b153052da449da2db17943a0f4e4114c"

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
