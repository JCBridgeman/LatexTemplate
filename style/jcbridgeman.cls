%% Copyright (c) 2023 Jacob C Bridgeman.
%% https://jcbridgeman.github.io/
%% mailto:jcbridgeman1@gmail.com

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{jcbridgeman}[2023/07/31 jcbridgeman LaTeX class]
\RequirePackage{kvoptions}
\RequirePackage{xcolor}
\RequirePackage{etoolbox}
\RequirePackage{environ,totcount,changes}
\makeatletter
\patchcmd{\@hex@@Hex}{f\else}{F\else}{\typeout{Patching xcolor}}{}
\makeatother

\definecolor{yellow}{RGB}{204, 204, 0}
\definecolor{darkblue}{RGB}{0,0,127}
\definecolor{darkgreen}{RGB}{0,180,0}
\definecolor{darkred}{RGB}{180,0,0}
\definecolor{nicegreen}{RGB}{5, 173, 39}


\RequirePackage{listofitems,ifthen}
\SetupKeyvalOptions{family=JCB,prefix=JCB@}

\DeclareOption{reprint}{\PassOptionsToClass{\CurrentOption}{revtex4-2}}
\DeclareOption{preprint}{\PassOptionsToClass{\CurrentOption}{revtex4-2}}
\DeclareOption{onecolumn}{\PassOptionsToClass{\CurrentOption}{revtex4-2}}
\DeclareOption{twocolumn}{\PassOptionsToClass{\CurrentOption}{revtex4-2}}

\DeclareOption{letterpaper}{
	\PassOptionsToPackage{letterpaper,centering,hmargin=2cm,vmargin=2cm}{geometry}
	\PassOptionsToClass{\CurrentOption}{revtex4-2}
	}
\DeclareOption{a4paper}{
	\PassOptionsToPackage{a4paper,centering,hmargin=2cm,vmargin=2cm}{geometry}
	\PassOptionsToClass{\CurrentOption}{revtex4-2}
	}

\DeclareOption{prl}{\PassOptionsToClass{\CurrentOption}{revtex4-2}}
\DeclareOption{prb}{\PassOptionsToClass{\CurrentOption}{revtex4-2}}
\DeclareOption{prx}{\PassOptionsToClass{\CurrentOption}{revtex4-2}}


\newboolean{allowexternal}
\setboolean{allowexternal}{false}
\DeclareOption{externalize}{\setboolean{allowexternal}{true}}

\DeclareOption{linenumbers}{\PassOptionsToClass{\CurrentOption}{revtex4-2}}

% Author comment commands. Use option authorcodes={A,B,C}
\makeatletter

\let\oldequiv\equiv

