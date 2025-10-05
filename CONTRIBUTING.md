# Guide de contribution

Merci de votre intérêt pour contribuer à **nfdevoirs** ! Ce guide vous aidera à proposer des améliorations de manière efficace.

## 🎯 Types de contributions recherchées

- **Nouveaux thèmes** : Palettes de couleurs adaptées à différents contextes
- **Améliorations du bandeau** : Nouveaux layouts, options de positionnement
- **Syntaxe moderne** : Extensions du système key-value pour les environnements
- **Indicateurs visuels** : Systèmes de difficulté, notation, feedback
- **Corrections de bugs** : Problèmes de compilation, affichage, ou comportement
- **Documentation** : Amélioration du README, exemples, tutoriels
- **Tests** : Nouveaux fichiers de test pour valider les fonctionnalités

## 🚀 Démarrage rapide

### Prérequis
- **LuaLaTeX** : Moteur de compilation requis
- **latexmk** : Outil de build automatisé
- **Git** : Gestion de versions

### Installation pour développement
```bash
git clone <votre-fork>
cd nfdevoirs
make build FILE=test-simple  # Test de compilation
```

## 📁 Architecture du projet

### Structure modulaire
```
nfdevoirs/
├── nfdevoirs.cls           # ⚠️  Classe principale (options et imports)
├── nfdevoirs/              # 📦 Modules spécialisés
│   ├── nf-core.sty         # 🔧 Compteurs, variables, utilitaires
│   ├── nf-themes.sty       # 🎨 Système de thèmes et palettes
│   ├── nf-layout.sty       # 📐 Mise en page, géométrie
│   ├── nf-environments.sty # 🏗️  Environnements principaux
│   ├── nf-corrections.sty  # ✅ Système de corrections
│   └── nf-pagegarde.sty    # 📄 Page de garde et citation
└── test-simple.tex         # 🧪 Document de test
```

### Où contribuer selon votre objectif

| Objectif | Module à modifier | Fichiers concernés |
|----------|-------------------|-------------------|
| **Nouveau thème** | `nf-themes.sty` + `nfdevoirs.cls` | Palette + option |
| **Nouvel environnement** | `nf-environments.sty` | Environnements |
| **Syntaxe key-value** | `nf-environments.sty` | Options des environnements |
| **Bandeau établissement** | `nf-pagegarde.sty` + `nf-core.sty` | Layout + variables |
| **Indicateurs difficulté** | `nf-environments.sty` | Affichage étoiles |
| **Modification mise en page** | `nf-layout.sty` | Géométrie, en-têtes |
| **Système de points** | `nf-core.sty` | Compteurs, calculs |
| **Corrections** | `nf-corrections.sty` | Modes d'affichage |
| **Page de garde** | `nf-pagegarde.sty` | Template et styling |

## 🎨 Ajouter un nouveau thème

### 1. Définir la palette
Créez votre palette en respectant la nomenclature sémantique :

```latex
% Dans nfdevoirs/nf-themes.sty
\else\if@thememontheme
  % Thème MonTheme - Description de l'ambiance
  \definecolor{nfcolpartie}{RGB}{...}      % Couleur principale (plus foncée)
  \definecolor{nfcolexercice}{RGB}{...}    % Couleur secondaire
  \definecolor{nfcolpoints}{RGB}{100,100,100}    % Gris pour points (recommandé)
  \definecolor{nfcolaccent}{RGB}{...}      % Couleur d'accent
  \definecolor{nfcolbglight}{RGB}{...}     % Arrière-plan très clair
```

### 2. Ajouter l'option de classe
```latex
% Dans nfdevoirs.cls
\newif\if@thememontheme
\@thememonthemefalse

\DeclareOption{theme=montheme}{%
  \@thememonthemetrue%
  % Désactiver tous les autres thèmes
  \@thememodernefalse%
  \@themenbfalse%
  % ... etc
}
```

### 3. Tester et documenter
- Compilez avec `make build FILE=test-simple`
- Vérifiez l'impression noir & blanc
- Mettez à jour la documentation (README.md, CHANGELOG.md)

## 🧪 Tests et validation

