/* GUI CONVERTED from sopccala.p (converter v1.69) Thu Aug 22 14:40:39 1996 */
/* sopccala.p  - CALCULATE PRICES AND COSTS FOR CONFIGURED SALES ORDER  */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/*F0PN*/ /*V8:ConvertMode=Maintenance                                   */
/* REVISION: 6.0      LAST MODIFIED: 01/15/91   BY: afs *D308**/
/* REVISION: 6.0      LAST MODIFIED: 03/04/91   BY: afs *D396**/
/* REVISION: 6.0      LAST MODIFIED: 04/16/91   BY: afs *D533**/
/* REVISION: 6.0      LAST MODIFIED: 10/01/91   BY: afs *D884**/
/* REVISION: 7.0      LAST MODIFIED: 10/30/91   BY: pma *F003**/
/* REVISION: 7.0      LAST MODIFIED: 04/09/92   BY: emb *F369**/
/* REVISION: 7.0      LAST MODIFIED: 04/15/92   BY: dld *F382**/
/* REVISION: 7.0      LAST MODIFIED: 08/17/92   BY: tjs *F835**/
/* REVISION: 7.3      LAST MODIFIED: 09/11/92   BY: tjs *G035**/
/* REVISION: 7.3      LAST MODIFIED: 10/28/92   BY: afs *G244**/
/* REVISION: 7.3      LAST MODIFIED: 11/05/92   BY: tjs *G191**/
/* REVISION: 7.3      LAST MODIFIED: 12/08/92   BY: tjs *G391**/
/* REVISION: 7.3      LAST MODIFIED: 01/08/93   BY: tjs *G522**/
/* REVISION: 7.3      LAST MODIFIED: 06/11/93   BY: tjs *GA40**/
/* REVISION: 7.3      LAST MODIFIED: 07/28/93   BY: tjs *GD80**/
/* REVISION: 7.4      LAST MODIFIED: 10/14/93   BY: cdt *H086**/
/* REVISION: 7.4      LAST MODIFIED: 10/19/93   BY: cdt *H184**/
/* REVISION: 7.4      LAST MODIFIED: 06/22/94   BY: WUG *GK60**/
/* REVISION: 7.4      LAST MODIFIED: 09/09/94   BY: afs *H510**/
/* REVISION: 8.5      LAST MODIFIED: 03/09/95   BY: DAH *J042**/
/* REVISION: 7.4      LAST MODIFIED: 08/25/95   BY: jym *G0TW**/
/* REVISION: 7.4      LAST MODIFIED: 12/07/95   BY: rxm *H0FS**/
/* REVISION: 8.5      LAST MODIFIED: 02/26/96   BY: rxm *G1P1**/
/* REVISION: 8.5      LAST MODIFIED: 04/02/96   BY: DAH *J0GT**/
/* REVISION: 8.5      LAST MODIFIED: 04/15/96   BY: DAH *J0HR**/
/* REVISION: 8.5      LAST MODIFIED: 05/22/96   BY: DAH *J0N2**/
/* REVISION: 8.5      LAST MODIFIED: 06/25/96   BY: tzp *G1X1**/
/* REVISION: 8.5      LAST MODIFIED: 07/05/96   BY: DAH *J0XR**/
/* REVISION: 8.5      LAST MODIFIED: 07/15/96   BY: ajw *J0Z6**/
/* REVISION: 8.5      LAST MODIFIED: 08/21/96   BY: tzp *F0X9**/
/* REVISION: 8.5      LAST MODIFIED: 11/14/03   BY: *LB01* Long Bo         */


/*GA40*/ /* Removed all other patch stamps to make code more readable. */

	 {mfdeclre.i}

	 define shared variable sod_recno as recid.
	 define shared variable so_recno as recid.
	 define variable pcqty like sod_qty_ord.
	 define variable listpr like sod_list_pr.
	 define variable price like sod_price.
/*GA40*/ define variable trunc_price like sob_tot_std.
	 define variable i as integer.
	 define variable qtyord like sod_qty_ord.
	 define variable dup-part like mfc_logical.
