\NeedsTeXFormat{LaTeX2e}
\RequirePackage{expl3}                                 % - Load LaTeX3 packages


%% ============================================================================
%%                          ~~~ CLASS META-INFO ~~~
%% ____________________________________________________________________________

\ProvidesExplClass
  {uqsreport}                                                   % - Name
  {2020/06/07}                                                  % - Date
  {1.0.3}                                                       % - Version
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
    \dim_set:Nn \commentmargin { 2in }
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

% --- Define custom UQ Space colours for titles

\providecolor { UQS Blue }{ HTML }{ 091544 }
\providecolor { UQS Grey }{ HTML }{ 868eb2 }

\definecolor { red    }{ HTML }{ e04d4a }
\definecolor { green  }{ HTML }{ 5ad05d }
\definecolor { orange }{ HTML }{ f49936 }

\definecolor { dark green }{ HTML }{ 31ac34 }
\definecolor { dark blue  }{ HTML }{ 2f5ec9 }

\colorlet {         section } { UQS Blue }
\colorlet {     sub section } { UQS Blue }
\colorlet { sub sub section } { UQS Blue }
\colorlet {       paragraph } { UQS Blue }

% --- Set text for section label, and reduce spacing of TOC appearance

\NewDocumentCommand \titleprefix { }{ }
\dottedcontents
  { section }
  [ 3.4ex ]
  { \vspace { 1ex } \color { section } \firamedium }
  { 3ex }
  { 0pc }


% --- Customise formatting for \section, \subsection & \subsubsection
\titleformat \section
  { \color { section } \Large \firamedium }
  { \makebox[ 0ex ][ r ]{ \thetitle\enspace } }
  { 0ex }
  { }

\titleformat \subsection
  { \color { sub section } \large \firamedium }
  { \makebox[ 0ex ][ r ]{ \thetitle\enspace } }
  { 0ex }
  { }

\titleformat \subsubsection
  { \color { sub sub section } \firamedium }
  { \makebox[ 0ex ][ r ]{ \thetitle\enspace } }
  { 0ex }
  { }

\titleformat \paragraph
  [ runin ]
  { \color { paragraph } \firamedium }
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
      \draw[UQS Blue,thin]
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

\newpagestyle { simple }[ \color{UQS Blue}\firalight ]{
    \sethead { \projectTag }{ }{ \marginRule }
    \setfoot { }{ \thepage }{ }
}

\newpagestyle { fancy }[ \color{UQS Blue}\firalight ]{
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
  \centering \color { UQS Blue } \firalight
  \ifThe{competition}
    { \large \firamedium \scshape \The{competition} } \\[1.8ex]
  \fi
  { \Huge \The{document} } \\[1.5ex]
  \ifThe{team} { \large
    \rule[0.6ex]{0.32\textwidth}{.4pt}
    \enspace { \The{team} } \enspace
    \rule[0.6ex]{0.32\textwidth}{.4pt}
  } \else { \large
    \rule[0.6ex]{0.80\textwidth}{.4pt}
  } \fi \\[1.6ex]
  { \huge \The{project} }
}

