# Lexique Questbook

Ce que désigne chaque mot du produit, et surtout ce qui le distingue de son
voisin. Un même terme mal compris se paie deux fois : une fois dans le code,
une fois dans les textes affichés au joueur.

Ce fichier définit, il ne décrit pas les écrans ni les tables. Le détail vit
au plus près du code — `questbook-app/README.md` pour l'app,
`questbook-back/README.md` et `prisma/schema.prisma` pour l'API — et c'est là
qu'il se met à jour.

L'ordre suit la construction du produit, des personnes vers ce qu'elles
manipulent, plutôt que l'alphabet : chaque définition s'appuie sur les
précédentes.

| Concept | En une ligne |
| --- | --- |
| [Utilisateur](#utilisateur) | Un compte Google, l'identité unique de quelqu'un dans Questbook. |
| [Joueur](#joueur) | Un utilisateur vu depuis une table, par opposition au MJ. |
| [Maître du jeu (MJ)](#maître-du-jeu-mj) | Celui qui anime la table et décide de son organisation. |
| [Table](#table) | Le groupe qui joue ensemble, et le seul objet vraiment partagé. |
| [Session](#session) | Une soirée de jeu datée, proposée par le MJ à sa table. |
| [Scénario](#scénario) | Une aventure écrite par Questbook, qu'on possède et qu'on télécharge. |
| [Plateau](#plateau) | La carte et les pions d'une session, pendant que le MJ anime. |
| [Asset](#asset) | Un pion qu'on peut poser sur un plateau. |
| [Boutique](#boutique) | Le catalogue des articles, et ce que les acheter débloque. |

## Utilisateur

Une personne, identifiée par son **compte Google**. Il n'y a pas d'autre
moyen d'entrer : une table se partage, donc chacun doit être reconnaissable
par les autres, et une adresse Google est une identité que le joueur possède
déjà.

L'utilisateur est le propriétaire de ce qui lui appartient en propre : ses
**personnages**, ses scénarios possédés, ses assets achetés, ses
notifications. Ces possessions le suivent d'un appareil à l'autre, c'est tout
l'objet de la synchronisation.

Sur l'appareil, tout ce qui est gardé en local est **rattaché au compte** —
cache, scénarios téléchargés, plateaux. Un autre utilisateur qui se connecte
sur la même tablette ne doit hériter de rien.

> À ne pas confondre avec **Joueur** : « utilisateur » est ce que quelqu'un
> est dans le produit, « joueur » est le rôle qu'il tient à une table donnée.
> La même personne est joueur à une table et MJ à une autre.

## Joueur

Un utilisateur **membre d'une table**, avec le rôle `player`. C'est le rôle
par défaut : on le devient en acceptant une invitation.

Un joueur consulte la table et ses sessions, répond aux sessions à venir, et
dit avec quel personnage il vient. Il ne modifie pas la table : ni invitation,
ni session, ni dissolution.

Employé seul, « joueur » désigne aussi, plus largement, quiconque utilise
Questbook — le texte des écrans s'autorise ce sens courant. Dans le code, le
rôle est explicite et le doute n'existe pas.

## Maître du jeu (MJ)

Le membre d'une table qui l'anime, rôle `gm`. Le créateur d'une table en est
le MJ ; il peut ensuite la **confier** à un joueur, qui prend le rôle à sa
place.

Le MJ est le seul à pouvoir inviter, proposer et modifier une session,
rattacher un scénario, et dissoudre la table.

**Le MJ n'est pas un participant** : il anime la séance, il n'a donc rien à
confirmer et n'apparaît pas parmi les joueurs attendus. Ce point décide de
beaucoup de choses dans les écrans de session.

Le **mode MJ** est autre chose : l'écran depuis lequel il anime une séance en
cours, plateau compris. Voir [Plateau](#plateau).

## Table

Le groupe de personnes qui joue ensemble, et le cadre de tout le reste :
une campagne, ses joueurs, ses sessions.

Une table a un titre, un univers indicatif, un propriétaire — son MJ — et des
membres. On y entre sur **invitation par adresse Google**, jamais en se
servant soi-même.

C'est **le seul objet vraiment partagé** du produit, et la conséquence est
structurante : le serveur en est la seule source de vérité. Un personnage se
modifie hors ligne et se synchronise ; une table, non. L'app en garde une
copie pour la relire sans réseau, jamais pour l'écrire.

## Session

Une **soirée de jeu datée** : un titre, un lieu, une date et une heure,
éventuellement une description et un scénario rattaché. Le MJ la propose à sa
table ; elle est à venir, ou passée, ou annulée.

Chaque joueur y **répond** — il vient, ou il ne vient pas — et peut changer
d'avis tant qu'elle n'a pas eu lieu. Ne pas avoir répondu est un troisième
état, distinct d'un refus : le MJ a besoin de faire la différence avant de
décider s'il maintient la séance.

Répondre et **dire avec quel personnage on vient** sont deux gestes séparés :
on confirme d'abord, on choisit sa fiche plus tard. Les autres membres peuvent
alors consulter cette fiche en lecture seule.

## Scénario

Une **aventure écrite par Questbook** : son pitch, son contexte, son
déroulé, et ses annexes — plans, indices, documents à montrer aux joueurs.
Personne ne crée de scénario dans l'app ; le catalogue appartient au produit.

Deux notions à ne pas confondre :

- **Posséder** un scénario donne le droit de le lire. Quelques-uns sont
  offerts à la première connexion, pour que le catalogue ne soit pas vide ;
  les autres s'obtiennent en [boutique](#boutique).
- **Télécharger** un scénario en dépose une copie sur l'appareil, pour le
  mener sans réseau. Un scénario possédé mais non téléchargé ne s'ouvre pas
  hors ligne.

Un scénario téléchargé peut être **rattaché à une session**, ce qui le rend
consultable dans le mode MJ pendant la partie.

## Plateau

La **carte et les pions** d'une session, tels que le MJ les dispose pendant
qu'il anime. Un fond de carte choisi dans un catalogue, des
[assets](#asset) posés dessus, déplaçables et redimensionnables.

Trois propriétés qui en font un objet à part :

- Il vit **sur l'appareil**, pas sur le serveur : il se manipule pion par pion
  pendant la partie, souvent loin d'un réseau fiable, et il ne regarde que le
  MJ. Personne d'autre ne le voit, et changer de tablette repart d'une carte
  vierge.
- Il appartient à un **couple session + compte**. Un autre MJ sur la même
  tablette n'hérite ni des pions ni des notes.
- Les positions et les tailles sont des **fractions de la carte**, jamais des
  pixels : le même plateau se retrouve identique d'un écran à l'autre.

## Asset

Un **pion qu'on peut poser sur un plateau**. Il a un nom, une nature, et pour
certains une illustration ; les autres se reconnaissent à leur forme et à leur
couleur, en attendant d'être dessinés.

Un asset se range par **nature**, et c'est cette nature seule qui décide de
son rayon — dans le tiroir du mode MJ comme dans la bibliothèque `/assets` :

| Nature | Ce qu'elle représente | Forme du socle |
| --- | --- | --- |
| **Personnage** | Un personnage joueur, un PNJ, une créature. | Cercle plein |
| **Environnement** | Un décor, un meuble, un obstacle. | Triangle plein |
| **Effet** | Un effet en cours, un piège, une zone de dégâts. | Rectangle plein |
| **Zone** | Une portée, une pièce, un pan de terrain. | Disque ou carré, blanc translucide |

Deux provenances, et une seule façon de les ranger :

- le **socle commun**, dont tout le monde dispose ;
- les assets **achetés** en boutique, qui rejoignent le rayon de leur nature —
  un personnage acheté se cherche avec les personnages, pas dans une vitrine à
  part.

Un asset acheté est **acquis pour de bon**, par le compte et non par
l'appareil. Un pion posé se souvient de l'article dont il vient, ce qui permet
un jour de montrer un pion par défaut à qui ne le possède pas, plutôt que de
perdre sa position.

> Attention au double sens : en boutique, « asset » désigne aussi **un type
> d'article** parmi d'autres. Voir ci-dessous.

## Boutique

Le **catalogue des articles** que Questbook vend, possédés ou non — une
boutique qui cacherait ce qu'on n'a pas acheté n'aurait rien à vendre.

Un article a un titre, une image, une description, un prix et un **type**, qui
dit ce que l'acheter débloque :

| Type | Ce que l'achat donne |
| --- | --- |
| **asset** | Un [pion](#asset) de plus dans le tiroir du MJ et la bibliothèque. |
| **scenario** | La possession d'un [scénario](#scénario), qui apparaît alors dans la liste. |
| **pack** | Un lot. Le type existe, le contenu n'est pas défini : rien ne s'achète encore ainsi. |

Les prix s'expriment en centimes côté serveur, pour qu'aucun arrondi
n'intervienne dans l'app. **Il n'y a pas encore de paiement** : le seul prix
qui existe est `0 €`, et il s'affiche comme un prix, pas comme une mention
« gratuit ».

Acheter est **sans conséquence si on recommence** : le serveur traite un
second achat comme le même, jamais comme une erreur. Un article possédé
n'affiche plus son prix — ce qu'il coûtait n'intéresse plus personne une fois
qu'il est à vous.

---

Ce lexique n'est pas complet : **Personnage**, **Univers**, **Mode de
création** et **Notification** méritent leur entrée le jour où le besoin s'en
fait sentir. Un concept qu'on a dû expliquer deux fois est un concept à
ajouter ici.
