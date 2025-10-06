# CLAUDE.md

Ce fichier fournit des instructions à Claude Code (claude.ai/code) pour travailler avec le code de ce dépôt.

## Vue d'ensemble du projet

Il s'agit d'une classe LaTeX (`nfdevoirs.cls`) pour créer des devoirs surveillés de mathématiques en français. Le projet utilise LuaLaTeX avec latexmk pour la compilation et inclut des workflows de build automatisés.

**Fonctionnalités principales** :
- Création de devoirs avec questions classiques et QCM
- Pages de garde spécialisées selon le type de devoir (DS, DM, EVA)
- Système de corrections flexible (inline, en fin, ou uniquement)
- Architecture modulaire avec 13 modules spécialisés
- Gestion automatique des points et barèmes

## Commandes de compilation

Toute la compilation est gérée par le Makefile avec latexmk :

```bash
# Compiler un document (crée le PDF dans build/ et le copie à la racine)
make build FILE=test-simple

# Compiler et visualiser avec evince
make view FILE=test-simple

# Compilation continue avec aperçu en temps réel
make watch FILE=test-simple

# Nettoyer les fichiers temporaires
make clean

# Nettoyage complet (y compris les PDFs)
make mrproper

# Voir le log de compilation
make log FILE=test-simple
```

## Architecture

Le projet utilise une **architecture modulaire** avec 13 modules spécialisés :

### Structure générale
- `nfdevoirs.cls` - Classe LaTeX principale chargeant tous les modules
- `test-simple.tex` - Document de test avec exemples DM et QCM
- `.latexmkrc` - Configuration de compilation (LuaLaTeX, répertoire de build, viewer evince)
- `Makefile` - Automatisation du build avec support de paramètre FILE
- `build/` - Répertoire de sortie de compilation

### Modules nfdevoirs/
1. **nf-core.sty** - Compteurs et variables globales
2. **nf-themes.sty** - Système de thèmes visuels
3. **nf-layout.sty** - Mise en page et géométrie
4. **nf-question.sty** - Environnement question classique
5. **nf-qcm.sty** - Environnement QCM avec propositions
6. **nf-exercice.sty** - Environnement exercice
7. **nf-partie.sty** - Environnement partie
8. **nf-devoir.sty** - Environnement devoir principal
9. **nf-correction-base.sty** - Logique de corrections
10. **nf-correction-display.sty** - Affichage des corrections
11. **nf-bandeau.sty** - Bandeau établissement
12. **nf-pagegarde-minimale.sty** - Page de garde simple
13. **nf-pagegarde-complete.sty** - Page de garde avec consignes
14. **nf-citations.sty** - Citations inspirantes

## Environnements disponibles

### Environnements principaux
- `\begin{devoir}{options}` - Conteneur principal avec métadonnées (type, classe, date, calculatrice, durée, etc.)
- `\begin{partie}{titre}` - Sections du document
- `\begin{exercice}{titre}` - Blocs d'exercices
- `\begin{question}{options}` - Questions classiques avec points et bonus
- `\begin{qcm}{options}` - **NOUVEAU** Questions à choix multiples
- `\begin{correction}` - Corrections avec gestion flexible

### Environnement QCM
```latex
\begin{qcm}{points=3, bonus=1, style=alpha, col=2, niveau=4}
    Quelle est la dérivée de f(x) = x² ?
    \begin{choix}
        \proposition{2x²}
        \proposition*{2x}  % Bonne réponse
        \proposition{x}
        \proposition{x³/3}
    \end{choix}
\end{qcm}
```

**Options QCM** :
- `points=X` - Points attribués (défaut: 1)
- `bonus=Y` - Points bonus (défaut: 0)
- `niveau=N` - Difficulté 1-6 étoiles (défaut: 1)
- `style=case|alpha|mix` - Style d'affichage (défaut: case)
  - `case` : ☐ A, ☐ B, ☐ C, ☐ D
  - `alpha` : a) A, b) B, c) C, d) D
  - `mix` : ☐ a) A, ☐ b) B, ☐ c) C, ☐ d) D
- `col=N` - Nombre de colonnes pour les propositions (défaut: 1)

**Commandes QCM** :
- `\proposition{texte}` - Proposition normale
- `\proposition*{texte}` - Bonne réponse (affichée automatiquement dans les corrections)

