/* sosorp02.p - SALES ORDER REPORT BY ITEM                                   */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                       */
/* All rights reserved worldwide.  This is an unpublished work.              */
/* $Revision: 1.21 $                                                          */
/*V8:ConvertMode=FullGUIReport                                               */
/* REVISION: 1.0      LAST MODIFIED: 06/03/86   BY: PML                      */
/* REVISION: 1.0      LAST MODIFIED: 08/29/86   BY: EMB *12*                 */
/* REVISION: 2.1      LAST MODIFIED: 10/20/87   BY: WUG *A94*                */
/* REVISION: 4.0      LAST MODIFIED: 02/12/88   BY: FLM *A175*               */
/* REVISION: 4.0      LAST MODIFIED: 12/07/88   BY: RL  *C0028               */
/* REVISION: 5.0      LAST MODIFIED: 01/04/88   BY: MLB *B006*               */
/* REVISION: 5.0      LAST MODIFIED: 09/21/89   BY: MLB *B286*               */
/* REVISION: 6.0      LAST MODIFIED: 04/05/90   BY: pml *D001*               */
/* REVISION: 6.0      LAST MODIFIED: 04/10/90   BY: ftb *D002* added site    */
/* REVISION: 6.0      LAST MODIFIED: 04/20/90   BY: ftb *                    */
/* REVISION: 6.0      LAST MODIFIED: 01/03/91   BY: dld *D284*               */
/* REVISION: 6.0      LAST MODIFIED: 02/28/91   BY: dld *D388*               */
/* REVISION: 6.0      LAST MODIFIED: 04/12/91   BY: bjb *D625*               */
/* REVISION: 6.0      LAST MODIFIED: 10/21/91   BY: afs *D903*               */
/* REVISION: 7.0      LAST MODIFIED: 02/06/92   BY: tjs *F184*               */
/* REVISION: 7.3      LAST MODIFIED: 12/02/92   BY: WUG *G383*               */
/* REVISION: 7.3      LAST MODIFIED: 11/01/93   BY: afs *GG83*               */
/* REVISION: 7.3      LAST MODIFIED: 11/04/93   BY: cdt *GG81*               */
/* REVISION: 7.3      LAST MODIFIED: 05/19/94   BY: afs *FO31*               */
/* REVISION: 7.3      LAST MODIFIED: 11/01/94   BY: ame *GN90*               */
/* REVISION: 8.5      LAST MODIFIED: 09/12/95   BY: taf *J053*               */
/* REVISION: 7.3      LAST MODIFIED: 05/11/95   BY: rxm *F0RK*               */
/* REVISION: 7.3      LAST MODIFIED: 10/10/95   BY: jym *G0YX*               */
/* REVISION: 8.5      LAST MODIFIED: 04/09/96   BY: jzw *G1P6*               */
/* REVISION: 8.5      LAST MODIFIED: 07/19/96   BY: taf *J0ZZ*               */
/* REVISION: 8.6      LAST MODIFIED: 10/04/97   BY: ckm *K0KZ*               */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane         */
/* REVISION: 8.6E     LAST MODIFIED: 07/16/98   BY: *L024* Bill Reckard      */
/* REVISION: 9.0      LAST MODIFIED: 12/03/98   BY: *J35H* Seema Varma       */
/* REVISION: 9.0      LAST MODIFIED: 12/29/98   BY: *J37S* Seema Varma       */
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan        */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane  */
/* REVISION: 9.1      LAST MODIFIED: 08/14/00   BY: *N0K6* Mudit Mehta       */
/* REVISION: 9.1      LAST MODIFIED: 10/25/00   BY: *N0T7* Jean Miller       */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.19  BY: Hareesh V DATE: 06/21/02 ECO: *N1HY* */
/* $Revision: 1.21 $ BY: Paul Donnelly (SB) DATE: 06/28/03 ECO: *Q00L* */
/*-Revision end---------------------------------------------------------------*/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* DISPLAY TITLE */
{mfdtitle.i "2+ "}

define variable rndmthd              like rnd_rnd_mthd                no-undo.
define variable oldcurr              like so_curr                     no-undo.
define variable part                 like sod_part                    no-undo.
define variable part1                like sod_part                    no-undo.
define variable nbr                  like so_nbr                      no-undo.
define variable nbr1                 like so_nbr                      no-undo.
define variable due                  like so_due_date                 no-undo.
define variable due1                 like so_due_date                 no-undo.
define variable name                 like ad_name      format "x(20)" no-undo.
define variable desc1                like pt_desc1                    no-undo.
define variable um                   like pt_um                       no-undo.
define variable qty_open             like sod_qty_ord
                                     label "Qty Open"                 no-undo.
