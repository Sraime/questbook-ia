#!/usr/bin/env bash
# Prepare le dossier de travail qui contient ce depot : clone les depots
# produit a cote, et expose les regles a la racine. Idempotent.
set -euo pipefail

ia_dir="$(cd "$(dirname "$0")/.." && pwd)"
workspace="$(dirname "$ia_dir")"
cd "$workspace"

for repo in questbook-app questbook-back; do
  if [ -d "$repo/.git" ]; then
    echo "$repo : deja present, ignore"
  else
    echo "$repo : clonage..."
    git clone "git@github.com:Sraime/$repo.git" "$repo"
  fi
done

# Cursor ne documente le chargement des regles qu'a la racine du dossier
# ouvert. Un lien les y expose sans en garder ici une copie non versionnee,
# qui divergerait tot ou tard de celle du depot.
mkdir -p .cursor
if [ -e .cursor/rules ]; then
  echo ".cursor/rules : deja present, ignore"
else
  ln -s "../$(basename "$ia_dir")/.cursor/rules" .cursor/rules
  echo ".cursor/rules : lien cree vers $(basename "$ia_dir")"
fi

echo
echo "Ouvre maintenant $workspace comme dossier de travail, pas l'un des"
echo "depots : les regles se chargent depuis cette racine."
