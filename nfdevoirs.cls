\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{nfdevoirs}[2025/09/29 Classe pour devoirs surveillés]

% ============================================================================
% OPTIONS DE CLASSE
% ============================================================================
\newif\if@correction
\@correctionfalse
\newif\if@correctionfin
\@correctionfinfalse

\DeclareOption{correction}{\@correctiontrue}
\DeclareOption{correctionfin}{\@correctionfintrue}
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{article}}
\ProcessOptions\relax

% ============================================================================
% CLASSE DE BASE ET PACKAGES
% ============================================================================
\LoadClass[a4paper,12pt]{article}

% Packages essentiels
\RequirePackage{fontspec}
\RequirePackage[french]{babel}
\RequirePackage{amsmath,amssymb,amsthm}
\RequirePackage{geometry}
\RequirePackage{enumitem}
\RequirePackage{xcolor}
\RequirePackage{graphicx}
\RequirePackage{tcolorbox}
\RequirePackage{marginnote}
\RequirePackage{etoolbox}
\RequirePackage{xparse}
\RequirePackage{calc}
\RequirePackage{fancyhdr}
\RequirePackage{lastpage}

% Configuration de la page
\geometry{
  top=10mm,
  left=10mm,
  right=10mm,
  bottom=15mm
}

% Couleurs modernes
\definecolor{nfblue}{RGB}{41,128,185}
\definecolor{nfbluebg}{RGB}{236,240,245}
\definecolor{nfgray}{RGB}{100,100,100}

% Configuration des listes avec puces modernes
\setlist[itemize,1]{label={\color{nfblue}$\bullet$}, leftmargin=*}
\setlist[itemize,2]{label={\color{nfblue}$\circ$}, leftmargin=*}

% Configuration tcolorbox
\tcbuselibrary{skins,breakable}

% Configuration des en-têtes et pieds de page
\pagestyle{fancy}
\fancyhf{} % Efface tout
\fancyfoot[C]{\textbf{\thepage/\pageref{LastPage}}} % Numéro de page format "n/total"
\renewcommand{\headrulewidth}{0pt} % Pas de ligne d'en-tête
\renewcommand{\footrulewidth}{0pt} % Pas de ligne de pied de page

% ============================================================================
% COMPTEURS
% ============================================================================
\newcounter{nfpartie}
\newcounter{nfexercice}[nfpartie]
\newcounter{nfquestion}[nfexercice]

% Compteurs de points
\newcounter{nfptsquestion}
\newcounter{nfbonusquestion}
\newcounter{nfptsexercice}
\newcounter{nfbonusexercice}
\newcounter{nfptspartie}
\newcounter{nfbonuspartie}
\newcounter{nfptsdevoir}
\newcounter{nfbonusdevoir}

% Pour stocker les totaux finaux (lus depuis .aux)
\def\nftotalpts{0}
\def\nftotalbonus{0}

% ============================================================================
% VARIABLES GLOBALES POUR LA PAGE DE GARDE
% ============================================================================
\newcommand{\@nfcalculatrice}{}
\newcommand{\@nfclasse}{}
\newcommand{\@nfdate}{}
\newcommand{\@nfnom}{}
\newcommand{\@nfeasteregg}{}
\newcommand{\@nfcitation}{}
\newcommand{\@nfauteur}{}
\newcommand{\@nfduree}{}

% ============================================================================
% COMMANDES D'AFFICHAGE DES POINTS
% ============================================================================

