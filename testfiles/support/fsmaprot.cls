\ProvidesClass{fsmaprot}[2022/02/18 v1.0]

% Mit numbers=noenddot wird kein "." am Ende der Gliederungsnummern gesetzt,
% was hier gewünscht ist, da der Anhang nicht gemeinsam mit der Tagesordnung
% in einer Gliederung steht.
\LoadClass[parskip=half,numbers=noenddot,a4paper]{scrartcl}

\RequirePackage[ngerman]{babel}
\RequirePackage[style=fsma]{prot}

%%% Titel + Versionierung
% Der Titel wird automatisch durch den mit \sitzungsdaten angegebenen Typ gesetzt
\RequirePackage{expl3}
\RequirePackage{xspace}
\ExplSyntaxOn

\RequirePackage[ngerman]{isodate}
\daymonthsepgerman{}\monthyearsepgerman{}{}%no spacing in date

\keys_define:nn { prot / options } {
	, typ .choice:
	, typ / fsr .meta:n = { titel = Fachschaftsratsitzung }
	, typ / vv .meta:n = { titel = Vollversammlung }
	, typ / konsti .meta:n = { titel = Konstituierende~Sitzung }
	, typ / semikonsti .meta:n = { titel = Semikonstituierende~Sitzung }
	, typ .default:n = { fsr }
}

\subject { \Vorlaeufiges Protokoll }
\title { \sTitel }
\subtitle { der~Fachschaft~Mathematik }


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
	\MakeProtokollSignatur\clearpage
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


%%% Titelseite
\titlehead {
	Technische Universität Kaiserslautern
	\\ Fachschaft Mathematik
	% \\ { \centering \includegraphics[scale=0.4]{Leo.png} }
}
\RequirePackage{graphicx}%required for \includegraphics
\AtBeginDocument {
	\nolinenumbers
	\maketitle
	\anwesenheitsliste
	\einschub {
		In diesem Protokoll werden Abstimmungsergebnisse in der Form (ja\,/\,nein\,/\,Ent\-hal\-tung\-en)
		und Wahlergebnisse in der Form (ja\,/\,nein) angegeben.
	}
}
