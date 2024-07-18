% Copyright (c) Jost Rossel 2023

\ProvidesClass{upbbeamer}
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{beamer}}
\ProcessOptions\relax
\LoadClass[aspectratio=169,12pt]{beamer}
\setbeamersize{text margin left=5.5mm,text margin right=5.5mm}

\newif\iflogoslide\logoslidefalse%
\DeclareOptionBeamer{uselogo}[true]{\logoslidetrue}
\newif\ifskiptitlepage\skiptitlepagefalse%
\DeclareOptionBeamer{skiptitlepage}[true]{\skiptitlepagetrue}
\newif\ifbusypreface\busyprefacefalse%
\DeclareOptionBeamer{busypreface}[true]{\busyprefacetrue}
\newif\ifnumbersections\numbersectionsfalse%
\DeclareOptionBeamer{numbersections}[true]{\numbersectionstrue}
\ProcessOptionsBeamer

\RequirePackage[T1]{fontenc}
\RequirePackage[utf8]{inputenc}
\RequirePackage[english]{babel}
\RequirePackage{graphicx} % importing images
\graphicspath{{figures/}} % set default path for images
\RequirePackage{xparse} % for \NewDocumentCommand and others
\RequirePackage{etoolbox} % general programming tools
\RequirePackage{changepage} % for adjustwidth environment

\mode<presentation>

%% FONT DEFINITION

% we use atkinson hyperlegible as it provides extra readability even for people
% without visual impairments, especially in bad presentation conditions.
\usepackage[sfdefault]{atkinson}
\renewcommand{\familydefault}{\sfdefault}

% set font for all TiKZ pictures
\RequirePackage{tikz}
\tikzset{every picture/.style={/utils/exec={\sfdefault}}}

% change the font size of captions
\RequirePackage[font=footnotesize]{caption}

