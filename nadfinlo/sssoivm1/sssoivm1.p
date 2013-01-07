/* xxsoivm1.p - INVOICE MAINTENANCE                                             */
/* Copyright 1996-2006 Softspeed, China.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.95.1.6 $                                                      */
/* REVISION: 1.0      LAST MODIFIED: 02/21/06   BY: Apple Tam *SS - 20060221*                  */
/* $Revision: 1.95.1.6 $    BY: Bill Jiang        DATE: 02/25/06  ECO: *SS - 20060225* */
/* $Revision: 1.95.1.6 $    BY: Micho Yang        DATE: 03/07/06  ECO: *SS - 20060307* */
/* $Revision: 1.95.1.6 $    BY: Bill Jiang        DATE: 03/11/06  ECO: *SS - 20060311* */
/* $Revision: 1.95.1.6 $    BY: Bill Jiang        DATE: 03/16/06  ECO: *SS - 20060316* */
/* $Revision: 1.95.1.6 $    BY: Micho Yang        DATE: 03/20/06  ECO: *SS - 20060320* */
/* $Revision: 1.95.1.6 $    BY: Bill Jiang        DATE: 03/24/06  ECO: *SS - 20060324* */
/* $Revision: 1.95.1.6 $    BY: Bill Jiang        DATE: 03/31/06  ECO: *SS - 20060331* */
/* $Revision: 1.95.1.6 $    BY: Bill Jiang        DATE: 04/01/06  ECO: *SS - 20060401* */
/* $Revision: 1.95.1.6 $    BY: Bill Jiang        DATE: 06/12/06  ECO: *SS - 20060612.1* */
/* By: Neil Gao Date: 20070102 ECO: * ss 20070102.1 * */
/* By: Neil Gao Date: 20070108 ECO: * ss 20070108.1 * */
/* By: Neil Gao Date: 20070417 ECO: * ss 20070417.1 * */

/* ss - 20070108.1 - b */
/*
下面加多一个货物发往地址.    上面的客户改成票据开往
 * ss - 20070108.1 - e */

/* SS - 20060612.1 - B */
/*
1. 增加了是否含税的选择条件
2. 直接来源于sssoivm3.p的/* SS - 20060407 */的第3条
*/
/* SS - 20060612.1 - E */

/* SS - 20060401 - B */
/*
1. 处理了计量单位
2. 改变为集中处理已选择的金额
*/
define            variable trans_conv like sod_um_conv no-undo.
/* SS - 20060401 - E */

/* SS - 20060331 - B */
define variable abs_recid   as recid no-undo.
define variable range       as character no-undo.
define variable range1      as character no-undo.
DEFINE VARIABLE s1 AS CHAR.
define variable cnt as decimal.

/* TEMP-TABLE */
define new shared temp-table tab_abs
   field tab_id              like abs_id
   field tab_item            like abs_item
   field tab_shipto          like abs_shipto
   field tab_shipfrom        like abs_shipfrom
   field tab_order           like abs_order
   field tab_line            like sod_line
   field tab_qty             like abs_qty
   field tab_recid           as recid
   /* SS - 20060401 - B */
   FIELD TAB_par_id LIKE ABS_par_id
   FIELD TAB_ship_qty LIKE ABS_ship_qty
   FIELD TAB__dec04 LIKE ABS__dec04
   FIELD TAB__qad02 LIKE ABS__qad02
   /* SS - 20060401 - E */
   .
/* SS - 20060331 - E */

{mfdtitle.i "130107.1"}

define new shared variable xxrqmnbr like xxrqm_nbr.
define new shared variable xxrqmsite  like xxrqm_site.
define new shared variable xxrqmcust  like xxrqm_cust.
define new shared variable xxrqmrqby_userid like xxrqm_rqby_userid.
define new shared variable xxrqmreq_date like xxrqm_req_date.
define new shared variable xxrqmtax_in like xxrqm_tax_in.
define variable del-yn like mfc_logical initial no.

/* SS - 20060307 - B */
DEFINE VAR auto_select LIKE mfc_logical INIT YES .
DEFINE VAR ship_date_from AS DATE .
DEFINE VAR ship_date_to   AS DATE .
/* SS - 20060324 - B */
/*
DEFINE VAR shipper_from   AS CHAR  .
DEFINE VAR shipper_to     AS CHAR .
*/
DEFINE VAR shipper_from   AS CHAR  FORMAT "x(11)".
DEFINE VAR shipper_to     AS CHAR FORMAT "x(11)".
DEFINE VARIABLE po LIKE so_po.
DEFINE VARIABLE po1 LIKE so_po.
/* SS - 20060324 - E */
DEFINE VAR sel_all LIKE mfc_logical INIT YES.

DEFINE VAR sel_stat       AS CHAR .
DEFINE VAR sel_total      AS DECIMAL FORMAT "->>,>>>,>>9.99".

DEFINE VAR part-desc1     LIKE pt_desc1 .
DEFINE VAR part-desc2     LIKE pt_desc2 .

define variable first_sw_call as logical initial true.
define variable apwork-recno  as recid.
/* SS - 20060307 - E */
/* ss - 20070108.1 - b */
DEFINE VARIABLE xxship  like so_ship.
DEFINE VARIABLE xxship1 like so_ship.
/* ss - 20070108.1 - e */

DEFINE NEW SHARED TEMP-TABLE tt1
   FIELD tt1_stat     as character format "x(1)"
   FIELD tt1_shipfrom LIKE ABS_shipfrom
   FIELD tt1_id LIKE ABS_id FORMAT "x(58)"
