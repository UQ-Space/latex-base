\NeedsTeXFormat{LaTeX2e}

\LoadClass[a4paper]{article}
\RequirePackage{expl3}                                     % - Load LaTeX3 packages


%% ================================================================================
%%                            ~~~ CLASS META-INFO ~~~
%% ________________________________________________________________________________

\ProvidesExplClass
    {spacereport}                                                   % - Name
    {2020/03/27}                                                    % - Date
    {1.0.2}                                                         % - Version
    {Technical Report template for use by UQ Space}                 % - Description

%% ================================================================================



%% =============================== LaTeX3 Packages  ===============================

% Required package information:
%
%   xparse   -> Allows for custom macros with a range of inputs, including custom
%               defaults, stars, delimiters, etc.
%
%   xspace   -> Detection of spaces and punctuation gobbled by a macro, and
%               replacement of said text naturally.

%% --------------------------------------------------------------------------------

\RequirePackage { xparse   }
\RequirePackage { xspace   }
\RequirePackage { l3keys2e }

%% --------------------------------------------------------------------------------

\bool_new:N \g_uqs_comments_bool
\dim_new:N  \g_uqs_comments_dim
\keys_define:nn { docOptions }{
    comments .code:n = {
        \bool_set_true:N \g_uqs_comments_bool
        \dim_set:Nn \g_uqs_comments_dim { 2in }
    }
}

\ProcessKeysOptions { docOptions }

%% ================================================================================



%% ===================== Title & Header / Footer Customisation ====================

% Required package information:
%
%   xcolor   -> Creation of custom colours from a variety of input types (RGB,
%               HSV, etc.) Colours can be saved to given names. The [table] option
%               creates the `\rowcolor` macro, for colouring table rows. Caution
%               must be used when colouring rows with `booktabs`, as the colouring
%               will have gaps. The [x11names] option gives access to colours via
%               the common x11 naming scheme.
%
%   titlesec -> Customisation of title styles (section, subsection, etc.) Allows
%               for creation of new title levels between existing titles. The
%               [pagestyles] option provides a more simple and robust way to
%               customise the header and footer, with extra marks provided.
%
%   titletoc -> Customisation of how different title styles appear in the TOC.

%% --------------------------------------------------------------------------------

\RequirePackage [ table, x11names ] { xcolor   }
\RequirePackage [ pagestyles ]      { titlesec }
\RequirePackage                     { titletoc }
\RequirePackage                     { tikz     }

%% --------------------------------------------------------------------------------

% --- Define custom UQ Space colours for titles

\definecolor { section       } { RGB } { 14, 31, 102 }
\definecolor { subsection    } { RGB } { 14, 31, 102 }
\definecolor { subsubsection } { RGB } { 14, 31, 102 }
\definecolor { paragraph     } { RGB } { 14, 31, 102 }


% --- Set text for section label, and reduce spacing of TOC appearance

\NewDocumentCommand \sectionname {} { Section~ }
\dottedcontents
    { section }
    [ 3.4ex ]
    { \vspace { 1ex } \bfseries }
    { 3ex }
    { 0pc }


% --- Customise formatting for \section, \subsection & \subsubsection

\titleformat \section                                   % Set format for \section
    [ frame ]                                                 % Display style
    { \color { section } \normalfont }                        % Label text
    { \filleft \enspace \sectionname \thetitle \enspace }     % Title text
    { 1ex }                                                   % Spacing below title
    { \filright \Large \bfseries \enspace }                   % Title formatting

\titleformat \subsection
    { \color { subsection } \large \bfseries}
    { \thetitle \quad }
    { 0ex }
    { }

\titleformat \subsubsection
    { \color { subsubsection } \bfseries }
    { \thetitle \quad }
    { 0ex }
    { }


% --- Customise spacing for \section, \subsection & \subsubsection

\titlespacing \section       { 0em }{ 2ex }{ 3ex }
\titlespacing \subsection    { 0em }{ 1ex }{ 1ex }
\titlespacing \subsubsection { 1em }{ 1ex }{ 1ex }


% --- Customise the header and footer respectively

\NewDocumentCommand \marginRule {  }{
    \bool_if:nT \g_uqs_comments_bool {
        \begin{tikzpicture}[overlay,remember~picture]
            \draw[red,dashed]
                ([xshift=\pdfpagewidth-\g_uqs_comments_dim]current~page.north~west)
                --
                ([xshift=\pdfpagewidth-\g_uqs_comments_dim]current~page.south~west);
        \end{tikzpicture}
    }
}