\newcommand{\@insertcomment}[5]{%1=color,2=author code,3=precomment formatting,4=comment,5=postcomment
	\protect\addcontentsline{toc}{subsubsection}{\textcolor{#1}{#2:~#4}}
	{\color{#1}#3#2:~#4#5}
}

\newcommand{\@inlinecomment}[3]{%1=color,2=author code,3=comment
	\@insertcomment{#1}{#2}{}{#3}{}
}

\newcommand{\@standardcomment}[3]{%1=color,2=author code,3=comment
	\@insertcomment{#1}{#2}{\begin{center}$\oldequiv\joinrel\oldequiv$}{#3}{$\oldequiv\joinrel\oldequiv$\end{center}}
}

\newcommand{\@defcommentsLong}[3]{%1=command (eg \jcb skip the \),2=color,3=author code
	\csdef{#1}##1{\@standardcomment{#2}{#3}{##1}}
	\csdef{#1inline}##1{\@inlinecomment{#2}{#3}{##1}}
}

\newcounter{@color}\setcounter{@color}{1}

\definecolor{@jcbColor}{RGB}{179,0,0}
\definecolor{@TODOColor}{RGB}{255, 0, 0}

\newcommand{\colorprovide}[2]{%
  \@ifundefinedcolor{#1}{
    \colorlet{#1}{#2}
    \ifthenelse{\value{@color}<\@authorcolorslen}%
    {\stepcounter{@color}}%
    {\setcounter{@color}{1}}
    }{}}

\readlist*\@authorcolors{blue,violet,nicegreen,magenta,orange}

\newcommand{\@defcomments}[1]{
    \colorprovide{@#1Color}{\@authorcolors[\value{@color}]}
	\@defcommentsLong{#1}{@#1Color}{\uppercase{#1}}
}

\newcommand\change[2][]{
	\protect\addcontentsline{toc}{subsubsection}{\textcolor{red}{Change}}
	{\color{yellow}{\it #1}}{\color{blue}{#2}}
}

\@defcomments{jcb}
\@defcomments{TODO}

\DeclareStringOption{authorcodes}

\renewcommand{\do}[1]{\@defcomments{#1}}
\define@key{JCB}{authorcodes}{\docsvlist{#1}}

\def\tikzloc{sections/figureCode/}
\DeclareStringOption[sections/figureCode/]{tikzloc}[sections/figureCode/]
\define@key{JCB}{tikzloc}{
	\def\tikzloc{#1}
}

\makeatother

%% Referee response
\makeatletter
	\newbool{JCB@refereeresponse}
	\setbool{JCB@refereeresponse}{false}

	\NewEnviron{response}{}

	\DeclareStringOption[]{response}[]
	\define@key{JCB}{response}{
		\setbool{JCB@refereeresponse}{true}
		\typeout{JCB: response mode}
		\PassOptionsToPackage{draft}{changes}
		\def\responseloc{#1}
	}

	\DeclareOptionX<Changes@added>{summary}{\def\Changes@added@summary{#1}}
	\presetkeys{Changes@added}{summary=\@empty}{}
	\DeclareOptionX<Changes@deleted>{summary}{\def\Changes@deleted@summary{#1}}
	\presetkeys{Changes@deleted}{summary=\@empty}{}
	\DeclareOptionX<Changes@replaced>{summary}{\def\Changes@replaced@summary{#1}}
	\presetkeys{Changes@replaced}{summary=\@empty}{}
	\renewcommand{\Changes@optiondefaultcolor}{red}
	\DeclareOptionX{defaultcolor}{\ifblank{#1}{}{\renewcommand{\Changes@optiondefaultcolor}{#1}}}

	\ProcessOptionsX
\makeatother
%%

\DeclareOption*{\PassOptionsToClass{\CurrentOption}{revtex4-2}}

\ExecuteOptions{a4paper,reprint,onecolumn,prb}

\ProcessOptions\relax
\ProcessKeyvalOptions*

\LoadClass[aps,notitlepage,longbibliography,superscriptaddress,footinbib]{revtex4-2}
\RequirePackage{amsmath,amsfonts,amssymb,amsthm,bm,bbm,stmaryrd}
\RequirePackage{graphicx,tikz,pgfplots,tikz-3dplot}
\RequirePackage{environ,xstring}
\RequirePackage{apptools,pdftexcmds}
\RequirePackage{tabularx,multirow}
\RequirePackage{booktabs,colortbl}
\RequirePackage{adjustbox,soul,diagbox,cancel,hhline}
\RequirePackage{changes}
\RequirePackage{outlines,changepage,ftnxtra}
\RequirePackage{geometry}

% Some tweaks to revtex
\makeatletter

\def\orcid#1{
	\ifx&#1&%
	% #1 is empty
	\else
	\@AF@join{
		\twocolumn@sw{\newline}{\kern-.25em}
		\href{https://orcid.org/#1}{ORCID:#1}}%
	\fi
}%

\def\@homepage#1#2{%
	\endgroup
	\ifx&#2&%
	\else
	\@AF@join{#1\href{https://#2}{#2}}%
	\fi
}%

\let\@@cite\cite
\renewcommand\cite[1]{\ifstrempty{#1}{\@@cite{blank}}{\@@cite{#1}}}
\let\oldonlinecite\onlinecite


\renewcommand{\onlinecite}[1]{%
	\readlist*{\@citelist}{#1}%
	\ifnumgreater{\@citelistlen}{1}{Refs}{Ref}.~[\oldonlinecite{#1}]%
	}

\AtAppendix{
	\let\oldsection\section
	\renewcommand{\section}[1]{
		\clearpage
		\oldsection{#1}
	}
	\@addtoreset{figure}{section}
	\renewcommand\thefigure{\thesection\arabic{figure}}
}

\newcounter{subsubsubsection}[subsubsection]
\def\subsubsubsectionmark#1{}
\def\thesubsubsubsection{}
\def\@subsubsubsection{\@startsection{subsubsubsection}{4}{5pt}{3ex}{2ex}{\small\centering\emph}}
\def\l@subsubsubsection{\@dottedtocline{4}{4.8em}{4.2em}}

\def\subsubsubsection{\@ifstar{\@subsubsubsection*}{\@subsubsubsection*}}

\makeatother

\usepackage[font=small,textfont=normalfont,singlelinecheck=off]{caption}
\usepackage[font=small,textfont=normalfont,singlelinecheck=off,justification=raggedright,labelfont=bf]{subcaption}

\newcommand{\sidecaption}[1]% #1 = label name
{\raisebox{\abovecaptionskip}{\begin{subfigure}[t]{1.6em}
			\caption[singlelinecheck=off]{}% do not center
			\label{#1}
		\end{subfigure}}\ignorespaces}

\makeatletter

\let\@oldtitle\title
\def\title#1{
    \def\@pdftitle{#1}
    \@oldtitle{#1}
}

\let\@oldauthor\author
\def\author#1{
\ifx\@pdfauthor\empty
\def\@pdfauthor{#1}
\else
\expandafter\def\expandafter\@pdfauthor\expandafter{\@pdfauthor, #1}
\fi
    \@oldauthor{#1}
}

\RequirePackage[pdfpagelabels,pdftex,bookmarks,breaklinks]{hyperref}
\definecolor{UGentBlue}{RGB}{30,100,200}

\hypersetup{
	colorlinks,
	linkcolor=UGentBlue,
	citecolor=UGentBlue,
	filecolor=red,
	urlcolor=UGentBlue,
	pdftitle={\@pdftitle},
	pdfauthor={\@pdfauthor},
    pdfcreator={LaTeX with extended hyperref}
}

\RequirePackage[capitalise]{cleveref}

\makeatother

% Math macros
\DeclareMathOperator{\Tr}{Tr}
\DeclareMathOperator{\tr}{tr}
\DeclareMathOperator{\supp}{supp}
\DeclareMathOperator{\Di}{Dih}
\DeclareMathOperator{\rep}{Rep}
\DeclareMathOperator{\op}{op}
\DeclareMathOperator{\id}{id}
\DeclareMathOperator{\Aut}{Aut}
\DeclareMathOperator{\End}{End}
\DeclareMathOperator{\Irr}{Irr}
\DeclareMathOperator{\Sign}{Sign}
\DeclareMathOperator{\Ind}{Ind}
\DeclareMathOperator{\rk}{rk}
\DeclareMathOperator{\Span}{span}
\DeclareMathOperator{\U}{U}

\newcommand{\iso}{\simeq}

\newcommand{\ZZ}[1]{\mathbb{Z}_{#1}}
\newcommand{\GF}[1]{\operatorname{GF}\left(#1\right)}
\newcommand{\FF}[1]{\mathbb{F}_{#1}}

\newcommand{\eps}{\epsilon}
\newcommand{\veps}{\varepsilon}
\newcommand{\cO}{\mathcal{O}}

\newcommand{\ket}[1]{|{#1}\rangle}
\newcommand{\expect}[1]{\langle{#1}\rangle}
\newcommand{\bra}[1]{\langle{#1}|}
\newcommand{\ketbra}[2]{|{#1}\rangle\!\langle{#2}|}
\newcommand{\braket}[2]{\langle{#1}|{#2}\rangle}
\newcommand{\proj}[1]{\ketbra{#1}{#1}}
\newcommand{\vket}[1]{|{#1})}
\newcommand{\vbra}[1]{({#1}|}
\newcommand{\Dih}[1]{\Di_{#1}}

\newcommand*{\one}{\mathbbm{1}} % identity
\newcommand{\D}[1]{\mathcal{D}{} }

\newcommand{\norm}[1]{\left\lVert#1\right\rVert}
\newcommand{\opnorm}[1]{\left\lVert#1\right\rVert_\text{op}}
\newcommand{\comm}[1]{\left[#1\right]}
\newcommand{\restrict}[1]{\raise-.2ex\hbox{\ensuremath|}_{#1}}

\newcommand{\G}{\mathcal{G}}

\usepackage[mathscr]{eucal}
\newcommand{\graph}{\mathscr{G}}

\newcommand{\vvec}[2][]
{\ensuremath{%
	\operatorname{\bf Vec}^{#1}
	\ifstrequal{#2}{}
	{}
	{\left(#2\right)}%
}}

\newcommand{\rrep}[2][]
{\ensuremath{%
	\operatorname{\bf Rep}^{#1}
	\ifstrequal{#2}{}
	{}
	{\left(#2\right)}%
}}

\newcommand{\vvectwist}[2][]{\vvec[#1]{#2}}

\let\originalleft\left
\let\originalright\right
\renewcommand{\left}{\mathopen{}\mathclose\bgroup\originalleft}
\renewcommand{\right}{\aftergroup\egroup\originalright}

\newcommand{\cat}[1]{\ensuremath{\mathcal{#1}}}
\newcommand{\C}{\cat{C}}
\newcommand{\M}{\cat{M}}

\newcommand{\set}[2]{
	\left\{#1
	\ifthenelse{\equal{#2}{}}{}{\,\middle|\,#2}
	\right\}
}

\newcommand{\order}[1]
{
	\left|
	\ifstrequal{#1}{}
	{\bullet}
	{#1}
	\right|
}

\newcommand{\subgp}{\leq}
\newcommand{\normalsubgp}{\trianglelefteq}

\newcommand{\cent}[1]
{\ensuremath{
		\operatorname{\bf Z}
		\ifstrequal{#1}{}
		{}
		{\left(#1\right)}
}}

\newcommand{\centralizer}[2]
{\ensuremath{
		\operatorname{\bf C}
		\ifstrequal{#2}{}{_{\Pauli{q}{n}}}{_{#2}}
		\ifstrequal{#1}{}
		{}
		{\left(#1\right)}
}}

\newcommand{\normalizer}[2]
{\ensuremath{
		\operatorname{\bf N}
		\ifstrequal{#2}{}{_{\Pauli{q}{n}}}{_{#2}}
		\ifstrequal{#1}{}
		{}
		{\left(#1\right)}
}}

\newcommand{\grouppresentation}[2]{
	\left\langle#1
	\ifthenelse{\equal{#2}{}}{}{\,\middle|\,#2}
	\right\rangle
}

\newcommand{\codeparameters}[2]{
	\left\llbracket#1\right\rrbracket_{#2}
}

\newenvironment{subalign}[1][]{\subequations\label{#1}\align}{\endalign\endsubequations}

\newcommand{\define}[1]{\emph{#1}}

\newcolumntype{C}[1]{>{\centering\let\newline\\\arraybackslash\hspace{0pt}}m{#1}}
\newcommand{\minitab}[2][l]{\begin{tabular}{#1}#2\end{tabular}}

\newcommand{\greycline}[1]{\arrayrulecolor[gray]{.8}\cline{#1}\arrayrulecolor{black}}

\newcommand\Tstrut{\rule{0pt}{2.6ex}}

\newcommand{\inputtikz}[1]{\input{\tikzloc#1.tikz}}
\let\includetikz\inputtikz

\newboolean{remakeall}
\setboolean{remakeall}{false}
\pgfplotsset{compat=newest}
\pgfplotsset{plot coordinates/math parser=false}
\usetikzlibrary{arrows,arrows.meta,decorations.pathmorphing,backgrounds,positioning,fit,calc,patterns,shapes,decorations.markings,shadings,perspective,fadings}
\usetikzlibrary{external}
\tikzset{every picture/.style={line cap=butt,line join=round}}

\ifthenelse{\not\equal{\tikzexternalcheckshellescape}{}\and\boolean{allowexternal}}{
	\tikzexternalize[prefix=figures/]
	\tikzset{external/system call={
				pdflatex \tikzexternalcheckshellescape -halt-on-error -interaction=batchmode -jobname "\image" "\texsource";rm  -f "\image".log ; rm -f "\image".dpth ; rm  -f "\image"Notes.bib; rm  -f "\image".md5;
			}}
}{
}

\newcommand{\includeTikz}[2]
{
    
	\tikzifexternalizing
	{
		\includeTikzrm{#1}{#2}
	}
	{
		\IfFileExists{figures/#1.pdf}
		{
			\ifthenelse{\boolean{remakeall}}
			{\includeTikzrm{#1}{#2}}
			{\includegraphics{figures/#1}}
		}
		{
			\includeTikzrm{#1}{#2}
		}
	}
}

\newcommand{\includeTikzrm}[2]{
	\tikzset{external/remake next}
	\tikzsetnextfilename{#1}
	#2
}

\NewEnviron{tikzarray}[2][scale=1]{
	\ensuremath{
		\begin{array}{c}\typeout{XYZ}
			\IfSubStr{#2}{:}
			{
				\StrBehind{#2}{:}[\filename]
				\includeTikzrm{\filename}{\begin{tikzpicture}[#1]\BODY;\end{tikzpicture}}
			}
			{
				\includeTikz{#2}{\begin{tikzpicture}[#1]\BODY;\end{tikzpicture}}
			}
		\end{array}}
}

\NewEnviron{tikzarrayrm}[2][scale=1]{
	\begin{array}{c}
		\IfSubStr{#2}{:}
		{
			\StrBehind{#2}{:}[\filename]
			\includeTikzrm{\filename}{\begin{tikzpicture}[#1]\BODY;\end{tikzpicture}}
		}
		{
			\includeTikzrm{#2}{\begin{tikzpicture}[#1]\BODY;\end{tikzpicture}}
		}
	\end{array}
}

\newcommand{\ifequals}[3]{\ifthenelse{\equal{#1}{#2}}{#3}{}}
\newcommand{\swcase}[2]{#1 #2} % Dummy, so \renewcommand has something to overwrite...
\newenvironment{switch}[1]{\renewcommand{\swcase}{\ifequals{#1}}}{}

\bibliographystyle{apsrev_jacob}

\allowdisplaybreaks



%%%%%%%
\makeatletter

\newcommand{\@sout}[1]{#1}
\setdeletedmarkup{\@sout{#1}}

\newtotcounter{JCB@Changes@total}

\ifbool{JCB@refereeresponse}{

	\NewCommandCopy{\@added}{\added}
	\renewcommand{\added}[2][\@empty]{%
	\ifmmode\@added[#1]{\ensuremath{#2}}\else\@added[#1]{#2}\fi
	\stepcounter{JCB@Changes@total}
	}

	\NewCommandCopy{\@deleted}{\deleted}
	\renewcommand{\deleted}[2][\@empty]{%
	\ifmmode%
	\@deleted[#1]{\ensuremath{#2}}%
	\else%
	\@deleted[#1]{#2}%
	\fi%
	}

	\NewCommandCopy{\@replaced}{\replaced}
	\renewcommand{\replaced}[3][\@empty]{%
	\ifmmode%
	\@replaced[#1]{\ensuremath{#2}}{\ensuremath{#3}}%
	\else%
	\@replaced[#1]{#2}{#3}%
	\fi%
	}
}{
	\renewcommand{\added}[2][\@empty]{#2}
	\renewcommand{\deleted}[2][\@empty]{}
	\renewcommand{\replaced}[3][\@empty]{#2}
}

\definecolor{addedGreen}{RGB}{41, 163, 47}
\setaddedmarkup{{\color{addedGreen} #1}}

\let\@listofchanges\listofchanges

\newcommand{\@nocontentsline}[3]{}
\newcommand{\tocless}[2]{\bgroup\let\addcontentsline=\@nocontentsline#1{#2}\egroup}

\newcommand{\toclesssection}[1]{\tocless{\section*}{#1}}

\renewcommand{\listofchanges}{\tocless\protect\@listofchanges\clearpage}

\usepackage[most]{tcolorbox}
\tcbset{shield externalize}
\definecolor{@quote}{RGB}{30,100,200}

\newenvironment{quote_report}{\begin{quote}}{\end{quote}}
\tcolorboxenvironment{quote_report}{blanker,
	before skip=6pt,after skip=6pt,left skip=3em,
	borderline west={2pt}{0pt}{@quote}}


\ifbool{JCB@refereeresponse}{
	\def\changes@title@produce{%
		\begingroup
		\frontmatter@title@above
		\frontmatter@title@format
		Response:
		\@title
		\unskip
		\phantomsection\expandafter\@argswap@val\expandafter{\@title}{\addcontentsline{toc}{title}}%
		\@ifx{\@title@aux\@title@aux@cleared}{}{%
			\expandafter\frontmatter@footnote\expandafter{\@title@aux}%
		}%
		\par
		\frontmatter@title@below
		\endgroup
	}%

	\def\frontmatter@title@produce{%
		\include{\responseloc}
		\begingroup
		\frontmatter@title@above
		\frontmatter@title@format
		Changes:
		\@title
		\unskip
		\phantomsection\expandafter\@argswap@val\expandafter{\@title}{\addcontentsline{toc}{title}}%
		\@ifx{\@title@aux\@title@aux@cleared}{}{%
			\expandafter\frontmatter@footnote\expandafter{\@title@aux}%
		}%
		\par
		\frontmatter@title@below
		\endgroup
	}%

	% \def\changes@author@produce@group{%
	% 	\begingroup
	% 	\let\@author@present\@author@present@group
	% 	\frontmatter@authorformat
	% 	\let\AU@temp\@empty
	% 	\set@listcomma@list\AU@temp
	% 	\let\AFG@opr \affils@present@group
	% 	\@AFG@list
	% 	\par
	% 	\endgroup
	% 	\frontmatter@authorbelow
	% }%

	\def\changes@author@present@script#1#2#3{%
		\begingroup
		% \doauthor{#2}{}{}%
		\endgroup
		\advance\@tempcnta\m@ne
	}%

	\def\changes@author@produce@nogroup{%
		\begingroup
			\let\changes@author@present\changes@author@present@script
			\let\AU@temp\@empty
			\@tempcnta\z@
			\let\AF@opr \@gobble
			\def\AU@opr{\@author@count\@tempcnta}%
			\def\CO@opr{\@collaboration@count\AU@temp\@tempcnta}%
			\@AAC@list
			\expandafter\CO@opr\@author@cleared
			\begingroup
			\frontmatter@authorformat
			\let\AU@opr \changes@author@present
			\set@listcomma@list\AU@temp
			\@AAC@list
			\unskip\unskip
			\par
			\endgroup
		\endgroup
	}%

	
	\def\responsetitleblock@produce{%
		\begingroup
		\ltx@footnote@pop
		\def\@mpfn{mpfootnote}%
		\def\thempfn{\thempfootnote}%
		\c@mpfootnote\z@
		\let\@makefnmark\frontmatter@makefnmark
		\frontmatter@setup
		\changes@title@produce
		\groupauthors@sw{%
			\changes@author@produce@group
		}{
			\changes@author@produce@nogroup
		}%
		\frontmatter@RRAPformat{%
			\expandafter\produce@RRAP\expandafter{\@date}
		}%
		\par
		\frontmatter@finalspace
		
		\endgroup
	}%
	
	\def\changesmaketitle{
		\@author@finish
		\title@column\responsetitleblock@produce
		\suppressfloats[t]
	}

	\renewenvironment{response}{%
		\thispagestyle{empty}
		\pagenumbering{roman}
		\changesmaketitle
		\vspace{-5mm}
		%
		\noindent\hspace*{\fill}\rule{.75\textwidth}{.5pt}\hspace*{\fill}\\

		\vspace*{5mm}
	}{%
	\newpage\newpage
	\ifnumgreater{\totvalue{JCB@Changes@total}}{0}{\listofchanges}{\typeout{No changes to list}}
	\newpage\newpage
	\pagenumbering{arabic}
	\setcounter{page}{1}
	}

	\newcommand{\nicerule}{%
		\vspace{5mm}%
		\noindent\hfill\rule{.75\textwidth}{.5pt}\hfill%
		\vspace{5mm}%
	}
}

\makeatother

\makeatletter
\renewrobustcmd{\Changes@output}[7]{%
	\ifbool{JCB@refereeresponse}%
	{%
		\Changes@check@author{#2}%
		\Changes@set@color{#2}%
		{%
			\IfIsInList{#1}{added|deleted|replaced|highlight}%
			{%
				\IfIsEmpty{#5}%
				{%
					\IfIsAuthorEmptyAtPosition{#2}{left}%
					{}%
					{{%
							\IfIsColored%
							{\color{authorcolor}}%
							{}%
							\Changes@Markup@author{\Changes@output@author@position{#2}{left}}%
					}}%
				}{}%
				{%
					\IfStrEq{#1}{highlight}%
					{}{%
						\IfIsColored%
						{\color{authorcolor}}%
						{}%
					}%
					\IfStrEq{#1}{added}{\Changes@Markup@added{#3}}{}%
					\IfStrEq{#1}{deleted}{\Changes@Markup@deleted{#4}}{}%
					\IfStrEq{#1}{replaced}{%
						{\Changes@Markup@added{#3}}
						\allowbreak%
						\Changes@Markup@deleted{#4}%
					}{}%
					\IfStrEq{#1}{highlight}{\Changes@Markup@highlight{#3}}{}%
				}%
				\IfIsEmpty{#5}%
				{%
					\IfIsAuthorEmptyAtPosition{#2}{right}%
					{}%
					{{%
							\IfIsColored%
							{\color{authorcolor}}%
							{}%
							\Changes@Markup@author{\Changes@output@author@position{#2}{right}}%
					}}%
				}{}%
				\stepcounter{Changes@#1Count#2}%
			}{}%
			\IfIsEmpty{#5}%
			{}%
			{%
				\stepcounter{Changes@commentCount#2}%
				\Changes@set@commentcount{#2}%
				\Changes@Markup@comment%
				{#5}%
				{#2}%
				{\Changes@output@author{#2}}%
			}%
		}%
		\IfStrEq{#1}{added}{%
			\IfIsEmpty{\Changes@added@summary}{%
				\def\@outtext{#7}%
			}{%
				\def\@outtext{\Changes@added@summary}%
			}
			\def\@out{\truncate{\Changestruncatewidth}{\@outtext}}}{}
		\IfStrEq{#1}{deleted}{%
			\IfIsEmpty{\Changes@deleted@summary}{%
				\def\@outtext{#7}%
			}{%
				\def\@outtext{\Changes@deleted@summary}%
			}
			\def\@out{\truncate{\Changestruncatewidth}{\@outtext}}}{}
		\IfStrEq{#1}{replaced}{%
			\IfIsEmpty{\Changes@replaced@summary}{%
				\def\@outtext{#7}%
			}{%
			\def\@outtext{\Changes@replaced@summary}%
			}
			\def\@out{\truncate{\Changestruncatewidth}{\@outtext}}}{}
		\IfIsEmpty{#2}%
		{\def\Changes@locid{}}%
		{\def\Changes@locid{~(#2)}}%
		\phantomsection\addcontentsline{\Changes@locextension}{#1}{#6\Changes@locid: \@out}%
	}%
	{%
		\IfIsEmpty{#3}%
		{\@bsphack\@esphack}%
		{#3}%
	}%
}
\makeatother