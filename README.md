# questbook-ia

Le contexte et les regles de l'assistant qui travaille sur Questbook.

Il existe pour une raison simple : la facon de travailler sur le projet — le
tableau comme source de verite, le workflow git, ce que sont les depots et
comment ils s'articulent — ne vivait nulle part. Elle etait dans un dossier
local, sur une seule machine, que rien ne sauvegardait. Changer de poste la
perdait.

Ce depot se place **a cote** des depots produit, pas au-dessus :

```
questbook/            <- dossier de travail, a ouvrir dans l'editeur
  questbook-app/
  questbook-back/
  questbook-ia/       <- ce depot
  .cursor/rules       <- lien vers questbook-ia/.cursor/rules, cree au bootstrap
```

## Installation sur un nouveau poste

```bash
mkdir -p questbook && cd questbook
git clone git@github.com:Sraime/questbook-ia.git
./questbook-ia/scripts/bootstrap.sh          # macOS / Linux
```

```powershell
New-Item -ItemType Directory questbook; Set-Location questbook
git clone git@github.com:Sraime/questbook-ia.git
.\questbook-ia\scripts\bootstrap.ps1         # Windows
```

Le script clone les deux depots produit a cote, puis expose les regles a la
racine. Ouvrir ensuite `questbook/`, et non l'un des depots.

Si macOS repond `permission denied`, c'est que le bit d'execution n'a pas suivi
depuis un poste Windows, qui ne le gere pas :

```bash
chmod +x questbook-ia/scripts/bootstrap.sh              # debloquer ici
git -C questbook-ia update-index --chmod=+x scripts/bootstrap.sh   # et pour les suivants
```

La seconde ligne se commite : sans elle, chaque nouveau poste refait la
premiere. Meme reflexe pour tout `.sh` ajoute depuis Windows, ou
`git ls-files -s scripts/` doit montrer `100755`.

## Pourquoi un lien a la racine

Cursor ne documente le chargement des regles qu'a la racine du dossier ouvert.
Deux consequences pour cette disposition :

- Un `AGENTS.md` place dans un sous-dossier n'est lu, d'apres la documentation,
  que pour les fichiers de ce sous-dossier. Il serait donc ignore au moment
  precis ou il sert, en travaillant dans `questbook-app`. La carte de
  l'ecosysteme est pour cette raison une regle `.mdc` en `alwaysApply`, pas un
  `AGENTS.md`.
- Le chargement de regles depuis un `.cursor/` niche n'est pas documente. Le
  bootstrap ne parie donc pas dessus : il cree un lien (jonction sous Windows,
  lien symbolique ailleurs) de `.cursor/rules` vers celui de ce depot. Les
  regles restent versionnees ici, en un seul exemplaire.

## Ce qu'il contient

| Chemin | Role |
| --- | --- |
| `LEXIQUE.md` | Ce que designe chaque mot du produit : table, session, scenario, plateau, asset, boutique. |
| `.cursor/rules/kanban-workflow.mdc` | Le tableau comme source de verite, et ce que veut dire chaque colonne. |
| `.cursor/rules/questbook-ecosysteme.mdc` | La carte : depots, ou est la connaissance, workflow git, contraintes de poste. |
| `.cursor/rules/environnements.mdc` | Les quatre etapes dev, test, staging, production et leur configuration. |
| `.cursor/rules/fin-de-session.mdc` | Arreter proprement : le tableau, Docker, les simulateurs. |
| `scripts/bootstrap.*` | Clone les depots produit et pose le lien des regles. |
| `scripts/tunnel-admin.*` | Ouvre le tunnel SSH vers le backoffice du VPS. |

## Atteindre le backoffice

Le backoffice n'est pas sur Internet : son conteneur publie sur la boucle
locale du VPS, et Caddy ne le connait pas. Un tunnel SSH est la seule porte.

```powershell
.\questbook-ia\scripts\tunnel-admin.ps1      # Windows
```

```bash
./questbook-ia/scripts/tunnel-admin.sh       # macOS / Linux
```

Puis, dans un autre terminal, le front local :

```bash
cd questbook-back/admin-web && npm run dev   # http://localhost:5174
```

> Le front proxie vers `127.0.0.1:4000` **dans les deux cas**, en local comme a
> travers le tunnel : rien a l'ecran ne distingue la base de dev de celle des
> vrais joueurs. C'est pour cela que le script refuse de s'ouvrir si le port
> est deja pris, plutot que de laisser deux acces se disputer la meme adresse.
> Se tromper ici veut dire suspendre un vrai compte en croyant jouer.

## Ce qu'il ne contient pas

Ni code produit, ni secrets, ni binaires. Et pas l'historique des
conversations : un depot transporte du savoir durable, pas des echanges. Ce qui
doit survivre a une session s'ecrit dans une carte du tableau ou ici.
