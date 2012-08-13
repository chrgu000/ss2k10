
/*Áã¼þ±êÇ©´òÓ¡*/
/*DEF VAR printertype AS CHAR.
ASSIGN printertype = {1}.*/
{mfdeclre.i}
DEFINE INPUT PARAMETER pcode LIKE b_co_code.
DEFINE INPUT PARAMETER btype AS CHARACTER. /*btype: DOU: print two barcode in a label, SIN: print single barcode in a label*/
/*DEFINE INPUT PARAMETER ctype AS CHARACTER. */ /*code type: one is "part" the other is " loc"*/
DEFINE INPUT PARAMETER ptype AS CHARACTER.  /*printer type: IPL ZPL*/
DEFINE INPUT PARAMETER rep AS LOGICAL.  /*if yes, means print label secondly or repeatedly,if no, means firstly print label*/

FOR FIRST b_ct_ctrl:
END.

FIND FIRST b_co_mstr NO-LOCK WHERE b_co_code = pcode NO-ERROR.
IF AVAILABLE b_co_mstr THEN DO:
    CASE ptype:
    WHEN "IPL" THEN DO:
        CASE btype:
            WHEN "DOU" THEN DO:
                OUTPUT TO VALUE("c:\" + mfguser).
                     PUT 'PRPOS 150,300' SKIP.
                     PUT  'bartype "CODE128":barratio 4,1:barheight 150:barmag 3' SKIP.
                     PUT  UNFORMAT 'BARFONT "Swiss 721 BT",10,8,5,1,1,100,2 ON:prbar "' b_co_code '"' SKIP.
                     PUT 'PRPOS 150,250' SKIP.
                     PUT 'FT "Swiss 721 BT"' SKIP.
                     /*PUT 'PT "PART NO"' SKIP.
                     PUT 'PRPOS 400,250' SKIP.
                     PUT UNFORMAT 'PT "' b_co_part '"' SKIP.*/
                      PUT UNFORMAT 'PT "' b_co_desc2 '"' SKIP.
                     /*PUT 'PRPOS 150,180' SKIP.
                     PUT 'PT "LOT/SER"' SKIP.
                     PUT 'PRPOS 400,180' SKIP.
                     PUT UNFORMAT 'PT "' b_co_lot '"' SKIP.
                     PUT 'PRPOS 150,50' SKIP.
                     PUT 'PT "REF NO."' SKIP.
                     PUT 'PRPOS 400,50' SKIP.
                     PUT UNFORMAT 'PT "' b_co_ref '"' SKIP.   */
                     PUT 'PRPOS 150,200' SKIP.
                     PUT 'PT "QUANTITY"' SKIP.
                     PUT 'PRPOS 400,200' SKIP.
                     PUT UNFORMAT 'PT "' TRIM(STRING(b_co_qty_cur,">>>>>>9.9<<<<<<")) '"' SKIP.
                     PUT 'PRPOS 150,0' SKIP.
                     PUT  'bartype "CODE128":barratio 4,1:barheight 150:barmag 3' SKIP.
                     PUT  UNFORMAT 'BARFONT "Swiss 721 BT",10,8,5,1,1,100,2 ON:prbar "' b_co_vcode '"' SKIP.
                     PUT 'PF' SKIP.
                OUTPUT CLOSE.
                OS-COMMAND SILENT VALUE("copy" + " c:\" + mfguser +  " LPT1").
            END. /*when dou*/
            WHEN "SIN" THEN DO:
                OUTPUT TO VALUE("c:\" + mfguser).
                     PUT 'PRPOS 150,80' SKIP.
                     PUT  'bartype "CODE128":barratio 4,1:barheight 150:barmag 3' SKIP.
                     PUT  UNFORMAT 'BARFONT "Swiss 721 BT",10,8,5,1,1,100,2 ON:prbar "' b_co_code '"' SKIP.
                     PUT 'PRPOS 150,10' SKIP.
                     PUT 'FT "Swiss 721 BT"' SKIP.
                     PUT 'PT "PART NO"' SKIP.
                     PUT 'PRPOS 400,10' SKIP.
                     PUT UNFORMAT 'PT "' b_co_part '"' SKIP.
                     /*PUT 'PRPOS 150,100' SKIP.
                     PUT 'PT "LOT/SER"' SKIP.
                     PUT 'PRPOS 400,100' SKIP.
                     PUT UNFORMAT 'PT "' b_co_lot '"' SKIP.
                     PUT 'PRPOS 150,50' SKIP.
                     PUT 'PT "REF NO."' SKIP.
                     PUT 'PRPOS 400,50' SKIP.
                     PUT UNFORMAT 'PT "' b_co_ref '"' SKIP.
                     PUT 'PRPOS 150,0' SKIP.
                     PUT 'PT "QUANTITY"' SKIP.
                     PUT 'PRPOS 400,0' SKIP.
                     PUT UNFORMAT 'PT "' TRIM(STRING(b_co_qty_cur,">>>>>>9.9<<<<<<")) '"' SKIP.
                     PUT 'PRPPOS 150,-50' SKIP.
                     PUT 'pt "*REPEAT*"' SKIP.*/
                     PUT 'PF' SKIP.
                OUTPUT CLOSE.
                OS-COMMAND SILENT VALUE("copy" +  " c:\" + mfguser  +  " LPT1").
            END.  /*when sin*/
            WHEN "FUL" THEN DO:
                OUTPUT TO VALUE("c:\" + mfguser).
                     PUT 'PRPOS 150,300' SKIP.
                     PUT  'bartype "CODE128":barratio 4,1:barheight 150:barmag 3' SKIP.
                     PUT  UNFORMAT 'BARFONT "Swiss 721 BT",10,8,5,1,1,100,2 ON:prbar "' b_co_code '"' SKIP.
                     PUT 'PRPOS 150,250' SKIP.
                     PUT 'FT "Swiss 721 BT"' SKIP.
                     PUT 'PT "PART NO"' SKIP.
                     PUT 'PRPOS 400,250' SKIP.
                     PUT UNFORMAT 'PT "' b_co_part '"' SKIP.
                     /*PUT 'PRPOS 150,200' SKIP.
                     PUT 'PT "DESC2"' SKIP.*/
                     PUT 'PRPOS 150,200' SKIP.
                     PUT UNFORMAT 'PT "' b_co_desc2 '"' SKIP.
                     PUT 'PRPOS 150,150' SKIP.
                     PUT 'PT "DATE."' SKIP.
                     PUT 'PRPOS 400,150' SKIP.
                     PUT UNFORMAT 'PT "' b_co_wodate '"' SKIP.
                     PUT 'PRPOS 150,100' SKIP.
                     PUT 'PT "SHIFT NO."' SKIP.
                     PUT 'PRPOS 400,100' SKIP.
                     PUT UNFORMAT 'PT "' b_co_shift '"' SKIP.
                     PUT 'PRPOS 150,50' SKIP.
                     PUT 'PT "LOT/SER"' SKIP.
                     PUT 'PRPOS 400,50' SKIP.
                     PUT UNFORMAT 'PT "' b_co_lot '"' SKIP.
                     PUT 'PRPOS 150,0' SKIP.
                     PUT 'PT "QUANTITY"' SKIP.
                     PUT 'PRPOS 400,0' SKIP.
                     PUT UNFORMAT 'PT "' TRIM(STRING(b_co_qty_cur,">>>>>>9.9<<<<<<")) '"' SKIP.
                     PUT 'PF' SKIP.
                OUTPUT CLOSE.
                OS-COMMAND SILENT VALUE("copy" +  " c:\" + mfguser  +  " LPT1").
            END. /*when dou*/
        END CASE.  /*case btype*/
    END.  /*when printer is IPL*/


    WHEN "ZPL" THEN DO:
        CASE btype:
            WHEN "DOU" THEN DO:
                OUTPUT TO value("c:\" + mfguser).
                     PUT "^XA" SKIP.
                     PUT UNFORMAT "^FO50,50^BY2,3,10^BCN,150,Y,N,N^AD^FD" b_co_code "^FS" SKIP.
                     PUT UNFORMAT "^FO50,250^AE^FDPART NO.^FS" SKIP.
                     PUT UNFORMAT "^FO250,250^AE^FD" b_co_part "^FS" SKIP.
                     PUT UNFORMAT "^FO50,300^AE^FDLOT/SER.^FS" SKIP.
                     PUT UNFORMAT "^FO250,300^AE^FD" b_co_lot "^FS" SKIP.
                     PUT UNFORMAT "^FO50,350^AE^FDREF NO.^FS" SKIP.
                     PUT UNFORMAT "^FO250,350^AE^FD" b_co_ref "^FS" SKIP.
                     PUT UNFORMAT "^FO50,400^AE^FDQUANTITY^FS" SKIP.
                     PUT UNFORMAT "^FO250,400^AE^FD" TRIM(STRING(b_co_qty_cur,">>>>>>9.9<<<<<<")) "^FS" SKIP.
                     PUT UNFORMAT "^FO50,450^BY2,3,10^BCN,150,Y,N,N^AD^FD" b_co_vcode "^FS" SKIP.
                     /*PUT UNFORMAT "^FO50,580^AE^FD" b_ct_comp "^FS" SKIP.*/
               /* PUT "^FO10,400^AD^FDPRINTER TIME:" global_date "^FS" SKIP.
                PUT "^FO300,400^AD^FDPRINTER USER:" global_user "^FS" SKIP.*/
                     PUT "^XZ" SKIP.
                OUTPUT CLOSE.
                OS-COMMAND SILENT VALUE("copy" +  " c:\" + mfguser  +  " LPT1").
            END.  /*when dou*/
            WHEN "SIN" THEN DO:
                OUTPUT TO VALUE("c:\" + mfguser).
                     PUT "^XA" SKIP.
                     PUT UNFORMAT "^FO50,50^BY2,3,10^BCN,200,Y,N,N^AD^FD" b_co_code "^FS" SKIP.
                     PUT UNFORMAT "^FO50,280^AE^FDPART NO.^FS" SKIP.
                     PUT UNFORMAT "^FO250,280^AE^FD" b_co_part "^FS" SKIP.
                     /*PUT UNFORMAT "^FO50,350^AE^FDLOT/SER.^FS" SKIP.
                     PUT UNFORMAT "^FO250,350^AE^FD" b_co_lot "^FS" SKIP.
                     PUT UNFORMAT "^FO50,420^AE^FDREF NO.^FS" SKIP.
                     PUT UNFORMAT "^FO250,420^AE^FD" b_co_ref "^FS" SKIP.
                     PUT UNFORMAT "^FO50,490^AE^FDQUANTITY^FS" SKIP.
                     PUT UNFORMAT "^FO250,490^AE^FD" TRIM(STRING(b_co_qty_cur,">>>>>>9.9<<<<<<")) "^FS" SKIP.
                     PUT UNFORMAT "^FO50,580^AE^FD" b_ct_comp "^FS" SKIP.   */
               /* PUT "^FO10,400^AD^FDPRINTER TIME:" global_date "^FS" SKIP.
                PUT "^FO300,400^AD^FDPRINTER USER:" global_user "^FS" SKIP.*/
                     PUT "^XZ" SKIP.
                OUTPUT CLOSE.
                OS-COMMAND SILENT VALUE("copy" +  " c:\" + mfguser  +  " LPT1").
            END. /*when sin*/
            WHEN "FUL" THEN DO:
                OUTPUT TO value("c:\" + mfguser).
                     PUT "^XA" SKIP.
                     PUT UNFORMAT "^FO50,50^BY2,3,10^BCN,150,Y,N,N^AD^FD" b_co_code "^FS" SKIP.
                     PUT UNFORMAT "^FO50,250^AE^FDPART NO.^FS" SKIP.
                     PUT UNFORMAT "^FO250,250^AE^FD" b_co_part "^FS" SKIP.
                     PUT UNFORMAT "^FO50,300^AE^FDLOT/SER.^FS" SKIP.
                     PUT UNFORMAT "^FO250,300^AE^FD" b_co_lot "^FS" SKIP.
                     PUT UNFORMAT "^FO50,350^AE^FDDESC NO.^FS" SKIP.
                     PUT UNFORMAT "^FO250,350^AE^FD" b_co_desc2 "^FS" SKIP.
                     PUT UNFORMAT "^FO50,400^AE^FDSHIFT^FS" SKIP.
                     PUT UNFORMAT "^FO250,400^AE^FD" b_co_shift "^FS" SKIP.
                     PUT UNFORMAT "^FO50,450^AE^FDWO DATE^FS" SKIP.
                     PUT UNFORMAT "^FO250,450^AE^FD" b_co_wodate "^FS" SKIP.
                     PUT UNFORMAT "^FO50,500^AE^FDQUANTITY^FS" SKIP.
                     PUT UNFORMAT "^FO250,500^AE^FD" TRIM(STRING(b_co_qty_cur,">>>>>>9.9<<<<<<")) "^FS" SKIP.
                     /*PUT UNFORMAT "^FO50,580^AE^FD" b_ct_comp "^FS" SKIP.*/
               /* PUT "^FO10,400^AD^FDPRINTER TIME:" global_date "^FS" SKIP.
                PUT "^FO300,400^AD^FDPRINTER USER:" global_user "^FS" SKIP.*/
                     PUT "^XZ" SKIP.
                OUTPUT CLOSE.
                OS-COMMAND SILENT VALUE("copy" +  " c:\" + mfguser  +  " LPT1").
            END.  /*when dou*/
        END CASE. /*case btype*/
    END.  /*when prnter is ZPL*/
     
    END CASE.
  OS-DELETE VALUE( "c:\" + mfguser).
END.  /*available co_mstr*/


