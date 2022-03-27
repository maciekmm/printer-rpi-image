BEGIN {
	FS="="
}

/^Device: / {
	no_printers++;
	gsub(/^[ ]+/, "", $2);
	current_printer = $2;
	printers[$2] = ""
	printer_opts[current_printer,"url"] = $2;
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