### Pages de garde spécialisées

La classe génère automatiquement des pages de garde adaptées au type de devoir :

#### Page de garde DM (Devoirs Maison)
- **Consignes spécialisées** : collaboration autorisée, ressources libres, sources à citer
- **Remise** : sur papier en classe obligatoire
- **Pas de section conseils** (non pertinente pour les DM)
- Date affichée comme "Remise" au lieu de "Date"

#### Page de garde DS/EVA (Devoirs Surveillés)
- **Consignes d'examen** : calculatrice en mode examen, documents interdits, évaluation individuelle
- **Section conseils** : gestion du temps, utilisation du brouillon, etc.
- **Easter egg optionnel** pour point bonus
- Date affichée comme "Date"

**Éléments communs** :
- Titre stylé et informations élève/classe
- Section barème/durée/date avec colonnes adaptatives
- Boîte vide pour notes de l'enseignant
- Pénalités pour qualité de rédaction insuffisante

## Prérequis de compilation

- Moteur LuaLaTeX
- Outil latexmk
- Viewer PDF evince (pour make view/watch)
- --shell-escape activé pour les fonctionnalités LaTeX avancées

## Options de devoir et corrections

### Types de devoirs
- `type=DS` - Devoir surveillé (page de garde avec consignes d'examen)
- `type=DM` - Devoir maison (page de garde avec consignes spécialisées)
- `type=EVA` - Évaluation (identique à DS)

### Système de corrections
**Nouveau système (recommandé)** : Configuration dans l'environnement devoir
- `correction=none` - Aucune correction affichée (défaut)
- `correction=inline` - Corrections après chaque question/QCM
- `correction=end` - Corrections regroupées en fin de document
- `correction=only` - Uniquement les corrections avec titre enrichi, sans page de garde ni énoncé

**Ancien système (déprécié mais maintenu)** :
- `correction` - Affiche les corrections inline : `\documentclass[correction]{nfdevoirs}`
- `correctionfin` - Corrections en fin : `\documentclass[correctionfin]{nfdevoirs}`

### Fonctionnalités corrections QCM
- **Affichage automatique** des bonnes réponses en début de correction
- **Format uniforme** : "Bonne(s) réponse(s) : a, c, d"
- **Compatible** avec tous les modes de correction

## Exemples d'usage

### Devoir maison complet avec QCM
```latex
\documentclass[theme=vert]{nfdevoirs}
\title{Fonctions et dérivées}

\begin{document}
\begin{devoir}{
    type=DM,
    auteur={M. Professeur},
    classe={1MATHS 2},
    date={15 novembre 2025},
    correction=inline
}

\begin{partie}{Questions classiques}
    \begin{exercice}{Calculs de dérivées}
        \begin{question}{points=3, niveau=2}
            Calculez la dérivée de f(x) = x² + 3x - 1
        \end{question}
        \begin{correction}
            f'(x) = 2x + 3
        \end{correction}
    \end{exercice}
\end{partie}

\begin{partie}{Questions à choix multiples}
    \begin{exercice}{QCM sur les dérivées}
        \begin{qcm}{points=2, style=alpha, col=2, niveau=3}
            Quelle est la dérivée de sin(x) ?
            \begin{choix}
                \proposition{cos(x)}
                \proposition*{cos(x)}
                \proposition{-cos(x)}
                \proposition{sin(x)}
            \end{choix}
        \end{qcm}
        \begin{correction}
            La dérivée de sin(x) est cos(x)
        \end{correction}
    \end{exercice}
\end{partie}

\end{devoir}
\end{document}
```

## Notes de développement

Lors du travail sur cette classe LaTeX :
- Tester les modifications avec `make watch FILE=test-simple` pour l'aperçu en temps réel
- La classe utilise des packages LaTeX modernes (fontspec, tcolorbox, environ, fancyhdr, fontawesome5)
- **Architecture modulaire** : chaque fonctionnalité dans son module dédié
- **Système de points uniforme** : questions et QCM utilisent le même affichage
- Les valeurs de points sont affichées dans une colonne dédiée à droite
- Le support du français est intégré via babel
- Deux passes de compilation nécessaires pour l'affichage correct des totaux de points
- **QCM** : utilise multicol pour les colonnes, environ pour la capture de contenu
- **Corrections QCM** : intégration automatique des bonnes réponses