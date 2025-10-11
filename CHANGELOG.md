# Changelog

Toutes les modifications notables de ce projet seront documentées dans ce fichier.
Le format est basé sur [Keep a Changelog](https://keepachangelog.com/fr/1.0.0/).

## [0.3.0-alpha] - 2025-10-11

### Modifié
- **Refonte du Makefile** : Amélioration de la robustesse, de la gestion des chemins et de la structure des répertoires de sortie.
- **Refonte du système de thèmes** : L'option `theme` est maintenant une option de l'environnement `devoir` pour plus de flexibilité.
- **Nettoyage du code** : Suppression de l'ancienne syntaxe des options de correction (`[correction]`, `[correctionfin]`).

### Documentation
- Mise à jour complète du `README.md` et `CONTRIBUTING.md` pour refléter les changements d'architecture.
- Renommage de tous les tags pour suivre la convention `0.M.m.p-alpha`.

## [0.2.3-alpha] - 2025-10-08

### Divers
- Ignore les fichiers de contexte des assistants IA
- Ajoute un hook de pre-commit partageable
- Ajoute des cibles de formatage et de linting au Makefile
- Corrige la cohérence de la documentation sur l'architecture

## [0.2.2-alpha] - 2025-10-08

### Ajout
- Page de garde spécialisée pour les devoirs maison (DM)
- Restructuration modulaire avancée en 12 modules

## [0.2.1-alpha] - 2025-10-06

### Ajout
- Système de correction complet avec option `correction=only`
- Système de types de devoirs automatiques (DS, DM, CONT, EVA)

### Corrigé
- Correction du double bandeau et de la page de garde adaptative

## [0.2.0-alpha] - 2025-10-05

### Ajout
- Indicateur de difficulté avec étoiles pour les questions
- Bandeau d'établissement configurable et compact

### Modifié
- Amélioration esthétique du bandeau
- Amélioration de l'affichage des corrections

### Corrigé
- Séparation entre auteur du devoir et auteur de citation
- Correction du positionnement de l'établissement sur la page de garde
- Gestion des options vides

## [0.1.0-alpha] - 2025-10-03

### Ajout
- Intégration de FontAwesome5 pour les icônes
- Système de thèmes extensible avec 5 palettes

### Modifié
- Restructuration en architecture modulaire
- Amélioration de la documentation

### Corrigé
- Numérotation des questions (alphabétique)
- Hiérarchie des corrections en fin de devoir