/* ss 20070102.1 */   FIELD tt1_disp_id like abs_id label "货运单号" FORMAT "x(58)"
   FIELD tt1_par_id LIKE ABS_par_id
   FIELD tt1_shipto         LIKE ABS_shipto
   FIELD tt1_order        AS CHAR FORMAT "x(8)"
   FIELD tt1_po           LIKE so_po
   FIELD tt1_line     LIKE ABS_line FORMAT "x(3)"
   FIELD tt1_item     AS CHAR FORMAT "x(18)"
   FIELD tt1_cust_part LIKE cp_cust_part
   FIELD tt1_desc1        like pt_desc1
   FIELD tt1_desc2        like pt_desc2
   FIELD tt1_um           AS CHAR FORMAT "x(2)"
   FIELD tt1_ship_qty AS DECIMAL FORMAT "->,>>>,>>9.99"
   FIELD tt1_qty_inv AS DECIMAL FORMAT "->,>>>,>>9.9<<<<<<<"
   FIELD tt1_price LIKE sod_price
   FIELD tt1_close_abs AS LOGICAL
   FIELD tt1_type LIKE sod_type
   /* SS - 20060401 - B */
   FIELD tt1_new  AS LOGICAL INITIAL YES
   FIELD tt1_ord_date LIKE so_ord_date
   FIELD tt1__qad02 LIKE ABS__qad02
   FIELD tt1_conv AS DECIMAL INITIAL 1
   /* SS - 20060401 - E */
/* ss 20070102.1 */ INDEX tt1_disp_id tt1_disp_id
   INDEX tt1_id tt1_id
   INDEX tt1_stat tt1_stat
   INDEX tt1_par_id_line tt1_par_id tt1_line
   INDEX tt1_shipfrom_id tt1_shipfrom tt1_id
   .
DEFINE BUFFER btt11 FOR tt1.

DEFINE BUFFER babs1 FOR ABS_mstr.
DEFINE NEW SHARED FRAME match_maintenance .
DEFINE NEW SHARED FRAME w.

form
   xxrqmnbr               colon 15
   xxrqmsite COLON 40
   xxrqmcust              colon 65
   xxrqmrqby_userid       colon 15
   xxrqmreq_date          colon 40
   xxrqmtax_in            colon 15
   /* SS - 20060307 - B */
   auto_select            COLON 40
   /* SS - 20060307 - E */
   sel_total COLON 60
   with frame a attr-space side-labels width 80.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

 /* SS - 20060307 - B */
FORM
   ship_date_from COLON 19
   ship_date_to   COLON 50
   shipper_from   COLON 19
   shipper_to     COLON 50
   /* SS - 20060324 - B */
   po COLON 19
   po1 COLON 50 label "To"
   xxship  colon 19 label "发货-至"
   xxship1 colon 50 label "至"
   /* SS - 20060324 - E */
   SKIP(1)
   sel_all        COLON 19
   WITH FRAME sel_auto TITLE COLOR normal (getFrameTitle("AUTOMATIC_SELECTION",39)) SIDE-LABELS WIDTH 80.

/* SET EXTERNAL LABELS */
setFrameLabels(frame sel_auto:handle).

/* SS - 20060311 - B */
FORM
   tt1_stat LABEL "Sel"
/* ss 20070102.1 -b */
/*
   tt1_id
 */
   tt1_disp_id
/* ss 20070102.1 - e */

   tt1_ship_qty
   WITH FRAME sel_shipper WIDTH 80 TITLE COLOR normal (getFrameTitle("SHIPPER_SELECTION_MAINTENANCE",42)).
/* SS - 20060311 - E */

/* SET EXTERNAL LABELS */
setFrameLabels(frame sel_shipper:handle).

/* SS - 20060331 - B */
form
   tt1_desc1 COLON 15
   tt1_desc2 NO-LABEL FORMAT "x(10)"
   tt1_price
   tt1_po COLON 15
   tt1_ord_date
   with frame sel_item side-labels width 80.
/* SS - 20060331 - E */

/* SET EXTERNAL LABELS */
setFrameLabels(frame sel_item:handle).

/* SS - 20060311 - B */
form
   tt1_disp_id
   tt1_qty_inv
   with frame w scroll 1 4 down NO-VALIDATE ATTR-SPACE TITLE COLOR normal (getFrameTitle("SHIPPER_MATCHING_DETAIL",34)) WIDTH 80.
setFrameLabels(frame w:handle).


FORM
   /* ss 20070102.1 -b */
/*
   tt1_id
 */
   tt1_disp_id
/* ss 20070102.1 - e */
   COLON 18
   /* SS - 20060331 - B */
   pt_desc1 COLON 18
   pt_desc2 NO-LABEL
   tt1_po COLON 18
   /* SS - 20060331 - E */
   tt1_ship_qty COLON 18
   tt1_cust_part COLON 58 FORMAT "x(18)"
   tt1_qty_inv COLON 18 FORMAT "->,>>>,>>9.99999"
   tt1_close_abs COLON 48 LABEL "Closed"
   tt1_type COLON 72
   with frame match_maintenance side-labels title color normal (getFrameTitle("SHIPPER_MATCHING_MAINTENANCE",41)) width 80 no-attr-space.
/* SS - 20060311 - E */

/* SET EXTERNAL LABELS */
setFrameLabels(frame match_maintenance:handle).
/* SS - 20060307 - E */

xxrqmnbr         = "".
xxrqmsite = "".
xxrqmcust         = "".
xxrqmrqby_userid     = "".
xxrqmreq_date   = today.
xxrqmtax_in  = no.

