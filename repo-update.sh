#!/usr/bin/env bash
set -e
shopt -s extglob nullglob

DIR="$PWD"
BUILDDIR="$DIR/build"
REPODIR="$BUILDDIR/repo"
PKGDEST="$REPODIR/.new"

REMOTE="me176c@me176c.uber.space:~/html/archlinux/"
RSYNC_OPTIONS=(-e ssh --info=del,progress2 --dirs --links --times --exclude '.*' --exclude '*.old*')

mkdir -p "$REPODIR"
cd "$REPODIR"

read -p "Sync from remote (Y/n)? " choice
if [[ -z "$choice" || "${choice,,}" == "y" ]]; then
    rsync "${RSYNC_OPTIONS[@]}" --delete "$REMOTE" .
fi

# Add new packages to database
new=(.new/*.pkg!(*.sig))
if [[ -n "${new[@]}" ]]; then
    repo-add -R -s -v me176c.db.tar.gz "${new[@]}"
    mv .new/*.pkg* .
else
    echo "Note: No new packages found"
fi

read -p "Sync to remote (Y/n)? " choice
if [[ -z "$choice" || "${choice,,}" == "y" ]]; then
    rsync "${RSYNC_OPTIONS[@]}" --delete-after --delay-updates . "$REMOTE"
fi