/*GD80*/ define variable pm_code like pt_pm_code.
	 define buffer sobdet for sob_det.
/*H086*/ define variable minprice              like pc_min_price.
/*H086*/ define variable maxprice              like pc_min_price.
/*H086*/ define variable dumcost               like pc_min_price.
/*H086*/ define variable dumpct                like pc_min_price.
/*H086*/ define variable warning               like mfc_logical initial yes.
/*H086*/ define variable warmess               like mfc_logical initial no.
/*H086*/ define variable minmaxerr             like mfc_logical.
/*H086*/ define variable newprice              like mfc_logical initial yes.
/*H086*/ define shared variable lineffdate     like so_due_date.
/*H086*/ define shared variable match_pt_um    like mfc_logical.
/*H510*/ define        variable pc_recno       as recid.
/*J042*/ define shared variable line_pricing   like mfc_logical.
/*J042*/ define shared variable reprice_dtl    like mfc_logical.
/*J042*/ define shared variable pics_type      like pi_cs_type.
/*J042*/ define shared variable part_type      like pi_part_type.
/*J042*/ define shared variable picust         like cm_addr.
/*J042*/ define        variable err_flag       as integer.
/*J042*/ define        variable update_parent_list like mfc_logical.
/*J042*/ define shared variable rfact          as integer.
/*J0N2*/ define        variable disc_min_max   like mfc_logical.
/*J0N2*/ define        variable disc_pct_err   as decimal
/*J0N2*/                        format "->>>>,>>>,>>9.9<<<".
/*J0N2*/ define        variable discount       as decimal.
/*J0N2*/ define        variable sobdiscpct     as decimal.
/*J0N2*/ define        variable man_disc_pct   as decimal.
/*J0N2*/ define        variable sys_disc_fact  as decimal.
/*J0N2*/ define        variable save_disc_pct  as decimal.
/*J0N2*/ define        variable last_sob_price like sob_price.
/*G1X1*/ define variable phantom like pt_phantom no-undo.

/*J042*/ define input parameter update_accum_qty like mfc_logical.
/*J12Q*/ define input parameter pause_if_error like mfc_logical.

/*J042*/ {pppivar.i }  /*SHARED PRICING VARIABLES*/
/*J042*/ {pppiwqty.i } /*SHARED ACCUM QTY WORKFILES*/
/*J042*/ {pppiwkpi.i } /*SHARED PRICING WORKFILE*/
/*F0X9*/ define variable scrp_pct like ps_scrp_pct no-undo.

	 find sod_det where recid(sod_det) = sod_recno.
	 find so_mstr where recid(so_mstr) = so_recno no-lock.
/*J0N2*/ find first pic_ctrl no-lock.

/*J042*/ /*DETERMINE IF PARENT HAS A MANUALLY ENTERED LIST PRICE,
**J042**   IF SO, COMPONENT LISTS WILL NOT ROLL UP INTO sod_list_pr*/
/*J042*/ find first wkpi_wkfl where wkpi_parent   = ""  and
/*J042*/                            wkpi_feature  = ""  and
/*J042*/                            wkpi_option   = ""  and
/*J042*/                            wkpi_amt_type = "1" and
/*J042*/                            wkpi_source   = "1"
/*J042*/                      no-lock no-error.
/*J042*/ if not available wkpi_wkfl then
/*J042*/    update_parent_list = yes.
/*J042*/ else
/*J042*/    update_parent_list = no.

/*GA40*/ if sod_qty_ord <> 0 then qtyord = sod_qty_ord.
			     else qtyord = 1.

/*GA40*/ /* Each sob_det adds to the sod_det cost */
	 for each sob_det where sob_nbr = sod_nbr and sob_line = sod_line
	 break by sob_part:
/*GUI*/ if global-beam-me-up then undo, leave.

/*GA40*/    if first-of (sob_part) then
	    find pt_mstr no-lock where pt_part = sob_part no-error.
/*G1X1* /*GD80*/    if available pt_mstr then pm_code = pt_pm_code. */
/*G1X1*/    if available pt_mstr then assign pm_code = pt_pm_code
					     phantom = pt_phantom.
