# Makefile pour la classe nfdevoirs
# Automatise la compilation des devoirs LaTeX avec latexmk
# Usage: make [TARGET] FILE=nom_fichier_sans_extension

# ============================================================================
# CONFIGURATION
# ============================================================================
# Fichier par défaut si aucun FILE n'est spécifié
FILE ?= test-simple

# Répertoire des tests
TESTS_DIR = tests

# Déterminer le chemin du fichier source
# Si le fichier existe dans tests/, l'utiliser, sinon chercher à la racine
ifneq (,$(wildcard $(TESTS_DIR)/$(FILE).tex))
    TEX_PATH = $(TESTS_DIR)/$(FILE).tex
    TEX_DIR = $(TESTS_DIR)
else
    TEX_PATH = $(FILE).tex
    TEX_DIR = .
endif

# Variables dérivées du nom de fichier
TEX = $(FILE).tex
PDF = $(FILE).pdf
BUILD_DIR = build
LOG = $(BUILD_DIR)/$(FILE).log

# Déclare toutes les cibles comme "phony" (pas de fichiers correspondants)
.PHONY: build view watch clean mrproper log help list-tests

# ============================================================================
# AIDE ET DOCUMENTATION
# ============================================================================
help:
	@echo "Makefile pour la compilation de devoirs LaTeX (classe nfdevoirs)"
	@echo ""
	@echo "Usage: make [TARGET] FILE=filename (sans extension .tex)"
	@echo ""
	@echo "Cibles disponibles:"
	@echo "  build      - Compile le PDF et le copie à la racine"
	@echo "  view       - Compile et visualise le PDF avec evince"
	@echo "  watch      - Compile en mode continu avec visualisation (recommandé)"
	@echo "  clean      - Efface les fichiers temporaires du build"
	@echo "  mrproper   - Nettoyage complet (build + PDF racine)"
	@echo "  log        - Affiche le dernier log de compilation"
	@echo "  list-tests - Liste les fichiers de test disponibles"
	@echo "  help       - Affiche cette aide"
	@echo ""
	@echo "Exemples:"
	@echo "  make watch FILE=mon-devoir    # Mode développement"
	@echo "  make build FILE=test-simple   # Compilation d'un test"
	@echo "  make clean                    # Nettoyage"
	@echo ""
	@echo "Note: Les fichiers sont cherchés automatiquement dans tests/ puis à la racine"

# ============================================================================
# CIBLES DE COMPILATION
# ============================================================================
# Compilation simple : génère le PDF dans build/ et le copie à la racine
build:
	@echo "🔨 Compilation de $(TEX_PATH)..."
	@latexmk $(TEX_PATH)
	@cp $(BUILD_DIR)/$(PDF) .
	@echo "✓ PDF généré et copié: $(PDF)"

# Compilation avec visualisation : ouvre automatiquement le PDF
view:
	@echo "🔨 Compilation avec visualisation de $(TEX_PATH)..."
	@latexmk -pv $(TEX_PATH)
	@cp $(BUILD_DIR)/$(PDF) .
	@echo "✓ PDF généré, copié et ouvert: $(PDF)"

# Mode watch : recompile automatiquement à chaque modification
# C'est le mode recommandé pour le développement
watch:
	@echo "👀 Mode watch activé pour $(TEX_PATH)"
	@echo "   Le PDF se recompile automatiquement à chaque sauvegarde"
	@echo "   Appuyez sur Ctrl+C pour arrêter"
	@latexmk -pvc $(TEX_PATH)

# ============================================================================
# CIBLES DE NETTOYAGE
# ============================================================================
# Nettoie uniquement les fichiers temporaires (garde le PDF)
clean:
	@echo "🧹 Nettoyage des fichiers temporaires..."
	@latexmk -c $(TEX_PATH)
	@echo "✓ Fichiers temporaires effacés"

# Nettoyage complet : supprime aussi le PDF de la racine
mrproper: clean
	@echo "🧹 Nettoyage complet..."
	@rm -f $(PDF)
	@echo "✓ Nettoyage complet terminé"

# ============================================================================
# UTILITAIRES DE DÉBOGAGE
# ============================================================================
# Affiche le log de compilation pour diagnostiquer les erreurs
log:
	@if [ -f $(LOG) ]; then \
		echo "📄 Affichage du log de compilation:"; \
		less $(LOG); \
	else \
		echo "❌ Erreur: fichier log introuvable ($(LOG))"; \
		echo "   Lancez d'abord une compilation avec 'make build'"; \
	fi

# Liste tous les fichiers de test disponibles
list-tests:
	@echo "📋 Fichiers de test disponibles:"
	@if [ -d $(TESTS_DIR) ]; then \
		ls -1 $(TESTS_DIR)/*.tex 2>/dev/null | sed 's|$(TESTS_DIR)/||g' | sed 's|\.tex$$||g' | sed 's|^|  - |g' || echo "  Aucun fichier de test trouvé"; \
	else \
		echo "  Répertoire tests/ inexistant"; \
	fi