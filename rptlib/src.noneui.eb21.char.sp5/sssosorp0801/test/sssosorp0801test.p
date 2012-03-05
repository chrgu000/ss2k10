/* sosorp08.p - SALES GROSS MARGIN REPORT BY ORDER                            */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.14.1.7 $                                                               */
/*V8:ConvertMode=FullGUIReport                                                */
/* REVISION: 1.0      LAST MODIFIED: 06/03/86   BY: PML                       */
/* REVISION: 1.0      LAST MODIFIED: 08/29/86   BY: EMB *12*                  */
/* REVISION: 4.0      LAST MODIFIED: 02/12/88   BY: FLM *A175*                */
/* REVISION: 4.0      LAST MODIFIED: 02/08/89   BY: RL *C0028*                */
/* REVISION: 5.0      LAST MODIFIED: 09/21/89   BY: MLB *B286*                */
/* REVISION: 5.0      LAST MODIFIED: 02/12/90   BY: ftb *B564*                */
/* REVISION: 6.0      LAST MODIFIED: 04/20/90   BY: ftb *                     */
/* REVISION: 5.0      LAST MODIFIED: 04/30/90   BY: emb *B682*                */
/* REVISION: 6.0      LAST MODIFIED: 02/13/91   BY: bjb *D865*                */
/* REVISION: 6.0      LAST MODIFIED: 04/11/91   BY: bjb *D515*                */
/* REVISION: 6.0      LAST MODIFIED: 10/21/91   BY: afs *D903*                */
/* REVISION: 7.0      LAST MODIFIED: 03/17/92   BY: TMD *F259*                */
/* REVISION: 7.0      LAST MODIFIED: 03/26/92   BY: dld *F322*                */
/* REVISION: 7.3      LAST MODIFIED: 12/02/92   BY: WUG *G383*                */
/* REVISION: 7.3      LAST MODIFIED: 01/20/93   BY: tjs *G560*                */
/* REVISION: 7.3      LAST MODIFIED: 05/04/93   BY: tjs *GA65*                */
/* REVISION: 7.3      LAST MODIFIED: 08/26/93   BY: tjs *G E 55*              */
/* REVISION: 7.3      LAST MODIFIED: 01/03/94   BY: tjs *F L 15*              */
/* REVISION: 7.3      LAST MODIFIED: 11/01/94   BY: ame *GN90*                */
/* REVISION: 8.5      LAST MODIFIED: 09/12/95   BY: taf *J053*                */
/* REVISION: 7.3      LAST MODIFIED: 10/10/95   BY: jym *G0YX*                */
/* REVISION: 8.5      LAST MODIFIED: 04/09/96   BY: jzw *G1P6*                */
/* REVISION: 8.5      LAST MODIFIED: 07/19/96   BY: taf *J0ZZ*                */
/* REVISION: 8.5      LAST MODIFIED: 04/23/97   BY: *J1LV* Aruna Patil        */
/* REVISION: 8.6      LAST MODIFIED: 10/05/97   BY: ckm *K0L5*                */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane          */
/* REVISION: 8.6E     LAST MODIFIED: 07/17/98   BY: *L024* Bill Reckard       */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1      LAST MODIFIED: 08/14/00   BY: *N0K6* Mudit Mehta        */
/* REVISION: 9.1      LAST MODIFIED: 10/25/00   BY: *N0T7* Jean Miller        */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.14.1.4  BY: Hareesh V. DATE: 06/21/02 ECO: *N1HY*              */
/* Revision: 1.14.1.6  BY: Paul Donnelly (SB) DATE: 06/28/03 ECO: *Q00L*      */
/* $Revision: 1.14.1.7 $        BY: Ashutosh Pitre     DATE: 09/19/03 ECO: *P13J*      */
/* $Revision: 1.14.1.7 $        BY: Bill Jiang     DATE: 08/13/07 ECO: *SS - 20070813.1*      */
/*-Revision end---------------------------------------------------------------*/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* DISPLAY TITLE */
{mfdtitle.i "1+ "}

/* SS - 20070813.1 - B */
{sssosorp0801.i "new"}
/* SS - 20070813.1 - E */

{gpcurrp.i}

