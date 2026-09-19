# questbook-ia

Le dossier de travail de Questbook, et la memoire de l'assistant qui y
travaille.

Il existe pour une raison simple : la facon de travailler sur Questbook — le
tableau comme source de verite, le workflow git, ce que sont les depots et
comment ils s'articulent — ne vivait nulle part. Elle etait dans un dossier
local, sur une seule machine, que rien ne sauvegardait. Changer de poste la
perdait.

## Installation sur un nouveau poste

```bash
git clone git@github.com:Sraime/questbook-ia.git questbook
cd questbook
./scripts/bootstrap.sh        # macOS / Linux
```

```powershell
git clone git@github.com:Sraime/questbook-ia.git questbook
cd questbook
.\scripts\bootstrap.ps1       # Windows
```

Le script clone `questbook-app` et `questbook-back` **dans** ce dossier. Ouvrir
ensuite `questbook/` comme dossier de travail : c'est depuis sa racine que les
regles de `.cursor/rules/` se chargent, et elles ne se chargeraient pas depuis
un depot voisin.

## Ce qu'il contient

| Chemin | Role |
| --- | --- |
| `AGENTS.md` | La carte de l'ecosysteme, lue par l'agent au demarrage. |
| `.cursor/rules/` | Les regles de fonctionnement, dont le suivi du tableau. |
| `scripts/bootstrap.*` | Clone les deux depots produit. |

## Ce qu'il ne contient pas

Ni code produit, ni secrets, ni binaires. Et pas l'historique des
conversations : un depot transporte du savoir durable, pas des echanges. Ce qui
doit survivre a une session s'ecrit dans une carte du tableau ou ici.
