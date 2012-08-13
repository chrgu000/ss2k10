/* GUI CONVERTED from sopccala.p (converter v1.78) Fri Oct 29 14:34:10 2004 */
/* sopccala.p  - CALCULATE PRICES AND COSTS FOR CONFIGURED SALES ORDER  */
/* Copyright 1986-2003 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/* $Revision: 1.33.3.1 $                                                    */
/*V8:ConvertMode=Maintenance                                            */
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
/* REVISION: 8.6      LAST MODIFIED: 10/23/97   BY: jxz *K15N**/
/* REVISION: 8.6E     LAST MODIFIED: 04/20/98   BY: *J2HJ* Niranjan R.    */
/* REVISION: 8.6E     LAST MODIFIED: 05/09/98   BY: *L00Y* Jeff Wootton   */
/* REVISION: 8.6E     LAST MODIFIED: 06/01/98   BY: *J2JJ* Niranjan R.    */
/* Old ECO marker removed, but no ECO header exists *J12Q*                */
/* REVISION: 8.6E     LAST MODIFIED: 07/03/98   BY: *L024* Sami Kureishy  */
/* REVISION: 9.0      LAST MODIFIED: 11/24/98   BY: *M017* Luke Pokic     */
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan     */
/* REVISION: 9.0      LAST MODIFIED: 06/09/99   BY: *J3GV* Poonam Bahl    */
/* REVISION: 9.1      LAST MODIFIED: 04/25/00   BY: *N0CF* Santosh Rao    */
/* REVISION: 9.1      LAST MODIFIED: 08/12/00   BY: *N0KN* myb            */
/* Old ECO marker removed, but no ECO header exists *F0PN*                */
/* Revision: 1.30    BY: Rajiv Ramaiah      DATE: 01/04/02  ECO: *M1SX*   */
/* Revision: 1.31    BY: Ashish Maheshwari  DATE: 07/04/02  ECO: *N1N9*   */
/* Revision: 1.32    BY: A.R. Jayaram       DATE: 12/27/02  ECO: *N232*   */
/* Revision: 1.33    BY: Hareesh V.         DATE: 02/06/03  ECO: *M228*   */
/* $Revision: 1.33.3.1 $   BY: Deepak Rao         DATE: 07/23/03  ECO: *P0Y6*   */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

{mfdeclre.i}

/* ADDED NO-UNDO TO VARIABLE DEFINITIONS BELOW */
define shared variable sod_recno as recid.
define shared variable so_recno as recid.
define variable pcqty                 like sod_qty_ord  no-undo.
define variable listpr                like sod_list_pr  no-undo.
define variable price                 like sod_price    no-undo.
define variable trunc_price           like sob_tot_std  no-undo.
define variable i                     as   integer      no-undo.
define variable qtyord                like sod_qty_ord  no-undo.
define variable dup-part              like mfc_logical  no-undo.
define buffer sobdet for sob_det.
define variable minprice              like pc_min_price no-undo.
define variable maxprice              like pc_min_price no-undo.
define variable dumcost               like pc_min_price no-undo.
define variable dumpct                like pc_min_price no-undo.
define variable warning               like mfc_logical initial yes
   no-undo.
define variable warmess               like mfc_logical initial no
   no-undo.
define variable minmaxerr             like mfc_logical no-undo.
define variable newprice              like mfc_logical initial yes
   no-undo.
define shared variable lineffdate     like so_due_date.
define shared variable match_pt_um    like mfc_logical.
define        variable pc_recno       as recid no-undo.
define shared variable line_pricing   like mfc_logical.
define shared variable reprice_dtl    like mfc_logical.
define shared variable pics_type      like pi_cs_type.
define shared variable part_type      like pi_part_type.
define shared variable picust         like cm_addr.
define        variable soc_pt_req     like mfc_logical no-undo.
define        variable err_flag       as   integer no-undo.
define        variable update_parent_list  like mfc_logical no-undo.
define shared variable rfact          as   integer.
define        variable disc_min_max   like mfc_logical no-undo.
define        variable disc_pct_err   as   decimal
   format "->>>>,>>>,>>9.9<<<" no-undo.
