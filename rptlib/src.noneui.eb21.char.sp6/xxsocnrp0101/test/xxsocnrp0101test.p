/* socnrp01.p - Consignment Cross Reference Report                           */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                       */
/* All rights reserved worldwide.  This is an unpublished work.              */
/* $Revision: 1.8 $                                                    */

/* Revision: 1.6         BY: Steve Nugent DATE: 04/04/02  ECO: *P00F* */
/* $Revision: 1.8 $        BY: Steve Nugent DATE: 06/19/02  ECO: *P091* */

/*V8:ConvertMode=FullGUIReport                                            */
/*                                                                           */
/* -----  W A R N I N G  -----  W A R N I N G  -----  W A R N I N G  -----   */
/*                                                                           */
/*         THIS PROGRAM IS A BOLT-ON TO STANDARD PRODUCT MFG/PRO.            */
/* ANY CHANGES TO THIS PROGRAM MUST BE PLACED ON A SEPARATE ECO THAN         */
/* STANDARD PRODUCT CHANGES.  FAILURE TO DO THIS CAUSES THE BOLT-ON CODE TO  */
/* BE COMBINED WITH STANDARD PRODUCT AND RESULTS IN PATCH DELIVERY FAILURES  */
/*                                                                           */
/* -----  W A R N I N G  -----  W A R N I N G  -----  W A R N I N G  -----   */
/*                                                                           */

/* 以下为版本历史 */
/* SS - 090325.1 By: Bill Jiang */

/*以下为发版说明 */
/* SS - 090325.1 - RNB
【090325.1】

修改于以下标准菜单程序:
  - 按订单排序的寄售库存报表 [socnrp01.p]

请参考以上标准菜单程序的相关帮助

请参考以下标准菜单程序进行验证:
  - 按订单排序的寄售库存报表 [socnrp01.p]

顺序输出了以下字段:

【090325.1】

SS - 090325.1 - RNE */

/*
{mfdtitle.i "2+ "}
*/
{mfdtitle.i "090325.1"}

/* SS - 090325.1 - B */
{xxsocnrp0101.i "new"}
/* SS - 090325.1 - E */

define variable shipfrom_from like cncix_site label "Ship-From" no-undo.
define variable shipfrom_to like cncix_site no-undo.
define variable cust_from like cncix_cust no-undo.
define variable cust_to like cncix_cust no-undo.
define variable shipto_from like cncix_shipto no-undo.
define variable shipto_to like cncix_shipto no-undo.
define variable part_from like cncix_part label "Item Number" no-undo.
define variable part_to like cncix_part no-undo.
define variable po_from like cncix_po label "PO Number" no-undo.
define variable po_to like cncix_po no-undo.
define variable order_from like cncix_so_nbr label "Order" no-undo.
define variable order_to   like cncix_so_nbr no-undo.
define variable date_from like cncix_ship_date label "Date Created" no-undo.
define variable date_to   like cncix_ship_date no-undo.
define variable sort_option as integer
           label "Sort Option" format "9" initial 1 no-undo.
define variable sortoption1 as character format "x(53)" no-undo.
define variable sortoption2 as character format "x(53)" no-undo.
define variable show_amts like mfc_logical label "Show Amounts" no-undo.


assign
   sortoption1 = "1 - " + getTermLabel("BY_SHIP-FROM",12) + ", " +
                          getTermLabel("CUSTOMER",8) + ", " +
                          getTermLabel("SHIP-TO",7) + ", " +
                          getTermLabel("ORDER",5) + ", " +
                          getTermLabel("ITEM",4) + ", " +
                          getTermLabel("PURCHASE_ORDER",2)
   sortoption2 = "2 - " + getTermLabel("BY_SHIP-FROM",12) + ", " +
                          getTermLabel("ITEM",4) + ", " +
                          getTermLabel("CUSTOMER",8) + ", " +
                          getTermLabel("SHIP-TO",7) + ", " +
                          getTermLabel("ORDER",5) + ", " +
                          getTermLabel("PURCHASE_ORDER",2).

