/* Generate By Barcode Generator , Copyright by Softspeed - Build By Sam Song  */ 
/* 載陔蘇�炵媯� */
/* Generate date / time  2006-4-3 10:23:55 */
define variable sectionid as integer init 0 .
define variable WMESSAGE as char format "x(80)" init "".
define variable wtm_num as char format "x(20)" init "0".
define variable wsection as char format "x(16)".
define variable i as integer .

define variable wtimeout as integer init 99999 .
find first code_mstr where code_fldname = "BARCODE" AND CODE_value ="wtimeout" no-lock no-error. /*  Timeout - All Level */
if AVAILABLE(code_mstr) Then wtimeout = 60 * decimal(code_cmmt).
find first code_mstr where code_fldname = "BARCODE" AND CODE_value ="xsmdf01wtimeout" no-lock no-error. /*  Timeout - Program Level */
if AVAILABLE(code_mstr) Then wtimeout = 60 * decimal(code_cmmt).

mainloop:
REPEAT:
     /* CYCLE COUNTER -SECTION ID -- START*/
      sectionid = sectionid + 1 .
     /* SECTION ID -- END  */

     /* START  LINE :1002  地點[SITE]  */
     V1002L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1002           as char format "x(50)".
        define variable PV1002          as char format "x(50)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        {xsdfsite.i}
        V1002 = wDefSite.
        V1002 = ENTRY(1,V1002,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1002 = ENTRY(1,V1002,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */
                display "[更新默認地點]"      + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1002 no-box.

                /* LABEL 1 - START */ 
                display "更新後的地點?"       format "x(40)" skip with fram F1002 no-box.
                /* LABEL 1 - END */ 

                /* LABEL 2 - START */ 
                  display skip(1) with fram F1002 no-box.
                /* LABEL 2 - END */

                /* LABEL 3 - START */
                display "1.確保有訪問權限"     format "x(40)" skip with fram F1002 no-box.
                /* LABEL 3  - END */

                /* LABEL 4 - START */
                  display skip(1) with fram F1002 no-box.
                /* LABEL 4 - END */
                display "輸入或按E退出 "      format "x(40)" skip
        skip with fram F1002 no-box.
        Update V1002
        WITH  fram F1002 NO-LABEL
        /* ROLL BAR START */
        EDITING:
        readkey pause wtimeout.
        if lastkey = -1 then quit.
        display skip "^" @ WMESSAGE NO-LABEL with fram F1002.
            IF LASTKEY = keycode("F10") or keyfunction(lastkey) = "CURSOR-DOWN"
            THEN DO:
                  IF recid(SI_MSTR) = ? THEN find first SI_MSTR where 
                              SI_SITE >=  INPUT V1002  no-lock no-error.
                  ELSE find first SI_MSTR where 
                              SI_SITE >  INPUT V1002  no-lock no-error.
                  IF AVAILABLE SI_MSTR then display skip 
            SI_SITE @ V1002 TRIM ( SI_SITE ) + "/" + TRIM ( SI_DESC ) @ WMESSAGE NO-LABEL with fram F1002.
                  else   display skip "" @ WMESSAGE with fram F1002.
            END.
            IF LASTKEY = keycode("F9") or keyfunction(lastkey) = "CURSOR-UP"
            THEN DO:
                  IF recid(SI_MSTR) = ? THEN find first SI_MSTR where 
            SI_SITE <=  INPUT V1002  no-lock no-error.
                  ELSE find last SI_MSTR where 
                              SI_SITE <  INPUT V1002  no-lock no-error.
                  IF AVAILABLE SI_MSTR then display skip 
            SI_SITE @ V1002 TRIM ( SI_SITE ) + "/" + TRIM ( SI_DESC ) @ WMESSAGE NO-LABEL with fram F1002.
                  else   display skip "" @ WMESSAGE with fram F1002.
            END.
            APPLY LASTKEY.
        END.
        /* ROLL BAR END */


        /* PRESS e EXIST CYCLE */
        IF V1002 = "e" THEN  LEAVE MAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F1002.

         /*  ---- Valid Check ---- START */

        find first si_mstr where si_site = V1002  no-lock no-error.
        IF NOT AVAILABLE si_mstr then do:
                display skip "錯誤,重試!" @ WMESSAGE NO-LABEL with fram F1002.
                pause 0 before-hide.
                undo, retry.
        end.


        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1002.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */

    define variable kPASS          as char format "x(1)" init "N".
    
find first CODE_MSTR where code_fldname = "BARCODEACCESSSITE" and code_value = userid(sdbname('qaddb'))  no-lock no-error.
IF NOT AVAILABLE CODE_MSTR then DO:

   find first CODE_MSTR where code_fldname = "BARCODEACCESSSITE" and code_value =  "*" no-lock no-error.
   IF NOT AVAILABLE CODE_MSTR THEN kPASS = "N".
   ELSE DO:
      if index ( trim(code_cmmt) , V1002 ) = 0  then kPASS = "N" .
                                                   else kPASS = "Y" .
   
   END.
END.
ELSE do:
 if  index ( trim(code_cmmt) , V1002 ) = 0 then kPASS = "N".
                                              else kPASS = "Y".
end.

        IF not kPASS = "Y" THEN DO:
                display skip "訪問權限有誤" @ WMESSAGE NO-LABEL with fram F1002.
                pause 0 before-hide.
                undo, retry.
        end.
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1002.
        pause 0.
        leave V1002L.
     END.
     PV1002 = V1002.
     /* END    LINE :1002  地點[SITE]  */


     /* START  LINE :1004  更新默認地點[UPDATE Default Site]  */
     V1004L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1004           as char format "x(50)".
        define variable PV1004          as char format "x(50)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        V1004 = V1002.
        V1004 = ENTRY(1,V1004,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1004 = ENTRY(1,V1004,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        find first code_mstr where code_fldname = "BARCODEDEFSITE" and code_value =  userid(sdbname('qaddb'))  no-error. 
        If NOT AVAILABLE(code_mstr) Then create code_mstr . 
	Code_fldname = "BARCODEDEFSITE".
        Code_value =  userid(sdbname('qaddb')) .
	Code_cmmt =trim ( V1002 ).
	release code_mstr.
IF 1 = 1 THEN
        leave V1004L.
        /* LOGICAL SKIP END */
                display "[更新默認地點]"      + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1004 no-box.

                /* LABEL 1 - START */ 
                display "更新默認地點"        format "x(40)" skip with fram F1004 no-box.
                /* LABEL 1 - END */ 

                /* LABEL 2 - START */ 
                  display skip(1) with fram F1004 no-box.
                /* LABEL 2 - END */

                /* LABEL 3 - START */
                  display skip(1) with fram F1004 no-box.
                /* LABEL 3  - END */

                /* LABEL 4 - START */
                  display skip(1) with fram F1004 no-box.
                /* LABEL 4 - END */
                display "輸入或按E退出 "      format "x(40)" skip
        skip with fram F1004 no-box.
        Update V1004
        WITH  fram F1004 NO-LABEL
        EDITING:
          readkey pause wtimeout.
          if lastkey = -1 Then quit.
           apply lastkey.
        end.

        /* PRESS e EXIST CYCLE */
        IF V1004 = "e" THEN  LEAVE MAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F1004.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1004.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1004.
        pause 0.
        leave V1004L.
     END.
     PV1004 = V1004.
     /* END    LINE :1004  更新默認地點[UPDATE Default Site]  */


end.