define        variable discount       as decimal no-undo.
define        variable sobdiscpct     as decimal no-undo.
define        variable man_disc_pct   as decimal no-undo.
define        variable sys_disc_fact  as decimal no-undo.
define        variable save_disc_pct  as decimal no-undo.
define        variable last_sob_price like sob_price  no-undo.
define        variable l_pt_um        like pt_um      no-undo.

define input parameter update_accum_qty like mfc_logical no-undo.
define input parameter pause_if_error   like mfc_logical no-undo.

{pppivar.i }  /*SHARED PRICING VARIABLES*/
{pppiwqty.i } /*SHARED ACCUM QTY WORKFILES*/
{pppiwkpi.i } /*SHARED PRICING WORKFILE*/

define variable scrp_pct        like ps_scrp_pct  no-undo.
define variable tot_cost        like sod_std_cost no-undo.
define variable mc-error-number like msg_nbr      no-undo.
define variable l_list_pr       like wkpi_amt     no-undo.

find sod_det
   where recid(sod_det) = sod_recno
   exclusive-lock.

for first so_mstr
   fields(so_curr so_cust so_ex_rate so_ex_rate2)
   where recid(so_mstr) = so_recno
   no-lock:
end. /* FOR FIRST so_mstr */

for first pic_ctrl
   fields(pic_disc_comb pic_so_fact pic_so_rfact)
   no-lock:
end. /* FOR FIRST pic_ctrl */

for first mfc_ctrl
   fields (mfc_field mfc_logical)
   where mfc_field = "soc_pt_req"
   no-lock:
end. /* FOR FIRST mfc_ctrl */

if available mfc_ctrl
then
   soc_pt_req = mfc_logical.

for first soc_ctrl
   fields (soc_apm)
   no-lock:
end.
if soc_apm
then
   for first cm_mstr
      fields (cm_promo)
      where cm_addr = so_cust
      no-lock:
   end.

/*DETERMINE IF PARENT HAS A MANUALLY ENTERED LIST PRICE,
IF SO, COMPONENT LISTS WILL NOT ROLL UP INTO sod_list_pr*/

find first wkpi_wkfl
    where wkpi_parent   = ""  and
          wkpi_feature  = ""  and
          wkpi_option   = ""  and
          wkpi_amt_type = "1" and
          wkpi_source   = "1"
    no-lock no-error.

if not available wkpi_wkfl
then
   update_parent_list = yes.
else
   update_parent_list = no.

if sod_qty_ord <> 0
then
   qtyord = sod_qty_ord.
else
   qtyord = 1.

/* GET THE COST */
{gprun.i ""socalcst.p"" "(sod_nbr, sod_line, output tot_cost)" }
/*GUI*/ if global-beam-me-up then undo, leave.


sod_std_cost = sod_std_cost + tot_cost.

/* EACH sob_det ADDS TO THE sod_det COST */
for each sob_det
   where sob_nbr = sod_nbr
   and  sob_line = sod_line
   break by sob_part:
   if first-of (sob_part)
   then

      for first pt_mstr
         fields(pt_part pt_phantom pt_pm_code pt_price pt_promo pt_um)
         where pt_part = sob_part
      no-lock:

         l_pt_um = pt_um.

      end. /* FOR FIRST pt_mstr */

   /* PROCESS COMPONENT PRICING SAME AS PARENT, ONLY THOSE   */
   /* CONFIGURED AS OPTIONAL ARE PRICED AND ADDED TO sod_det */
   /* PRICE FIELDS                                           */

  /*if substring(sob_feature,13,1) = "o"
   or substring(sob_serial,15,1)  = "o"
   then do:*/

      if line_pricing
      or reprice_dtl
      then do:
         assign
            last_sob_price  = sob_price
            best_list_price = 0
            best_net_price  = 0.

         /*GET BEST LIST TYPE PRICE LIST*/

         if  soc_apm
         and available cm_mstr
         and cm_promo <> ""
         and available pt_mstr
         and pt_promo <> ""
         then do:
            {gprun.i ""gppiapm1.p"" "(pics_type,
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
                                      so_ex_rate2,
                                      sod_nbr,
                                      sod_line,
                                      sod_div,
                                      output err_flag)"}
