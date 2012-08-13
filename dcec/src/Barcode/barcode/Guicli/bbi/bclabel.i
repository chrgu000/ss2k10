/*¡„º˛±Í«©¥Ú”°*/
/*DEF VAR printertype AS CHAR.
ASSIGN printertype = {1}.*/

FIND FIRST b_ct_ctrl NO-LOCK NO-ERROR.
CASE {1}:
   WHEN "IPL" THEN DO:

      OUTPUT TO c:\bcLABEL.txt.

      


/*
      PUT "<STX>L12;o240,650;f1;l650;w4;<ETX>" SKIP.
*/  IF {2} = 'part' THEN DO:
     PUT 'PRPOS 320,320' SKIP.
      PUT  'bartype "CODE128":barratio 3,1:barheight 100:barmag 5' SKIP.
     PUT  UNFORMAT 'BARFONT "Swiss 721 BT",10,8,5,1,1,100,2 ON:prbar "'{3} '"' SKIP.
     PUT 'PRPOS 320,240' SKIP.
     PUT 'FT "Swiss 721 BT"' SKIP.
     PUT 'PT "PART NO"' SKIP.
      PUT 'PRPOS 570,240' SKIP.
     PUT UNFORMAT 'PT "' {4} '"' SKIP.
      PUT 'PRPOS 320,180' SKIP.
     PUT 'PT "LOT/SERIAL NO."' SKIP.
      PUT 'PRPOS 700,180' SKIP.
     PUT UNFORMAT 'PT "' {5} '"' SKIP.
      PUT 'PRPOS 320,120' SKIP.
     PUT 'PT "REF NO."' SKIP.
      PUT 'PRPOS 570,120' SKIP.
     PUT UNFORMAT 'PT "' {6} '"' SKIP.
      PUT 'PRPOS 320,60' SKIP.
     PUT 'PT "QUANTITY"' SKIP.
      PUT 'PRPOS 570,60' SKIP.
     PUT UNFORMAT 'PT "' TRIM(STRING({7},">>>>>>9.9<<<<<<")) '"' SKIP.
      PUT 'PRPOS 800,0' SKIP.
     PUT UNFORMAT 'PT "' b_ct_comp '"' SKIP.
     PUT 'PF' SKIP.

END.
ELSE DO:

 PUT 'PRPOS 320,320' SKIP.
  PUT  'bartype "CODE128":barratio 3,1:barheight 100:barmag 5' SKIP.
 PUT  UNFORMAT 'BARFONT "Swiss 721 BT",10,8,5,1,1,100,2 ON:prbar "' {3} '"' SKIP.
 PUT 'PRPOS 320,240' SKIP.
 PUT 'FT "Swiss 721 BT"' SKIP.
 PUT 'PT "Site "' SKIP.
  PUT 'PRPOS 570,240' SKIP.
 PUT UNFORMAT 'PT "' {4} '"' SKIP.
  PUT 'PRPOS 320,180' SKIP.
 PUT 'PT "Location "' SKIP.
  PUT 'PRPOS 570,180' SKIP.
 PUT UNFORMAT 'PT "' {5} '"' SKIP.
  
 PUT 'PF' SKIP.

END.
   
 OUTPUT CLOSE.
       OS-COMMAND SILENT VALUE("copy C:\bclabel.txt LPT1").

END.
   WHEN "ZPL" THEN DO:

       OUTPUT TO c:\bcLABEL.txt.

       IF {2} = 'part' THEN DO:
       PUT "^XA" SKIP.
     /* PUT "^FO10,370^GB600,0,3^FS" SKIP.*/
      PUT UNFORMAT "^FO200,100^BY3^B3N,N,100,Y,N^AD^FD" {3} "^FS" SKIP.
      PUT UNFORMAT "^FO200,280^AE^FDPART NO.^FS" SKIP.
      PUT UNFORMAT "^FO450,280^AE^FD" {4} "^FS" SKIP.
      PUT UNFORMAT "^FO200,350^AE^FDLOT/SERIAL NO.^FS" SKIP.
      PUT UNFORMAT "^FO580,350^AE^FD" {5} "^FS" SKIP.
      PUT UNFORMAT "^FO200,420^AE^FDREF NO.^FS" SKIP.
      PUT UNFORMAT "^FO450,420^AE^FD" {6} "^FS" SKIP.
      PUT UNFORMAT "^FO200,490^AE^FDQUANTITY^FS" SKIP.
      PUT UNFORMAT "^FO450,490^AE^FD" TRIM(STRING({7},">>>>>>9.9<<<<<<")) "^FS" SKIP.
      PUT UNFORMAT "^FO485,580^AE^FD" b_ct_comp "^FS" SKIP.
     /* PUT "^FO10,400^AD^FDPRINTER TIME:" global_date "^FS" SKIP.
      PUT "^FO300,400^AD^FDPRINTER USER:" global_user "^FS" SKIP.*/
      PUT "^XZ" SKIP.
       END.
       ELSE DO:
    PUT "^XA" SKIP.
     /* PUT "^FO10,370^GB600,0,3^FS" SKIP.*/
      PUT UNFORMAT "^FO200,100^BY4^B3N,N,100,Y,N^AD^FD" {3} "^FS" SKIP.
      PUT UNFORMAT "^FO200,280^AE^FDSite ^FS" SKIP.
      PUT UNFORMAT "^FO450,280^AE^FD" {4} "^FS" SKIP.
      PUT UNFORMAT "^FO200,350^AD^FDLocation ^FS" SKIP.
      PUT UNFORMAT "^FO450,350^AE^FD" {5} "^FS" SKIP.
     /*PUT "^FO10,400^AD^FDPRINTER TIME:" global_date "^FS" SKIP.
      PUT "^FO300,400^AD^FDPRINTER USER:" global_user "^FS" SKIP.*/
      PUT "^XZ" SKIP.
       END.

       OUTPUT CLOSE.
       OS-COMMAND SILENT VALUE("copy C:\bclabel.txt LPT1").

   END.
END CASE.
