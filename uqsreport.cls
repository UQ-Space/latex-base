\NeedsTeXFormat{LaTeX2e}
\RequirePackage{expl3}                                 % - Load LaTeX3 packages


%% ============================================================================
%%                          ~~~ CLASS META-INFO ~~~
%% ____________________________________________________________________________

\ProvidesExplClass
  {uqsreport}                                                   % - Name
  {2020/10/24}                                                  % - Date
  {1.1.0}                                                       % - Version
  {Report class for use by UQ Space}                            % - Description


%% ============================================================================



%% ============================= LaTeX3 Packages  =============================

% Required package information:
%
%   xparse   -> Allows for custom macros with a range of inputs, including
%               custom defaults, stars, delimiters, etc.
%
%   xspace   -> Detection of spaces and punctuation gobbled by a macro, and
%               replacement of said text naturally.

%% ----------------------------------------------------------------------------

\RequirePackage { xparse   }
\RequirePackage { xspace   }
\RequirePackage { l3keys2e }

%% ----------------------------------------------------------------------------

\bool_new:N \g_uqs_comments_bool
\dim_new:N  \commentmargin
\keys_define:nn { docOptions }{
  comments .code:n = {
    \bool_set_true:N \g_uqs_comments_bool
    \dim_set:Nn \commentmargin { 50mm }
  },
  unknown .code:n = {
    \PassOptionsToClass{\CurrentOption}{article}
  }
}

\ProcessKeysOptions { docOptions }

\LoadClass[a4paper]{article}

%% ============================================================================



%% =================== Title & Header / Footer Customisation ==================

% Required package information:
%
%   xcolor   -> Creation of custom colours from a variety of input types (RGB,
%               HSV, etc.) Colours can be saved to given names. The [table]
%               option creates the `\rowcolor` macro, for colouring table rows.
%               Caution must be used when colouring rows with `booktabs`, as
%               the colouring will have gaps. The [x11names] option gives
%               access to colours via the common x11 naming scheme.
%
%   titlesec -> Customisation of title styles (section, subsection, etc.)
%               Allows for creation of new title levels between existing
%               titles. The [pagestyles] option provides a more simple and
%               robust way to customise the header and footer, with extra marks
%               provided.
%
%   titletoc -> Customisation of how different title styles appear in the TOC.

%% ----------------------------------------------------------------------------

\RequirePackage [ table, x11names ] { xcolor   }
\RequirePackage [ pagestyles ]      { titlesec }
\RequirePackage                     { titletoc }
\RequirePackage                     { tikz     }
\RequirePackage                     { themeta  }

%% ----------------------------------------------------------------------------

\RequirePackage   [ T1 ]{ fontenc }
\DeclareFontShape { T1 }{ cmr }{ c }{ n }{ <->ssub*cmr/m/n }{ }

% -- Current Roboto font set

\RequirePackage [ light ]{ roboto }
\renewcommand \seriesdefault { m }

% ----------------------------------------
%            Colour Definitions
% ----------------------------------------

% -- UQ Space Colours

\providecolor { UQ Purple }{ HTML }{ 51247A }
\providecolor { UQ Grey   }{ HTML }{ 999490 }

% -- Standard Palette

\definecolor { red        }{ HTML }{ E62645 }
\definecolor { green      }{ HTML }{ 2EA836 }
\definecolor { orange     }{ HTML }{ EB602B }
\definecolor { magenta    }{ HTML }{ 962A8B }

\definecolor { dark green }{ HTML }{ 31ac34 }
\definecolor { dark blue  }{ HTML }{ 2f5ec9 }


\colorlet {         section } { UQ Purple }
\colorlet {     sub section } { UQ Purple }
\colorlet { sub sub section } { UQ Purple }
\colorlet {       paragraph } { UQ Purple }

% --- Set text for section label, and reduce spacing of TOC appearance

\NewDocumentCommand \titleprefix { }{ }
\titlecontents
  { section }
  [ 4ex ]
  { \vspace { 1ex } }
  { \contentslabel{3ex} }{ }{ \hfill\contentspage }{ \vspace { 1ex } }

\dottedcontents
  { sub section }
  [ 10ex ]
  { }
  { 5ex }
  { 1em }

\dottedcontents
  { sub sub section }
  [ 19ex ]
  { }
  { 7ex }
  { 1em }

