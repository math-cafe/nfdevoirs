# Makefile pour la classe nfdevoirs
# Automatise la compilation des devoirs LaTeX avec latexmk
# Usage: make [CIBLE] FILE=nom_fichier_sans_extension

# ============================================================================ 
# CONFIGURATION
# ============================================================================ 
# Ce Makefile requiert que la variable FILE soit spécifiée pour la plupart des cibles.
# Ex: make build FILE=mon-devoir

# Variables dérivées du nom de fichier
TEX = $(FILE).tex
PDF = $(FILE).pdf
BUILD_DIR = build
LOG = $(BUILD_DIR)/$(FILE).log

# Liste de toutes les sources LaTeX pour le formatage global
LATEX_SOURCES := nfdevoirs.cls $(wildcard nfdevoirs/*.sty) $(wildcard tests/*.tex)

# ============================================================================ 
# VALIDATION DES PARAMÈTRES
# ============================================================================ 
# Cibles qui n'ont pas besoin du paramètre FILE
PUBLIC_TARGETS := help mrproper format install-hooks

# Détermine la cible actuelle. Si 'make' est appelé sans argument, la cible par défaut est 'help'.
CURRENT_GOAL := $(or $(MAKECMDGOALS),help)

# Isole les cibles qui ne sont PAS publiques
NEEDS_FILE_CHECK := $(filter-out $(PUBLIC_TARGETS),$(CURRENT_GOAL))

# Si au moins une cible non-publique est appelée, on vérifie la présence de FILE
ifneq ($(NEEDS_FILE_CHECK),)
  ifndef FILE
    $(error Le paramètre FILE est manquant. Essayez 'make help' pour plus d'informations.)
  endif
endif

# Déclare toutes les cibles comme "phony" (pas de fichiers correspondants)
.PHONY: help build view watch clean mrproper log lint format install-hooks

# ============================================================================ 
# AIDE AUTO-DOCUMENTÉE (CIBLE PAR DÉFAUT)
# ============================================================================ 
help: ## Affiche cette aide
	@echo "Makefile pour la compilation de devoirs LaTeX (classe nfdevoirs)"
	@echo ""
	@echo "Usage: make [CIBLE] FILE=filename (sans extension .tex)"
	@echo ""
	@echo "Cibles disponibles:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "; FMT = "  %-9s - %s\n"}; {printf FMT, $$1, $$2}'
	@echo ""
	@echo "Exemples:"
	@echo "  make watch FILE=mon-devoir    # Mode développement"
	@echo "  make build FILE=mon-devoir    # Compilation simple"
	@echo "  make clean FILE=mon-devoir    # Nettoyage pour un fichier spécifique"
	@echo "  make mrproper                 # Nettoyage complet du projet"
	@echo "  make format                   # Formate tout le projet"
	@echo "  make lint FILE=mon-devoir     # Vérifie la syntaxe d'un fichier"
	@echo "  make install-hooks            # Installe les hooks Git pour le développement"

# ============================================================================ 
# CIBLES DE COMPILATION
# ============================================================================ 
build: ## Compile le PDF et le copie à la racine
	@echo "🔨 Compilation de $(TEX)..."
	@latexmk $(TEX)
	@cp $(BUILD_DIR)/$(PDF) .
	@echo "✓ PDF généré et copié: $(PDF)"

view: ## Compile et visualise le PDF avec evince
	@echo "🔨 Compilation avec visualisation de $(TEX)..."
	@latexmk -pv $(TEX)
	@cp $(BUILD_DIR)/$(PDF) .
	@echo "✓ PDF généré, copié et ouvert: $(PDF)"

watch: ## Compile en mode continu avec visualisation (recommandé)
	@echo "👀 Mode watch activé pour $(TEX)"
	@echo "   Le PDF se recompile automatiquement à chaque sauvegarde"
	@echo "   Appuyez sur Ctrl+C pour arrêter"
	@latexmk -pvc $(TEX)

# ============================================================================ 
# CIBLES DE NETTOYAGE
# ============================================================================ 
clean: ## Efface les fichiers temporaires du build (pour le FILE en cours)
	@echo "🧹 Nettoyage des fichiers temporaires pour $(TEX)..."
	@latexmk -c $(TEX)
	@echo "✓ Fichiers temporaires effacés"

mrproper: ## Nettoyage complet (vide le dossier build/ et efface tous les .pdf)
	@echo "🧹 Nettoyage complet..."
	@rm -rf $(BUILD_DIR)/*
	@rm -f *.pdf
	@echo "✓ Nettoyage complet terminé"

# ============================================================================ 
# QUALITÉ DE CODE ET DÉBOGAGE
# ============================================================================ 
log: ## Affiche le dernier log de compilation pour un fichier
	@if [ -f $(LOG) ]; then \
		echo "📄 Affichage du log de compilation:"; \
		less $(LOG); \
	else \
		echo "❌ Erreur: fichier log introuvable ($(LOG))"; \
		echo "   Lancez d'abord une compilation avec 'make build'"; \
	fi

lint: ## Vérifie la syntaxe du code LaTeX avec chktex
	@echo "🔍 Analyse de $(TEX) avec chktex..."
	@chktex $(TEX)

format: ## Formate le code LaTeX avec latexindent (tout le projet ou un seul fichier)
	@echo "💅 Formatage du code LaTeX avec latexindent..."
	@if [ -z "$(FILE)" ]; then \
		echo "  -> Aucun FILE spécifié. Formatage de tout le projet..."; \
		latexindent -s -wd -l -c $(BUILD_DIR) $(LATEX_SOURCES); \
	else \
		echo "  -> Formatage du fichier unique: $(TEX)..."; \
		latexindent -s -wd -l -c $(BUILD_DIR) $(TEX); \
	fi
	@echo "✓ Formatage terminé."

# ============================================================================ 
# GESTION DES HOOKS GIT
# ============================================================================ 
install-hooks: ## Installe les hooks Git du projet dans le dépôt local .git/
	@echo "🔧 Installation des hooks Git..."
	@cp scripts/hooks/* .git/hooks/
	@chmod +x .git/hooks/*
	@echo "✓ Hooks installés avec succès."