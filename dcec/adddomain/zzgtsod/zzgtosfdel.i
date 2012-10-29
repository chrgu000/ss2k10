/* This routine removes the file {&filen}. */

IF SEARCH({&filen}) <> ? THEN DO:
  IF      OPSYS = "MSDOS" THEN DOS  SILENT del       VALUE(SEARCH({&filen})).
  ELSE IF OPSYS = "WIN32" then DOS  SILENT del       VALUE(SEARCH({&filen})).   /*LB01*/
  ELSE IF OPSYS = "OS2"   THEN OS2  SILENT del       VALUE(SEARCH({&filen})).
  ELSE IF OPSYS = "UNIX"  THEN UNIX SILENT rm        VALUE(SEARCH({&filen})).
  ELSE IF OPSYS = "VMS"   THEN VMS  SILENT delete    VALUE({&filen} + ";").
  ELSE IF OPSYS = "BTOS"  THEN BTOS SILENT OS-DELETE VALUE({&filen}).
  ELSE MESSAGE "osdelete.i: Unknown Operating System -" OPSYS.
END.
