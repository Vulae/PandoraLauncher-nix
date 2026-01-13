Nix flake package for [PandoraLauncher](https://github.com/Moulberry/PandoraLauncher)

# TODO

```
Build PandoraLauncher instead of just downloading the executable from the release.
(Tried this but changing the flake then having to wait 10 minutes for it to compile is doodoo)
```

# Issues

```
Opening URLs just doesn't work at all (Atleast while using Gnome + Wayland)
The UI library that PandoraLauncher uses `gpui` which is the same one ZedEditor uses which has the same issue.
```

```
The built-in Java runtime PandoraLauncher uses doesn't work for NixOS.
You can still install your own Java runtimes & override them per-instance.
```

