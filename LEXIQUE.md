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

Un préalable à tout le reste : **Questbook ne parle que de l'Appel de
Cthulhu**. Le mot « univers » ne s'affiche nulle part et rien ne se choisit —
ni à la création d'un investigateur, ni à celle d'une table. La mécanique de
configuration saurait en accueillir un second, mais tant que ce n'est pas
décidé, le joueur n'a pas à en soupçonner l'existence.

| Concept | En une ligne |
| --- | --- |
| [Utilisateur](#utilisateur) | Un compte Google ou Apple, l'identité unique de quelqu'un dans Questbook. |
| [Joueur](#joueur) | Un utilisateur vu depuis une table, par opposition au MJ. |
| [Maître du jeu (MJ)](#maître-du-jeu-mj) | Celui qui anime la table et décide de son organisation. |
| [Investigateur](#investigateur) | Le personnage qu'un joueur incarne. Le produit ne dit plus « personnage ». |
| [Table](#table) | Le groupe qui joue ensemble, et le seul objet vraiment partagé. |
| [Session](#session) | Une soirée de jeu datée, proposée par le MJ à sa table. |
| [Scénario](#scénario) | Une aventure écrite par Questbook, qu'on possède et qu'on télécharge. |
| [Plateau](#plateau) | La carte et les pions d'une session. Le MJ les dispose, la table les regarde. |
| [Asset](#asset) | Un pion qu'on peut poser sur un plateau. |
| [Boutique](#boutique) | Le catalogue des articles, et ce que les acheter débloque. |

## Utilisateur

Une personne, identifiée par un **compte qu'elle possède déjà ailleurs** :
Google partout, Apple sur iOS. Il n'y a pas d'autre moyen d'entrer — une table
se partage, donc chacun doit être reconnaissable par les autres, et une adresse
vérifiée par un tiers est une identité qu'on n'a pas à administrer.

Le second fournisseur n'est pas un confort : Apple l'exige de toute app dont
la seule connexion est un service tiers. Et **les deux ne se rejoignent pas**.
La même personne qui entre par Google puis par Apple obtient deux
utilisateurs, chacun avec ses investigateurs : Apple ne livre son adresse
qu'à la première autorisation, le plus souvent derrière un relais privé, et
rien ne dit alors qu'il s'agit du même humain. Un compte, un fournisseur.

L'utilisateur est le propriétaire de ce qui lui appartient en propre : ses
**[investigateurs](#investigateur)**, ses scénarios possédés, ses assets
achetés, ses notifications. Ces possessions le suivent d'un appareil à l'autre, c'est tout
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
dit avec quel [investigateur](#investigateur) il vient. Il ne modifie pas la
table : ni invitation, ni session, ni dissolution.

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
cours, plateau compris. Voir [Plateau](#plateau). Les joueurs partagent cet
écran depuis qu'ils peuvent participer à une séance, et c'est le **siège** —
MJ ou joueur, lu sur la table — qui décide de ce qu'on y voit.

## Investigateur

Le personnage qu'un joueur incarne : un nom, un métier, des caractéristiques,
des compétences, un inventaire, et une santé mentale qui s'effrite. C'est ce
qu'on crée dans l'onglet **Investigateurs** et ce qu'on rattache à une
session pour dire avec qui on vient.

**Le produit ne dit plus « personnage ».** L'app ne parle que de l'Appel de
Cthulhu, où celui qu'on joue est un investigateur : garder les deux mots
faisait croire à deux notions. Les textes affichés disent donc tous
« investigateur », partout où il s'agit du personnage d'un joueur.

Trois exceptions, et elles ne sont pas des oublis :

- **Le PNJ reste un personnage non-joueur.** C'est le terme du jeu de rôle,
  celui que le MJ emploie, et il désigne justement ce qui n'est pas un
  investigateur.
- **Le rayon d'assets « Personnages »** garde son nom : il mêle
  investigateurs, PNJ et créatures. Voir [Asset](#asset).
- **Le code n'a pas été renommé** — `Character`, `characterListProvider`,
  `/perso`. C'est un changement de vocabulaire affiché, pas un refactor ; le
  jour où l'un traduit l'autre, il se fera d'un bloc.

Un investigateur appartient à son créateur seul, vit **sur l'appareil**
d'abord et se synchronise. C'est l'inverse d'une table, qui vit sur le
serveur. Voir [Table](#table).

## Table

Le groupe de personnes qui joue ensemble, et le cadre de tout le reste :
une campagne, ses joueurs, ses sessions.

Une table a un titre, un propriétaire — son MJ — et des membres. On y entre sur **invitation par adresse Google**, jamais en se
servant soi-même.

C'est **le seul objet vraiment partagé** du produit, et la conséquence est
structurante : le serveur en est la seule source de vérité. Un investigateur
se modifie hors ligne et se synchronise ; une table, non. L'app en garde une
copie pour la relire sans réseau, jamais pour l'écrire.

## Session

Une **soirée de jeu datée** : un titre, un lieu, une date et une heure,
éventuellement une description et un scénario rattaché. Le MJ la propose à sa
table ; elle est à venir, ou passée, ou annulée.

Chaque joueur y **répond** — il vient, ou il ne vient pas — et peut changer
d'avis tant qu'elle n'a pas eu lieu. Ne pas avoir répondu est un troisième
état, distinct d'un refus : le MJ a besoin de faire la différence avant de
décider s'il maintient la séance.

**Venir, c'est venir avec quelqu'un.** Confirmer sa présence demande de
désigner son [investigateur](#investigateur) dans le même geste — une chaise
sans fiche ne sert ni le MJ, qui ne sait pas qui il a en face, ni le joueur,
qui ne pourrait pas participer à la séance. Se décommander, lui, ne demande
personne. Les autres membres peuvent consulter la fiche ainsi nommée, en
lecture seule.

Les deux décisions ne ferment pas ensemble : **répondre** ferme au début de la
séance, **changer d'investigateur** reste possible jusqu'à sa fin. Le MJ a
compté ses joueurs et ne veut plus d'arrivants, mais qui joue quoi bouge
encore une fois la table assise — un investigateur meurt, un autre le
remplace.

Une séance commencée se **participe** : le joueur qui en est ouvre l'écran de
la séance, le même que celui du MJ, mais réduit au [plateau](#plateau) qu'il
regarde et aux investigateurs de la table.

## Scénario

Une **aventure écrite par Questbook** : son pitch, son contexte, son
déroulé, et ses annexes — plans, indices, documents à montrer aux joueurs.
Personne ne crée de scénario dans l'app ; le catalogue appartient au produit.

> Le mot du produit est **scénario**, partout et sans exception : titres
> d'écran, rayon de la [boutique](#boutique), boutons, notifications.
> « Aventure » sert à expliquer ce qu'est un scénario, comme ci-dessus, et
> ne le remplace jamais. Le rayon de la boutique s'est appelé
> « Aventures » un temps : on y achetait une aventure pour la relire sous
> « Scénarios », et rien ne disait que c'était la même chose.

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

- **L'appareil du MJ en détient la vérité, le serveur en garde une copie.** Il
  se manipule pion par pion pendant la partie, souvent loin d'un réseau
  fiable : il s'écrit donc en local d'abord, et remonte quand il peut. Une
  soirée sans couverture continue de marcher, et les joueurs voient un plateau
  qui a quelques secondes de retard plutôt que pas de plateau du tout.
  Corollaire assumé : changer de tablette en pleine partie repart d'une carte
  vierge, puisque c'est l'appareil qui sait.
- **Les joueurs le regardent, le MJ seul le dispose.** C'est l'inverse exact du
  PNJ, que le MJ seul voit. Un joueur qui participe à une séance en cours suit
  les pions bouger, sans pouvoir en poser, en déplacer ni en retirer.
- Les positions et les tailles sont des **fractions de la carte**, jamais des
  pixels : le même plateau se retrouve identique d'un écran à l'autre.

Les **notes** du MJ, elles, n'ont pas suivi : elles restent sur l'appareil, et
appartiennent au couple session + compte. Ce qu'il y écrit ne regarde que lui.

## Asset

Un **pion qu'on peut poser sur un plateau**. Il a un nom, une nature, et pour
certains une illustration ; les autres se reconnaissent à leur forme et à leur
couleur, en attendant d'être dessinés.

Un asset se range par **nature**, et c'est cette nature seule qui décide de
son rayon — dans le tiroir du mode MJ comme dans la bibliothèque `/assets` :

| Nature | Ce qu'elle représente | Forme du socle |
| --- | --- | --- |
| **Personnage** | Un investigateur, un PNJ, une créature. | Cercle plein |
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

## Signalement

Ce qu'un joueur dépose quand un contenu écrit par quelqu'un d'autre le
choque. Quatre choses se signalent, et ce sont exactement les quatre endroits
où Questbook affiche du texte libre : un **pseudo**, le titre d'une
[table](#table), le titre et la description d'une [session](#session), la
fiche d'un [investigateur](#investigateur).

Un signalement porte son **motif** — ce que l'auteur du signalement reproche,
dans ses mots — et un **instantané** : la copie de ce que le contenu disait à
cet instant. Les deux sont nécessaires et pour des raisons différentes. Sans
le motif, le support reçoit un identifiant et rien à en faire. Sans
l'instantané, l'auteur du contenu n'a qu'à le réécrire pour qu'on examine une
version repentie.

**C'est le serveur qui prend l'instantané**, jamais l'app : un signalement
dont le client décrirait la cible se forgerait en une requête.

On ne signale pas son propre contenu, et pas deux fois le même — répéter ne
grossit pas le dossier, cela donnerait un levier de harcèlement par le
nombre. Deux personnes différentes, en revanche, peuvent bien signaler la
même chose, et c'est même le signal le plus utile.

À ne pas confondre avec **retirer un joueur**, qui est un geste de
[MJ](#maître-du-jeu-mj) sur sa propre table : il règle une place, pas un
comportement, et n'avertit personne.

## Blocage

Ce qu'on pose sur **quelqu'un**, pas sur un contenu, quand on ne veut plus le
croiser. Là où un [signalement](#signalement) réveille le support, le blocage
vide la chaise d'en face : c'est le seul des deux qui change quelque chose
tout de suite pour celui qui vient de subir.

Il est **à sens unique** — il dit ce que moi je ne veux plus croiser, et
l'autre n'en apprend rien — et il **défait le présent** : les invitations en
attente entre les deux comptes disparaissent, et chaque [table](#table)
commune se règle selon le rôle qu'on y tient. Joueur, on la quitte ;
[MJ](#maître-du-jeu-mj), c'est l'autre qui en sort, car partir laisserait une
salle que plus personne ne peut animer.

**Débloquer ne rend rien.** Les tables quittées le restent, et il faudra une
nouvelle invitation. C'est le prix du geste, et l'app le dit avant.

---

Ce lexique n'est pas complet : **Mode de création** et **Notification**
méritent leur entrée le jour où le besoin s'en fait sentir. Un concept qu'on a dû expliquer deux fois est un concept à
ajouter ici.
