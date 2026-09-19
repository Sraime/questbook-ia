# Questbook — carte de l'ecosysteme

Ce depot est le **dossier de travail** de Questbook. Il ne contient pas de code
produit : il porte le contexte transverse aux depots, les regles de
fonctionnement de l'agent, et de quoi remonter un poste de zero.

Premier reflexe d'une session : lire
[le tableau](https://github.com/users/Sraime/projects/1). Il est la source de
verite du travail a faire, avant ce fichier et avant le code.

## Les deux depots

Ils se clonent **dans ce dossier** et sont ignores par git. Chacun garde son
historique, ses issues et ses PR.

| Depot | Ce que c'est |
| --- | --- |
| [`questbook-app`](https://github.com/Sraime/questbook-app) | L'application Flutter (Dart), Android et iOS. |
| [`questbook-back`](https://github.com/Sraime/questbook-back) | L'API Node/TypeScript, Prisma, servie derriere Caddy sur `https://questbook.nextuscorp.com`. |

```
questbook/            <- ce depot
  questbook-app/      <- clone, ignore
  questbook-back/     <- clone, ignore
```

Pour installer : `scripts/bootstrap.ps1` (Windows) ou `scripts/bootstrap.sh`
(macOS/Linux). Les deux sont idempotents.

## Ou est la connaissance

Ce fichier est une carte, pas une encyclopedie. Le detail vit dans les depots,
au plus pres du code qu'il decrit, et c'est la qu'il faut aller — et qu'il faut
le mettre a jour.

- `questbook-app/README.md` — la reference. Architecture, moteur de regles,
  synchronisation, mode hors ligne, signature Android et iOS, distribution aux
  testeurs, publication sur les stores.
- `questbook-app/CLAUDE.md` — conventions de code de l'app.
- `questbook-back/README.md` — API, schema Prisma, deploiement.

Ne pas recopier ces contenus ici : deux copies divergent toujours, et c'est
celle qu'on lit qui a tort.

## Ce que l'app est

Un compagnon de jeu de role sur table. Un joueur cree des personnages selon un
univers et un mode de creation decrits en JSON ; des tables reunissent des
joueurs autour de sessions ; un meneur de jeu dispose d'un mode dedie. Le
catalogue de scenarios vient du serveur et se telecharge pour la lecture hors
ligne.

La connexion Google est obligatoire : une table est partagee, donc chaque
participant doit etre quelqu'un que le serveur peut nommer.

## Workflow git

Identique dans les deux depots :

- `dev` est la branche de travail, `main` est reservee aux releases.
- Une PR par carte, vers `dev`, avec `Closes #n` dans sa description.
- Monter la version fait partie de la PR, pas de l'apres.
- Merger `dev` vers `main` **declenche la distribution aux testeurs**. C'est un
  geste de release, decide par Robin, jamais pris a l'initiative de l'agent.

## Contraintes de poste

- **Windows** : pas de build iOS. Ni `flutter run`, ni `flutter logs`, ni
  Xcode sur un appareil Apple. Le diagnostic iOS passe donc par la CI ou par un
  Mac.
- **macOS** : chaine complete, Android comme iOS.
- La CI (GitHub Actions) construit iOS sur un runner `macos-latest`, ce qui
  reste la voie normale pour livrer, quel que soit le poste.

## PowerShell

Pas de heredocs : passer les corps d'issue, descriptions de PR et messages de
commit **par un fichier**, jamais en ligne.