mainloop:
repeat on error undo, retry:

   view frame a.
   HIDE FRAME w.
   HIDE FRAME match_maintenance.
   update
      xxrqmnbr
      with frame a editing:
      {mfnp.i xxrqm_mstr xxrqmnbr xxrqm_nbr xxrqmnbr xxrqm_nbr xxrqm_nbr}
      if recno <> ? then do:
         assign
            xxrqmnbr         = xxrqm_nbr
            xxrqmsite = xxrqm_site
            xxrqmcust          = xxrqm_cust
            xxrqmrqby_userid   = xxrqm_rqby_userid
            xxrqmreq_date      = xxrqm_req_date
            xxrqmtax_in        = xxrqm_tax_in
            .

         display
            xxrqmnbr
            xxrqmsite
            xxrqmcust
            xxrqmrqby_userid
            xxrqmreq_date
            xxrqmtax_in
            /* SS - 20060307 - B */
            auto_select
            /* SS - 20060307 - E */
            with frame a.
      end. /* if recno<>? */
   end.  /*with frame a eiting:*/

   /* 不允许编译已经过账的行 */
   find first xxrqm_mstr where xxrqm_nbr = xxrqmnbr no-error.
   if available xxrqm_mstr then do:
      if xxrqm_invoiced then do:
         /* TODO */
         message "该申请号已过帐，请重新输入".
         undo, retry.
      end.
      else do:
         assign
            xxrqmnbr  = xxrqm_nbr
            xxrqmsite = xxrqm_site
            xxrqmcust         = xxrqm_cust
            xxrqmrqby_userid     = xxrqm_rqby_userid
            xxrqmreq_date   = xxrqm_req_date
            xxrqmtax_in  = xxrqm_tax_in
            .
      end. /*else do*/
   end. /*if available xxrqm_mst*/

   /* 创建新行 */
   if not available xxrqm_mstr then do:
      if xxrqmnbr = "" then do :
         xxrqmnbr = "00000001".
         repeat:
            find first xxrqm_mstr where xxrqm_nbr = xxrqmnbr  no-lock no-error.
            if available xxrqm_mstr then do:
               xxrqmnbr = fill("0",8 - length(string(integer(xxrqmnbr) + 1))) + string(integer(xxrqmnbr) + 1).
            end.
            else do:
          leave.
            end.
         end. /*repeat*/
      end.
      create xxrqm_mstr.
      assign
         xxrqm_nbr = xxrqmnbr
         .

      if recid(xxrqm_mstr) = ? THEN DO:
         release xxrqm_mstr.
      END.
   end. /*if not available xxrqm_mstr*/

   display
      xxrqmnbr
      xxrqmsite
      xxrqmcust
      xxrqmrqby_userid
      xxrqmreq_date
      xxrqmtax_in
      /* SS - 20060307 - B */
      auto_select
      /* SS - 20060307 - E */
      with frame a.

   ststatus = stline[3].
   status input ststatus.

   xxrqmcustloop:
   repeat on endkey undo mainloop, retry:
      /* 地点和客户 - B */
      update
         xxrqmsite
         xxrqmcust
         with frame a editing:
         readkey.
         apply lastkey.
    end.

      FIND FIRST si_mstr WHERE si_site = xxrqmsite NO-LOCK NO-ERROR.
      if not available si_mstr
      then do:
         {pxmsg.i &MSGNUM=708 &ERRORLEVEL=3}
         next-prompt xxrqmsite with frame a.
         undo, retry.
      end.

      find first cm_mstr where cm_addr = xxrqmcust no-lock no-error.
      if not available cm_mstr then do:
         {pxmsg.i &MSGNUM=3 &ERRORLEVEL=3}
         next-prompt xxrqmcust with frame a.
         undo,retry.
      end.

      FIND first xxrqm_mstr where xxrqm_nbr = xxrqmnbr AND xxrqm_site <> "" AND xxrqm_cust <> "" no-lock NO-ERROR.
    IF available xxrqm_mstr and (xxrqm_site <> xxrqmsite OR xxrqm_cust <> xxrqmcust) THEN DO:
         /* TODO */
         message "该申请号已存在，不能修改地点和客户。请重新输入".
      next-prompt xxrqmsite with frame a.
      undo,retry.
    END.
      /* 地点和客户 - E */

      /* 删除或编辑 - B */
      ststatus = stline[2].
      status input ststatus.

      /* SS - 20060612.1 - B */
      /*
      update
         xxrqmrqby_userid
         xxrqmreq_date
         xxrqmtax_in
         go-on(F5 CTRL-D) with frame a editing:
         readkey.
         apply lastkey.
      end.
      */
      FIND first xxabs_mstr where xxabs_nbr = xxrqmnbr USE-INDEX xxabs_id no-lock NO-ERROR.
      IF AVAILABLE xxabs_mstr THEN DO:
         update
            xxrqmrqby_userid
            xxrqmreq_date
            /*
            xxrqmtax_in
            */
            go-on(F5 CTRL-D) with frame a editing:
            readkey.
            apply lastkey.
         end.
      END.
      ELSE DO:
         update
            xxrqmrqby_userid
            xxrqmreq_date
            xxrqmtax_in
            go-on(F5 CTRL-D) with frame a editing:
            readkey.
            apply lastkey.
         end.
      END.
      /* SS - 20060612.1 - E */

      if lastkey = keycode("F5") or lastkey = keycode("CTRL-D") then do:
         del-yn = no.
         {mfmsg01.i 11 1 del-yn}
         if del-yn then do:
            /* SS - 20060311 - B */
            /* 只要是未过账的申请,就允许删除 */
            DO:
               FOR EACH xxabs_mstr EXCLUSIVE-LOCK
                  WHERE xxabs_nbr = xxrqmnbr
                  USE-INDEX xxabs_id
                  :
                  DELETE xxabs_mstr.
               END.

               find first xxrqm_mstr where xxrqm_nbr = xxrqmnbr USE-INDEX xxrqm_nbr exclusive-lock no-error.
               if available xxrqm_mstr then do:
                  delete xxrqm_mstr.
               end.
            END.
            /* SS - 20060311 - E */
            clear frame a.
            ASSIGN
               xxrqmnbr        = ""
               xxrqmsite = ""
               xxrqmcust         = ""
               xxrqmrqby_userid     = ""
               xxrqmreq_date   = TODAY
               xxrqmtax_in  = no
               .
            display
               xxrqmnbr
               xxrqmsite
               xxrqmcust
               xxrqmrqby_userid
               xxrqmreq_date
               xxrqmtax_in
              /* SS - 20060307 - B */
               auto_select
              /* SS - 20060307 - E */
               with frame a.
         end.
         if del-yn then next mainloop.
      end. /*f5*/
      else do: /*f5*/
         find first xxrqm_mstr where xxrqm_nbr = xxrqmnbr exclusive-lock NO-ERROR.
         if available xxrqm_mstr then do:
            assign
               xxrqm_nbr          = xxrqmnbr
               xxrqm_site = xxrqmsite
               xxrqm_cust         = xxrqmcust
               xxrqm_rqby_userid     = xxrqmrqby_userid
               xxrqm_req_date     = xxrqmreq_date
               xxrqm_tax_in      = xxrqmtax_in
               .
         end.
         release xxrqm_mstr.
      end. /*f5*/
      /* 删除或编辑 - E */

      /* SS - 20060311 - B */
      /* 是否自动选择 - B */
      ststatus = stline[3].
      status input ststatus.
      /* 是否自动选择 - E */
      /* SS - 20060311 - E */

      leave.
   end. /*repeat*/


  loopf1:
  do on error undo, leave:

      /* 执行自动选择 - E */
      /* SS - 20060307 - B */
      IF auto_select = YES THEN DO:
         ship_date_from = ?.
         ship_date_to   = ?.
         shipper_from   = "".
         shipper_to     = "".
         /* SS - 20060324 - B */
         po = "".
         po1 = "".
         /* SS - 20060324 - E */
         /* ss - 20070108 - b */
         xxship  = "".
         xxship1 = "".
         /* ss - 20070108 - e */
         sel_all = YES.

         auto-select-block:
         /* SS - 20060331 - B */
         repeat on endkey undo mainloop, retry:
            /* SS - 20060331 - E */
            SET
               ship_date_from
               ship_date_to
               shipper_from
               shipper_to
               /* SS - 20060324 - B */
               po
               po1
               /* SS - 20060324 - E */
               /* ss - 20070108 - b */
               xxship
               xxship1
               /* ss - 20070108 - e */
               WITH FRAME sel_auto .

            SET
               sel_all
               WITH FRAME sel_auto.

            LEAVE auto-select-block .
         END.

         IF ship_date_from = ?  THEN ship_date_from = low_date.
         IF ship_date_to   = ?  THEN ship_date_to   = hi_date .
         IF shipper_to     = "" THEN shipper_to     = hi_char .
         /* SS - 20060324 - B */
         IF po1 = "" THEN po1 = hi_char.
         /* SS - 20060324 - E */
         /* ss - 20070108 - b */
         if xxship1 = "" then xxship1 = hi_char.
         /* ss - 20070108 - e */

         /* SS - 20060311 - B */
         IF sel_all THEN DO:
            sel_stat = "*".
         END.
         ELSE DO:
            sel_stat = "".
         END.
         /* SS - 20060311 - E */

         HIDE FRAME sel_auto NO-PAUSE .

         sel_total = 0 .
         FOR EACH tt1 NO-LOCK :
            DELETE tt1 .
         END.

         /* SS - 20060331 - B */
         /* SET THE DOCUMENT ID SELECTION RANGES */
         assign
            range  = "s" + shipper_from
            range1 = "s" + shipper_to.

         /* DELETE OLD RECORDS IN TEMP-TABLE */
         for each tab_abs exclusive-lock:
            delete tab_abs.
         end.

         SHIPLOOP:
         for each abs_mstr
             where abs_shipfrom = xxrqmsite
               and abs_id       >= range  and abs_id      <= range1
