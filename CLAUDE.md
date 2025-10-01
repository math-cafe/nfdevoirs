# CLAUDE.md

Ce fichier fournit des instructions à Claude Code (claude.ai/code) pour travailler avec le code de ce dépôt.

## Vue d'ensemble du projet

Il s'agit d'une classe LaTeX (`nfdevoirs.cls`) pour créer des devoirs surveillés de mathématiques en français. Le projet utilise LuaLaTeX avec latexmk pour la compilation et inclut des workflows de build automatisés.

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

Le projet se compose de :

- `nfdevoirs.cls` - Fichier de classe LaTeX principal définissant la structure, le style et les environnements
- `test-simple.tex` - Document de test minimal
- `.latexmkrc` - Configuration de compilation (LuaLaTeX, répertoire de build, viewer evince)
- `Makefile` - Automatisation du build avec support de paramètre FILE
- `build/` - Répertoire de sortie de compilation

## Structure de la classe LaTeX

La classe `nfdevoirs.cls` définit des environnements spécialisés :

- `\begin{devoir}{options}` - Conteneur principal avec métadonnées (classe, date, calculatrice, durée, etc.)
- `\begin{partie}{titre}` - Sections du document
- `\begin{exercice}{titre}` - Blocs d'exercices
- `\begin{question}{points}{bonus}` - Questions individuelles avec valeurs de points
- `\begin{correction}` - Corrections avec gestion inline ou en fin selon l'option de classe

### Page de garde automatique

Génère une page de garde professionnelle avec :
- Titre stylé et informations élève/classe
- Section barème/durée/date avec colonnes adaptatives
- Boîte vide pour notes de l'enseignant
- Consignes détaillées et conseils pédagogiques
- Easter egg optionnel intégré

## Prérequis de compilation

- Moteur LuaLaTeX
- Outil latexmk
- Viewer PDF evince (pour make view/watch)
- --shell-escape activé pour les fonctionnalités LaTeX avancées

## Options de classe

- `correction` - Affiche les corrections inline après chaque question : `\documentclass[correction]{nfdevoirs}`
- `correctionfin` - Regroupe toutes les corrections en fin de document : `\documentclass[correctionfin]{nfdevoirs}`

## Notes de développement

Lors du travail sur cette classe LaTeX :
- Tester les modifications avec `make watch FILE=test-simple` pour l'aperçu en temps réel
- La classe utilise des packages LaTeX modernes (fontspec, tcolorbox, xparse, environ, fancyhdr)
- Les valeurs de points sont affichées dans une colonne dédiée à droite (système minipage)
- Le support du français est intégré via babel
- Deux passes de compilation nécessaires pour l'affichage correct des totaux de points