define variable rndmthd         like rnd_rnd_mthd                        no-undo.
define variable oldcurr         like so_curr                             no-undo.
define variable cust            like so_cust                             no-undo.
define variable cust1           like so_cust                             no-undo.
define variable nbr             like so_nbr                              no-undo.
define variable nbr1            like so_nbr                              no-undo.
define variable ord             like so_ord_date                         no-undo.
define variable ord1            like so_ord_date                         no-undo.
define variable name            like ad_name                             no-undo.
define variable qty_open        like sod_qty_ord label "Qty Open"        no-undo.
define variable ext_price       like sod_price   label "Ext Price"
                                format "->>>>,>>>,>>9.99"                no-undo.
define variable ext_price_unrnd like sod_price                           no-undo.
define variable gr_margin       like sod_price   label "Unit Margin"     no-undo.
define variable ext_gr_margin   like ext_price   label "Ext Margin"      no-undo.
define variable desc1           like pt_desc1                            no-undo.
define variable base_tot        like sod_price                           no-undo.
define variable base_tot_unrnd  like sod_price                           no-undo.
define variable margin_tot      like ext_price                           no-undo.
define variable base_price      like sod_price format ">>>>>>>>>9.99<<<" no-undo.
define variable hold_cost       like sod_std_cost                        no-undo.
define variable base_rpt        like so_curr                             no-undo.
define variable mixed_rpt       like mfc_logical initial no
                                label "Mixed Currencies"                 no-undo.
define variable disp_curr       as   character format "x(1)" label "C"   no-undo.
define variable spsn            like sp_addr                             no-undo.
define variable spsn1           like spsn                                no-undo.
define variable prt_curr        like so_curr                             no-undo.
define variable printable       like mfc_logical                         no-undo.
define variable include_shipped like mfc_logical initial yes
                                label "Include Fully Shipped"            no-undo.
define variable include_unconf  like mfc_logical initial yes
                                label "Include Unconfirmed"              no-undo.
define variable l_new_so        like mfc_logical initial no              no-undo.
define variable v_disp_line1    as   character   format "x(40)"
                                label "Exch Rate"                        no-undo.
define variable v_disp_line2    as   character   format "x(40)"          no-undo.
define variable mc-error-number like msg_nbr                             no-undo.

{gprunpdf.i "mcpl" "p"}
{gprunpdf.i "mcui" "p"}

form
   nbr                            colon 15
   nbr1            label "To"     colon 49 skip
   cust                           colon 15
   cust1           label "To"     colon 49 skip
   ord                            colon 15
   ord1            label "To"     colon 49 skip
   spsn                           colon 15
   spsn1           label "To"     colon 49 skip(1)
   base_rpt                       colon 25 skip
   mixed_rpt                      colon 25 skip(1)
   include_shipped                colon 25
   include_unconf                 colon 25
with frame a side-labels width 80.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

find first gl_ctrl  where gl_ctrl.gl_domain = global_domain no-lock no-error.
oldcurr = "".

{wbrp01.i}