/* ss 20070108.1 - b */
/*
               and abs_shipto = xxrqmcust
 */
/* ss 20070108.1 - e */
               and abs_type      = "s"
               AND ABS_shp_date >= ship_date_from
               AND ABS_shp_date <= ship_date_to
               no-lock
               break by abs_id:

            if substring(abs_status,2,1) = " "
            then
               next SHIPLOOP.
            abs_recid = recid(abs_mstr).

            /*  STORE ALL ITEMS OF SHIPPER IN TEMP-TABLE */
            {gprun.i ""ssrcshrp1a.p""
               "(input recid(abs_mstr)
                 )"}

         end. /* SHIPLOOP */
         /* SS - 20060331 - E */

         FOR EACH TAB_abs NO-LOCK
            ,EACH so_mstr NO-LOCK
            WHERE so_nbr = tab_order and so_bill = xxrqmcust
            ,EACH sod_det NO-LOCK
            WHERE sod_nbr = tab_order
            AND sod_line = tab_line
            :

            /* SS - 20060612.1 - B */
            IF sod_tax_in <> xxrqmtax_in THEN DO:
               NEXT.
            END.
            /* SS - 20060612.1 - E */

            IF NOT (so_po >= po AND so_po <= po1) THEN DO:
               NEXT.
            END.

/* ss 20070108.1 - b */
            if not (so_ship >= xxship and so_ship <= xxship1) then next.
/* ss 20070108.1 - e */

            CREATE tt1.
            ASSIGN
               tt1_stat = sel_stat
               tt1_shipfrom = tab_shipfrom
               tt1_id = tab_id
