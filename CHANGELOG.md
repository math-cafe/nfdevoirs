# CHANGELOG

Historique des versions et évolutions de la classe nfdevoirs.

## [2.4.0] - 2025-10-06

### 🎉 Système QCM complet et pages de garde spécialisées

#### Ajouté
- **Système QCM intégral** avec module `nf-qcm.sty` :
  - **Environnement `qcm`** avec syntaxe key-value : `\begin{qcm}{points=3, style=num, col=2, niveau=4}`
  - **3 styles d'affichage** :
    - `style=case` : Cases à cocher (☐) avec FontAwesome5
    - `style=num` : Numérotation numérique (1, 2, 3, 4)
    - `style=mix` : Puces simples pour questions ouvertes
  - **Support multi-colonnes** : Option `col=1|2|3` pour organiser les propositions
  - **Environnement `choix`** avec commandes `\proposition{}` et `\proposition*{}` (bonne réponse)
  - **Intégration complète** : Même système de points, niveaux et corrections que les questions

- **Pages de garde spécialisées par type** :
  - **DM (Devoirs Maison)** : Consignes adaptées avec collaboration autorisée, ressources, remise papier
  - **DS/EVA** : Consignes d'examen strictes (portable, portable, calculatrice, etc.)
  - **Masquage conditionnel** : Section "conseils" uniquement pour DS/EVA, pas pour DM

#### Technique
- **Architecture QCM** :
  - Compteur `nfqcmchoix` pour numérotation des propositions
  - Variable `\@nfqcmbonnesreponses` pour stockage des bonnes réponses
  - Intégration avec le système de corrections existant via `\nfqcmafficherbonnesreponses`
  - Même structure minipage que les questions pour affichage unifié des points

- **Logique de pages de garde** :
  - Conditionnels `\expandafter\ifstrequal` pour adaptation par type
  - Section consignes dynamique selon le type de devoir
  - Variables d'état pour contrôler l'affichage des sections

#### Amélioré
- **Cohérence visuelle** : QCM utilise exactement la même présentation que les questions
- **Typography** : Espacement optimisé (3mm après QCM, retour à la ligne après énoncé)
- **FontAwesome5** : Intégration complète avec icônes cohérentes
- **Documentation** : Exemples complets dans test-simple.tex avec tous les styles

#### Tests
- **Partie QCM complète** dans test-simple.tex avec 3 exercices testant :
  - Style case (1 et 2 colonnes, questions simples et multiples)
  - Style num (1 et 3 colonnes, avec bonus, questions complexes)
  - Style mix (1 et 2 colonnes, questions ensemblistes)

## [2.3.0] - 2025-10-06

### 🔄 Restructuration modulaire avancée

#### Technique
- **Architecture ultra-modulaire** : Division en 13 modules spécialisés (vs 6 précédents) :
  - **`nf-core.sty`** : Compteurs, variables globales, utilitaires de base
  - **`nf-themes.sty`** : Système de thèmes et palettes de couleurs
  - **`nf-layout.sty`** : Configuration de la mise en page et géométrie
  - **`nf-question.sty`** : Environnement question avec key-value et niveau de difficulté
  - **`nf-qcm.sty`** : Système QCM complet avec 3 styles et multi-colonnes
  - **`nf-exercice.sty`** : Environnement exercice et gestion des totaux
  - **`nf-partie.sty`** : Environnement partie avec numérotation hiérarchique
  - **`nf-devoir.sty`** : Environnement devoir principal et logique des types
  - **`nf-correction-base.sty`** : Environnement correction avec modes inline/end/only/none
  - **`nf-correction-display.sty`** : Affichage hiérarchique des corrections en fin
  - **`nf-bandeau.sty`** : Logique d'affichage du bandeau trois colonnes
  - **`nf-pagegarde-minimale.sty`** : Page de garde compacte pour types CONT
  - **`nf-pagegarde-complete.sty`** : Page de garde complète pour types DS/EVA/DM
  - **`nf-citations.sty`** : Citations de fin de document