/* SELECTION FORM A */
form
    shipfrom_from  colon 15
    shipfrom_to    colon 45 label {t001.i}
    cust_from      colon 15
    cust_to        colon 45 label {t001.i}
    shipto_from    colon 15
    shipto_to      colon 45 label {t001.i}
    part_from      colon 15
    part_to        colon 45 label {t001.i}
    po_from        colon 15
    po_to          colon 45 label {t001.i}
    order_from     colon 15
    order_to       colon 45 label {t001.i}
    date_from      colon 15
    date_to        colon 45 label {t001.i}
    skip(1)
   /* SS - 090325.1 - B
    show_amts       colon 35
    sort_option    colon 15
    skip
    sortoption1    at 17 no-label
    sortoption2    at 17 no-label
    skip(1)
   SS - 090325.1 - E */
 with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).



{wbrp01.i}


repeat:

   if shipfrom_to = hi_char then shipfrom_to = "".
   if cust_to = hi_char     then cust_to = "".
   if shipto_to = hi_char   then shipto_to = "".
   if part_to = hi_char     then part_to = "".
   if po_to = hi_char       then po_to = "".
   if order_to = hi_char    then order_to = "".
   if date_from = low_date  then date_from = ?.
   if date_to = hi_date     then date_to = ?.

   /* SS - 090325.1 - B
   display
      sortoption1
      sortoption2
   with frame a.
   SS - 090325.1 - E */
   if (c-application-mode <> "WEB") then
      update
         shipfrom_from
         shipfrom_to
         cust_from
         cust_to
         shipto_from
         shipto_to
         part_from
         part_to
         po_from
         po_to
         order_from
         order_to
         date_from
         date_to
   /* SS - 090325.1 - B
         show_amts
         sort_option
      SS - 090325.1 - E */
      with frame a.

   {wbrp06.i &command = update
      &fields = "shipfrom_from shipfrom_to
                 cust_from cust_to
                 shipto_from shipto_to
                 part_from part_to
                 po_from po_to
                 order_from  order_to
                 date_from date_to
   /* SS - 090325.1 - B
                 show_amts sort_option
      SS - 090325.1 - E */
      "
     &frm = "a"}

   /* SS - 090325.1 - B
   /* VALIDATE SORT OPTION FIELD */
   if sort_option <> 1  and
      sort_option <> 2  then do:
      {pxmsg.i &MSGNUM=2313 &ERRORLEVEL=3} /* INVALID SORT OPTION */
      next-prompt sort_option with frame a.
      undo, retry.
   end.
   SS - 090325.1 - E */

   if (c-application-mode <> "WEB") or
      (c-application-mode <> "WEB" and
      (c-web-request begins "DATA")) then do:

       bcdparm = "".
       {mfquoter.i shipfrom_from}
       {mfquoter.i shipfrom_to  }
       {mfquoter.i cust_from    }
       {mfquoter.i cust_to      }
       {mfquoter.i shipto_from  }
       {mfquoter.i shipto_to    }
       {mfquoter.i part_from    }
       {mfquoter.i part_to      }
       {mfquoter.i po_from      }
       {mfquoter.i po_to        }
       {mfquoter.i order_from   }
       {mfquoter.i order_to     }
       {mfquoter.i date_from    }
       {mfquoter.i date_to      }
       {mfquoter.i show_amts}
       {mfquoter.i sort_option  }


   end. /* IF (c-application-mode */

    if shipfrom_to = "" then shipfrom_to = hi_char.
    if cust_to = ""     then cust_to = hi_char.
    if shipto_to = ""   then shipto_to = hi_char.
    if part_to = ""     then part_to = hi_char.
    if po_to = ""       then po_to = hi_char.
    if order_to = ""    then order_to = hi_char.
    if date_from = ?    then date_from = low_date.
    if date_to = ?      then date_to = hi_date.

   /* OUTPUT DESTINATION SELECTION */
   {gpselout.i &printType = "printer"
               &printWidth = 132
               &pagedFlag = " "
               &stream = " "
               &appendToFile = " "
               &streamedOutputToTerminal = " "
               &withBatchOption = "yes"
               &displayStatementType = 1
               &withCancelMessage = "yes"
               &pageBottomMargin = 6
               &withEmail = "yes"
               &withWinprint = "yes"
               &defineVariables = "yes"}

   /* SS - 090325.1 - B
   {mfphead.i}

   if sort_option = 1 then do:
      {gprun.i ""socnrp1a.p""
     "(input shipfrom_from,
       input shipfrom_to,
       input cust_from,
       input cust_to,
       input shipto_from,
       input shipto_to,
       input part_from,
       input part_to,
       input po_from,
       input po_to,
       input order_from,
       input order_to,
       input date_from,
       input date_to,
       input show_amts)"
      }
   end.
   else
   if sort_option = 2 then do:
      {gprun.i ""socnrp1b.p""
     "(input shipfrom_from,
       input shipfrom_to,
       input cust_from,
       input cust_to,
       input shipto_from,
       input shipto_to,
       input part_from,
       input part_to,
       input po_from,
       input po_to,
       input order_from,
       input order_to,
       input date_from,
       input date_to,
       input show_amts)"
      }
   end.

   /* REPORT TRAILER */
   {mfrtrail.i}
   SS - 090325.1 - E */

   /* SS - 090325.1 - B */
   PUT UNFORMATTED "BEGIN: " + STRING(TIME, "HH:MM:SS") SKIP.
   
   FOR EACH ttxxsocnrp0101:
      DELETE ttxxsocnrp0101.
   END.
   
   {gprun.i ""xxsocnrp0101.p"" "(
      input shipfrom_from,
      input shipfrom_to,
      input cust_from,
      input cust_to,
      input shipto_from,
      input shipto_to,
      input part_from,
      input part_to,
      input po_from,
      input po_to,
      input order_from,
      input order_to,
      input date_from,
      input date_to
      )"}
   
   EXPORT DELIMITER ";" "地点" "地点名称" "订单" "项" "客户" "客户名称" "发货-至" "发货-至名称" "物料" "物料名称" "采购订单号" "最多过期天数" "库位" "批/序号" "授权" "库存数量" "库存单位" "已发货量" "发货人" "发货日期" "参考" "在途中" "最多过期日期" "原币金额" "原币" "本币金额" "本币" "curr_error1" "curr_error2".
   EXPORT DELIMITER ";" "标准输出" "标准输出" "标准输出" "标准输出" "标准输出" "标准输出" "标准输出" "标准输出" "标准输出" "标准输出" "标准输出" "标准输出" "标准输出" "标准输出" "标准输出" "标准输出" "标准输出" "标准输出" "标准输出" "标准输出" "标准输出" "标准输出" "标准输出" "标准输出" "标准输出" "标准输出" "标准输出" "标准输出" "标准输出".
   EXPORT DELIMITER ";" "cncix_site" "site_description" "cncix_so_nbr" "cncix_sod_line" "cncix_cust" "cust_description" "cncix_shipto" "ship_description" "cncix_part" "part_description" "cncix_po" "max_aging_days" "cncix_current_loc" "cncix_lotser" "cncix_auth" "cncix_qty_stock" "cncix_stock_um" "cncix_qty_ship" "cncix_asn_shipper" "cncix_ship_date" "cncix_ref" "cncix_intransit" "cncix_aged_date" "cncix_ship_value" "cncix_curr" "qoh_base_curr" "gl_base_curr" "curr_error1" "curr_error2".
   FOR EACH ttxxsocnrp0101:
      EXPORT DELIMITER ";" ttxxsocnrp0101.
   END.
   
   PUT UNFORMATTED "END: " + STRING(TIME, "HH:MM:SS") SKIP.
   
   {xxmfrtrail.i}
   /* SS - 090325.1 - E */

end. /*REPEAT*/

{wbrp04.i &frame-spec = a}