/* ss 20070102.1 */ tt1_disp_id = substring(tab_id,3, length( tab_par_id ) - 1 ) + " " +
               substring(tab_id,length(tab_par_id) + 2 + length(tab_shipfrom) , length(sod_nbr) ) + " " +
               substring(tab_id,length(tab_par_id) + 2 + length(tab_shipfrom) + length(sod_nbr) , length(string(sod_line) ) ) + " " +
               substring(tab_id,length(tab_par_id) + 2 + length(tab_shipfrom) + length(sod_nbr) + length(string(sod_line) ),length(sod_part) ) + " " +
               substring(tab_id,length(tab_par_id) + 2 + length(tab_shipfrom) + length(sod_nbr) + length(string(sod_line) ) + length(sod_part) )
               tt1_par_id = tab_par_id
               tt1_shipto = tab_shipto
               tt1_order = tab_order
               tt1_po = so_po
               tt1_ord_date = so_ord_date
               tt1_line = string(tab_line)
               tt1_item = tab_item
               tt1_um  = sod_um
               /* SS - 20060401 - B */
               tt1__qad02 = TAB__qad02
               /* SS - 20060401 - E */
               tt1_ship_qty = tab_ship_qty - tab__dec04
               tt1_price = sod_price
               .

            ASSIGN
               tt1_qty_inv = tt1_ship_qty
               tt1_close_abs = YES
               tt1_type = ""
               .

            /* SS - 20060401 - B */
            /*
            IF sel_all THEN DO:
               sel_total = sel_total + tt1_qty_inv * tt1_price.
            END.
            */
            /* SS - 20060401 - E */

         END.

         /* 之前已经申请的记录 */
         FOR EACH xxabs_mstr NO-LOCK
            WHERE xxabs_nbr = xxrqmnbr
            USE-INDEX xxabs_id
            ,EACH ABS_mstr NO-LOCK
            WHERE ABS_shipfrom = xxabs_shipfrom
            AND ABS_id = xxabs_id
            USE-INDEX ABS_id
            ,EACH so_mstr NO-LOCK
            WHERE so_nbr = ABS_order
            ,EACH sod_det NO-LOCK
            WHERE sod_nbr = abs_order
            AND STRING(sod_line) = ABS_line
            :

            FIND FIRST tt1 WHERE tt1_shipfrom = xxabs_shipfrom AND tt1_id = xxabs_id USE-INDEX tt1_shipfrom_id NO-LOCK NO-ERROR.
            IF AVAILABLE tt1 THEN DO:
               /* SS - 20060401 - B */
               /*
               IF sel_all THEN DO:
                  sel_total = sel_total - tt1_qty_inv * tt1_price.
               END.
               */
               /* SS - 20060401 - E */
               ASSIGN
                  tt1_stat = "*"
                  tt1_qty_inv = xxabs_ship_qty
                  tt1_close_abs = xxabs_canceled
                  tt1_type = xxabs__chr01
                  tt1_new = NO
                  .
               /* SS - 20060401 - B */
               /*
               sel_total = sel_total + tt1_qty_inv * tt1_price.
               */
               /* SS - 20060401 - E */
            END.
            ELSE DO:

               CREATE tt1.
               ASSIGN
                  tt1_stat = sel_stat
                  tt1_shipfrom = ABS_shipfrom
                  tt1_id = ABS_id
/* ss 20070102.1 */ tt1_disp_id = substring(abs_id,3, length( abs_par_id ) - 1 ) + " " +
                  substring(abs_id,length(abs_par_id) + 2 + length(abs_shipfrom) , length(sod_nbr) ) + " " +
                  substring(abs_id,length(abs_par_id) + 2 + length(abs_shipfrom) + length(sod_nbr) , length(string(sod_line)) ) + " " +
                  substring(abs_id,length(abs_par_id) + 2 + length(abs_shipfrom) + length(sod_nbr) + length(string(sod_line)),length(sod_part) ) + " " +
                  substring(abs_id,length(abs_par_id) + 2 + length(abs_shipfrom) + length(sod_nbr) + length(string(sod_line)) + length(sod_part) )
                  tt1_par_id = ABS_par_id
                  tt1_shipto = ABS_shipto
                  tt1_order = abs_order
                  tt1_po = so_po
                  tt1_ord_date = so_ord_date
                  tt1_line = ABS_line
                  tt1_item = ABS_item
                  tt1_um  = sod_um
                  /* SS - 20060401 - B */
                  tt1__qad02 = ABS__qad02
                  /* SS - 20060401 - E */
                  tt1_ship_qty = ABS_ship_qty - ABS__dec04
                  tt1_price = sod_price
                  tt1_qty_inv = xxabs_ship_qty
                  tt1_close_abs = xxabs_canceled
                  tt1_type = xxabs__chr01
                  tt1_stat = "*"
                  tt1_new = NO
                  .

               /* SS - 20060401 - B */
               /*
               sel_total = sel_total + tt1_qty_inv * tt1_price.
               */
               /* SS - 20060401 - E */
            END.
         END. /* FOR EACH xxabs_mstr NO-LOCK */

         FOR EACH xxrqm_mstr NO-LOCK
            WHERE xxrqm_cust = xxrqmcust
            AND xxrqm_nbr <> xxrqmnbr
            AND xxrqm_invoice = NO
            USE-INDEX xxrqm_cust
            ,EACH xxabs_mstr NO-LOCK
            WHERE xxabs_nbr = xxrqm_nbr
            AND xxabs_shipfrom = xxrqmsite
            USE-INDEX xxabs_id
            BREAK BY xxabs_id
            :
            ACCUMULATE xxabs_ship_qty (TOTAL BY xxabs_id).
            IF LAST-OF(xxabs_id) THEN DO:
               FIND FIRST tt1 WHERE tt1_id = xxabs_id USE-INDEX tt1_id NO-ERROR.
               IF AVAILABLE tt1 THEN DO:
                  ASSIGN
                     tt1_ship_qty = tt1_ship_qty - (ACCUMULATE TOTAL BY xxabs_id xxabs_ship_qty)
                     .
                  IF tt1_new = YES THEN DO:
                     /* SS - 20060401 - B */
                     /*
                     IF sel_all THEN DO:
                        sel_total = sel_total - tt1_qty_inv * tt1_price.
                        ASSIGN
                           tt1_qty_inv = tt1_qty_inv - (ACCUMULATE TOTAL BY xxabs_id xxabs_ship_qty)
                           .
                        sel_total = sel_total + tt1_qty_inv * tt1_price.
                     END.
                     ELSE DO:
                        ASSIGN
                           tt1_qty_inv = tt1_qty_inv - (ACCUMULATE TOTAL BY xxabs_id xxabs_ship_qty)
                           .
                     END.
                     */
                     ASSIGN
                        tt1_qty_inv = tt1_qty_inv - (ACCUMULATE TOTAL BY xxabs_id xxabs_ship_qty)
                        .
                     /* SS - 20060401 - E */
                  END.
               END.
            END.
         END.

 /* SS - 20060324 - B */
          for each tt1 exclusive-lock where tt1_ship_qty = 0:
              delete tt1.
          end.
         /* SS - 20060401 - B */
         sel_total = 0.
