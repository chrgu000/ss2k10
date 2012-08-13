/*零件标签打印*/
/*DEF VAR printertype AS CHAR.
ASSIGN printertype = {1}.*/

FIND FIRST b_usr_mstr WHERE b_usr_usrid = g_user NO-LOCK NO-ERROR.
OUTPUT TO VALUE(b_usr_printer).
CASE {1}:
   WHEN "IPL" THEN DO:
/*MESSAGE {1} VIEW-AS ALERT-BOX.*/
     

      


/*
      PUT "<STX>L12;o240,650;f1;l650;w4;<ETX>" SKIP.
*/  
 IF {2} = 'part' THEN DO:
     PUT 'PRPOS 150,50' SKIP.
     PUT  'bartype "CODE128":barratio 3,1:barheight 80:barmag 2' SKIP.
     PUT  UNFORMAT 'BARFONT "Swiss 721 BT",10,8,5,1,1,100,2 ON:prbar "'{3} '"' SKIP.
     PUT 'PRPPOS 150,180' SKIP.
     PUT 'FT "Swiss 721 BT"' SKIP.
     PUT 'PT "零件号/PART NO"' SKIP.
      PUT 'PRPPOS 150,200' SKIP.
     PUT UNFORMAT 'PT "' {4} '"' SKIP.
      PUT 'PRPPOS 150,230' SKIP.
     PUT 'PT "批/序号/LOT/SERIAL NO."' SKIP.
      PUT 'PRPPOS 150,250' SKIP.
     PUT UNFORMAT 'PT "' {5} '"' SKIP.
      PUT 'PRPPOS 150,280' SKIP.
     PUT 'PT "参考号/REF NO."' SKIP.
      PUT 'PRPPOS 150,300' SKIP.
     PUT UNFORMAT 'PT "' {6} '"' SKIP.
      PUT 'PRPPOS 150,330' SKIP.
     PUT 'PT "数量/QUANTITY"' SKIP.
      PUT 'PRPPOS 150,350' SKIP.
     PUT UNFORMAT 'PT "' TRIM(STRING({7},">>>>>>9.9<<<<<<")) '"' SKIP.
     /* PUT 'PRPPOS 150,400' SKIP.
     PUT UNFORMAT 'PT "' b_ct_comp '"' SKIP.*/
     PUT 'PF' SKIP.
END.
ELSE IF {2} = "split" THEN DO:
       PUT 'PRPOS 150,50' SKIP.
       PUT  'bartype "CODE128":barratio 3,1:barheight 80:barmag 2' SKIP.
       PUT  UNFORMAT 'BARFONT "Swiss 721 BT",10,8,5,1,1,100,2 ON:prbar "'{3} '"' SKIP.
       PUT 'PRPPOS 150,180' SKIP.
       PUT 'FT "Swiss 721 BT"' SKIP.
       PUT 'PT "零件号/PART NO"' SKIP.
       PUT 'PRPPOS 150,200' SKIP.
       PUT UNFORMAT 'PT "' {4} '"' SKIP.
       PUT 'PRPPOS 150,230' SKIP.
       PUT 'PT "批/序号/LOT/SERIAL NO."' SKIP.
       PUT 'PRPPOS 150,250' SKIP.
       PUT UNFORMAT 'PT "' {5} '"' SKIP.
       PUT 'PRPPOS 150,280' SKIP.
       PUT 'PT "参考号/REF NO."' SKIP.
       PUT 'PRPPOS 150,300' SKIP.
       PUT UNFORMAT 'PT "' {6} '"' SKIP.
       PUT 'PRPPOS 150,330' SKIP.
       PUT 'PT "数量/QUANTITY"' SKIP.
       PUT 'PRPPOS 150,350' SKIP.
       PUT UNFORMAT 'PT "' TRIM(STRING({7},">>>>>>9.9<<<<<<")) '"' SKIP.
    /* PUT 'PRPPOS 150,400' SKIP.
    PUT UNFORMAT 'PT "' b_ct_comp '"' SKIP.*/
    PUT 'PF' SKIP.
 END.
 ELSE DO:

 PUT 'PRPOS 150,70' SKIP.
  PUT  'bartype "CODE128":barratio 3,1:barheight 80:barmag 2' SKIP.
 PUT  UNFORMAT 'BARFONT "Swiss 721 BT",10,8,5,1,1,100,2 ON:prbar "' {3} '"' SKIP.
 PUT 'PRPPOS 150,200' SKIP.
 PUT 'FT "Swiss 721 BT"' SKIP.
 PUT 'PT "地点/Site "' SKIP.
  PUT 'PRPPOS 150,220' SKIP.
 PUT UNFORMAT 'PT "' {4} '"' SKIP.
  PUT 'PRPPOS 150,270' SKIP.
 PUT 'PT "库位/Location "' SKIP.
  PUT 'PRPPOS 150,290' SKIP.
 PUT UNFORMAT 'PT "' {5} '"' SKIP.
  
 PUT 'PF' SKIP.

END.
   
 /*OUTPUT CLOSE.
       OS-COMMAND SILENT VALUE("copy C:\bclabel.txt LPT1").*/

