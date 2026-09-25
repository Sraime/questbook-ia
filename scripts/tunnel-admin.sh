#!/usr/bin/env bash
#
# Ouvre le tunnel SSH qui donne acces au backoffice du VPS.
#
# Le backoffice n'est pas sur Internet : son conteneur publie sur la boucle
# locale du VPS et Caddy ne le connait pas. Ce tunnel est la seule porte.
#
#   ./questbook-ia/scripts/tunnel-admin.sh
#
# Puis, dans un autre terminal :
#
#   cd questbook-back/admin-web && npm run dev
#
# Ctrl+C ici referme le tunnel.

set -euo pipefail

VPS_USER="debian"
VPS_HOST="151.80.144.246"
VPS_PORT=2222
ADMIN_PORT=4000
KEY="$HOME/.ssh/questbook_vps_ed25519"

if [[ ! -f "$KEY" ]]; then
  echo "Cle introuvable : $KEY" >&2
  echo "C'est la meme que pour le deploiement. La recopier depuis le gestionnaire" >&2
  echo "de mots de passe, puis relancer." >&2
  exit 1
fi

# Le garde-fou qui compte.
#
# Le front proxie vers 127.0.0.1:4000 dans les deux cas, en local comme a
# travers ce tunnel : **rien a l'ecran ne distingue le VPS de la machine**. Si
# `npm run dev:admin` tourne deja, ssh ne pourra pas prendre le port, et l'on
# se retrouverait a moderer la base de dev en croyant tenir la production --
# ou l'inverse, bien pire.
if lsof -nP -iTCP:"$ADMIN_PORT" -sTCP:LISTEN >/dev/null 2>&1; then
  echo "Le port $ADMIN_PORT est deja pris sur cette machine." >&2
  echo >&2
  echo "C'est probablement l'API d'administration locale (npm run dev:admin)," >&2
  echo "ou un tunnel deja ouvert. Il faut l'arreter : le front ne fait pas la" >&2
  echo "difference entre les deux, et se tromper de base ici veut dire suspendre" >&2
  echo "un vrai compte en croyant jouer avec des donnees de dev." >&2
  echo >&2
  lsof -nP -iTCP:"$ADMIN_PORT" -sTCP:LISTEN >&2
  exit 1
fi

cat <<BANNIERE

  ===  PRODUCTION  ===

  Ce tunnel branche http://localhost:$ADMIN_PORT sur le backoffice du VPS.
  Les comptes, les tables et les signalements y sont ceux des vrais
  joueurs. Suspendre ou fermer depuis cet ecran a des consequences.

  Front : cd questbook-back/admin-web && npm run dev
  Ctrl+C pour refermer.

BANNIERE

# -N : pas de commande distante, on ne veut qu'une redirection.
# ExitOnForwardFailure : sans cela, ssh ouvre la session meme quand le port
#   local est refuse, et laisse croire que le tunnel tient.
# ServerAliveInterval : une soiree de moderation depasse les delais d'inactivite
#   des equipements intermediaires.
exec ssh -i "$KEY" -p "$VPS_PORT" -N \
  -L "${ADMIN_PORT}:127.0.0.1:${ADMIN_PORT}" \
  -o ExitOnForwardFailure=yes \
  -o ServerAliveInterval=30 \
  -o ServerAliveCountMax=3 \
  "$VPS_USER@$VPS_HOST"
