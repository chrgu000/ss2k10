/* Generate By Barcode Generator , Copyright by Softspeed - Build By Sam Song  */ 
/* Rep Backflush with label */
/* Generate date / time  2011-3-18 11:31:16 */
define variable sectionid as integer init 0 .
define variable WMESSAGE as char format "x(80)" init "".
define variable wtm_num as char format "x(20)" init "0".
define variable wsection as char format "x(200)".
define variable looa as char format "x(200)" init "Y".
define variable i as integer .
define variable t_v1300 as char .
define variable t_v1302 as char .
define variable t_v1310 as char .
define variable t_v1314 as char .
define variable t_v1326 as char .
define variable t_v1400 as char .
DEFINE VARIABLE trnbr AS INTEGER.
DEFINE NEW GLOBAL SHARED VARIABLE mfguser AS CHARACTER.
DEFINE NEW GLOBAL SHARED VARIABLE ts_mfguser AS CHARACTER.
define  variable t_v100  as char EXTENT 15 .
define  variable tki  as integer .
define  variable tkj  as integer .
define  variable tkstr  as char .

define variable wtimeout as integer init 99999 .
find first code_mstr where code_fldname = "BARCODE" AND CODE_value ="wtimeout"
 and can-find ( first dom_mstr where  dom_type = "SYSTEM " and dom_domain = code_domain and dom_active = yes ) 
 no-lock no-error. /*  Timeout - All Level */
if AVAILABLE(code_mstr) Then wtimeout = 60 * decimal(code_cmmt).
find first code_mstr where code_fldname = "BARCODE" AND CODE_value ="xsrep08wtimeout"
 and can-find ( first dom_mstr where  dom_type = "SYSTEM " and dom_domain = code_domain and dom_active = yes ) 
 no-lock no-error. /*  Timeout - All Level */
if AVAILABLE(code_mstr) Then wtimeout = 60 * decimal(code_cmmt).

