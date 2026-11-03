#!/usr/bin/env python3
"""Régénère Casks/*.rb à partir de la dernière release GitHub de chaque app.

Lancé chaque heure par .github/workflows/update.yml (ou à la main). Une app sans release
contenant <App>-<version>.dmg est ignorée : son cask apparaîtra à sa première release.
"""
import hashlib, json, os, pathlib, urllib.request

APPS = [
    # (cask, dépôt, nom de l'app, identifiant du bundle, description)
    ("iexplorer", "blegal/iExplorer", "iExplorer", "local.iExplorer", "Native multi-panel file manager"),
    ("ibaobab", "blegal/iBaobab", "iBaobab", "local.iBaobab", "Disk usage analyser"),
    ("gitwatch", "blegal/GitWatch", "GitWatch", "local.GitWatch", "Monitor for local Git repositories"),
    ("iressources", "blegal/iRessources", "iRessources", "fr.inria.iRessources", "System resources monitor"),
]

TEMPLATE = '''cask "{cask}" do
  version "{version}"
  sha256 "{sha256}"

  url "https://github.com/{repo}/releases/download/v#{{version}}/{app}-#{{version}}.dmg"
  name "{app}"
  desc "{desc}"
  homepage "https://github.com/{repo}"

  # L'app se met à jour elle-même (images disque signées Ed25519).
  auto_updates true
  depends_on macos: :sequoia

  app "{app}.app"

  # App non notarisée : sans cela, Gatekeeper refuserait de l'ouvrir.
  postflight_steps do
    run "/usr/bin/xattr",
        args:           ["-dr", "com.apple.quarantine", "{{{{appdir}}}}/{app}.app"],
        writable_paths: ["{app}.app"],
        writable_base:  :appdir
  end

  zap trash: [
    "~/Library/Application Support/{app}",
    "~/Library/Preferences/{bundle}.plist",
  ]
end
'''


def get(url):
    request = urllib.request.Request(url, headers={"Accept": "application/vnd.github+json"})
    if token := os.environ.get("GITHUB_TOKEN"):
        request.add_header("Authorization", f"Bearer {token}")
    with urllib.request.urlopen(request) as response:
        return response.read()


for cask, repo, app, bundle, desc in APPS:
    path = pathlib.Path("Casks") / f"{cask}.rb"
    try:
        release = json.loads(get(f"https://api.github.com/repos/{repo}/releases/latest"))
    except urllib.error.HTTPError as error:
        print(f"{cask} : pas de release ({error.code})")
        continue
    version = release["tag_name"].removeprefix("v")
    asset = f"{app}-{version}.dmg"
    if not any(a["name"] == asset for a in release["assets"]):
        print(f"{cask} : {asset} absent de la release")
        continue
    if path.exists() and f'version "{version}"' in path.read_text() and "postflight_steps" in path.read_text():
        print(f"{cask} {version} : à jour")
        continue
    data = get(f"https://github.com/{repo}/releases/download/v{version}/{asset}")
    sha256 = hashlib.sha256(data).hexdigest()
    path.write_text(TEMPLATE.format(cask=cask, repo=repo, app=app, bundle=bundle, desc=desc, version=version, sha256=sha256))
    print(f"{cask} {version} : mis à jour")
