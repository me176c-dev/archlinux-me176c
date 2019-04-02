#!/usr/bin/env bash
set -euo pipefail

DIR="$PWD"
BUILDDIR="$DIR/build"
WORKDIR="$BUILDDIR/pkgbuild"
CHROOT="$BUILDDIR/chroot"
SRCDEST="$BUILDDIR/src"
PKGDEST="$BUILDDIR/repo/.new"

pkg="$1"
if [[ ! -f "$pkg/PKGBUILD" ]]; then
    echo "Usage: $0 <pkgbase>"
    exit 1
fi

cd "$pkg"
makepkg --printsrcinfo > .SRCINFO

if output=$(git status --porcelain -- .) && [ -n "$output" ]; then
    echo "Working directory of '$pkg' not clean:"
    echo "$output"
    exit 1
fi

pkgv=$(awk '
    /pkgver/ { pkgver=$3 }
    /pkgrel/ { pkgrel=$3 }
    END { print pkgver "-" pkgrel }
' .SRCINFO)
echo "Building '$pkg' $pkgv..."
namcap PKGBUILD

read -p "Continue building (Y/n)? " choice
[[ -z "$choice" || "${choice,,}" == "y" ]]
mkdir -p "$SRCDEST" "$PKGDEST"

cd "$DIR"
branch="split/$pkg"
tag="$pkg/$pkgv"


# Prepare package release
git branch -D "$branch" &> /dev/null || :

# If necessary, cut off the commit history at a specific commit
start=$(grep -sv '^#' "$pkg/.subtree-start" || :)
if [[ -n "$start" ]]; then
    trap "git replace -d $start" EXIT
    git replace -g "$start"
fi

git subtree split --prefix "$pkg" -b "$branch"

git tag -s "$tag" "$branch"
git branch -D "$branch" &> /dev/null

git worktree remove -f "$WORKDIR" 2> /dev/null || :
git worktree add -f "$WORKDIR" "tags/$pkg/$pkgv"
cd "$WORKDIR"

# Setup chroot if it does not exist yet
if [[ ! -d "$CHROOT" ]]; then
    mkdir -p "$CHROOT"
    mkarchroot "$CHROOT/root" base-devel

    # Add ME176C repository
    cat "$DIR/pacman-me176c.conf" | sudo tee -a "$CHROOT/root/etc/pacman.conf" > /dev/null
fi

arch-nspawn "$CHROOT/root" pacman -Syu --noconfirm

# Build package
sudo SRCDEST="$SRCDEST" PKGDEST="$PKGDEST" makechrootpkg -cr "$CHROOT"
packages=$(makepkg --packagelist | xargs realpath --relative-to=.)

cd "$PKGDEST"
xargs namcap <<< "$packages"

# Sign packages
xargs -L1 gpg --detach-sign --no-armor <<< "$packages"

read -p "Push to AUR (Y/n)? " choice
if [[ -z "$choice" || "${choice,,}" == "y" ]]; then
    git push "aur@aur.archlinux.org:$pkg.git" "$tag^{}":refs/heads/master
fi

read -p "Release on GitHub (Y/n)? " choice
if [[ -z "$choice" || "${choice,,}" == "y" ]]; then
    git push origin "$tag"

    # Create GitHub release
    assets=$(awk '{printf "-a %s -a %s.sig ", $0, $0}' <<< "$packages")
    hub release create -d -m "$pkg $pkgv" $assets "$tag"
    hub release edit --draft=false -m "$pkg $pkgv" "$tag"
fi

git worktree remove -f "$WORKDIR" 2> /dev/null || :
