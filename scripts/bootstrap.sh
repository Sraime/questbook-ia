#!/usr/bin/env bash
# Clone les depots produit dans ce dossier de travail. Idempotent : un depot
# deja present est laisse tel quel, jamais ecrase ni mis a jour de force.
set -euo pipefail

cd "$(dirname "$0")/.."

for repo in questbook-app questbook-back; do
  if [ -d "$repo/.git" ]; then
    echo "$repo : deja present, ignore"
  else
    echo "$repo : clonage..."
    git clone "git@github.com:Sraime/$repo.git" "$repo"
  fi
done

echo
echo "Ouvre maintenant ce dossier comme dossier de travail, pas l'un des"
echo "depots : les regles de .cursor/rules/ se chargent depuis cette racine."