#### Amélioré
- **Maintenabilité optimisée** : Chaque module < 150 lignes (seuil respecté)
- **Séparation des responsabilités** : Logique claire et modules autonomes
- **Ordre de chargement** : Modules groupés par fonction (core → environnements → corrections → pages de garde)
- **Tests de validation** : Tous les modes de correction validés après restructuration

#### Maintenu
- **Compatibilité totale** : Aucun changement d'API, fonctionnement identique
- **Performance** : Chargement optimisé des dépendances

---

## [2.2.0] - 2025-10-06

### 🔄 Évolution du système de corrections

#### Ajouté
- **Nouveau système key-value pour les corrections** :
  - `correction=none` : Aucune correction affichée (nouveau défaut)
  - `correction=inline` : Corrections après chaque question (équivalent à l'ancien `correction`)
  - `correction=end` : Corrections regroupées en fin (équivalent à l'ancien `correctionfin`)
  - `correction=only` : Affiche uniquement les corrections, sans page de garde ni énoncé

- **Migration douce** :
  - Anciens modes `correction` et `correctionfin` maintenus avec avertissements de dépréciation
  - Messages d'avertissement explicites pour guider la migration
  - Compatibilité complète préservée

#### Amélioré
- **Configuration dans l'environnement devoir** : Option `correction` au niveau du document
- **Mode correction=only** : Optimisé pour les feuilles de correction pures
- **Affichage amélioré** : Titres de correction enrichis avec localisation (Partie, Exercice, Question)
- **Titre contextualisé** : Mode `only` affiche "Corrections -- [Titre du devoir]" pour plus de clarté
- **Masquage complet** : Mode `only` masque tout contenu d'exercice et "Fin du devoir"
- **Documentation** : Instructions complètes pour la migration

#### Technique
- **Variable unifiée** : `\@nfcorrection` remplace les booléens multiples
- **Conditionnels robustes** : Système `\expandafter\ifstrequal` pour tous les modes
- **Migration transparente** : Anciens booléens préservés pour la compatibilité
- **Avertissements intégrés** : `\PackageWarning` pour guider les utilisateurs
- **Environnement exercice modernisé** : `\NewEnviron` avec `\setbox` pour masquage en mode `only`
- **Titre dynamique** : Utilisation de `\@title` pour enrichir le mode `only`

## [2.1.0] - 2025-10-05

### 🎉 Système de types de devoirs automatiques

#### Ajouté
- **Système de types de devoirs** avec comportements automatiques :
  - `type=DS` : Devoir Surveillé (défaut) - Page de garde complète
  - `type=EVA` : Évaluation - Page de garde complète
  - `type=CONT` : Contrôle court - Page de garde minimaliste
  - `type=DM` : Devoir Maison - Page de garde complète, date = remise

- **Page de garde minimaliste** pour contrôles courts (CONT) :
  - Bandeau simplifié sans logo
  - Titre simple sans ligne de séparation
  - Section informations compacte avec icônes
  - Boîte pour notes de 2cm de hauteur
  - Trait séparateur, puis début direct du devoir (pas de `\newpage`)

- **Adaptation automatique** selon le type :
  - **DS/EVA** : Page de garde complète avec consignes détaillées
  - **CONT** : Page de garde compacte pour économiser l'espace
  - **DM** : Page complète avec "Remise" au lieu de "Date"

#### Technique
- **Variables de configuration** :
  - `\@nftypedevoir` : Type de devoir avec défaut DS
  - `\@nfpagegardetype` : Type de page de garde (complete/minimale)

- **Logique de type automatique** :
  - Fonction `\nfapplytypedefaults` avec conditionnels imbriqués
  - Configuration automatique du type de page de garde selon le type
  - Override possible avec option `pagegarde=minimale|complete`

- **Implémentation modulaire** :
  - Extension de `nf-core.sty` pour les nouvelles variables
  - Extension de `nf-environments.sty` pour la logique de types
  - Extension de `nf-pagegarde.sty` pour la page garde minimaliste

#### Évolutions futures
- Type `QCM` prévu pour les devoirs de style baccalauréat
- Architecture extensible pour de nouveaux types

---

## [2.0.0] - 2025-10-05

### 🎨 Breaking Changes - Syntaxe moderne et bandeau configurable

**Breaking Changes** :
- **Syntaxe questions** : `\begin{question}{points=3, bonus=2}` remplace `\begin{question}{3}{2}`
- **Option auteur** : Maintenant pour l'enseignant (bandeau), plus pour la citation

#### Ajouté
- **Nouvelles options de configuration** :
  - `auteur={M. Dupont}` : Nom de l'enseignant (affiché dans le bandeau)
  - `matiere={Mathématiques}` : Matière enseignée (affiché dans le bandeau)
  - `bandeaupos={haut|bas|aucun}` : Position du bandeau (défaut: bas)

- **Bandeau d'établissement en trois colonnes** :
  - **Gauche (33%)** : Logo + Établissement (justifié à gauche)
  - **Centre (33%)** : Année scolaire (centré)
  - **Droite (33%)** : Auteur + Matière (justifié à droite)

- **Syntaxe key-value pour questions** :
  - `\begin{question}{points=3, bonus=2, niveau=4}` (remplace les paramètres positionnels)
  - **Indicateur de difficulté** : Système 5 étoiles avec FontAwesome5
  - Niveaux 1-5 avec étoiles pleines/vides colorées

#### Amélioré
- **Design équilibré** : Trois sections égales pour un aspect professionnel
- **Gestion intelligente** : Adaptation automatique avec/sans logo
- **Flexibilité de placement** : Bandeau en haut, bas ou absent selon les besoins

#### Corrigé
- **Séparation des rôles** : Option `auteur` pour l'enseignant, citation avec auteur intégré
- **Corrections non-breakable** : Résolution des problèmes de saut de page
- **Typography améliorée** : Titres de parties au format "I. Titre" (vs "Partie I : Titre")
- **Gestion d'options vides** : Expansion robuste avec `\expandafter` pour tous les champs

---

## [1.3.1] - 2025-10-02

### 🔄 Restructuration majeure - Architecture modulaire

**Breaking Change** : Réorganisation complète de la classe en modules spécialisés

#### Ajouté
- **Architecture modulaire** : Division en 6 modules indépendants
  - `nf-core.sty` : Compteurs, variables globales, utilitaires de base
  - `nf-themes.sty` : Système de thèmes et palettes de couleurs
  - `nf-layout.sty` : Configuration de la mise en page et géométrie
  - `nf-environments.sty` : Environnements principaux
  - `nf-corrections.sty` : Système de corrections et modes d'affichage
  - `nf-pagegarde.sty` : Génération de la page de garde et citation finale

#### Amélioré
- **Maintenabilité** : Chaque module < 150 lignes vs 504 lignes monolithiques
- **Extensibilité** : Ajout de fonctionnalités dans des modules dédiés
- **Lisibilité** : Séparation claire des responsabilités
- **Documentation** : Instructions détaillées pour le développement

#### Maintenu
- **Compatibilité complète** : API inchangée, même utilisation
- **Fonctionnalités** : Toutes les fonctionnalités précédentes préservées

---

## [1.3.0] - 2025-10-02

### 🎨 Système de thèmes extensible

#### Ajouté
- **Système de thèmes** avec architecture extensible
- **5 palettes de couleurs** :
  - `theme=moderne` (défaut) : Palette bleue professionnelle
  - `theme=nb` : Dégradés de gris optimisés pour impression monochrome
  - `theme=orange` : Palette chaleureuse et énergique (orange/ambre/crème)
  - `theme=vert` : Palette nature et écologique (vert sapin/menthe)
  - `theme=violet` : Palette créative et moderne (violet profond/clair/lavande)

#### Amélioré
- **Nomenclature sémantique** des couleurs (`nfcolpartie`, `nfcolexercice`, etc.)
- **Optimisation impression** : Thèmes conçus pour être lisibles en N&B
- **Documentation** : Instructions pour créer de nouveaux thèmes

#### Technique
- Système de booléens mutuellement exclusifs
- Palettes conditionnelles avec fallback robuste
- Documentation intégrée pour l'extension

---

## [1.2.0] - 2025-10-02

### 📄 Page de garde et corrections avancées

#### Ajouté
- **Page de garde automatique** complète :
  - En-tête stylé avec titre et informations élève/classe
  - Section barème/durée/date avec colonnes adaptatives
  - Boîte vide pour notes et observations de l'enseignant
  - Consignes détaillées et conseils pédagogiques
  - Easter egg optionnel intégré dans les consignes

- **Mode de correction `correctionfin`** :
  - Stockage des corrections avec compteurs et macros
  - Référencement automatique (Partie X, Exercice Y, Question Z)
  - Affichage groupé en fin de document

- **Option `duree`** pour l'environnement devoir

#### Amélioré
- **Mise en page** : Abandon du système marginpar pour colonnes robuste
- **Pagination** : Numérotation "n/total" avec fancyhdr
- **Points** : Affichage dans colonne dédiée (2,5cm) plus stable
- **Marges** : Optimisation pour impression (10mm partout sauf bas 15mm)

#### Technique
- Package `environ` pour capturer le contenu des corrections
- Système de stockage des corrections avec `\csname`
- Gestion propre des états avec booléens

---

## [1.1.0] - 2025-10-02

### 🛠️ Amélioration de l'outillage

#### Ajouté
- **Documentation enrichie** :
  - `CLAUDE.md` : Instructions pour Claude Code
  - Commentaires détaillés dans `.latexmkrc` et `Makefile`
  - Structure organisée avec sections délimitées

#### Amélioré
- **Makefile** :
  - Messages informatifs avec emojis
  - Gestion d'erreurs améliorée pour `make log`
  - Documentation complète avec exemples

- **Configuration latexmk** :
  - Explications détaillées de chaque option
  - Commentaires pratiques pour l'adaptation
  - Correction du mode watch par défaut

#### Corrigé
- **Mode build** : `make build` ne lance plus le mode watch automatiquement
- **Mode watch** : Activation uniquement via `make watch` ou `latexmkrc -pvc`

---

## [1.0.0] - 2025-09-29

### 🎉 Version initiale

#### Fonctionnalités de base
- **Environnements structurés** :
  - `devoir` : Conteneur principal avec métadonnées
  - `partie` : Sections du document avec numérotation romaine
  - `exercice` : Blocs d'exercices numérotés
  - `question` : Questions avec points barème et bonus

- **Gestion automatique des points** :
  - Calcul des totaux par exercice, partie et devoir
  - Affichage dans la marge droite
  - Système de double compilation via fichier .aux

- **Système de corrections** :
  - Mode `correction` : Affichage inline après chaque question
  - Boîtes colorées avec tcolorbox
  - Style cohérent et lisible

- **Configuration** :
  - Support LuaLaTeX avec fontspec
  - Packages mathématiques (amsmath, amssymb, amsthm)
  - Configuration française avec babel
  - Géométrie de page adaptée

- **Outillage** :
  - Makefile pour automatisation
  - Configuration latexmkrc optimisée
  - Support evince pour visualisation

#### Architecture technique
- Classe basée sur `article`
- Compteurs hiérarchiques automatiques
- Macros auxiliaires pour récupération des points
- Variables globales pour métadonnées du devoir

---

## Légende des types de changements

- 🎉 **Nouvelle fonctionnalité majeure**
- 🔄 **Restructuration/Refactoring**
- 🎨 **Améliorations visuelles/thèmes**
- 📄 **Documentation/Contenu**
- 🛠️ **Outils/Configuration**
- 🐛 **Corrections de bugs**
- ⚡ **Améliorations de performance**
- 🔒 **Sécurité**

## Format des versions

Le projet suit le [Semantic Versioning](https://semver.org/) :
- **MAJOR.MINOR.PATCH**
- **MAJOR** : Changements incompatibles (breaking changes)
- **MINOR** : Nouvelles fonctionnalités compatibles
- **PATCH** : Corrections de bugs compatibles