define variable base_rpt             like so_curr                     no-undo.
define variable mixed_rpt            like mfc_logical   initial no
                                     label "Mixed Currencies"         no-undo.
define variable disp_curr            as   character
                                     label "C" format "x(1)"          no-undo.
define variable spsn                 like sp_addr                     no-undo.
define variable spsn1                like spsn                        no-undo.
define variable stat                 like so_stat                     no-undo.
define variable stat1                like so_stat                     no-undo.
define variable site                 like so_site                     no-undo.
define variable site1                like so_site                     no-undo.
define variable include_allocated    like mfc_logical initial yes
                                     label "Include Allocated"        no-undo.
define variable include_picked       like mfc_logical initial yes
                                     label "Include Picked"           no-undo.
define variable include_shipped      like mfc_logical initial yes
                                     label "Include Shipped"          no-undo.
define variable include_unprocessed  like mfc_logical initial yes
                                     label "Include Unprocessed"      no-undo.
define variable base_price           like sod_price                   no-undo.
define variable curr_price           like sod_price                   no-undo.
define variable ext_base_price       like sod_price
                                     label "Ext Price"
                                     format "->,>>>,>>>,>>9.99"       no-undo.
define variable ext_base_price_unrnd like sod_price                   no-undo.
define variable ext_curr_price       like sod_price
                                     label "Ext Price"
                                     format "->,>>>,>>>,>>9.99"       no-undo.
define variable ext_curr_price_unrnd like sod_price                   no-undo.
define variable mc-error-number      like msg_nbr                     no-undo.
define variable disp-item-col        as   character     format "x(6)" no-undo.

{gpcurrp.i}

{gprunpdf.i "mcpl" "p"}

form
   part                          colon 15
   part1          label "To"     colon 49 skip
   nbr                           colon 15
   nbr1           label "To"     colon 49 skip
   due                           colon 15
   due1           label "To"     colon 49 skip
   spsn                          colon 15
   spsn1          label "To"     colon 49 skip
   stat                          colon 15
   stat1          label "To"     colon 49 skip
   site                          colon 15
   site1          label "To"     colon 49
   skip(1)
   base_rpt                      colon 22 skip
   mixed_rpt                     colon 22 skip(1)
   include_allocated             colon 22 skip
   include_picked                colon 22 skip
   include_shipped               colon 22 skip
   include_unprocessed           colon 22 skip
with frame a side-labels width 80.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

disp-item-col = getTermLabel("ITEM",4) + ": ".

form
   skip(1)
   disp-item-col
   sod_part
   desc1    format "x(49)"
   skip(1)
with frame itemlbl no-labels width 80 no-box.

disp-item-col:screen-value in frame itemlbl = disp-item-col.

form
   sod_nbr
   so_cust
   name
   sod_line
   sod_qty_all
   sod_qty_pick
   qty_open
   sod_um
   disp_curr
   base_price
   ext_base_price
   sod_due_date
   sod_type
with frame c down width 132 no-box.

/* SET EXTERNAL LABELS */
setFrameLabels(frame c:handle).

oldcurr = "".
{wbrp01.i}

