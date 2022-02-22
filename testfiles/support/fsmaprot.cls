\ProvidesClass{fsmaprot}[2022/02/18 v1.0]

\RequirePackage[ngerman]{babel}
\RequirePackage[style=fsma]{prot}

% Mit numbers=noenddot wird kein "." am Ende der Gliederungsnummern gesetzt,
% was hier gewünscht ist, da der Anhang nicht gemeinsam mit der Tagesordnung
% in einer Gliederung steht.
\LoadClass[parskip=half,numbers=noenddot,a4paper,12pt]{scrartcl}

%%% Titel + Versionierung
% Der Titel wird automatisch durch den mit \sitzungsdaten angegebenen Typ gesetzt
\RequirePackage{expl3}
\RequirePackage{xspace}
\ExplSyntaxOn

\RequirePackage[ngerman]{isodate}
\daymonthsepgerman{}\monthyearsepgerman{}{}%no spacing in date

\keys_define:nn { prot / options } {
		, short .tl_set:N = \l@@_title_short_tl
		, long .tl_set:N = \l@@_title_long_tl
		, prefix .tl_set:N = \l@@_title_prefix_tl
		, typ .choice:
		, typ / fsr .meta:n = {
			short = { Fachschaftsratsitzung }, long = { Fachschaftsratsitzung~der~Fachschaft~Mathematik }
		}
		, typ / vv .meta:n = {
			short = { Vollversammlung }, long = { Vollversammlung~der~Fachschaft~Mathematik }
		}
		, typ / konsti .meta:n = {
			short = { konstituierenden~Sitzung}, long = { konstituierenden~Sitzung~der~Fachschaft~Mathematik }
		}
		, typ / semikonsti .meta:n = {
			short = { semikonstituierenden~Sitzung }, long = { semikonstituierenden~Sitzung~der~Fachschaft~Mathematik }
		}
		, typ .default:n = { fsr }
		, version .choice:
		, version / vorlaeufig .meta:n = { prefix = { Vorläufiges~ }, versionierung = \c_true_bool }
		, version / forlaeufig .meta:n = { prefix = { Vorläufiges~vorläufiges~ }, versionierung = \c_true_bool }
		, version / final .meta:n = { versionierung = \c_false_bool }
		, version .default:n = { final }
		, versionierung .code:n = {
			\bool_if:nTF { #1 } {
				%% vorläufig
				\RequirePackage{xcolor}%Farbe
				\RequirePackage{lineno}%Zeilennummern
				\RequirePackage{soulutf8}%Durchstreichungen
			
				\NewDocumentCommand \todo { m } {
					\PackageWarning{fsmaprot}{TODO:~##1} \hl{TODO:~##1}
				}
				\NewDocumentCommand \change { m } { \textcolor{red} ##1 }
				\NewDocumentCommand \del { m } { \textcolor{red} \st{##1} }

				%line numbers
				%enable line numbers
				\definecolor{gray}{gray}{0.5}
				\renewcommand\linenumberfont{\normalfont\tiny\sffamily\textcolor{gray}}
				\linenumbers
				%disable line numbers at appendix
				\let\versioning@appendix\appendix
				\renewcommand\appendix{
					\nolinenumbers
					\versioning@appendix
				}
			} {
				%% fertig
				\NewDocumentCommand \todo { m } {
					\PackageError{fsmaprot}{TODO:~##1}{Du~hast~offenbar~noch~irgendetwas~zu~tun.}
				}
				\NewDocumentCommand \change { m } { ##1 }
				\NewDocumentCommand \del { m } { }
			}
		}
}
\cs_new_protected_nopar:Nn \prot_preview_title: {
	\tl_use:N { \l@@_title_prefix_tl } Protokoll
}

\NewDocumentCommand \pdftitle {} {
	\numdate% set date format
	\prot_preview_title:{} ~der~\tl_use:N { \l@@_title_short_tl }~am~\printdate{\tl_use:N { \l_prot_meeting_datum_tl }}
}
\NewDocumentCommand \pdfsubject {} {
	\origdate% set date format
	\prot_preview_title:{} ~der~\tl_use:N { \l@@_title_long_tl }~der~Technischen~Universität~Kaiserslautern~am~\printdate{\tl_use:N { \l_prot_meeting_datum_tl }}
}
\NewDocumentCommand \heading {} {
	\prot_preview_title:{}
}
\NewDocumentCommand \subheading {} {
	\origdate% set date format
	der~\tl_use:N { \l@@_title_short_tl }~am~\printdate{\tl_use:N { \l_prot_meeting_datum_tl }}
}

\ExplSyntaxOff

%%% Stil
\pagestyle{plain}
\setlength\parindent{0pt}
% make everything smaller
\renewcommand*\size@section{\large}
\renewcommand*\size@subsection{\normalsize}
\renewcommand\@dotsep{1000}
\RedeclareSectionCommand[beforeskip=.5\baselineskip,afterskip=-1em]{paragraph}
\RedeclareSectionCommand[beforeskip=1\baselineskip,afterskip=.5\baselineskip]{section}
\RedeclareSectionCommand[beforeskip=.75\baselineskip,afterskip=.25\baselineskip]{subsection}

%%% table of contents

\RequirePackage{hyperref}%required for autorefnames
\RequirePackage{bookmark}%fix for bookmark level gap

% prepend „TOP“ to sections and subsections
\let\prot@@seccntformat\@seccntformat
\renewcommand\@seccntformat{TOP \prot@@seccntformat}
\renewcommand\sectionautorefname{TOP}
\renewcommand\subsectionautorefname{TOP}
\renewcommand\subsubsectionautorefname{TOP}

\let\prot@appendix\appendix
\renewcommand\appendix{
	% make signature
	\MakeSignatur\clearpage
	% no longer prepend „TOP“ to sections and subsections
	\let\@seccntformat\prot@@seccntformat
	% hide appendix sections from table of contents
	\let\appendixtoc\relax
	\addtocontents{toc}{\appendixtoc}
	%
	\prot@appendix
}
\def\appendixtoc{\def\contentsline{\@gobblefour}}%unterdrückt weitere Punkte in \tableofcontents, sobald dies aufgerufen wird, wird in \Tagesordnung überschrieben.


% explain footnotes at their origin and hide them from the table of contents
\let\prot@addcontentsline\addcontentsline
\renewcommand\addcontentsline[3]{
		\let\prot@footnote\footnote
		\def\footnote##1{}
		\prot@addcontentsline{#1}{#2}{#3}
		\let\footnote\prot@footnote
}

% hide page numbers in table of contents
\DeclareTOCStyleEntry[pagenumberbox=\@gobble]{tocline}{section}
\DeclareTOCStyleEntry[pagenumberbox=\@gobble]{tocline}{subsection}

% hide „Contents“ title from table of contents
\renewcommand\tocbasic@listhead[1]{}


%%% Anfang
\RequirePackage{graphicx}%required for \includegraphics
\AtBeginDocument{
	% PDF-Metadaten
	\hypersetup{
		% FIXME: arguments are not expanded?!
	    , pdftitle = \pdftitle
		, pdfsubject = \pdfsubject
		, pdfauthor = \protokollfuehrung
	}
	% Titel
	\begin{flushleft}
		Technische Universität Kaiserslautern\\
		Fachschaft Mathematik
	\end{flushleft}
	\begin{center}
		%\includegraphics[scale=0.4]{Leo.png}\\%Bild von Leo
		\vspace{1em}
		\begin{Large}
			\textbf{\heading}
		\end{Large}\\
		\begin{large}
			\subheading
		\end{large}
	\end{center}
	\vspace{1em}
	% Sitzungsdaten
	\begin{description}
		\renewcommand\descriptionlabel{\hspace\labelsep\bfseries}
		\itemsep-0.2em
		\item[Dauer] \sStart bis \sEnde
	\end{description}
	\anwesenheitsliste{}
	% Anfangshinweise
	\emph{%
		In diesem Protokoll werden Abstimmungsergebnisse in der Form (ja\,/\,nein\,/\,Ent\-hal\-tung\-en)
		und Wahlergebnisse in der Form (ja\,/\,nein) angegeben.
	}
}

%%%Ende
%%Signatur
\RequirePackage{tabularx}%tables with equally spaced columns
\newcommand\EndSignatur{
	\begin{figure}[b]
		Kaiserslautern, \@date \vspace{2em}

		\begin{tabularx}{\linewidth}{@{}XX@{}}%@{} suppresses the space between columns
			\hrule&\hrule\\%
			\protokollfuehrung{}&\sitzungsfuehrung{}\\%
			Protokoll&Sitzungsleitung%
		\end{tabularx}
	\end{figure}
}

\newcommand\MakeSignatur{%create signatur only at first occurence
	\EndSignatur
	\renewcommand\MakeSignatur{}
}

\AtEndDocument{
	\MakeSignatur
}

%%% Einschübe
% Einschübe werden so gesetzt, dass sie Listeneinzüge und möglichst auch vertikale Abstände ignorieren; insbesondere sollte es egal sein, ob ein Einschub am Anfang einer oder direkt vor einer Liste auftaucht, selbiges für das Listenende
\newlength\einschub@vspace
\newlength\einschub@parindent
\newlength\einschub@parskip
\newif\ifeinschub@auslist
\newcommand\einschub[5]{\Einschub{#1#2:#3#4~Uhr: #5}}
\newcommand\pause[2]{\einschub@split#1-#2-{Sitzungspause}}
\def\einschub@split#1#2#3#4-#5#6#7#8-#9{\Einschub{#1#2:#3#4~Uhr -- #5#6:#7#8~Uhr: #9}}
\newcommand\Einschub[1]{%\vskip is a TeX primitive and can collapse, \vspace not
	\par
	%% Setzt vertikale Abstände in und nach Listen passend, wenn parskip=0 ist
	\setlength\einschub@parindent\parindent % save it
	\setlength\parindent{-\@totalleftmargin}%
	\setlength\einschub@vspace\topsep
	\addtolength\einschub@vspace\partopsep
	\einschub@auslistfalse
	\ifnum\lastskip=\einschub@vspace
		% Wenn direkt vor dem Einschub eine Liste aufgehört hat,
		% setze Abstände wie für einen Listenpunkt
		\einschub@auslisttrue
		\setlength\einschub@vspace{-\einschub@vspace}%
		\addtolength\einschub@vspace\itemsep
		\addvspace\einschub@vspace
	\else
		\ifnum\lastskip=\z@skip
		\else
			\vskip\itemsep
		\fi
	\fi
	\emph{#1}%
	\setlength\parindent\einschub@parindent
	\setlength\einschub@vspace{0pt}%
	\ifeinschub@auslist
		\setlength\einschub@vspace\itemsep
		\vskip0pt%
	\fi\par
	\addvspace\einschub@vspace
}

%%% Personen kommen und gehen
% wrappers around \peoplemove, ..., \peoplemovetext, ...
\newcommand\kommt[5]{
	\peopleenter{#5}
	\einschub{#1}{#2}{#3}{#4}{\peopleentertext{#5}}
}
\newcommand\geht[5]{
	\peopleleave{#5}
	\einschub{#1}{#2}{#3}{#4}{\peopleleavetext{#5}}
}
\newcommand\kommtgeht[6]{
	\peoplemove{#5}{#6}
	\einschub{#1}{#2}{#3}{#4}{\peoplemovetext{#5}{#6}}
}
\let\kommtstill\peopleenter
\let\gehtstill\peopleleave
\let\kommtgehtstill\peoplemove