/* SS - 20060401 - E*/


          FOR EACH tt1 where tt1_stat = "*" break by tt1_order by tt1_line:
             if first-of(tt1_line) then do:
                assign cnt = 0.
             end.
             /* SS - 20060401 - B */
                if tt1__qad02 <> tt1_um
                then do:
                   {gprun.i ""gpumcnv.p""
                      "(input  tt1_um,
                      input  tt1__qad02,
                      input  tt1_item,
                      output trans_conv)"}

 /* ss 20070417.1 - b */
                  if trans_conv = ? or trans_conv = 0 then trans_conv = 1.
 /* ss 20070417.1 - e */

                   ASSIGN
                      tt1_ship_qty = tt1_ship_qty / TRANS_conv
                      tt1_qty_inv = tt1_qty_inv / TRANS_conv
                      tt1_conv = TRANS_conv
                      .
                   assign cnt = cnt + tt1_qty_inv.

              if last-of(tt1_line) then do:
                 assign sel_total = sel_total + round(cnt * tt1_price , 2).
              end.
             END.
             /* SS - 20060401 - E */
          END.

/*****************************************************************************
         /* SS - 20060324 - B */
         /* SS - 20060401 - B */
         sel_total = 0.
         /* SS - 20060401 - E */
         FOR EACH tt1:
            IF tt1_ship_qty = 0 THEN DO:
               DELETE tt1.
            END.
            /* SS - 20060401 - B */
            ELSE DO:
               if tt1__qad02 <> tt1_um
               then do:
                  {gprun.i ""gpumcnv.p""
                     "(input  tt1_um,
                     input  tt1__qad02,
                     input  tt1_item,
                     output trans_conv)"}

/* ss 20070417.1 - b */
                  if trans_conv = ? or trans_conv = 0 then trans_conv = 1.
/* ss 20070417.1 - e */

                  ASSIGN
                     tt1_ship_qty = tt1_ship_qty / TRANS_conv
                     tt1_qty_inv = tt1_qty_inv / TRANS_conv
                     tt1_conv = TRANS_conv
                     .
               end.

               IF tt1_stat = "*" THEN DO:
                  sel_total = sel_total + round(tt1_qty_inv * tt1_price , 2).
               END.
            END.
            /* SS - 20060401 - E */
         END.
         /* SS - 20060324 - E */