% --- Customise formatting for \section, \subsection & \subsubsection
\titleformat \section
  { \setlength\fboxsep{2mm} \color { section } \Large \sffamily \bfseries }
  { \llap { \fcolorbox{UQPurple}{UQPurple}{ \hspace\marginparsep \color{white} \thetitle } \enspace }}
  { 0ex }
  { }

\titleformat \subsection
  { \color { sub section } \large \sffamily }
  { \llap { \thetitle\enspace } }
  { 0ex }
  { }

\titleformat \subsubsection
  { \color { sub sub section } \sffamily }
  { \llap { \thetitle\enspace } }
  { 0ex }
  { }

\titleformat \paragraph
  [ runin ]
  { \color { paragraph } \sffamily }
  { }
  { 0ex }
  { }


% --- Customise spacing for \section, \subsection & \subsubsection

\titlespacing \section       { 0ex }{ 1ex }{ 1ex }
\titlespacing \subsection    { 0ex }{ 1ex }{ 0.5ex }
\titlespacing \subsubsection { 0ex }{ 1ex }{ 0.5ex }
\titlespacing \paragraph     { 0ex }{ 1ex }{ 0.5ex }


% --- Customise the header and footer respectively

\NewDocumentCommand \marginRule {  }{
  \bool_if:nT \g_uqs_comments_bool {
    \begin{tikzpicture}[ overlay, remember~picture ]
      \draw[UQ Purple,thin]
        ( [xshift=\pdfpagewidth-\commentmargin] current~page.north~west ) --
        ( [xshift=\pdfpagewidth-\commentmargin] current~page.south~west ) ;
    \end{tikzpicture}
  }
}

\widenhead { 10mm }{ 10mm }

\def \projectTag { UQ~Space~/~\The{project} }

\renewpagestyle { empty }{
    \sethead { }{ }{ \marginRule }
    \setfoot { }{ }{ }
}

\newpagestyle { simple }[ \color{UQ Purple}\sffamily ]{
    \sethead { \projectTag }{ }{ \marginRule }
    \setfoot { }{ \thepage }{ }
}

\newpagestyle { fancy }[ \color{UQ Purple}\sffamily ]{
    \sethead { \projectTag    }{ }{ \sectiontitle\marginRule }
    \setfoot { \The{document} }{ }{ \thepage }
}

%% ============================================================================



%% ==================== Modification of Existing Commands =====================

% Required package information
%
%   etoolbox -> Toolbox of commands for creating more complex macros, and
%               hooking onto internal LaTeX and TeX macros.

%% ---------------------------------------------------------------------------

\RequirePackage { etoolbox }
\RequirePackage { secnum }
\RequirePackage { svg }

%% ---------------------------------------------------------------------------

% --- Default footnotesize font within tables

\AtBeginEnvironment  { tabular } \small


% --- Reduction of spacing after tables and figures

\AfterEndEnvironment { table   } { \vspace { -2ex } }
\AfterEndEnvironment { figure  } { \vspace { -2ex } }


% --- Rename section label, and change numbering at \appendix
%     NOTE: Use \secnum when available

\appto \appendix {
    \RenewDocumentCommand \titleprefix { } { App.~ }
    \setsecnum{A.I.i}
}

\NewDocumentCommand \titleblock { }{
  \centering \sffamily
  \ifThe{competition}
    { \large \sffamily \bfseries \scshape \The{competition} } \\[1.8ex]
  \fi
  { \Huge \scshape \robotoThin{\The{document}} } \\[1.5ex]
  \ifThe{team} { \large
    \rule[0.6ex]{0.32\textwidth}{.4pt}
    \enspace { \robotoThin{\The{team}} } \enspace
    \rule[0.6ex]{0.32\textwidth}{.4pt}
  } \else { \large
    \rule[0.6ex]{0.80\textwidth}{.4pt}
  } \fi \\[1.6ex]
  { \huge \robotoThin{\The{project}} }
}

