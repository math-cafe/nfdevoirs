# Configuration latexmk pour nfdevoirs

# Utiliser lualatex
$pdf_mode = 4;

# Répertoire de build séparé
$out_dir = 'build';

# Viewer: evince
$pdf_previewer = 'evince %O %S';

# Options pour lualatex
$lualatex = 'lualatex %O --interaction=nonstopmode --shell-escape %S';

# Nettoyage
$clean_ext = 'synctex.gz synctex.gz(busy) run.xml tex.bak bbl bcf fdb_latexmk run tdo %R-blx.bib';

# Compiler automatiquement au changement
$preview_continuous_mode = 1;

# Nombre de compilations max
$max_repeat = 5;