repeat:

   if can-find(first order_wkfl)
   then
      for each order_wkfl
      exclusive-lock:
         delete order_wkfl.
      end.  /* FOR FIRST order_wkfl */

   if nbr1  = hi_char  then nbr1  = "".
   if cust1 = hi_char  then cust1 = "".
   if ord   = low_date then ord   = ?.
   if ord1  = hi_date  then ord1  = ?.
   if spsn1 = hi_char  then spsn1 = "".

   if c-application-mode <> 'web'
   then
      update
         nbr nbr1 cust cust1 ord ord1 spsn spsn1 base_rpt
         mixed_rpt include_shipped include_unconf
      with frame a.

   {wbrp06.i &command = update
             &fields  = "  nbr nbr1 cust cust1 ord ord1 spsn spsn1
                         base_rpt mixed_rpt include_shipped include_unconf"
             &frm     = "a"}

   if    (c-application-mode <> 'web')
      or (c-application-mode = 'web'
      and (c-web-request begins 'data'))
   then do:

      bcdparm = "".
      {mfquoter.i nbr            }
      {mfquoter.i nbr1           }
      {mfquoter.i cust           }
      {mfquoter.i cust1          }
      {mfquoter.i ord            }
      {mfquoter.i ord1           }
      {mfquoter.i spsn           }
      {mfquoter.i spsn1          }
      {mfquoter.i base_rpt       }
      {mfquoter.i mixed_rpt      }
      {mfquoter.i include_shipped}
      {mfquoter.i include_unconf }

      if nbr1  = "" then nbr1  = hi_char.
      if cust1 = "" then cust1 = hi_char.
      if ord   = ?  then ord   = low_date.
      if ord1  = ?  then ord1  = hi_date.
      if spsn1 = "" then spsn1 = hi_char.

   end. /* IF (c-application-mode <> 'web') OR */

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

   /* SS - 20070813.1 - B */
   /*
   {mfphead.i}

   form
      skip(1)
   with frame a1 page-top width 132.
   /* SET EXTERNAL LABELS */
   setFrameLabels(frame a1:handle).
   view frame a1.

   for each so_mstr
      fields( so_domain so_curr so_cust so_exru_seq so_ex_rate so_ex_rate2
             so_nbr  so_rmks so_sched    so_ship    so_slspsn   so_stat)
       where so_mstr.so_domain = global_domain and (  (so_nbr       >= nbr )
      and   (so_nbr       <= nbr1)
      and    so_sched      = no
      and   (so_cust      >= cust)
      and   (so_cust      <= cust1)
      and   (so_ord_date  >= ord)
      and   (so_ord_date  <= ord1)
      and   (so_slspsn[1] >= spsn)
      and   (so_slspsn[1] <= spsn1)
      and  ((so_curr       = base_rpt)
         or (base_rpt      = ""))
   ) no-lock break by so_nbr
   with frame c down width 132 no-box:

      /* SET EXTERNAL LABELS */
      setFrameLabels(frame c:handle).

      /* CHECK IF ANY SALES ORDER IS BEING CREATED */
      l_new_so = no.
      {gprun.i ""sonewso.p""
         "(input recid(so_mstr),
           output l_new_so)"}
      if not l_new_so
      then do:

         if    (oldcurr <> so_curr)
            or (oldcurr = "")
         then do:

            /* CALL TO gpcurmth.i REPLACED BY mc-get-rnd-mthd */
            /* GET ROUNDING METHOD FROM CURRENCY MASTER */
            {gprunp.i "mcpl" "p" "mc-get-rnd-mthd"
               "(input  so_curr,
                 output rndmthd,
                 output mc-error-number)" }
            if mc-error-number <> 0
            then do:
               {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=4}
               if c-application-mode <> 'WEB'
               then
                  pause.
               undo, next.
            end. /* IF mc-error-number <> 0 */
            oldcurr = so_curr.
         end. /* IF (oldcurr <> so_curr) OR (oldcurr = "") */

         printable = no. /* DETERMINE IF AT LEAST ONE LINE IS PRINTABLE */
         if     include_shipped
            and include_unconf
         then
            printable = yes.
         if not printable
         then do:
            if include_shipped
            then do:
               for first sod_det
                  fields( sod_domain sod_confirm sod_desc sod_due_date sod_line
                  sod_nbr
                         sod_price   sod_part sod_qty_ord  sod_type sod_sched
                         sod_type    sod_um   sod_qty_ship sod_std_cost)
                   where sod_det.sod_domain = global_domain and  sod_nbr =
                   so_nbr
                  and   sod_confirm
               no-lock:
               end. /* FOR FIRST sod_det */
            end. /* IF include_shipped */
            else do: /* INCLUDE_UNCONF */
               for first sod_det
                  fields( sod_domain sod_confirm sod_desc sod_due_date sod_line
                  sod_nbr
                         sod_price   sod_part sod_qty_ord  sod_type sod_sched
                         sod_type    sod_um    sod_qty_ship sod_std_cost)
                   where sod_det.sod_domain = global_domain and  sod_nbr =
                   so_nbr
                  and (sod_qty_ord - sod_qty_ship) > 0
               no-lock:
               end. /* FOR FIRST sod_det */
            end. /* ELSE DO */
            if available sod_det
            then
               printable = yes.
         end. /* IF NOT PRINTABLE */
         if printable
         then do:

            name = "".
            for first ad_mstr
               fields( ad_domain ad_addr ad_name)
               where ad_mstr.ad_domain = global_domain
               and   ad_addr = so_cust
               no-lock:
               name = ad_name.
            end. /* FOR FIRST ad_mstr */

            {gprunp.i "mcui" "p" "mc-ex-rate-output"
               "(input so_curr,
                 input base_curr,
                 input so_ex_rate,
                 input so_ex_rate2,
                 input so_exru_seq,
                 output v_disp_line1,
                 output v_disp_line2)"}

            if so_rmks <> "" and page-size - line-counter < 3
            then
               page.
            do with frame b:
               /* SET EXTERNAL LABELS */
               setFrameLabels(frame b:handle).
               display
                  so_nbr so_cust name so_ship so_ord_date so_stat
                  so_slspsn[1] so_slspsn[2] so_curr v_disp_line1
               with frame b width 132.

               if    so_slspsn[3] <> ""
                  or so_slspsn[3] <> ""
                  or v_disp_line2 <> ""
               then
                  display
                     so_slspsn[3] @ so_slspsn[1]
                     so_slspsn[4] @ so_slspsn[2]
                     v_disp_line2 @ v_disp_line1
                  with frame b.
            end. /* DO WITH */
            if so_rmks <> ""
            then
               put so_rmks at 13.
            put skip(1).

            /* GET ORDER DETAIL  */
            for each sod_det
               fields( sod_domain sod_confirm sod_desc sod_due_date sod_line
               sod_nbr
                      sod_price   sod_part sod_qty_ord  sod_type sod_sched
                      sod_type    sod_um    sod_qty_ship sod_std_cost)
                where sod_det.sod_domain = global_domain and  sod_nbr   = so_nbr
               and   sod_sched = no
            no-lock break by sod_nbr by sod_line
            with frame c width 132:

               qty_open = sod_qty_ord - sod_qty_ship.
               if     sod_qty_ord > 0
                  and qty_open    < 0
               then
                  qty_open = 0.
               if     sod_qty_ord < 0
                  and qty_open    > 0
               then
                  qty_open = 0.

               /* IS LINE PRINTABLE? */
               if     (include_shipped
                  or  (not include_shipped and qty_open > 0))
                  and (include_unconf or (not include_unconf and sod_confirm))
               then do:

                  if    base_curr = so_curr
                     or base_rpt  = so_curr
                     or (base_rpt = "" and mixed_rpt)
                  then do: /* UNIT PRICE WILL NOT BE CONVERTED */
                     base_price = sod_price.
                  end. /* IF base_curr = so_curr */
                  else do:  /* CONVERT UNIT PRICE TO BASE */

                     {gprunp.i "mcpl" "p" "mc-curr-conv"
                        "(input  so_curr,
                          input  base_curr,
                          input  so_ex_rate,
                          input  so_ex_rate2,
                          input  sod_price,
                          input  false,  /* DO NOT ROUND */
                          output base_price,
                          output mc-error-number)" }
                     if mc-error-number <> 0
                     then do:
                        {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
                     end. /* IF mc-error-number <> 0 */

                     disp_curr = getTermLabel("YES",1).
                  end.    /* END ELSE DO */

                  /*COST IS IN BASE. CONVERT WHEN REPORTING IN NON-BASE.*/
                  if    (base_rpt = "" and not mixed_rpt)
                     or (base_curr = so_curr and base_rpt = "" and mixed_rpt)
                  then
                     hold_cost = sod_std_cost.

                  else do:
                     {gprunp.i "mcpl" "p" "mc-curr-conv"
                        "(input  base_curr,
                          input  so_curr,
                          input  so_ex_rate2,
                          input  so_ex_rate,
                          input  sod_std_cost,
                          input  false,  /* DO NOT ROUND */
                          output hold_cost,
                          output mc-error-number)" }
                     if mc-error-number <> 0
                     then do:
                        {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
                     end. /* IF mc-error-number <> 0 */
                  end. /* ELSE DO */

                  /* ext_price AND gr_margin WILL BE CALCULATED IN */
                  /* ORIGINAL CURRENCY UNLESS BASE IS SPECIFIED.   */

                  if base_rpt = "" and mixed_rpt
                  then
                     assign
                        gr_margin     = sod_price - hold_cost
                        ext_gr_margin = qty_open * gr_margin
                        /* NO CURRENCY CONVERSION */
                        ext_price     = qty_open * sod_price.
                  else
                     assign
                        gr_margin     = base_price - hold_cost
                        ext_gr_margin = qty_open * gr_margin
                        ext_price     = qty_open * base_price.

                  assign
                     base_tot   = qty_open * base_price
                     margin_tot = qty_open * (base_price - hold_cost).

                  /* CONVERT ext_price & MARGIN TO BASE IF */
                  /* REPORTING base_curr                   */
                  if     base_rpt = ""
                     and mixed_rpt
                  then do:

                     {gprunp.i "mcpl" "p" "mc-curr-conv"
                        "(input  so_curr,
                          input  base_curr,
                          input  so_ex_rate,
                          input  so_ex_rate2,
                          input  base_tot,
                          input  false,  /* DO NOT ROUND */
                          output base_tot,
                          output mc-error-number)" }
                     if mc-error-number <> 0
                     then do:
                        {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
                     end. /* IF mc-error-number <> 0 */

                     {gprunp.i "mcpl" "p" "mc-curr-conv"
                        "(input  so_curr,
                          input  base_curr,
                          input  so_ex_rate,
                          input  so_ex_rate2,
                          input  margin_tot,
                          input  false,  /* DO NOT ROUND */
                          output margin_tot,
                          output mc-error-number)" }
                     if mc-error-number <> 0
                     then do:
                        {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
                     end. /* IF mc-error-number <> 0 */

                  end. /* IF base_rpt = "" AND mixed_rpt THEN DO: */

                  /* SAVE ext_price AND base_tot UNROUNDED AMOUNTS */
                  assign
                     ext_price_unrnd = ext_price
                     base_tot_unrnd  = base_tot
                     /* SET THE PRINT LINE CURRENCY */
                     prt_curr = so_curr.
                  if base_rpt = "" and not mixed_rpt
                  then
                     prt_curr = base_curr.

                  /* IF A CURRENCY CONVERSION WAS DONE */
                  if disp_curr = getTermLabel("YES",1)
                  then do:

                     /* ROUND RESULT */
                     {gprunp.i "mcpl" "p" "mc-curr-rnd"
                        "(input-output base_tot,
                          input        gl_rnd_mthd,
                          output       mc-error-number)" }
                     if mc-error-number <> 0
                     then do:
                        {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
                     end. /* IF mc-error-number <> 0 */

                     {gprunp.i "mcpl" "p" "mc-curr-rnd"
                        "(input-output ext_price,
                          input        gl_rnd_mthd,
                          output       mc-error-number)" }

                     {gprunp.i "mcpl" "p" "mc-curr-rnd"
                        "(input-output ext_gr_margin,
                          input        gl_rnd_mthd,
                          output       mc-error-number)" }

                     {gprunp.i "mcpl" "p" "mc-curr-rnd"
                        "(input-output margin_tot,
                          input        gl_rnd_mthd,
                          output       mc-error-number)" }

                     if base_rpt = "" and mixed_rpt
                     then
                        disp_curr = "".
                  end. /* IF disp_curr */
                  else do:
                     /* BASE TOTAL SHOULD ALWAYS BE ROUNDED PER */
                     /* BASE ROUND METHOD                       */

                     {gprunp.i "mcpl" "p" "mc-curr-rnd"
                        "(input-output base_tot,
                          input        gl_rnd_mthd,
                          output       mc-error-number)" }
                     if mc-error-number <> 0
                     then do:
                        {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
                     end. /* IF mc-error-number */

                     {gprunp.i "mcpl" "p" "mc-curr-rnd"
                        "(input-output ext_price,
                          input        rndmthd,
                          output       mc-error-number)" }

                     {gprunp.i "mcpl" "p" "mc-curr-rnd"
                        "(input-output ext_gr_margin,
                          input        rndmthd,
                          output       mc-error-number)" }

                     {gprunp.i "mcpl" "p" "mc-curr-rnd"
                        "(input-output margin_tot,
                          input        rndmthd,
                          output       mc-error-number)" }

                  end. /*ELSE DO */

                  accumulate ext_price (total by so_nbr).
                  accumulate ext_gr_margin (total by so_nbr).
                  accumulate base_tot (total by so_nbr).
                  accumulate margin_tot (total by so_nbr).
                  accumulate ext_price_unrnd (total by so_nbr).
                  accumulate base_tot_unrnd (total by so_nbr).

                  desc1 = sod_desc.
                  for first pt_mstr
                     fields( pt_domain pt_desc1 pt_desc2 pt_part)
                      where pt_mstr.pt_domain = global_domain and  pt_part =
                      sod_part
                  no-lock:
                     if desc1 = ""
                     then
                        desc1 = pt_desc1 + " " + pt_desc2.

                  end. /* FOR FIRST pt_mstr */

                  if page-size - line-counter < 2
                  then
                     page.
                  display
                     sod_line
                     sod_part
                     sod_um
                     sod_qty_ord
                     sod_qty_ship
                     qty_open
                     sod_confirm label "Conf"
                     prt_curr
                     base_price
                     ext_price
                     ext_gr_margin
                     sod_due_date
                     sod_type.
                  put desc1 at 6 format "x(49)" skip.

               end. /* LINE PRINTABLE */
               {mfrpchk.i}
            end.  /* EACH sod_det */

            /*  STORE SALES ORDER TOTALS, BY CURRENCY, IN WORK FILE.*/

            if base_rpt = "" and mixed_rpt
            then do:
               find first order_wkfl
                  where so_curr = ordwk_curr
               exclusive-lock no-error.
               /* IF A RECORD FOR THIS CURRENCY DOESN'T EXIST, */
               /* CREATE ONE.                                  */
               if not available order_wkfl
               then do:
                  create order_wkfl.
                  ordwk_curr = so_curr.
               end. /* IF NOT AVAILABLE */
               /* ACCUMULATE INDIVIDUAL CURRENCY TOTALS IN WORK FILE.     */
               ordwk_for = ordwk_for + (accum total by so_nbr ext_price_unrnd).
               if base_curr <> so_curr
               then
                  ordwk_base = ordwk_base
                                  + (accum total by so_nbr base_tot_unrnd).
               else
                  ordwk_base = ordwk_for.
            end. /* IF base_rpt */

            /*  DISPLAY SALES ORDER TOTAL.      */
            if page-size - line-counter < 2
            then
               page.
               underline ext_price ext_gr_margin with frame c.
            display
               prt_curr +  " " +
                  getTermLabel("ORDER_TOTAL",12) + ":" format "x(17)"
                  @ sod_part
               accum total by so_nbr ext_price @ ext_price
               accum total by so_nbr ext_gr_margin @ ext_gr_margin
            with frame c.
            if base_curr <> so_curr and base_rpt = "" and mixed_rpt
            then do:
               down 1.

               display
                  getTermLabel("TOTAL_IN_BASE",17) + ":" @ sod_part
                  accum total by so_nbr base_tot @ ext_price
                  accum total by so_nbr margin_tot @ ext_gr_margin.
            end. /* IF base_curr */
            /* FOR REPORT TOTAL */
            accumulate (accum total base_tot) (total).
            accumulate (accum total base_tot_unrnd) (total).
            /* FOR REPORT TOTAL */
            accumulate (accum total margin_tot) (total).

         end. /* ORDER PRINTABLE */

      end. /* IF NOT NEW SALES ORDER */

      /*  DISPLAY REPORT TOTAL            */

      if last(so_nbr)
      then do:
         if (page-size - line-counter < 2) and base_rpt <> ""
         then
            page.

         underline ext_price ext_gr_margin with frame c.
         if base_rpt = ""
         then
            prt_curr = base_curr.
         else
            prt_curr = base_rpt.
         display
            prt_curr + " " + getTermLabel("REPORT_TOTAL",13) +
               ":" format "x(18)" @ sod_part
            accum total (accum total base_tot) @ ext_price
            accum total (accum total margin_tot) @ ext_gr_margin
         with frame c.

         /* IF ALL CURRENCIES, PRINT A SUMMARY REPORT */
         /* BROKEN BY CURRENCY.                       */
         if base_rpt = "" and mixed_rpt
         then
            {gprun.i ""gpcurrp.p""}.
         {mfrpchk.i}
      end. /* IF LAST(so_nbr) */

      {mfrpchk.i}
   end. /* FOR EACH so_mstr */

   /* REPORT TRAILER */
   {mfrtrail.i}
   */
   PUT UNFORMATTED "BEGIN: " + STRING(TIME, "HH:MM:SS") SKIP.

   EMPTY TEMP-TABLE ttsssosorp0801.

   {gprun.i ""sssosorp0801.p"" "(
      input nbr,
      input nbr1,
      input cust,
      input cust1,
      input ord,
      input ord1,
      input spsn,
      input spsn1,
      input base_rpt,
      input mixed_rpt,
      input include_shipped,
      input include_unconf
      )"}

   EXPORT DELIMITER ";" "so_nbr" "so_cust" "name" "so_ship" "so_ord_date" "so_stat" "so_slspsn[1]" "so_slspsn[2]" "so_slspsn[3]" "so_slspsn[4]" "so_curr" "v_disp_line1" "v_disp_line2" "so_rmks" "sod_line" "sod_part" "sod_um" "sod_qty_ord" "sod_qty_ship" "qty_open" "sod_confirm" "prt_curr" "base_price" "ext_price" "ext_gr_margin" "sod_due_date" "sod_type" "so_ex_rate" "so_ex_rate2" "so_exru_seq".
   FOR EACH ttsssosorp0801:
      EXPORT DELIMITER ";" ttsssosorp0801.
   END.

   PUT UNFORMATTED "END: " + STRING(TIME, "HH:MM:SS") SKIP.

   {a6mfrtrail.i}
   /* SS - 20070813.1 - E */

end. /* REPEAT */

{wbrp04.i &frame-spec = a}