\RenewDocumentCommand \maketitle { } {
  \begin{titlepage}

  \pgfdeclareverticalshading { sunset }{ 100 bp }
    { color(0bp)=(magenta); color(60bp)=(UQ Purple); color(100bp)=(UQ Purple) }

  \tikzfading[
    name = fade~sunset,
    top~color=transparent!100,
    bottom~color=transparent!0
  ]

  \begin{tikzpicture}[remember~picture,overlay]

    \fill [ black ] ( current~page . north~west ) rectangle ( current~page . south~east );

    \shade [
      shading=sunset, path~fading=fade~sunset
    ] ( current~page . south~west ) rectangle +(\paperwidth, .5\paperheight);

    \node( starmap ) at ([ yshift=40mm ] current~page . center ) {
      \includesvg[ width=\paperwidth, inkscapearea=page ]{ images/starcover.svg } };

    \node[ anchor=north ] at ([ shift={(-3mm,-10mm)} ] current~page . north) {
      \includegraphics[ width=\paperwidth ]{ packages/uqsLogo-light.png } };

    \node[ anchor=south, outer~sep=5mm ] ( banner ) at ( current~page . south ) {
      \includegraphics[ width=0.9\paperwidth ]{ packages/uqLockup-white.png } };

    \node[ anchor=south, white ] at ( banner . north ) {
      \parbox { 0.8\paperwidth }{ \titleblock } };

  \end{tikzpicture}
  \end{titlepage}
}

%% ============================================================================





%% ============================================================================
%%                     NEW CUSTOM COMMANDS & ENVIRONMENTS
%% ============================================================================

\RequirePackage { comments }
\RequirePackage { versioning }

%% ----------------------------------------------------------------------------

\bool_if:nF { \g_uqs_comments_bool }{ \DisableComments }

%% ------------- Acknowledgements and Contributions Environments --------------

% --- Formats the abstract paragraph

\RenewDocumentEnvironment { abstract }{ }{
    \hfill
    \begin{minipage}{0.8\linewidth}
    \textcolor{UQ Purple}{\firamedium{Abstract: }}
}{
    \end{minipage}
    \hfill
    \vspace{6ex}
}


% --- Temporarily reformatted \section

\NewDocumentCommand \underlinedTitle { s O{#3} m }{
    \group_begin:
    \titleformat \section
        { \color {subsection} \LARGE \bfseries}
        { \thetitle \quad }
        { 2em }
        { \vspace{1em} \filcenter }
        [\titlerule\relax]
    \IfBooleanTF { #1 }
        { \section*{#3} }
        { \section[#2]{#3} }
    \group_end:
}


% --- Formats the acknowledgements paragraph

\NewDocumentEnvironment { acknowledgements }{ }{
    \hfill
    \begin{minipage}{0.8\linewidth}
        \underlinedTitle*{Acknowledgements}\vspace{0.25em}
        \begin{center}
}{
        \end{center}
    \end{minipage}
    \hfill
}


% --- Formats the contributions list. Takes an optional number
%     of columns to align to, with the default being 2.

\NewDocumentEnvironment { contributions } { O{2} m } {
    \hfill
    \begin{minipage}{#2}
        \begin{multicols}{#1}[\underlinedTitle*{Contributions}]
            \centering
}{
        \end{multicols}
    \end{minipage}
    \hfill
}


%% ------------------ Resize and reorient pages mid-document ------------------

\usepackage{paperchange}

% --- Reset page sizing after importing each section, for consistency

\RequirePackage{import}                                   % <--- Requires this!

\let\oldimport\import
\RenewDocumentCommand \import { mm }{
    \newpage
    \oldimport { #1 }{ #2 }
    \restorepagesize
    \relax
}


%% ----------------- Define classes of basic acronyms en-mass -----------------

% --- Creates function that takes two values, and creates an acronym belonging
%     to a given class.

\cs_new:Nn \acr_new_acro:nn { }
\cs_new:Nn \acr_set_class:n {
  \cs_gset:Nn \acr_new_acro:nn {
    \DeclareAcronym { ##1 } {
      short = { ##1 },
      long  = { ##2 },
      tag   = {  #1 }
    }
  }
}


% --- Takes a list of key-value arguments, with each key and values being the
%     short and long forms of the acronyms respectively. Has an optional
%     argument representing the class the acronyms belong to.

\NewDocumentCommand \AddAcronyms { om } {
  \acr_set_class:n { #1 }
  \keyval_parse:NNn \use_none:n \acr_new_acro:nn { #2 }
}


%% ---------------------------- Invisible Sections ----------------------------

\NewDocumentCommand \invisibleSection { O{#2} m }{
    \phantomsection
    \sectionmark { #2 }
    \refstepcounter { section }
    \addcontentsline { toc }{ section }{
        \protect \numberline{ \thesection } \protect #1
    }
}

%% ============================================================================