END.
   WHEN "ZPL" THEN DO:
    IF {2} = 'part' THEN DO:
      PUT "^XA" SKIP.
      PUT "^FO70,415^GB600,0,3^FS" SKIP.
      PUT "^FO70,20^BY2^B3N,N,100,Y,N^AD^FD" {3} "^FS" SKIP.
      PUT "^FO0770,30^AER,150,50^FDDCEC^FS" SKIP.
      PUT "^FO70,140^AR^FDPART NO.                                     PACKAGE ID. ^FS" SKIP.
      PUT UNFORMAT "^FO70,170^AR^FD" {4} "^FS"  SKIP.
      PUT "^FO520,170^AR^FD" {6} "^FS"  SKIP.
      PUT "^FO70,210^AR^FDLOT/SERIAL NO.                   .^FS" SKIP.
      PUT "^FO70,240^AR^FD" {5} "^FS" SKIP.
      PUT "^FO70,280^AR^FDQUANTITY.                                   SUPPLIER CODE. ^FS" SKIP.
      PUT "^FO70,310^AR^FD" TRIM(STRING({7},">>>>>>9.9<<<<<<")) "^FS" SKIP.
      PUT "^FO520,310^AR^FD" {8} "^FS" SKIP.
     /* PUT "^FO70,350^AR^FDDESCRIPTION.^FS" SKIP.
      PUT "^FO70,380^AR^FD" {8} "^FS" SKIP.*/
      PUT "^FO70,425^AD^FDPRINTER TIME:" TODAY "^FS" SKIP.
      PUT "^FO370,425^AD^FDPRINTER USER:" g_user "^FS" SKIP.

      PUT "^XZ" SKIP.
     END.
     ELSE  IF {2} = 'split' THEN DO:
         PUT "^XA" SKIP.
         PUT "^FO70,565^GB600,0,3^FS" SKIP.

         PUT "^FO200,20^BY2^BCN,100,Y,N,N^AD^FD" {3} "^FS" SKIP.

         PUT "^FO200,300^BY2^BAN,100,Y,N,N^FD" {4} "^FS" SKIP.
         PUT "^FO100,440^BY2^BCN,100,Y,N,N^FD" {7} "^FS" SKIP.
/*
         PUT "^FO70,20^BY2^B3N,N,100,Y,N^AD^FD" {3} "^FS" SKIP.
         PUT "^FO70,160^BY2^B3N,N,100,Y,N^AD^FD" {4} "^FS" SKIP.
         PUT "^FO70,300^BY2^B3N,N,100,Y,N^AD^FD" {5} "^FS" SKIP.
         PUT "^FO70,440^BY2^B3N,N,100,Y,N^AD^FD" {5} "^FS" SKIP.*/

         PUT "^FO70,575^AD^FDPRINTER TIME:" TODAY "^FS" SKIP.
         PUT "^FO370,575^AD^FDPRINTER USER:" g_user "^FS" SKIP.

         PUT "^XZ" SKIP.
          END.

       ELSE DO:
    PUT "^XA" SKIP.

    PUT "^FO80,410^GB600,0,3^FS" SKIP.
    /*          93          PUT "^FO80,40^BY3^BAN,140,Y,N,N^AD^FD" loc_site ","  loc_loc "^FS" SKIP.
              39          PUT "^FO80,40^BY3^B3N,N,140,Y,N^AD^FD" loc_site "++--,,..//"  loc_loc "^FS" SKIP.*/
     /*128*/       PUT "^FO100,10^BY3^BCN,160,Y,N,N^AD^FD" {4} "."  {5} "^FS" SKIP.
              /*          PUT "^FO0770,80^AER,150,50^FDmetso^FS" SKIP.
                        PUT "^FO80,210^AR^FDSITE NO.^FS" SKIP.
                        PUT "^FO80,250^AE^FD" loc_site "^FS" SKIP. */
                /*        PUT "^FO160,260^AE^FDLOCATION NO.^FS" SKIP.*/
                        PUT "^FO170,240^AE,150,50^FD" {5} "^FS" SKIP.
                    /*    PUT "^FO80,430^AR^FDDESCRIPTION. ^FS" SKIP.
                        PUT "^FO80,470^AE^FD" loc_desc "^FS" SKIP.*/
                        PUT "^FO100,425^AD^FDPRINTER TIME:" TODAY "^FS" SKIP.
                        PUT "^FO430,425^AD^FDPRINTER USER:" g_user "^FS" SKIP.



     /* PUT "^FO10,370^GB600,0,3^FS" SKIP.*/
 /*     PUT UNFORMAT "^FO200,100^BY4^B3N,N,100,Y,N^AD^FD" {3} "^FS" SKIP.
      PUT UNFORMAT "^FO200,280^AE^FDSite ^FS" SKIP.
      PUT UNFORMAT "^FO450,280^AE^FD" {4} "^FS" SKIP.
      PUT UNFORMAT "^FO200,350^AD^FDLocation ^FS" SKIP.
      PUT UNFORMAT "^FO450,350^AE^FD" {5} "^FS" SKIP.*/
     /*PUT "^FO10,400^AD^FDPRINTER TIME:" global_date "^FS" SKIP.
      PUT "^FO300,400^AD^FDPRINTER USER:" global_user "^FS" SKIP.*/
      PUT "^XZ" SKIP.
       END.

      /* OUTPUT CLOSE.
      /* OS-COMMAND SILENT VALUE("copy C:\bclabel.txt LPT1").*/*/


   END.
END CASE.
OUTPUT CLOSE.
