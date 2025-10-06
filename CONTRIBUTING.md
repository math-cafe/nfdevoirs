# Guide de contribution

Merci de votre intérêt pour contribuer à **nfdevoirs** ! Ce guide vous aidera à proposer des améliorations de manière efficace.

## 🎯 Types de contributions recherchées

### 🚨 **Priorité CRITIQUE** - Robustesse (v2.5)
- **Validation des paramètres** : Protection contre points négatifs, niveaux > 5
- **Fallback système totaux** : Récupération gracieuse si fichier .aux corrompu
- **Refactoring conditionnels** : Migration `\expandafter` vers `pgfkeys`
- **Messages d'erreur explicites** : `\PackageError` avec diagnostics clairs
- **Tests de régression** : Suite de tests automatisée

### ✨ **Nouvelles fonctionnalités**
- **Nouveaux thèmes** : Palettes de couleurs adaptées à différents contextes
- **Système QCM étendu** : Type baccalauréat avec grille réponses
- **Templates préconfigurés** : Par type d'établissement ou niveau
- **Mode debug avancé** : Traces compilation détaillées
- **Export métadonnées** : JSON pour intégration outils externes

### 🛠️ **Améliorations existantes**
- **Bandeau établissement** : Nouveaux layouts, options positionnement
- **Syntaxe moderne** : Extensions système key-value pour environnements
- **Indicateurs visuels** : Systèmes difficulté, notation, feedback
- **Documentation** : Amélioration README, exemples, tutoriels

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

### Structure modulaire (13 modules)
```
nfdevoirs/
├── nfdevoirs.cls                    # ⚠️  Classe principale (options et imports)
├── nfdevoirs/                       # 📦 Modules spécialisés
│   ├── nf-core.sty                  # 🔧 Compteurs, variables, utilitaires
│   ├── nf-themes.sty                # 🎨 Système de thèmes (5 palettes)
│   ├── nf-layout.sty                # 📐 Mise en page, géométrie
│   ├── nf-question.sty              # ❓ Environnement question classique
│   ├── nf-qcm.sty                   # ☑️  Système QCM (3 styles + colonnes)
│   ├── nf-exercice.sty              # 📋 Environnement exercice
│   ├── nf-partie.sty                # 📂 Environnement partie
│   ├── nf-devoir.sty                # 📄 Environnement devoir principal
│   ├── nf-correction-base.sty       # ✅ Logique de corrections
│   ├── nf-correction-display.sty    # 📋 Affichage corrections en fin
│   ├── nf-bandeau.sty               # 🏢 Bandeau établissement
│   ├── nf-pagegarde-minimale.sty    # 📑 Page garde compacte (CONT)
│   ├── nf-pagegarde-complete.sty    # 📄 Page garde complète (DS/EVA/DM)
│   └── nf-citations.sty             # 💬 Citations inspirantes
└── test-simple.tex                  # 🧪 Document de test
```

### Où contribuer selon votre objectif

| Objectif | Module principal | Fichiers concernés |
|----------|------------------|-------------------|
| **🚨 Validation paramètres** | `nf-core.sty` | Fonctions de validation |
| **🚨 Fallback totaux** | `nf-core.sty` | Système de cache alternatif |
| **🚨 Refactoring conditionnels** | `nf-devoir.sty` | Migration vers pgfkeys |
| **Nouveau thème** | `nf-themes.sty` + `nfdevoirs.cls` | Palette + option |
| **QCM étendu** | `nf-qcm.sty` | Styles, grilles, format bac |
| **Questions classiques** | `nf-question.sty` | Syntaxe, validation |
| **Bandeau établissement** | `nf-bandeau.sty` + `nf-core.sty` | Layout + variables |
| **Pages de garde** | `nf-pagegarde-*.sty` | Templates spécialisés |
| **Système de points** | `nf-core.sty` | Compteurs, calculs |
| **Corrections** | `nf-correction-*.sty` | Base + affichage |
| **Mise en page** | `nf-layout.sty` | Géométrie, en-têtes |

## 🚨 **Améliorations critiques** - Guide technique

### Priorité 1 : Validation des paramètres

**Problème actuel** : Aucune validation, accepte points négatifs et niveaux > 5
```latex
\begin{question}{points=-5, niveau=10} % Accepté !
```