\renewpagestyle { empty }{
    \sethead { } { } { \marginRule }
    \setfoot { } { } { }
}

\newpagestyle { simple }{
    \sethead { } { } { \marginRule }
    \setfoot { } { \thepage } { }
}

\newpagestyle { fancy }{
    \sethead { \sectiontitle  } { } { \The{project} \marginRule }
    \setfoot { \The{document} } { } { \thepage      }
}

%% ================================================================================



%% ====================== Modification of Existing Commands =======================

% Required package information
%
%   etoolbox -> Toolbox of commands for creating more complex macros, and hooking
%               onto internal LaTeX and TeX macros.

%% -------------------------------------------------------------------------------

\RequirePackage { etoolbox }

%% -------------------------------------------------------------------------------

% --- Default footnotesize font within tables

\AtBeginEnvironment  { tabular } \footnotesize


% --- Reduction of spacing after tables and figures

\AfterEndEnvironment { table   } { \vspace { -2ex } }
\AfterEndEnvironment { figure  } { \vspace { -2ex } }


% --- Rename section label, and change numbering at \appendix
%     NOTE: Use \secnum when available

\appto \appendix {
    \RenewDocumentCommand \sectionname { } { Appendix~ }
    \renewcommand* \thesubsection {
        % - Numbering: A.I
        \Alph   { section    }
        .\Roman { subsection }
    }
    \renewcommand* \thesubsubsection {
        % - Numbering: A.I.I
        \Alph   { section       }
        .\Roman { subsection    }
        .\Roman { subsubsection }
    }
}

\RenewDocumentCommand \maketitle { } {
  \begin{titlepage}
	\center

    \includegraphics[width=0.95\linewidth]{images/UQSpace_Logo.png}\\

	\vfill

	\fontfamily{qag}\selectfont

	\textbf{\Huge \The{project}} \\[3ex]
	\rule[0.7ex]{0.25\textwidth}{.4pt}
	\enspace {\large\The{duedate}} \enspace
	\rule[0.7ex]{0.25\textwidth}{.4pt} \\
	\textsc{\LARGE
	    \The{competition} \\
	    \The{team}
	    \enspace | \enspace
	    \The{document}
	}

	\vfill\vfill
	\includegraphics[width=120mm]{images/UQ_Lockup_Landscape.png}
	\vspace{1cm}

  \end{titlepage}
}

%% ================================================================================





%% ================================================================================
%%                        NEW CUSTOM COMMANDS & ENVIRONMENTS
%% ================================================================================

\RequirePackage { marginnote }

%% --------------------------------------------------------------------------------


%% --------------- Acknowledgements and Contributions Environments ----------------

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


%% -------------------- Resize and reorient pages mid-document --------------------

\dim_const:Nn \totalMargin         { 0.85 in            }
\dim_const:Nn \c_uqs_refHeight_dim { 29.7cm }  % -- 0.00009pt different to \the\pdfpageheight -_-
\dim_const:Nn \c_uqs_refWidth_dim  { \the\pagewidth + \g_uqs_comments_dim }

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


% --- Sets the current page size and orientation. Mandatory argument is the page
%     size, as is set by `newpagesize`, while the optional argument is 'port' or
%     'land' for portrait and landscape respectively. Default is 'port'.

