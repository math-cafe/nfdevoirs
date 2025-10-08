# Tests nfdevoirs

Ce répertoire contient tous les fichiers de test pour la classe LaTeX **nfdevoirs**.

## Fichiers de test disponibles

| Fichier | Description |
|---------|-------------|
| `test-simple.tex` | Test principal avec exemples de tous les environnements |
| `test-qcm-end.tex` | Test QCM avec corrections en fin de document |
| `test-corrections-fin.tex` | Test des corrections en mode fin |
| `test-bugfix.tex` | Test pour validation de corrections de bugs |

## Utilisation

Compilez n'importe quel test avec le Makefile depuis la racine :

```bash
# Compilation simple
make build FILE=test-simple

# Mode développement avec aperçu temps réel
make watch FILE=test-simple

# Lister tous les tests disponibles
make list-tests
```

Le Makefile détecte automatiquement si le fichier est dans `tests/` et gère les chemins correctement.

## Ajout de nouveaux tests

1. Créez votre fichier `.tex` dans ce répertoire avec le préfixe `test-`
2. Le Makefile le détectera automatiquement
3. Utilisez `make list-tests` pour vérifier qu'il est bien listé