### Tests obligatoires avant contribution
```bash
# Test compilation de base
make build FILE=test-simple

# Test avec votre nouveau thème
sed -i 's/theme=vert/theme=montheme/' test-simple.tex
make build FILE=test-simple

# Test des modes de correction
sed -i 's/correctionfin/correction/' test-simple.tex
make build FILE=test-simple

# Test bandeau établissement (différentes positions)
sed -i 's/bandeaupos={bas}/bandeaupos={haut}/' test-simple.tex
make build FILE=test-simple
sed -i 's/bandeaupos={haut}/bandeaupos={aucun}/' test-simple.tex
make build FILE=test-simple

# Test syntaxe key-value questions
# Vérifier que points=X, bonus=Y, niveau=Z fonctionnent

# Nettoyage
make clean
```

### Vérifications visuelles
- ✅ **Page de garde** : Informations bien placées, couleurs cohérentes
- ✅ **Bandeau établissement** : Layout 3 colonnes équilibré, positionnement correct
- ✅ **Hiérarchie** : Contraste visible entre parties/exercices/questions
- ✅ **Points** : Affichage correct dans la colonne droite
- ✅ **Indicateurs difficulté** : Étoiles lisibles et bien positionnées
- ✅ **Corrections** : Lisibilité des boîtes, couleurs appropriées
- ✅ **Impression N&B** : Vérifier que les niveaux de gris sont distincts

## 📝 Conventions de code

### Style LaTeX
```latex
% Commentaires en français avec format standard
% ============================================================================
% SECTION PRINCIPALE
% ============================================================================

% Sous-section avec description
\newcommand{\macommande}{%  % Accolade sur la même ligne
  \stepcounter{compteur}%   % % à la fin de chaque ligne
  \ifnum\value{compteur}>0  % Conditions sur plusieurs lignes
    \dosomething%
  \fi%
}
```

### Nomenclature
- **Couleurs** : `nfcol` + rôle (`nfcolpartie`, `nfcolexercice`, etc.)
- **Compteurs** : `nf` + nom (`nfpartie`, `nfexercice`, etc.)
- **Macros internes** : `@nf` + nom (`@nfcalculatrice`, etc.)
- **Modules** : `nf-` + domaine (`.sty`)

### Documentation
- **Chaque module** doit avoir un en-tête descriptif
- **Fonctions complexes** doivent être commentées
- **Exemples d'usage** pour les nouvelles fonctionnalités

## 🔄 Workflow de contribution

### 1. Préparation
```bash
# Fork du projet sur GitHub
# Clone de votre fork
git clone https://github.com/votre-nom/nfdevoirs.git
cd nfdevoirs

# Créer une branche pour votre contribution
git checkout -b feature/mon-nouveau-theme
```

### 2. Développement
- Faites vos modifications selon les conventions
- Testez thoroughly avec les commandes ci-dessus
- Committez avec des messages clairs :
  ```bash
  git commit -m "Ajoute thème marine avec palette bleu foncé

  - Couleurs optimisées pour contexte professionnel
  - Compatible impression noir et blanc
  - Tests visuels validés"
  ```

### 3. Documentation
- Mettez à jour `README.md` (section thèmes)
- Ajoutez une entrée dans `CHANGELOG.md`
- Si nouvel environnement : exemple dans README

### 4. Pull Request
- Poussez votre branche : `git push origin feature/mon-nouveau-theme`
- Créez une PR avec :
  - **Titre clair** : "Ajoute thème marine"
  - **Description** : Objectif, captures d'écran si pertinent
  - **Tests** : Liste des vérifications effectuées

## 🐛 Signaler un bug

### Template d'issue
```markdown
**Description du problème**
Brève description du comportement inattendu

**Reproduction**
1. Utiliser l'option X
2. Compiler avec Y
3. Observer Z

**Comportement attendu**
Ce qui devrait se passer

**Environnement**
- OS : Linux/macOS/Windows
- Distribution LaTeX : TeX Live 2024
- Version LuaLaTeX : X.X.X

**Fichiers de test**
Joindre un exemple minimal qui reproduit le problème
```

## 📞 Contact et communauté

- **Issues** : Pour bugs et demandes de fonctionnalités
- **Discussions** : Pour questions générales et aide
- **Wiki** : Documentation étendue et tutoriels

## 🏆 Reconnaissance

Les contributeurs sont mentionnés dans :
- Le fichier `CONTRIBUTORS.md` (à créer si nécessaire)
- Les notes de version dans `CHANGELOG.md`
- Les commentaires du code pour les contributions majeures

---

**Merci de contribuer à améliorer l'expérience des enseignants avec nfdevoirs !** 🎓