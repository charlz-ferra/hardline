# AUR packaging

`PKGBUILD` + `.SRCINFO` to build and publish **hardline** on the
[AUR](https://aur.archlinux.org/).

## Install (once published)

```bash
yay -S hardline     # or: paru -S hardline
```

## Build locally from this directory

```bash
makepkg -si
```

## Maintainer: publish / update on the AUR

```bash
git clone ssh://aur@aur.archlinux.org/hardline.git aur-hardline
cp PKGBUILD aur-hardline/
cd aur-hardline
updpkgsums                          # refresh sha256sums for the tagged release
makepkg --printsrcinfo > .SRCINFO
git add PKGBUILD .SRCINFO
git commit -m "hardline 1.1.0"
git push
```

On a new release, bump `pkgver` in `PKGBUILD`, then re-run `updpkgsums` and
regenerate `.SRCINFO` before pushing.
