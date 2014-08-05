/* Generate By Barcode Generator , Copyright by Softspeed - Build By Sam Song  */
/* SO SHIPMENT */
/* Generate date / time  2014/7/21 17:28:09 */
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
define input PARAMETER sysptr as int .
DEFINE VARIABLE trnbr AS INTEGER.
DEFINE NEW GLOBAL SHARED VARIABLE mfguser AS CHARACTER.
DEFINE NEW GLOBAL SHARED VARIABLE ts_mfguser AS CHARACTER.
define  variable t_v100  as char EXTENT 15 .
define  variable tki  as integer .
define  variable tkj  as integer .
define  variable tkstr  as char .
define variable vfg as char.
define shared variable xsnvarfsto  as char no-undo .
define shared variable xsnvarsecs  as char no-undo .
define variable V1300           as char format "x(150)".
xsnvarfsto = "Now Begin".
xsnvarsecs = "Wait For End".

define variable wtimeout as integer init 99999 .
find first code_mstr where code_fldname = "BARCODE" AND CODE_value ="wtimeout"
 and can-find ( first dom_mstr where  dom_type = "SYSTEM " and dom_domain = code_domain and dom_active = yes )
 no-lock no-error. /*  Timeout - All Level */
if AVAILABLE(code_mstr) Then wtimeout = 60 * decimal(code_cmmt).
find first code_mstr where code_fldname = "BARCODE" AND CODE_value ="xssoi12wtimeout"
 and can-find ( first dom_mstr where  dom_type = "SYSTEM " and dom_domain = code_domain and dom_active = yes )
 no-lock no-error. /*  Timeout - All Level */
if AVAILABLE(code_mstr) Then wtimeout = 60 * decimal(code_cmmt).

define shared var xsnewmsg as char no-undo.
xsnewmsg = "now running".
PROCEDURE CheckSecuritied:
          define var usrwdate as date.
          define var curdate as date .
          define var nowdate as date .
          define var curtime as int .
          define var currec like tr_trnbr .
          curdate = today.
          curtime = time.
          nowdate = today.
          usrwdate = 02/16/12.
          find first usrw_wkfl where usrw_key1 = "BARCODE" and usrw_key2 = "LICENSEKEY"  and usrw_domain = "PDC"
              no-lock no-error.
          if avail usrw_wkfl then do:
            usrwdate = usrw_datefld[1].
            if usrw_datefld[1] = ?  then       usrwdate  = 02/16/12.
            if usrw_charfld[3] <> encode("SS" + string(year(usrw_datefld[1])) + string(month(usrw_datefld[1])) + string(day(usrw_datefld[1]))) then usrwdate = 02/16/12.
          end.
          release usrw_wkfl.
          for last tr_hist no-lock where tr_domain = "PDC" use-index tr_trnbr:
            currec = tr_trnbr.
          end.
          for last tr_hist no-lock where tr_domain = "PDC" and tr_trnbr < (currec - 20000)  use-index tr_trnbr:
            nowdate = tr_date.
          end.
          if  (nowdate - usrwdate) < 30  then usrwdate = nowdate - 30 .
          if  program-name(2) = "xsinv45.p" then usrwdate = usrwdate + 60 .
          if  usrwdate < nowdate then do:
            do on end-key undo,retry:
              do while ((today - curdate) * 3600 * 24 + time - curtime) < ((nowdate - usrwdate) / 30) :
                pause 0 no-message.
              end.
            end.
          end.
