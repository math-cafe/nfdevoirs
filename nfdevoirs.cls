\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{nfdevoirs}[2025/10/02 Classe modulaire pour devoirs surveillés]

% ============================================================================
% OPTIONS DE CLASSE
% ============================================================================

% Options de correction
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

\DeclareOption{correction}{\@correctiontrue}
\DeclareOption{correctionfin}{\@correctionfintrue}

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
\RequirePackage{nfdevoirs/nf-environments}
\RequirePackage{nfdevoirs/nf-corrections}
\RequirePackage{nfdevoirs/nf-pagegarde}

\endinput