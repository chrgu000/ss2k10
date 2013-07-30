/*By Ken SS - 090419.1 */
/*xxctrp01.p 海关合同打印*/

/* DISPLAY TITLE */
{mfdtitle.i "090419.1"}

DEFINE VARIABLE xxct_nbr AS CHARACTER FORMAT "x(20)".

DEFINE NEW SHARED VARIABLE xxct_mstr AS CHARACTER INIT "Softspeed_CUSTOM_MSTR".
DEFINE NEW SHARED VARIABLE xxctd_det AS CHARACTER INIT "Softspeed_CUSTOM_DET".
DEFINE NEW SHARED VARIABLE xxctd_pk  AS CHARACTER INIT "Softspeed_CUSTOM_PACKING".

DEFINE NEW SHARED VARIABLE v_abs_par_id AS CHARACTER.
DEFINE NEW SHARED VARIABLE v_sod_list_pr LIKE sod_list_pr.

DEFINE NEW SHARED VARIABLE v_ship AS CHARACTER.
DEFINE NEW SHARED VARIABLE v_sold AS CHARACTER.

DEFINE NEW SHARED VARIABLE v_remark1 AS CHARACTER.
DEFINE NEW SHARED VARIABLE v_remark2 AS CHARACTER.
DEFINE NEW SHARED VARIABLE v_remark3 AS CHARACTER.

DEFINE NEW SHARED VARIABLE xxct_nbr_date AS CHARACTER.
DEFINE NEW SHARED VARIABLE xxct_etd_date AS CHARACTER.


FORM
   xxct_nbr      colon 25
   with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

{wbrp01.i}

