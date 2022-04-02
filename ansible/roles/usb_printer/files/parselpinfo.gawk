BEGIN {
	FS="="
}

/^Device: / {
	OFS="="
	no_printers++;
	$1="";
	gsub(/^=[ ]+/, "", $0);
	current_printer = $0;
	printers[$0] = ""
	printer_opts[current_printer,"url"] = $0;
}

! /Device: / {
	gsub(/^[ ]+/, "", $2);
	gsub(/^[ ]+/, "", $1);
	gsub(/[ ]*$/, "", $1);
	printer_opts[current_printer,$1] = $2;
}

END {
	i = 0;
	print "[";
	for(printer in printers) {
		i++;
		print "{"
		printf "\t\"uri\": \"%s\",\n", printer_opts[printer,"url"];
		printf "\t\"name\": \"%s\"\n", printer_opts[printer,"info"];
		printf "}";
		if (i != no_printers) {
			print ",";
		}
	}
	print "]";
}