/*GUI*/ if global-beam-me-up then undo, leave.

         end. /* IF soc_apm */
         else do : /* IF NOT soc_apm */

            {gprun.i ""gppibx.p"" "(pics_type,
                                    picust,
                                    part_type,
                                    sob_part,
                                    sob_parent,
                                    sob_feature,
                                    sob_part,
                                    1,
                                    so_curr,
                                    l_pt_um,
                                    sod_pricing_dt,
                                    soc_pt_req,
                                    sod_site,
                                    so_ex_rate,
                                    so_ex_rate2,
                                    sod_nbr,
                                    sod_line,
                                    output err_flag)"}
/*GUI*/ if global-beam-me-up then undo, leave.

         end. /* IF NOT soc_apm */

         if best_list_price = 0
         then do:
            find first wkpi_wkfl
               where wkpi_parent   = sob_parent
               and   wkpi_feature  = sob_feature
               and   wkpi_option   = sob_part
               and   wkpi_amt_type = "1"
            no-lock no-error.
            if not available wkpi_wkfl
            then do:
               if available pt_mstr
               then do:
                  /* CHANGED 6th INPUT PARAMETER TO false FROM true */
                  {gprunp.i "mcpl" "p" "mc-curr-conv"
                                   "(input  base_curr,
                                     input  so_curr,
                                     input  so_ex_rate2,
                                     input  so_ex_rate,
                                     input  pt_price * sod_um_conv,
                                     input  false,
                                     output best_list_price,
                                     output mc-error-number)"}
                  if mc-error-number <> 0
                  then do:
                     {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
                  end.

                  /*CREATE LIST TYPE PRICE LIST RECORD IN wkpi_wkfl*/
                  {gprun.i ""gppiwkad.p"" "(sod_um,
                                            sob_parent,
                                            sob_feature,
                                            sob_part,
                                            ""4"",
                                            ""1"",
                                            best_list_price,
                                            0,
                                            no)"}
/*GUI*/ if global-beam-me-up then undo, leave.

               end.
               else do:
                  /* CREATE LIST TYPE PRICE LIST RECORD IN wkpi_wkfl */
                  best_list_price = sob_tot_std.
                  {gprun.i ""gppiwkad.p"" "(sod_um,
                                            sob_parent,
                                            sob_feature,
                                            sob_part,
                                            ""7"",
                                            ""1"",
                                            best_list_price,
                                            0,
                                            no)"}
/*GUI*/ if global-beam-me-up then undo, leave.

               end.
            end.
            else
               best_list_price = wkpi_amt.
         end.
         assign
            sob_tot_std = best_list_price
            sob_price   = best_list_price.

         /*CALCULATE TERMS INTEREST*/
         if sod_crt_int <> 0
         then do:
            assign
               sob_tot_std     = (100 + sod_crt_int) / 100 * sob_tot_std
               sob_price       = sob_tot_std
               best_list_price = sob_tot_std.
            /*CREATE CREDIT TERMS INTEREST wkpi_wkfl RECORD*/
            {gprun.i ""gppiwkad.p"" "(sod_um,
                                      sob_parent,
                                      sob_feature,
                                      sob_part,
                                      ""5"",
                                      ""1"",
                                      sob_tot_std,
                                      0,
                                      no)"}
/*GUI*/ if global-beam-me-up then undo, leave.

         end.

      end. /* line_pricing OR reprice_dtl */

      /* UPDATE ACCUM QTY WORKFILES                           */
      /* QUALIFIED THE QTY (sob_qty_req) AND EXTENDED LIST    */
      /* (sob_qty_req * sob_tot_std) PARAMETERS TO DIVIDE BY  */
      /* U/M CONVERSION RATIO SINCE THESE INCLUDE THIS FACTOR */
      /* ALREADY.                                             */
      if update_accum_qty
      then do:
         {gprun.i ""gppiqty2.p"" "(sod_line,
                                   sob_part,
                                   sob_qty_req / sod_um_conv,
                                   sob_qty_req * sob_tot_std / sod_um_conv,
                                   sod_um,
                                   no,
                                   yes,
                                   yes)"}
/*GUI*/ if global-beam-me-up then undo, leave.

      end.

      if (line_pricing
      or reprice_dtl)
      then do:

         /* LOOK INTO PRICE TABLES ONLY IF PRICES ARE NOT MANUALLY EDITED */
         /* IN THE SO CONFIGURATION BILL                                  */
         if not can-find (first wkpi_wkfl
            where wkpi_parent  = sob_parent
            and   wkpi_feature = sob_feature
            and   wkpi_option  = sob_part
            and   wkpi_source  = "1")
         then do:
            /*GET BEST DISCOUNTS*/

            if  soc_apm
            and available cm_mstr
            and cm_promo <> ""
            and available pt_mstr
            and pt_promo <> ""
            then do:
               {gprun.i ""gppiapm1.p"" "(pics_type,
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
                                         so_ex_rate2,
                                         sod_nbr,
                                         sod_line,
                                         sod_div,
                                         output err_flag)"}
/*GUI*/ if global-beam-me-up then undo, leave.

            end. /* IF soc_apm */
            else do: /* IF NOT soc_apm */

               {gprun.i ""gppibx.p"" "(pics_type,
                                       picust,
                                       part_type,
                                       sob_part,
                                       sob_parent,
                                       sob_feature,
                                       sob_part,
                                       2,
                                       so_curr,
                                       l_pt_um,
                                       sod_pricing_dt,
                                       no,
                                       sod_site,
                                       so_ex_rate,
                                       so_ex_rate2,
                                       sod_nbr,
                                       sod_line,
                                       output err_flag)"}
/*GUI*/ if global-beam-me-up then undo, leave.

            end. /* IF NOT soc_apm */
         end. /* IF NOT  CAN-FIND */

         /* WHEN BEST LIST PRICE IS 0 AND NET PRICE / MARK-UP TYPE PRICE   */
         /* LISTS EXIST FOR THE COMPONENT ITEMS.                           */

         l_list_pr = 0.
         if best_list_price = 0
         then do:

            for each wkpi_wkfl
               where (wkpi_amt_type = "4" or
                      wkpi_amt_type = "3")
                 and wkpi_parent    = sob_parent
                 and wkpi_feature   = sob_feature
                 and wkpi_option    = sob_part
               no-lock:

               if wkpi_amt_type = "4"
               then do:
                  if l_list_pr = 0
                  then
                     l_list_pr = wkpi_amt.

                  if wkpi_amt < l_list_pr
                  then
                     l_list_pr = wkpi_amt.
               end. /* IF wkpi_amt_type = "4" */

               if wkpi_amt_type = "3"
               then do:
                  if l_list_pr = 0
                  then
                     l_list_pr = wkpi_disc_amt + (wkpi_disc_amt *
                                                 (wkpi_amt / 100)).
                  if (wkpi_disc_amt + (wkpi_disc_amt * (wkpi_amt / 100))) <
                     l_list_pr
                  then
                     l_list_pr = wkpi_disc_amt + (wkpi_disc_amt *
                                                 (wkpi_amt / 100)).
               end. /* IF wkpi_amt_type = "3" */

            end. /* FOR EACH wkpi_wkfl */

            {gprun.i ""gppiwkad.p"" "(sod_um,
                                      sob_parent,
                                      sob_feature,
                                      sob_part,
                                      ""0"",
                                      ""1"",
                                      l_list_pr,
                                      0,
                                      no)"}
/*GUI*/ if global-beam-me-up then undo, leave.


            assign
               best_list_price = l_list_pr
               sob_tot_std     = best_list_price
               sob_price       = best_list_price.

            if  sod_crt_int <> 0
            and sob_tot_std <> 0
            then do:
               assign
                  sob_tot_std     = (100 + sod_crt_int) / 100 * sob_tot_std
                  sob_price       = sob_tot_std
                  best_list_price = sob_tot_std.

               {gprun.i ""gppiwkad.p"" "(sod_um,
                                         sob_parent,
                                         sob_feature,
                                         sob_part,
                                         ""5"",
                                         ""1"",
                                         sob_tot_std,
                                         0,
                                         no)"}
/*GUI*/ if global-beam-me-up then undo, leave.


            end. /* IF  sod_crt_int <> 0 ... */

            if  update_accum_qty
            and sob_tot_std <> 0
            then do:
               {gprun.i ""gppiqty2.p"" "(sod_line,
                                         sob_part,
                                         sob_qty_req / sod_um_conv,
                                         sob_qty_req *
                                         sob_tot_std / sod_um_conv,
                                         sod_um,
                                         no,
                                         yes,
                                         yes)"}
/*GUI*/ if global-beam-me-up then undo, leave.

            end. /* IF update_accum_qty ... */
         end. /* IF best_list_price = 0 */

         /*CALCULATE BEST PRICE*/
         {gprun.i ""gppibx04.p"" "(sob_parent,
                                   sob_feature,
                                   sob_part,
                                   no,
                                   rfact)"}
/*GUI*/ if global-beam-me-up then undo, leave.

         sob_price = best_net_price.

         /* JUST IN CASE SYSTEM DISCOUNTS CHANGED SINCE THE LAST PRICING  */
         /* AND THE USER MANUALLY ENTERED THE PRICE (OR DISCOUNT), RETAIN */
         /* THE PREVIOUS NET PRICE (THAT'S WHAT THE USER WANTS) AND REVISE*/
         /* THE MANUAL DISCOUNT ADJUSTMENT TO COMPENSATE.                 */

         if sob_tot_std <> 0
         then
            sobdiscpct = (1 - (sob_price / sob_tot_std)) * 100.
         else
            sobdiscpct = 0.

         find first wkpi_wkfl
            where wkpi_parent   = sob_parent  and
                  wkpi_feature  = sob_feature and
                  wkpi_option   = sob_part    and
                  wkpi_amt_type = "2"         and
                  wkpi_source   = "1"
            no-lock no-error.

         if available wkpi_wkfl
         then do:
            assign
               save_disc_pct = sobdiscpct
               sob_price     = last_sob_price.
            if sob_tot_std <> 0
            then
               sobdiscpct = (1 - (sob_price / sob_tot_std)) * 100.
            else
               sobdiscpct = 0.

            if pic_disc_comb = "1"
            then do:      /* CASCADING DISCOUNT */
               if available wkpi_wkfl
               then
                  sys_disc_fact = if not found_100_disc
                                  then
                                     ((100 - save_disc_pct) / 100) /
                                     ((100 - wkpi_amt)      / 100)
                                  else
                                     0.
               else
                  sys_disc_fact =  (100 - save_disc_pct) / 100.
               if sys_disc_fact = 1
               then
                  man_disc_pct  = sobdiscpct.
               else do:
                  if sys_disc_fact <> 0
                  then do:
                     assign
                        discount     = (100 - sobdiscpct) / 100
                        man_disc_pct = (1 - (discount / sys_disc_fact))
                                       * 100.
                  end.
                  else
                     man_disc_pct = if sobdiscpct = 100
                                    then
                                       sobdiscpct
                                    else
                                       sobdiscpct - 100.
               end.
            end.
            else do:
               if available wkpi_wkfl
               then
                  man_disc_pct = sobdiscpct - (save_disc_pct - wkpi_amt).
               else
                  man_disc_pct = sobdiscpct - save_disc_pct.
            end.

            {gprun.i ""gppiwkad.p"" "(sod_um,
                                      sob_parent,
                                      sob_feature,
                                      sob_part,
                                      ""1"",
                                      ""2"",
                                      0,
                                      man_disc_pct,
                                      no)"}
/*GUI*/ if global-beam-me-up then undo, leave.


         end. /* last_sob_price <> sob_price */

         /*TEST FOR DISCOUNT RANGE VIOLATION.  IF FOUND, CREATE    */
         /*MANUAL DISCOUNT TO RECONCILE THE DIFFERENCE BETWEEN THE */
         /*SYSTEM DISCOUNT AND THE MIN OR MAX ALLOWABLE DISCOUNT,  */
         /*DEPENDING ON THE VIOLATION.                             */

         if sob_tot_std <> 0
         then
            sobdiscpct   = (1 - (sob_price / sob_tot_std)) * 100.
         else
            sobdiscpct = 0.

         disc_min_max = no.

         {gppidisc.i pic_so_fact sobdiscpct pic_so_rfact}
         if disc_min_max
         then do:
            {pxmsg.i &MSGNUM=6934
                     &ERRORLEVEL=2
                     &MSGARG1=sob_part
                     &MSGARG1=dict_pct_err}
            if not batchrun
            then
               pause.
            sobdiscpct      = if pic_so_fact
                              then
                                 (1 - discount) * 100
                              else
                                 discount.
            find first wkpi_wkfl
                where wkpi_parent   = sob_parent  and
                      wkpi_feature  = sob_feature and
                      wkpi_option   = sob_part    and
                      wkpi_amt_type = "2"         and
                      wkpi_source   = "1"
                no-lock no-error.

            /* CASCADING DISCOUNT */
            if pic_disc_comb = "1"
            then do:
               if available wkpi_wkfl
               then
                  sys_disc_fact = ((100 - disc_pct_err) / 100) /
                                  ((100 - wkpi_amt)      / 100).
               else
                  sys_disc_fact =  (100 - disc_pct_err) / 100.
               if sys_disc_fact = 1
               then
                  man_disc_pct  = sobdiscpct.
               else do:
                  if sys_disc_fact <> 0
                  then do:
                     assign
                        discount      = (100 - sobdiscpct) / 100
                        man_disc_pct  = (1 - (discount / sys_disc_fact)) * 100.
                  end.
                  else
                     man_disc_pct  = sobdiscpct - 100.
               end.
            end.
            else do:  /* ADDITIVE DISCOUNT */
               if available wkpi_wkfl
               then
                  man_disc_pct = sobdiscpct - (disc_pct_err - wkpi_amt).
               else
                  man_disc_pct = sobdiscpct - disc_pct_err.
            end.

            {gprun.i ""gppiwkad.p"" "(sod_um,
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


            sob_price = sob_tot_std * (1 - (sobdiscpct / 100)).

         end. /* IF disc_min_max */

         /*UPDATE sod_list_pr AND sod_price, TEST TO SEE IF PARENT
         HAS MANUALLY ENTERED LIST PRICE, IF SO, DO NOT ACCUMULATE
         sod_list_pr*/

         if update_parent_list
         then
            sod_list_pr = sod_list_pr + (sob_tot_std *
                          sob_qty_req / qtyord / sod_um_conv).
         sod_price = sod_price + (sob_price * sob_qty_req / qtyord
                     / sod_um_conv).

      end. /* line_pricing OR reprice_dtl */

  /* end. *//* sob_feature OR sob_serial */

end. /* FOR EACH sob_det */