repeat on error undo, retry:


   if c-application-mode <> "WEB" then
   update
         xxct_nbr
   with frame a.

   {wbrp06.i &command = update &fields = " xxct_nbr " &frm = "a"}

   v_remark1 = "".
   v_remark2 = "".
   v_remark3 = "".
   xxct_nbr_date = "".
    xxct_etd_date = "".


   FIND FIRST usrw_wkfl WHERE usrw_domain = GLOBAL_domain
       AND usrw_key1 = xxct_mstr
       AND usrw_key2 = xxct_nbr
       NO-LOCK NO-ERROR.
   IF NOT AVAIL usrw_wkfl THEN DO:
       MESSAGE "合同不存在".
       NEXT-PROMPT xxct_nbr.
       UNDO,RETRY.
   END.
   ELSE DO:
       v_remark1 = "PACKING SLIP NO.:" + xxct_nbr.
       v_remark2 = "No:" + usrw_charfld[9].
       xxct_nbr_date = string(usrw_datefld[1]).
       xxct_etd_date = string(usrw_datefld[3]).

       FIND FIRST cmt_det WHERE cmt_domain = GLOBAL_domain
           AND cmt_indx = usrw_intfld[3]
           NO-LOCK NO-ERROR.
       IF AVAIL cmt_det THEN DO:
           v_remark3 = cmt_cmmt[5].
       END.

   END.

   FIND FIRST abs_mstr WHERE abs_domain = global_domain AND substring(abs_mstr.abs__qad01 ,61,20) = xxct_nbr
       AND substring(abs_status,2,1) = "y"
       NO-LOCK NO-ERROR.
   IF NOT AVAIL ABS_mstr  THEN DO:

       MESSAGE "合同对应的货运单没有确认".
       NEXT-PROMPT xxct_nbr.
       UNDO,RETRY.

   END.
   ELSE DO:
       v_abs_par_id = abs_id.
   END.

   if (c-application-mode <> "WEB") or
      (c-application-mode = "WEB" and
      (c-web-request begins "DATA"))
   then do:

      bcdparm = "".
      {mfquoter.i xxct_nbr  }

   end.

   /* SELECT PRINTER */
   {gpselout.i
       &printType = "printer"
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

DEFINE TEMP-TABLE tt1
       FIELD tt1_sold_name  AS CHARACTER
       FIELD tt1_sold_addr1 AS CHARACTER
       FIELD tt1_sold_addr2 AS CHARACTER
       FIELD tt1_sold_tel_fax AS CHARACTER

       FIELD tt1_ship_name  AS CHARACTER
       FIELD tt1_ship_addr1 AS CHARACTER
       FIELD tt1_ship_addr2 AS CHARACTER
       FIELD tt1_ship_tel_fax AS CHARACTER

       FIELD tt1_cust_part AS CHARACTER
       FIELD tt1_cust_part_desc1 AS CHARACTER
       FIELD tt1_cust_part_desc2 AS CHARACTER
       FIELD tt1_cust_part_desc3 AS CHARACTER
       FIELD tt1_qty AS DECIMAL
       FIELD tt1_price AS DECIMAL FORMAT ">>,>>>,>>9.9999"
       FIELD tt1_amt AS DECIMAL FORMAT ">>>,>>>,>>9.9999"
       FIELD tt1_remark1 AS CHARACTER
       FIELD tt1_remark2 AS CHARACTER
       FIELD tt1_remark3 AS CHARACTER

       FIELD tt1_nbr AS CHARACTER
       FIELD tt1_nbr_date AS CHARACTER
       FIELD tt1_etd_date AS CHARACTER
       FIELD tt1_inv_nbr AS CHARACTER
       .

EMPTY TEMP-TABLE tt1.

for each abs_mstr where abs_domain = global_domain and abs_par_id =  v_abs_par_id no-lock :

   v_ship = "".
   v_sold = "".

   find first sod_det where sod_domain = global_domain and sod_nbr = abs_order and sod_line = integer(abs_line) no-lock no-error .
   if available sod_det then do :
     v_sod_list_pr = sod_list_pr.
     FIND FIRST so_mstr WHERE so_domain = GLOBAL_domain
         AND so_nbr = sod_nbr NO-LOCK NO-ERROR.
     IF AVAIL so_mstr THEN DO:

         v_ship = so_ship.
         v_sold = so_cust.

     END.
   end .
   ELSE DO:
     v_sod_list_pr = 0.
   END.

   CREATE tt1.

   FIND FIRST ad_mstr WHERE ad_domain = GLOBAL_domain
       AND ad_addr = v_sold
       NO-LOCK NO-ERROR.
   IF AVAIL ad_mstr  THEN DO:
       ASSIGN tt1_sold_name = ad_name
              tt1_sold_addr1 = ad_line1
              tt1_sold_addr2 = ad_line2
              tt1_sold_tel_fax = "Tel:" + ad_phone + ",Fax:" + ad_fax.
   END.

   FIND FIRST ad_mstr WHERE ad_domain = GLOBAL_domain
       AND ad_addr = v_ship
       NO-LOCK NO-ERROR.
   IF AVAIL ad_mstr THEN DO:

       ASSIGN tt1_ship_name = ad_name
              tt1_ship_addr1 = ad_line1
              tt1_ship_addr2 = ad_line2
              tt1_ship_tel_fax = "Tel:" + ad_phone + ",Fax:" + ad_fax.
   END.

   FIND FIRST cp_mstr WHERE cp_domain = GLOBAL_domain
       AND cp_part = ABS_item
       NO-LOCK NO-ERROR.
   IF AVAIL cp_mstr THEN DO:
       ASSIGN tt1_cust_part = cp_cust_part
              tt1_cust_part_desc1 = cp_comment
              tt1_cust_part_desc2 = cp_cust_eco.
   END.
   ELSE DO:

       ASSIGN tt1_cust_part = ABS_item
              tt1_cust_part_desc1 = "客户物料没维护"
              tt1_cust_part_desc2 = "".
   END.

   ASSIGN tt1_qty = ABS_ship_qty
          tt1_price = v_sod_list_pr
          tt1_amt = ABS_ship_qty * v_sod_list_pr
          tt1_remark1 = v_remark1
          tt1_remark2 = v_remark2
          tt1_remark3 = v_remark3
          tt1_nbr = xxct_nbr
          tt1_nbr_date = xxct_nbr_date
          tt1_etd_date = xxct_etd_date.



END.

FOR EACH tt1:
    FIND FIRST ABS_mstr WHERE ABS_domain = GLOBAL_domain
        AND ABS_id = v_abs_par_id
        NO-LOCK NO-ERROR.
    IF AVAIL ABS_mstr THEN DO:
        tt1_inv_nbr = abs__chr10.
    END.
END.


PUT UNFORMATTED "#def REPORTPATH=$/QAD Addons/BI Report/" + SUBSTRING(execname,1,LENGTH(execname) - 2) SKIP.
PUT UNFORMATTED "#def :end" SKIP.

FOR EACH tt1:
    EXPORT DELIMITER ";" tt1.
END.




{mfreset.i}
end.

{wbrp04.i &frame-spec = a}