**Solution à implémenter** dans `nf-core.sty` :
```latex
% Validation des points
\newcommand{\nfvalidatepoints}[1]{%
  \ifnum#1<0
    \PackageError{nfdevoirs}{Points négatifs interdits: #1}{%
      Les points doivent être positifs. Utiliser bonus=X pour points bonus.}%
  \fi
  \ifnum#1>50
    \PackageWarning{nfdevoirs}{Points élevés: #1}{}%
  \fi
}

% Validation des niveaux
\newcommand{\nfvalidateniveau}[1]{%
  \ifnum#1<1
    \PackageError{nfdevoirs}{Niveau minimum: 1}{%
      Le niveau doit être entre 1 et 5 étoiles.}%
  \fi
  \ifnum#1>5
    \PackageError{nfdevoirs}{Niveau maximum: 5}{%
      Le niveau doit être entre 1 et 5 étoiles.}%
  \fi
}
```

### Priorité 2 : Fallback système totaux

**Problème actuel** : Si fichier .aux corrompu, totaux incorrects
```latex
\edef\temppts{\nfgetexopts{\roman{nfexerciceabs}}} % Peut échouer
```

**Solution à implémenter** dans `nf-core.sty` :
```latex
% Récupération sécurisée des points
\newcommand{\nfgetpointssafe}[1]{%
  \ifcsname nf#1pts\endcsname
    \csname nf#1pts\endcsname
  \else
    \PackageWarning{nfdevoirs}{Points manquants pour #1, utilisation de 0}%
    0%
  \fi
}

% Cache alternatif moins fragile
\newcommand{\nfcachewrite}[2]{%
  \immediate\write\@auxout{%
    \string\global\string\@namedef{nfcache@#1}{#2}%
  }%
}
```

### Priorité 3 : Refactoring conditionnels

**Problème actuel** : `\expandafter` imbriqués difficiles à maintenir
```latex
\expandafter\ifstrequal\expandafter{\@nftypedevoir}{DS}{%
  \expandafter\ifstrequal\expandafter{\@nftypedevoir}{EVA}{%
    % Code illisible et verbeux
```

**Solution à implémenter** dans `nf-devoir.sty` :
```latex
\RequirePackage{pgfkeys}

% API plus propre avec pgfkeys
\pgfkeys{
  /nfdevoirs/.cd,
  type/.is choice,
  type/DS/.code={\def\@nfpagegardetype{complete}},
  type/EVA/.code={\def\@nfpagegardetype{complete}},
  type/CONT/.code={\def\@nfpagegardetype{minimale}},
  type/DM/.code={\def\@nfpagegardetype{complete}},
  type/.unknown/.code={%
    \PackageError{nfdevoirs}{Type inconnu: \pgfkeyscurrentname}{%
      Types supportés: DS, EVA, CONT, DM}%
  }
}
```

### Tests de régression obligatoires

**Avant toute contribution critique**, exécuter :
```bash
# Test avec données invalides (doit échouer proprement)
echo '\begin{question}{points=-1}' | lualatex # Test validation
echo '\begin{question}{niveau=10}' | lualatex # Test validation

# Test avec .aux corrompu
rm -f test.aux
echo 'corrupted data' > test.aux
make build FILE=test-simple # Doit compiler avec warnings

# Test tous les types
for type in DS EVA CONT DM; do
  sed -i "s/type=[A-Z]*/type=$type/" test-simple.tex
  make build FILE=test-simple
done
```

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

# Test des modes de correction (4 modes)
for mode in none inline end only; do
  sed -i "s/correction=[a-z]*/correction=$mode/" test-simple.tex
  make build FILE=test-simple
done

# Test bandeau établissement (toutes positions)
for pos in haut bas aucun; do
  sed -i "s/bandeaupos=[a-z]*/bandeaupos=$pos/" test-simple.tex
  make build FILE=test-simple
done

# Test types de devoirs complets
for type in DS EVA CONT DM; do
  sed -i "s/type=[A-Z]*/type=$type/" test-simple.tex
  make build FILE=test-simple
done

# Test système QCM (3 styles + colonnes)
# Vérifier que tous les styles QCM compilent
for style in case alpha mix; do
  echo "Test style QCM: $style"
  grep -q "style=$style" test-simple.tex && echo "✓ Style $style présent"
done

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