/*GD80*/    else pm_code = "".
/*GD80*/    find ptp_det where ptp_part = sob_part and
/*GD80*/    ptp_site = sob_site no-lock no-error.
/*G1X1* /*GD80*/    if available ptp_det then pm_code = ptp_pm_code. */
/*G1X1*/    if available ptp_det then assign pm_code = ptp_pm_code
					     phantom = ptp_phantom.
/*GD80*     if pt_pm_code <> "C" then do: */
/*G1X1*/    if phantom = no then do:
/*GD80*/       if pm_code <> "C" then do:
		  {gpsct05.i &part=sob_part &site=sod_site &cost=sct_cst_tot}
	       end.
	       else do: /* This level cost on config parents */
		  {gpsct05.i &part=sob_part &site=sod_site &cost=
	       "sct_bdn_tl + sct_lbr_tl + sct_mtl_tl + sct_ovh_tl + sct_sub_tl"}
	       end.
/*G1X1*/    end.
	    /* Global Phantom this level cost not rolled up */
/*G1X1*/    else do:
/*G1X1*/      {gpsct05.i &part=sob_part &site=sod_site &cost="sct_bdn_ll
/*G1X1*/       + sct_lbr_ll + sct_mtl_ll + sct_ovh_ll + sct_sub_ll"}
/*G1X1*/    end.
/*H086*/    /*  sod_std_cost = sod_std_cost + glxcst * sob_qty_req / qtyord. */
/*G1P1*/    if (substring(sob_feature,13,1) = "O"
/*G1P1*/    or substring(sob_serial,15,1) = "O") then
/*F0X9* /*H086*/ sod_std_cost = sod_std_cost + glxcst * sob_qty_req / qtyord  */
/*F0X9*/    assign scrp_pct = decimal (substring (sob_serial,5,6))
/*F0X9*/           sod_std_cost = sod_std_cost + (glxcst * sob_qty_req / qtyord
/*F0X9*/             * (if scrp_pct < 100 then (100 / (100 - scrp_pct)) else 0))
/*H086*/                                * sod_um_conv.

/*J042*/   /*PROCESS COMPONENT PRICING SAME AS PARENT, ONLY THOSE
**J042*      CONFIGURED AS OPTIONAL ARE PRICED AND ADDED TO sod_det
**J042*      PRICE FIELDS*/

/*J042*/    if substring(sob_feature,13,1) = "o" or
/*J042*/       substring(sob_serial,15,1)  = "o" then do:

/*J042*/       if line_pricing or reprice_dtl then do:

/*J0N2*/          last_sob_price  = sob_price.
/*J042*/          best_list_price = 0.
/*J042*/          best_net_price  = 0.

/*J042*/          /*GET BEST LIST TYPE PRICE LIST*/
/*J0XR*/          /*Added sod_site, so_ex_rate to parameters*/
		  {gprun.i ""gppibx.p"" "(pics_type,
					  picust,
					  part_type,
					  sob_part,
					  sob_parent,
					  sob_feature,
					  sob_part,
					  1,
					  so_curr,
					  sod_um,
					  sod_pricing_dt,
					  no,
					  sod_site,
					  so_ex_rate,
					  output err_flag)"}
/*GUI*/ if global-beam-me-up then undo, leave.


/*J042*/          if best_list_price = 0 then do:
/*J042*/             find first wkpi_wkfl where wkpi_parent   = sob_parent  and
/*J042*/                                        wkpi_feature  = sob_feature and
/*J042*/                                        wkpi_option   = sob_part    and
/*J042*/                                        wkpi_amt_type = "1"
/*J042*/                                  no-lock no-error.
/*J042*/             if not available wkpi_wkfl then do:
/*J0GT*/                if available pt_mstr then do:
/*J0GT*/                   best_list_price = pt_price * so_ex_rate
/*J0XR*/                                              * sod_um_conv.
/*J042*/                   /*Create list type price list record in wkpi_wkfl*/
/*LB01*/	   {gprun.i ""zzgppiwkad.p"" "(sod_um,
						     sob_parent,
						     sob_feature,
						     sob_part,
						     ""4"",
						     ""1"",
						     best_list_price,
						     0,
						     no)"}
/*GUI*/ if global-beam-me-up then undo, leave.

/*J0GT*/                end.
/*J0GT*/                else do:
/*J0GT*/                   /*Create list type price list record in wkpi_wkfl
/*J0GT*/                     for memo type*/
/*J0GT*/                   best_list_price = sob_tot_std.
/*LB01*/	   {gprun.i ""zzgppiwkad.p"" "(sod_um,
						     sob_parent,
						     sob_feature,
						     sob_part,
						     ""7"",
						     ""1"",
						     best_list_price,
						     0,
						     no)"}
/*GUI*/ if global-beam-me-up then undo, leave.

/*J0GT*/                end.
/*J042*/             end.
/*J0GT** /*J042*/    best_list_price = sob_tot_std. */
/*J0GT*/             else
/*J0GT*/                best_list_price = wkpi_amt.
/*J042*/          end.

/*J042*/          sob_tot_std = best_list_price.
/*J042*/          sob_price   = best_list_price.

/*J042*/          /*CALCULATE TERMS INTEREST*/
/*J042*/          if sod_crt_int <> 0 then do:
/*J042*/             sob_tot_std     = (100 + sod_crt_int) / 100 * sob_tot_std.
/*J042*/             sob_price       = sob_tot_std.
/*J042*/             best_list_price = sob_tot_std.
/*J042*/             /*Create credit terms interest wkpi_wkfl record*/
/*LB01*/     {gprun.i ""zzgppiwkad.p"" "(sod_um,
					       sob_parent,
					       sob_feature,
					       sob_part,
					       ""5"",
					       ""1"",
					       sob_tot_std,
					       0,
					       no)"}
/*GUI*/ if global-beam-me-up then undo, leave.

/*J042*/          end.

/*J042*/       end. /*line_pricing or reprice_dtl*/

/*J042*/       /*UPDATE ACCUM QTY WORKFILES*/
/*J0XR*/       /*Qualified the qty (sob_qty_req) and extended list   */
/*J0XR*/       /*(sob_qty_req * sob_tot_std) parameters to divide by */
/*J0XR*/       /*u/m conversion ratio since these include this factor*/
/*J0XR*/       /*already.                                            */
/*J042*/       if update_accum_qty then do:
/*LB01*/  {gprun.i ""zzgppiqty2.p"" "(sod_line,
					    sob_part,
					    sob_qty_req / sod_um_conv,
					    sob_qty_req * sob_tot_std
							/ sod_um_conv,
					    sod_um,
					    no,
/*J0Z6*/                                    yes,
					    yes)"}
/*GUI*/ if global-beam-me-up then undo, leave.

/*J042*/       end.

/*J0HR** /*J042*/       if line_pricing or reprice_dtl then do: */
/*J0HR*/       if sob_tot_std <> 0 and (line_pricing or reprice_dtl) then do:

/*J0GT*/          /*FIND THE ITEM COST BEFORE CALLING gppibx.p FOR DISCOUNTS*/

/*J0XR**          *Now performed in gppibx03.p*
** /*J0GT*/       {gpsct05.i &part=sob_part &site=sod_site &cost=sct_cst_tot}
**J0XR*/

/*J042*/          /*GET BEST DISCOUNTS*/
/*J0XR** /*J042*/ item_cost = glxcst. */
/*J0XR*/          /*Added sod_site, so_ex_rate to parameters*/
		  {gprun.i ""gppibx.p"" "(pics_type,
					  picust,
					  part_type,
					  sob_part,
					  sob_parent,
					  sob_feature,
					  sob_part,
					  2,
					  so_curr,
					  sod_um,
					  sod_pricing_dt,
					  no,
					  sod_site,
					  so_ex_rate,
					  output err_flag)"}
/*GUI*/ if global-beam-me-up then undo, leave.


/*J042*/          /*CALCULATE BEST PRICE*/
/*LB01*/  {gprun.i ""zzgppibx04.p"" "(sob_parent,
					    sob_feature,
					    sob_part,
					    no,
					    rfact)"}
/*GUI*/ if global-beam-me-up then undo, leave.

/*J042*/          sob_price = best_net_price.

/*J0N2*/    /* JUST IN CASE SYSTEM DISCOUNTS CHANGED SINCE THE LAST PRICING  */
/*J0N2*/    /* AND THE USER MANUALLY ENTERED THE PRICE (OR DISCOUNT), RETAIN */
/*J0N2*/    /* THE PREVIOUS NET PRICE (THAT'S WHAT THE USER WANTS) AND REVISE*/
/*J0N2*/    /* THE MANUAL DISCOUNT ADJUSTMENT TO COMPENSATE.                 */

/*J0N2*/          sobdiscpct = (1 - (sob_price / sob_tot_std)) * 100.

/*J0N2*/          find first wkpi_wkfl where wkpi_parent   = sob_parent  and
/*J0N2*/                                     wkpi_feature  = sob_feature and
/*J0N2*/                                     wkpi_option   = sob_part    and
/*J0N2*/                                     wkpi_amt_type = "2"         and
/*J0N2*/                                     wkpi_source   = "1"
/*J0N2*/                               no-lock no-error.

/*J0N2*/          if available wkpi_wkfl
/*J0N2*/          then do:
/*J0N2*/             save_disc_pct = sobdiscpct.
/*J0N2*/             sob_price     = last_sob_price.
/*J0N2*/             if sob_tot_std <> 0 then
/*J0N2*/                sobdiscpct = (1 - (sob_price / sob_tot_std)) * 100.
/*J0N2*/             else
/*J0N2*/                sobdiscpct = 0.

/*J0N2*/             if pic_disc_comb = "1" then do:      /*cascading discount*/
/*J0N2*/                if available wkpi_wkfl then
/*J0N2*/                   sys_disc_fact = if not found_100_disc then
/*J0N2*/                                      ((100 - save_disc_pct) / 100) /
/*J0N2*/                                      ((100 - wkpi_amt)      / 100)
/*J0N2*/                                   else
/*J0N2*/                                      0.
/*J0N2*/                else
/*J0N2*/                   sys_disc_fact =  (100 - save_disc_pct) / 100.
/*J0N2*/                if sys_disc_fact = 1 then
/*J0N2*/                   man_disc_pct  = sobdiscpct.
/*J0N2*/                else do:
/*J0N2*/                   if sys_disc_fact <> 0 then do:
/*J0N2*/                      discount      = (100 - sobdiscpct) / 100.
/*J0N2*/                      man_disc_pct  = (1 - (discount / sys_disc_fact))
/*J0N2*/                                      * 100.
/*J0N2*/                   end.
/*J0N2*/                   else
/*J0N2*/                      man_disc_pct  = sobdiscpct - 100.
/*J0N2*/                end.
/*J0N2*/             end.
/*J0N2*/             else do:
/*J0N2*/                if available wkpi_wkfl then
/*J0N2*/                   man_disc_pct = sobdiscpct -
/*J0N2*/                                  (save_disc_pct - wkpi_amt).
/*J0N2*/                else
/*J0N2*/                   man_disc_pct = sobdiscpct - save_disc_pct.
/*J0N2*/             end.

/*LB01**J0N2*/       {gprun.i ""zzgppiwkad.p"" "(sod_um,
					       sob_parent,
					       sob_feature,
					       sob_part,
					       ""1"",
					       ""2"",
					       0,
					       man_disc_pct,
					       no)"}
/*GUI*/ if global-beam-me-up then undo, leave.


/*J0N2*/          end. /* last_sob_price <> sob_price */

/*J0N2*/          /*TEST FOR DISCOUNT RANGE VIOLATION.  IF FOUND, CREATE    */
/*J0N2*/          /*MANUAL DISCOUNT TO RECONCILE THE DIFFERENCE BETWEEN THE */
/*J0N2*/          /*SYSTEM DISCOUNT AND THE MIN OR MAX ALLOWABLE DISCOUNT,  */
/*J0N2*/          /*DEPENDING ON THE VIOLATION.                             */

/*J0N2*/          sobdiscpct   = (1 - (sob_price / sob_tot_std)) * 100.
/*J0N2*/          disc_min_max = no.
/*J0N2*/          {gppidisc.i pic_so_fact sobdiscpct pic_so_rfact}
/*J0N2*/          if disc_min_max then do: /*found a discount range violation*/
/*J0N2*/             {mfmsg03.i 6934 2 sob_part disc_pct_err """"}
/*J0N2*/             if not batchrun then
/*J0N2*/                pause.
/*J0N2*/             sobdiscpct      = if pic_so_fact then
/*J0N2*/                                  (1 - discount) * 100
/*J0N2*/                               else
/*J0N2*/                                  discount.
/*J0N2*/             find first wkpi_wkfl where wkpi_parent   = sob_parent  and
/*J0N2*/                                        wkpi_feature  = sob_feature and
/*J0N2*/                                        wkpi_option   = sob_part    and
/*J0N2*/                                        wkpi_amt_type = "2"         and
/*J0N2*/                                        wkpi_source   = "1"
/*J0N2*/                                  no-lock no-error.

/*J0N2*/             if pic_disc_comb = "1" then do:     /*cascading discount*/
/*J0N2*/                if available wkpi_wkfl then
/*J0N2*/                   sys_disc_fact = ((100 - disc_pct_err) / 100) /
/*J0N2*/                                   ((100 - wkpi_amt)      / 100).
/*J0N2*/                else
/*J0N2*/                   sys_disc_fact =  (100 - disc_pct_err) / 100.
/*J0N2*/                if sys_disc_fact = 1 then
/*J0N2*/                   man_disc_pct  = sobdiscpct.
/*J0N2*/                else do:
/*J0N2*/                   if sys_disc_fact <> 0 then do:
/*J0N2*/                      discount      = (100 - sobdiscpct) / 100.
/*J0N2*/                      man_disc_pct  = (1 - (discount / sys_disc_fact))
/*J0N2*/                                      * 100.
/*J0N2*/                   end.
/*J0N2*/                   else
/*J0N2*/                      man_disc_pct  = sobdiscpct - 100.
/*J0N2*/                end.
/*J0N2*/             end.
/*J0N2*/             else do:                            /*additive discount*/
/*J0N2*/                if available wkpi_wkfl then
/*J0N2*/                   man_disc_pct = sobdiscpct -
/*J0N2*/                                  (disc_pct_err - wkpi_amt).
/*J0N2*/                else
/*J0N2*/                   man_disc_pct = sobdiscpct - disc_pct_err.
/*J0N2*/             end.

/*LB01**J0N2*/             {gprun.i ""zzgppiwkad.p"" "(
					       sod_um,
					       sob_parent,
					       sob_feature,
					       sob_part,
					       ""1"",
					       ""2"",
					       0,
					       man_disc_pct,
					       no
					      )"}
/*GUI*/ if global-beam-me-up then undo, leave.



/*J0N2*/             sob_price = sob_tot_std * (1 - (sobdiscpct / 100)).

/*J0N2*/          end.    /* if disc_min_max */

/*J042*/          /*UPDATE sod_list_pr AND sod_price, TEST TO SEE IF PARENT
**J042**            HAS MANUALLY ENTERED LIST PRICE, IF SO, DO NOT ACCUMULATE
**J042**            sod_list_pr*/

/*J042*/          if update_parent_list then
/*J042*/             sod_list_pr = sod_list_pr + (sob_tot_std *
/*J042*/                                          sob_qty_req / qtyord
/*J0XR*/                                                      / sod_um_conv).
/*J042*/          sod_price = sod_price + (sob_price *
/*J042*/                                   sob_qty_req / qtyord
/*J0XR*/                                               / sod_um_conv).

/*J042*/       end. /*line_pricing or reprice_dtl*/

/*J042*/    end. /*sob_feature or sob_serial*/

	 end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /*for each sob_det*/

/*J042*******************************************************************
**J042*  PRICING NOW OCCURS IN FIRST sob_det LOOP SINCE CALL TO qppiqty2.p
**       WILL MAINTAIN ACCUMULATED QTY'S
**
**       /* EACH OPTIONAL sob_det MANUALLY UPDATED ADDS TO THE sod_det PRICE */
** /*H0FS*/ for each sob_det where sob_nbr = sod_nbr and sob_line = sod_line
** /*H0FS*/ and (substring(sob_feature,13,1) = "O"
** /*H0FS*/ or substring(sob_serial,15,1) = "O")
** /*H0FS*/ and substring(sob_serial,40,1) = "y"
** /*H0FS*/ break by sob_part:
**       /* MANUAL PRICES ARE ASSUMED TO INCLUDE CREDIT TERMS INTEREST, IF
**          APPLICABLE.  THEREFORE NO FURTHER ADJUSTMENT IS DONE HERE. */
** /*H0FS*/    assign
** /*H0FS*/       sod_list_pr = sod_list_pr + sob_tot_std * sob_qty_req / qtyord
** /*H0FS*/       sod_price   = sod_price   + sob_price  * sob_qty_req / qtyord.
** /*H0FS*/ end.
**
** /*GA40*/ /* Each Optional sob_det adds to the sod_det price */
**       for each sob_det where sob_nbr = sod_nbr and sob_line = sod_line
**       and
**       (substring(sob_feature,13,1) = "O"
** /*GK60*/ or substr(sob_serial,15,1) = "O")
** /*H0FS*/ and substring(sob_serial,40,1) <> "y"
**       break by sob_part:
**          if first-of (sob_part) then do:
**             find pt_mstr no-lock where pt_part = sob_part no-error.
**             pcqty = 0.
**             dup-part = no.
**          end.
**
**          /* Pricing done on added sob or sob from optional ps */
** /*GA40*     if substring(sob_feature,13,1) = "O" then do:    */
** /*GA40*        if sob_price = so_ex_rate * pt_price then do: */
** /*H086*/       /* trunc_price = so_ex_rate * pt_price.   */
** /*H086*/       trunc_price = so_ex_rate * pt_price * sod_um_conv.
** /*H0FS /*GA40*/  if sob_price = trunc_price then do: */
**             /* Sum qty for price list look-up if price not chgd by user */
** /*H0FS*/    if substring(sob_serial,40,1) <> "y" then do:
**                /* Sum qty for price list look-up if price not chgd by user */
**                pcqty = pcqty + sob_qty_req.
**                if not first-of (sob_part) then dup-part = yes.
**             end.
**             else do:
**                /* Add price to sod_det if <> pt_price (user entered price) */
**                /* sob_tot_std is list price */
**                sod_list_pr =
**                sod_list_pr + sob_tot_std * sob_qty_req / qtyord.
**                sod_price = sod_price + sob_price * sob_qty_req / qtyord.
**             end.
** /*GA40*     end. */
**
**          if last-of (sob_part) and pcqty <> 0 then do:
**
** /*H086*/       /* listpr = pt_price * so_ex_rate. */
** /*H086*/       listpr = pt_price * so_ex_rate * sod_um_conv.
**             price = listpr.
**
** /*H086*/       /* PRICE TABLE LIST PRICE LOOK-UP */
** /*H510*/       /* Added parameters for price table required, recid */
** /*H086*/       if so_pr_list2 <> "" then do:
** /*H086*/          {gprun.i ""gppclst.p""
**                         "(input        so_pr_list2,
**                           input        sob_part,
**                           input        pt_um,
**                           input        sod_um_conv,
**                           input        lineffdate,
**                           input        so_curr,
**                           input        newprice,
**                           input        false,
**                           input-output listpr,
**                           input-output price,
**                           output       minprice,
**                           output       maxprice,
**                           output       pc_recno
**                          )" }
** /*H086*/       end.
**
** /*H184*/       /* CALC TERMS INTEREST */
** /*H184*/       if sod_crt_int <> 0 then do:
** /*H184*/          assign
** /*H184*/             listpr  = (100 + sod_crt_int) / 100 * listpr
** /*H184*/             price   = (100 + sod_crt_int) / 100 * price.
** /*H184*/       end.
**
** /*H086*/       /* DISCOUNT TABLE LOOK-UP */
** /*H086*/       if so_pr_list <> "" then do:
** /*H0FS*/          if pm_code <> "C" then do:
** /*H0FS*/          {gpsct05.i &part=sob_part &site=sod_site &cost=sct_cst_tot}
** /*H0FS*/          end.
** /*H0FS*/          else do: /* This level cost on config parents */
** /*H0FS*/             {gpsct05.i &part=sob_part &site=sod_site &cost=
**             "sct_bdn_tl + sct_lbr_tl + sct_mtl_tl + sct_ovh_tl + sct_sub_tl"}
** /*H0FS*/          end.
**
** /*H0FS*/          dumcost = glxcst.

** /*H510*/          /* Added pc_recno to gppccal call below */
** /*G0TW*/          /* Added supplier discount percent as input 10 */
** /*H086*/          {gprun.i ""gppccal.p""
**                         "(input        sob_part,
**                           input        pcqty,
**                           input        pt_um,
**                           input        sod_um_conv,
**                           input        so_curr,
**                           input        so_pr_list,
**                           input        lineffdate,
**                           input        dumcost,
**                           input        match_pt_um,
**                           input        0,
**                           input-output listpr,
**                           output       dumpct,
**                           input-output price,
**                           output       pc_recno
**                          )" }
** /*H086*/       end.
**
** /*H0FS*/       if listpr = 0 then
** /*H0FS*/          listpr = price.
** /*H086*/
** /*H086*/       /* PRICE TABLE MIN/MAX WARNING FOR DISC TABLES. PLUG PRICES */
** /*H086*/       if so_pr_list2 <> "" then do:
** /*H086*/          assign
** /*H086*/             warmess = no
** /*H086*/             warning = yes.
** /*H0FS*/          /* ADDED sob_part & REMOVED sod_um_conv PARAMETERS BELOW */
** /*H086*/          {gprun.i ""gpmnmx.p""
**                         "(input        warning,
**                           input        warmess,
**                           input        minprice,
**                           input        maxprice,
**                           output       minmaxerr,
**                           input-output listpr,
**                           input-output price,
**                           input        sob_part
**                          )" }
** /*H086*/       end.
**
**             /* STORE THE PRICE TABLE PRICE IN THE COMPONENT DETAIL */
** /*GA40*/       sob_tot_std = listpr.
**             sob_price = price.
**
** /*GA40*        if sod_qty_ord <> 0 then qtyord = sod_qty_ord. */
** /*GA40*                            else qtyord = 1.           */
**
**             sod_list_pr = sod_list_pr + listpr * pcqty / qtyord.
**             sod_price   = sod_price   + price  * pcqty / qtyord.
**
**             if dup-part then do:
** /*H086*/          /* trunc_price = so_ex_rate * pt_price. */
** /*H086*/          trunc_price = so_ex_rate * pt_price * sod_um_conv.
**                /* Update net price in other sob w/ same part */
**                for each sobdet where sobdet.sob_nbr = sod_nbr
**                                 and sobdet.sob_line = sod_line
**                                 and sobdet.sob_part = pt_part
** /*GA40*                           and sobdet.sob_price = pt_price */
** /*H0FS /*GA40*/                   and sobdet.sob_price = trunc_price */
** /*GK60            and substring(sobdet.sob_feature,13,1) <> "": */
** /*GK60*/          and
** /*GK60*/          (substring(sobdet.sob_feature,13,1) = "O"
** /*GK60*/          or substr(sobdet.sob_serial,15,1) = "O"):
** /*H0FS*/          /* DO NOT ADJUST PRICE IF PRICE HAS BEEN MANUALLY SET */
** /*H0FS*/          and substring(sobdet.sob_serial,40,1) <> "y":
** /*H0FS*/             assign
** /*H0FS*/                sobdet.sob_tot_std = listpr
**                         sobdet.sob_price = price.
**                end.
**             end. /* dup part */
**          end. /* if last-of sob_part */
**       end. /* for each sob_det */
**************************************************************J042*/
