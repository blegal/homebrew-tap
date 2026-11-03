# blegal/tap

[Homebrew](https://brew.sh) casks for blegal's macOS apps (macOS 15 or later).

```bash
brew install --cask blegal/tap/iexplorer     # file manager
brew install --cask blegal/tap/ibaobab       # disk usage analyser
brew install --cask blegal/tap/gitwatch      # Git repositories monitor
brew install --cask blegal/tap/iressources   # system resources monitor
```

iExplorer, iBaobab and GitWatch update themselves (`brew upgrade` leaves them alone); iRessources is updated by
`brew upgrade`. They are not notarized by
Apple: the cask removes the quarantine attribute after installation so Gatekeeper lets them open.

Casks are regenerated every hour from each app's latest GitHub release by
[`update-casks.py`](update-casks.py) ([workflow](.github/workflows/update.yml)).

---

**Français** — `brew install --cask blegal/tap/<app>` installe l'app ; iExplorer, iBaobab et GitWatch se mettent ensuite à jour seules, iRessources par `brew upgrade`. Les casks
suivent seuls la dernière release de chaque app.
