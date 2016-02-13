%!TEX root = thesis.tex

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{thesis}[2015/06/13 Extension of thud document class]

% LaTeX 2e fixes
\RequirePackage{fix-cm}

%
% This class is nothing like reusable or generic or anything.
% It just contains everything I would have put in the thesis preamble
%

\ProcessOptions\relax

%
% Load the thud class
%
% This hack to pass the language to babel inside thud is horrid
\def\thudbabelopt{italian,english}
\LoadClass[target=bach]{thud}

%
% Used packages
%

% Encoding and fonts
\RequirePackage[utf8]{inputenc}
\RequirePackage{zi4} % For a decent monospace font

% Typographic elements
\RequirePackage{epigraph}

% TeX programming
\RequirePackage{etoolbox}
\RequirePackage{environ}

% ToC, Bibliography, Index, Floats, etc...
\RequirePackage{varioref}
\RequirePackage{hyperref}
\RequirePackage[capitalise,noabbrev,nameinlink]{cleveref}
\RequirePackage[numbers,square,sort&compress]{natbib}
\RequirePackage{newfloat}
\RequirePackage{caption,subcaption}
\RequirePackage{emptypage} % Avoid headings on empty pages
\RequirePackage[nottoc,notlot,notlof]{tocbibind}
\RequirePackage{tocloft}
\RequirePackage{chngcntr} % For \counterwithout
\RequirePackage{flushend} % To balance the two columns of the index's last page
\RequirePackage{titlesec}

% Math
\RequirePackage{amsmath,amssymb,amsthm}
\RequirePackage{thmtools}
\RequirePackage{mathtools}

% Typesetting
\RequirePackage{complexity}
\RequirePackage{enumitem}
\RequirePackage{listings}
\RequirePackage{xcolor}
\RequirePackage{lettrine}
\RequirePackage[all]{foreign}

%
% Layout, typography, ToC, etc...
%