*****************************************************************************/
         DISPLAY
            sel_total
            WITH FRAME a.

         sw_block:
         do on endkey undo, leave:
            /* SS - 20060311 - B */
            FIND FIRST tt1 NO-LOCK NO-ERROR.
            IF NOT AVAILABLE tt1 THEN DO:
               MESSAGE "不存在相关货运单的资料".
               LEAVE loopf1.
            END.
            /* SS - 20060311 - E */

            display
               xxrqmnbr
               xxrqmsite
               xxrqmcust
               xxrqmrqby_userid
               xxrqmreq_date
               xxrqmtax_in
               auto_select
               sel_total
               with frame a.

            VIEW FRAME sel_shipper.
            VIEW FRAME sel_item .
            clear frame match_maintenance.
            /* INCLUDE SCROLLING WINDOW TO ALLOW THE USER TO SCROLL      */
            /* THROUGH (AND SELECT FROM) EXISTING PAYMENTS APPLICATIONS  */
            {swselect.i
               &detfile      = tt1

               &scroll-field = tt1_disp_id
               &framename    = "sel_shipper"
               &framesize    = 7
               &sel_on       = ""*""
               &sel_off      = """"
               &display1     = tt1_stat

               &display2     = tt1_disp_id
               &display3     = tt1_ship_qty
               &exitlabel    = sw_block
               &exit-flag    = first_sw_call
               &record-id    = apwork-recno
               &include1     = "
                  /* ACCUMULATE OPEN AMOUNT INTO SELECTION TOTAL */
                  sel_total = sel_total - tt1_ship_qty * tt1_price.
                  /* DISPLAY SUMMARY & tt1_item INFORMATION */
                  display sel_total with frame a.
                  "
               &include2     = "
                  /* ACCUMULATE OPEN AMOUNT INTO SELECTION TOTAL */
                  sel_total = sel_total + tt1_ship_qty * tt1_price.
                  /* DISPLAY SUMMARY & tt1_item INFORMATION */
                  display sel_total with frame a.
                  "
               &include3     = "
                  /* DISPLAY SUMMARY & tt1_item INFORMATION */
                  /* SS - 20060331 - B */
                  find FIRST pt_mstr where pt_part = tt1_item no-lock no-error.
                  if available pt_mstr THEN DO:
                     display
                        pt_desc1 @ tt1_desc1
                        pt_desc2 @ tt1_desc2
                        tt1_price
                        tt1_po
                        tt1_ord_date
                        with frame sel_item.
                  END.
                  ELSE DO:
                     display
                        '非库存零件' @ tt1_desc1
                        '' @ tt1_desc2
                        tt1_price
                        tt1_po
                        tt1_ord_date
                        with frame sel_item.
                  END.
                  /* SS - 20060331 - E */
                  "
               }

            HIDE FRAME sel_shipper.
            HIDE FRAME sel_item.

            LEAVE sw_block.
         END. /* do on endkey undo, leave: */

         /* 删除没有选择的记录 */
         FOR EACH tt1 NO-LOCK
            WHERE tt1_stat <> "*"
            USE-INDEX tt1_stat
            :
            FOR EACH xxabs_mstr EXCLUSIVE-LOCK
               WHERE xxabs_nbr = xxrqmnbr
               AND xxabs_shipfrom = tt1_shipfrom
               AND xxabs_id = tt1_id
               :
               DELETE xxabs_mstr.
            END.
            DELETE tt1.
         END.  /* FOR EACH tt1 NO-LOCK WHERE tt1.sel_stat = "*" : */

         /* 更新客户零件,更新或创建已经选择的记录 */
         FOR EACH tt1 EXCLUSIVE-LOCK:
            FIND FIRST cp_mstr
               WHERE cp_part = tt1_item
               AND cp_cust = tt1_shipto
               USE-INDEX cp_part_cust
               NO-LOCK
               NO-ERROR
               .
            IF AVAILABLE cp_mstr THEN DO:
               ASSIGN
                  tt1_cust_part = cp_cust_part
                  .
            END.

            FIND FIRST xxabs_mstr
               WHERE xxabs_nbr = xxrqmnbr
               AND xxabs_shipfrom = tt1_shipfrom
               AND xxabs_id = tt1_id
               EXCLUSIVE-LOCK
               NO-ERROR
               .
            IF NOT AVAIL xxabs_mstr THEN DO:
               /*
               {pxmsg.i &MSGNUM=1 &ERRORLEVEL=1}
                  */
               CREATE xxabs_mstr.
               ASSIGN
                  xxabs_nbr = xxrqmnbr
                  xxabs_shipfrom = tt1_shipfrom
                  xxabs_id  = tt1_id
                  xxabs_par_id = tt1_par_id
                  xxabs_order = tt1_order
                  xxabs_line = tt1_line
                  /* SS - 20060401 - B */
                  xxabs_ship_qty = tt1_qty_inv * tt1_conv
                  /* SS - 20060401 - E */
                  xxabs_canceled = tt1_close_abs
                  xxabs__chr01 = tt1_type
                  .
            END.
            ELSE DO:
               ASSIGN
                  xxabs_nbr = xxrqmnbr
                  xxabs_shipfrom = tt1_shipfrom
                  xxabs_id  = tt1_id
                  xxabs_par_id = tt1_par_id
                  xxabs_order = tt1_order
                  xxabs_line = tt1_line
                  /* SS - 20060401 - B */
                  xxabs_ship_qty = tt1_qty_inv * tt1_conv
                  /* SS - 20060401 - E */
                  xxabs_canceled = tt1_close_abs
                  xxabs__chr01 = tt1_type
                  .
               RELEASE xxabs_mstr.
            END.
         END.  /* FOR EACH tt1 NO-LOCK WHERE tt1.sel_stat = "*" : */

         if keyfunction(lastkey) = "end-error" or keyfunction(lastkey) = "." then do:
            LEAVE loopf1.
            HIDE FRAME sel_shipper.
            HIDE FRAME sel_item.
         end. /* IF keyfunction(lastkey) = "end-error" ... */
      END.  /*  IF auto_select = YES THEN DO: */
      /* SS - 20060307 - E */
      /* 执行自动选择 - E */

      HIDE FRAME sel_shipper.
      HIDE FRAME sel_item.
      {gprun.i ""sssoivm1a.p""}

      ststatus = stline[2].
      status input ststatus.

      loopf2:
      REPEAT WITH FRAME match_maintenance:
/* ss 20070102.1 - b */
/*
         PROMPT-FOR
            tt1_id
            editing:
            if frame-field = "tt1_id" then do:
               /* NEXT-PREV ON ATTACHED RECEIVERS ONLY */
               {mfnp.i tt1 tt1_id tt1_id tt1_id tt1_id tt1_id}

               if recno <> ? then do:
                  /* SS - 20060331 - B */
                  FIND FIRST pt_mstr WHERE pt_part = tt1_item NO-LOCK NO-ERROR.
                  IF AVAILABLE pt_mstr THEN DO:
                     DISP
                        tt1_id
                        pt_desc1
                        pt_desc2
                        tt1_po
                        tt1_ship_qty
                        tt1_cust_part
                        tt1_qty_inv
                        tt1_close_abs
                        tt1_type
                        WITH FRAME match_maintenance .
                  END.
                  ELSE DO:
                     DISP
                        tt1_id
                        "非库存零件" @ pt_desc1
                        "" @ pt_desc2
                        tt1_po
                        tt1_ship_qty
                        tt1_cust_part
                        tt1_qty_inv
                        tt1_close_abs
                        tt1_type
                        WITH FRAME match_maintenance .
                  END.
                  /* SS - 20060331 - E */
               END.
            END. /* if frame-field = "receiver" then do: */
            ELSE DO:
               STATUS INPUT.
               readkey.
               apply lastkey.
            END.
         END. /* with frame match_maintenance editing: */

         FIND FIRST tt1 WHERE tt1_id = INPUT tt1_id  NO-LOCK NO-ERROR.
         IF NOT AVAILABLE tt1 THEN DO:
            MESSAGE "记录不存在".
            NEXT-PROMPT tt1_id.
            UNDO,RETRY.
         END.
 */
         PROMPT-FOR
            tt1_disp_id
            editing:
            if frame-field = "tt1_disp_id" then do:
               /* NEXT-PREV ON ATTACHED RECEIVERS ONLY */
               {mfnp.i tt1 tt1_disp_id tt1_disp_id tt1_disp_id tt1_disp_id tt1_disp_id}

               if recno <> ? then do:
                  /* SS - 20060331 - B */
                  FIND FIRST pt_mstr WHERE pt_part = tt1_item NO-LOCK NO-ERROR.
                  IF AVAILABLE pt_mstr THEN DO:
                     DISP
                        tt1_disp_id
                        pt_desc1
                        pt_desc2
                        tt1_po
                        tt1_ship_qty
                        tt1_cust_part
                        tt1_qty_inv
                        tt1_close_abs
                        tt1_type
                        WITH FRAME match_maintenance .
                  END.
                  ELSE DO:
                     DISP
                        tt1_disp_id
                        "非库存零件" @ pt_desc1
                        "" @ pt_desc2
                        tt1_po
                        tt1_ship_qty
                        tt1_cust_part
                        tt1_qty_inv
                        tt1_close_abs
                        tt1_type
                        WITH FRAME match_maintenance .
                  END.
                  /* SS - 20060331 - E */
               END.
            END. /* if frame-field = "receiver" then do: */
            ELSE DO:
               STATUS INPUT.
               readkey.
               apply lastkey.
            END.
         END. /* with frame match_maintenance editing: */

         assign tt1_disp_id.
         FIND FIRST tt1 WHERE tt1_disp_id = INPUT tt1_disp_id  NO-LOCK NO-ERROR.
         IF NOT AVAILABLE tt1 THEN DO:
            MESSAGE "记录不存在".
            NEXT-PROMPT tt1_disp_id.
            clear frame match_maintenance.
            UNDO,RETRY loopf2.
         END.
         else do:
              if tt1_close_abs then do:
                 MESSAGE "记录已关闭不允修改".
                 NEXT-PROMPT tt1_disp_id.
                 clear frame match_maintenance.
                 undo,retry loopf2.
              end.
         end.
/* ss 20070102.1 - e */

         /* SS - 20060311 - B */
         ststatus = stline[2].
         status input ststatus.
         /* SS - 20060311 - E */

         sel_total = sel_total - tt1_qty_inv * tt1_price.
         SET  tt1_qty_inv validate ( tt1_qty_inv <> ?,"不允许为？")
              go-on ("F5" "CTRL-D") WITH FRAME match_maintenance .
         sel_total = sel_total + tt1_qty_inv * tt1_price.
         if tt1_ship_qty <> tt1_qty_inv then do:
            DISP no @ tt1_close_abs
                 WITH FRAME match_maintenance.
         end.
         DISP
            sel_total
            WITH FRAME a.

         if lastkey = keycode("F5") or lastkey = keycode("CTRL-D") then do:
            del-yn = yes.
            {mfmsg01.i 11 1 del-yn}
            if not del-yn then undo loopf2.
         end. /* then do: */

         if del-yn then do:
            FOR EACH xxabs_mstr EXCLUSIVE-LOCK
               WHERE xxabs_nbr = xxrqmnbr
               AND xxabs_shipfrom = tt1_shipfrom
               AND xxabs_id = tt1_id
               USE-INDEX xxabs_id
               :
               delete xxabs_mstr .
            END.

            sel_total = sel_total - tt1_qty_inv * tt1_price.
            DISP
               sel_total
               WITH FRAME a.

            DELETE tt1.

            clear frame match_maintenance.
            del-yn = no.
            next loopf2.
         end. /* if del-yn then do: */

         /* SS - 20060311 - B */
         /* 发票数量等于短缺量时,自动关闭,且不可更改 */
         IF tt1_ship_qty = tt1_qty_inv THEN DO:
            tt1_close_abs = YES.
            tt1_type = "".

            DISP
               tt1_close_abs
               tt1_type
               WITH FRAME match_maintenance .
         END.
         /* 发票数量不等于短缺量时,可以选择关闭 */
         ELSE DO:
            tt1_close_abs = NO.
            tt1_type = "".

            DISP
               tt1_type
               WITH FRAME match_maintenance.

            SET
               tt1_close_abs
               WITH FRAME match_maintenance .
         END.

         /* 当关闭货运单项且发票数量不等于短缺量时,允许记录原因代码 */
         IF tt1_close_abs = YES AND tt1_ship_qty <> tt1_qty_inv THEN DO:
            SET
               tt1_type
               WITH FRAME match_maintenance.
         END.
         /* SS - 20060311 - E */

         FIND FIRST xxabs_mstr
            WHERE xxabs_nbr = xxrqmnbr
            AND xxabs_shipfrom = tt1_shipfrom
            AND xxabs_id = tt1_id
            USE-INDEX xxabs_id
            EXCLUSIVE-LOCK
            NO-ERROR
            .
         IF NOT AVAIL xxabs_mstr THEN DO:
            {pxmsg.i &MSGNUM=1 &ERRORLEVEL=1}
            CREATE xxabs_mstr.
            ASSIGN
               xxabs_nbr = xxrqmnbr
               xxabs_shipfrom = tt1_shipfrom
               xxabs_id  = tt1_id
               xxabs_par_id = tt1_par_id
               xxabs_order = tt1_order
               xxabs_line = tt1_line
               /* SS - 20060401 - B */
               xxabs_ship_qty = tt1_qty_inv * tt1_conv
               /* SS - 20060401 - E */
               xxabs_canceled = tt1_close_abs
               xxabs__chr01 = tt1_type
               .
         END.
         ELSE DO:
            ASSIGN
               xxabs_nbr = xxrqmnbr
               xxabs_shipfrom = tt1_shipfrom
               xxabs_id  = tt1_id
               xxabs_par_id = tt1_par_id
               xxabs_order = tt1_order
               xxabs_line = tt1_line
               /* SS - 20060401 - B */
               xxabs_ship_qty = tt1_qty_inv * tt1_conv
               /* SS - 20060401 - E */
               xxabs_canceled = tt1_close_abs
               xxabs__chr01 = tt1_type
               .
            RELEASE xxabs_mstr.
         END.

         if keyfunction(lastkey) = "end-error" or keyfunction(lastkey) = "." then do:
            leave loopf1.
            HIDE FRAME w.
            HIDE FRAME match_maintenance .
         end. /* IF keyfunction(lastkey) = "end-error" ... */
      END. /* loopf2: */
   END. /* loopf1 : do on error undo, leave: */
end. /*mainloop*/

STATUS input.
