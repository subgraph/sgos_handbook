#!/bin/awk -f

BEGIN {
	printf("Syscall(dec)  Syscall(hex)  System Call\n");
	sep = sprintf("%*s",12," ");
	gsub(/ /, "-",sep);
	printf("%s  %s  %s\n", sep, sep, sep)
} 

{
	if ($2 ~ "__NR_") {
		gsub(/__NR_/,"",$2);
		printf ("%-12d  0x%-12x%-12s\n", $3, $3, $2)
	}
}

END {
	print("\n\\newpage")
}
