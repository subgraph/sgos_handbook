# This script is run after po4a-gettextive to remove any entries that contain
# Markdown or LaTeX directives that should not be translated

BEGIN { 
	RS = "#. type:" ; 
	FS = "\n" ; 
	ORS = "";
}

# This code will retain only the records that do not match the Markdown and 
# LaTeX directives we specify in the regular expressions below

!/msgid "\\\\newpage"/ && \
!/msgid "\\\\clearpage"/ \
{	
	# We print the #. type: row for every record past the first
	if (NR>1) {
		print RS$0
	} else {
		print $0
	}
}