repeat:

   if can-find (first order_wkfl)
   then
      for each order_wkfl
         exclusive-lock:
         delete order_wkfl.
      end. /* FOR EACH order_wkfl */

   if part1 = hi_char
   then
      part1 = "".
   if nbr1 = hi_char
   then
      nbr1 = "".
   if due = low_date
   then
      due = ?.
   if due1 = hi_date
   then
      due1 = ?.
   if spsn1 = hi_char
   then
      spsn1 = "".
   if stat1 = hi_char
   then
      stat1 = "".
   if site1 = hi_char
   then
      site1 = "".

   if c-application-mode <> 'web'
   then
      update
         part              part1
         nbr               nbr1
         due               due1
         spsn              spsn1
         stat              stat1
         site              site1
         base_rpt          mixed_rpt
         include_allocated include_picked
         include_shipped   include_unprocessed
   with frame a.

   {wbrp06.i &command = update
             &fields = "  part              part1
                          nbr               nbr1
                          due               due1
                          spsn              spsn1
                          stat              stat1
                          site              site1
                          base_rpt          mixed_rpt
                          include_allocated include_picked
                          include_shipped   include_unprocessed"
             &frm = "a"}

   if (c-application-mode     <> 'web')
      or  (c-application-mode  = 'web'
      and (c-web-request  begins 'data'))
   then do:

      bcdparm = "".
      {gprun.i ""gpquote.p"" "(input-output bcdparm, 18,
           part,                      part1,
           nbr,                       nbr1,
           string(due),               string(due1),
           spsn,                      spsn1,
           stat,                      stat1,
           site,                      site1,
           base_rpt,                  string(mixed_rpt),
           string(include_allocated), string(include_picked),
           string(include_shipped),   string(include_unprocessed),
           null_char, null_char)"}

      if part1 = ""
      then
         part1 = hi_char.
      if nbr1 = ""
      then
         nbr1 = hi_char.
      if due = ?
      then
         due = low_date.
      if due1 = ?
      then
         due1 = hi_date.
      if spsn1 = ""
      then
         spsn1 = hi_char.
      if stat1 = ""
      then
         stat1 = hi_char.
      if site1 = ""
      then
         site1 = hi_char.

   end. /* IF (c-application-mode  <> 'web') .... */

   /* OUTPUT DESTINATION SELECTION */
   {gpselout.i &printType                = "printer"
               &printWidth               = 132
               &pagedFlag                = " "
               &stream                   = " "
               &appendToFile             = " "
               &streamedOutputToTerminal = " "
               &withBatchOption          = "yes"
               &displayStatementType     = 1
               &withCancelMessage        = "yes"
               &pageBottomMargin         = 6
               &withEmail                = "yes"
               &withWinprint             = "yes"
               &defineVariables          = "yes"}

   {mfphead.i}

   form
      skip(1)
   with frame a1 page-top width 132.
   view frame a1.

   /* GET ORDER DETAIL  */
   for each sod_det
      fields( sod_domain sod_due_date     sod_line
              sod_nbr          sod_part
              sod_price        sod_qty_all
              sod_qty_ord      sod_qty_pick
              sod_qty_ship     sod_sched
              sod_site         sod_slspsn
              sod_type         sod_um
              sod_um_conv)
       where sod_det.sod_domain = global_domain and (  (sod_part      >= part
       and  sod_part       <= part1)
      and    not sod_sched
      and  ((sod_due_date  >= due  and  sod_due_date   <= due1)
         or (sod_due_date   = ?    and (due  = low_date
                                    or  due1 = hi_date)))
      and   (sod_nbr       >= nbr  and  sod_nbr        <= nbr1)
      and   (sod_slspsn[1] >= spsn and  sod_slspsn[1]  <= spsn1)
      and   (sod_site      >= site and  sod_site       <= site1)
      and  ((include_allocated     and  sod_qty_all    <> 0)
         or (include_picked        and  sod_qty_pick   <> 0)
         or (include_shipped       and  sod_qty_ship   <> 0)
         or (include_unprocessed   and  sod_qty_all     = 0
             and sod_qty_pick = 0
             and sod_qty_ship = 0))
      ) no-lock,
         each so_mstr
            fields( so_domain so_curr       so_cust
                    so_ex_rate    so_ex_rate2
                    so_nbr        so_stat)
             where so_mstr.so_domain = global_domain and (  so_nbr  = sod_nbr
            and (so_stat >= stat and so_stat <= stat1)
            and (base_rpt = ""    or base_rpt = so_curr)
            ) no-lock
        break by sod_part by sod_due_date
            with frame c no-attr-space:

      if (oldcurr <> so_curr) or (oldcurr = "")
      then do:

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

      qty_open = sod_qty_ord - sod_qty_ship.

      if sod_qty_ord > 0 and qty_open < 0
      then
         qty_open = 0.

      if sod_qty_ord  < 0
         and qty_open > 0
      then
         qty_open = 0.

      /* SET CURRENCY CONVERTED FLAG */
      disp_curr = "".
      if base_curr        <> so_curr
         and base_rpt     <> so_curr
         and not (base_rpt = "" and mixed_rpt)
      then
         disp_curr = getTermLabel("YES",1).

      /* SET PRICE FOR CURR AND BASE */
      curr_price = sod_price.

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

      /* CALCULATE EXTENDED PRICE AND BASE TOTAL */
      ext_curr_price = qty_open * curr_price.

      /* BASE EQUALS EXT_CURR_PRICE CONVERTED USING SO_EX_RATE */
      /* AND ROUNDING PER BASE ROUND METHOD */

      {gprunp.i "mcpl" "p" "mc-curr-conv"
         "(input  so_curr,
           input  base_curr,
           input  so_ex_rate,
           input  so_ex_rate2,
           input  ext_curr_price,
           input  false,  /* DO NOT ROUND */
           output ext_base_price,
           output mc-error-number)" }
      if mc-error-number <> 0
      then do:
         {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
      end. /* IF mc-error-number <> 0 */

      /* SAVE UNROUNDED VALUES */
      assign
         ext_curr_price_unrnd = ext_curr_price
         ext_base_price_unrnd = ext_base_price.

      {gprunp.i "mcpl" "p" "mc-curr-rnd"
         "(input-output ext_curr_price,
           input        rndmthd,
           output       mc-error-number)" }
      if mc-error-number <> 0
      then do:
         {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
      end. /* IF mc-error-number <> 0 */

      {gprunp.i "mcpl" "p" "mc-curr-rnd"
         "(input-output ext_base_price,
           input        rndmthd,
           output       mc-error-number)" }

      /* ACCUMULATE SUB-TOTALS */
      accumulate ext_curr_price               (total by sod_part).
      accumulate ext_base_price               (total by sod_part).
      accumulate ext_curr_price_unrnd         (total by sod_part).
      accumulate ext_base_price_unrnd         (total by sod_part).
      accumulate (sod_qty_all  * sod_um_conv) (total by sod_part).
      accumulate (sod_qty_pick * sod_um_conv) (total by sod_part).
      accumulate (qty_open     * sod_um_conv) (total by sod_part).

      name = "".
      for first ad_mstr
         fields( ad_domain ad_addr ad_name)
          where ad_mstr.ad_domain = global_domain and  ad_addr = so_cust
         no-lock:
         name = ad_name.
      end. /* FOR FIRST ad_mstr */

      assign
         desc1 = ""
         um    = "".

      for first pt_mstr
         fields( pt_domain pt_desc1 pt_desc2 pt_part pt_um)
          where pt_mstr.pt_domain = global_domain and  pt_part = sod_part
      no-lock:
         assign
            desc1 = pt_desc1 + " " + pt_desc2
            um = pt_um.


      end. /* FOR FIRST pt_mstr */

      if first-of(sod_part)
      then do with frame c:

         if base_rpt = ""
            and mixed_rpt
         then do:
            page.
         end. /* IF base_rpt = "" ... */
         else do:
            if page-size - line-counter < 3
            then
               page.
         end. /* ELSE DO */

         display
            sod_part
            desc1
         with frame itemlbl.
      end. /* IF FIRST-OF(sod_part) */

      /* PRINT DETAIL LINE */
      if base_curr = so_curr
         or (base_rpt = "" and not mixed_rpt)
      then do:
         /* DISPLAY THE ITEM NUMBER ON NEXT PAGE IF NECESSARY */
         if page-size - line-counter < 3
         then do:
            page.
            display
               sod_part
               desc1
            with frame itemlbl.
         end. /* IF PAGE-SIZE - LINE-COUNTER < 3  */
         display
            sod_nbr        so_cust
            name           sod_line
            sod_qty_all    sod_qty_pick
            qty_open       sod_um
            disp_curr      base_price
            ext_base_price sod_due_date
            sod_type
         with frame c.
         down with frame c.
      end. /* IF base_curr = so_curr .... */
      else do:
         /* DISPLAY THE ITEM NUMBER ON NEXT PAGE IF NECESSARY */
         if page-size - line-counter < 3
         then do:
            page.
            display
               sod_part
               desc1
            with frame itemlbl.
         end. /* IF PAGE-SIZE - LINE-COUNTER < 3  */
         display
            sod_nbr
            so_cust name
            sod_line
            sod_qty_all
            sod_qty_pick
            qty_open
            sod_um
            disp_curr
            curr_price     @ base_price
            ext_curr_price @ ext_base_price
            sod_due_date
            sod_type
         with frame c.
         down with frame c.
      end. /* ELSE DO */

      /*  STORE SALES ORDER TOTALS, BY CURRENCY, IN WORK FILE.    */
      if base_rpt = ""
         and mixed_rpt
      then do:
         for first order_wkfl
            fields (ordwk_base ordwk_curr ordwk_for)
            where ordwk_curr = so_curr
            no-lock:
         end. /* FOR FIRST order_wkfl */

         /* IF A RECORD FOR THIS CURRENCY DOESN'T EXIST, CREATE ONE. */
         if not available order_wkfl
         then do:
            create order_wkfl.
            ordwk_curr = so_curr.
         end. /* IF NOT AVAILABLE order_wkfl */

         /* ACCUMULATE INDIVIDUAL CURRENCY TOTALS IN WORK FILE. */
         assign
            ordwk_for  = ordwk_for  + ext_curr_price_unrnd
            ordwk_base = ordwk_base + ext_base_price_unrnd.

      end. /* IF base_rpt = "" .... */

      if last-of(sod_part)
      then do with frame c:

         /* DISPLAY CURRENCY ITEM TOTAL */
         if base_rpt <> ""
         then do:

            /* DISPLAY THE ITEM NUMBER ON NEXT PAGE IF NECESSARY */
            if page-size - line-counter < 3
            then do:
               page.
               display
                  sod_part
                  desc1
               with frame itemlbl.
            end. /* IF PAGE-SIZE - LINE-COUNTER < 3  */

            underline
               sod_qty_all
               sod_qty_pick
               qty_open
               ext_base_price.
            display

               so_curr + " " + getTermLabel("ITEM_TOTAL",15) + ":" @ name
               accum total by sod_part(sod_qty_all * sod_um_conv)
               @ sod_qty_all
               accum total by sod_part(sod_qty_pick * sod_um_conv)
               @ sod_qty_pick
               accum total by sod_part(qty_open * sod_um_conv)
               @ qty_open
               um @ sod_um
               accum total by sod_part (ext_curr_price) @ ext_base_price.
            down with frame c.
         end. /* IF base_rpt <> "" */

         /* DISPLAY BASE ITEM TOTAL */
         if base_rpt = ""
            and not mixed_rpt
         then do:

            /* DISPLAY THE ITEM NUMBER ON NEXT PAGE IF NECESSARY */
            if page-size - line-counter < 3
            then do:
               page.
               display
                  sod_part
                  desc1
               with frame itemlbl.
            end. /* IF PAGE-SIZE - LINE-COUNTER < 3  */

            underline
               sod_qty_all
               sod_qty_pick
               qty_open
               ext_base_price.

            display

               getTermLabel("BASE_ITEM_TOTAL",19) + ":" @ name
               accum total by sod_part(sod_qty_all * sod_um_conv)
               @ sod_qty_all
               accum total by sod_part(sod_qty_pick * sod_um_conv)
               @ sod_qty_pick
               accum total by sod_part(qty_open * sod_um_conv)
               @ qty_open
               um @ sod_um
               accum total by sod_part (ext_base_price)
               @ ext_base_price.
            down with frame c.
         end. /* IF base_rpt = "" .... */

         /* DISPLAY QTY ITEM TOTAL ONLY */
         if base_rpt = ""
            and mixed_rpt
         then do:

            /* DISPLAY THE ITEM NUMBER ON NEXT PAGE IF NECESSARY */
            if page-size - line-counter < 3
            then do:
               page.
               display
                  sod_part
                  desc1
               with frame itemlbl.
            end. /* IF PAGE-SIZE - LINE-COUNTER < 3  */

            underline
               sod_qty_all
               sod_qty_pick
               qty_open.

            display

               getTermLabel("ITEM_TOTAL",19) + ":" @ name
               accum total by sod_part(sod_qty_all * sod_um_conv)
               @ sod_qty_all
               accum total by sod_part(sod_qty_pick * sod_um_conv)
               @ sod_qty_pick
               accum total by sod_part(qty_open * sod_um_conv)
               @ qty_open
               um @ sod_um.
            down with frame c.

            /* IF ALL CURRENCIES, PRINT A SUMMARY REPORT */
            /* BROKEN BY CURRENCY. */
            {gprun.i ""gpcurrp.p""}
            {mfrpchk.i}

            if can-find (first order_wkfl)
            then
               for each order_wkfl
                  exclusive-lock:
                  delete order_wkfl.
               end. /* FOR EACH order_wkfl */
         end. /* IF base_rpt = "" .... */

         if last(sod_part)
         then do with frame c:
            if page-size - line-counter < 3
            then
               page.
            if base_rpt = ""
               and not mixed_rpt
            then do:

               /* DISPLAY BASE TOTAL */
               underline
                  ext_base_price.

               display
                  getTermLabel("BASE_REPORT_TOTAL",19) + ":" @ name
                  accum total (ext_base_price) @ ext_base_price.
               down with frame c.
            end. /* IF base_rpt = "".... */

            if base_rpt <> ""
            then do:

               /* DISPLAY CURRENCY TOTAL */
               underline
                  ext_base_price.

               display
                  so_curr + " " + getTermLabel("REPORT_TOTAL",15) + ":" @ name
                  accum total (ext_curr_price) @ ext_base_price.
               down with frame c.
            end. /* IF base_rpt <> "" */
         end. /* IF LAST(sod_part) */
      end. /* IF LAST-OF(sod_part) */
      {mfrpchk.i}
   end. /* FOR EACH sod_det */

   /* REPORT TRAILER  */
   {mfrtrail.i}

end. /* REPEAT */

{wbrp04.i &frame-spec = a}
