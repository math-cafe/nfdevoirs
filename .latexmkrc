# Configuration latexmk pour la classe nfdevoirs
# Ce fichier configure latexmk pour une compilation optimale des devoirs LaTeX

# ============================================================================
# MOTEUR DE COMPILATION
# ============================================================================
# Mode 4 = LuaLaTeX (requis pour fontspec et gestion unicode avancée)
$pdf_mode = 4;

# ============================================================================
# ORGANISATION DES FICHIERS
# ============================================================================
# Tous les fichiers temporaires et le PDF sont générés dans build/
# Cela maintient le répertoire racine propre
$out_dir = 'build';

# ============================================================================
# VISUALISEUR PDF
# ============================================================================
# evince sous Linux - remplacer par votre viewer préféré si nécessaire
# %O = options, %S = fichier source
$pdf_previewer = 'evince %O %S';

# ============================================================================
# OPTIONS DE COMPILATION
# ============================================================================
# --interaction=nonstopmode : continue malgré les erreurs
# --shell-escape : autorise l'exécution de commandes externes (requis pour certains packages)
$lualatex = 'lualatex %O --interaction=nonstopmode --shell-escape %S';

# ============================================================================
# NETTOYAGE AVANCÉ
# ============================================================================
# Extensions de fichiers à nettoyer en plus des extensions par défaut
$clean_ext = 'synctex.gz synctex.gz(busy) run.xml tex.bak bbl bcf fdb_latexmk run tdo %R-blx.bib';

# ============================================================================
# MODE WATCH (compilation continue)
# ============================================================================
# Active le mode preview continu par défaut (make watch)
$preview_continuous_mode = 1;

# Limite le nombre de compilations pour éviter les boucles infinies
$max_repeat = 5;