mainloop:
REPEAT:
     /* CYCLE COUNTER -SECTION ID -- START*/
      sectionid = sectionid + 1 .
     /* SECTION ID -- END  */

     /* START  LINE :1001  域[DOMAIN]  */
     V1001L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1001           as char format "x(150)".
        define variable PV1001          as char format "x(150)".
        define variable L10011          as char format "x(40)".
        define variable L10012          as char format "x(40)".
        define variable L10013          as char format "x(40)".
        define variable L10014          as char format "x(40)".
        define variable L10015          as char format "x(40)".
        define variable L10016          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        {xsdfdomain.i}
        V1001 = wDefDomain.
        V1001 = ENTRY(1,V1001,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1001 = ENTRY(1,V1001,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        IF dPASS = "Y" then
        leave V1001L.
        /* LOGICAL SKIP END */

                /* LABEL 1 - START */ 
                L10011 = "域设定有误" .
                display L10011          format "x(40)" skip with fram F1001 width 150 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                L10012 = "1.没有设定默认域" .
                display L10012          format "x(40)" skip with fram F1001 width 150 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                L10013 = "2.域权限设定有误" .
                display L10013          format "x(40)" skip with fram F1001 width 150 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                L10014 = "  请查核" .
                display L10014          format "x(40)" skip with fram F1001 width 150 no-box.
                /* LABEL 4 - END */ 
                display "输入或按E退出"       format "x(40)" skip
        skip with fram F1001 width 150 no-box.
        Update V1001
        WITH  fram F1001 NO-LABEL
        EDITING:
          readkey pause wtimeout.
          if lastkey = -1 Then quit.
        if LASTKEY = 404 Then Do: /* DISABLE F4 */
           pause 0 before-hide.
           undo, retry.
        end.
           apply lastkey.
        end.

        /* PRESS e EXIST CYCLE */
        IF V1001 = "e" THEN  LEAVE MAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F1001.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1001.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
        IF not trim(V1001) = "E" THEN DO:
                display skip "Error , Retry " @ WMESSAGE NO-LABEL with fram F1001.
                pause 0 before-hide.
                undo, retry.
        end.
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1001.
        pause 0.
        leave V1001L.
     END.
     PV1001 = V1001.
     /* END    LINE :1001  域[DOMAIN]  */


     /* START  LINE :1002  地点[SITE]  */
     V1002L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1002           as char format "x(150)".
        define variable PV1002          as char format "x(150)".
        define variable L10021          as char format "x(40)".
        define variable L10022          as char format "x(40)".
        define variable L10023          as char format "x(40)".
        define variable L10024          as char format "x(40)".
        define variable L10025          as char format "x(40)".
        define variable L10026          as char format "x(40)".
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
        IF aPASS = "Y" then
        leave V1002L.
        /* LOGICAL SKIP END */
                display "[生产回冲-有标签]"    + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1002 width 150 no-box.

                /* LABEL 1 - START */ 
                L10021 = "地点设定有误" .
                display L10021          format "x(40)" skip with fram F1002 width 150 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                L10022 = "1.没有设定默认地点" .
                display L10022          format "x(40)" skip with fram F1002 width 150 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                L10023 = "2.权限设定有误" .
                display L10023          format "x(40)" skip with fram F1002 width 150 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                L10024 = "  请查核" .
                display L10024          format "x(40)" skip with fram F1002 width 150 no-box.
                /* LABEL 4 - END */ 
                display "输入或按E退出"       format "x(40)" skip
        skip with fram F1002 width 150 no-box.
        Update V1002
        WITH  fram F1002 NO-LABEL
        EDITING:
          readkey pause wtimeout.
          if lastkey = -1 Then quit.
        if LASTKEY = 404 Then Do: /* DISABLE F4 */
           pause 0 before-hide.
           undo, retry.
        end.
           apply lastkey.
        end.

        /* PRESS e EXIST CYCLE */
        IF V1002 = "e" THEN  LEAVE MAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F1002.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1002.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
        IF not trim(V1002) = "E" THEN DO:
                display skip "Error , Retry " @ WMESSAGE NO-LABEL with fram F1002.
                pause 0 before-hide.
                undo, retry.
        end.
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1002.
        pause 0.
        leave V1002L.
     END.
     PV1002 = V1002.
     /* END    LINE :1002  地点[SITE]  */


     /* START  LINE :1099  雇员  */
     V1099L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1099           as char format "x(150)".
        define variable PV1099          as char format "x(150)".
        define variable L10991          as char format "x(40)".
        define variable L10992          as char format "x(40)".
        define variable L10993          as char format "x(40)".
        define variable L10994          as char format "x(40)".
        define variable L10995          as char format "x(40)".
        define variable L10996          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1099 = ENTRY(1,V1099,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */
                display "[生产回冲-有标签]"    + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1099 width 150 no-box.

                /* LABEL 1 - START */ 
                L10991 = "雇员?" .
                display L10991          format "x(40)" skip with fram F1099 width 150 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                  L10992 = "" . 
                display L10992          format "x(40)" skip with fram F1099 width 150 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                  L10993 = "" . 
                display L10993          format "x(40)" skip with fram F1099 width 150 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L10994 = "" . 
                display L10994          format "x(40)" skip with fram F1099 width 150 no-box.
                /* LABEL 4 - END */ 
                display "输入或按E退出"       format "x(40)" skip
        skip with fram F1099 width 150 no-box.
        recid(emp_mstr) = ?.
        Update V1099
        WITH  fram F1099 NO-LABEL
        /* ROLL BAR START */
        EDITING:
        readkey pause wtimeout.
        if lastkey = -1 then quit.
        if LASTKEY = 404 Then Do: /* DISABLE F4 */
           pause 0 before-hide.
           undo, retry.
        end.
        display skip "^" @ WMESSAGE NO-LABEL with fram F1099.
            IF LASTKEY = keycode("F10") or keyfunction(lastkey) = "CURSOR-DOWN"
            THEN DO:
                  IF recid(emp_mstr) = ? THEN find first emp_mstr where 
                              emp_domain=V1001 AND  
                              emp_addr >=  INPUT V1099
                               no-lock no-error.
                  else do: 
                       if emp_addr =  INPUT V1099
                       then find next emp_mstr
                       WHERE emp_domain=V1001
                        no-lock no-error.
                        else find first emp_mstr where 
                              emp_domain=V1001 AND  
                              emp_addr >=  INPUT V1099
                               no-lock no-error.
                  end.
                  IF AVAILABLE emp_mstr then display skip 
            emp_addr @ V1099 emp_addr + "/" + emp_lname @ WMESSAGE NO-LABEL with fram F1099.
                  else   display skip "" @ WMESSAGE with fram F1099.
            END.
            IF LASTKEY = keycode("F9") or keyfunction(lastkey) = "CURSOR-UP"
            THEN DO:
                  IF recid(emp_mstr) = ? THEN find last emp_mstr where 
                              emp_domain=V1001 AND  
                              emp_addr <=  INPUT V1099
                               no-lock no-error.
                  else do: 
                       if emp_addr =  INPUT V1099
                       then find prev emp_mstr
                       where emp_domain=V1001
                        no-lock no-error.
                        else find first emp_mstr where 
                              emp_domain=V1001 AND  
                              emp_addr >=  INPUT V1099
                               no-lock no-error.
                  end.
                  IF AVAILABLE emp_mstr then display skip 
            emp_addr @ V1099 emp_addr + "/" + emp_lname @ WMESSAGE NO-LABEL with fram F1099.
                  else   display skip "" @ WMESSAGE with fram F1099.
            END.
            APPLY LASTKEY.
        END.
        /* ROLL BAR END */


        /* PRESS e EXIST CYCLE */
        IF V1099 = "e" THEN  LEAVE MAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F1099.

         /*  ---- Valid Check ---- START */

        find first emp_mstr where emp_domain=V1001 and emp_addr =V1099 no-lock no-error .
If not avail emp_mstr then do:
display skip "雇员不存在,请查" @ WMESSAGE NO-LABEL with fram F1099.
                pause 0 before-hide.
                Undo, retry.

End.
        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1099.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1099.
        pause 0.
        leave V1099L.
     END.
     PV1099 = V1099.
     /* END    LINE :1099  雇员  */


     /* START  LINE :1203  生效日期  */
     V1203L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1203           as char format "x(150)".
        define variable PV1203          as char format "x(150)".
        define variable L12031          as char format "x(40)".
        define variable L12032          as char format "x(40)".
        define variable L12033          as char format "x(40)".
        define variable L12034          as char format "x(40)".
        define variable L12035          as char format "x(40)".
        define variable L12036          as char format "x(40)".
        define variable D1203           as date .
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        V1203 = string ( today ).
        D1203 = Date ( V1203).
        V1203 = ENTRY(1,V1203,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
         If sectionid > 1 Then 
        V1203 = PV1203 .
         If sectionid > 1 Then 
        D1203 = Date ( V1203).
        V1203 = ENTRY(1,V1203,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */
                display "[生产回冲-有标签]"    + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1203 width 150 no-box.

                /* LABEL 1 - START */ 
                L12031 = "生效日期?" .
                display L12031          format "x(40)" skip with fram F1203 width 150 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                L12032 = string ( today ) .
                display L12032          format "x(40)" skip with fram F1203 width 150 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                  L12033 = "" . 
                display L12033          format "x(40)" skip with fram F1203 width 150 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L12034 = "" . 
                display L12034          format "x(40)" skip with fram F1203 width 150 no-box.
                /* LABEL 4 - END */ 
                display "输入或按E退出"       format "x(40)" skip
        skip with fram F1203 width 150 no-box.
        Update D1203
        WITH  fram F1203 NO-LABEL
        EDITING:
          readkey pause wtimeout.
          if lastkey = -1 Then quit.
        if LASTKEY = 404 Then Do: /* DISABLE F4 */
           pause 0 before-hide.
           undo, retry.
        end.
           apply lastkey.
        end.

        /* PRESS e EXIST CYCLE */
        IF V1203 = "e" THEN  LEAVE MAINLOOP.
        V1203 = string ( D1203).
        display  skip WMESSAGE NO-LABEL with fram F1203.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1203.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1203.
        pause 0.
        leave V1203L.
     END.
     PV1203 = V1203.
     /* END    LINE :1203  生效日期  */


     /* START  LINE :1204  班次  */
     V1204L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1204           as char format "x(150)".
        define variable PV1204          as char format "x(150)".
        define variable L12041          as char format "x(40)".
        define variable L12042          as char format "x(40)".
        define variable L12043          as char format "x(40)".
        define variable L12044          as char format "x(40)".
        define variable L12045          as char format "x(40)".
        define variable L12046          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1204 = ENTRY(1,V1204,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */
                display "[生产回冲-有标签]"    + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1204 width 150 no-box.

                /* LABEL 1 - START */ 
                L12041 = "班次?" .
                display L12041          format "x(40)" skip with fram F1204 width 150 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                  L12042 = "" . 
                display L12042          format "x(40)" skip with fram F1204 width 150 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                  L12043 = "" . 
                display L12043          format "x(40)" skip with fram F1204 width 150 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L12044 = "" . 
                display L12044          format "x(40)" skip with fram F1204 width 150 no-box.
                /* LABEL 4 - END */ 
                display "输入或按E退出"       format "x(40)" skip
        skip with fram F1204 width 150 no-box.
        Update V1204
        WITH  fram F1204 NO-LABEL
        EDITING:
          readkey pause wtimeout.
          if lastkey = -1 Then quit.
        if LASTKEY = 404 Then Do: /* DISABLE F4 */
           pause 0 before-hide.
           undo, retry.
        end.
           apply lastkey.
        end.

        /* PRESS e EXIST CYCLE */
        IF V1204 = "e" THEN  LEAVE MAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F1204.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1204.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1204.
        pause 0.
        leave V1204L.
     END.
     PV1204 = V1204.
     /* END    LINE :1204  班次  */


     /* START  LINE :1290  扫描标签[Raw Material]  */
     V1290L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1290           as char format "x(150)".
        define variable PV1290          as char format "x(150)".
        define variable L12901          as char format "x(40)".
        define variable L12902          as char format "x(40)".
        define variable L12903          as char format "x(40)".
        define variable L12904          as char format "x(40)".
        define variable L12905          as char format "x(40)".
        define variable L12906          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        V1290 = " ".
        V1290 = ENTRY(1,V1290,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1290 = ENTRY(1,V1290,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */
                display "[生产回冲-有标签]"    + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1290 width 150 no-box.

                /* LABEL 1 - START */ 
                L12901 = "扫描广本标签:" .
                display L12901          format "x(40)" skip with fram F1290 width 150 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                  L12902 = "" . 
                display L12902          format "x(40)" skip with fram F1290 width 150 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                  L12903 = "" . 
                display L12903          format "x(40)" skip with fram F1290 width 150 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L12904 = "" . 
                display L12904          format "x(40)" skip with fram F1290 width 150 no-box.
                /* LABEL 4 - END */ 
                display "输入或按E退出"       format "x(40)" skip
        skip with fram F1290 width 150 no-box.
        Update V1290
        WITH  fram F1290 NO-LABEL
        EDITING:
          readkey pause wtimeout.
          if lastkey = -1 Then quit.
        if LASTKEY = 404 Then Do: /* DISABLE F4 */
           pause 0 before-hide.
           undo, retry.
        end.
           apply lastkey.
        end.

        /* PRESS e EXIST CYCLE */
        IF V1290 = "e" THEN  LEAVE MAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F1290.

         /*  ---- Valid Check ---- START */

        if length(trim(V1290))<>0 then do:
find first pt_mstr where pt_domain=V1001 and pt_article =trim(substring(ENTRY(1, V1290, "@"),4,16)) no-lock no-error .
If not avail pt_mstr then do:
display skip "件号不存在,请查" @ WMESSAGE NO-LABEL with fram F1290.
                pause 0 before-hide.
                Undo, retry.

End.
End.
If length(trim(V1290))=0 then do:
display skip "件号不能为空,请查" @ WMESSAGE NO-LABEL with fram F1290.
                pause 0 before-hide.
                Undo, retry.

End.
        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1290.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1290.
        pause 0.
        leave V1290L.
     END.
     PV1290 = V1290.
     /* END    LINE :1290  扫描标签[Raw Material]  */


   /* Internal Cycle Input :1300    */
   V1300LMAINLOOP:
   REPEAT:
     /* START  LINE :1300  GB件号[Raw Material]  */
     V1300L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1300           as char format "x(150)".
        define variable PV1300          as char format "x(150)".
        define variable L13001          as char format "x(40)".
        define variable L13002          as char format "x(40)".
        define variable L13003          as char format "x(40)".
        define variable L13004          as char format "x(40)".
        define variable L13005          as char format "x(40)".
        define variable L13006          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        V1300 = trim( substring(V1290,4,16)).
        V1300 = ENTRY(1,V1300,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1300 = ENTRY(1,V1300,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */
                display "[生产回冲-有标签]"    + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1300 width 150 no-box.

                /* LABEL 1 - START */ 
                L13001 = "广本件号?" .
                display L13001          format "x(40)" skip with fram F1300 width 150 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                  L13002 = "" . 
                display L13002          format "x(40)" skip with fram F1300 width 150 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                  L13003 = "" . 
                display L13003          format "x(40)" skip with fram F1300 width 150 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L13004 = "" . 
                display L13004          format "x(40)" skip with fram F1300 width 150 no-box.
                /* LABEL 4 - END */ 
                display "输入或按E退出"       format "x(40)" skip
        skip with fram F1300 width 150 no-box.
        recid(PT_MSTR) = ?.
        Update V1300
        WITH  fram F1300 NO-LABEL
        /* ROLL BAR START */
        EDITING:
        readkey pause wtimeout.
        if lastkey = -1 then quit.
        if LASTKEY = 404 Then Do: /* DISABLE F4 */
           pause 0 before-hide.
           undo, retry.
        end.
        display skip "^" @ WMESSAGE NO-LABEL with fram F1300.
            IF LASTKEY = keycode("F10") or keyfunction(lastkey) = "CURSOR-DOWN"
            THEN DO:
                  IF recid(PT_MSTR) = ? THEN find first PT_MSTR where 
                              PT_DOMAIN = V1001 and pt_article<>"" AND  
                              pt_article >=  INPUT V1300
                               no-lock no-error.
                  else do: 
                       if pt_article =  INPUT V1300
                       then find next PT_MSTR
                       WHERE PT_DOMAIN = V1001 and pt_article<>""
                        no-lock no-error.
                        else find first PT_MSTR where 
                              PT_DOMAIN = V1001 and pt_article<>"" AND  
                              pt_article >=  INPUT V1300
                               no-lock no-error.
                  end.
                  IF AVAILABLE PT_MSTR then display skip 
            pt_article @ V1300 trim( PT_DESC1 ) @ WMESSAGE NO-LABEL with fram F1300.
                  else   display skip "" @ WMESSAGE with fram F1300.
            END.
            IF LASTKEY = keycode("F9") or keyfunction(lastkey) = "CURSOR-UP"
            THEN DO:
                  IF recid(PT_MSTR) = ? THEN find last PT_MSTR where 
                              PT_DOMAIN = V1001 and pt_article<>"" AND  
                              pt_article <=  INPUT V1300
                               no-lock no-error.
                  else do: 
                       if pt_article =  INPUT V1300
                       then find prev PT_MSTR
                       where PT_DOMAIN = V1001 and pt_article<>""
                        no-lock no-error.
                        else find first PT_MSTR where 
                              PT_DOMAIN = V1001 and pt_article<>"" AND  
                              pt_article >=  INPUT V1300
                               no-lock no-error.
                  end.
                  IF AVAILABLE PT_MSTR then display skip 
            pt_article @ V1300 trim( PT_DESC1 ) @ WMESSAGE NO-LABEL with fram F1300.
                  else   display skip "" @ WMESSAGE with fram F1300.
            END.
            APPLY LASTKEY.
        END.
        /* ROLL BAR END */


        /* PRESS e EXIST CYCLE */
        /* **SKIP TO MAIN LOOP START** */
        IF V1300 = "e" THEN  LEAVE MAINLOOP.
        /* **SKIP TO MAIN LOOP END** */
        display  skip WMESSAGE NO-LABEL with fram F1300.

         /*  ---- Valid Check ---- START */

        find first pt_mstr where pt_domain = V1001 and pt_article =V1300 no-lock  no-error.
        If NOT AVAILABLE pt_mstr then do:
display skip "件号不存在,请查" @ WMESSAGE NO-LABEL with fram F1300.
                pause 0 before-hide.
                Undo, retry.


	End.
If length(trim(V1300))=0 then do:
display skip "件号不能为空,请查" @ WMESSAGE NO-LABEL with fram F1300.
                pause 0 before-hide.
                Undo, retry.

End.
        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1300.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1300.
        pause 0.
        leave V1300L.
     END.
     IF INDEX(V1300,"@" ) = 0 then V1300 = V1300 + "@".
     PV1300 = V1300.
     V1300 = ENTRY(1,V1300,"@").
     /* END    LINE :1300  GB件号[Raw Material]  */


     /* START  LINE :1301  TS件号[Raw Material]  */
     V1301L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1301           as char format "x(150)".
        define variable PV1301          as char format "x(150)".
        define variable L13011          as char format "x(40)".
        define variable L13012          as char format "x(40)".
        define variable L13013          as char format "x(40)".
        define variable L13014          as char format "x(40)".
        define variable L13015          as char format "x(40)".
        define variable L13016          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        find first pt_mstr where pt_article=V1300 and PT_DOMAIN = V1001 no-lock no-error no-wait.
If avail pt_mstr then
        V1301 = pt_part.
        V1301 = ENTRY(1,V1301,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1301 = ENTRY(1,V1301,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */
                display "[生产回冲-有标签]"    + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1301 width 150 no-box.

                /* LABEL 1 - START */ 
                L13011 = "TS件号?" .
                display L13011          format "x(40)" skip with fram F1301 width 150 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                  L13012 = "" . 
                display L13012          format "x(40)" skip with fram F1301 width 150 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                  L13013 = "" . 
                display L13013          format "x(40)" skip with fram F1301 width 150 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L13014 = "" . 
                display L13014          format "x(40)" skip with fram F1301 width 150 no-box.
                /* LABEL 4 - END */ 
                display "输入或按E退出"       format "x(40)" skip
        skip with fram F1301 width 150 no-box.
        recid(PT_MSTR) = ?.
        Update V1301
        WITH  fram F1301 NO-LABEL
        /* ROLL BAR START */
        EDITING:
        readkey pause wtimeout.
        if lastkey = -1 then quit.
        if LASTKEY = 404 Then Do: /* DISABLE F4 */
           pause 0 before-hide.
           undo, retry.
        end.
        display skip "^" @ WMESSAGE NO-LABEL with fram F1301.
            IF LASTKEY = keycode("F10") or keyfunction(lastkey) = "CURSOR-DOWN"
            THEN DO:
                  IF recid(PT_MSTR) = ? THEN find first PT_MSTR where 
                              PT_DOMAIN = V1001 and pt_article=V1300 AND  
                              PT_PART >=  INPUT V1301
                               no-lock no-error.
                  else do: 
                       if PT_PART =  INPUT V1301
                       then find next PT_MSTR
                       WHERE PT_DOMAIN = V1001 and pt_article=V1300
                        no-lock no-error.
                        else find first PT_MSTR where 
                              PT_DOMAIN = V1001 and pt_article=V1300 AND  
                              PT_PART >=  INPUT V1301
                               no-lock no-error.
                  end.
                  IF AVAILABLE PT_MSTR then display skip 
            PT_PART @ V1301 trim( PT_DESC1 ) @ WMESSAGE NO-LABEL with fram F1301.
                  else   display skip "" @ WMESSAGE with fram F1301.
            END.
            IF LASTKEY = keycode("F9") or keyfunction(lastkey) = "CURSOR-UP"
            THEN DO:
                  IF recid(PT_MSTR) = ? THEN find last PT_MSTR where 
                              PT_DOMAIN = V1001 and pt_article=V1300 AND  
                              PT_PART <=  INPUT V1301
                               no-lock no-error.
                  else do: 
                       if PT_PART =  INPUT V1301
                       then find prev PT_MSTR
                       where PT_DOMAIN = V1001 and pt_article=V1300
                        no-lock no-error.
                        else find first PT_MSTR where 
                              PT_DOMAIN = V1001 and pt_article=V1300 AND  
                              PT_PART >=  INPUT V1301
                               no-lock no-error.
                  end.
                  IF AVAILABLE PT_MSTR then display skip 
            PT_PART @ V1301 trim( PT_DESC1 ) @ WMESSAGE NO-LABEL with fram F1301.
                  else   display skip "" @ WMESSAGE with fram F1301.
            END.
            APPLY LASTKEY.
        END.
        /* ROLL BAR END */


        /* PRESS e EXIST CYCLE */
        IF V1301 = "e" THEN  LEAVE V1300LMAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F1301.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1301.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1301.
        pause 0.
        leave V1301L.
     END.
     PV1301 = V1301.
     /* END    LINE :1301  TS件号[Raw Material]  */


     /* START  LINE :1310  工序  */
     V1310L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1310           as char format "x(150)".
        define variable PV1310          as char format "x(150)".
        define variable L13101          as char format "x(40)".
        define variable L13102          as char format "x(40)".
        define variable L13103          as char format "x(40)".
        define variable L13104          as char format "x(40)".
        define variable L13105          as char format "x(40)".
        define variable L13106          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        find last ro_det where ro_domain = V1001 and
ro_routing = V1301  no-lock no-error.
If AVAILABLE ( ro_det ) then
        V1310 = string ( ro_op ).
        V1310 = ENTRY(1,V1310,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1310 = ENTRY(1,V1310,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */
                display "[生产回冲-有标签]"    + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1310 width 150 no-box.

                /* LABEL 1 - START */ 
                L13101 = "工序?" .
                display L13101          format "x(40)" skip with fram F1310 width 150 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                find last ro_det where ro_domain = V1001 and
ro_routing = V1300  no-lock no-error.
If AVAILABLE ( ro_det ) then
                L13102 = "工序:" + trim ( string ( ro_op ) ) .
                else L13102 = "" . 
                display L13102          format "x(40)" skip with fram F1310 width 150 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                find last ro_det where ro_domain = V1001 and 
ro_routing = V1300  no-lock no-error.
If AVAILABLE ( ro_det ) then
                L13103 = trim ( ro_desc ) .
                else L13103 = "" . 
                display L13103          format "x(40)" skip with fram F1310 width 150 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L13104 = "" . 
                display L13104          format "x(40)" skip with fram F1310 width 150 no-box.
                /* LABEL 4 - END */ 
                display "输入或按E退出"       format "x(40)" skip
        skip with fram F1310 width 150 no-box.
        recid(ro_det) = ?.
        Update V1310
        WITH  fram F1310 NO-LABEL
        /* ROLL BAR START */
        EDITING:
        readkey pause wtimeout.
        if lastkey = -1 then quit.
        if LASTKEY = 404 Then Do: /* DISABLE F4 */
           pause 0 before-hide.
           undo, retry.
        end.
        display skip "^" @ WMESSAGE NO-LABEL with fram F1310.
            IF LASTKEY = keycode("F10") or keyfunction(lastkey) = "CURSOR-DOWN"
            THEN DO:
                  IF recid(ro_det) = ? THEN find first ro_det where 
                              ro_domain = V1001 and ro_routing = V1301 AND  
                              string ( ro_op ) >=  INPUT V1310
                               no-lock no-error.
                  else do: 
                       if string ( ro_op ) =  INPUT V1310
                       then find next ro_det
                       WHERE ro_domain = V1001 and ro_routing = V1301
                        no-lock no-error.
                        else find first ro_det where 
                              ro_domain = V1001 and ro_routing = V1301 AND  
                              string ( ro_op ) >=  INPUT V1310
                               no-lock no-error.
                  end.
                  IF AVAILABLE ro_det then display skip 
            string ( ro_op ) @ V1310 ro_desc @ WMESSAGE NO-LABEL with fram F1310.
                  else   display skip "" @ WMESSAGE with fram F1310.
            END.
            IF LASTKEY = keycode("F9") or keyfunction(lastkey) = "CURSOR-UP"
            THEN DO:
                  IF recid(ro_det) = ? THEN find last ro_det where 
                              ro_domain = V1001 and ro_routing = V1301 AND  
                              string ( ro_op ) <=  INPUT V1310
                               no-lock no-error.
                  else do: 
                       if string ( ro_op ) =  INPUT V1310
                       then find prev ro_det
                       where ro_domain = V1001 and ro_routing = V1301
                        no-lock no-error.
                        else find first ro_det where 
                              ro_domain = V1001 and ro_routing = V1301 AND  
                              string ( ro_op ) >=  INPUT V1310
                               no-lock no-error.
                  end.
                  IF AVAILABLE ro_det then display skip 
            string ( ro_op ) @ V1310 ro_desc @ WMESSAGE NO-LABEL with fram F1310.
                  else   display skip "" @ WMESSAGE with fram F1310.
            END.
            APPLY LASTKEY.
        END.
        /* ROLL BAR END */


        /* PRESS e EXIST CYCLE */
        IF V1310 = "e" THEN  LEAVE V1300LMAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F1310.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1310.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
        find first ro_det where ro_domain = V1001 and ro_routing = V1301 and string ( ro_op ) = V1310  no-lock no-error.
        IF NOT AVAILABLE ro_det then do:
                display skip "工序有误!!" @ WMESSAGE NO-LABEL with fram F1310.
                pause 0 before-hide.
                undo, retry.
        end.
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1310.
        pause 0.
        leave V1310L.
     END.
     IF INDEX(V1310,"@" ) = 0 then V1310 = V1310 + "@".
     PV1310 = V1310.
     V1310 = ENTRY(1,V1310,"@").
     /* END    LINE :1310  工序  */


     /* START  LINE :1320  生产线[Production Line]  */
     V1320L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1320           as char format "x(150)".
        define variable PV1320          as char format "x(150)".
        define variable L13201          as char format "x(40)".
        define variable L13202          as char format "x(40)".
        define variable L13203          as char format "x(40)".
        define variable L13204          as char format "x(40)".
        define variable L13205          as char format "x(40)".
        define variable L13206          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        V1320 = substring(V1099,2,4).
        V1320 = ENTRY(1,V1320,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
         If sectionid > 1 Then 
        V1320 = PV1320 .
        V1320 = ENTRY(1,V1320,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */
                display "[生产回冲-有标签]"    + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1320 width 150 no-box.

                /* LABEL 1 - START */ 
                L13201 = "生产线?" .
                display L13201          format "x(40)" skip with fram F1320 width 150 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                  L13202 = "" . 
                display L13202          format "x(40)" skip with fram F1320 width 150 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                  L13203 = "" . 
                display L13203          format "x(40)" skip with fram F1320 width 150 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L13204 = "" . 
                display L13204          format "x(40)" skip with fram F1320 width 150 no-box.
                /* LABEL 4 - END */ 
                display "输入或按E退出"       format "x(40)" skip
        skip with fram F1320 width 150 no-box.
        recid(ln_mstr) = ?.
        Update V1320
        WITH  fram F1320 NO-LABEL
        /* ROLL BAR START */
        EDITING:
        readkey pause wtimeout.
        if lastkey = -1 then quit.
        if LASTKEY = 404 Then Do: /* DISABLE F4 */
           pause 0 before-hide.
           undo, retry.
        end.
        display skip "^" @ WMESSAGE NO-LABEL with fram F1320.
            IF LASTKEY = keycode("F10") or keyfunction(lastkey) = "CURSOR-DOWN"
            THEN DO:
                  IF recid(ln_mstr) = ? THEN find first ln_mstr where 
                              ln_domain=V1001 AND  
                              ln_line >=  INPUT V1320
                               no-lock no-error.
                  else do: 
                       if ln_line =  INPUT V1320
                       then find next ln_mstr
                       WHERE ln_domain=V1001
                        no-lock no-error.
                        else find first ln_mstr where 
                              ln_domain=V1001 AND  
                              ln_line >=  INPUT V1320
                               no-lock no-error.
                  end.
                  IF AVAILABLE ln_mstr then display skip 
            ln_line @ V1320 ln_line + "/" + ln_desc @ WMESSAGE NO-LABEL with fram F1320.
                  else   display skip "" @ WMESSAGE with fram F1320.
            END.
            IF LASTKEY = keycode("F9") or keyfunction(lastkey) = "CURSOR-UP"
            THEN DO:
                  IF recid(ln_mstr) = ? THEN find last ln_mstr where 
                              ln_domain=V1001 AND  
                              ln_line <=  INPUT V1320
                               no-lock no-error.
                  else do: 
                       if ln_line =  INPUT V1320
                       then find prev ln_mstr
                       where ln_domain=V1001
                        no-lock no-error.
                        else find first ln_mstr where 
                              ln_domain=V1001 AND  
                              ln_line >=  INPUT V1320
                               no-lock no-error.
                  end.
                  IF AVAILABLE ln_mstr then display skip 
            ln_line @ V1320 ln_line + "/" + ln_desc @ WMESSAGE NO-LABEL with fram F1320.
                  else   display skip "" @ WMESSAGE with fram F1320.
            END.
            APPLY LASTKEY.
        END.
        /* ROLL BAR END */


        /* PRESS e EXIST CYCLE */
        IF V1320 = "e" THEN  LEAVE V1300LMAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F1320.

         /*  ---- Valid Check ---- START */

        find first ln_mstr where ln_domain=V1001 and ln_line =V1320 no-lock no-error .
If not avail ln_mstr then do:
display skip "生产线不存在,请查" @ WMESSAGE NO-LABEL with fram F1320.
                pause 0 before-hide.
                Undo, retry.

End.
        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1320.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
        find first LND_DET where LND_DOMAIN = V1001 AND LND_LINE = V1320 and LND_PART = ENTRY(1, V1301, "@")  no-lock no-error.
        IF NOT AVAILABLE LND_DET then do:
                display skip "件号/生产线不匹配!" @ WMESSAGE NO-LABEL with fram F1320.
                pause 0 before-hide.
                undo, retry.
        end.
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1320.
        pause 0.
        leave V1320L.
     END.
     PV1320 = V1320.
     /* END    LINE :1320  生产线[Production Line]  */


     /* START  LINE :1410  L Control  */
     V1410L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1410           as char format "x(150)".
        define variable PV1410          as char format "x(150)".
        define variable L14101          as char format "x(40)".
        define variable L14102          as char format "x(40)".
        define variable L14103          as char format "x(40)".
        define variable L14104          as char format "x(40)".
        define variable L14105          as char format "x(40)".
        define variable L14106          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        find first pt_mstr where pt_domain = V1001 and pt_part = V1301  no-lock no-error.
If AVAILABLE ( pt_mstr ) then
        V1410 = pt_lot_ser.
        V1410 = ENTRY(1,V1410,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1410 = ENTRY(1,V1410,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */

        /* --FIRST TIME SKIP -- START  */
         if sectionid = 1 then leave V1410L.
        /* --FIRST TIME SKIP -- END  */


        /* --CYCLE TIME SKIP -- START  */
         if sectionid > 1 then leave V1410L .
        /* --CYCLE TIME SKIP -- END  */

                display "[生产回冲-有标签]"    + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1410 width 150 no-box.

                /* LABEL 1 - START */ 
                  L14101 = "" . 
                display L14101          format "x(40)" skip with fram F1410 width 150 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                  L14102 = "" . 
                display L14102          format "x(40)" skip with fram F1410 width 150 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                  L14103 = "" . 
                display L14103          format "x(40)" skip with fram F1410 width 150 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L14104 = "" . 
                display L14104          format "x(40)" skip with fram F1410 width 150 no-box.
                /* LABEL 4 - END */ 
                display "输入或按E退出"       format "x(40)" skip
        skip with fram F1410 width 150 no-box.
        /* DISPLAY ONLY */
        define variable X1410           as char format "x(40)".
        X1410 = V1410.
        V1410 = "".
        /* DISPLAY ONLY */
        Update V1410
        WITH  fram F1410 NO-LABEL
        EDITING:
          readkey pause wtimeout.
          if lastkey = -1 Then quit.
        if LASTKEY = 404 Then Do: /* DISABLE F4 */
           pause 0 before-hide.
           undo, retry.
        end.
           apply lastkey.
        end.
        V1410 = X1410.
        /* DISPLAY ONLY */
        LEAVE V1410L.
        /* DISPLAY ONLY */

        /* PRESS e EXIST CYCLE */
        IF V1410 = "e" THEN  LEAVE V1300LMAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F1410.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1410.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1410.
        pause 0.
        leave V1410L.
     END.
     PV1410 = V1410.
     /* END    LINE :1410  L Control  */


     /* START  LINE :1500  批号[LOT]  */
     V1500L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1500           as char format "x(150)".
        define variable PV1500          as char format "x(150)".
        define variable L15001          as char format "x(40)".
        define variable L15002          as char format "x(40)".
        define variable L15003          as char format "x(40)".
        define variable L15004          as char format "x(40)".
        define variable L15005          as char format "x(40)".
        define variable L15006          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        V1500 = STRING(YEAR(date ( V1203 )))   + ( IF MONTH ( date ( V1203 ) ) < 10 THEN "0" + STRING( MONTH ( date ( V1203 ) ) ) ELSE STRING( MONTH ( date ( V1203 ) ) ) )  +  ( IF DAY ( date ( V1203 ) ) < 10 THEN "0" + STRING( DAY ( date ( V1203 ) ) ) ELSE STRING( DAY ( date ( V1203 ) ) ) ).
        V1500 = ENTRY(1,V1500,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1500 = ENTRY(1,V1500,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        IF V1410 <> "L" then
        leave V1500L.
        /* LOGICAL SKIP END */
                display "[生产回冲-有标签]"    + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1500 width 150 no-box.

                /* LABEL 1 - START */ 
                L15001 = "批号?" .
                display L15001          format "x(40)" skip with fram F1500 width 150 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                L15002 = "件号:" + trim( V1300 ) .
                display L15002          format "x(40)" skip with fram F1500 width 150 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                  L15003 = "" . 
                display L15003          format "x(40)" skip with fram F1500 width 150 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L15004 = "" . 
                display L15004          format "x(40)" skip with fram F1500 width 150 no-box.
                /* LABEL 4 - END */ 
                display "输入或按E退出"       format "x(40)" skip
        skip with fram F1500 width 150 no-box.
        Update V1500
        WITH  fram F1500 NO-LABEL
        EDITING:
          readkey pause wtimeout.
          if lastkey = -1 Then quit.
        if LASTKEY = 404 Then Do: /* DISABLE F4 */
           pause 0 before-hide.
           undo, retry.
        end.
           apply lastkey.
        end.

        /* PRESS e EXIST CYCLE */
        IF V1500 = "e" THEN  LEAVE V1300LMAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F1500.

         /*  ---- Valid Check ---- START */

        find first pt_mstr where pt_domain = V1001 and pt_part = V1301  no-lock no-error.
If AVAILABLE ( pt_mstr ) then do:
 if pt_lot_ser='L' and V1500="" then do:

display skip "L控制，不能为空" @ WMESSAGE NO-LABEL with fram F1500.
                pause 0 before-hide.
                Undo, retry.
end.
end.
        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1500.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1500.
        pause 0.
        leave V1500L.
     END.
     IF INDEX(V1500,"@" ) <> 0 then V1500 = ENTRY(2,V1500,"@").
     PV1500 = V1500.
     /* END    LINE :1500  批号[LOT]  */


     /* START  LINE :1510  库位[LOC]  */
     V1510L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1510           as char format "x(150)".
        define variable PV1510          as char format "x(150)".
        define variable L15101          as char format "x(40)".
        define variable L15102          as char format "x(40)".
        define variable L15103          as char format "x(40)".
        define variable L15104          as char format "x(40)".
        define variable L15105          as char format "x(40)".
        define variable L15106          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        V1510 = substring(V1099,2,4).
        V1510 = ENTRY(1,V1510,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
         If sectionid > 1 Then 
        V1510 = PV1510 .
        V1510 = ENTRY(1,V1510,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */
                display "[生产回冲-有标签]"    + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1510 width 150 no-box.

                /* LABEL 1 - START */ 
                L15101 = "库位?" .
                display L15101          format "x(40)" skip with fram F1510 width 150 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                  L15102 = "" . 
                display L15102          format "x(40)" skip with fram F1510 width 150 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                  L15103 = "" . 
                display L15103          format "x(40)" skip with fram F1510 width 150 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L15104 = "" . 
                display L15104          format "x(40)" skip with fram F1510 width 150 no-box.
                /* LABEL 4 - END */ 
                display "输入或按E退出"       format "x(40)" skip
        skip with fram F1510 width 150 no-box.
        recid(LOC_MSTR) = ?.
        Update V1510
        WITH  fram F1510 NO-LABEL
        /* ROLL BAR START */
        EDITING:
        readkey pause wtimeout.
        if lastkey = -1 then quit.
        if LASTKEY = 404 Then Do: /* DISABLE F4 */
           pause 0 before-hide.
           undo, retry.
        end.
        display skip "^" @ WMESSAGE NO-LABEL with fram F1510.
            IF LASTKEY = keycode("F10") or keyfunction(lastkey) = "CURSOR-DOWN"
            THEN DO:
                  IF recid(LOC_MSTR) = ? THEN find first LOC_MSTR where 
                              LOC_DOMAIN = V1001 AND LOC_SITE = V1002 AND  
                              LOC_LOC >=  INPUT V1510
                               no-lock no-error.
                  else do: 
                       if LOC_LOC =  INPUT V1510
                       then find next LOC_MSTR
                       WHERE LOC_DOMAIN = V1001 AND LOC_SITE = V1002
                        no-lock no-error.
                        else find first LOC_MSTR where 
                              LOC_DOMAIN = V1001 AND LOC_SITE = V1002 AND  
                              LOC_LOC >=  INPUT V1510
                               no-lock no-error.
                  end.
                  IF AVAILABLE LOC_MSTR then display skip 
            LOC_LOC @ V1510 trim ( LOC_desc ) @ WMESSAGE NO-LABEL with fram F1510.
                  else   display skip "" @ WMESSAGE with fram F1510.
            END.
            IF LASTKEY = keycode("F9") or keyfunction(lastkey) = "CURSOR-UP"
            THEN DO:
                  IF recid(LOC_MSTR) = ? THEN find last LOC_MSTR where 
                              LOC_DOMAIN = V1001 AND LOC_SITE = V1002 AND  
                              LOC_LOC <=  INPUT V1510
                               no-lock no-error.
                  else do: 
                       if LOC_LOC =  INPUT V1510
                       then find prev LOC_MSTR
                       where LOC_DOMAIN = V1001 AND LOC_SITE = V1002
                        no-lock no-error.
                        else find first LOC_MSTR where 
                              LOC_DOMAIN = V1001 AND LOC_SITE = V1002 AND  
                              LOC_LOC >=  INPUT V1510
                               no-lock no-error.
                  end.
                  IF AVAILABLE LOC_MSTR then display skip 
            LOC_LOC @ V1510 trim ( LOC_desc ) @ WMESSAGE NO-LABEL with fram F1510.
                  else   display skip "" @ WMESSAGE with fram F1510.
            END.
            APPLY LASTKEY.
        END.
        /* ROLL BAR END */


        /* PRESS e EXIST CYCLE */
        IF V1510 = "e" THEN  LEAVE V1300LMAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F1510.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1510.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
        find first LOC_MSTR where LOC_DOMAIN = V1001 AND LOC_LOC = V1510 AND LOC_SITE = V1002  no-lock no-error.
        IF NOT AVAILABLE LOC_MSTR then do:
                display skip "Error , Retry." @ WMESSAGE NO-LABEL with fram F1510.
                pause 0 before-hide.
                undo, retry.
        end.
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1510.
        pause 0.
        leave V1510L.
     END.
     IF INDEX(V1510,"@" ) <> 0 then V1510 = ENTRY(2,V1510,"@").
     PV1510 = V1510.
     /* END    LINE :1510  库位[LOC]  */


     /* START  LINE :1600  完工数量[QTY]  */
     V1600L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1600           as char format "x(150)".
        define variable PV1600          as char format "x(150)".
        define variable L16001          as char format "x(40)".
        define variable L16002          as char format "x(40)".
        define variable L16003          as char format "x(40)".
        define variable L16004          as char format "x(40)".
        define variable L16005          as char format "x(40)".
        define variable L16006          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        V1600 = "0".
        V1600 = ENTRY(1,V1600,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1600 = ENTRY(1,V1600,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */
                display "[生产回冲-有标签]"    + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1600 width 150 no-box.

                /* LABEL 1 - START */ 
                L16001 = "完工数量?" .
                display L16001          format "x(40)" skip with fram F1600 width 150 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                L16002 = "件号:" + trim( V1300 ) .
                display L16002          format "x(40)" skip with fram F1600 width 150 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                L16003 = "线/批号:" + Trim(V1320) + "/" + Trim(V1500) .
                display L16003          format "x(40)" skip with fram F1600 width 150 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                L16004 = "库位:" + trim( V1510 ) .
                display L16004          format "x(40)" skip with fram F1600 width 150 no-box.
                /* LABEL 4 - END */ 
                display "输入或按E退出"       format "x(40)" skip
        skip with fram F1600 width 150 no-box.
        Update V1600
        WITH  fram F1600 NO-LABEL
        EDITING:
          readkey pause wtimeout.
          if lastkey = -1 Then quit.
        if LASTKEY = 404 Then Do: /* DISABLE F4 */
           pause 0 before-hide.
           undo, retry.
        end.
           apply lastkey.
        end.

        /* PRESS e EXIST CYCLE */
        IF V1600 = "e" THEN  LEAVE V1300LMAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F1600.

         /*  ---- Valid Check ---- START */

        {xsrepchk.p}
        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1600.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        If V1600 = "" OR V1600 = "-" OR V1600 = "." OR V1600 = ".-" OR V1600 = "-." then do:
                display skip "CAN NOT EMPTY  " @ WMESSAGE NO-LABEL with fram F1600.
                pause 0 before-hide.
                undo, retry.
        end.
        DO i = 1 to length(V1600).
                If index("0987654321.-", substring(V1600,i,1)) = 0 then do:
                display skip "Format  Error  " @ WMESSAGE NO-LABEL with fram F1600.
                pause 0 before-hide.
                undo, retry.
                end.
        end.
        /* CHECK FOR NUMBER VARIABLE  END */
        find first LD_DET where ( decimal(V1600) > 0 ) OR ( decimal(V1600) < 0 AND (ld_part  = V1301 AND ld_loc = V1510 and ld_domain = V1001 and  ld_site = V1002 AND ld_ref = "" AND  ld_lot = V1500 and
ld_site = V1002 and ld_ref = "" and  ld_QTY_oh + DECIMAL ( V1600 ) >= 0 ) )  no-lock no-error.
        IF NOT AVAILABLE LD_DET then do:
                display skip "该操作导致库存<0" @ WMESSAGE NO-LABEL with fram F1600.
                pause 0 before-hide.
                undo, retry.
        end.
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1600.
        pause 0.
        leave V1600L.
     END.
     PV1600 = V1600.
     /* END    LINE :1600  完工数量[QTY]  */


     /* START  LINE :1601  实际运行时间[Real Time]  */
     V1601L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1601           as char format "x(150)".
        define variable PV1601          as char format "x(150)".
        define variable L16011          as char format "x(40)".
        define variable L16012          as char format "x(40)".
        define variable L16013          as char format "x(40)".
        define variable L16014          as char format "x(40)".
        define variable L16015          as char format "x(40)".
        define variable L16016          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        V1601 = "0".
        V1601 = ENTRY(1,V1601,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1601 = ENTRY(1,V1601,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */
                display "[生产回冲-有标签]"    + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1601 width 150 no-box.

                /* LABEL 1 - START */ 
                L16011 = "实际运行时间?" .
                display L16011          format "x(40)" skip with fram F1601 width 150 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                  L16012 = "" . 
                display L16012          format "x(40)" skip with fram F1601 width 150 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                  L16013 = "" . 
                display L16013          format "x(40)" skip with fram F1601 width 150 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L16014 = "" . 
                display L16014          format "x(40)" skip with fram F1601 width 150 no-box.
                /* LABEL 4 - END */ 
                display "输入或按E退出"       format "x(40)" skip
        skip with fram F1601 width 150 no-box.
        Update V1601
        WITH  fram F1601 NO-LABEL
        EDITING:
          readkey pause wtimeout.
          if lastkey = -1 Then quit.
        if LASTKEY = 404 Then Do: /* DISABLE F4 */
           pause 0 before-hide.
           undo, retry.
        end.
           apply lastkey.
        end.

        /* PRESS e EXIST CYCLE */
        IF V1601 = "e" THEN  LEAVE V1300LMAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F1601.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1601.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        If V1601 = "" OR V1601 = "-" OR V1601 = "." OR V1601 = ".-" OR V1601 = "-." then do:
                display skip "CAN NOT EMPTY  " @ WMESSAGE NO-LABEL with fram F1601.
                pause 0 before-hide.
                undo, retry.
        end.
        DO i = 1 to length(V1601).
                If index("0987654321.-", substring(V1601,i,1)) = 0 then do:
                display skip "Format  Error  " @ WMESSAGE NO-LABEL with fram F1601.
                pause 0 before-hide.
                undo, retry.
                end.
        end.
        /* CHECK FOR NUMBER VARIABLE  END */
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1601.
        pause 0.
        leave V1601L.
     END.
     PV1601 = V1601.
     /* END    LINE :1601  实际运行时间[Real Time]  */


     /* START  LINE :1700  确认[CONFIRM]  */
     V1700L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1700           as char format "x(150)".
        define variable PV1700          as char format "x(150)".
        define variable L17001          as char format "x(40)".
        define variable L17002          as char format "x(40)".
        define variable L17003          as char format "x(40)".
        define variable L17004          as char format "x(40)".
        define variable L17005          as char format "x(40)".
        define variable L17006          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        V1700 = "Y".
        V1700 = ENTRY(1,V1700,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1700 = ENTRY(1,V1700,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */
                display "[生产回冲-有标签]"    + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1700 width 150 no-box.

                /* LABEL 1 - START */ 
                L17001 = "件号:" + trim(V1300) .
                display L17001          format "x(40)" skip with fram F1700 width 150 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                L17002 = "线/批号:" + Trim(V1320) + "/" + Trim(V1500) .
                display L17002          format "x(40)" skip with fram F1700 width 150 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                L17003 = "数量:" + trim(V1600) .
                display L17003          format "x(40)" skip with fram F1700 width 150 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                L17004 = "库位:" + trim( V1510 ) .
                display L17004          format "x(40)" skip with fram F1700 width 150 no-box.
                /* LABEL 4 - END */ 
                display "确认过帐[Y],E退出"   format "x(40)" skip
        skip with fram F1700 width 150 no-box.
        Update V1700
        WITH  fram F1700 NO-LABEL
        EDITING:
          readkey pause wtimeout.
          if lastkey = -1 Then quit.
        if LASTKEY = 404 Then Do: /* DISABLE F4 */
           pause 0 before-hide.
           undo, retry.
        end.
           apply lastkey.
        end.

        /* PRESS e EXIST CYCLE */
        IF V1700 = "e" THEN  LEAVE V1300LMAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F1700.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1700.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
        find first ld_det where decimal(V1600) > 0 OR ( decimal(V1600) < 0 AND (ld_part  = V1301 AND ld_domain = V1001 and ld_site = V1002 AND ld_ref = "" AND ld_loc = V1510 and ld_lot = V1500 and ld_domain = V1001 and ld_site = V1002 AND ld_ref = "" and  ld_QTY_oh + DECIMAL ( V1600 ) >= 0 ) )  NO-ERROR NO-WAIT.
        IF NOT AVAILABLE ld_det then do:
                display skip "无效或被锁!" @ WMESSAGE NO-LABEL with fram F1700.
                pause 0 before-hide.
                undo, retry.
        end.
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1700.
        pause 0.
        leave V1700L.
     END.
     PV1700 = V1700.
     /* END    LINE :1700  确认[CONFIRM]  */


     /* START  LINE :9000  BEFORE POST LAST TRANSACTION  */
     V9000L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V9000           as char format "x(150)".
        define variable PV9000          as char format "x(150)".
        define variable L90001          as char format "x(40)".
        define variable L90002          as char format "x(40)".
        define variable L90003          as char format "x(40)".
        define variable L90004          as char format "x(40)".
        define variable L90005          as char format "x(40)".
        define variable L90006          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        find last tr_hist where tr_domain = V1001 and tr_trnbr >= 0 no-lock no-error.
If AVAILABLE ( tr_hist ) then
        V9000 = string(tr_trnbr).
        V9000 = ENTRY(1,V9000,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V9000 = ENTRY(1,V9000,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */

        /* --FIRST TIME SKIP -- START  */
         if sectionid = 1 then leave V9000L.
        /* --FIRST TIME SKIP -- END  */


        /* --CYCLE TIME SKIP -- START  */
         if sectionid > 1 then leave V9000L .
        /* --CYCLE TIME SKIP -- END  */

                display "[生产回冲-有标签]"    + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F9000 width 150 no-box.

                /* LABEL 1 - START */ 
                  L90001 = "" . 
                display L90001          format "x(40)" skip with fram F9000 width 150 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                  L90002 = "" . 
                display L90002          format "x(40)" skip with fram F9000 width 150 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                  L90003 = "" . 
                display L90003          format "x(40)" skip with fram F9000 width 150 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L90004 = "" . 
                display L90004          format "x(40)" skip with fram F9000 width 150 no-box.
                /* LABEL 4 - END */ 
                display "输入或按E退出"       format "x(40)" skip
        skip with fram F9000 width 150 no-box.
        /* DISPLAY ONLY */
        define variable X9000           as char format "x(40)".
        X9000 = V9000.
        V9000 = "".
        /* DISPLAY ONLY */
        Update V9000
        WITH  fram F9000 NO-LABEL
        EDITING:
          readkey pause wtimeout.
          if lastkey = -1 Then quit.
        if LASTKEY = 404 Then Do: /* DISABLE F4 */
           pause 0 before-hide.
           undo, retry.
        end.
           apply lastkey.
        end.
        V9000 = X9000.
        /* DISPLAY ONLY */
        LEAVE V9000L.
        /* DISPLAY ONLY */

        /* PRESS e EXIST CYCLE */
        IF V9000 = "e" THEN  LEAVE V1300LMAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F9000.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F9000.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F9000.
        pause 0.
        leave V9000L.
     END.
     PV9000 = V9000.
     /* END    LINE :9000  BEFORE POST LAST TRANSACTION  */


        display "...PROCESSING...  " NO-LABEL with fram F9000X width 150 no-box.
        pause 0.
     /*  Update MFG/PRO START  */ 
      ts_mfguser = V1300. /* ching add */ 
     {xsrep08u.i}
     /*  Update MFG/PRO END  */ 
        display  "" NO-LABEL with fram F9000X width 150 no-box .
        pause 0.
     /* START  LINE :9010  OK  */
     V9010L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V9010           as char format "x(150)".
        define variable PV9010          as char format "x(150)".
        define variable L90101          as char format "x(40)".
        define variable L90102          as char format "x(40)".
        define variable L90103          as char format "x(40)".
        define variable L90104          as char format "x(40)".
        define variable L90105          as char format "x(40)".
        define variable L90106          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        V9010 = "Y".
        V9010 = ENTRY(1,V9010,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V9010 = ENTRY(1,V9010,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */
                display "[生产回冲-有标签]"    + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F9010 width 150 no-box.

                /* LABEL 1 - START */ 
                  L90101 = "" . 
                display L90101          format "x(40)" skip with fram F9010 width 150 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                  L90102 = "" . 
                display L90102          format "x(40)" skip with fram F9010 width 150 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                /* SS - 20070318.1 - B */     
           		   ASSIGN trnbr = INTEGER(ts_mfguser) NO-ERROR.
		    IF ERROR-STATUS:ERROR THEN DO:
		       ASSIGN trnbr = 0.
		    END.


                  /* LABEL 2 - START */ 
 find last tr_hist where tr_trnbr = trnbr 
		                 and tr_domain = V1001 
				 /*AND tr_user2 = V1300*/
 		                 AND tr_program = "xsrep08.p"
				 and  (tr_type = "iss-wo" or tr_type = "rct-wo")
				 and tr_site = V1002  				 
				 /*and  tr_part = V1301 
				 and tr_serial = V1500*/
				   USE-INDEX tr_trnbr
			        NO-LOCK 
			        NO-ERROR.
				IF AVAILABLE tr_hist THEN DO:

				               L90101 = "交易已提交".
				    END.
				    ELSE DO:
				       L90101 = "".
				    END.
				    DISP 
				       L90101 FORMAT "x(40)" 
				       SKIP 
				       WITH FRAME F9010 NO-BOX.
				    If AVAILABLE ( tr_hist ) then do:
			 L90102 = "交易号:" + trim(string(tr_trnbr)) .               
				       L90103 = "" .
				    End.
				    ELSE DO:
				       L90102 = "" .
				       L90103 = "交易提交失败 " .
				    END.	    
				 Display 
				    L90102          format "x(40)" skip 
				    L90103          format "x(40)" skip 
				    with fram F9010 no-box.

                              If L90103<>"" then
				/* SS - 20070318.1 - E */
                L90103 = L90103 .
                else L90103 = "" . 
                display L90103          format "x(40)" skip with fram F9010 width 150 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                L90104 = "按Y继续,E退出" .
                display L90104          format "x(40)" skip with fram F9010 width 150 no-box.
                /* LABEL 4 - END */ 
                display "输入或按E退出"       format "x(40)" skip
        skip with fram F9010 width 150 no-box.
        Update V9010
        WITH  fram F9010 NO-LABEL
        EDITING:
          readkey pause wtimeout.
          if lastkey = -1 Then quit.
        if LASTKEY = 404 Then Do: /* DISABLE F4 */
           pause 0 before-hide.
           undo, retry.
        end.
           apply lastkey.
        end.

        /* PRESS e EXIST CYCLE */
        IF V9010 = "e" THEN  LEAVE V1300LMAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F9010.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F9010.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
        IF not trim(V9010) = "Y" THEN DO:
                display skip "Error , Retry " @ WMESSAGE NO-LABEL with fram F9010.
                pause 0 before-hide.
                undo, retry.
        end.
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F9010.
        pause 0.
        leave V9010L.
     END.
     PV9010 = V9010.
     /* END    LINE :9010  OK  */


   /* Without Condition Exit Cycle Start */ 
   LEAVE V1300LMAINLOOP.
   /* Without Condition Exit Cycle END */ 
   /* Internal Cycle END :9010    */
   END.
   pause 0 before-hide.
end.