\renewcommand{\texttt}[1]{{\fontseries{lc}\selectfont\ttfamily\large #1}}

%% COLOR DEFINITION
\RequirePackage{xcolor}

% UPB COLORS
% internal color definitions
% the main color names of the secondary colors are numbered A, B, C
% the letter before that indicate the color group (G = green, P = pink) relative
% to the tertiary colors
\makeatletter
\definecolor{@upbTertiaryGreen}{RGB}{166,207,66} % #A6CF42
\definecolor{@upbSecondaryGC}{RGB}{88,197,199} % #58C5C7
\definecolor{@upbSecondaryGB}{RGB}{58,169,200} % #3AA9C8
\definecolor{@upbSecondaryGA}{RGB}{4,123,193} % #047BC1
\definecolor{@upbPrimary}{RGB}{41,56,150} % #293896
\definecolor{@upbSecondaryPA}{RGB}{24,28,98} % #181C62
\definecolor{@upbSecondaryPB}{RGB}{108,63,152} % #6C3F98
\definecolor{@upbSecondaryPC}{RGB}{180,48,146} % #B43092
\definecolor{@upbTertiaryPink}{RGB}{237,40,138} % #ED288A
% names you should use
% naming is translated/adapted from the official German names
\colorlet{upbAccentGreen}{@upbTertiaryGreen}
\colorlet{upbLime}{@upbTertiaryGreen}
\colorlet{upbArctic}{@upbSecondaryGC}
\colorlet{upbOcean}{@upbSecondaryGB}
\colorlet{upbAzure}{@upbSecondaryGA}
\colorlet{upbUltraBlue}{@upbPrimary}
\colorlet{upbSapphire}{@upbSecondaryPA}
\colorlet{upbIris}{@upbSecondaryPB}
\colorlet{upbFuchsia}{@upbSecondaryPC}
\colorlet{upbPomegranate}{@upbTertiaryPink}
\colorlet{upbAccentPink}{@upbTertiaryPink}
\makeatother

% TEXT COLORS
\setbeamercolor{alerted text}{fg=upbAccentPink}
\setbeamercolor{frametitle}{fg=upbUltraBlue}
\setbeamercolor{structure}{fg=black}
\setbeamercolor{normal text}{fg=black}
\setbeamerfont{frametitle}{size=\large,series=\bfseries}
\setbeamerfont{framesubtitle}{size=\normalsize,series=\bfseries}

%% SLIDE LAYOUT

% HEADER
\setbeamertemplate{headline}{} % disable headline
\setbeamertemplate{frametitle}{%
    \iflogoslide\vspace*{1.5cm}\else\vspace*{2.5mm}\fi%
    \begin{adjustwidth}{0cm}{\iflogoslide 0cm\else 3cm\fi}
        {%
            \usebeamerfont{frametitle}\usebeamercolor[fg]{frametitle}%
            \insertframetitle\\%
        }
        {%
            \ifdefvoid{\insertframesubtitle}{}{%
                \usebeamerfont{framesubtitle}\usebeamercolor[fg]{framesubtitle}%
                \insertframesubtitle\\%
            }%
        }%
    \end{adjustwidth}
}

% FOOTER
\def\makefootline{%
    \hfill%
    \usebeamercolor[fg]{page number in head/foot}%
    \usebeamerfont{page number in head/foot}%
    \strut\usebeamertemplate*{page number in head/foot}%
    \insertframenumber%
    \hspace*{7.5mm}\vspace*{2.5mm}%
}
\setbeamerfont{page number in head/foot}{size=\scriptsize}
\setbeamertemplate{footline}{\makefootline}
\setbeamertemplate{navigation symbols}{} % disable navigation symbols

% BACKGROUND
\makeatletter
\newcommand{\upbbeamer@setslidebackground}[1]{%
    % \ifbeamer@plainframe\else%
        \includegraphics[width=\paperwidth,height=\paperheight]{#1}%
    % \fi%
}

\iflogoslide%
    \newcommand{\slidebackground}{\upbbeamer@setslidebackground{design-elements/contentslide_logo}}
\else%
    \newcommand{\slidebackground}{\upbbeamer@setslidebackground{design-elements/contentslide}}
\fi%

\newcommand{\slidebackgroundbusy}{%
    \upbbeamer@setslidebackground{design-elements/titleslide}%
}

\ifskiptitlepage%
    \setbeamertemplate{background canvas}{\slidebackground}%
\else%
    \setbeamertemplate{background canvas}{%
        \ifnumcomp{\thepage}{=}{1}{% this is only relevant for the first page
            \upbbeamer@setslidebackground{design-elements/titleslide_logo}%
        }{%
            \slidebackground%
        }%
    }%
\fi%
\makeatother

%% TITLE PAGE
\setbeamercolor{title}{fg=upbUltraBlue}
\setbeamercolor{subtitle}{fg=black}
\setbeamerfont{title}{size=\LARGE,series=\bfseries}
\setbeamerfont{subtitle}{size=\small,series=\normalfont}
\setbeamerfont{institute}{size=\small,series=\normalfont}
\setbeamerfont{author}{size=\footnotesize,series=\normalfont}
\setbeamerfont{date}{size=\footnotesize,series=\normalfont}

\setbeamertemplate{title page}{
    \vspace*{2.5cm}
    \begin{adjustwidth}{1.05cm}{3cm}
        {%
            \usebeamerfont{title}\usebeamercolor[fg]{title}%
            \inserttitle\\[1em]%
        }%
        {%
            \ifdefvoid{\insertsubtitle}{}{%
                \usebeamerfont{subtitle}\usebeamercolor[fg]{subtitle}%
                \insertsubtitle\\
            }%
        }%
        {%
            \ifdefvoid{\insertinstitute}{\vfill}{%
                \usebeamerfont{institute}\usebeamercolor[fg]{institute}%
                \insertinstitute\\\vfill
            }%
        }%

        {\usebeamerfont{author}\usebeamercolor[fg]{author}\insertauthor\\}%
        {\usebeamerfont{date}\usebeamercolor[fg]{date}\insertdate\\}
    \end{adjustwidth}
}

\ifskiptitlepage\else%
    % automatically insert title page as first page
    \AtBeginDocument{{\setbeamertemplate{footline}{}\begin{frame}[plain]\titlepage\end{frame}}}
\fi%

% ITEMIZE PROPERTIES
\defbeamertemplate{itemize item}{small circle}{\textbullet}
\setbeamertemplate{itemize items}[small circle]

% DEFINING TOC
\setcounter{tocdepth}{2}
\setcounter{secnumdepth}{2}
\defbeamertemplate{section in toc}{circle unnumbered}{\leavevmode\textbullet\hspace{\itemsep}\inserttocsection\par}
\defbeamertemplate{subsection in toc}{circle unnumbered}{\leavevmode\hspace{1em}\textbullet\hspace{\itemsep}\inserttocsubsection\par}
\ifnumbersections%
    \setbeamertemplate{section in toc}[sections numbered]
    \setbeamertemplate{subsection in toc}{\leavevmode\hspace{1em}\inserttocsectionnumber.\inserttocsubsectionnumber~\inserttocsubsection\par}
    \setbeamertemplate{subsubsection in toc}{\leavevmode\hspace{3em}\inserttocsectionnumber.\inserttocsubsectionnumber.\inserttocsubsubsectionnumber~\inserttocsubsubsection\par}
\else%
    \setbeamertemplate{sections/subsections in toc}[circle unnumbered]
\fi%

% FOOTNOTES
\RequirePackage[hang]{footmisc}
\setbeamercolor{footnote}{fg=black!70}

% scale a text to fit the width of the page
% #1: the width to fit to (scaling of linewidth) (default: 1)
% #2: the text to fit
\NewDocumentCommand{\textfit}{O{1} +m}{%
    \resizebox*{#1\linewidth}{!}{\usebeamercolor[fg]{framesubtitle}#2}
}

% sets the templates for the preface
\def\setpreface{%
    \ifbusypreface%
        \setbeamertemplate{background canvas}{\slidebackgroundbusy}
    \else%
        \setbeamertemplate{background canvas}{\slidebackground}
    \fi%
    \setbeamertemplate{footline}{}
}

%% OLD INTERFACE (for compatibility with the old template)

% define preface environment
\newenvironment{preface}{\begingroup\setpreface}{\endgroup}

\newcommand{\sectionframe}{%
    {
    \setpreface
    \setbeamertemplate{background canvas}{\slidebackgroundbusy}
    \begin{frame}[c]
        \begin{adjustwidth}{1.05cm}{3cm}
            \usebeamerfont{title}\usebeamercolor[fg]{title}\ifnumbersections\thesection. \fi\insertsection
        \end{adjustwidth}
    \end{frame}
    }
}

%% END OF OLD INTERFACE

%% NEW INTERFACE

% add `preface' as a frame mode
\makeatletter
\newif\ifinpreface
\define@key{beamerframe}{preface}[true]{
    \inprefacetrue
    \begingroup
    \setpreface
}
\apptocmd{\beamer@reseteecodes}{%
    \ifinpreface%
        \endgroup
        \inprefacefalse
    \fi%
}{}{}
\newif\ifinempty
\define@key{beamerframe}{empty}[true]{
    \inemptytrue
    \begingroup
    \renewcommand\upbbeamer@setslidebackground[1]{}
}
\apptocmd{\beamer@reseteecodes}{%
    \ifinempty%
        \endgroup
        \inemptyfalse
    \fi%
}{}{}
\makeatother

% define a new section command to automatically insert a section frame
% \Section{<title>} will insert a section frame and a section with the given title
% \Section*{<title>} will insert a section frame and a section* with the given title
\NewDocumentCommand{\Section}{ s +m }{%
    \IfBooleanTF{#1}{\section*{#2}}{\section{#2}\sectionframe}%
}

%% END OF NEW INTERFACE

%% SETUP CODE STYLE
\RequirePackage{minted}

\mode<all>
\endinput
