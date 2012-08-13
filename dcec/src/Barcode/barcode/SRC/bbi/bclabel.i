/*¡„º˛±Í«©¥Ú”°*/
/*DEF VAR printertype AS CHAR.
ASSIGN printertype = {1}.*/
FIND FIRST b_ct_ctrl NO-LOCK NO-ERROR.
CASE {1}:
   WHEN "IPL" THEN DO:
      PUT "<STX><ESC>C0<ETX>" SKIP.
      PUT "<STX><ESC>P;<ETX>" SKIP.
      PUT "<STX>E4;F4,DEMO 4;<ETX>" SKIP.
      PUT "<STX>B1;o0,655;f1;h80;w2;c0,0;i1;r1;d0,18;<ETX>" SKIP.
      PUT "<STX>H2;o100,650;f1;h1;w1;c20;r0;b0;d0,18;<ETX>" SKIP.
      PUT "<STX>H3;o120,650;f1;h1;w1;c21;r0;b0;d0,18;<ETX>" SKIP.
      PUT "<STX>H4;o170,650;f1;h1;w1;c20;r0;b0;d0,28;<ETX>" SKIP.
      PUT "<STX>H5;o190,650;f1;h1;w1;c21;r0;b0;d0,28;<ETX>" SKIP.
      PUT "<STX>H6;o100,270;f1;h1;w1;c20;r0;b0;d0,28;<ETX>" SKIP.
      PUT "<STX>H7;o120,270;f1;h1;w1;c21;r0;b0;d0,28;<ETX>" SKIP.
      PUT "<STX>H8;o170,270;f1;h1;w1;c20;r0;b0;d0,28;<ETX>" SKIP.
      PUT "<STX>H9;o190,270;f1;h1;w1;c21;r0;b0;d0,28;<ETX>" SKIP.
      PUT "<STX>H10;o50,700;f4;h1;w1;c21;r0;b0;d0,28;<ETX>" SKIP.
/*
      PUT "<STX>L12;o240,650;f1;l650;w4;<ETX>" SKIP.
*/  IF {2} = 'part' THEN DO:
      PUT "<STX>R<ETX>" SKIP.
      PUT "<STX><ESC>E4<CAN><ETX>" SKIP.
      PUT "<STX><ESC>F1<LF>" {3} "<ETX>" SKIP.
      PUT "<STX><ESC>F2<LF>PART NO.<ETX>"  SKIP.
      PUT "<STX><ESC>F3<LF>" {4} "<ETX>"  SKIP.
      PUT "<STX><ESC>F4<LF>LOT/SERIAL NO.<ETX>"  SKIP.
      PUT "<STX><ESC>F5<LF>" {5} "<ETX>" SKIP.
       PUT "<STX><ESC>F4<LF>REF NO.<ETX>"  SKIP.
      PUT "<STX><ESC>F5<LF>" {6} "<ETX>" SKIP.
      PUT "<STX><ESC>F8<LF>QUANTITY.<ETX>" SKIP.
      PUT "<STX><ESC>F9<LF>" TRIM(STRING({7},">>>>>>9.9<<<<<<")) "<ETX>" SKIP.
     PUT "<STX><ESC>F10<LF>" b_ct_comp "<ETX>" SKIP.
      PUT "<STX><ETB><FF><ETX>" SKIP.
END.
ELSE DO:
 PUT "<STX>R<ETX>" SKIP.
      PUT "<STX><ESC>E4<CAN><ETX>" SKIP.
      PUT "<STX><ESC>F1<LF>" {3} "<ETX>" SKIP.
      PUT "<STX><ESC>F2<LF>Site <ETX>"  SKIP.
      PUT "<STX><ESC>F3<LF>" {4} "<ETX>"  SKIP.
      PUT "<STX><ESC>F4<LF>Location <ETX>"  SKIP.
      PUT "<STX><ESC>F5<LF>" {5} "<ETX>" SKIP.
      PUT "<STX><ETB><FF><ETX>" SKIP.


END.
   END.
   WHEN "ZPL" THEN DO:
       IF {2} = 'part' THEN DO:
       
       PUT "^XA" SKIP.
      PUT "^FO10,370^GB600,0,3^FS" SKIP.
      PUT "^FO10,40^BY2^BCN,70,Y,N,N^AD^FD" {3} "^FS" SKIP.
      PUT "^FO10,170^AD^FDPART NO.^FS" SKIP.
      PUT "^FO10,190^AE^FD" {4} "^FS" SKIP.
      PUT "^FO10,240^AD^FDLOT/SERIAL NO.^FS" SKIP.
      PUT "^FO10,260^AE^FD" {5} "^FS" SKIP.
      PUT "^FO10,240^AD^FDREF NO.^FS" SKIP.
      PUT "^FO10,260^AE^FD" {6} "^FS" SKIP.
      PUT "^FO10,310^AD^FDQUANTITY.^FS" SKIP.
      PUT "^FO10,330^AE^FD" TRIM(STRING({7},">>>>>>9.9<<<<<<")) "^FS" SKIP.
      PUT "^FO10,400^AE^FD" b_ct_comp "^FS" SKIP.
     /* PUT "^FO10,400^AD^FDPRINTER TIME:" global_date "^FS" SKIP.
      PUT "^FO300,400^AD^FDPRINTER USER:" global_user "^FS" SKIP.*/
      PUT "^XZ" SKIP.
       END.
       ELSE DO:
    PUT "^XA" SKIP.
      PUT "^FO10,370^GB600,0,3^FS" SKIP.
      PUT "^FO10,40^BY2^BCN,70,Y,N,N^AD^FD" {3} "^FS" SKIP.
      PUT "^FO10,170^AD^FDSite ^FS" SKIP.
      PUT "^FO10,190^AE^FD" {4} "^FS" SKIP.
      PUT "^FO10,240^AD^FDLocation ^FS" SKIP.
      PUT "^FO10,260^AE^FD" {5} "^FS" SKIP.
     /*PUT "^FO10,400^AD^FDPRINTER TIME:" global_date "^FS" SKIP.
      PUT "^FO300,400^AD^FDPRINTER USER:" global_user "^FS" SKIP.*/
      PUT "^XZ" SKIP.


       END.
   END.
END CASE.
