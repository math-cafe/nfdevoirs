# Makefile pour la classe nfdevoirs
# Automatise la compilation des devoirs LaTeX avec latexmk

# ============================================================================
# CONFIGURATION
# ============================================================================

BUILD_DIR = build

# Logique pour gérer l'extension de fichier
HAS_EXT = $(filter %.tex %.sty, $(FILE))
TEX_SRC = $(if $(HAS_EXT), $(FILE), $(FILE).tex)

# Logique pour les chemins de sortie
BASENAME = $(notdir $(FILE))
OUT_DIR = $(BUILD_DIR)/$(dir $(FILE))
PDF_PATH = $(OUT_DIR)/$(BASENAME).pdf
LOG_PATH = $(OUT_DIR)/$(BASENAME).log

# Sources pour le formatage global
LATEX_SOURCES := nfdevoirs.cls $(wildcard nfdevoirs/*.sty) $(wildcard tests/*.tex)

# Commande latexmk avec les chemins d'inclusion pour TeX et Lua.
LATEXMK = LUAINPUTS=./nfdevoirs//: TEXINPUTS=.: latexmk

# ============================================================================
# VALIDATION DES PARAMÈTRES
# ============================================================================
PUBLIC_TARGETS := help mrproper format install-hooks
CURRENT_GOAL := $(or $(MAKECMDGOALS),help)
NEEDS_FILE_CHECK := $(filter-out $(PUBLIC_TARGETS),$(CURRENT_GOAL))

ifneq ($(NEEDS_FILE_CHECK),)
  ifndef FILE
    $(error Le paramètre FILE est manquant. Essayez 'make help' pour plus d'informations.)
  endif
  # Validation du chemin de FILE : le chemin doit être à la racine ou sous tests/
  # La regex vérifie si le chemin commence par 'tests/' OU ne contient aucun '/'.
  ifeq ($(shell echo "$(FILE)" | grep -q -E '^(tests/|[^/]*$$)' && echo 1),)
    $(error Le fichier doit se trouver à la racine ou dans le dossier 'tests/')
  endif
endif

# Déclare toutes les cibles comme "phony"
.PHONY: help build view watch clean mrproper log lint format install-hooks

# ============================================================================
# AIDE AUTO-DOCUMENTÉE (CIBLE PAR DÉFAUT)
# ============================================================================
help: ## @aide Affiche cette aide
	@echo "Makefile pour la compilation de devoirs LaTeX (classe nfdevoirs)"
	@echo ""
	@echo "Usage: make [CIBLE] [FILE=<chemin/fichier>]"
	@echo ""
	@echo "  Le paramètre FILE est requis pour la plupart des cibles (build, view, etc.)."
	@echo "  L'extension .tex est optionnelle."
	@echo ""
	@echo "Cibles de Compilation :"
	@grep -E '^[a-zA-Z_-]+:.*?## @compilation' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## @compilation "}; {printf "  %-15s - %s\n", $$1, $$2}'
	@echo ""
	@echo "Qualité & Outils :"
	@grep -E '^[a-zA-Z_-]+:.*?## @outils' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## @outils "}; {printf "  %-15s - %s\n", $$1, $$2}'
	@echo ""
	@echo "Cibles de Nettoyage :"
	@grep -E '^[a-zA-Z_-]+:.*?## @nettoyage' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## @nettoyage "}; {printf "  %-15s - %s\n", $$1, $$2}'
	@echo ""
	@echo "Aide :"
	@grep -E '^[a-zA-Z_-]+:.*?## @aide' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## @aide "}; {printf "  %-15s - %s\n", $$1, $$2}'
	@echo ""
	@echo "Exemples:"
	@echo "  make watch FILE=tests/test-simple   # Mode développement"
	@echo "  make build FILE=tests/test-simple   # Compilation simple"
	@echo "  make mrproper                     # Nettoyage complet du projet"

# ============================================================================
# CIBLES DE COMPILATION
# ============================================================================
build: ## @compilation Compile le PDF dans son sous-dossier de build/
	@echo "🔨 Compilation de $(TEX_SRC)..."
	@mkdir -p $(OUT_DIR)
	@$(LATEXMK) -output-directory=$(OUT_DIR) $(TEX_SRC)
	@echo "✓ PDF généré dans: $(PDF_PATH)"

view: ## @compilation Compile et visualise le PDF
	@echo "🔨 Compilation et visualisation de $(TEX_SRC)..."
	@mkdir -p $(OUT_DIR)
	@$(LATEXMK) -pv -output-directory=$(OUT_DIR) $(TEX_SRC)
	@echo "✓ PDF ouvert dans le viewer."

watch: ## @compilation Compile en mode continu avec visualisation
	@echo "👀 Mode watch activé pour $(TEX_SRC)..."
	@mkdir -p $(OUT_DIR)
	@$(LATEXMK) -pvc -output-directory=$(OUT_DIR) $(TEX_SRC)

# ============================================================================
# CIBLES DE NETTOYAGE
# ============================================================================
clean: ## @nettoyage Efface les fichiers temporaires pour une cible
	@echo "🧹 Nettoyage des fichiers temporaires pour $(TEX_SRC)..."
	@$(LATEXMK) -c $(TEX_SRC)
	@echo "✓ Fichiers temporaires effacés"

mrproper: ## @nettoyage Nettoyage complet (supprime tout le dossier build/)
	@echo "🧹 Nettoyage complet..."
	@rm -rf $(BUILD_DIR)
	@rm -f *.pdf
	@echo "✓ Nettoyage complet terminé"

# ============================================================================
# QUALITÉ DE CODE ET DÉBOGAGE
# ============================================================================
log: ## @outils Affiche le dernier log de compilation pour un fichier
	@if [ -f $(LOG_PATH) ]; then \
		echo "📄 Affichage du log de compilation:"; \
		less $(LOG_PATH); \
	else \
		echo "❌ Erreur: fichier log introuvable ($(LOG_PATH))"; \
		echo "   Lancez d'abord une compilation avec 'make build'"; \
	fi

lint: ## @outils Vérifie la syntaxe LaTeX avec chktex
	@echo "🔍 Analyse de $(TEX_SRC) avec chktex..."
	@chktex $(TEX_SRC)

format: ## @outils Formate le code LaTeX avec latexindent
	@echo "💅 Formatage du code LaTeX avec latexindent..."
	@if [ -z "$(FILE)" ]; then \
		echo "  -> Aucun FILE spécifié. Formatage de tout le projet..."; \
		latexindent -s -wd -l -c $(BUILD_DIR) $(LATEX_SOURCES); \
	else \
		echo "  -> Formatage du fichier unique: $(TEX_SRC)..."; \
		latexindent -s -wd -l -c $(BUILD_DIR) $(TEX_SRC); \
	fi
	@echo "✓ Formatage terminé."

# ============================================================================
# GESTION DES HOOKS GIT
# ============================================================================
install-hooks: ## @outils Installe les hooks Git du projet
	@echo "🔧 Installation des hooks Git..."
	@cp scripts/hooks/* .git/hooks/
	@chmod +x .git/hooks/*
	@echo "✓ Hooks installés avec succès."
