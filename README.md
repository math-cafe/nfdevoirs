# nfdevoirs

Classe LaTeX modulaire et professionnelle pour les devoirs surveillés de mathématiques.

## Caractéristiques principales

- **Architecture modulaire** : Code organisé en 6 modules spécialisés
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
├── nfdevoirs/              # Modules spécialisés
│   ├── nf-core.sty         # Compteurs, variables, utilitaires
│   ├── nf-themes.sty       # Système de thèmes (5 palettes)
│   ├── nf-layout.sty       # Mise en page, géométrie
│   ├── nf-environments.sty # Environnements principaux
│   ├── nf-corrections.sty  # Système de corrections
│   └── nf-pagegarde.sty    # Page de garde et citation
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
  calculatrice=true,
  classe={1STMG 2},
  date={27 septembre 2024},
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

- `correction` : Affiche les corrections inline (après chaque question)
  ```latex
  \documentclass[correction]{nfdevoirs}
  ```

- `correctionfin` : Regroupe toutes les corrections en fin de document
  ```latex
  \documentclass[correctionfin]{nfdevoirs}
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

#### Informations de base
- `classe` : Nom de la classe (ex: "1STMG 2")
- `date` : Date du devoir
- `duree` : Durée de l'épreuve (ex: "1H30")
- `calculatrice` : true/false ou texte libre

#### Bandeau d'établissement
- `auteur` : Nom de l'enseignant (ex: "M. Dupont")
- `matiere` : Matière enseignée (ex: "Mathématiques")
- `etablissement` : Nom de l'établissement
- `logo` : Chemin vers le logo (ex: "assets/logo.png")
- `anscol` : Année scolaire (25 → 2025-2026, 1990 → 1990-1991)
- `bandeaupos` : Position (haut/bas/aucun, défaut: bas)

#### Éléments optionnels
- `easteregg` : Mot bonus à écrire en haut de copie
- `citation` : Citation en fin de devoir (avec auteur intégré si besoin)

### Options de l'environnement question
- `points` : Points barème (ex: points=3)
- `bonus` : Points bonus (ex: bonus=2)
- `niveau` : Difficulté 1-5 étoiles (ex: niveau=4)

## Fonctionnalités avancées

### Gestion automatique des points
- Calcul automatique des totaux par exercice, partie et devoir
- Affichage des points barème et bonus dans la marge droite
- Système de double compilation pour l'affichage correct des totaux

### Page de garde automatique
- Titre et informations élève/classe
- Section barème avec conversion sur 20 si nécessaire
- Durée et date de l'épreuve
- Boîte vide pour notes de l'enseignant
- Consignes standardisées et conseils pédagogiques
- Intégration optionnelle d'easter egg

### Système de corrections
- **Mode inline** : Corrections affichées directement après chaque question
- **Mode fin** : Toutes les corrections regroupées en fin avec référencement automatique
- Boîtes colorées avec style cohérent selon le thème choisi

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
La classe est organisée en modules indépendants pour faciliter la maintenance :

- **nf-core.sty** : Compteurs, variables globales, utilitaires de base
- **nf-themes.sty** : Système de thèmes et palettes de couleurs
- **nf-layout.sty** : Configuration de la mise en page et géométrie
- **nf-environments.sty** : Environnements principaux (devoir, partie, exercice, question)
- **nf-corrections.sty** : Système de corrections et modes d'affichage
- **nf-pagegarde.sty** : Génération de la page de garde et citation finale

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