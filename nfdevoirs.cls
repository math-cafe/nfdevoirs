\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{nfdevoirs}[2025/10/06 Classe modulaire pour devoirs surveillés]

% ============================================================================
% OPTIONS DE CLASSE
% ============================================================================

% Options de correction (compatibilité + nouveau système)
\newif\if@correction
\@correctionfalse
\newif\if@correctionfin
\@correctionfinfalse

% Système de thèmes extensible
\newif\if@themenb
\@themenbfalse
\newif\if@thememoderne
\@thememodernetrue  % thème par défaut
\newif\if@themeorange
\@themeorangefalse
\newif\if@themevert
\@themevertfalse
\newif\if@themeviolet
\@themevioletfalse

% Variable pour le nouveau système de correction
\newcommand{\@nfcorrection}{none} % none, inline, end, only

% Options de correction (avec migration douce)
\DeclareOption{correction}{%
  \@correctiontrue%
  \renewcommand{\@nfcorrection}{inline}%
  \PackageWarning{nfdevoirs}{Option 'correction' depreciee. Utilisez 'correction=inline' dans les options du devoir}%
}
\DeclareOption{correctionfin}{%
  \@correctionfintrue%
  \renewcommand{\@nfcorrection}{end}%
  \PackageWarning{nfdevoirs}{Option 'correctionfin' depreciee. Utilisez 'correction=end' dans les options du devoir}%
}

% Options de thèmes avec gestion mutuelle exclusive
\DeclareOption{theme=nb}{%
  \@themenbtrue%
  \@thememodernefalse%
  \@themeorangefalse%
  \@themevertfalse%
  \@themevioletfalse%
}
\DeclareOption{theme=moderne}{%
  \@thememodernetrue%
  \@themenbfalse%
  \@themeorangefalse%
  \@themevertfalse%
  \@themevioletfalse%
}
\DeclareOption{theme=orange}{%
  \@themeorangetrue%
  \@thememodernefalse%
  \@themenbfalse%
  \@themevertfalse%
  \@themevioletfalse%
}
\DeclareOption{theme=vert}{%
  \@themeverttrue%
  \@thememodernefalse%
  \@themenbfalse%
  \@themeorangefalse%
  \@themevioletfalse%
}
\DeclareOption{theme=violet}{%
  \@themeviolettrue%
  \@thememodernefalse%
  \@themenbfalse%
  \@themeorangefalse%
  \@themevertfalse%
}

\DeclareOption*{\PassOptionsToClass{\CurrentOption}{article}}
\ProcessOptions\relax

% ============================================================================
% CLASSE DE BASE ET PACKAGES ESSENTIELS
% ============================================================================
\LoadClass[a4paper,12pt]{article}

% Packages essentiels
\RequirePackage{fontspec}
\RequirePackage[french]{babel}
\RequirePackage{amsmath,amssymb,amsthm}
\RequirePackage{xcolor}
\RequirePackage{graphicx}
\RequirePackage{marginnote}
\RequirePackage{calc}

% ============================================================================
% CHARGEMENT DES MODULES
% ============================================================================
\RequirePackage{nfdevoirs/nf-core}
\RequirePackage{nfdevoirs/nf-themes}
\RequirePackage{nfdevoirs/nf-layout}
% Environnements principaux
\RequirePackage{nfdevoirs/nf-question}
\RequirePackage{nfdevoirs/nf-exercice}
\RequirePackage{nfdevoirs/nf-partie}
\RequirePackage{nfdevoirs/nf-devoir}
% Système de corrections
\RequirePackage{nfdevoirs/nf-correction-base}
\RequirePackage{nfdevoirs/nf-correction-display}
% Pages de garde et éléments visuels
\RequirePackage{nfdevoirs/nf-bandeau}
\RequirePackage{nfdevoirs/nf-pagegarde-minimale}
\RequirePackage{nfdevoirs/nf-pagegarde-complete}
\RequirePackage{nfdevoirs/nf-citations}

\endinput