\RenewDocumentCommand \maketitle { } {
  \begin{titlepage}
  \begin{tikzpicture}[remember~picture,overlay]

    \node( starmap ) at ([ yshift=40mm ] current~page . center ) {
      \includesvg[ width=\paperwidth, inkscapearea=page ]{ images/starmap.svg }
    };

    \node[ anchor=north ] at ([ shift={(-3mm,-10mm)} ] current~page . north) {
      \includegraphics[ width=\paperwidth ]{ packages/uqsLogo-blue.png }
    };

    \node( banner ) at ([ yshift=2mm ] current~page . south ) [
      anchor=south, fill=UQS Blue,
      minimum~width=(\paperwidth-4mm), minimum~height=40mm
    ] {
      \includegraphics[ width=0.9\paperwidth ]{ packages/uqLockup-white.png }
    };

    \node[ anchor=south ] at ([ yshift=8mm ] banner . north ) {
      \parbox { 0.8\paperwidth }{ \titleblock }
    };

    % \node [ anchor=west ] at
    %   ( [ xshift=+6mm ] current~page . west |- 0, 0 |- banner . center )
    %   { \includegraphics [ height=20mm ]{ images/uqs-logo-w2.png } };

    % \node [ anchor=east ] at
    %   ( [ xshift=-6mm ] current~page . east |- 0, 0 |- banner . center )
    %   { \Large \color { white } \The{project} };

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
    \textcolor{UQS Blue}{\firamedium{Abstract: }}
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

\dim_const:Nn \defaultmargin       { 0.85 in }
\dim_const:Nn \c_uqs_refHeight_dim { 29.7 cm }  % -- 0.00009pt different to \the\pdfpageheight -_-
\dim_const:Nn \c_uqs_refWidth_dim  { \the\pdfpagewidth + \commentmargin }

\prop_new:N \g_uqs_pages_prop

\msg_new:nnn
    { Pages }
    { AlreadyDefined }
    { The~page~size~#1~is~already~defined }
\msg_new:nnn
    { Pages }
    { InvalidOrientation }
    { Invalid~orientation~`#1`,~choose~`port`~or~`land` }


% --- Define a new pagesize

\NewDocumentCommand \newpagesize { mmm }{
    % Sort the dimensions; a <- short, b <- long
    \dim_set:Nn \l_tmpa_dim { \dim_min:nn { #2 } { #3 } }
    \dim_set:Nn \l_tmpb_dim { \dim_max:nn { #2 } { #3 } }
    % Add dimensions to comma list
    \clist_clear:N \l_tmpa_clist
    \exp_args:NNV \clist_put_right:Nn \l_tmpa_clist { \dim_use:N \l_tmpa_dim }
    \exp_args:NNV \clist_put_right:Nn \l_tmpa_clist { \dim_use:N \l_tmpb_dim }
    % Raise warning if page size already defined
    \prop_if_in:NnT \g_uqs_pages_prop { #1 } { \msg_warning:nnn {Pages} {AlreadyDefined} {#1} }
    % Put page size into global property list
    \exp_args:NNnV \prop_gput:Nnn \g_uqs_pages_prop { #1 } \l_tmpa_clist
}


% --- Sets the current page size and orientation. Mandatory argument is the
%     page size, as is set by `newpagesize`, while the optional argument is
%     'port' or 'land' for portrait and landscape respectively. Default is
%     'port'.

\NewDocumentCommand \setpagesize { O{} m !O{port} }{
  \prop_get:NnN \g_uqs_pages_prop { #2 } \l_tmpa_tl
  \exp_args:NNV \clist_set:Nn \l_tmpa_clist \l_tmpa_tl
  \str_case:nnF { #3 } {
    { port } { }  % No need to change anything
    { land } { \clist_reverse:N \l_tmpa_clist }
  }
  { \msg_error:nnn {Pages} {InvalidOrientation} {#3} }
  \dim_set:Nn \pdfpagewidth  { \clist_item:Nn \l_tmpa_clist 1 + \commentmargin }
  \dim_set:Nn \pdfpageheight { \clist_item:Nn \l_tmpa_clist 2 }
  \eject
  % Create new margins relative to original page size
  \newgeometry{
    layoutsize = { \pdfpagewidth, \pdfpageheight },
    marginparsep = \defaultmargin + 1em,  % |- 1em for padding
    marginpar    = \commentmargin - 2em,  % |
    margin       = \defaultmargin,
    right        = \defaultmargin + \commentmargin,
    #1
	}
}


% --- Restores the page size and orientation to A4 portait. Uses size
%     comparison to reduce the number of calls required to `newgeometry`

\NewDocumentCommand \restorepagesize { }{
    \bool_lazy_and:nnF
        { \dim_compare_p:nNn { \pdfpagewidth  }{ = }{ \c_uqs_refWidth_dim  } }
        { \dim_compare_p:nNn { \pdfpageheight }{ = }{ \c_uqs_refHeight_dim } }
        { \newpage\setpagesize{ A4 } }
}


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
      class = {  #1 }
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