%
% Add a little of space below the supervisor name, for the signature
%
\let\@oldsupervisor\supervisor
\renewcommand\supervisor[1]{\@oldsupervisor{#1\vspace{4ex}}}

% I don't like the default style because mixes Serif and Sans Serif
% in different headings.
% This style has Serif fonts everywhere for consistency
\AtBeginDocument{\pagestyle{big}}

% The bibliography style provided by the thud package is just a stripped down
% version of this one, no need to use custom code.
\bibliographystyle{abbrvnat}

% Correct running heads in bibliography and index to avoid the uppercasing.
% Huge hack until I understand how the thud class really works.
\AtBeginEnvironment{thebibliography}{%
  \renewcommand\MakeUppercase[1]{#1}%
}

\AtBeginEnvironment{theindex}{%
  \renewcommand\MakeUppercase[1]{#1}%
  \cleardoublepage
}

\AtEndEnvironment{theindex}{%
  \flushcolsend% To balance the two columns of the last page of the index
}

% ToC issues
\renewcommand\cfttoctitlefont{\hfill\Huge\bfseries}
\setlength\cftaftertoctitleskip{0pt}

\AtBeginDocument{%
  \preto\tableofcontents{\cleardoublepage}%
}

% Settings for lettrines
\setlength{\DefaultNindent}{0pt}
\setcounter{DefaultLines}{2}

% Settings for lists
\setlist{nosep}
\setlist[itemize,1]{label=$\circ$}
\setlist[itemize,2]{label=\textendash}
\setlist[description]{
  leftmargin=0pt,
  labelsep=\parindent,
  labelindent=\parindent,
  font=\normalfont\itshape,
  listparindent=\parindent
}

\AtBeginEnvironment{description}{
  \let\@olditem\item
  \renewcommand\item[1][]{\@olditem[#1.]}
}

% Theorems etc...
\mathtoolsset{showonlyrefs,showmanualtags}
\declaretheorem{definition}
\declaretheorem{theorem}
\declaretheorem[sibling=theorem]{lemma}


% Enable indexing
% makeidx package loaded from the class (and conflicts if reloaded)
\makeindex

% Convenience index and emphasis command.
\newcommand{\emphidx}[1]{\emph{#1}\index{#1}}

%
% Pretty printing of code listings
%
% Style
\lstset{
  basicstyle=\small\ttfamily,
  commentstyle=\normalfont,
  numberstyle=\small,
  numbers=left,
  numberfirstline=true,
  showlines=true,
  captionpos=b,
  xleftmargin=2em,
  frame=l,
  escapeinside={/*}{*/}
}

%
% Floats environments
%

% Float for listings
\DeclareFloatingEnvironment[
  name=Listing,
  fileext=lol
]{listing}

% Cleveref names
\if@cref@capitalise
\crefname{listing}{Listing}{Listings}
\crefname{sublisting}{Listing}{Listings}
\else
\crefname{listing}{listing}{listings}
\crefname{sublisting}{listing}{listings}
\fi

\Crefname{listing}{Listing}{Listings}
\Crefname{sublisting}{Listing}{Listings}

% Continuous numbering of floats
\counterwithout{figure}{chapter}
\counterwithout{table}{chapter}
\counterwithout{listing}{chapter}
\counterwithout{equation}{chapter}

%
% Automatic PDF info
%
\pdfstringdefDisableCommands{
  \def\\{\ }
}

\apptocmd{\title}{
  \hypersetup{
    pdftitle={#1}
  }
}{}{}

\apptocmd{\author}{
  \hypersetup{
    pdfauthor={#1}
  }
}{}{}

\hypersetup {
  pdfsubject={Master Thesis - Università degli Studi di Udine}
}


%
% Provided commands
%

%
% Numerals (useful in the bibliography)
%
\renewcommand\th {\textsuperscript{th}\xspace}
\newcommand  \fst{\textsuperscript{st}\xspace}
\newcommand  \nd {\textsuperscript{nd}\xspace}
\newcommand  \rd {\textsuperscript{rd}\xspace}

% Turn thud front matter things into environments, and style them as a quote
% environment
% We also add an option to change language because these environments
% could have to be used more than once with different languages
\newenvironment{switchlang}[1]{
  \begingroup
    \newcommand\@newlang{#1}
    \if\@empty\@newlang \else \otherlanguage{#1}\fi
}{
    \if\@empty\@newlang \else \endotherlanguage\fi
  \endgroup
}

\newenvironment{@frontchapter}[2]{
  \switchlang{#1}
    \cleardoublepage
    \thispagestyle{empty}
    \vspace*{\fill}
    \par\flushright{\Huge\textbf{#2}}
    \vspace{2ex}
    \quote
}{
    \endquote
    \vspace*{\fill}
  \endswitchlang
}

\renewenvironment{abstract}[1][]{
  \@frontchapter{#1}{\abstractname}
}{
  \end@frontchapter
}

\renewenvironment{summary}[1][]{
  \@frontchapter{#1}{\summaryname}
}{
  \end@frontchapter
}

\renewenvironment{acknowledgements}[1][]{
  \@frontchapter{#1}{\acknowledgementsname}
}{
  \end@frontchapter
}

\renewenvironment{dedication}[1][0.4\textwidth]{%
  \titlelike{flushright}%
    \minipage{#1}
}{
    \endminipage%
  \endtitlelike%
}

% C-style multiline comments (Definitive TeX trick)
\long\def\*#1*/{\ClassWarning{thesis}{Multiline comment still alive}}

% Enhanced epigraph environment
\let\@oldepi\epigraph
\let\epigraph\relax
\NewEnviron{epigraph}[2][\@empty]
{%
  {%
    \@oldepi{\BODY}{#2\ifx\@empty#1 \else\\\emph{#1}\fi}%
  }%
}

% Complexity classes
\renewclass{\EXP}{EXPTIME}
\renewclass{\NEXP}{NEXPTIME}

% Use this after complexity classes to typeset "-complete", but avoiding
% the line to break on the hyphen
% Trick from
% http://tex.stackexchange.com/questions/103608
\newcommand{\hyphen}{\mbox{-}\nobreak\hspace{0pt}}

\newcommand{\complete}{\hyphen complete}
\newcommand{\completeness}{\hyphen completeness}
\newcommand{\hard}{\hyphen hard}
\newcommand{\hardness}{\hyphen hardness}

% Print a blue warning.
\newcommand{\textwarn}[1]{%
  \textsuperscript{\textcolor{blue}{#1}}%
}

% Remember to put a citation
\newcommand{\citationeeded}{%
  \textwarn{[citation needed]}%
  \ClassWarning{thesis}{Citation needed}%
}

% Fake headings with TODO mark on the ToC
\newcommand{\fakeheading}[2]{%
  \refstepcounter{#1}%
  \addcontentsline{toc}{#1}%
    {\numberline
      {\@nameuse{the#1}}#2\texorpdfstring{\textwarn{TODO}}{\ [TODO]}
    }%
  \ClassWarning{thesis}{Fake #1}%
}

\newcommand\newfake[1]{
  \@namedef{fake#1}##1{\fakeheading{#1}{##1}}
}

\newfake{section}
\newfake{subsection}

\newcommand\todo[1]{%
  \footnote{\textcolor{red}{#1}}%
  \PackageWarning{thesis}{Nota TODO ancora presente}%
}
% Numeric sets
\newcommand\N{\mathbb{N}}
\newcommand\Z{\mathbb{Z}}
\newcommand\Q{\mathbb{Q}}
\renewcommand\R{\mathbb{R}} % Already defined by the complexity package
\renewcommand\C{\mathbb{C}} % but with other meanings