end.
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
        define temp-table tmplot
                fields sn as integer
                fields lot as character
                fields qty as decimal
                fields trid like tr_trnbr
                index sn is primary sn.
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
                display "[销售发货二维码]"     + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1002 width 150 no-box.

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

   /* Internal Cycle Input :1320    */
   V1320LMAINLOOP:
   REPEAT:     
     /* START  LINE :1003  库位[LOC]  */
     V1003L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1003           as char format "x(150)".
        define variable PV1003          as char format "x(150)".
        define variable L10031          as char format "x(40)".
        define variable L10032          as char format "x(40)".
        define variable L10033          as char format "x(40)".
        define variable L10034          as char format "x(40)".
        define variable L10035          as char format "x(40)".
        define variable L10036          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        V1003 = " ".
        V1003 = ENTRY(1,V1003,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1003 = ENTRY(1,V1003,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */
                display "[销售发货二维码]"     + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1003 width 150 no-box.

                /* LABEL 1 - START */
                L10031 = "库位?" .
                display L10031          format "x(40)" skip with fram F1003 width 150 no-box.
                /* LABEL 1 - END */


                /* LABEL 2 - START */
                  L10032 = "" .
                display L10032          format "x(40)" skip with fram F1003 width 150 no-box.
                /* LABEL 2 - END */


                /* LABEL 3 - START */
                  L10033 = "" .
                display L10033          format "x(40)" skip with fram F1003 width 150 no-box.
                /* LABEL 3 - END */


                /* LABEL 4 - START */
                  L10034 = "" .
                display L10034          format "x(40)" skip with fram F1003 width 150 no-box.
                /* LABEL 4 - END */
                display "输入或按E退出"       format "x(40)" skip
        skip with fram F1003 width 150 no-box.
        recid(LOC_MSTR) = ?.
        Update V1003
        WITH  fram F1003 NO-LABEL
        /* ROLL BAR START */
        EDITING:
        readkey pause wtimeout.
        if lastkey = -1 then quit.
        if LASTKEY = 404 Then Do: /* DISABLE F4 */
           pause 0 before-hide.
           undo, retry.
        end.
        display skip "^" @ WMESSAGE NO-LABEL with fram F1003.
            IF LASTKEY = keycode("F10") or keyfunction(lastkey) = "CURSOR-DOWN"
            THEN DO:
                  IF recid(LOC_MSTR) = ? THEN find first LOC_MSTR where
                              LOC_DOMAIN = V1001 AND LOC_SITE = V1002 AND
                              LOC_LOC >=  INPUT V1003
                               no-lock no-error.
                  else do:
                       if LOC_LOC =  INPUT V1003
                       then find next LOC_MSTR
                       WHERE LOC_DOMAIN = V1001 AND LOC_SITE = V1002
                        no-lock no-error.
                        else find first LOC_MSTR where
                              LOC_DOMAIN = V1001 AND LOC_SITE = V1002 AND
                              LOC_LOC >=  INPUT V1003
                               no-lock no-error.
                  end.
                  IF AVAILABLE LOC_MSTR then display skip
            LOC_LOC @ V1003 LOC_DESC @ WMESSAGE NO-LABEL with fram F1003.
                  else   display skip "" @ WMESSAGE with fram F1003.
            END.
            IF LASTKEY = keycode("F9") or keyfunction(lastkey) = "CURSOR-UP"
            THEN DO:
                  IF recid(LOC_MSTR) = ? THEN find last LOC_MSTR where
                              LOC_DOMAIN = V1001 AND LOC_SITE = V1002 AND
                              LOC_LOC <=  INPUT V1003
                               no-lock no-error.
                  else do:
                       if LOC_LOC =  INPUT V1003
                       then find prev LOC_MSTR
                       where LOC_DOMAIN = V1001 AND LOC_SITE = V1002
                        no-lock no-error.
                        else find first LOC_MSTR where
                              LOC_DOMAIN = V1001 AND LOC_SITE = V1002 AND
                              LOC_LOC >=  INPUT V1003
                               no-lock no-error.
                  end.
                  IF AVAILABLE LOC_MSTR then display skip
            LOC_LOC @ V1003 LOC_DESC @ WMESSAGE NO-LABEL with fram F1003.
                  else   display skip "" @ WMESSAGE with fram F1003.
            END.
            APPLY LASTKEY.
        END.
        /* ROLL BAR END */


        /* PRESS e EXIST CYCLE */
        IF V1003 = "e" THEN  LEAVE MAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F1003.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1003.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
        find first LOC_MSTR where LOC_DOMAIN = V1001 AND LOC_LOC = V1003 AND LOC_SITE = V1002  no-lock no-error.
        IF NOT AVAILABLE LOC_MSTR then do:
                display skip "Error , Retry." @ WMESSAGE NO-LABEL with fram F1003.
                pause 0 before-hide.
                undo, retry.
        end.
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1003.
        pause 0.
        leave V1003L.
     END.
     PV1003 = V1003.
     /* END    LINE :1003  库位[LOC]  */


     /* START  LINE :1010  生效日期  */
     V1010L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1010           as char format "x(150)".
        define variable PV1010          as char format "x(150)".
        define variable L10101          as char format "x(40)".
        define variable L10102          as char format "x(40)".
        define variable L10103          as char format "x(40)".
        define variable L10104          as char format "x(40)".
        define variable L10105          as char format "x(40)".
        define variable L10106          as char format "x(40)".
        define variable D1010           as date .
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        V1010 = string(today).
        D1010 = Date ( V1010).
        V1010 = ENTRY(1,V1010,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
         If sectionid > 1 Then
        V1010 = PV1010 .
         If sectionid > 1 Then
        D1010 = Date ( V1010).
        V1010 = ENTRY(1,V1010,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */

        /* --CYCLE TIME SKIP -- START  */
         if sectionid > 1 then leave V1010L .
        /* --CYCLE TIME SKIP -- END  */

                display "[销售发货二维码]"     + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1010 width 150 no-box.

                /* LABEL 1 - START */
                L10101 = "生效日期?" .
                display L10101          format "x(40)" skip with fram F1010 width 150 no-box.
                /* LABEL 1 - END */


                /* LABEL 2 - START */
                  L10102 = "" .
                display L10102          format "x(40)" skip with fram F1010 width 150 no-box.
                /* LABEL 2 - END */


                /* LABEL 3 - START */
                  L10103 = "" .
                display L10103          format "x(40)" skip with fram F1010 width 150 no-box.
                /* LABEL 3 - END */


                /* LABEL 4 - START */
                  L10104 = "" .
                display L10104          format "x(40)" skip with fram F1010 width 150 no-box.
                /* LABEL 4 - END */
                display "输入或按E退出"       format "x(40)" skip
        skip with fram F1010 width 150 no-box.
        Update D1010
        WITH  fram F1010 NO-LABEL
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
        IF V1010 = "e" THEN  LEAVE MAINLOOP.
        V1010 = string ( D1010).
        display  skip WMESSAGE NO-LABEL with fram F1010.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1010.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1010.
        pause 0.
        leave V1010L.
     END.
     PV1010 = V1010.
     /* END    LINE :1010  生效日期  */


     /* START  LINE :1050  发货单号  */
     V1050L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1050           as char format "x(150)".
        define variable PV1050          as char format "x(150)".
        define variable L10501          as char format "x(40)".
        define variable L10502          as char format "x(40)".
        define variable L10503          as char format "x(40)".
        define variable L10504          as char format "x(40)".
        define variable L10505          as char format "x(40)".
        define variable L10506          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1050 = ENTRY(1,V1050,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        if sectionid > 1 then leave V1050L .
        Define var xxthdate as date.
        Xxthdate = today.
        V1050 = "SH" + string(year(xxthdate)) + fill("0",2 - length(string(month(xxthdate)))) + string(month(xxthdate))
           + fill("0",2 - length(string(day(xxthdate)))) + string(day(xxthdate)) + "0001".
        Find first code_mstr where code_domain = V1001 and code_fldname = "BarCodeSHPar" and code_value = "AutoNum" no-error.
           If not avail code_mstr then do:
             create code_mstr .
             Assign
                code_domain  = wDefDomain
                code_fldname = "BarCodeSHPar"
                code_value   = "AutoNum"
                code_cmmt    = V1050.
           end.
                 IF V1050 < code_cmmt then V1050 = code_cmmt.
           Code_cmmt = substring(V1050,1,10) + fill("0",4 - length(string(int(substring(V1050,11,4))) )) + string(int(substring(V1050,11,4)) + 1).
           Release code_mstr.
         If 1=1 then
        leave V1050L.
        /* LOGICAL SKIP END */

        /* --CYCLE TIME SKIP -- START  */
         if sectionid > 1 then leave V1050L .
        /* --CYCLE TIME SKIP -- END  */

                display "[销售发货二维码]"     + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1050 width 150 no-box.

                /* LABEL 1 - START */
                  L10501 = "" .
                display L10501          format "x(40)" skip with fram F1050 width 150 no-box.
                /* LABEL 1 - END */


                /* LABEL 2 - START */
                  L10502 = "" .
                display L10502          format "x(40)" skip with fram F1050 width 150 no-box.
                /* LABEL 2 - END */


                /* LABEL 3 - START */
                  L10503 = "" .
                display L10503          format "x(40)" skip with fram F1050 width 150 no-box.
                /* LABEL 3 - END */


                /* LABEL 4 - START */
                  L10504 = "" .
                display L10504          format "x(40)" skip with fram F1050 width 150 no-box.
                /* LABEL 4 - END */
                display "输入或按E退出"       format "x(40)" skip
        skip with fram F1050 width 150 no-box.
        Update V1050
        WITH  fram F1050 NO-LABEL
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
        IF V1050 = "e" THEN  LEAVE MAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F1050.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1050.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1050.
        pause 0.
        leave V1050L.
     END.
     PV1050 = V1050.
     /* END    LINE :1050  发货单号  */


     /* START  LINE :1100  销售订单[SalesOrder]  */
     V1100L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1100           as char format "x(150)".
        define variable PV1100          as char format "x(150)".
        define variable L11001          as char format "x(40)".
        define variable L11002          as char format "x(40)".
        define variable L11003          as char format "x(40)".
        define variable L11004          as char format "x(40)".
        define variable L11005          as char format "x(40)".
        define variable L11006          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        V1100 = " ".
        V1100 = ENTRY(1,V1100,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1100 = ENTRY(1,V1100,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */
                display "[销售发货二维码]"     + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1100 width 150 no-box.

                /* LABEL 1 - START */
                L11001 = "销售订单?" .
                display L11001          format "x(40)" skip with fram F1100 width 150 no-box.
                /* LABEL 1 - END */


                /* LABEL 2 - START */
                L11002 = "发货单号:" + V1050 .
                display L11002          format "x(40)" skip with fram F1100 width 150 no-box.
                /* LABEL 2 - END */


                /* LABEL 3 - START */
                  L11003 = "" .
                display L11003          format "x(40)" skip with fram F1100 width 150 no-box.
                /* LABEL 3 - END */


                /* LABEL 4 - START */
                  L11004 = "" .
                display L11004          format "x(40)" skip with fram F1100 width 150 no-box.
                /* LABEL 4 - END */
                display "输入或按E退出"       format "x(40)" skip
        skip with fram F1100 width 150 no-box.
        recid(SO_MSTR) = ?.
        Update V1100
        WITH  fram F1100 NO-LABEL
        /* ROLL BAR START */
        EDITING:
        readkey pause wtimeout.
        if lastkey = -1 then quit.
        if LASTKEY = 404 Then Do: /* DISABLE F4 */
           pause 0 before-hide.
           undo, retry.
        end.
        display skip "^" @ WMESSAGE NO-LABEL with fram F1100.
            IF LASTKEY = keycode("F10") or keyfunction(lastkey) = "CURSOR-DOWN"
            THEN DO:
                  IF recid(SO_MSTR) = ? THEN find first SO_MSTR where
                              SO_DOMAIN = V1001 AND ( SO_SITE = "" OR SO_SITE = V1002 ) AND
                              SO_NBR >=  INPUT V1100
                               no-lock no-error.
                  else do:
                       if SO_NBR =  INPUT V1100
                       then find next SO_MSTR
                       WHERE SO_DOMAIN = V1001 AND ( SO_SITE = "" OR SO_SITE = V1002 )
                        no-lock no-error.
                        else find first SO_MSTR where
                              SO_DOMAIN = V1001 AND ( SO_SITE = "" OR SO_SITE = V1002 ) AND
                              SO_NBR >=  INPUT V1100
                               no-lock no-error.
                  end.
                  IF AVAILABLE SO_MSTR then display skip
            SO_NBR @ V1100 trim( SO_PO ) + "*" + string ( so_due_date ) @ WMESSAGE NO-LABEL with fram F1100.
                  else   display skip "" @ WMESSAGE with fram F1100.
            END.
            IF LASTKEY = keycode("F9") or keyfunction(lastkey) = "CURSOR-UP"
            THEN DO:
                  IF recid(SO_MSTR) = ? THEN find last SO_MSTR where
                              SO_DOMAIN = V1001 AND ( SO_SITE = "" OR SO_SITE = V1002 ) AND
                              SO_NBR <=  INPUT V1100
                               no-lock no-error.
                  else do:
                       if SO_NBR =  INPUT V1100
                       then find prev SO_MSTR
                       where SO_DOMAIN = V1001 AND ( SO_SITE = "" OR SO_SITE = V1002 )
                        no-lock no-error.
                        else find first SO_MSTR where
                              SO_DOMAIN = V1001 AND ( SO_SITE = "" OR SO_SITE = V1002 ) AND
                              SO_NBR >=  INPUT V1100
                               no-lock no-error.
                  end.
                  IF AVAILABLE SO_MSTR then display skip
            SO_NBR @ V1100 trim( SO_PO ) + "*" + string ( so_due_date ) @ WMESSAGE NO-LABEL with fram F1100.
                  else   display skip "" @ WMESSAGE with fram F1100.
            END.
            APPLY LASTKEY.
        END.
        /* ROLL BAR END */


        /* PRESS e EXIST CYCLE */
        IF V1100 = "e" THEN  LEAVE MAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F1100.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1100.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
        find first SO_MSTR where SO_DOMAIN = V1001 AND SO_NBR = V1100 AND ( SO_SITE = V1002 OR SO_SITE = "" )  NO-ERROR NO-WAIT.
        IF NOT AVAILABLE SO_MSTR then do:
                display skip "无效或被锁!" @ WMESSAGE NO-LABEL with fram F1100.
                pause 0 before-hide.
                undo, retry.
        end.
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1100.
        pause 0.
        leave V1100L.
     END.
     PV1100 = V1100.
     /* END    LINE :1100  销售订单[SalesOrder]  */


     /* START  LINE :1105  客户代码[Customer Code]  */
     V1105L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1105           as char format "x(150)".
        define variable PV1105          as char format "x(150)".
        define variable L11051          as char format "x(40)".
        define variable L11052          as char format "x(40)".
        define variable L11053          as char format "x(40)".
        define variable L11054          as char format "x(40)".
        define variable L11055          as char format "x(40)".
        define variable L11056          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        find first so_mstr where so_domain = V1001 and so_nbr  = V1100 no-lock no-error.
If AVAILABLE ( so_mstr ) then
        V1105 = so_cust.
        V1105 = ENTRY(1,V1105,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1105 = ENTRY(1,V1105,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */

        /* --FIRST TIME SKIP -- START  */
         if sectionid = 1 then leave V1105L.
        /* --FIRST TIME SKIP -- END  */


        /* --CYCLE TIME SKIP -- START  */
         if sectionid > 1 then leave V1105L .
        /* --CYCLE TIME SKIP -- END  */

                display "[销售发货二维码]"     + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1105 width 150 no-box.

                /* LABEL 1 - START */
                  L11051 = "" .
                display L11051          format "x(40)" skip with fram F1105 width 150 no-box.
                /* LABEL 1 - END */


                /* LABEL 2 - START */
                  L11052 = "" .
                display L11052          format "x(40)" skip with fram F1105 width 150 no-box.
                /* LABEL 2 - END */


                /* LABEL 3 - START */
                  L11053 = "" .
                display L11053          format "x(40)" skip with fram F1105 width 150 no-box.
                /* LABEL 3 - END */


                /* LABEL 4 - START */
                  L11054 = "" .
                display L11054          format "x(40)" skip with fram F1105 width 150 no-box.
                /* LABEL 4 - END */
                display "输入或按E退出"       format "x(40)" skip
        skip with fram F1105 width 150 no-box.
        Update V1105
        WITH  fram F1105 NO-LABEL
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
        IF V1105 = "e" THEN  LEAVE MAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F1105.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1105.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1105.
        pause 0.
        leave V1105L.
     END.
     PV1105 = V1105.
     /* END    LINE :1105  客户代码[Customer Code]  */


     /* START  LINE :1110  订单项次  */
     V1110L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1110           as char format "x(150)".
        define variable PV1110          as char format "x(150)".
        define variable L11101          as char format "x(40)".
        define variable L11102          as char format "x(40)".
        define variable L11103          as char format "x(40)".
        define variable L11104          as char format "x(40)".
        define variable L11105          as char format "x(40)".
        define variable L11106          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        find first sod_det where sod_domain = V1001 and sod_nbr = V1100 and sod_site = V1002 and sod_confirm no-lock no-error.
If AVAILABLE (sod_det) and string ( sod_line ) <> V1110 then
        V1110 = string (sod_line ).
        V1110 = ENTRY(1,V1110,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1110 = ENTRY(1,V1110,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        find last sod_det where sod_domain = V1001 and sod_nbr = V1100 and sod_site = V1002 and sod_confirm no-lock no-error.
If AVAILABLE (sod_det) and string ( sod_line ) = V1110 then
        leave V1110L.
        /* LOGICAL SKIP END */
                display "[销售发货二维码]"     + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1110 width 150 no-box.

                /* LABEL 1 - START */
                L11101 = "订单项次?" .
                display L11101          format "x(40)" skip with fram F1110 width 150 no-box.
                /* LABEL 1 - END */


                /* LABEL 2 - START */
                L11102 = "发货单号:" + V1050 .
                display L11102          format "x(40)" skip with fram F1110 width 150 no-box.
                /* LABEL 2 - END */


                /* LABEL 3 - START */
                  L11103 = "" .
                display L11103          format "x(40)" skip with fram F1110 width 150 no-box.
                /* LABEL 3 - END */


                /* LABEL 4 - START */
                  L11104 = "" .
                display L11104          format "x(40)" skip with fram F1110 width 150 no-box.
                /* LABEL 4 - END */
                display "输入或按E退出"       format "x(40)" skip
        skip with fram F1110 width 150 no-box.
        recid(SOD_DET) = ?.
        Update V1110
        WITH  fram F1110 NO-LABEL
        /* ROLL BAR START */
        EDITING:
        readkey pause wtimeout.
        if lastkey = -1 then quit.
        if LASTKEY = 404 Then Do: /* DISABLE F4 */
           pause 0 before-hide.
           undo, retry.
        end.
        display skip "^" @ WMESSAGE NO-LABEL with fram F1110.
            IF LASTKEY = keycode("F10") or keyfunction(lastkey) = "CURSOR-DOWN"
            THEN DO:
                  IF recid(SOD_DET) = ? THEN find first SOD_DET where
                              sod_domain = V1001 AND sod_nbr = V1100 and sod_site = V1002 and sod_confirm AND
                              string ( SOD_LINE ) >=  INPUT V1110
                               no-lock no-error.
                  else do:
                       if string ( SOD_LINE ) =  INPUT V1110
                       then find next SOD_DET
                       WHERE sod_domain = V1001 AND sod_nbr = V1100 and sod_site = V1002 and sod_confirm
                        no-lock no-error.
                        else find first SOD_DET where
                              sod_domain = V1001 AND sod_nbr = V1100 and sod_site = V1002 and sod_confirm AND
                              string ( SOD_LINE ) >=  INPUT V1110
                               no-lock no-error.
                  end.
                  IF AVAILABLE SOD_DET then display skip
            string ( SOD_LINE ) @ V1110 trim(SOD_PART) + "*" + String( SOD_DUE_DATE) @ WMESSAGE NO-LABEL with fram F1110.
                  else   display skip "" @ WMESSAGE with fram F1110.
            END.
            IF LASTKEY = keycode("F9") or keyfunction(lastkey) = "CURSOR-UP"
            THEN DO:
                  IF recid(SOD_DET) = ? THEN find last SOD_DET where
                              sod_domain = V1001 AND sod_nbr = V1100 and sod_site = V1002 and sod_confirm AND
                              string ( SOD_LINE ) <=  INPUT V1110
                               no-lock no-error.
                  else do:
                       if string ( SOD_LINE ) =  INPUT V1110
                       then find prev SOD_DET
                       where sod_domain = V1001 AND sod_nbr = V1100 and sod_site = V1002 and sod_confirm
                        no-lock no-error.
                        else find first SOD_DET where
                              sod_domain = V1001 AND sod_nbr = V1100 and sod_site = V1002 and sod_confirm AND
                              string ( SOD_LINE ) >=  INPUT V1110
                               no-lock no-error.
                  end.
                  IF AVAILABLE SOD_DET then display skip
            string ( SOD_LINE ) @ V1110 trim(SOD_PART) + "*" + String( SOD_DUE_DATE) @ WMESSAGE NO-LABEL with fram F1110.
                  else   display skip "" @ WMESSAGE with fram F1110.
            END.
            APPLY LASTKEY.
        END.
        /* ROLL BAR END */


        /* PRESS e EXIST CYCLE */
        IF V1110 = "e" THEN  LEAVE MAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F1110.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1110.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
        find first SOD_DET where SOD_DOMAIN = V1001 AND SOD_NBR = V1100 AND string ( sod_line ) = V1110 and SOD_SITE = V1002 and sod_confirm  NO-ERROR NO-WAIT.
        IF NOT AVAILABLE SOD_DET then do:
                display skip "无效或被锁!" @ WMESSAGE NO-LABEL with fram F1110.
                pause 0 before-hide.
                undo, retry.
        end.
        else do:
             assign vfg = sod_part.
        end.
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1110.
        pause 0.
        leave V1110L.
     END.
     PV1110 = V1110.
     /* END    LINE :1110  订单项次  */


     /* START  LINE :1200  成品[Finished Goods]  */
     V1200L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1200           as char format "x(150)".
        define variable PV1200          as char format "x(150)".
        define variable L12001          as char format "x(40)".
        define variable L12002          as char format "x(40)".
        define variable L12003          as char format "x(40)".
        define variable L12004          as char format "x(40)".
        define variable L12005          as char format "x(40)".
        define variable L12006          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */
        /* --FIRST TIME DEFAULT  VALUE -- START  */
        V1200 = ENTRY(1,V1200,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1200 = ENTRY(1,V1200,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */
                display "[销售发货二维码]"     + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1200 width 150 no-box.

                /* LABEL 1 - START */
                find first sod_det where sod_domain = V1001 and  sod_nbr = V1100 and sod_line = integer(V1110)  no-lock no-error.
If AVAILABLE ( sod_det ) then
                L12001 = "成品:" + trim(sod_part) .
                else L12001 = "" .
                display L12001          format "x(40)" skip with fram F1200 width 150 no-box.
                /* LABEL 1 - END */


                /* LABEL 2 - START */
                find first so_mstr where  so_domain = V1001 and so_nbr = V1100 no-lock no-error.
If AVAILABLE ( so_mstr ) then
                L12002 = "PO #:" + trim ( so_po ) .
                else L12002 = "" .
                display L12002          format "x(40)" skip with fram F1200 width 150 no-box.
                /* LABEL 2 - END */


                /* LABEL 3 - START */
                find first so_mstr where so_domain = V1001 and so_nbr = V1100 no-lock no-error.
If AVAILABLE ( so_mstr ) then
                L12003 = "客户:" + trim ( so_cust ) .
                else L12003 = "" .
                display L12003          format "x(40)" skip with fram F1200 width 150 no-box.
                /* LABEL 3 - END */


                /* LABEL 4 - START */
                L12004 = "项次:" + trim(V1110) .
                display L12004          format "x(40)" skip with fram F1200 width 150 no-box.
                /* LABEL 4 - END */
                display "输入或按E退出"       format "x(40)" skip
        skip with fram F1200 width 150 no-box.
        Update V1200
        WITH  fram F1200 NO-LABEL
        EDITING:
          readkey pause wtimeout.
          if lastkey = -1 Then quit.
        if LASTKEY = 404 Then Do: /* DISABLE F4 */
           pause 0 before-hide.
           undo, retry.
        end.
           apply lastkey.
        end.
        v1300 = V1200.
        empty temp-table tmplot no-error.
        Define variable vvi as integer.
        Do vvi = 1 to 3:
           if entry(vvi * 2,v1300,"@") <> "" then do:
              create tmplot.
              Assign sn = vvi
                     lot = entry(vvi * 2,v1300,"@")
                     qty = decimal(entry(vvi * 2 + 1,v1300,"@")).
           End.
        End.
        V1200 = ENTRY(1,v1300,"@").
        /* PRESS e EXIST CYCLE */
        IF V1200 = "e" THEN  LEAVE MAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F1200.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1200.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
        find first SOD_DET where SOD_DOMAIN = V1001 AND SOD_NBR = V1100 AND SOD_LINE = integer ( V1110 ) AND SOD_PART = ENTRY(1, V1200, "@")  no-lock no-error.
        IF NOT AVAILABLE SOD_DET then do:
                display skip "该成品不匹配,请查核!" @ WMESSAGE NO-LABEL with fram F1200.
                pause 0 before-hide.
                undo, retry.
        end.
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1200.
        pause 0.
        leave V1200L.
     END.
     PV1200 = V1200.
     /* END    LINE :1200  成品[Finished Goods]  */


     /* START  LINE :1300  二维码  */
     V1300L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.

        define variable PV1300          as char format "x(150)".
        define variable L13001          as char format "x(40)".
        define variable L13002          as char format "x(40)".
        define variable L13003          as char format "x(40)".
        define variable L13004          as char format "x(40)".
        define variable L13005          as char format "x(40)".
        define variable L13006          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */

         leave V1300L.
        /* --FIRST TIME DEFAULT  VALUE -- START  */
        V1300 = " ".
        V1300 = ENTRY(1,V1300,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1300 = ENTRY(1,V1300,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */
                display "[销售发货二维码]"     + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1300 width 150 no-box.

                /* LABEL 1 - START */
                L13001 = "请扫描二维码" .
                display L13001          format "x(40)" skip with fram F1300 width 150 no-box.
                /* LABEL 1 - END */


                /* LABEL 2 - START */
                L13002 = "销售订单" + V1100 .
                display L13002          format "x(40)" skip with fram F1300 width 150 no-box.
                /* LABEL 2 - END */


                /* LABEL 3 - START */
                L13003 = "订单项次:" + V1110 .
                display L13003          format "x(40)" skip with fram F1300 width 150 no-box.
                /* LABEL 3 - END */


                /* LABEL 4 - START */
                L13004 = "物料:" + trim( V1300 ) .
                display L13004          format "x(40)" skip with fram F1300 width 150 no-box.
                /* LABEL 4 - END */
                display "输入或按E退出"       format "x(40)" skip
        skip with fram F1300 width 150 no-box.
        Update V1300
        WITH  fram F1300 NO-LABEL
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
        IF V1300 = "e" THEN  LEAVE MAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F1300.

         /*  ---- Valid Check ---- START */

        empty temp-table tmplot no-error.
        Do vvi = 1 to 3:
           if entry(vvi * 2,v1300,"@") <> "" then do:
              create tmplot.
              Assign sn = vvi
                     lot = entry(vvi * 2,v1300,"@")
                     qty = decimal(entry(vvi * 2 + 1,v1300,"@")).
           End.
        End.
        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1300.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
        IF not entry(1,v1300,"@") = v1200 THEN DO:
                display skip "条码信息不匹配" @ WMESSAGE NO-LABEL with fram F1300.
                pause 0 before-hide.
                undo, retry.
        end.
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1300.
        pause 0.
        leave V1300L.
     END.
     PV1300 = V1300.
     /* END    LINE :1300  二维码  */


     /* START  LINE :1320  修改批号  */
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
        V1320 = "N".
        V1320 = ENTRY(1,V1320,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1320 = ENTRY(1,V1320,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */
        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */
                display "[销售发货二维码]"     + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1320 width 150 no-box.

                /* LABEL 1 - START */
                L13201 = "批号是否需要修改?" .
                display L13201          format "x(40)" skip with fram F1320 width 150 no-box.
                /* LABEL 1 - END */


                /* LABEL 2 - START */
                L13202 = ENTRY(2,V1300,'@') + '/' + ENTRY(3,v1300,'@') .
                display L13202          format "x(40)" skip with fram F1320 width 150 no-box.
                /* LABEL 2 - END */


                /* LABEL 3 - START */
                L13203 = ENTRY(4,V1300,'@') + '/' + ENTRY(5,V1300,'@') .
                display L13203          format "x(40)" skip with fram F1320 width 150 no-box.
                /* LABEL 3 - END */


                /* LABEL 4 - START */
                L13204 = ENTRY(6,V1300,'@') + '/' + ENTRY(7,V1300,'@') .
                display L13204          format "x(40)" skip with fram F1320 width 150 no-box.
                /* LABEL 4 - END */
                display "输入或按E退出"       format "x(40)" skip
        skip with fram F1320 width 150 no-box.
        Update V1320
        WITH  fram F1320 NO-LABEL
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
        IF V1320 = "e" THEN  LEAVE V1320LMAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F1320.
         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1320.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1320.
        pause 0.
        leave V1320L.
     END.
     PV1320 = V1320.
     /* END    LINE :1320  修改批号  */


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
        find first pt_mstr where pt_domain = V1001 and pt_part = V1200  no-lock no-error.
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

                display "[销售发货二维码]"     + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1410 width 150 no-box.

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
        IF V1410 = "e" THEN  LEAVE V1320LMAINLOOP.
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
modlot:
repeat:
if V1320 = "N" then leave modlot.
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
        V1500 = " ".
        V1500 = ENTRY(1,V1500,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1500 = ENTRY(1,V1500,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */
                display "[销售发货二维码]"     + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1500 width 150 no-box.

                /* LABEL 1 - START */
                L15001 = "选择要修改的批号或Y完成修改！" .
                display L15001          format "x(40)" skip with fram F1500 width 150 no-box.
                /* LABEL 1 - END */


                /* LABEL 2 - START */
                L15002 = "物料:" + trim( V1200 ) .
                display L15002          format "x(40)" skip with fram F1500 width 150 no-box.
                /* LABEL 2 - END */


                /* LABEL 3 - START */
                L15003 = "发货单号:" + V1050 .
                display L15003          format "x(40)" skip with fram F1500 width 150 no-box.
                /* LABEL 3 - END */


                /* LABEL 4 - START */
                  L15004 = "" .
                display L15004          format "x(40)" skip with fram F1500 width 150 no-box.
                /* LABEL 4 - END */
                display "输入或按E退出"       format "x(40)" skip
        skip with fram F1500 width 150 no-box.
        recid(tmplot) = ?.
        Update V1500
        WITH  fram F1500 NO-LABEL
        /* ROLL BAR START */
        EDITING:
        readkey pause wtimeout.
        if lastkey = -1 then quit.
        if LASTKEY = 404 Then Do: /* DISABLE F4 */
           pause 0 before-hide.
           undo, retry.
        end.
        display skip "^" @ WMESSAGE NO-LABEL with fram F1500.
            IF LASTKEY = keycode("F10") or keyfunction(lastkey) = "CURSOR-DOWN"
            THEN DO:
                  IF recid(tmplot) = ? THEN find first tmplot where
                              lot <> "" and qty <> 0 AND
                              lot >=  INPUT V1500
                               use-index sn
                               no-lock no-error.
                  else do:
                       if lot =  INPUT V1500
                       then find next tmplot
                       WHERE lot <> "" and qty <> 0
                               use-index sn
                        no-lock no-error.
                        else find first tmplot where
                              lot <> "" and qty <> 0 AND
                              lot >=  INPUT V1500
                               use-index sn
                               no-lock no-error.
                  end.
                  IF AVAILABLE tmplot then display skip
            lot @ V1500 LOT + "@" + trim(string(qty)) @ WMESSAGE NO-LABEL with fram F1500.
                  else   display skip "" @ WMESSAGE with fram F1500.
            END.
            IF LASTKEY = keycode("F9") or keyfunction(lastkey) = "CURSOR-UP"
            THEN DO:
                  IF recid(tmplot) = ? THEN find last tmplot where
                              lot <> "" and qty <> 0 AND
                              lot <=  INPUT V1500
                               use-index sn
                               no-lock no-error.
                  else do:
                       if lot =  INPUT V1500
                       then find prev tmplot
                       where lot <> "" and qty <> 0
                               use-index sn
                        no-lock no-error.
                        else find first tmplot where
                              lot <> "" and qty <> 0 AND
                              lot >=  INPUT V1500
                               use-index sn
                               no-lock no-error.
                  end.
                  IF AVAILABLE tmplot then display skip
            lot @ V1500 LOT + "@" + trim(string(qty)) @ WMESSAGE NO-LABEL with fram F1500.
                  else   display skip "" @ WMESSAGE with fram F1500.
            END.
            APPLY LASTKEY.
        END.
        /* ROLL BAR END */


        /* PRESS e EXIST CYCLE */
        IF V1500 = "e" THEN  LEAVE V1320LMAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F1500.

        if not can-find(first tmplot no-lock where lot = v1500) and v1500 <> "Y" then do:
           display skip "批号错误!" WMESSAGE NO-LABEL with fram F1500.
           undo,retry V1500L.
        end.
        if v1500 = "Y" then leave modlot.
         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1500.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1500.
        pause 0.
        leave V1500L.
     END.
     PV1500 = V1500.
     /* END    LINE :1500  批号[LOT]  */


     /* START  LINE :1600  数量[QTY]  */
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
        define variable vqty            like ld_qty_oh.
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        find first tmplot where lot = v1500 no-error.
        if avail tmplot then do:
           vqty = tmplot.qty.
        end.
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */


        /* --CYCLE TIME SKIP -- START  */
        /* --CYCLE TIME SKIP -- END  */

                display "[销售发货二维码]"     + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1600 width 150 no-box.

                /* LABEL 1 - START */
                L16001 = "发货数量?" .
                display L16001          format "x(40)" skip with fram F1600 width 150 no-box.
                /* LABEL 1 - END */


                /* LABEL 2 - START */
                L16002 = "物料:" + trim( V1200 ) .
                display L16002          format "x(40)" skip with fram F1600 width 150 no-box.
                /* LABEL 2 - END */


                /* LABEL 3 - START */
                L16003 = "批号:" + Trim(V1500) .
                display L16003          format "x(40)" skip with fram F1600 width 150 no-box.
                /* LABEL 3 - END */

                /* LABEL 4 - START */
                find first ld_det where ld_domain = V1001 and ld_part = V1200 and ld_site = V1002 and
ld_ref = ""     and
ld_loc = V1003  and
ld_lot = V1500  and ld_qty_oh <> 0 use-index ld_part_lot no-lock no-error.
If AVAILABLE ( ld_det ) then do:
                L16004 = "库存:" + trim(V1003) + "/" + string ( ld_qty_oh ) .
                    v1600 = string(min(vqty,ld_qty_oh)).
                end.
                else L16004 = "" .
                display L16004          format "x(40)" skip with fram F1600 width 150 no-box.
                /* LABEL 4 - END */
                display "输入或按E退出"       format "x(40)" skip
        skip with fram F1600 width 150 no-box.
        /* DISPLAY ONLY */
        define variable X1600           as char format "x(40)".
        X1600 = V1600.
        /* DISPLAY ONLY */
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

        /* DISPLAY ONLY */
        /* DISPLAY ONLY */

        /* PRESS e EXIST CYCLE */
        IF V1600 = "e" THEN  LEAVE V1320LMAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F1600.

         /*  ---- Valid Check ---- START */

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
        find first LD_DET where ld_domain = V1001 and ld_part  = V1200 AND ld_loc = V1003 and
ld_site = V1002 and ld_ref = "" and  ld_lot = V1500 and  ld_QTY_oh >= DECIMAL ( V1600 )  no-lock no-error.
        IF NOT AVAILABLE LD_DET then do:
                display skip "在库数 <: " + string( V1600 ) @ WMESSAGE NO-LABEL with fram F1600.
                pause 0 before-hide.
                undo, retry.
        end.
        IF not V1600 <> "0" THEN DO:
                display skip "在库数 <: " + string( V1600 ) @ WMESSAGE NO-LABEL with fram F1600.
                pause 0 before-hide.
                undo, retry.
        end.
         /*  ---- Valid Check ---- END */
        find first tmplot exclusive where lot = v1500 no-error.
        if available tmplot then do:
           if v1600 = "0" then delete tmplot.
           else
           assign qty = decimal(v1600).
        end.
        display  "" @ WMESSAGE NO-LABEL with fram F1600.
        pause 0.
        leave V1600L.
     END.
     PV1600 = V1600.
     /* END    LINE :1600  数量[QTY]  */
end. /* modlot */

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
                display "[销售发货二维码]"     + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1700 width 150 no-box.

                /* LABEL 1 - START */
                find first tmplot where sn = 1 no-error.
If avail tmplot then
                L17001 = "批号:" + trim(lot) + " 数量" + trim(string(qty)) .
                else L17001 = "" .
                display L17001          format "x(40)" skip with fram F1700 width 150 no-box.
                /* LABEL 1 - END */


                /* LABEL 2 - START */
                find first tmplot where sn = 2 no-error.
If avail tmplot then
                L17002 = "批号:" + trim(lot) + " 数量" + trim(string(qty)) .
                else L17002 = "" .
                display L17002          format "x(40)" skip with fram F1700 width 150 no-box.
                /* LABEL 2 - END */


                /* LABEL 3 - START */
                find first tmplot where sn = 3 no-error.
If avail tmplot then
                L17003 = "批号:" + trim(lot) + " 数量" + trim(string(qty)) .
                else L17003 = "" .
                display L17003          format "x(40)" skip with fram F1700 width 150 no-box.
                /* LABEL 3 - END */


                /* LABEL 4 - START */
                  L17004 = "" .
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
        IF V1700 = "e" THEN  LEAVE V1320LMAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F1700.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1700.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
        find first so_mstr where so_domain = V1001 and so_nbr = V1100  NO-ERROR NO-WAIT.
        IF NOT AVAILABLE so_mstr then do:
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


     /* START  LINE :9000  CREATE TIGGER  */
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
        define temp-table mytt field mytt_rec as recid.
        for each mytt : delete mytt . end . 
        On create of tr_hist do:
          find first mytt where mytt_rec = recid(tr_hist) no-lock no-error.
          If not available mytt then do:
            create mytt. Mytt_rec = recid(tr_hist).
          End.
        End.
        V9000 = " ".
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

                display "[销售发货二维码]"     + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F9000 width 150 no-box.

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

        /* PRESS e EXIST CYCLE */
        IF V9000 = "e" THEN  LEAVE V1320LMAINLOOP.
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
     /* END    LINE :9000  CREATE TIGGER  */


        display "...PROCESSING...  " NO-LABEL with fram F9000X width 150 no-box.
        pause 0.
     /*  Update MFG/PRO START  */
      mfguser = V1300. /* ching add */
     {xssoi12u.i}
      run CheckSecuritied.
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
                display "[销售发货二维码]"     + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F9010 width 150 no-box.

                /* LABEL 1 - START */
                    L90101 = "交易失败".
                for each mytt:
                 find first tr_hist where recid(tr_hist) = mytt_rec and tr_domain=V1001  and tr_type begins "iss" no-error .
                 if avail tr_hist then do:
                    find first tmplot where tmplot.lot = tr_serial exclusive-lock no-error.
                    if available tmplot then do:
                       assign tmplot.trid = tr_trnbr.
                    end.
                   L90101 = "交易已提交".
                   L90102 = "交易号:" + trim(string(tr_trnbr)) .
		               tr__chr02 = V1050. 
		               tr__chr02 = V1050.   
                   release tr_hist.            
                 End.
                end.
    IF L90101 <>"" THEN
               
                L90101 = L90101 .
                else L90101 = "" .
                display L90101          format "x(40)" skip with fram F9010 width 150 no-box.
                /* LABEL 1 - END */


                /* LABEL 2 - START */
                find first tmplot where sn = 1 no-error.
               if available tmplot and trid <> 0 then 
                L90102 = "交易号:" + trim(string(trid)).
                L90102 = L90102 .
                display L90102          format "x(40)" skip with fram F9010 width 150 no-box.
                /* LABEL 2 - END */


                /* LABEL 3 - START */
                 find first tmplot where sn = 2 no-error.
               if available tmplot and trid <> 0 then 
                L90103 = "交易号:" + trim(string(trid)).
                display L90103          format "x(40)" skip with fram F9010 width 150 no-box.
                /* LABEL 3 - END */


                /* LABEL 4 - START */
                 find first tmplot where sn = 3 no-error.
               if available tmplot and trid <> 0 then 
                L90104 = "交易号:" + trim(string(trid)).
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
        IF V9010 = "e" THEN  LEAVE MainLoop.
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


   /* Internal Cycle END :9010    */
   END.
   pause 0 before-hide.
end.
