/* xxsoivrp1.p -  salse order invoice report                                  */
/*-Revision end---------------------------------------------------------------*/

{mfdtitle.i "1485"}

define variable invnbr like idh_inv_nbr no-undo.
define variable invnbr1 like idh_inv_nbr no-undo.
define variable part like pt_part no-undo.
define variable part1 like pt_part no-undo.
define variable shpdt as date no-undo.
define variable shpdt1 as date no-undo.
define variable ltser like ld_lot no-undo.
define variable ltser1 like ld_lot no-undo.
define variable issdte like ld_date no-undo.
define variable dte   like ld_date no-undo.
define variable lot   like ld_lot no-undo.

define temp-table xxbi
  fields bi_shipdate as character
  fields bi_inv_nbr like idh_inv_nbr
  fields bi_sopo like idh_contr_id
/*  fields bi_nbr like idh_nbr */
  fields bi_line like idh_line
  fields bi_qyt_ship like idh_qty_ship
  fields bi_um like idh_um
  fields bi_serial like idh_serial
  fields bi_prod_dte as character
  fields bi_part like idh_part
  fields bi_custpart like idh_custpart.

form
   shpdt   colon 14
   shpdt1  colon 38 label {t001.i}
   invnbr   colon 14
   invnbr1  colon 38 label {t001.i}
   part     colon 14
   part1    label {t001.i}
   ltser      colon 14
   ltser1     colon 38 label {t001.i} skip(2)
with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

{wbrp01.i}

repeat:

   if invnbr1 = hi_char then invnbr1 = "".
   if part1 = hi_char then part1 = "".
   if ltser1  = hi_char then ltser1 = "".
   if shpdt = low_date then shpdt = ?.
   if shpdt1 = hi_date then shpdt1 = ?.

 if c-application-mode <> 'web' then
    update shpdt shpdt1 invnbr invnbr1 part part1 ltser ltser1 with frame a.

         {wbrp06.i &command = update
          &fields = " shpdt shpdt1 invnbr invnbr1 part part1 ltser ltser1"
          &frm = "a"}

 if (c-application-mode <> 'web') or
         (c-application-mode = 'web' and
         (c-web-request begins 'data')) then do:

        if invnbr1 = "" then invnbr1 = hi_char.
        if part1 = "" then part1 = hi_char.
        if ltser1 = "" then ltser1 = hi_char.
        if shpdt = ? then shpdt = low_date.
        if shpdt1 = ? then shpdt1 = hi_date.

 end.

   /* OUTPUT DESTINATION SELECTION */
   {gpselout.i &printType = "printer"
               &printWidth = 172
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
  /*  {mfphead.i} */
   for each xxbi exclusive-lock: delete xxbi. end.
   for each ih_hist fields(ih_domain ih_inv_nbr ih_ship_date) no-lock
      where ih_domain = global_domain
        and ih_inv_nbr >= invnbr and ih_inv_nbr <= invnbr1
        and ih_ship_date >= shpdt and ih_ship_date <= shpdt1,
       each idh_hist
        fields(idh_domain  idh_nbr idh_inv_nbr idh_contr_id idh_line
               idh_qty_ship idh_um idh_serial idh_part idh_custpart)
               no-lock
    where idh_domain = global_domain
         and idh_inv_nbr = ih_inv_nbr
         and idh_part >= part and idh_part<= part1
         and idh_serial >= ltser and idh_serial <= ltser1
     with frame b width 172 no-attr-space:
                /* SET EXTERNAL LABELS */
                /* setFrameLabels(frame b:handle). */
         /*       {mfrpchk.i}         G348*/
     assign dte = ? issdte = ? lot = "".

     find first tr_hist no-lock use-index tr_part_eff
          where tr_domain = global_domain
            and tr_part = idh_part
            and tr_nbr = idh_nbr
            and tr_line = idh_line
          /* and tr_rmks = idh_inv_nbr  */
            AND (
              /*
              (tr_type = "ISS-SO"
               and not(can-find(first cncu_mstr
               where cncu_mstr.cncu_domain = global_domain
                 and cncu_trnbr = tr_trnbr)))
               */
               tr_type = "ISS-SO"
               OR tr_type = "CN-SHIP"
               OR tr_type = "RCT-SOR")
               and tr_serial <> ""
         /* and tr_effdate = ih_ship_date */
            no-error.
     if available tr_hist then do:
        assign lot = tr_serial.
     end.
/**********************
     find first ld_det no-lock use-index ld_part_lot
          where ld_domain = global_domain and ld_part = idh_part
            and ld_lot = lot no-error.
     if available ld_det then do:
        assign dte = ld_date.
     end.
     for each tr_hist fields(tr_domain tr_type tr_part tr_serial tr_effdate)
              no-lock use-index tr_type
          where tr_domai = global_domain
            and tr_type = "rct-wo"
            and tr_part = idh_part
            and tr_serial = lot:
        assign dte = tr_effdate.
     end.
***********************/
     find last tr_hist no-lock use-index tr_serial 
         where tr_domain = global_domain
           and tr_serial = lot and tr_part = idh_part
           and tr_loc = "201"  /* 201是包装二级库也就是产品的包装时间 */
           and (tr_type = "rct-wo" or tr_type = "rct-tr") no-error.
     if available tr_hist then do:
        assign dte = tr_effdate.
     end.
     /*************
     find first cncu_mstr no-lock where cncu_domain = global_domain
            and cncu_invoice = idh_inv_nbr and cncu_sod_line = idh_line no-error.
     if available cncu_mstr then do:
        find first tr_hist no-lock where tr_domain = global_domain and tr_trnbr = cncu_tr_nbr no-error.
     end.
     **************/
     /*
     display ih_ship_date column-label "Goods issue date"
             idh_nbr idh_inv_nbr idh_contr_id idh_line
             idh_qty_ship idh_um lot dte
             idh_part idh_custpart format "x(30)".
             {mfrpchk.i}
     */
     create xxbi.
     assign /* bi_nbr = idh_nbr  */
            bi_inv_nbr = idh_inv_nbr
            bi_sopo = idh_contr_id
            bi_line = idh_line
            bi_qyt_ship = idh_qty_ship
            bi_um = idh_um
            bi_serial = lot
            bi_part = idh_part
            bi_custpart = idh_custpart.
     if ih_ship_date <> ? then
     assign bi_shipdate = string(year(ih_ship_date),"9999")
                        + "-" + string(month(ih_ship_date),"99")
                        + "-" + string(day(ih_ship_date),"99").
     else assign bi_shipdate = "".
     if dte <> ? then
     assign bi_prod_dte = string(year(dte),"9999")
                        + "-" + string(month(dte),"99")
                        + "-" + string(day(dte),"99").
     else assign bi_prod_dte = "".
   end.
   PUT UNFORMATTED "#def REPORTPATH=$/PORITE/" + SUBSTRING(execname,1,LENGTH(execname) - 2) SKIP.
   PUT UNFORMATTED "#def :end" SKIP.

   FOR EACH xxbi no-lock break by bi_shipdate:
       EXPORT DELIMITER ";" xxbi.
   END.
 /*      {mfrtrail.i}*/
   {mfreset.i}

end.

 {wbrp04.i &frame-spec = a}