\NewDocumentCommand \setpagesize { m O{port} }{
    \prop_get:NnN \g_uqs_pages_prop { #1 } \l_tmpa_tl
    \exp_args:NNV \clist_set:Nn \l_tmpa_clist \l_tmpa_tl
    \str_case:nnF { #2 } {
        { port } { }  % No need to change anything
        { land } { \clist_reverse:N \l_tmpa_clist }
    }
    { \msg_error:nnn {Pages} {InvalidOrientation} {#2} }
    \dim_set:Nn \pagewidth  { \clist_item:Nn \l_tmpa_clist 1 + \g_uqs_comments_dim }
    \dim_set:Nn \pageheight { \clist_item:Nn \l_tmpa_clist 2 }
    \eject
    % Create new margins relative to original page size
    \newgeometry{
		top    = \dim_eval:n { \totalMargin },
		left   = \dim_eval:n { \totalMargin },
		bottom = \dim_eval:n { \totalMargin + \c_uqs_refHeight_dim - \pageheight },
		right  = \dim_eval:n { \totalMargin + \c_uqs_refWidth_dim  - \pagewidth  },
		marginparsep = \totalMargin + 1em,
		marginparwidth = \g_uqs_comments_dim - 1em
	}
}


% --- Restores the page size and orientation to A4 portait.
%     Uses size comparison to reduce the number of calls required to `newgeometry`

\NewDocumentCommand \restorepagesize { }{
    \bool_lazy_and:nnF
        { \dim_compare_p:nNn { \pdfpagewidth  }{ = }{ \c_uqs_refWidth_dim  } }
        { \dim_compare_p:nNn { \pdfpageheight }{ = }{ \c_uqs_refHeight_dim } }
        { \newpage\setpagesize{ A4 } }
}


% --- Reset page sizing after importing each section, for consistency

\RequirePackage{import}                                       % <--- Requires this!

\let\oldimport\import
\RenewDocumentCommand \import { mm }{
    % \newpage
    \oldimport { #1 }{ #2 }
    \restorepagesize
    \relax
}


%% ------------------ Define `meta` properties for document use  ------------------

\prop_new:N \g_meta_dict_prop
\seq_new:N  \g_meta_prefix_seq

% --- Takes a list of key-value arguments, and assigns these within
%     the internal dictionary. Key-value arguments can be nested.

\NewDocumentCommand \Setup { m }{
    \keyval_parse:NNn
        \use_none:n
        \meta_subset:nn
        { #1 }
}


% --- Take a single 'meta' value, and add into the dictionary

\cs_new:Nn \meta_set:n {
    % Construct key from prefixes
    \exp_args:NNx   \str_set:Nn  \l_tmpa_str { \seq_use:Nn \g_meta_prefix_seq { . } }
    % If key already exists, then get token-list and append ', '
    % Otherwise, ensure temporary token-list is clear
    \prop_get:NVNTF \g_meta_dict_prop \l_tmpa_str \l_tmpa_tl
        { \tl_put_right:Nn \l_tmpa_tl {,~} }
        { \tl_gclear:N     \l_tmpa_tl }
    % Parse the values based on the last prefix
    \seq_get_right:NN \g_meta_prefix_seq \l_tmpb_tl
    \exp_args:NNf \tl_put_right:Nn \l_tmpa_tl {
        \str_case:VnF \l_tmpb_tl {
            { project  } { Project~#1 }
            { team     } { Team~#1 }
            { altitude } { \SI{#1}{\ft} }
            { size     } { \SI{#1}{\inch} }
            { length   } { \SI{#1}{\mm} }
            { diameter } { \SI{#1}{\mm} }
            { weight   } { \SI{#1}{\kg} }
        }
        { #1 }
    }
    % Put the modified / new token list into the property list
    \exp_args:NNoo \prop_gput:Nnn \g_meta_dict_prop \l_tmpa_str \l_tmpa_tl
}


% --- Take a key-value 'meta' info pair, use the key as a prefix,
%     and parse all the values individually.

\cs_new:Nn \meta_subset:nn {
    \seq_put_right:Nn \g_meta_prefix_seq { #1 }
    \keyval_parse:NNn
        \meta_set:n
        \meta_subset:nn
        { #2 }
    \seq_pop_right:NN \g_meta_prefix_seq \l_tmpa_tl
}


% --- Access the meta info property list by the given key.
%     Raise an error if the key doesn't exist.

\NewDocumentCommand \The { m }{
    \prop_get:NnNTF \g_meta_dict_prop { #1 } \l_tmpa_tl
        { \tl_use:N \l_tmpa_tl  }
        { ??? }
    \xspace
}


%% ------------------- Define classes of basic acronyms en-mass -------------------

% --- Creates function that takes two values, and creates an acronym belonginging
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


%% -------------------------- Inline and margin comments -------------------------

\NewDocumentCommand \comment { s +m } {
    \bool_if:nT \g_uqs_comments_bool {
        \IfBooleanTF { #1 }
            { { \color { red } \ttfamily #2 } }
            { \marginnote { \raggedright \color { red } \ttfamily #2 } }
    }
}


%% ----------------------------- Invisible Sections ------------------------------

\NewDocumentCommand \invisibleSection { O{#2} m }{
    \phantomsection
    \sectionmark { #2 }
    \addtocounter { section }{ 1 }
    \addcontentsline { toc }{ section }{
        \protect \numberline{ \thesection } \protect #1
    }
}

%% ===============================================================================
