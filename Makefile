# Makefile pour nfdevoirs
# Usage: make watch FILE=test-simple

FILE ?= test-simple
TEX = $(FILE).tex
PDF = $(FILE).pdf
BUILD_DIR = build
LOG = $(BUILD_DIR)/$(FILE).log

.PHONY: build view watch clean mrproper log help

help:
	@echo "Usage: make [TARGET] FILE=filename (sans extension)"
	@echo ""
	@echo "Cibles disponibles:"
	@echo "  build     - Compile le PDF et le copie à la racine"
	@echo "  view      - Compile et visualise le PDF"
	@echo "  watch     - Compile en mode continu avec visualisation"
	@echo "  clean     - Efface les fichiers du build"
	@echo "  mrproper  - Efface tout (build + PDF racine)"
	@echo "  log       - Affiche le dernier log"
	@echo ""
	@echo "Exemple: make watch FILE=test-simple"

build:
	@latexmk $(TEX)
	@cp $(BUILD_DIR)/$(PDF) .
	@echo "✓ PDF copié: $(PDF)"

view:
	@latexmk -pv $(TEX)
	@cp $(BUILD_DIR)/$(PDF) .
	@echo "✓ PDF copié: $(PDF)"

watch:
	@latexmk -pvc $(TEX)

clean:
	@latexmk -c $(TEX)
	@echo "✓ Fichiers temporaires effacés"

mrproper: clean
	@rm -f $(PDF)
	@echo "✓ Nettoyage complet"

log:
	@if [ -f $(LOG) ]; then \
		less $(LOG); \
	else \
		echo "Erreur: fichier log introuvable ($(LOG))"; \
	fi