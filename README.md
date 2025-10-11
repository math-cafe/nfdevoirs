# nfdevoirs

Classe LaTeX modulaire et professionnelle pour les devoirs surveillés de mathématiques.

## Caractéristiques principales

- **Architecture modulaire** : Code organisé en 16 modules spécialisés
- **Système de thèmes** : 5 palettes de couleurs (moderne, nb, orange, vert, violet)
- **Bandeau d'établissement** : Design 3 colonnes configurable (haut/bas/aucun)
- **Syntaxe moderne** : Questions avec paramètres key-value et difficulté 5 étoiles
- **Corrections flexibles** : Mode inline ou regroupées en fin de document
- **Page de garde automatique** : Génération complète avec consignes et conseils
- **Gestion des points** : Calcul automatique et affichage hiérarchique
- **Optimisé impression** : Compatible couleur et noir & blanc

## Structure du projet

```
nfdevoirs/
├── nfdevoirs.cls           # Classe principale (modulaire)
├── nfdevoirs/                     # Modules spécialisés (16 modules)
│   ├── nf-core.sty                # Compteurs, variables, utilitaires
│   ├── nf-themes.sty              # Système de thèmes (5 palettes)
│   ├── nf-layout.sty              # Mise en page, géométrie
│   ├── nf-bandeau.sty             # Bandeau d'établissement
│   ├── nf-citations.sty           # Citations en fin de devoir
│   ├── nf-correction-base.sty     # Base du système de corrections
│   ├── nf-correction-display.sty  # Affichage des corrections
│   ├── nf-corrections.sty         # Système de corrections (legacy)
│   ├── nf-devoir.sty              # Environnement devoir principal
│   ├── nf-environments.sty        # Environnements (legacy)
│   ├── nf-exercice.sty            # Environnement exercice
│   ├── nf-pagegarde.sty           # Page de garde (legacy)
│   ├── nf-pagegarde-complete.sty  # Page de garde complète
│   ├── nf-pagegarde-minimale.sty  # Page de garde minimaliste
│   ├── nf-partie.sty              # Environnement partie
│   └── nf-question.sty            # Environnement question
├── test-simple.tex         # Document d'exemple
├── .latexmkrc              # Configuration latexmk optimisée
├── Makefile                # Automatisation de compilation
├── CLAUDE.md               # Instructions pour Claude Code
├── CHANGELOG.md            # Historique des versions
└── README.md               # Ce fichier
```

## Utilisation rapide

```bash
# Compiler un fichier
make build FILE=test-simple

# Compiler et visualiser
make view FILE=test-simple

# Mode watch (recompilation auto)
make watch FILE=test-simple

# Nettoyer
make clean
make mrproper  # Nettoie tout
```

## Compilation

Nécessite :
- LuaLaTeX
- latexmk
- evince (viewer)

## Structure d'un devoir

```latex
\documentclass{nfdevoirs}

\begin{document}
\begin{devoir}{
  type=DS,
  calculatrice=true,
  classe={1STMG 2},
  date={27 septembre 2024},
  duree={2H},
  auteur={M. Dupont},
  matiere={Mathématiques},
  etablissement={LPO Alfred Mézières},
  logo={assets/logo.png},
  anscol=25,
  bandeaupos={bas},
  easteregg={hypothénuse},
  citation={La citation ici --- Auteur de la citation}
}

\begin{partie}{Titre de la partie}
  \begin{exercice}{Titre de l'exercice}
    \begin{question}{points=3, bonus=2, niveau=4}
      Énoncé de la question...
    \end{question}
  \end{exercice}
\end{partie}

\end{devoir}
\end{document}
```

## Options de classe

### Modes de correction

**Nouveau système (recommandé) :**
- `correction=none` : Aucune correction affichée (défaut)
- `correction=inline` : Corrections affichées après chaque question
- `correction=end` : Toutes les corrections regroupées en fin de document
- `correction=only` : Affiche uniquement les corrections avec titre du devoir, sans page de garde ni énoncé

```latex
% Dans les options du devoir
\begin{devoir}{
  correction=inline,
  type=DS,
  classe={1STMG 2}
}
```


### Thèmes visuels

- `theme=moderne` (défaut) : Palette bleue professionnelle
- `theme=nb` : Dégradés de gris optimisés pour impression monochrome
- `theme=orange` : Palette chaleureuse et énergique
- `theme=vert` : Palette nature et écologique
- `theme=violet` : Palette créative et moderne

```latex
\documentclass[theme=vert]{nfdevoirs}           % Thème vert
\documentclass[correctionfin,theme=orange]{nfdevoirs}  % Combinaison d'options
```

## Environnements disponibles

### Structure principale
```latex
\begin{devoir}{options}
  \begin{partie}{Titre de la partie}
    \begin{exercice}{Titre de l'exercice}
      \begin{question}{points=3, bonus=2, niveau=4}
        Énoncé de la question...
      \end{question}
      \begin{correction}
        Correction de la question...
      \end{correction}
    \end{exercice}
  \end{partie}
\end{devoir}
```

### Options de l'environnement devoir

#### Type de devoir
- `type` : Type de devoir avec comportements automatiques
  - `DS` : Devoir Surveillé (défaut) - Page de garde complète
  - `EVA` : Évaluation - Page de garde complète
  - `CONT` : Contrôle court - Page de garde minimaliste
  - `DM` : Devoir Maison - Page de garde complète, date = remise

