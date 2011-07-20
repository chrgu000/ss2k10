/* Generate By Barcode Generator , Copyright by Softspeed - Build By Sam Song */
/* SO SHIPMENT */
/* SS - BY KEN CHEN 080905.1 */
/* SS - BY KEN CHEN 080911.1 */
/* Generate date / time  11/22/07 20:44:15 */
/* Revision: eb2sp4 BY: Micho Yang  DATE: 10/30/08  ECO: *SS - 20081030.1* */
/* Revision: eb2sp4 BY: Micho Yang  DATE: 11/13/08  ECO: *SS - 20081113.1* */
/* Revision: eb2sp4 BY: Micho Yang  DATE: 11/18/08  ECO: *SS - 20081118.1* */
/* Revision: eb2sp4 BY: Micho Yang  DATE: 03/25/09  ECO: *SS - 20090325.1* */
/* Revision: eb2sp4 BY: Micho Yang  DATE: 03/25/09  ECO: *SS - 20090601.1* */
/* SS - 090804.1 By: Neil Gao */
/* SS - 090818.1 By: Neil Gao */
/* SS - 090911.1 By: Neil Gao */
/* SS 090911.1 - B */
/* SS 010513.1 - By: SamSOng */

/*
解决销售订单过量发放问题
*/
/* SS 090911.1 - E */

/* SS 090818.1 - B */
/*
解决重复记录问题
*/
/* SS 090818.1 - E */

/* SS 090804.1 - B */
/*
解决 xxsod_week 没有更新数据错误问题
*/
/* SS 090804.1 - E */
/* SS - 20090601.1 - B */
/*
显示内容为“订单号*客户零件号*日期”，
改为“订单号*日期*客户零件号”
*/
/* SS - 20090601.1 - E */

/* SS - 20090325.1 - B */
/*
修改 xxsod__dec01 和 xxsod__dec02 的问题
*/
/* SS - 20090325.1 - E */

/* SS - 20081118.1 - B */
/*
例如：                    推迟时间后如下：
2008-11-14  19:00         2008-11-17  19:00
2008-11-14  20:00         2008-11-17  19:00
2008-11-14  21:00         2008-11-17  19:00

这样就会导致，判断销售订单长度时出现问题，因此需更新程序
*/
/* SS - 20081118.1 - E */

/* SS - 20081113.1 - B */
/*
修改交易提交失败的 tr_time
*/
/* SS - 20081113.1 - E */

/* SS - 20081030.1 - B */
/*
1. 允许直通条码
*/
/* SS - 20081030.1 - E */

/* ss - 20101022.1 - *v1310* */
/*
1.加入输入料号和以前输入的图号做匹配确认。
*/
/*SS - 101105.1 BY KEN*/
/*
以前输入有可能是图号或是料号
先判断以前输入的是否和现在扫描的一样
如果不一样则，以前输入的当做是图号.
*/

/*SS - 101123.1 BY KEN*/
/*
以前输入有可能是图号或是料号
先判断以前输入的是否和现在扫描的一样
如果不一样则，以前输入的当做是图号.
*/
/* ss - 110402.1 -b */  /* 修改获取订单逻辑 */
/* ss - 110621.1 -b */ /*  xxsod_rmks2 记录global_userid*/
/*增加版本信息*/

/*- SS - 110720.1 --------------------------------------------*17YJ*-----------
  Purpose:记录台车状况到xxtc_hst
  Parameters: NONE
  Memo: Add new table xxtc_hst record it.
------------------------------------------------------------------------------*/

define variable sectionid as integer init 0 .
define variable WMESSAGE as char format "x(80)" init "".
define variable wtm_num as char format "x(20)" init "0".
define variable wsection as char format "x(16)".
define variable i as integer .
define variable vernbr as character format "x(10)".
/* ss - 110402.1 -b */
DEFINE VAR v_month AS CHAR FORMAT "x(2)" .
/* ss - 110402.1 -e */
/*
DEF SHARED VAR global_userid AS CHAR.
*/
DEF VAR v_L15002 AS CHAR.
DEF BUFFER codemstr FOR CODE_mstr.

/*SS - 080905.1 B*/
/*
 {mfdtitle.i "101022.1"}
 */
    /*
    {mfdtitle.i "110402.1"}
    */
 {mfdtitle.i "110720.1"}
	assign vernbr = "*110720.1".


/*
 {mfdecweb.i}
 {gplabel.i}
   define shared variable base_curr like gl_ctrl.gl_base_curr.
   define shared variable window_row as integer.
   define shared variable window_down as integer.
   define shared variable global_addr like ad_mstr.ad_addr.
   define shared variable glentity like en_mstr.en_entity.
   define shared variable current_entity like en_mstr.en_entity.
   define shared variable global_db as character.
   define shared variable trmsg like tr_hist.tr_msg.
   define shared variable global_site_list as character.
   define shared variable global_lngd_raw like mfc_ctrl.mfc_logical.
   define shared variable mfguser as character.
   define shared variable maxpage like prd_max_page.
   define shared variable printlength as integer.
   define shared variable runok like mfc_ctrl.mfc_logical.
   define shared variable l-obj-in-use like mfc_logical.

   define shared variable dtitle as character format "x(78)".
   define shared variable global_part like pt_mstr.pt_part.
   define shared variable global_site like si_mstr.si_site.
   define shared variable global_loc  like loc_mstr.loc_loc.
   define shared variable global_lot  like ld_det.ld_lot.

   define shared variable batchrun like mfc_ctrl.mfc_logical.
   define shared variable execname as character.

   define shared variable global_user_lang_dir like lng_mstr.lng_dir.
*/
/*SS - 080905.1 E*/


define variable wtimeout as integer init 99999 .
find first code_mstr where code_fldname = "BARCODE" AND CODE_value ="wtimeout" no-lock no-error. /*  Timeout - All Level */
if AVAILABLE(code_mstr) Then wtimeout = 60 * decimal(code_cmmt).
find first code_mstr where code_fldname = "BARCODE" AND CODE_value ="xssoi11wtimeout" no-lock no-error. /*  Timeout - Program Level */
if AVAILABLE(code_mstr) Then wtimeout = 60 * decimal(code_cmmt).

