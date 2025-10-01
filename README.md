# nfdevoirs

Classe LaTeX pour les devoirs surveillés de mathématiques.

## Structure

```
nfdevoirs/
├── nfdevoirs.cls         # La classe
├── test-simple.tex       # Test minimal
├── test-complet.tex      # Test complet
├── .latexmkrc            # Configuration latexmk
├── Makefile              # Automatisation
└── README.md             # Ce fichier
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
  calculatrice=oui,
  classe={1STMG 2},
  date={27 septembre 2024},
  easteregg={hypothénuse},
  citation={La citation ici},
  auteur={Galilée}
}

\begin{partie}{Titre de la partie}
  \begin{exercice}{Titre de l'exercice}
    \begin{question}{3}{0}  % 3 pts barème, 0 bonus
      Énoncé de la question...
    \end{question}
  \end{exercice}
\end{partie}

\end{devoir}
\end{document}
```

## Options de classe

- `correction` : Affiche les corrections inline (après chaque question)
  ```latex
  \documentclass[correction]{nfdevoirs}
  ```

- `correctionfin` : Regroupe toutes les corrections en fin de document
  ```latex
  \documentclass[correctionfin]{nfdevoirs}
  ```