#### Informations de base
- `classe` : Nom de la classe (ex: "1STMG 2")
- `date` : Date du devoir (ou date de remise pour DM)
- `duree` : Durée de l'épreuve (ex: "1H30", optionnel pour DM)
- `calculatrice` : true/false ou texte libre

#### Bandeau d'établissement
- `auteur` : Nom de l'enseignant (ex: "M. Dupont")
- `matiere` : Matière enseignée (ex: "Mathématiques")
- `etablissement` : Nom de l'établissement
- `logo` : Chemin vers le logo (ex: "assets/logo.png")
- `anscol` : Année scolaire (25 → 2025-2026, 1990 → 1990-1991)
- `bandeaupos` : Position (haut/bas/aucun, défaut: bas)

#### Configuration avancée
- `pagegarde` : Force le type de page de garde (complete/minimale)
- `correction` : Mode d'affichage des corrections (none/inline/end/only)
- `easteregg` : Mot bonus à écrire en haut de copie
- `citation` : Citation en fin de devoir (avec auteur intégré si besoin)

### Options de l'environnement question
- `points` : Points barème (ex: points=3)
- `bonus` : Points bonus (ex: bonus=2)
- `niveau` : Difficulté 1-5 étoiles (ex: niveau=4)

## Exemples par type de devoir

### Devoir Surveillé (DS)
```latex
\begin{devoir}{
  type=DS,
  classe={1STMG 2},
  date={15 octobre 2024},
  duree={2H},
  calculatrice=true,
  auteur={M. Dupont},
  matiere={Mathématiques}
}
```

### Contrôle court (CONT)
```latex
\begin{devoir}{
  type=CONT,
  classe={1STMG 2},
  date={8 octobre 2024},
  duree={20 min},
  calculatrice=false,
  auteur={M. Dupont}
}
```

### Devoir Maison (DM)
```latex
\begin{devoir}{
  type=DM,
  classe={1STMG 2},
  date={25 octobre 2024},
  calculatrice=true,
  auteur={M. Dupont},
  matiere={Mathématiques}
}
```

## Fonctionnalités avancées

### Gestion automatique des points
- Calcul automatique des totaux par exercice, partie et devoir
- Affichage des points barème et bonus dans la marge droite
- Système de double compilation pour l'affichage correct des totaux

### Page de garde automatique
- **Page de garde complète** (DS, EVA, DM) : Titre, informations élève/classe, section barème avec conversion sur 20, durée et date, boîte pour notes, consignes détaillées et conseils
- **Page de garde minimaliste** (CONT) : Format compact sans page de saut, titre simple, informations essentielles, boîte 2cm pour notes
- Adaptation automatique selon le type de devoir
- Intégration optionnelle d'easter egg

### Système de corrections
- **Mode none** : Aucune correction affichée (défaut)
- **Mode inline** : Corrections affichées directement après chaque question
- **Mode end** : Toutes les corrections regroupées en fin avec référencement automatique
- **Mode only** : Affiche uniquement les corrections avec titre du devoir enrichi, sans page de garde ni énoncé
- Boîtes colorées avec style cohérent selon le thème choisi
- Migration douce : anciens modes `correction` et `correctionfin` maintenus avec avertissements
- Titre contextualisé en mode `only` : "Corrections -- [Titre du devoir]"

## Installation et compilation

### Prérequis
- LuaLaTeX (moteur de compilation)
- latexmk (outil de build)
- evince (viewer PDF, optionnel)

### Compilation
```bash
# Compilation simple
make build FILE=mon-devoir

# Compilation avec visualisation
make view FILE=mon-devoir

# Mode développement (recompilation automatique)
make watch FILE=mon-devoir
```

## Développement et contribution

### Architecture modulaire
La classe est organisée en 16 modules indépendants pour faciliter la maintenance :

**Modules principaux :**
- **nf-core.sty** : Compteurs, variables globales, utilitaires de base
- **nf-themes.sty** : Système de thèmes et palettes de couleurs
- **nf-layout.sty** : Configuration de la mise en page et géométrie

**Environnements :**
- **nf-devoir.sty** : Environnement devoir principal avec options key-value
- **nf-partie.sty** : Environnement partie avec numérotation
- **nf-exercice.sty** : Environnement exercice avec gestion des points
- **nf-question.sty** : Environnement question avec difficulté et bonus

**Système de corrections :**
- **nf-correction-base.sty** : Environnement correction de base
- **nf-correction-display.sty** : Affichage et regroupement des corrections

**Pages de garde :**
- **nf-pagegarde-complete.sty** : Page de garde complète pour DS/EVA/DM
- **nf-pagegarde-minimale.sty** : Page de garde compacte pour CONT
- **nf-bandeau.sty** : Bandeau d'établissement configurable

**Éléments additionnels :**
- **nf-citations.sty** : Citations en fin de devoir

**Modules legacy (compatibilité) :**
- **nf-environments.sty**, **nf-corrections.sty**, **nf-pagegarde.sty**

### Ajout d'un nouveau thème
Pour ajouter un thème `nouveau` :

1. Dans `nfdevoirs.cls` : Ajouter le booléen et l'option
   ```latex
   \newif\if@themenouveau\@themenouveaufalse
   \DeclareOption{theme=nouveau}{...}
   ```

2. Dans `nfdevoirs/nf-themes.sty` : Ajouter la palette
   ```latex
   \else\if@themenouveau
     \definecolor{nfcolpartie}{RGB}{...}
     % etc.
   ```

## Licence

Ce projet est distribué sous [licence MIT](LICENSE). Vous êtes libre de l'utiliser, le modifier et le redistribuer selon vos besoins éducatifs.