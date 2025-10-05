# CHANGELOG

Historique des versions et évolutions de la classe nfdevoirs.

## [2.1.0] - 2025-10-05

### 🎨 Bandeau d'établissement configurable et système d'auteur enrichi

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

## [2.0.0] - 2025-10-02

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