mainloop:
REPEAT:
     /* CYCLE COUNTER -SECTION ID -- START*/
      sectionid = sectionid + 1 .
     /* SECTION ID -- END  */

     /* START  LINE :1002  地点[SITE]  */
     V1002L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1002           as char format "x(50)".
        define variable PV1002          as char format "x(50)".
        define variable L10021          as char format "x(40)".
        define variable L10022          as char format "x(40)".
        define variable L10023          as char format "x(40)".
        define variable L10024          as char format "x(40)".
        define variable L10025          as char format "x(40)".
        define variable L10026          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        {xsdfsite.i}
     FUNCTION GETerppart RETURNS CHARACTER (INPUT V1003x AS CHARACTER , INPUT xxxsod_part AS CHARACTER).


     DEF VARIABLE erppart LIKE pt_part.
  FIND FIRST cp_mstr WHERE  cp_cust=trim(V1003x) AND xxxsod_part = cp_cust_part NO-LOCK NO-ERROR.
    IF   AVAIL cp_mstr THEN do:
    assign erppart=cp_part.

        End.

     RETURN erppart.

     END FUNCTION.

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
                display "[销售订单发货n]"     + "*" + TRIM ( V1002 ) + vernbr  format "x(50)" skip with fram F1002 no-box.

                /* LABEL 1 - START */
                L10021 = "地点设定有误" .
                display L10021          format "x(40)" skip with fram F1002 no-box.
                /* LABEL 1 - END */


                /* LABEL 2 - START */
                L10022 = "1.没有设定默认地点" .
                display L10022          format "x(40)" skip with fram F1002 no-box.
                /* LABEL 2 - END */


                /* LABEL 3 - START */
                L10023 = "2.权限设定有误" .
                display L10023          format "x(40)" skip with fram F1002 no-box.
                /* LABEL 3 - END */


                /* LABEL 4 - START */
                L10024 = "  请查核" .
                display L10024          format "x(40)" skip with fram F1002 no-box.
                /* LABEL 4 - END */
                display "输入或按E退出"       format "x(40)" skip
        skip with fram F1002 no-box.
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

    /* ching */
    iimainloop:
    repeat:
    /* ching */

     /* START  LINE :1003  客户[CUST]  */
     V1003L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1003           as char format "x(50)".
        define variable PV1003          as char format "x(50)".
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
         If sectionid > 1 Then
        V1003 = PV1003 .
        V1003 = ENTRY(1,V1003,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */
                display "[销售订单发货n]"     + "*" + TRIM ( V1002 ) + VERNBR  format "x(40)" skip with fram F1003 no-box.

                /* LABEL 1 - START */
                L10031 = "客户" .
                display L10031          format "x(40)" skip with fram F1003 no-box.
                /* LABEL 1 - END */


                /* LABEL 2 - START */
                  L10032 = "" .
                display L10032          format "x(40)" skip with fram F1003 no-box.
                /* LABEL 2 - END */


                /* LABEL 3 - START */
                  L10033 = "" .
                display L10033          format "x(40)" skip with fram F1003 no-box.
                /* LABEL 3 - END */


                /* LABEL 4 - START */
                  L10034 = "" .
                display L10034          format "x(40)" skip with fram F1003 no-box.
                /* LABEL 4 - END */
                display "输入或按E退出"       format "x(40)" skip
        skip with fram F1003 no-box.
        recid(cm_mstr) = ?.
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
                  IF recid(cm_mstr) = ? THEN find first cm_mstr where
                              cm_addr >=  INPUT V1003
                               no-lock no-error.
                  else do:
                       if cm_addr =  INPUT V1003
                       then find next cm_mstr
                        no-lock no-error.
                        else find first cm_mstr where
                              cm_addr >=  INPUT V1003
                               no-lock no-error.
                  end.
                  IF AVAILABLE cm_mstr then display skip
            cm_addr @ V1003 cm_addr + "*" + cm_sort @ WMESSAGE NO-LABEL with fram F1003.
                  else   display skip "" @ WMESSAGE with fram F1003.
            END.
            IF LASTKEY = keycode("F9") or keyfunction(lastkey) = "CURSOR-UP"
            THEN DO:
                  IF recid(cm_mstr) = ? THEN find last cm_mstr where
                              cm_addr <=  INPUT V1003
                               no-lock no-error.
                  else do:
                       if cm_addr =  INPUT V1003
                       then find prev cm_mstr
                        no-lock no-error.
                        else find first cm_mstr where
                              cm_addr >=  INPUT V1003
                               no-lock no-error.
                  end.
                  IF AVAILABLE cm_mstr then display skip
            cm_addr @ V1003 cm_addr + "*" + cm_sort @ WMESSAGE NO-LABEL with fram F1003.
                  else   display skip "" @ WMESSAGE with fram F1003.
            END.
            APPLY LASTKEY.
        END.
        /* ROLL BAR END */


        /* PRESS e EXIST CYCLE */
        IF V1003 = "e" THEN  LEAVE MAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F1003.

         /*  ---- Valid Check ---- START */

        find first cm_mstr where cm_addr = trim(V1003) NO-LOCK NO-ERROR.
IF NOT AVAILABLE cm_mstr then do:
  display skip "客户不存在 " @ WMESSAGE NO-LABEL with fram F1003.
  pause 0 before-hide.
  undo, retry.
end.
        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1003.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1003.
        pause 0.
        leave V1003L.
     END.
     PV1003 = V1003.
     /* END    LINE :1003  客户[CUST]  */


     /* START  LINE :1004  日期[DATE]  */
     V1004L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1004           as char format "x(50)".
        define variable PV1004          as char format "x(50)".
        define variable L10041          as char format "x(40)".
        define variable L10042          as char format "x(40)".
        define variable L10043          as char format "x(40)".
        define variable L10044          as char format "x(40)".
        define variable L10045          as char format "x(40)".
        define variable L10046          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
/*find first xxsod_det where xxsod_cust=trim(V1003) and xxsod__dec02=0 no-lock no-error.
If  avail xxsod_det then V1004=xxsod_due_date1.
Else V1004=string(today).
If V1004<>"" then*/
def var tempdate1 as char.
/*tempdate1="1".
for each  xxsod_det where xxsod_cust=trim(V1003) and xxsod__dec02=0 no-lock break by xxsod_cust by xxsod_due_date1:
  if tempdate1="1" then assign V1004=xxsod_due_date1 tempdate1="2".
  else leave.

end.
If V1004="" then assign  V1004=string(today).
*/
V1004 = string(year(today),"9999") + "-" +  string(month(today),"99") + "-" + string(day(today),"99").
If V1004<>"" then
        V1004 = V1004.
        V1004 = ENTRY(1,V1004,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
         If sectionid > 1 Then
        V1004 = PV1004 .
        V1004 = ENTRY(1,V1004,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */
                display "[销售订单发货n]"     + "*" + TRIM ( V1002 ) + VERNBR  format "x(40)" skip with fram F1004 no-box.

                /* LABEL 1 - START */
                L10041 = "日期" .
                display L10041          format "x(40)" skip with fram F1004 no-box.
                /* LABEL 1 - END */


                /* LABEL 2 - START */
                L10042 = "客户:" + V1003 .
                display L10042          format "x(40)" skip with fram F1004 no-box.
                /* LABEL 2 - END */


                /* LABEL 3 - START */
                  L10043 = "" .
                display L10043          format "x(40)" skip with fram F1004 no-box.
                /* LABEL 3 - END */


                /* LABEL 4 - START */
                  L10044 = "" .
                display L10044          format "x(40)" skip with fram F1004 no-box.
                /* LABEL 4 - END */
                display "输入或按E退出"       format "x(40)" skip
        skip with fram F1004 no-box.
        recid(xxsod_det) = ?.
        Update V1004
        WITH  fram F1004 NO-LABEL
        /* ROLL BAR START */
        EDITING:
        readkey pause wtimeout.
        if lastkey = -1 then quit.
        if LASTKEY = 404 Then Do: /* DISABLE F4 */
           pause 0 before-hide.
           undo, retry.
        end.
        display skip "^" @ WMESSAGE NO-LABEL with fram F1004.
            IF LASTKEY = keycode("F10") or keyfunction(lastkey) = "CURSOR-DOWN"
            THEN DO:
                  IF recid(xxsod_det) = ? THEN find first xxsod_det where
                              xxsod_cust=trim(V1003) and xxsod__dec02=0 AND
                              xxsod_due_date1 >=  INPUT V1004
                               no-lock no-error.
                  else do:
                       if xxsod_due_date1 =  INPUT V1004
                       then find next xxsod_det
                       WHERE xxsod_cust=trim(V1003) and xxsod__dec02=0
                        no-lock no-error.
                        else find first xxsod_det where
                              xxsod_cust=trim(V1003) and xxsod__dec02=0 AND
                              xxsod_due_date1 >=  INPUT V1004
                               no-lock no-error.
                  end.
                  IF AVAILABLE xxsod_det then display skip
            xxsod_due_date1 @ V1004 xxsod_cust + "*" + xxsod_due_date1 + "*" + xxsod_due_time1 @ WMESSAGE NO-LABEL with fram F1004.
                  else   display skip "" @ WMESSAGE with fram F1004.
            END.
            IF LASTKEY = keycode("F9") or keyfunction(lastkey) = "CURSOR-UP"
            THEN DO:
                  IF recid(xxsod_det) = ? THEN find last xxsod_det where
                              xxsod_cust=trim(V1003) and xxsod__dec02=0 AND
                              xxsod_due_date1 <=  INPUT V1004
                               no-lock no-error.
                  else do:
                       if xxsod_due_date1 =  INPUT V1004
                       then find prev xxsod_det
                       where xxsod_cust=trim(V1003) and xxsod__dec02=0
                        no-lock no-error.
                        else find first xxsod_det where
                              xxsod_cust=trim(V1003) and xxsod__dec02=0 AND
                              xxsod_due_date1 >=  INPUT V1004
                               no-lock no-error.
                  end.
                  IF AVAILABLE xxsod_det then display skip
            xxsod_due_date1 @ V1004 xxsod_cust + "*" + xxsod_due_date1 + "*" + xxsod_due_time1 @ WMESSAGE NO-LABEL with fram F1004.
                  else   display skip "" @ WMESSAGE with fram F1004.
            END.
            APPLY LASTKEY.
        END.
        /* ROLL BAR END */


        /* PRESS e EXIST CYCLE */
        IF V1004 = "e" THEN  LEAVE iimainloop /* ching MAINLOOP */.
        display  skip WMESSAGE NO-LABEL with fram F1004.

         /*  ---- Valid Check ---- START */

        find first xxsod_det where xxsod_cust = trim(V1003) and xxsod_due_date1=trim(V1004) and xxsod__dec02=0 NO-LOCK  NO-ERROR.
IF NOT AVAILABLE xxsod_det then do:
  display skip "该客户该天没有客户传票 " @ WMESSAGE NO-LABEL with fram F1004.
  pause 0 before-hide.
  Undo, retry.
End.
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
     /* END    LINE :1004  日期[DATE]  */


     /* START  LINE :1005  时段[TIME]  */
     V1005L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1005           as char format "x(50)".
        define variable PV1005          as char format "x(50)".
        define variable L10051          as char format "x(40)".
        define variable L10052          as char format "x(40)".
        define variable L10053          as char format "x(40)".
        define variable L10054          as char format "x(40)".
        define variable L10055          as char format "x(40)".
        define variable L10056          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
/*find first xxsod_det where xxsod_cust=trim(V1003) and xxsod_due_date1=trim(V1004) and xxsod__dec02=0 no-lock no-error.
If  avail xxsod_det then V1005=xxsod_due_time1.
Else V1005="".
If V1005<>"" then*/
def var tempdate2 as char.
tempdate2="1".
for each xxsod_det where xxsod_cust=trim(V1003) and xxsod_due_date1=trim(V1004) and xxsod__dec02=0 no-lock break by xxsod_cust by xxsod_due_date1 by xxsod_due_time1:
  if tempdate2="1" then assign V1005=xxsod_due_time1 tempdate2="2".
  else leave.
end.
If V1005<>"" then
        V1005 = V1005.
        V1005 = ENTRY(1,V1005,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
         If sectionid > 1 Then
        V1005 = PV1005 .
        V1005 = ENTRY(1,V1005,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */
                display "[销售订单发货n]"     + "*" + TRIM ( V1002 ) + vernbr format "x(40)" skip with fram F1005 no-box.

                /* LABEL 1 - START */
                L10051 = "时段" .
                display L10051          format "x(40)" skip with fram F1005 no-box.
                /* LABEL 1 - END */


                /* LABEL 2 - START */
                L10052 = "客户:" + V1003 .
                display L10052          format "x(40)" skip with fram F1005 no-box.
                /* LABEL 2 - END */


                /* LABEL 3 - START */
                L10053 = "日期:" + V1004 .
                display L10053          format "x(40)" skip with fram F1005 no-box.
                /* LABEL 3 - END */


                /* LABEL 4 - START */
                  L10054 = "" .
                display L10054          format "x(40)" skip with fram F1005 no-box.
                /* LABEL 4 - END */
                display "输入[时段]或按E退出"       format "x(40)" skip
        skip with fram F1005 no-box.
        recid(xxsod_det) = ?.
        Update V1005
        WITH  fram F1005 NO-LABEL
        /* ROLL BAR START */
        EDITING:
        readkey pause wtimeout.
        if lastkey = -1 then quit.
        if LASTKEY = 404 Then Do: /* DISABLE F4 */
           pause 0 before-hide.
           undo, retry.
        end.
        display skip "^" @ WMESSAGE NO-LABEL with fram F1005.
            IF LASTKEY = keycode("F10") or keyfunction(lastkey) = "CURSOR-DOWN"
            THEN DO:
                  IF recid(xxsod_det) = ? THEN find first xxsod_det where
                              xxsod_cust=trim(V1003) and xxsod_due_date1=trim(V1004) and xxsod__dec02=0 AND
                              xxsod_due_time1 >=  INPUT V1005
                               no-lock no-error.
                  else do:
                       if xxsod_due_time1 =  INPUT V1005
                       then find next xxsod_det
                       WHERE xxsod_cust=trim(V1003) and xxsod_due_date1=trim(V1004) and xxsod__dec02=0
                        no-lock no-error.
                        else find first xxsod_det where
                              xxsod_cust=trim(V1003) and xxsod_due_date1=trim(V1004) and xxsod__dec02=0 AND
                              xxsod_due_time1 >=  INPUT V1005
                               no-lock no-error.
                  end.
                  IF AVAILABLE xxsod_det then display skip
            xxsod_due_time1 @ V1005 xxsod_cust + "*" + xxsod_due_date1 + "*" + xxsod_due_time1 @ WMESSAGE NO-LABEL with fram F1005.
                  else   display skip "" @ WMESSAGE with fram F1005.
            END.
            IF LASTKEY = keycode("F9") or keyfunction(lastkey) = "CURSOR-UP"
            THEN DO:
                  IF recid(xxsod_det) = ? THEN find last xxsod_det where
                              xxsod_cust=trim(V1003) and xxsod_due_date1=trim(V1004) and xxsod__dec02=0 AND
                              xxsod_due_time1 <=  INPUT V1005
                               no-lock no-error.
                  else do:
                       if xxsod_due_time1 =  INPUT V1005
                       then find prev xxsod_det
                       where xxsod_cust=trim(V1003) and xxsod_due_date1=trim(V1004) and xxsod__dec02=0
                        no-lock no-error.
                        else find first xxsod_det where
                              xxsod_cust=trim(V1003) and xxsod_due_date1=trim(V1004) and xxsod__dec02=0 AND
                              xxsod_due_time1 >=  INPUT V1005
                               no-lock no-error.
                  end.
                  IF AVAILABLE xxsod_det then display skip
            xxsod_due_time1 @ V1005 xxsod_cust + "*" + xxsod_due_date1 + "*" + xxsod_due_time1 @ WMESSAGE NO-LABEL with fram F1005.
                  else   display skip "" @ WMESSAGE with fram F1005.
            END.
            APPLY LASTKEY.
        END.
        /* ROLL BAR END */


        /* PRESS e EXIST CYCLE */
        IF V1005 = "e" THEN  LEAVE iimainloop /* ching MAINLOOP */.
        display  skip WMESSAGE NO-LABEL with fram F1005.

         /*  ---- Valid Check ---- START */

        find first xxsod_det where xxsod_cust = trim(V1003) and xxsod_due_date1=trim(V1004) and xxsod_due_time1=trim(V1005) and xxsod__dec02=0 NO-LOCK NO-ERROR.
IF NOT AVAILABLE xxsod_det then do:
  display skip "该客户该天该时段没有订单 " @ WMESSAGE NO-LABEL with fram F1005.
  pause 0 before-hide.
  Undo, retry.
End.
        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1005.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
         /*  ---- Valid Check ---- END */




        /*SS - 080911.1 B*/
        /*for test.
        {xsrpfxt01.i}
        */
        /*SS - 080911.1 E*/





        display  "" @ WMESSAGE NO-LABEL with fram F1005.
        pause 0.
        leave V1005L.
     END.
     PV1005 = V1005.
     /* END    LINE :1005  时段[TIME]  */

/*17YJ*/ pv10006loop:   /*17YJ*/ /*台车号:记录在 v10006*/
/*17YJ*/ repeat:
/*17YJ*/ 	hide all.
/*17YJ*/ 	display "[销售订单发货n]"     + "*" + TRIM ( V1002 ) + vernbr  format "x(40)" skip with fram F10006 no-box.
/*17YJ*/ 	/* LABEL 1 - START 	*/
/*17YJ*/ 	L10051 = "台车号" .
/*17YJ*/ 	display L10051          format "x(40)" skip with fram F10006 no-box.
/*17YJ*/
/*17YJ*/ 	/* LABEL 2 - START */
/*17YJ*/ 	L10052 = "客户:" + V1003 .
/*17YJ*/ 	display L10052          format "x(40)" skip with fram F10006 no-box.
/*17YJ*/ 	/* LABEL 2 - END */
/*17YJ*/ 	/* LABEL 3 - START */
/*17YJ*/ 	L10053 = "日期:" + V1004 .
/*17YJ*/ 	display L10053          format "x(40)" skip with fram F10006 no-box.
/*17YJ*/ 	/* LABEL 3 - END */
/*17YJ*/ 	/* LABEL 4 - START */
/*17YJ*/ 	  L10054 = "" .
/*17YJ*/ 	display L10054          format "x(40)" skip with fram F10006 no-box.
/*17YJ*/ 	/* LABEL 4 - END */
/*17YJ*/ 	display "输入台车号或按E退出"       format "x(40)" skip
/*17YJ*/ 	skip with fram F10006 no-box.
/*17YJ*/ 	define variable v10006 as character format "x(50)".
/*17YJ*/ 	UPDATE v10006 WITH  fram F10006 NO-LABEL EDITING:
/*17YJ*/  readkey pause wtimeout.
/*17YJ*/  if lastkey = -1 then quit.
/*17YJ*/  if LASTKEY = 404 Then Do: /* DISABLE F4 */
/*17YJ*/     pause 0 before-hide.
/*17YJ*/     undo, retry.
/*17YJ*/  end.
/*17YJ*/       apply lastkey.
/*17YJ*/  end.
/*17YJ*/  IF V10006 = "e" THEN  LEAVE  pv10006loop /*ching pv10006loop */.
/*17YJ*/	if v10006 = "" then do:
/*17YJ*/  		assign wmessage = "台车号不可为空!".
/*17YJ*/  		display  skip WMESSAGE NO-LABEL with fram F10006.
/*17YJ*/  		undo ,retry.
/*17YJ*/  end.
/*17YJ*/  					 assign wmessage = "......".
/*17YJ*/  display  skip WMESSAGE NO-LABEL with fram F10006.
/*17YJ*/  find first xxtc_hst no-lock where xxtc_nbr = v10006 no-error.
/*17YJ*/  if availabl xxtc_hst and xxtc_cust <> "" then do:
/*17YJ*/  		assign wmessage = "台车:[" + v10006 + "]在客户:[" + "]处！请确认资料.".
/*17YJ*/     display  skip WMESSAGE NO-LABEL with fram F10006.
/*17YJ*/    assign v10006 = "".
/*17YJ*/		undo , retry.
/*17YJ*/	end.
/*17YJ*/  leave pv10006loop.
/*17YJ*/ end.


/* ching */
imainloop:
repeat:
/*ching */
   /* Internal Cycle Input :1300    */
   V1300LMAINLOOP:
   REPEAT:
     /* START  LINE :1300  成品[Finished Goods]  */
     V1300L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1300           as char format "x(50)".
        define variable PV1310          as char format "x(50)".
        define variable L13001          as char format "x(40)".
        define variable L13002          as char format "x(40)".
        define variable L13003          as char format "x(40)".
        define variable L13004          as char format "x(40)".
        define variable L13005          as char format "x(40)".
        define variable L13006          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        V1300 = " ".
        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */
                display "[销售订单发货n]"     + "*" + TRIM ( V1002 ) + vernbr format "x(40)" skip with fram F1300 no-box.

                /* LABEL 1 - START */
                L13001 = "图号 或 图号+批号?" .
                display L13001          format "x(40)" skip with fram F1300 no-box.
                /* LABEL 1 - END */


                /* LABEL 2 - START */
                L13002 = "客户:" + V1003 .
                display L13002          format "x(40)" skip with fram F1300 no-box.
                /* LABEL 2 - END */


                /* LABEL 3 - START */
                L13003 = "车台号:" + v10006.
                display L13003  format "x(40)" skip with fram F1300 no-box.
                /* LABEL 3 - END */


                /* LABEL 4 - START */
                L13004 = "日期 时段:" + V1004 + " "  + V1005 .
                display L13004          format "x(40)" skip with fram F1300 no-box.
                /* LABEL 4 - END */
                display "输入或按E退出"       format "x(40)" skip
        skip with fram F1300 no-box.
        recid(xxsod_det) = ?.
        Update V1300
        WITH  fram F1300 NO-LABEL
        EDITING:
        readkey pause wtimeout.
        if lastkey = -1 then quit.
        if LASTKEY = 404 Then Do: /* DISABLE F4 */
           pause 0 before-hide.
           undo, retry.
        end.
             apply lastkey.
        end.
        IF V1300 = "e" THEN  LEAVE  imainloop /*ching MAINLOOP */ .
        /* **SKIP TO MAIN LOOP END** */
        display  skip WMESSAGE NO-LABEL with fram F1300.



/*v1310*/ V1310L:
/*v1310*/ REPEAT:
/*v1310*/
/*v1310*/    /* --DEFINE VARIABLE -- START */
/*v1310*/    hide all.
/*v1310*/    define variable V1310           as char format "x(50)".
/*v1310*/    define variable PV1300          as char format "x(50)".
/*v1310*/    define variable L130111          as char format "x(40)".
/*v1310*/    define variable L130121          as char format "x(40)".
/*v1310*/    define variable L130131          as char format "x(40)".
/*v1310*/    define variable L130141          as char format "x(40)".
/*v1310*/    define variable L130151          as char format "x(40)".
/*v1310*/    define variable L130161          as char format "x(40)".
/*v1310*/    /* --DEFINE VARIABLE -- END */
/*v1310*/
/*v1310*/
/*v1310*/    /* --FIRST TIME DEFAULT  VALUE -- START  */
/*v1310*/    V1310 = " ".
/*v1310*/
/*v1310*/            display "[销售订单发货n]"     + "*" + TRIM ( V1002 ) + vernbr  format "x(40)" skip with fram F1310 no-box.
/*v1310*/
/*v1310*/            /* LABEL 1 - START */
/*v1310*/            L130111 = "标签图号?" .
/*v1310*/            display L130111          format "x(40)" skip with fram F1310 no-box.
/*v1310*/            /* LABEL 1 - END */
/*v1310*/
/*v1310*/            /* LABEL 4 - START */
/*v1310*/            L130141 = "图号/批号:" + V1300 .
/*v1310*/            display L130141          format "x(40)" skip with fram F1310 no-box.
/*v1310*/
/*v1310*/            /* LABEL 2 - START */
/*v1310*/            L130121 = "客户:" + V1003 .
/*v1310*/            display L130121          format "x(40)" skip with fram F1310 no-box.
/*v1310*/            /* LABEL 2 - END */
/*v1310*/
/*v1310*/
/*v1310*/            /* LABEL 3 - START */
/*v1310*/            L130131 = "日期 时段:" + V1004 + " " + V1005 .
/*v1310*/            display L130131          format "x(40)" skip with fram F1310 no-box.
/*v1310*/            /* LABEL 3 - END */
/*v1310*/
/*v1310*/            /* LABEL 4 - END */
/*v1310*/            display "输入或按E退出"       format "x(40)" skip
/*v1310*/    skip with fram F1310 no-box.
/*v1310*/    Update V1310
/*v1310*/    WITH  fram F1310 NO-LABEL
/*v1310*/    EDITING:
/*v1310*/    readkey pause wtimeout.
/*v1310*/    if lastkey = -1 then quit.
/*v1310*/    if LASTKEY = 404 Then Do: /* DISABLE F4 */
/*v1310*/       pause 0 before-hide.
/*v1310*/       undo, retry.
/*v1310*/    end.
/*v1310*/         apply lastkey.
/*v1310*/    end.
/*v1310*/    ASSIGN V1310.
/*v1310*/    IF V1310 = "e" THEN  LEAVE  imainloop /*ching MAINLOOP */ .
/*v1310*/    display  skip WMESSAGE NO-LABEL with fram F1310.
/*v1310*/    find first pt_mstr no-lock where pt_part = V1310 no-error.
/*v1310*/    if available pt_mstr then do:
                /*SS - 101105.1 B*/


                /*
/*v1310*/       if pt_draw <> trim(substring(V1300,2)) then do:
/*v1310*/          display skip "料号图号不对应" @ WMESSAGE NO-LABEL with fram F1310.
/*v1310*/          undo V1310L,retry.
/*v1310*/       end.
/*v1310*/       else do:
/*v1310*/          leave V1310L.
/*v1310*/       end.
                */

                IF pt_part <> entry(1,V1300,"@") THEN  DO:

                   /*SS - 101123.1 B*/
                   if pt_draw <> trim(substring(V1300,2)) then do:
                      display skip "图号与标签图号不对应" @ WMESSAGE NO-LABEL with fram F1310.
                      undo V1310L,retry.
                   end.
                   else do:
                       leave V1310L.
                   end.


                    /*
                   if pt_draw <> trim(substring(V1300,2)) then do:
                      display skip "料号图号不对应" @ WMESSAGE NO-LABEL with fram F1310.
                      undo V1310L,retry.
                   end.
                   else do:
                       leave V1310L.
                   end.
                   */
                   /*SS - 101123.1 E*/
                END.
                ELSE DO:
                   leave V1310L.
                END.
                /*SS - 101105.1 E*/
/*v1310*/    end.
/*v1310*/    else do:
/*v1310*/       display skip "标签图号错误！" @ WMESSAGE NO-LABEL with fram F1310.
/*v1310*/       undo V1310L,retry.
/*v1310*/    end.
/*v1310*/ end.


 /* **SKIP TO MAIN LOOP END** */

  /*  ---- Valid Check ---- START */


/* 001 7/14/2006 14:00 a980SAG H122M1

find first xxsod_det where trim(xxsod_cust) = '001' and trim(xxsod_due_date1)='7/14/2006' and trim(xxsod_due_time1)='14:00' and trim(xxsod_part)='a980SAG H122M1' and xxsod__dec02=0 NO-LOCK NO-ERROR.
*/

/***********/
def var tmpsonbr as char.
tmpsonbr="".
def var tmppart as char.
def var tmpparta as char.
DEF VAR custpart AS CHAR.
DEF VAR v_flag AS LOGICAL .
tmpparta="".
def var v_ord_date as char.

/* SS - 20081030.1 - B */
/*
find first pt_mstr where pt_draw = trim(substring(V1300,2)) no-lock no-error.
if not avail pt_mstr then do:
  display skip "ERP图号不存在 " @ WMESSAGE NO-LABEL with fram F1300.
  pause 0 before-hide.
  Undo, retry.
end.
else assign tmppart=pt_part.
  */
/* 扫描的条码类型为 "图号" 时为："M + 零件号" */
IF INDEX(v1300,"@") = 0 THEN DO:
   find first pt_mstr where pt_draw = trim(substring(V1300,2)) no-lock no-error.
   if not avail pt_mstr then do:
      display skip "ERP图号不存在 " @ WMESSAGE NO-LABEL with fram F1300.
      pause 0 before-hide.
      Undo, retry.
   end.
   else assign tmppart=pt_part.
END.
/* 扫描的条码类型为 "图号 + 批号" 时："ERP零件号 + 直接的批号" */
ELSE DO:
   find first pt_mstr where pt_part = entry(1,V1300,"@") no-lock no-error.
   if not avail pt_mstr then do:
      display skip "ERP图号不存在 " @ WMESSAGE NO-LABEL with fram F1300.
      pause 0 before-hide.
      Undo, retry.
   end.
   else assign tmppart=pt_part.
END.
/* SS - 20081030.1 - E */

/* SS - 20071225.1 - B */
DEF TEMP-TABLE ttcp
    FIELD ttcp_cust     LIKE cp_cust
    FIELD ttcp_part     LIKE cp_part
    FIELD ttcp_cust_part    LIKE cp_cust_part
    .

/*
DISPLAY SKIP "1." + TRIM(v1003) + " " + tmppart @ WMESSAGE NO-LABEL with fram F1300.
pause 10.
  */

EMPTY TEMP-TABLE ttcp .
FOR EACH cp_mstr WHERE trim(cp_cust) = TRIM(v1003) AND trim(tmppart) = trim(cp_part) NO-LOCK :
    FIND FIRST ttcp WHERE ttcp_cust = cp_cust AND ttcp_part = cp_part AND ttcp_cust_part = cp_cust_part NO-ERROR.
    IF NOT AVAIL ttcp THEN DO:
        CREATE ttcp.
        ASSIGN
            ttcp_cust = trim(cp_cust)
            ttcp_part = trim(cp_part)
            ttcp_cust_part = trim(cp_cust_part)
            .
    END.
END.


/* SS - 20071225.1 - E */
FIND FIRST cp_mstr WHERE  cp_cust=trim(V1003) AND tmppart = cp_part NO-LOCK NO-ERROR.
  IF NOT AVAIL cp_mstr THEN DO:
  display skip "ERP图号对应未维护" @ WMESSAGE NO-LABEL with fram F1300.
  pause 0 before-hide.
  Undo, retry.
End.
/* SS - 20071225.1 - B */
/*
else assign tmpparta = cp_cust_part.
  */
/* SS - 20071225.1 - E */

find first cm_mstr where cm_addr=trim(V1003) no-lock no-error.
if avail cm_mstr then assign tmpsonbr=substring(cm_sort,1,2).

/* SS - 20071225.1 - B */
custpart = "" .
/* SS - 20071225.1 - E */

/*find first xxsod_det where trim(xxsod_cust) = trim(V1003) and trim(xxsod_due_date1)=trim(V1004)
*and trim(xxsod_due_time1)=trim(V1005) and trim(xxsod_part)=tmpparta /*ENTRY(1, V1300, "@")*/ and
*xxsod__dec02=0 NO-LOCK NO-ERROR.
*if avail xxsod_det then do:
*
* assign tmpsonbr = tmpsonbr + substring(xxsod_type,1,1).
*        assign tmpsonbr =tmpsonbr + substring(V1004,4,1).
*
* if dec(ENTRY(2, V1004, "-"))<10 then assign tmpsonbr=tmpsonbr + ENTRY(2, V1004, "-").
* if dec(ENTRY(2, V1004, "-"))=10 then assign tmpsonbr=tmpsonbr + 'A'.
* if dec(ENTRY(2, V1004, "-"))=11 then assign tmpsonbr=tmpsonbr + 'B'.
* if dec(ENTRY(2, V1004, "-"))=12 then assign tmpsonbr=tmpsonbr + 'C'.
*  assign tmpsonbr =tmpsonbr + substring(xxsod_project,1,1).
*  assign tmpsonbr =tmpsonbr + string(xxsod_week).
*
end. */

/* SS - 20071225.1 - B */
/*
* find first xxsod_det where  xxsod_cust  = trim(V1003) and  xxsod_due_date1 =trim(V1004) and  xxsod_due_time1 =trim(V1005) and  xxsod_part =trim(tmpparta)  and  xxsod__dec02=0 NO-LOCK NO-ERROR.
* /*find first  xxsod_det  where trim(xxsod_cust) =trim(V1003) and
*trim(xxsod_due_date1)=trim(V1004) and trim(xxsod_due_time1)=trim(V1005) and
*xxsod_part=trim(tmpparta) and xxsod__dec02=0 no-lock no-error.
*
*message  trim(V1003) " "  trim(V1004) " " trim(V1005) " " tmpparta  " xxsod__dec02 ".
*pause 10.*/
*if not avail xxsod_det then do:
*
*
* display skip  "该客户该天该时段没有图号 " @ WMESSAGE NO-LABEL with fram F1300.
* pause 0 before-hide. /* tmppart + tmpparta + */
* Undo, retry.
*end.
*/

v_flag = NO .
FOR EACH xxsod_det where  xxsod_cust  = trim(V1003) and  xxsod_due_date1 =trim(V1004) and  xxsod_due_time1 =trim(V1005) and  xxsod__dec02=0 NO-LOCK :
    FIND FIRST ttcp WHERE ttcp_cust = TRIM(xxsod_cust) AND ttcp_cust_part = TRIM(xxsod_part) NO-LOCK NO-ERROR.
    IF AVAIL ttcp THEN DO:
        v_flag = YES .
    END.
END.
IF v_flag = NO THEN DO:
  display skip  "该客户该天该时段没有图号 " @ WMESSAGE NO-LABEL with fram F1300.
  pause 0 before-hide. /* tmppart + tmpparta + */
  Undo, retry.
END.
/* SS - 20071225.1 - E */

for each xxsod_det where trim(xxsod_cust) = trim(V1003) and trim(xxsod_due_date1)=trim(V1004) and trim(xxsod_due_time1)=trim(V1005)
    /* SS - 20071225.1 - B */ /*and trim(xxsod_part)=tmpparta */ /* SS - 20071225.1 - e */ /*ENTRY(1, V1300, "@")*/ and  xxsod__dec02=0 NO-LOCK
    ,FIRST ttcp WHERE ttcp_cust = TRIM(xxsod_cust) AND ttcp_cust_part = TRIM(xxsod_part) NO-LOCK
                                   break by xxsod_type by xxsod_cust by xxsod_project
/* SS 090804.1 - B */
/*
                                   BY xxsod_week
*/
/* SS 090804.1 - E */
                                   BY DATE(INTEGER(SUBSTRING(xxsod_rmks,INDEX(xxsod_rmks," ") + 5,2)),INTEGER(SUBSTRING(xxsod_rmks,INDEX(xxsod_rmks," ") + 7,2)), INTEGER(SUBSTRING(xxsod_rmks,INDEX(xxsod_rmks," ") + 1,4)))
                                   BY xxsod_due_date1 BY xxsod_part :
/* SS 090804.1 - B */
/*
         IF FIRST-OF(xxsod_week) THEN v_ord_date = substring(xxsod_rmks, index(xxsod_rmks, " " ) + 1) .
*/
/* SS 010513.1 - B */
/*    v_ord_date = substring(xxsod_rmks, index(xxsod_rmks, " " ) + 1) . */
v_ord_date = replace ( xxsod_due_date1,"-","").

/*******************/
/* SS 010513.1 - E */

   /* SS - 20081118.1 - B */
/* SS 090912.1 - B */
/*
   IF FIRST-OF(xxsod_part) THEN DO:
*/
   IF FIRST(xxsod_part) THEN DO:

/* SS 090912.1 - E */
       /* ss - 110402.1 - b
   /* SS - 20081118.1 - E */
      assign tmpsonbr = tmpsonbr + substring(xxsod_type,1,1).
      ASSIGN tmpsonbr =tmpsonbr + substring(v_ord_date,4,1).

      if dec(substring(v_ord_date,5,2))<10 then assign tmpsonbr=tmpsonbr + substring(v_ord_date,6,1).
      if dec(substring(v_ord_date,5,2))=10 then assign tmpsonbr=tmpsonbr + 'A'.
      if dec(substring(v_ord_date,5,2))=11 then assign tmpsonbr=tmpsonbr + 'B'.
      if dec(substring(v_ord_date,5,2))=12 then assign tmpsonbr=tmpsonbr + 'C'.
      assign tmpsonbr =tmpsonbr + substring(xxsod_project,1,1).
/* SS 090804.1 - B */
/*
      assign tmpsonbr =tmpsonbr + string(xxsod_week).
*/
      assign tmpsonbr =tmpsonbr + string(day(date(xxsod_due_date1))).
/* SS 090804.1 - E */
      ss - 110402.1 - e */

       /* ss - 110402.1 -b */
       /* tmpsonbr 已经客户开头了 */
         if dec(substring(v_ord_date,5,2))<10 then assign v_month =  substring(v_ord_date,6,1).
      if dec(substring(v_ord_date,5,2))=10 then assign v_month = 'A'.
      if dec(substring(v_ord_date,5,2))=11 then assign v_month =  'B'.
      if dec(substring(v_ord_date,5,2))=12 then assign v_month =  'C'.

       tmpsonbr = tmpsonbr +  SUBstring( STRING( YEAR(date(xxsod_due_date1) ) , "9999") , 3 ) + v_month + STRING( day(date(xxsod_due_date1) ) ,"99") +
          substring(xxsod_project,1,1) .
       /* ss - 110402.1 -e */

      /* SS - 20071225.1 - B */
      ASSIGN custpart = xxsod_part .
      /* SS - 20071225.1 - E */
   /* SS - 20081118.1 - B */
   END.
   /* SS - 20081118.1 - E */

end.

/***********/
IF length(tmpsonbr, 'raw') > 8 THEN DO:
  display skip "销售订单号大于8位"  @ WMESSAGE NO-LABEL with fram F1300.
  pause 0 before-hide.
  Undo, retry.
end.
/***********/
find first so_mstr where so_nbr=tmpsonbr /* and so_site=V1002 */ no-lock no-error.
 If not avail so_mstr then do:
  display skip "销售订单不存在" @ WMESSAGE NO-LABEL with fram F1300.
  pause 0 before-hide.
  Undo, retry.
end.


/***********/
find first sod_det where sod_nbr=tmpsonbr and sod_part=tmppart  no-lock no-error.
if not avail sod_det then do:
  display skip "订单不存在该图号" @ WMESSAGE NO-LABEL with fram F1300.
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
     /* END    LINE :1300  成品[Finished Goods]  */


     /* START  LINE :1301  昭和订单  */
     V1301L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1301           as char format "x(50)".
        define variable PV1301          as char format "x(50)".
        define variable L13011          as char format "x(40)".
        define variable L13012          as char format "x(40)".
        define variable L13013          as char format "x(40)".
        define variable L13014          as char format "x(40)".
        define variable L13015          as char format "x(40)".
        define variable L13016          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */

        if tmpsonbr<>"" then
        V1301 = tmpsonbr.
        V1301 = ENTRY(1,V1301,"@").

        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1301 = ENTRY(1,V1301,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        find first so_mstr where so_nbr=V1301 and so_site=V1002 no-lock no-error.
   If  avail so_mstr then
        leave V1301L.
        /* LOGICAL SKIP END */
                display "[销售订单发货n]"     + "*" + TRIM ( V1002 ) + vernbr format "x(40)" skip with fram F1301 no-box.

                /* LABEL 1 - START */
                L13011 = "昭和订单" .
                display L13011          format "x(40)" skip with fram F1301 no-box.
                /* LABEL 1 - END */


                /* LABEL 2 - START */
                L13012 = "客户:" + V1003 .
                display L13012          format "x(40)" skip with fram F1301 no-box.
                /* LABEL 2 - END */


                /* LABEL 3 - START */
                L13013 = "日期:" + V1004 .
                display L13013          format "x(40)" skip with fram F1301 no-box.
                /* LABEL 3 - END */


                /* LABEL 4 - START */
                L13014 = "时段:" + V1005 .
                display L13014          format "x(40)" skip with fram F1301 no-box.
                /* LABEL 4 - END */
                display "输入或按E退出"       format "x(40)" skip
        skip with fram F1301 no-box.
        Update V1301
        WITH  fram F1301 NO-LABEL
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
        IF V1301 = "e" THEN  LEAVE V1300LMAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F1301.

         /*  ---- Valid Check ---- START */

        find first so_mstr where so_nbr=trim(V1301) and so_site=V1002 no-lock no-error.
 If not avail so_mstr then do:
  display skip "订单不存在" @ WMESSAGE NO-LABEL with fram F1301.
  pause 0 before-hide.
  Undo, retry.
End.
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
     /* END    LINE :1301  昭和订单  */


     /* START  LINE :1302  昭和料号  */
     V1302L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1302           as char format "x(50)".
        define variable PV1302          as char format "x(50)".
        define variable L13021          as char format "x(40)".
        define variable L13022          as char format "x(40)".
        define variable L13023          as char format "x(40)".
        define variable L13024          as char format "x(40)".
        define variable L13025          as char format "x(40)".
        define variable L13026          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        if tmppart<>"" then
        V1302 = tmppart.
        V1302 = ENTRY(1,V1302,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1302 = ENTRY(1,V1302,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        find first sod_det where sod_nbr=trim(V1301) and sod_part=trim(V1302) no-lock no-error.
   If  avail sod_det then
        leave V1302L.
        /* LOGICAL SKIP END */
                display "[销售订单发货n]"     + "*" + TRIM ( V1002 ) + vernbr format "x(40)" skip with fram F1302 no-box.

                /* LABEL 1 - START */
                L13021 = "昭和料号" .
                display L13021          format "x(40)" skip with fram F1302 no-box.
                /* LABEL 1 - END */


                /* LABEL 2 - START */
                L13022 = "客户:" + V1003 .
                display L13022          format "x(40)" skip with fram F1302 no-box.
                /* LABEL 2 - END */


                /* LABEL 3 - START */
                L13023 = "日期:" + V1004 .
                display L13023          format "x(40)" skip with fram F1302 no-box.
                /* LABEL 3 - END */


                /* LABEL 4 - START */
                L13024 = "时段:" + V1005 .
                display L13024          format "x(40)" skip with fram F1302 no-box.
                /* LABEL 4 - END */
                display "输入或按E退出"       format "x(40)" skip
        skip with fram F1302 no-box.
        Update V1302
        WITH  fram F1302 NO-LABEL
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
        IF V1302 = "e" THEN  LEAVE V1300LMAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F1302.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1302.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1302.
        pause 0.
        leave V1302L.
     END.
     PV1302 = V1302.
     /* END    LINE :1302  昭和料号  */


     /* START  LINE :1400  库位[LOC]  */
     V1400L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1400           as char format "x(50)".
        define variable PV1400          as char format "x(50)".
        define variable L14001          as char format "x(40)".
        define variable L14002          as char format "x(40)".
        define variable L14003          as char format "x(40)".
        define variable L14004          as char format "x(40)".
        define variable L14005          as char format "x(40)".
        define variable L14006          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        find first pt_mstr where pt_part = V1302  no-lock no-error.
If AVAILABLE ( pt_mstr ) then
        V1400 = pt_loc.
        V1400 = ENTRY(1,V1400,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1400 = ENTRY(1,V1400,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */
                display "[销售订单发货n]"     + "*" + TRIM ( V1002 ) + vernbr  format "x(40)" skip with fram F1400 no-box.

                /* LABEL 1 - START */
                L14001 = "库位?" .
                display L14001          format "x(40)" skip with fram F1400 no-box.
                /* LABEL 1 - END */


                /* LABEL 2 - START */
                find first pt_mstr where pt_part = V1302  no-lock no-error.
If AVAILABLE ( pt_mstr ) then
                L14002 = pt_loc .
                else L14002 = "" .
                display L14002          format "x(40)" skip with fram F1400 no-box.
                /* LABEL 2 - END */


                /* LABEL 3 - START */
                L14003 = "客户:" +  V1003 + "/" + V1301 .
                display L14003          format "x(40)" skip with fram F1400 no-box.
                /* LABEL 3 - END */


                /* LABEL 4 - START */
                L14004 = "日期:" + V1004 .
                display L14004          format "x(40)" skip with fram F1400 no-box.
                /* LABEL 4 - END */
                display "输入或按E退出"       format "x(40)" skip
        skip with fram F1400 no-box.
        recid(LOC_MSTR) = ?.
        Update V1400
        WITH  fram F1400 NO-LABEL
        /* ROLL BAR START */
        EDITING:
        readkey pause wtimeout.
        if lastkey = -1 then quit.
        if LASTKEY = 404 Then Do: /* DISABLE F4 */
           pause 0 before-hide.
           undo, retry.
        end.
        display skip "^" @ WMESSAGE NO-LABEL with fram F1400.
            IF LASTKEY = keycode("F10") or keyfunction(lastkey) = "CURSOR-DOWN"
            THEN DO:
                  IF recid(LOC_MSTR) = ? THEN find first LOC_MSTR where
                              LOC_SITE = V1002 AND
                              LOC_LOC >=  INPUT V1400
                               no-lock no-error.
                  else do:
                       if LOC_LOC =  INPUT V1400
                       then find next LOC_MSTR
                       WHERE LOC_SITE = V1002
                        no-lock no-error.
                        else find first LOC_MSTR where
                              LOC_SITE = V1002 AND
                              LOC_LOC >=  INPUT V1400
                               no-lock no-error.
                  end.
                  IF AVAILABLE LOC_MSTR then display skip
            LOC_LOC @ V1400 LOC_DESC @ WMESSAGE NO-LABEL with fram F1400.
                  else   display skip "" @ WMESSAGE with fram F1400.
            END.
            IF LASTKEY = keycode("F9") or keyfunction(lastkey) = "CURSOR-UP"
            THEN DO:
                  IF recid(LOC_MSTR) = ? THEN find last LOC_MSTR where
                              LOC_SITE = V1002 AND
                              LOC_LOC <=  INPUT V1400
                               no-lock no-error.
                  else do:
                       if LOC_LOC =  INPUT V1400
                       then find prev LOC_MSTR
                       where LOC_SITE = V1002
                        no-lock no-error.
                        else find first LOC_MSTR where
                              LOC_SITE = V1002 AND
                              LOC_LOC >=  INPUT V1400
                               no-lock no-error.
                  end.
                  IF AVAILABLE LOC_MSTR then display skip
            LOC_LOC @ V1400 LOC_DESC @ WMESSAGE NO-LABEL with fram F1400.
                  else   display skip "" @ WMESSAGE with fram F1400.
            END.
            APPLY LASTKEY.
        END.
        /* ROLL BAR END */


        /* PRESS e EXIST CYCLE */
        IF V1400 = "e" THEN  LEAVE V1300LMAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F1400.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1400.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
        find first LOC_MSTR where LOC_LOC = V1400 AND LOC_SITE = V1002  no-lock no-error.
        IF NOT AVAILABLE LOC_MSTR then do:
                display skip "Error , Retry." @ WMESSAGE NO-LABEL with fram F1400.
                pause 0 before-hide.
                undo, retry.
        end.
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1400.
        pause 0.
        leave V1400L.
     END.
     PV1400 = V1400.
     /* END    LINE :1400  库位[LOC]  */


     /* START  LINE :1410  L Control  */
     V1410L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1410           as char format "x(50)".
        define variable PV1410          as char format "x(50)".
        define variable L14101          as char format "x(40)".
        define variable L14102          as char format "x(40)".
        define variable L14103          as char format "x(40)".
        define variable L14104          as char format "x(40)".
        define variable L14105          as char format "x(40)".
        define variable L14106          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        find first pt_mstr where pt_part = V1302  no-lock no-error.
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

                display "[销售订单发货n]"     + "*" + TRIM ( V1002 ) + vernbr  format "x(40)" skip with fram F1410 no-box.

                /* LABEL 1 - START */
                  L14101 = "" .
                display L14101          format "x(40)" skip with fram F1410 no-box.
                /* LABEL 1 - END */


                /* LABEL 2 - START */
                  L14102 = "" .
                display L14102          format "x(40)" skip with fram F1410 no-box.
                /* LABEL 2 - END */


                /* LABEL 3 - START */
                  L14103 = "" .
                display L14103          format "x(40)" skip with fram F1410 no-box.
                /* LABEL 3 - END */


                /* LABEL 4 - START */
                  L14104 = "" .
                display L14104          format "x(40)" skip with fram F1410 no-box.
                /* LABEL 4 - END */
                display "输入或按E退出"       format "x(40)" skip
        skip with fram F1410 no-box.
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
        define variable V1500           as char format "x(50)".
        define variable PV1500          as char format "x(50)".
        define variable L15001          as char format "x(40)".
        define variable L15002          as char format "x(40)".
        define variable L15003          as char format "x(40)".
        define variable L15004          as char format "x(40)".
        define variable L15005          as char format "x(40)".
        define variable L15006          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        V1500 = ( if ENTRY(2, PV1300, "@") = "" then "" else ENTRY(2, PV1300, "@") ).
        V1500 = ENTRY(1,V1500,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1500 = ENTRY(1,V1500,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        IF V1410 <> "L" then
        leave V1500L.
        /* LOGICAL SKIP END */
                display "[销售订单发货n]"     + "*" + TRIM ( V1002 ) + vernbr format "x(40)" skip with fram F1500 no-box.

                /* LABEL 1 - START */
                L15001 = "批号?" .
                display L15001          format "x(40)" skip with fram F1500 no-box.
                /* LABEL 1 - END */


                /* LABEL 2 - START */
                find first ld_det where ld_part = V1302 and ld_loc = V1400 and ld_site = V1002 and ld_ref = "" and ld_qty_oh <> 0 use-index ld_part_lot no-lock no-error.
If AVAILABLE ( ld_det ) then
                L15002 = "最小:" + trim(ld_lot) .
                else L15002 = "" .
                     v_L15002 = TRIM(ld_lot) .
                display L15002          format "x(40)" skip with fram F1500 no-box.
                /* LABEL 2 - END */


                /* LABEL 3 - START */
                find first ld_det where ld_part = V1302 and ld_loc = V1400 and ld_site = V1002 and ld_ref = "" and ld_qty_oh <> 0 use-index ld_part_lot no-lock no-error.
If AVAILABLE ( ld_det ) then
                L15003 = "库存:" + trim(string(ld_qty_oh)) .
                else L15003 = "" .
                display L15003          format "x(40)" skip with fram F1500 no-box.
                /* LABEL 3 - END */


                /* LABEL 4 - START */
                L15004 = "图号:" + trim( tmppart ) .
                display L15004          format "x(40)" skip with fram F1500 no-box.
                /* LABEL 4 - END */
                display "输入或按E退出"       format "x(40)" skip
        skip with fram F1500 no-box.
        recid(LD_DET) = ?.
        Update V1500
        WITH  fram F1500 NO-LABEL
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
                  IF recid(LD_DET) = ? THEN find first LD_DET where
                              LD_PART = V1302 AND LD_LOC = V1400 AND LD_QTY_OH <> 0 AND LD_SITE = V1002 AND LD_REF = "" AND
                              LD_LOT >=  INPUT V1500
                               no-lock no-error.
                  else do:
                       if LD_LOT =  INPUT V1500
                       then find next LD_DET
                       WHERE LD_PART = V1302 AND LD_LOC = V1400 AND LD_QTY_OH <> 0 AND LD_SITE = V1002 AND LD_REF = ""
                        no-lock no-error.
                        else find first LD_DET where
                              LD_PART = V1302 AND LD_LOC = V1400 AND LD_QTY_OH <> 0 AND LD_SITE = V1002 AND LD_REF = "" AND
                              LD_LOT >=  INPUT V1500
                               no-lock no-error.
                  end.
                  IF AVAILABLE LD_DET then display skip
            LD_LOT @ V1500 LD_LOT + "/" + trim(string(LD_QTY_OH)) @ WMESSAGE NO-LABEL with fram F1500.
                  else   display skip "" @ WMESSAGE with fram F1500.
            END.
            IF LASTKEY = keycode("F9") or keyfunction(lastkey) = "CURSOR-UP"
            THEN DO:
                  IF recid(LD_DET) = ? THEN find last LD_DET where
                              LD_PART = V1302 AND LD_LOC = V1400 AND LD_QTY_OH <> 0 AND LD_SITE = V1002 AND LD_REF = "" AND
                              LD_LOT <=  INPUT V1500
                               no-lock no-error.
                  else do:
                       if LD_LOT =  INPUT V1500
                       then find prev LD_DET
                       where LD_PART = V1302 AND LD_LOC = V1400 AND LD_QTY_OH <> 0 AND LD_SITE = V1002 AND LD_REF = ""
                        no-lock no-error.
                        else find first LD_DET where
                              LD_PART = V1302 AND LD_LOC = V1400 AND LD_QTY_OH <> 0 AND LD_SITE = V1002 AND LD_REF = "" AND
                              LD_LOT >=  INPUT V1500
                               no-lock no-error.
                  end.
                  IF AVAILABLE LD_DET then display skip
            LD_LOT @ V1500 LD_LOT + "/" + trim(string(LD_QTY_OH)) @ WMESSAGE NO-LABEL with fram F1500.
                  else   display skip "" @ WMESSAGE with fram F1500.
            END.
            APPLY LASTKEY.
        END.
        /* ROLL BAR END */
        /* PRESS e EXIST CYCLE */
        IF V1500 = "e" THEN  LEAVE V1300LMAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F1500.

         /*  ---- Valid Check ---- START */

        if substring(V1500,1,1)="S" then V1500=substring(V1500,2,18).

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1500.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
        /* SS - 20071226.1 - B */
        IF LENGTH(v1500) < 6 OR SUBSTRING(v_L15002,1,6) <> SUBSTRING(v1500,1,6) THEN DO:
                FIND FIRST codemstr WHERE codemstr.CODE_fldname = "bcuser" AND codemstr.CODE_value = GLOBAL_userid NO-LOCK NO-ERROR.
                IF NOT AVAIL codemstr OR (AVAIL codemstr AND codemstr.CODE_cmmt = "NO") THEN DO:
                    display skip "该用户没有权限,请通知上级主管批准" @ WMESSAGE NO-LABEL with fram F1500.
                    pause 0 before-hide.
                    undo, retry.
                END.
        END.
        /* SS - 20071226.1 - E */

        IF not ( IF INDEX(V1500,"@" ) <> 0 then ENTRY(2,V1500,"@") else V1500 ) <> "" THEN DO:
                display skip "L控制,不能为空" @ WMESSAGE NO-LABEL with fram F1500.
                pause 0 before-hide.
                undo, retry.
        end.
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1500.
        pause 0.
        leave V1500L.
     END.
     IF INDEX(V1500,"@" ) <> 0 then V1500 = ENTRY(2,V1500,"@").
     PV1500 = V1500.
     /* END    LINE :1500  批号[LOT]  */


     /* START  LINE :1550  MIN LOT and QTY  */
     V1550L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1550           as char format "x(50)".
        define variable PV1550          as char format "x(50)".
        define variable L15501          as char format "x(40)".
        define variable L15502          as char format "x(40)".
        define variable L15503          as char format "x(40)".
        define variable L15504          as char format "x(40)".
        define variable L15505          as char format "x(40)".
        define variable L15506          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        find first ld_det where ld_part = V1302 and ld_site = V1002 and ld_ref = "" and ld_loc = V1400 and ld_qty_oh <> 0 use-index ld_part_lot no-lock no-error.
If AVAILABLE ( ld_det ) then
        V1550 = trim(ld_lot) + fill( " ", 18 - length ( trim ( ld_lot ) ) ) + string( ld_qty_oh ).
        V1550 = ENTRY(1,V1550,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1550 = ENTRY(1,V1550,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */

        /* --FIRST TIME SKIP -- START  */
         if sectionid = 1 then leave V1550L.
        /* --FIRST TIME SKIP -- END  */


        /* --CYCLE TIME SKIP -- START  */
         if sectionid > 1 then leave V1550L .
        /* --CYCLE TIME SKIP -- END  */

                display "[销售订单发货n]"     + "*" + TRIM ( V1002 ) + vernbr format "x(40)" skip with fram F1550 no-box.

                /* LABEL 1 - START */
                L15501 = "1- 18 LOT NO" .
                display L15501          format "x(40)" skip with fram F1550 no-box.
                /* LABEL 1 - END */


                /* LABEL 2 - START */
                  L15502 = "" .
                display L15502          format "x(40)" skip with fram F1550 no-box.
                /* LABEL 2 - END */


                /* LABEL 3 - START */
                  L15503 = "" .
                display L15503          format "x(40)" skip with fram F1550 no-box.
                /* LABEL 3 - END */


                /* LABEL 4 - START */
                L15504 = "图号:" + trim( tmppart ) .
                display L15504          format "x(40)" skip with fram F1550 no-box.
                /* LABEL 4 - END */
                display "输入或按E退出"       format "x(40)" skip
        skip with fram F1550 no-box.
        /* DISPLAY ONLY */
        define variable X1550           as char format "x(40)".
        X1550 = V1550.
        V1550 = "".
        /* DISPLAY ONLY */
        Update V1550
        WITH  fram F1550 NO-LABEL
        EDITING:
          readkey pause wtimeout.
          if lastkey = -1 Then quit.
        if LASTKEY = 404 Then Do: /* DISABLE F4 */
           pause 0 before-hide.
           undo, retry.
        end.
           apply lastkey.
        end.
        V1550 = X1550.
        /* DISPLAY ONLY */
        LEAVE V1550L.
        /* DISPLAY ONLY */

        /* PRESS e EXIST CYCLE */
        IF V1550 = "e" THEN  LEAVE V1300LMAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F1550.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1550.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1550.
        pause 0.
        leave V1550L.
     END.
     PV1550 = V1550.
     /* END    LINE :1550  MIN LOT and QTY  */


     /* START  LINE :1551  销售订单[SalesOrder]  */
     V1551L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1551           as char format "x(50)".
        define variable PV1551          as char format "x(50)".
        define variable L15511          as char format "x(40)".
        define variable L15512          as char format "x(40)".
        define variable L15513          as char format "x(40)".
        define variable L15514          as char format "x(40)".
        define variable L15515          as char format "x(40)".
        define variable L15516          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        V1551 = V1301.
        V1551 = ENTRY(1,V1551,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1551 = ENTRY(1,V1551,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        find last so_mstr where so_site=trim(V1002) and so_cust=trim(V1003) and so_nbr=trim(V1551) no-lock no-error.
If   avail so_mstr and so_nbr=trim(V1551) then
        leave V1551L.
        /* LOGICAL SKIP END */
                display "[销售订单发货n]"     + "*" + TRIM ( V1002 ) + vernbr format "x(40)" skip with fram F1551 no-box.

                /* LABEL 1 - START */
                L15511 = "销售订单?" .
                display L15511          format "x(40)" skip with fram F1551 no-box.
                /* LABEL 1 - END */


                /* LABEL 2 - START */
                  L15512 = "" .
                display L15512          format "x(40)" skip with fram F1551 no-box.
                /* LABEL 2 - END */


                /* LABEL 3 - START */
                  L15513 = "" .
                display L15513          format "x(40)" skip with fram F1551 no-box.
                /* LABEL 3 - END */


                /* LABEL 4 - START */
                  L15514 = "" .
                display L15514          format "x(40)" skip with fram F1551 no-box.
                /* LABEL 4 - END */
                display "输入或按E退出"       format "x(40)" skip
        skip with fram F1551 no-box.
        recid(so_mstr) = ?.
        Update V1551
        WITH  fram F1551 NO-LABEL
        /* ROLL BAR START */
        EDITING:
        readkey pause wtimeout.
        if lastkey = -1 then quit.
        if LASTKEY = 404 Then Do: /* DISABLE F4 */
           pause 0 before-hide.
           undo, retry.
        end.
        display skip "^" @ WMESSAGE NO-LABEL with fram F1551.
            IF LASTKEY = keycode("F10") or keyfunction(lastkey) = "CURSOR-DOWN"
            THEN DO:
                  IF recid(so_mstr) = ? THEN find first so_mstr where
                              so_nbr >=  INPUT V1551
                               no-lock no-error.
                  else do:
                       if so_nbr =  INPUT V1551
                       then find next so_mstr
                        no-lock no-error.
                        else find first so_mstr where
                              so_nbr >=  INPUT V1551
                               no-lock no-error.
                  end.
                  IF AVAILABLE so_mstr then display skip
            so_nbr @ V1551 so_nbr + "*" + V1003 @ WMESSAGE NO-LABEL with fram F1551.
                  else   display skip "" @ WMESSAGE with fram F1551.
            END.
            IF LASTKEY = keycode("F9") or keyfunction(lastkey) = "CURSOR-UP"
            THEN DO:
                  IF recid(so_mstr) = ? THEN find last so_mstr where
                              so_nbr <=  INPUT V1551
                               no-lock no-error.
                  else do:
                       if so_nbr =  INPUT V1551
                       then find prev so_mstr
                        no-lock no-error.
                        else find first so_mstr where
                              so_nbr >=  INPUT V1551
                               no-lock no-error.
                  end.
                  IF AVAILABLE so_mstr then display skip
            so_nbr @ V1551 so_nbr + "*" + V1003 @ WMESSAGE NO-LABEL with fram F1551.
                  else   display skip "" @ WMESSAGE with fram F1551.
            END.
            APPLY LASTKEY.
        END.
        /* ROLL BAR END */


        /* PRESS e EXIST CYCLE */
        IF V1551 = "e" THEN  LEAVE V1300LMAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F1551.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1551.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1551.
        pause 0.
        leave V1551L.
     END.
     PV1551 = V1551.
     /* END    LINE :1551  销售订单[SalesOrder]  */


     /* START  LINE :1553  客户代码[Customer Code]  */
     V1553L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1553           as char format "x(50)".
        define variable PV1553          as char format "x(50)".
        define variable L15531          as char format "x(40)".
        define variable L15532          as char format "x(40)".
        define variable L15533          as char format "x(40)".
        define variable L15534          as char format "x(40)".
        define variable L15535          as char format "x(40)".
        define variable L15536          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        find first so_mstr where so_nbr  = V1551 no-lock no-error.
If AVAILABLE ( so_mstr ) then
        V1553 = so_cust.
        V1553 = ENTRY(1,V1553,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1553 = ENTRY(1,V1553,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        if 1=1 then
        leave V1553L.
        /* LOGICAL SKIP END */
                display "[销售订单发货n]"     + "*" + TRIM ( V1002 ) + vernbr  format "x(40)" skip with fram F1553 no-box.

                /* LABEL 1 - START */
                  L15531 = "" .
                display L15531          format "x(40)" skip with fram F1553 no-box.
                /* LABEL 1 - END */


                /* LABEL 2 - START */
                  L15532 = "" .
                display L15532          format "x(40)" skip with fram F1553 no-box.
                /* LABEL 2 - END */


                /* LABEL 3 - START */
                  L15533 = "" .
                display L15533          format "x(40)" skip with fram F1553 no-box.
                /* LABEL 3 - END */


                /* LABEL 4 - START */
                  L15534 = "" .
                display L15534          format "x(40)" skip with fram F1553 no-box.
                /* LABEL 4 - END */
                display "输入或按E退出"       format "x(40)" skip
        skip with fram F1553 no-box.
        Update V1553
        WITH  fram F1553 NO-LABEL
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
        IF V1553 = "e" THEN  LEAVE V1300LMAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F1553.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1553.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1553.
        pause 0.
        leave V1553L.
     END.
     PV1553 = V1553.
     /* END    LINE :1553  客户代码[Customer Code]  */


     /* START  LINE :1555  订单项次  */
     V1555L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1555           as char format "x(50)".
        define variable PV1555          as char format "x(50)".
        define variable L15551          as char format "x(40)".
        define variable L15552          as char format "x(40)".
        define variable L15553          as char format "x(40)".
        define variable L15554          as char format "x(40)".
        define variable L15555          as char format "x(40)".
        define variable L15556          as char format "x(40)".
        DEF VAR v_qty_ord AS CHAR.
        DEF VAR v_qty_ship AS CHAR.
        DEF VAR v_due_date AS CHAR.
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        /* SS - 20080121.1 - B */
        v_qty_ord = "".
        v_qty_ship = "" .
        v_due_date = "" .
        find first sod_det where sod_nbr=trim(V1551) and sod_part=trim(V1302) and sod_site = trim(V1002)
            AND string(year(sod_due_date),"9999") + "-" + STRING(MONTH(sod_due_date),"99") + "-" + STRING(DAY(sod_due_date),"99") = TRIM(v1004) no-lock no-error.
        If avail sod_det then do:
           assign
               V1555=string(sod_line)
               v_qty_ord = string(sod_qty_ord)
               v_qty_ship = string(sod_qty_ship)
               v_due_date = STRING(sod_due_date)
               .
        End.
        /* SS - 20080121.1 - B */
If V1555<>"" then
        V1555 = V1555.
        V1555 = ENTRY(1,V1555,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1555 = ENTRY(1,V1555,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* SS - 20080121.1 - B */
        /*
        find first sod_det where sod_nbr = trim(V1551) and sod_site = trim(V1002) and string ( sod_line ) = trim(V1555)  and sod_confirm no-lock no-error.
        If AVAILABLE (sod_det) then
        leave V1555L.
        */
        /* SS - 20080121.1 - B */
        /* LOGICAL SKIP END */

                display "[销售订单发货n]"     + "*" + TRIM ( V1002 ) + vernbr format "x(40)" skip with fram F1555 no-box.

                /* LABEL 1 - START */
                L15551 = "订单项次" .
                display L15551          format "x(40)" skip with fram F1555 no-box.
                /* LABEL 1 - END */


                /* LABEL 2 - START */
                /* SS - 20080116.1 - B */
                /*
                  L15552 = "" .
                display L15552          format "x(40)" skip with fram F1555 no-box.
                */
                /* SS - 20080121.1 - B */
                /*
                FIND FIRST sod_det WHERE sod_nbr = v1551 AND sod_site = v1002 AND sod_confirm AND sod_part = v1300 AND sod_due_date >= TODAY NO-LOCK NO-ERROR.
                IF AVAIL (sod_det) THEN L15552 = "项次:" + STRING(sod_line) .
                ELSE L15552 = "" .
                 */
                L15552 = "项次:" + v1555 .
                /* SS - 20080121.1 - B */
                display L15552          format "x(40)" skip with fram F1555 no-box.
                /* SS - 20080116.1 - E */
                /* LABEL 2 - END */

                /* LABEL 3 - START */
                /* SS - 20080116.1 - B */
                /*
                  L15553 = "" .
                display L15553          format "x(40)" skip with fram F1555 no-box.
                */
                /* SS - 20080121.1 - B */
                /*
                FIND FIRST sod_det WHERE sod_nbr = v1551 AND sod_site = v1002 AND sod_confirm AND sod_part = v1300 AND sod_due_date >= TODAY NO-LOCK NO-ERROR.
                IF AVAIL sod_det THEN L15553 = "订单/已发:" + STRING(sod_qty_ord) + "/" + STRING(sod_qty_ship) .
                ELSE L15553 = "" .
                */
                L15553 = "订单/已发:" + v_qty_ord + "/" + v_qty_ship .
                /* SS - 20080121.1 - B */
                display L15553          format "x(40)" skip with fram F1555 no-box.
                /* SS - 20080116.1 - E */
                /* LABEL 3 - END */


                /* LABEL 4 - START */
                /* SS - 20080116.1 - B */
                /*
                  L15554 = "" .
                display L15554          format "x(40)" skip with fram F1555 no-box.
                */
                /* SS - 20080121.1 - B */
                /*
                FIND FIRST sod_det WHERE sod_nbr = v1551 AND sod_site = v1002 AND sod_confirm AND sod_part = v1300 AND sod_due_date >= TODAY NO-LOCK NO-ERROR.
                IF AVAIL sod_det THEN L15554 = "到 期 日 :" + STRING(sod_due_date) .
                ELSE L15554 = "" .
                     */
                L15554 = "到 期 日 :" + v_due_date .
                /* SS - 20080121.1 - B */
                display L15554          format "x(40)" skip with fram F1555 no-box.
                /* SS - 20080116.1 - E */
                /* LABEL 4 - END */
                display "输入或按E退出"       format "x(40)" skip
        skip with fram F1555 no-box.
        recid(sod_det) = ?.
        Update V1555
        WITH  fram F1555 NO-LABEL
        /* ROLL BAR START */
        EDITING:
        readkey pause wtimeout.
        if lastkey = -1 then quit.
        if LASTKEY = 404 Then Do: /* DISABLE F4 */
           pause 0 before-hide.
           undo, retry.
        end.
        display skip "^" @ WMESSAGE NO-LABEL with fram F1555.
            IF LASTKEY = keycode("F10") or keyfunction(lastkey) = "CURSOR-DOWN"
            THEN DO:
                  IF recid(sod_det) = ? THEN find first sod_det where
                              sod_nbr = trim(V1551) and sod_site = trim(V1002) and sod_part=V1302 and sod_confirm AND
                              string (SOD_LINE ) >=  INPUT V1555
                               no-lock no-error.
                  else do:
                       if string (SOD_LINE ) =  INPUT V1555
                       then find next sod_det
                       WHERE sod_nbr = trim(V1551) and sod_site = trim(V1002) and sod_part=V1302 and sod_confirm
                        no-lock no-error.
                        else find first sod_det where
                              sod_nbr = trim(V1551) and sod_site = trim(V1002) and sod_part=V1302 and sod_confirm AND
                              string (SOD_LINE ) >=  INPUT V1555
                               no-lock no-error.
                  end.
                  /* SS - 20090601.1 - B */
                  /*
                  IF AVAILABLE sod_det then display skip
            string (SOD_LINE ) @ V1555 sod_nbr + "*" + trim(SOD_custPART) + "*" + string(SOD_DUE_DATE) @ WMESSAGE NO-LABEL with fram F1555.
                  */
                  IF AVAILABLE sod_det then display skip
            string (SOD_LINE ) @ V1555 sod_nbr + "*" + string(SOD_DUE_DATE) + "*" + trim(SOD_custPART) @ WMESSAGE NO-LABEL with fram F1555.
                  /* SS - 20090601.1 - E */
                  else   display skip "" @ WMESSAGE with fram F1555.
            END.
            IF LASTKEY = keycode("F9") or keyfunction(lastkey) = "CURSOR-UP"
            THEN DO:
                  IF recid(sod_det) = ? THEN find last sod_det where
                              sod_nbr = trim(V1551) and sod_site = trim(V1002) and sod_part=V1302 and sod_confirm AND
                              string (SOD_LINE ) <=  INPUT V1555
                               no-lock no-error.
                  else do:
                       if string (SOD_LINE ) =  INPUT V1555
                       then find prev sod_det
                       where sod_nbr = trim(V1551) and sod_site = trim(V1002) and sod_part=V1302 and sod_confirm
                        no-lock no-error.
                        else find first sod_det where
                              sod_nbr = trim(V1551) and sod_site = trim(V1002) and sod_part=V1302 and sod_confirm AND
                              string (SOD_LINE ) >=  INPUT V1555
                               no-lock no-error.
                  end.
                  /* SS - 20090601.1 - B */
                  /*
                  IF AVAILABLE sod_det then display skip
            string (SOD_LINE ) @ V1555 sod_nbr + "*" + trim(SOD_custPART) + "*" + string(SOD_DUE_DATE) @ WMESSAGE NO-LABEL with fram F1555.
                   */
                  IF AVAILABLE sod_det then display skip
            string (SOD_LINE ) @ V1555 sod_nbr + "*" + string(SOD_DUE_DATE) + "*" + trim(SOD_custPART) @ WMESSAGE NO-LABEL with fram F1555.
                  /* SS - 20090601.1 - E */
                  else   display skip "" @ WMESSAGE with fram F1555.
            END.
            APPLY LASTKEY.
        END.
        /* ROLL BAR END */


        /* PRESS e EXIST CYCLE */
        IF V1555 = "e" THEN  LEAVE V1300LMAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F1555.

         /*  ---- Valid Check ---- START */

        find first sod_det where sod_nbr = trim(V1551) and sod_site = trim(V1002) and string ( sod_line ) = trim(V1555)  and sod_confirm no-lock no-error.
If not AVAILABLE (sod_det) then do:
  display skip "订单项不存在" @ WMESSAGE NO-LABEL with fram F1555.
  pause 0 before-hide.
  Undo, retry.
end.
        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1555.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1555.
        pause 0.
        leave V1555L.
     END.
     PV1555 = V1555.
     /* END    LINE :1555  订单项次  */

     /* START  LINE :1600  数量[QTY]  */
     V1600L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1600           as char format "x(50)".
        define variable PV1600          as char format "x(50)".
        define variable L16001          as char format "x(40)".
        define variable L16002          as char format "x(40)".
        define variable L16003          as char format "x(40)".
        define variable L16004          as char format "x(40)".
        define variable L16005          as char format "x(40)".
        define variable L16006          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        V1600 = "发料数量".
        V1600 = ENTRY(1,V1600,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1600 = " ".
        V1600 = ENTRY(1,V1600,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */
                display "[销售订单发货n]"     + "*" + TRIM ( V1002 )  + vernbr format "x(40)" skip with fram F1600 no-box.

                /* LABEL 1 - START */
                L16001 = "发货数量?" .
                display L16001          format "x(40)" skip with fram F1600 no-box.
                /* LABEL 1 - END */


                /* LABEL 2 - START */
                L16002 = "图号:" + trim( tmppart ) .
                display L16002          format "x(40)" skip with fram F1600 no-box.
                /* LABEL 2 - END */


                /* LABEL 3 - START */
                L16003 = "批号:" + Trim(V1500) .
                display L16003          format "x(40)" skip with fram F1600 no-box.
                /* LABEL 3 - END */


                /* LABEL 4 - START */
                find first ld_det where ld_part = V1302 and ld_site = V1002 and
ld_ref = ""     and
ld_loc = V1400  and
ld_lot = V1500  and ld_qty_oh <> 0 use-index ld_part_lot no-lock no-error.
If AVAILABLE ( ld_det ) then
                L16004 = "库存:" + trim(V1400) + "/" + string ( ld_qty_oh ) .
                else L16004 = "" .
                display L16004          format "x(40)" skip with fram F1600 no-box.
                /* LABEL 4 - END */
                display "输入或按E退出"       format "x(40)" skip
        skip with fram F1600 no-box.
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
        if substring(V1600,1,1)="q" then V1600=substring(V1600,2,18).

        /* ss - ching B */
          def var tmpqq as dec.
          def var tmpqq1 as dec.
        tmpqq = 0.
        tmpqq1 = 0.

        /* SS - 20090325.1 - B */

/* SS 090818.1 - B */
/*
        for FIRST xxsod_det where trim(xxsod_cust) = trim(V1003) and trim(xxsod_due_date1)=trim(V1004) and trim(xxsod_due_time1)=trim(V1005)
           AND TRIM(xxsod_part) = custpart no-LOCK :
        END.
        IF AVAIL xxsod_det THEN DO:
           assign
              tmpqq = xxsod__dec01
              tmpqq1 = xxsod_qty_ord.
        End.
*/
        for each xxsod_det where trim(xxsod_cust) = trim(V1003) and trim(xxsod_due_date1)=trim(V1004) and trim(xxsod_due_time1)=trim(V1005)
           AND TRIM(xxsod_part) = custpart no-LOCK :
            tmpqq = tmpqq + xxsod__dec01 .
            tmpqq1 = tmpqq1 + xxsod_qty_ord.
        end.
        if tmpqq + dec(V1600) > tmpqq1 then do:
          display skip "发货量大于订单量" + string(dec(V1600) + tmpqq - tmpqq1) @ WMESSAGE NO-LABEL with fram F1600.
          pause 0 before-hide.
          Undo, retry.
        end.
/* SS 090818.1 - E */
        /* SS - 20090325.1 - E */

/* SS 090902.1 - B */

/* SS 090911.1 - B */
        tmpqq1 = 0.
        find first sod_det where sod_nbr = trim(V1551) and string ( sod_line ) = trim(V1555) no-lock no-error.
        if avail sod_det then tmpqq1 = sod_qty_ord - sod_qty_ship.
        if tmpqq1 - dec(V1600) < 0 then do:
          display skip "发货量大于订单量" + string(dec(V1600) - tmpqq1) @ WMESSAGE NO-LABEL with fram F1600.
          pause 0 before-hide.
          Undo, retry.
        end.
/* SS 090911.1 - E */

        tmpqq = 0.
        tmpqq1 = 0.
        for each xxsod_det where trim(xxsod_cust) = trim(V1003) and trim(xxsod_due_date1)=trim(V1004) AND TRIM(xxsod_part) = custpart no-LOCK :
          tmpqq = tmpqq + xxsod__dec01.
        end.
        find first sod_det where sod_nbr = trim(V1551) and string ( sod_line ) = trim(V1555) no-lock no-error.
        if avail sod_det then tmpqq1 = sod_qty_ord.
/* SS 090902.1 - E */

/* SS 090911.1 - B */
/*
        If (tmpqq + dec(V1600)) > tmpqq1 and   DECIMAL ( V1600 ) >0 and tmpqq1>0 then do:
*/
        If (tmpqq + dec(V1600)) > tmpqq1 and   DECIMAL ( V1600 ) >= 0 and tmpqq1 >= 0  then do:
/* SS 090911.1 - E */
          display skip "发货量大于订单量" + string(tmpqq + dec(V1600) - tmpqq1) @ WMESSAGE NO-LABEL with fram F1600.
          pause 0 before-hide.
          Undo, retry.
        End.

        If   abs(DECIMAL ( V1600 ) + tmpqq) >abs(tmpqq1) and DECIMAL ( V1600 )<0  and   tmpqq1<0 then do:
          display skip "发货量大于订单量" + string(tmpqq + dec(V1600) - tmpqq1) @ WMESSAGE NO-LABEL with fram F1600.
          pause 0 before-hide.
          Undo, retry.
        End.
        /* ss - ching E */

/*if   abs(tmpqq) < abs(DECIMAL ( V1600 ))  and DECIMAL ( V1600 ) < 0 and    tmpqq1>0  then do:
 display skip "冲数不能大于订货量" + string(tmpqq) @ WMESSAGE NO-LABEL with  fram F1600.
 pause 0 before-hide.
 Undo, retry.
End.



If   abs(tmpqq) < DECIMAL ( V1600 ) and DECIMAL ( V1600 )>0  and   tmpqq1<0 then do:
  display skip "冲数不能大于订货量" + string(tmpqq + dec(V1600) - tmpqq1) @ WMESSAGE NO-LABEL with fram F1600.
  pause 0 before-hide.
  Undo, retry.
End.
*/
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
        find first LD_DET where ld_part  = tmppart AND ld_loc = V1400 and
        ld_site = V1002 and ld_ref = "" and  ld_lot = V1500 and  ld_QTY_oh >= DECIMAL ( V1600 )  no-lock no-error.
        IF NOT AVAILABLE LD_DET then do:
                display skip "在库数 <: " + string( V1600 ) @ WMESSAGE NO-LABEL with fram F1600.
                pause 0 before-hide.
                undo, retry.

        end.
        /*20081026*/
        /*
        IF not V1600 <> "0" THEN DO:
                display skip "在库数 <: " + string( V1600 ) @ WMESSAGE NO-LABEL with fram F1600.
                pause 0 before-hide.
                undo, retry.
        end.
        */
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1600.
        pause 0.
        leave V1600L.
     END.
     PV1600 = V1600.
     /* END    LINE :1600  数量[QTY]  */


     /* START  LINE :1700  确认[CONFIRM]  */
     V1700L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1700           as char format "x(50)".
        define variable PV1700          as char format "x(50)".
        define variable L17001          as char format "x(40)".
        define variable L17002          as char format "x(40)".
        define variable L17003          as char format "x(40)".
        define variable L17004          as char format "x(40)".
        define variable L17005          as char format "x(40)".
        define variable L17006          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        /* SS - 20080116.1 - B */
        /*
        V1700 = "E".
        */
        V1700 = "Y".
        /* SS - 20080116.1 - E */
        V1700 = ENTRY(1,V1700,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1700 = ENTRY(1,V1700,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */
                display "[销售订单发货n]"     + "*" + TRIM ( V1002 )  + vernbr format "x(40)" skip with fram F1700 no-box.

                /* LABEL 1 - START */
                L17001 = "图号:" + trim(tmppart) .
                display L17001          format "x(40)" skip with fram F1700 no-box.
                /* LABEL 1 - END */


                /* LABEL 2 - START */
                L17002 = "批号:" + trim ( V1500 ) .
                display L17002          format "x(40)" skip with fram F1700 no-box.
                /* LABEL 2 - END */


                /* LABEL 3 - START */
                L17003 = "库位:" + trim ( V1400 ) + "/" + trim( V1600 ) .
                display L17003          format "x(40)" skip with fram F1700 no-box.
                /* LABEL 3 - END */


                /* LABEL 4 - START */
                find first sod_det where sod_nbr = V1551 and sod_line = integer ( V1553 )  no-lock no-error.
If AVAILABLE ( sod_det ) then
                L17004 = "订单未决数量:" + ( if sod_qty_ord <= sod_qty_ship then "0" else ( string ( sod_qty_ord - sod_qty_ship ) ) ) .
                else L17004 = "" .
                display L17004          format "x(40)" skip with fram F1700 no-box.
                /* LABEL 4 - END */
                display "确认过帐[Y],E退出"   format "x(40)" skip
        skip with fram F1700 no-box.
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
        find first so_mstr where so_nbr = V1551  NO-ERROR NO-WAIT.
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


     /* START  LINE :9000  BEFORE POST LAST TRANSACTION  */
     V9000L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V9000           as char format "x(50)".
        define variable PV9000          as char format "x(50)".
        define variable L90001          as char format "x(40)".
        define variable L90002          as char format "x(40)".
        define variable L90003          as char format "x(40)".
        define variable L90004          as char format "x(40)".
        define variable L90005          as char format "x(40)".
        define variable L90006          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        find last tr_hist where tr_trnbr >= 0 no-lock no-error.
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

                display "[销售订单发货n]"     + "*" + TRIM ( V1002 )  + vernbr format "x(40)" skip with fram F9000 no-box.

                /* LABEL 1 - START */
                  L90001 = "" .
                display L90001          format "x(40)" skip with fram F9000 no-box.
                /* LABEL 1 - END */


                /* LABEL 2 - START */
                  L90002 = "" .
                display L90002          format "x(40)" skip with fram F9000 no-box.
                /* LABEL 2 - END */


                /* LABEL 3 - START */
                  L90003 = "" .
                display L90003          format "x(40)" skip with fram F9000 no-box.
                /* LABEL 3 - END */


                /* LABEL 4 - START */
                  L90004 = "" .
                display L90004          format "x(40)" skip with fram F9000 no-box.
                /* LABEL 4 - END */
                display "输入或按E退出"       format "x(40)" skip
        skip with fram F9000 no-box.
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


        display "...PROCESSING...  " NO-LABEL with fram F9000X no-box.
        pause 0.
     /*  Update MFG/PRO START  */
     /*20081026*/
     IF V1600 <> "0" THEN DO:

/* SS 090911.1 - B */
        do transaction on error undo ,leave V1300LMAINLOOP:
/* SS 090911.1 - E */
          {xssoi11u.i}
/* SS 090912.1 - B */
          find last tr_hist where tr_date = today and   tr_trnbr > integer ( V9000 ) and
            tr_nbr  = V1551 and  tr_type = "ISS-SO"  and  tr_site = V1002     and tr_part = V1302     and tr_serial = V1500
          use-index tr_date_trn no-lock no-error.
          if NOT AVAILABLE ( tr_hist ) then do:
            undo,leave V1300LMAINLOOP.
          end.
          tmpqq = 0.
          tmpqq1 = 0.
          for FIRST xxsod_det where trim(xxsod_cust) = trim(V1003) and trim(xxsod_due_date1) = trim(V1004) and trim(xxsod_due_time1) = trim(V1005)
            and TRIM(xxsod_part) = custpart EXCLUSIVE-LOCK:
          END.
          IF AVAIL xxsod_det THEN DO:
            /* xxsod__dec01 存放累计数量 */
            assign
              xxsod__dec01 = xxsod__dec01 + dec( V1600 )
            .
            /* ss - 110621.1 -b */
            xxsod_rmks2 = GLOBAL_userid .
            /* ss - 110621.1 -e */
          end.
          ELSE DO:
            undo,leave V1300LMAINLOOP.
          END.

          for FIRST xxsod_det where trim(xxsod_cust) = trim(V1003) and trim(xxsod_due_date1) = trim(V1004) and trim(xxsod_due_time1) = trim(V1005)
            and TRIM(xxsod_part) = custpart no-LOCK :
          END.
          IF AVAIL xxsod_det THEN DO:
                assign
                        tmpqq = xxsod__dec01
                        tmpqq1 = xxsod_qty_ord.
          END.

          if tmpqq <> 0 AND tmpqq = tmpqq1 then do:
             for FIRST xxsod_det where trim(xxsod_cust) = trim(V1003) and trim(xxsod_due_date1) = trim(V1004) and trim(xxsod_due_time1) = trim(V1005)
               and TRIM(xxsod_part) = custpart EXCLUSIVE-LOCK :
             END.
             IF AVAIL xxsod_det THEN DO:
                /* 一旦累计数量 xxsod__dec01 = xxsod_qty_ord ，则关闭此时段 */
                assign xxsod__dec02 = 1.

             END.
          end.
          /* record tc status to xxtc_hst */
/*17YJ*/  find first xxtc_hst exclusive-lock where xxtc_nbr = v10006 no-error.
/*17YJ*/  if available xxtc_hst then do:
/*17YJ*/  	assign  xxtc_cust = V1003
/*17YJ*/		        xxtc_stat = "C"
/*17YJ*/		        xxtc_date = today
/*17YJ*/		        xxtc_mod_date = today
/*17YJ*/		        xxtc_mod_usr = global_userid .
/*17YJ*/  end. /*if available xxtc_hst then do:*/
/*17YJ*/  else do:
/*17YJ*/  	 create xxtc_hst.
/*17YJ*/  	 assign xxtc_nbr = v10006
/*17YJ*/		        xxtc_cust = V1003
/*17YJ*/		        xxtc_stat = "C"
/*17YJ*/		        xxtc_date = today
/*17YJ*/		        xxtc_mod_date = today
/*17YJ*/		        xxtc_mod_usr = global_userid .
/*17YJ*/  end.  /*if available xxtc_hst else do:*/

/* SS 090912.1 - E */
/* SS 090911.1 - B */
      end. /* do */
/* SS 090911.1 - E */
     END.

     release so_mstr.
     release sod_det.
     /*  Update MFG/PRO END  */
        display  "" NO-LABEL with fram F9000X no-box .
        pause 0.
     /* START  LINE :9005  FIFO Log Checking  */
     V9005L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V9005           as char format "x(50)".
        define variable PV9005          as char format "x(50)".
        define variable L90051          as char format "x(40)".
        define variable L90052          as char format "x(40)".
        define variable L90053          as char format "x(40)".
        define variable L90054          as char format "x(40)".
        define variable L90055          as char format "x(40)".
        define variable L90056          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        find last tr_hist where
tr_date = today     and
tr_trnbr > integer ( V9000 ) and
tr_nbr  = V1551    and  tr_type = "ISS-SO"  and
tr_site = V1002     and  tr_part = V1302     and tr_serial = V1500
           /* SS - 20081113.1 - B */
           /*
           and
tr_time  + 15 >= TIME
*/
           /* SS - 20081113.1 - E */
use-index tr_date_trn no-lock no-error.
If AVAILABLE ( tr_hist ) then
        V9005 = string(tr_trnbr).
        V9005 = ENTRY(1,V9005,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V9005 = ENTRY(1,V9005,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        if V9005 <> "" then do:
find first tr_hist where tr_trnbr = integer(V9005) and tr_qty_loc < 0 no-error.
If AVAILABLE ( tr_hist ) and trim( substring(V1550,1,18) ) <> trim ( V1500 ) then
   tr__chr01 = V1550.
end.
If 1 = 1 then
        leave V9005L.
        /* LOGICAL SKIP END */

        /* --FIRST TIME SKIP -- START  */
         if sectionid = 1 then leave V9005L.
        /* --FIRST TIME SKIP -- END  */


        /* --CYCLE TIME SKIP -- START  */
         if sectionid > 1 then leave V9005L .
        /* --CYCLE TIME SKIP -- END  */

                display "[销售订单发货n]"     + "*" + TRIM ( V1002 )  + vernbr  format "x(40)" skip with fram F9005 no-box.

                /* LABEL 1 - START */
                L90051 = "UPDATE TO TR__CHR01" .
                display L90051          format "x(40)" skip with fram F9005 no-box.
                /* LABEL 1 - END */


                /* LABEL 2 - START */
                  L90052 = "" .
                display L90052          format "x(40)" skip with fram F9005 no-box.
                /* LABEL 2 - END */


                /* LABEL 3 - START */
                  L90053 = "" .
                display L90053          format "x(40)" skip with fram F9005 no-box.
                /* LABEL 3 - END */


                /* LABEL 4 - START */
                  L90054 = "" .
                display L90054          format "x(40)" skip with fram F9005 no-box.
                /* LABEL 4 - END */
                display "输入或按E退出"       format "x(40)" skip
        skip with fram F9005 no-box.
        Update V9005
        WITH  fram F9005 NO-LABEL
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
        IF V9005 = "e" THEN  LEAVE V1300LMAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F9005.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F9005.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F9005.
        pause 0.
        leave V9005L.
     END.
     PV9005 = V9005.
     /* END    LINE :9005  FIFO Log Checking  */


     /* START  LINE :9010  OK  */
     V9010L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V9010           as char format "x(50)".
        define variable PV9010          as char format "x(50)".
        define variable L90101          as char format "x(40)".
        define variable L90102          as char format "x(40)".
        define variable L90103          as char format "x(40)".
        define variable L90104          as char format "x(40)".
        define variable L90105          as char format "x(40)".
        define variable L90106          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        /* SS - 20080116.1 - B */
        /*
        V9010 = "Y".
        */
        V9010 = "Y".
        /* SS - 20080116.1 - E */
        V9010 = ENTRY(1,V9010,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V9010 = ENTRY(1,V9010,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */
                display "[销售订单发货n]"     + "*" + TRIM ( V1002 )  + vernbr format "x(40)" skip with fram F9010 no-box.

                /* LABEL 1 - START */
                find last tr_hist where
tr_date = today     and
tr_trnbr > integer ( V9000 ) and
tr_nbr  = V1551    and  tr_type = "ISS-SO"  and
tr_site = V1002     and tr_part = V1302     and tr_serial = V1500
                   /* SS - 20081113.1 - B */
                   /*
                   and
tr_time  + 15 >= TIME */
                   /* SS - 20081113.1 - E */
use-index tr_date_trn no-lock no-error.
If AVAILABLE ( tr_hist ) then
                L90101 = "交易已提交" .
                else L90101 = "" .
                display L90101          format "x(40)" skip with fram F9010 no-box.
                /* LABEL 1 - END */


                /* LABEL 2 - START */
                def var tempnbr as char.
Tempnbr="".
find last tr_hist where
tr_date = today     and
tr_trnbr > integer ( V9000 ) and
tr_nbr  = V1551     and  tr_type = "ISS-SO"  and  tr_site = V1002     and tr_part = V1302     and tr_serial = V1500
   /* SS - 20081113.1 - B */
   /*
   and
tr_time  + 15 >= TIME
*/
   /* SS - 20081113.1 - E */
use-index tr_date_trn no-lock no-error.
If AVAILABLE ( tr_hist ) then assign tempnbr=trim(string(tr_trnbr)).

/* SS - 20090325.1 - B */
/*
def var tmpint as char.
tmpint="1".
for each xxsod_det where trim(xxsod_cust) = trim(V1003) and trim(xxsod_due_date1)=trim(V1004) and trim(xxsod_due_time1)=trim(V1005) and TRIM(xxsod_part) = custpart
    /* SS - 20071225.1 - B */
    /*trim(xxsod_part)= ENTRY(1, V1300, "@")*/
    /* SS - 20071225.1 - E */  EXCLUSIVE-LOCK:
   if tmpint="1" then assign xxsod__dec01=xxsod__dec01 + dec( V1600 ) tmpint="2" .
   else leave.
end.
*/
/* SS - 20090325.1 - E */

/*
find first xxsod_det where trim(xxsod_cust) = trim(V1003) and trim(xxsod_due_date1)=trim(V1004) and trim(xxsod_due_time1)=trim(V1005) and trim(xxsod_part)=ENTRY(1, V1300, "@")  EXCLUSIVE-LOCK no-error.
if avail xxsod_det then   assign xxsod__dec01=xxsod__dec01 + dec( V1600 ).
*/
/*
release xxsod_det.
  */

/* SS - 20090325.1 - B */
/*
tmpqq=0.
tmpqq1=0.
for each xxsod_det where trim(xxsod_cust) = trim(V1003) and trim(xxsod_due_date1)=trim(V1004) and trim(xxsod_due_time1)=trim(V1005) and     /* SS - 20071225.1 - B */
    /*trim(xxsod_part)= ENTRY(1, V1300, "@")*/ TRIM(xxsod_part) = custpart
    /* SS - 20071225.1 - E */   no-LOCK :
  assign tmpqq= tmpqq + xxsod__dec01
         tmpqq1= tmpqq1 + xxsod_qty_ord.

End.

if tmpqq<>0 and abs(tmpqq) >= abs(tmpqq1) then do:
  for each xxsod_det where trim(xxsod_cust) = trim(V1003) and trim(xxsod_due_date1)=trim(V1004) and trim(xxsod_due_time1)=trim(V1005) and     /* SS - 20071225.1 - B */
    /*trim(xxsod_part)= ENTRY(1, V1300, "@")*/ TRIM(xxsod_part) = custpart
    /* SS - 20071225.1 - E */   EXCLUSIVE-LOCK :
    assign xxsod__dec02=1.

  End.
end.
release xxsod_det.
  */
/* SS - 20090325.1 - E */

/*SS - 080905.1 B*/

    FIND FIRST xxsod_det WHERE trim(xxsod_due_date1)=trim(V1004) and trim(xxsod_due_time1)=trim(V1005) AND xxsod_cust = trim(V1003) AND xxsod_qty_ord <> xxsod__dec01 NO-LOCK NO-ERROR.
    IF NOT AVAIL xxsod_det THEN DO:

         display SKIP "货已发完,可以打印放行条"@ WMESSAGE NO-LABEL with fram F9010.
    END.
    ELSE DO:
         display SKIP "货没发完,不可以打印放行条"@ WMESSAGE NO-LABEL with fram F9010.
    END.

/*SS - 080905.1 E*/

If tempnbr<>"" then
                L90102 = "交易号 :" + tempnbr .
                else L90102 = "" .
                display L90102          format "x(40)" skip with fram F9010 no-box.
                /* LABEL 2 - END */


                /* LABEL 3 - START */
                find last tr_hist where
tr_date = today     and
tr_trnbr > integer ( V9000 ) and
tr_nbr  = V1551    and  tr_type = "ISS-SO"  and  tr_site = V1002     and tr_part = V1302     and tr_serial = V1500
                   /* SS - 20081113.1 - B */
                   /*
                   and
tr_time  + 15 >= TIME */
                   /* SS - 20081113.1 - E */
use-index tr_date_trn no-lock no-error.
If NOT AVAILABLE ( tr_hist ) then
                L90103 = "交易提交失败" .
                else L90103 = "" .
                display L90103          format "x(40)" skip with fram F9010 no-box.
                /* LABEL 3 - END */

/* SS - 20090325.1 - B */
IF L90103 = "" THEN DO:
/* SS 090911.1 - B */
/*
   tmpqq = 0.
   tmpqq1 = 0.
   for FIRST xxsod_det where trim(xxsod_cust) = trim(V1003) and trim(xxsod_due_date1) = trim(V1004) and trim(xxsod_due_time1) = trim(V1005)
      and TRIM(xxsod_part) = custpart EXCLUSIVE-LOCK:
   END.
   IF AVAIL xxsod_det THEN DO:
      /* xxsod__dec01 存放累计数量 */
      assign
         xxsod__dec01 = xxsod__dec01 + dec( V1600 )
         .
   end.

   for FIRST xxsod_det where trim(xxsod_cust) = trim(V1003) and trim(xxsod_due_date1) = trim(V1004) and trim(xxsod_due_time1) = trim(V1005)
      and TRIM(xxsod_part) = custpart no-LOCK :
   END.
   IF AVAIL xxsod_det THEN DO:
      assign
         tmpqq = xxsod__dec01
         tmpqq1 = xxsod_qty_ord.
   END.

   if tmpqq <> 0 AND tmpqq = tmpqq1 then do:
    for FIRST xxsod_det where trim(xxsod_cust) = trim(V1003) and trim(xxsod_due_date1) = trim(V1004) and trim(xxsod_due_time1) = trim(V1005)
         and TRIM(xxsod_part) = custpart EXCLUSIVE-LOCK :
      END.
      IF AVAIL xxsod_det THEN DO:
         /* 一旦累计数量 xxsod__dec01 = xxsod_qty_ord ，则关闭此时段 */
       assign xxsod__dec02 = 1.
    End.
   end.
*/
/* SS 090911.1 - E */
END.
/* SS - 20090325.1 - E */


                /* LABEL 4 - START */
                L90104 = "按Y打印条码,E退出" .
                display L90104          format "x(40)" skip with fram F9010 no-box.
                /* LABEL 4 - END */
                display "输入或按E退出"       format "x(40)" skip
        skip with fram F9010 no-box.

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
   /* Internal Cycle Input :9110    */



   V9110LMAINLOOP:
   REPEAT:
   /*Logical Enter Cycle9110    */
   IF NOT (V9010 = "Y" AND V1700 = "Y" ) THEN LEAVE V9110LMAINLOOP.
     /*SS - 080909.1 B*/
    /*
     /* START  LINE :9110  条码上数量[QTY ON LABEL]  */
     V9110L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V9110           as char format "x(50)".
        define variable PV9110          as char format "x(50)".
        define variable L91101          as char format "x(40)".
        define variable L91102          as char format "x(40)".
        define variable L91103          as char format "x(40)".
        define variable L91104          as char format "x(40)".
        define variable L91105          as char format "x(40)".
        define variable L91106          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        V9110 = V1600.
        V9110 = ENTRY(1,V9110,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V9110 = ENTRY(1,V9110,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */
                /*SS - 20080905.1 ADD -有放行条 */
                display "[销售订单发货-有放行条n]"     + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F9110 no-box.

                /* LABEL 1 - START */
                find first pt_mstr where pt_part = tmppart  no-lock no-error.
If AVAILABLE ( pt_mstr ) then
                L91101 = pt_um + " 标签上数量?" .
                else L91101 = "" .
                display L91101          format "x(40)" skip with fram F9110 no-box.
                /* LABEL 1 - END */


                /* LABEL 2 - START */
                L91102 = "图号:" + trim( tmppart ) .
                display L91102          format "x(40)" skip with fram F9110 no-box.
                /* LABEL 2 - END */


                /* LABEL 3 - START */
                L91103 = "批号:" + Trim(V1500) .
                display L91103          format "x(40)" skip with fram F9110 no-box.
                /* LABEL 3 - END */


                /* LABEL 4 - START */
                  L91104 = "" .
                display L91104          format "x(40)" skip with fram F9110 no-box.
                /* LABEL 4 - END */
                display "输入或按E退出"       format "x(40)" skip
        skip with fram F9110 no-box.
        Update V9110
        WITH  fram F9110 NO-LABEL
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
        IF V9110 = "e" THEN  LEAVE V9110LMAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F9110.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F9110.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        If V9110 = "" OR V9110 = "-" OR V9110 = "." OR V9110 = ".-" OR V9110 = "-." then do:
                display skip "CAN NOT EMPTY  " @ WMESSAGE NO-LABEL with fram F9110.
                pause 0 before-hide.
                undo, retry.
        end.
        DO i = 1 to length(V9110).
                If index("0987654321.-", substring(V9110,i,1)) = 0 then do:
                display skip "Format  Error  " @ WMESSAGE NO-LABEL with fram F9110.
                pause 0 before-hide.
                undo, retry.
                end.
        end.
        /* CHECK FOR NUMBER VARIABLE  END */
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F9110.
        pause 0.
        leave V9110L.
     END.
     PV9110 = V9110.
     /* END    LINE :9110  条码上数量[QTY ON LABEL]  */


     /* START  LINE :9120  条码个数[No Of Label]  */
     V9120L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V9120           as char format "x(50)".
        define variable PV9120          as char format "x(50)".
        define variable L91201          as char format "x(40)".
        define variable L91202          as char format "x(40)".
        define variable L91203          as char format "x(40)".
        define variable L91204          as char format "x(40)".
        define variable L91205          as char format "x(40)".
        define variable L91206          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        V9120 = "1".
        V9120 = ENTRY(1,V9120,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V9120 = ENTRY(1,V9120,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */
                /*SS - 20080905.1 ADD -有放行条*/
                display "[销售订单发货-有放行条n]"     + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F9120 no-box.

                /* LABEL 1 - START */
                L91201 = "标签个数?" .
                display L91201          format "x(40)" skip with fram F9120 no-box.
                /* LABEL 1 - END */


                /* LABEL 2 - START */
                L91202 = "图号:" + trim( tmppart ) .
                display L91202          format "x(40)" skip with fram F9120 no-box.
                /* LABEL 2 - END */


                /* LABEL 3 - START */
                L91203 = "批号:" + Trim(V1500) .
                display L91203          format "x(40)" skip with fram F9120 no-box.
                /* LABEL 3 - END */


                /* LABEL 4 - START */
                  L91204 = "" .
                display L91204          format "x(40)" skip with fram F9120 no-box.
                /* LABEL 4 - END */
                display "输入或按E退出"       format "x(40)" skip
        skip with fram F9120 no-box.
        Update V9120
        WITH  fram F9120 NO-LABEL
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
        IF V9120 = "e" THEN  LEAVE V9110LMAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F9120.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F9120.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        If V9120 = "" OR V9120 = "-" OR V9120 = "." OR V9120 = ".-" OR V9120 = "-." then do:
                display skip "CAN NOT EMPTY  " @ WMESSAGE NO-LABEL with fram F9120.
                pause 0 before-hide.
                undo, retry.
        end.
        DO i = 1 to length(V9120).
                If index("0987654321.-", substring(V9120,i,1)) = 0 then do:
                display skip "Format  Error  " @ WMESSAGE NO-LABEL with fram F9120.
                pause 0 before-hide.
                undo, retry.
                end.
        end.
        /* CHECK FOR NUMBER VARIABLE  END */
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F9120.
        pause 0.
        leave V9120L.
     END.
     PV9120 = V9120.
     /* END    LINE :9120  条码个数[No Of Label]  */

     wtm_num = V9120.

   */

   /*SS - 080909.1 E*/



     /* START  LINE :9130  打印机[Printer]  */
     V9130L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V9130           as char format "x(50)".
        define variable PV9130          as char format "x(50)".
        define variable L91301          as char format "x(40)".
        define variable L91302          as char format "x(40)".
        define variable L91303          as char format "x(40)".
        define variable L91304          as char format "x(40)".
        define variable L91305          as char format "x(40)".
        define variable L91306          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        find first upd_det where upd_nbr = "SOI11" and upd_select = 99 no-lock no-error.
If AVAILABLE ( upd_det ) then
        V9130 = UPD_DEV.
        V9130 = ENTRY(1,V9130,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
         If sectionid > 1 Then
        V9130 = PV9130 .
        V9130 = ENTRY(1,V9130,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */


        /*SS - 20080905.1 ADD v9130 = "bi" .为了把结果输出到BI*/
        v9130 = "ck1" .


        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */
                /*SS - 20080905.1 ADD 有放行*/
                display "[销售订单发货-有放行条]" + "*" + TRIM ( V1002 )
                        format "x(40)" skip with fram F9130 no-box.

                /* LABEL 1 - START */
                L91301 = "打印机?" .
                display L91301 format "x(40)" skip with fram F9130 no-box.
                /* LABEL 1 - END */


                /* LABEL 2 - START */
                  L91302 = "" .
                display L91302 format "x(40)" skip with fram F9130 no-box.
                /* LABEL 2 - END */


                /* LABEL 3 - START */
                  L91303 = "" .
                display L91303 format "x(40)" skip with fram F9130 no-box.
                /* LABEL 3 - END */


                /* LABEL 4 - START */
                  L91304 = "" .
                display L91304 format "x(40)" skip with fram F9130 no-box.
                /* LABEL 4 - END */
                display "输入或按E退出" format "x(40)" skip
        skip with fram F9130 no-box.
        recid(PRD_DET) = ?.
        Update V9130
        WITH  fram F9130 NO-LABEL
        /* ROLL BAR START */
        EDITING:
        readkey pause wtimeout.
        if lastkey = -1 then quit.
        if LASTKEY = 404 Then Do: /* DISABLE F4 */
           pause 0 before-hide.
           undo, retry.
        end.
        display skip "^" @ WMESSAGE NO-LABEL with fram F9130.
            IF LASTKEY = keycode("F10") or keyfunction(lastkey) = "CURSOR-DOWN"
            THEN DO:
                  IF recid(PRD_DET) = ? THEN find first PRD_DET where
                              PRD_DEV >=  INPUT V9130
                               no-lock no-error.
                  else do:
                       if PRD_DEV =  INPUT V9130
                       then find next PRD_DET
                        no-lock no-error.
                        else find first PRD_DET where
                              PRD_DEV >=  INPUT V9130
                               no-lock no-error.
                  end.
                  IF AVAILABLE PRD_DET then display skip
            PRD_DEV @ V9130 PRD_DESC @ WMESSAGE NO-LABEL with fram F9130.
                  else   display skip "" @ WMESSAGE with fram F9130.
            END.
            IF LASTKEY = keycode("F9") or keyfunction(lastkey) = "CURSOR-UP"
            THEN DO:
                  IF recid(PRD_DET) = ? THEN find last PRD_DET where
                              PRD_DEV <=  INPUT V9130
                               no-lock no-error.
                  else do:
                       if PRD_DEV =  INPUT V9130
                       then find prev PRD_DET
                        no-lock no-error.
                        else find first PRD_DET where
                              PRD_DEV >=  INPUT V9130
                               no-lock no-error.
                  end.
                  IF AVAILABLE PRD_DET then display skip
            PRD_DEV @ V9130 PRD_DESC @ WMESSAGE NO-LABEL with fram F9130.
                  else   display skip "" @ WMESSAGE with fram F9130.
            END.
            APPLY LASTKEY.
        END.
        /* ROLL BAR END */


        /* PRESS e EXIST CYCLE */
        IF V9130 = "e" THEN  LEAVE V9110LMAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F9130.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F9130.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
        find first PRD_DET where PRD_DEV = V9130  no-lock no-error.
        IF NOT AVAILABLE PRD_DET then do:
                display skip "打印机有误 " @ WMESSAGE NO-LABEL with fram F9130.
                pause 0 before-hide.
                undo, retry.
        end.
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F9130.

        pause 0.
        leave V9130L.
     END.
     PV9130 = V9130.

     /* END    LINE :9130  打印机[Printer]  */

     /*SS - 20080905.1 B*/
     /*
     Define variable ts9130 AS CHARACTER FORMAT "x(100)".
     Define variable av9130 AS CHARACTER FORMAT "x(100)".
     PROCEDURE soi119130l.
        /* Define Labels Path  Start */
        Define variable LabelsPath as character format "x(100)" init "/app/bc/labels/".
        Find first code_mstr where code_fldname = "BARCODE" AND CODE_value ="LabelsPath"no-lock no-error.
        If AVAILABLE(code_mstr) Then LabelsPath = trim ( code_cmmt ).
        If substring(LabelsPath, length(LabelsPath), 1) <> "/" Then
        LabelsPath = LabelsPath + "/".
        /* Define Labels Path  END */
     INPUT FROM VALUE(LabelsPath + "soi11").
     wsection = TRIM ( string(year(TODAY)) + string(MONTH(TODAY)) + string(DAY(TODAY)))  + trim(STRING(TIME)) + trim(string(RANDOM(1,100))) .
     output to value( trim(wsection) + ".l") .
     Do While True:
              IMPORT UNFORMATTED ts9130.
        av9130 = trim(V1302) + "@" + trim (V1500).
       IF INDEX(ts9130,"&B") <> 0  THEN DO:
       TS9130 = substring(TS9130, 1, Index(TS9130 , "&B") - 1) + av9130
       + SUBSTRING( ts9130 , index(ts9130 ,"&B") + length("&B"), LENGTH(ts9130) - ( index(ts9130 ,"&B" ) + length("&B") - 1 ) ).
       END.
        av9130 = V9110.
       IF INDEX(ts9130,"$Q") <> 0  THEN DO:
       TS9130 = substring(TS9130, 1, Index(TS9130 , "$Q") - 1) + av9130
       + SUBSTRING( ts9130 , index(ts9130 ,"$Q") + length("$Q"), LENGTH(ts9130) - ( index(ts9130 ,"$Q" ) + length("$Q") - 1 ) ).
       END.
        av9130 = " ".
       IF INDEX(ts9130,"&M") <> 0  THEN DO:
       TS9130 = substring(TS9130, 1, Index(TS9130 , "&M") - 1) + av9130
       + SUBSTRING( ts9130 , index(ts9130 ,"&M") + length("&M"), LENGTH(ts9130) - ( index(ts9130 ,"&M" ) + length("&M") - 1 ) ).
       END.
       find first pt_mstr where pt_part = V1302  no-lock no-error.
If AVAILABLE ( pt_mstr )  then
        av9130 = trim(pt_desc1).
       IF INDEX(ts9130,"$F") <> 0  THEN DO:
       TS9130 = substring(TS9130, 1, Index(TS9130 , "$F") - 1) + av9130
       + SUBSTRING( ts9130 , index(ts9130 ,"$F") + length("$F"), LENGTH(ts9130) - ( index(ts9130 ,"$F" ) + length("$F") - 1 ) ).
       END.
       find first ad_mstr where ad_addr = V1003  no-lock no-error.
If AVAILABLE ( ad_mstr )  then
        av9130 = trim ( ad_name ).
       IF INDEX(ts9130,"$N") <> 0  THEN DO:
       TS9130 = substring(TS9130, 1, Index(TS9130 , "$N") - 1) + av9130
       + SUBSTRING( ts9130 , index(ts9130 ,"$N") + length("$N"), LENGTH(ts9130) - ( index(ts9130 ,"$N" ) + length("$N") - 1 ) ).
       END.
        av9130 = string ( today ).
       IF INDEX(ts9130,"$D") <> 0  THEN DO:
       TS9130 = substring(TS9130, 1, Index(TS9130 , "$D") - 1) + av9130
       + SUBSTRING( ts9130 , index(ts9130 ,"$D") + length("$D"), LENGTH(ts9130) - ( index(ts9130 ,"$D" ) + length("$D") - 1 ) ).
       END.
        av9130 = V1302.
       IF INDEX(ts9130,"$P") <> 0  THEN DO:
       TS9130 = substring(TS9130, 1, Index(TS9130 , "$P") - 1) + av9130
       + SUBSTRING( ts9130 , index(ts9130 ,"$P") + length("$P"), LENGTH(ts9130) - ( index(ts9130 ,"$P" ) + length("$P") - 1 ) ).
       END.
        av9130 = "XXXX".
       IF INDEX(ts9130,"&D") <> 0  THEN DO:
       TS9130 = substring(TS9130, 1, Index(TS9130 , "&D") - 1) + av9130
       + SUBSTRING( ts9130 , index(ts9130 ,"&D") + length("&D"), LENGTH(ts9130) - ( index(ts9130 ,"&D" ) + length("&D") - 1 ) ).
       END.
        av9130 = "NEED CONFIRM".
       IF INDEX(ts9130,"&R") <> 0  THEN DO:
       TS9130 = substring(TS9130, 1, Index(TS9130 , "&R") - 1) + av9130
       + SUBSTRING( ts9130 , index(ts9130 ,"&R") + length("&R"), LENGTH(ts9130) - ( index(ts9130 ,"&R" ) + length("&R") - 1 ) ).
       END.
       find first cp_mstr where cp_cust = V1003 and cp_cust_part <> "" and cp_part = V1300 no-lock no-error.
If AVAILABLE ( cp_mstr )  then
        av9130 = trim ( cp_cust_part ).
       IF INDEX(ts9130,"$X") <> 0  THEN DO:
       TS9130 = substring(TS9130, 1, Index(TS9130 , "$X") - 1) + av9130
       + SUBSTRING( ts9130 , index(ts9130 ,"$X") + length("$X"), LENGTH(ts9130) - ( index(ts9130 ,"$X" ) + length("$X") - 1 ) ).
       END.
       find first pt_mstr where pt_part = V1302  no-lock no-error.
If AVAILABLE ( pt_mstr )  then
        av9130 = string ( pt_net_wt ) + trim ( pt_net_wt_um ).
       IF INDEX(ts9130,"&N") <> 0  THEN DO:
       TS9130 = substring(TS9130, 1, Index(TS9130 , "&N") - 1) + av9130
       + SUBSTRING( ts9130 , index(ts9130 ,"&N") + length("&N"), LENGTH(ts9130) - ( index(ts9130 ,"&N" ) + length("&N") - 1 ) ).
       END.
       find first pt_mstr where pt_part = V1302  no-lock no-error.
If AVAILABLE ( pt_mstr )  then
        av9130 = string ( pt_ship_wt ) + trim ( pt_ship_wt_um ).
       IF INDEX(ts9130,"&G") <> 0  THEN DO:
       TS9130 = substring(TS9130, 1, Index(TS9130 , "&G") - 1) + av9130
       + SUBSTRING( ts9130 , index(ts9130 ,"&G") + length("&G"), LENGTH(ts9130) - ( index(ts9130 ,"&G" ) + length("&G") - 1 ) ).
       END.
       find first so_mstr where so_nbr = V1551  no-lock no-error.
If AVAILABLE ( so_mstr )  then
        av9130 = so_po.
       IF INDEX(ts9130,"$C") <> 0  THEN DO:
       TS9130 = substring(TS9130, 1, Index(TS9130 , "$C") - 1) + av9130
       + SUBSTRING( ts9130 , index(ts9130 ,"$C") + length("$C"), LENGTH(ts9130) - ( index(ts9130 ,"$C" ) + length("$C") - 1 ) ).
       END.
       put unformatted ts9130 skip.
     End.
     INPUT CLOSE.
     OUTPUT CLOSE.
     unix silent value ("chmod 777  " + trim(wsection) + ".l").
     END PROCEDURE.
     run soi119130l.
     do i = 1 to integer(wtm_num):
       find first PRD_DET where PRD_DEV = V9130 no-lock no-error.
       IF AVAILABLE PRD_DET then do:
         unix silent value (trim(prd_path) + " " + trim(wsection) + ".l").
         unix silent value ( "clear").
       end.
     End.
   */

     find first PRD_DET where PRD_DEV = V9130  no-lock no-error.
     IF AVAILABLE PRD_DET then do:

       /*
         /* OUTPUT DESTINATION SELECTION */
         {xxgpout.i
             &printType = "printer "
             &printWidth = 80
             &pagedFlag = "{3} "
             &stream = "{4} "
             &appendToFile = "{5} "
             &streamedOutputToTerminal = " "
             &withBatchOption = "no"
             &displayStatementType = 1
             &withCancelMessage = "yes"
             &pageBottomMargin = 6
             &withEmail = "yes"
             &withWinprint = "yes"
             &defineVariables = "yes"
         }
       */

        /*SS - 080911.1 B*/
        {xsrpfxt01.i}

        LEAVE V9110LMAINLOOP.

        /*SS - 080911.1 E*/

     end.
     /* 为了把结果输出到BI */

     /* SS - 20080905.1 - E */
   /* Internal Cycle END :9130    */
   END.
   pause 0 before-hide.
end.

/*ching */
end.
end.
/*ching */