% Affichage des points à droite du titre (dans le flux de texte)
\newcommand{\nfaffichepts}[3]{% #1=taille, #2=pts, #3=bonus
  \hfill%
  \makebox[2.5cm][r]{%
    \fontsize{#1}{#1}\selectfont
    \color{nfgray}%
    \ifnum#2>0 /#2\fi%
    \ifnum#3>0 \space +#3\fi%
  }%
}

% ============================================================================
% ENVIRONNEMENT QUESTION
% ============================================================================
\NewEnviron{question}[2]{%
  % #1 = points barème, #2 = points bonus
  \stepcounter{nfquestion}%
  \setcounter{nfptsquestion}{#1}%
  \setcounter{nfbonusquestion}{#2}%
  \addtocounter{nfptsexercice}{#1}%
  \addtocounter{nfbonusexercice}{#2}%
  % Structure en deux colonnes : contenu + points
  \noindent
  \begin{minipage}[t]{\dimexpr\textwidth-3cm\relax}
    \textbf{\arabic{nfquestion})} \BODY
  \end{minipage}%
  \hfill
  \begin{minipage}[t]{2.5cm}
    \raggedleft
    \textbf{%
      \color{nfgray}%
      \ifnum#1>0 /#1\fi%
      \ifnum#2>0 \space +#2\fi%
    }
  \end{minipage}%
  \par\medskip
}

% ============================================================================
% ENVIRONNEMENT EXERCICE
% ============================================================================
\newcounter{nfexerciceabs} % Compteur absolu pour identifier les exercices

% Macro auxiliaire pour récupérer les points sauvegardés (avec valeur par défaut)
\newcommand{\nfgetexopts}[1]{%
  \ifcsname nfexo#1pts\endcsname
    \csname nfexo#1pts\endcsname
  \else
    0%
  \fi
}
\newcommand{\nfgetexobonus}[1]{%
  \ifcsname nfexo#1bonus\endcsname
    \csname nfexo#1bonus\endcsname
  \else
    0%
  \fi
}

\NewDocumentEnvironment{exercice}{m}{%
  % #1 = titre
  \stepcounter{nfexercice}%
  \stepcounter{nfexerciceabs}%
  \setcounter{nfptsexercice}{0}%
  \setcounter{nfbonusexercice}{0}%
  \vspace{1em}%
  % Affichage du titre avec les points (structure en deux colonnes)
  \noindent
  \begin{minipage}[t]{\dimexpr\textwidth-3cm\relax}
    {\Large\textbf{\arabic{nfexercice}. #1}}
  \end{minipage}%
  \hfill
  \begin{minipage}[t]{2.5cm}
    \raggedleft
    {\Large\textbf{%
      \color{nfgray}%
      \edef\temppts{\nfgetexopts{\roman{nfexerciceabs}}}%
      \edef\tempbonus{\nfgetexobonus{\roman{nfexerciceabs}}}%
      \ifnum\temppts>0 /\temppts\fi%
      \ifnum\tempbonus>0 \space +\tempbonus\fi%
    }}
  \end{minipage}%
  \par\medskip
}{%
  % Sauvegarde des totaux dans le .aux pour la prochaine compilation
  \if@filesw
    \immediate\write\@auxout{%
      \string\expandafter\string\gdef\string\csname\space nfexo\roman{nfexerciceabs}pts\string\endcsname{\the\value{nfptsexercice}}%
    }%
    \immediate\write\@auxout{%
      \string\expandafter\string\gdef\string\csname\space nfexo\roman{nfexerciceabs}bonus\string\endcsname{\the\value{nfbonusexercice}}%
    }%
  \fi
  % Ajout aux totaux de la partie
  \addtocounter{nfptspartie}{\value{nfptsexercice}}%
  \addtocounter{nfbonuspartie}{\value{nfbonusexercice}}%
  \vspace{1em}%
}

% ============================================================================
% ENVIRONNEMENT PARTIE
% ============================================================================

% Macro auxiliaire pour récupérer les points sauvegardés (avec valeur par défaut)
\newcommand{\nfgetpartiepts}[1]{%
  \ifcsname nfpartie#1pts\endcsname
    \csname nfpartie#1pts\endcsname
  \else
    0%
  \fi
}
\newcommand{\nfgetpartiebonus}[1]{%
  \ifcsname nfpartie#1bonus\endcsname
    \csname nfpartie#1bonus\endcsname
  \else
    0%
  \fi
}

\NewDocumentEnvironment{partie}{m}{%
  % #1 = titre
  \stepcounter{nfpartie}%
  \setcounter{nfptspartie}{0}%
  \setcounter{nfbonuspartie}{0}%
  \vspace{2em}%
  % Affichage du titre avec les points (structure en deux colonnes)
  \noindent
  \begin{minipage}[t]{\dimexpr\textwidth-3cm\relax}
    {\LARGE\textbf{Partie \Roman{nfpartie}%
    \ifstrempty{#1}{}{\ : #1}}}
  \end{minipage}%
  \hfill
  \begin{minipage}[t]{2.5cm}
    \raggedleft
    {\LARGE\textbf{%
      \color{nfgray}%
      \edef\temppts{\nfgetpartiepts{\roman{nfpartie}}}%
      \edef\tempbonus{\nfgetpartiebonus{\roman{nfpartie}}}%
      \ifnum\temppts>0 /\temppts\fi%
      \ifnum\tempbonus>0 \space +\tempbonus\fi%
    }}
  \end{minipage}%
  \par\bigskip
}{%
  % Sauvegarde des totaux dans le .aux pour la prochaine compilation
  \if@filesw
    \immediate\write\@auxout{%
      \string\expandafter\string\gdef\string\csname\space nfpartie\roman{nfpartie}pts\string\endcsname{\the\value{nfptspartie}}%
    }%
    \immediate\write\@auxout{%
      \string\expandafter\string\gdef\string\csname\space nfpartie\roman{nfpartie}bonus\string\endcsname{\the\value{nfbonuspartie}}%
    }%
  \fi
  % Ajout aux totaux du devoir
  \addtocounter{nfptsdevoir}{\value{nfptspartie}}%
  \addtocounter{nfbonusdevoir}{\value{nfbonuspartie}}%
  \vspace{2em}%
}

% ============================================================================
% ENVIRONNEMENT CORRECTION
% ============================================================================

% Compteur global pour numéroter les corrections
\newcounter{nfcorrection}

\NewEnviron{correction}{%
  \if@correction
    % Mode inline : afficher directement
    \begin{tcolorbox}[
      enhanced,
      breakable,
      colback=nfbluebg,
      colframe=nfblue,
      arc=3pt,
      boxrule=1pt,
      left=5pt,
      right=5pt,
      top=5pt,
      bottom=5pt,
      title={\small\textcolor{nfblue}{✓ Correction}},
      fonttitle=\bfseries,
      coltitle=nfblue,
      attach boxed title to top left={yshift=-2mm, xshift=5mm},
      boxed title style={
        colback=white,
        colframe=nfblue,
        boxrule=1pt,
        arc=2pt
      }
    ]
    \BODY
    \end{tcolorbox}
  \fi
  \if@correctionfin
    % Mode fin : stocker chaque correction dans sa propre macro
    \stepcounter{nfcorrection}%
    % Stocker les infos de localisation
    \expandafter\xdef\csname nfcorr\the\value{nfcorrection}partie\endcsname{\Roman{nfpartie}}%
    \expandafter\xdef\csname nfcorr\the\value{nfcorrection}exo\endcsname{\arabic{nfexercice}}%
    \expandafter\xdef\csname nfcorr\the\value{nfcorrection}quest\endcsname{\arabic{nfquestion}}%
    % Stocker le contenu de la correction
    \expandafter\global\expandafter\let\csname nfcorr\the\value{nfcorrection}body\endcsname\BODY
  \fi
}

% Commande pour afficher toutes les corrections en fin de document
\newcommand{\nfaffichercorrections}{%
  \if@correctionfin
    \ifnum\value{nfcorrection}>0
      \clearpage
      \section*{Corrections}
      % Boucle pour afficher toutes les corrections stockées
      \count@=1\relax
      \loop\ifnum\count@<\numexpr\value{nfcorrection}+1\relax
        \noindent\textbf{Partie \csname nfcorr\the\count@ partie\endcsname, %
        Exercice \csname nfcorr\the\count@ exo\endcsname, %
        Question \csname nfcorr\the\count@ quest\endcsname}
        \begin{tcolorbox}[
          enhanced,
          breakable,
          colback=nfbluebg,
          colframe=nfblue,
          arc=3pt,
          boxrule=1pt,
          left=5pt,
          right=5pt,
          top=5pt,
          bottom=5pt,
        ]
        \csname nfcorr\the\count@ body\endcsname
        \end{tcolorbox}
        \medskip
        \advance\count@ by 1\relax
      \repeat
    \fi
  \fi
}

% ============================================================================
% PAGE DE GARDE
% ============================================================================
\newcommand{\nfpagegarde}{%
  \thispagestyle{empty}%
  
  % En-tête avec titre et infos
  \begin{center}
    {\Huge\bfseries\color{nfblue}\@title}
    
    \vspace{0.3cm}
    {\color{nfblue}\rule{0.6\textwidth}{2pt}}
    \vspace{0.5cm}
    
    \begin{minipage}{0.45\textwidth}
      {\large\textbf{Nom :} \@nfnom}
    \end{minipage}%
    \hfill
    \begin{minipage}{0.45\textwidth}
      \raggedleft
      {\large\textbf{Classe :} \@nfclasse}
    \end{minipage}
  \end{center}
  
  \vspace{0.8cm}
  
  % Section Informations (Barème / Durée / Date)
  \begin{center}
    \begin{minipage}[t]{0.3\textwidth}
      \centering
      \textbf{\color{nfblue}Barème} \\[0.2cm]
      \textbf{\nftotalpts\ points}%
      \ifnum\nftotalbonus>0
        \ + \textbf{\nftotalbonus\ bonus}%
      \fi \\
      \ifnum\nftotalpts=20
      \else
        \textit{\small note convertie sur 20 points}
      \fi
    \end{minipage}%
    \hfill
    \ifstrempty{\@nfduree}{}{%
      \begin{minipage}[t]{0.3\textwidth}
        \centering
        \textbf{\color{nfblue}Durée} \\[0.2cm]
        \textbf{\@nfduree}
      \end{minipage}%
      \hfill
    }%
    \ifstrempty{\@nfdate}{}{%
      \begin{minipage}[t]{0.3\textwidth}
        \centering
        \textbf{\color{nfblue}Date} \\[0.2cm]
        \textbf{\@nfdate}
      \end{minipage}%
    }
  \end{center}
  
  \vspace{0.5cm}
  
  % Boîte pour la note (vide, à remplir à la main)
  \begin{tcolorbox}[
    enhanced,
    colback=white,
    colframe=nfblue,
    boxrule=1.5pt,
    arc=2pt,
    left=10pt,
    right=10pt,
    top=8pt,
    bottom=8pt,
    height=45mm,
  ]
    \textbf{\color{nfblue}Note et observations :}
    \vspace{2.3cm}
  \end{tcolorbox}
  
  \vspace{0.5cm}
  
  % Section Consignes
  {\large\textbf{\color{nfblue}Consignes pour l'épreuve}}
  \vspace{0.2cm}
  
  \begin{itemize}[leftmargin=*, itemsep=3pt]
    \item L'usage de la calculatrice est \textbf{\@nfcalculatrice}.
    \item Aucun document, support de cours ou formulaire n'est admis.
    \item Cette évaluation est \textbf{strictement individuelle}. Toute communication est prohibée.
    \item L'intégralité des exercices doit être traitée. L'ordre de traitement est laissé à votre appréciation, sous réserve que chaque exercice soit traité sans interruption.
    \item Des pénalités (1 point chacune sur la note finale) seront appliquées pour :
    \begin{itemize}[itemsep=2pt]
      \item Rédaction de qualité insuffisante
      \item Terminologie ou notation mathématique inappropriées
      \item Non-respect des consignes d'exécution
    \end{itemize}
  \end{itemize}
  
  \vspace{0.5cm}
  
  % Section Conseils
  {\large\textbf{\color{nfblue}Conseils pour réussir}}
  \vspace{0.2cm}
  
  \begin{itemize}[leftmargin=*, itemsep=3pt]
    \item \textbf{Prenez connaissance de l'ensemble du sujet} avant de commencer pour comprendre la structure et identifier les compétences à mobiliser.
    
    \item \textbf{Lisez attentivement les énoncés} pour bien cerner les capacités testées%
    \ifstrempty{\@nfeasteregg}{.}{\ {\color{nfgray}\textit{(un point bonus vous attend si vous écrivez « \@nfeasteregg » en haut de votre copie)}}.}
    
    \item \textbf{Gérez votre temps} : recherche sur brouillon, rédaction soignée, puis relecture.
    
    \item \textbf{Utilisez un brouillon.} Les élèves qui organisent leur travail sur brouillon obtiennent systématiquement de meilleurs résultats : moins d'erreurs, rédaction plus claire, meilleure gestion du temps.
  \end{itemize}
  
  \vspace{0.3cm}
  
  \begin{center}
    \textit{Une copie propre et bien organisée témoigne de votre rigueur mathématique.}
  \end{center}
  
  \newpage
}

% ============================================================================
% CITATION FINALE
% ============================================================================
\newcommand{\nfcitationfin}{%
  \vfill
  \begin{center}
    \rule{0.5\textwidth}{0.4pt}
    
    \vspace{0.5cm}
    
    {\Large\textbf{Fin du devoir}}
    
    \vspace{1cm}
    
    \ifstrempty{\@nfcitation}{}{%
      \parbox{0.8\textwidth}{%
        \centering
        \textit{\@nfcitation}
        
        \vspace{0.3cm}
        
        \ifstrempty{\@nfauteur}{}{\textbf{\@nfauteur}}
      }%
    }
  \end{center}
}

% ============================================================================
% SYSTÈME DE STOCKAGE DES TOTAUX (deux passes via .aux)
% ============================================================================

% Commande pour écrire les totaux dans le .aux
\newcommand{\nfwritetotaux}{%
  \if@filesw
    \immediate\write\@auxout{%
      \string\gdef\string\nftotalpts{\the\value{nfptsdevoir}}%
    }%
    \immediate\write\@auxout{%
      \string\gdef\string\nftotalbonus{\the\value{nfbonusdevoir}}%
    }%
  \fi
}

% ============================================================================
% ENVIRONNEMENT DEVOIR
% ============================================================================
\newif\if@nfindevoirenv
\@nfindevoirenvfalse

\NewDocumentEnvironment{devoir}{m}{%
  \@nfindevoirenvtrue
  % Parsing des options avec pgfkeys
  \setkeys{nfdevoir}{#1}%
  % Réinitialisation des compteurs
  \setcounter{nfpartie}{0}%
  \setcounter{nfptsdevoir}{0}%
  \setcounter{nfbonusdevoir}{0}%
  % Génération de la page de garde (avec totaux depuis .aux)
  \nfpagegarde
}{%
  % À la fin du devoir
  % 1. Écriture des totaux dans .aux pour la prochaine compilation
  \nfwritetotaux
  % 2. Affichage de la citation finale
  \nfcitationfin
  % 3. Affichage des corrections si mode correctionfin
  \nfaffichercorrections
  \@nfindevoirenvfalse
}

% Configuration des clés pour l'environnement devoir
\RequirePackage{keyval}
\define@key{nfdevoir}{calculatrice}{\renewcommand{\@nfcalculatrice}{#1}}
\define@key{nfdevoir}{classe}{\renewcommand{\@nfclasse}{#1}}
\define@key{nfdevoir}{date}{\renewcommand{\@nfdate}{#1}}
\define@key{nfdevoir}{nom}{\renewcommand{\@nfnom}{#1}}
\define@key{nfdevoir}{easteregg}{\renewcommand{\@nfeasteregg}{#1}}
\define@key{nfdevoir}{citation}{\renewcommand{\@nfcitation}{#1}}
\define@key{nfdevoir}{auteur}{\renewcommand{\@nfauteur}{#1}}
\define@key{nfdevoir}{duree}{\renewcommand{\@nfduree}{#1}}

\endinput