\RequirePackage {expl3}
\ProvidesExplClass {fsmaprot} {2022-03-26} {1.0} {Fachschaftsprotokolle}

\LoadClass { scrartcl }

\RequirePackage [ ngerman ] { babel }
\RequirePackage { microtype }
\RequirePackage [
	, style = fsma
	, autosignatur
] { prot }

%%% Titel + Versionierung
% Der Titel wird automatisch durch den mit \sitzungsdaten angegebenen Typ gesetzt

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

%%% Titelseite
\titlehead {
	Technische~Universität~Kaiserslautern
	\\~Fachschaft~Mathematik
	\begin{center} \includegraphics [ height = 2 cm ]{ example-image-1x1.png } \end{center}
}
\AddToHook { begindocument / end } {
	\maketitle
	\linenumbers
	\anwesenheitsliste
	% Die \hspace{...} erlauben im Gegensatz zu \, einen Zeilenumbruch.
	\einschub {
		In~diesem~Protokoll~werden~Abstimmungsergebnisse~in~der~Form~
		(ja \,/\hspace{.16667em} nein \,/\hspace{.16667em} Enthaltungen) ~
		und~Wahlergebnisse~in~der~Form~(ja\,/\,nein)~angegeben.
	}
}

\cs_set_eq:NN \ergwahl \janein
\cs_set_eq:NN \Ergwahl \Janein

%%% So genannter Stil
% Hier sorgen wir a) für Abstand zwischen Absätzen und verringern zugleich
% b) den Abstand zu Überschriften und deren Größe. Warum wir dies tun, kann ich
% auch nicht sagen.
\KOMAoptions {
	, parskip = half
	, headings = small
}
\RedeclareSectionCommand[beforeskip=-1\baselineskip,afterskip=.5\baselineskip]{section}
\RedeclareSectionCommand[beforeskip=-.75\baselineskip,afterskip=.25\baselineskip]{subsection}
\RedeclareSectionCommand[beforeskip=-.75\baselineskip,afterskip=.25\baselineskip]{subsubsection}
\RedeclareSectionCommand[beforeskip=-.5\baselineskip]{paragraph}


%%% Amputiertes Inhaltsverzeichnis

% Unterdrückt Titel
\deftocheading { toc } { }

% Unterdrückt Ausgabe des Anhangs
\cs_set:Npn \appendixtoc { \cs_set:Npn \contentsline { \use_none:nnnn } }

% Unterdrückt Seitenzahl
\DeclareTOCStyleEntries [ pagenumberbox = \use_none:n ] { tocline } { section , subsection , subsubsection }
