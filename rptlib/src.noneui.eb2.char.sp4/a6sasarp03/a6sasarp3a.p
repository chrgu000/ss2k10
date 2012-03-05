/* sasarp3a.p - SALES BY CUSTOMER REPORT SUBROUTINE                     */
/* Copyright 1986-2003 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/* $Revision: 1.7.1.10 $                                                       */
/*V8:ConvertMode=Report                                                 */
/* REVISION: 6.0      LAST MODIFIED: 06/14/90   BY: MLB *D038*          */
/* REVISION: 6.0      LAST MODIFIED: 10/11/90   BY: MLB *D087*          */
/* REVISION: 6.0      LAST MODIFIED: 10/25/90   BY: MLB *D141*          */
/* REVISION: 6.0      LAST MODIFIED: 04/24/91   BY: MLV *D572*          */
/* REVISION: 6.0      LAST MODIFIED: 09/20/91   BY: MLV *D863*          */
/* REVISION: 7.0      LAST MODIFIED: 04/09/92   BY: tjs *F337*          */
/* REVISION: 7.3      LAST MODIFIED: 11/19/92   By: jcd *G349*          */
/* REVISION: 8.6      LAST MODIFIED: 10/13/97   BY: ckm *K0VN*          */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane    */
/* REVISION: 8.6E     LAST MODIFIED: 04/07/98   BY: *L00M*  DS          */
/* REVISION: 8.6E     LAST MODIFIED: 06/19/98   BY: *L02V* Brenda Milton    */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane */
/* REVISION: 9.1      LAST MODIFIED: 04/28/00   BY: *N09M* Antony Babu      */
/* REVISION: 9.1      LAST MODIFIED: 06/14/00   BY: *L0X4* Abhijeet Thakur  */
/* REVISION: 9.1      LAST MODIFIED: 08/12/00   BY: *N0KN* Mark Brown       */
/* REVISION: 9.1      LAST MODIFIED: 08/29/00   BY: *N0PM* Arul Victoria    */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.7.1.7   BY: Jean Miller           DATE: 11/26/01  ECO: *N0TX*  */
/* Revision: 1.7.1.9   BY: Seema Tyagi           DATE: 04/10/02  ECO: *N1FW*  */
/* $Revision: 1.7.1.10 $  BY: Anitha Gopal          DATE: 02/21/03  ECO: *N285*  */
/* $Revision: 1.7.1.10 $  BY: Bill Jiang          DATE: 09/12/05  ECO: *SS - 20050912*  */
/* $Revision: 1.7.1.10 $  BY: Bill Jiang          DATE: 10/14/05  ECO: *SS - 20051014*  */
/* $Revision: 1.7.1.10 $  BY: Bill Jiang          DATE: 01/06/06  ECO: *SS - 20060106*  */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* SS - 20050817 - B */
{a6sasarp03.i}

define input parameter cust like cm_addr.
define input parameter cust1 like cm_addr.
define input parameter pl like pt_prod_line.
define input parameter pl1 like pt_prod_line.
define input parameter part like pt_part.
define input parameter part1 like pt_part.
define input parameter cmtype like cm_type.
define input parameter cmtype1 like cm_type.
define input parameter region like cm_region.
define input parameter region1 like cm_region.
define input parameter slspsn like sp_addr.
define input parameter slspsn1 like slspsn.
define input parameter lstype like ls_type.

define input parameter mon1 as integer.
define input parameter yr1 like cph_year.
define input parameter show_memo like mfc_logical.
define input parameter et_report_curr like exr_curr1.
/* SS - 20050817 - E */

{mfdeclre.i}

/* EXTERNAL LABEL INCLUDE */
{gplabel.i}

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE sasarp3a_p_4 "Customer Type"
/* MaxLen: Comment: */

&SCOPED-DEFINE sasarp3a_p_7 "Include Memo Items"
/* MaxLen: Comment: */

&SCOPED-DEFINE sasarp3a_p_15 "Summary/Detail"
/* MaxLen: Comment: */

&SCOPED-DEFINE sasarp3a_p_18 "Show Sales"
/* MaxLen: Comment: */

&SCOPED-DEFINE sasarp3a_p_20 "Show Margin"
/* MaxLen: Comment: */

&SCOPED-DEFINE sasarp3a_p_21 "Show Qty"
/* MaxLen: Comment: */

&SCOPED-DEFINE sasarp3a_p_22 "Show Margin %"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

{wbrp02.i}

    /* SS - 20050912 - B */
    /*
define shared variable pl      like pt_prod_line.
define shared variable pl1     like pt_prod_line.
define shared variable part    like pt_part.
define shared variable part1   like pt_part.
define shared variable cust    like cm_addr.
define shared variable cust1   like cm_addr.
define shared variable cmtype  like cm_type label {&sasarp3a_p_4}.
define shared variable cmtype1 like cm_type label {&sasarp3a_p_4}.
define shared variable region  like cm_region.
define shared variable region1 like cm_region.
define shared variable slspsn  like sp_addr.
define shared variable slspsn1 like slspsn.
define shared variable lstype  like ls_type.
define shared variable mon     as   integer format ">9".
define shared variable mon1    as   integer format ">9".
define shared variable yr1     like cph_year.
define shared variable yr      like cph_year.
*/
define shared variable mon     as   integer format ">9".
define shared variable yr      like cph_year.
/* SS - 20050912 - E */

define shared variable monhead   as   character format "x(8)" extent 12 no-undo.
/* SS - 20050912 - B */
/*
define shared variable show_memo like mfc_logical label {&sasarp3a_p_7}.
*/
/* SS - 20050912 - E */

define shared variable sum-yn        like mfc_logical format {&sasarp3a_p_15}
   initial yes.
define shared variable under         as   character format "x(8)" extent 12.
define shared variable disp_qty      like mfc_logical initial yes
   label {&sasarp3a_p_21}.
define shared variable disp_sales    like mfc_logical initial yes
   label {&sasarp3a_p_18}.
define shared variable disp_margin   like mfc_logical initial yes
   label {&sasarp3a_p_20}.
define shared variable disp_marg_per like mfc_logical initial yes
   label {&sasarp3a_p_22}.
define shared variable in_1000s      like mfc_logical.

define variable i              as   integer.
define variable desc1          like pt_desc1.
define variable desc2          like pt_desc2.
define variable um             like pt_um.
define variable pl-desc        like pl_desc.
define variable qty            as   decimal format "->>>>>>9" extent 12 no-undo.
define variable sales          as   decimal format "->>>>>>9" extent 12 no-undo.
define variable cost           as   decimal format "->>>>>>9" extent 12 no-undo.
define variable margin         as   decimal format "->>>>>>9" extent 12 no-undo.
define variable margin_per     as   decimal format "->>>9.9%" extent 12 no-undo.
define variable tot_qty        as   decimal format "->>>,>>>,>>9".
define variable tot_sales      like tot_qty.
define variable l_tot_cost     like tot_qty no-undo.
define variable tot_margin     like tot_qty.
define variable tot_marg_per   as   decimal format "->>>9.9%".

define variable cm_qty         as   decimal format "->>>>>>9" extent 12 no-undo.
define variable cm_sales       as   decimal format "->>>>>>9" extent 12 no-undo.
define variable l_cm_cost      as   decimal format "->>>>>>9" extent 12 no-undo.
define variable cm_margin      as   decimal format "->>>>>>9" extent 12 no-undo.
define variable cm_marg_per    like margin_per.

define variable tot_cm_qty     as   decimal format "->>>>>>>>>>9" no-undo.
define variable tot_cm_sales   as   decimal format "->>>>>>>>>>9" no-undo.
define variable l_tot_cm_cost  as   decimal format "->>>>>>>>>>9" no-undo.
define variable tot_cm_margin  as   decimal format "->>>>>>>>>>9".
define variable tot_cmmarg_per like tot_marg_per.

define variable st_qty         as   decimal format "->>>>>>9" extent 12 no-undo.
define variable st_sales       as   decimal format "->>>>>>9" extent 12 no-undo.
define variable l_st_cost      as   decimal format "->>>>>>9" extent 12 no-undo.
define variable st_margin      as   decimal format "->>>>>>9" extent 12 no-undo.
define variable st_marg_per    like margin_per.

define variable tot_st_qty     as   decimal format "->>>>>>>>>>9" no-undo.
define variable tot_st_sales   as   decimal format "->>>>>>>>>>9" no-undo.
define variable l_tot_st_cost  as   decimal format "->>>>>>>>>>9" no-undo.
define variable tot_st_margin  as   decimal format "->>>>>>>>>>9".
define variable tot_stmarg_per like tot_marg_per.

define variable pl_qty         as   decimal format "->>>>>>9" extent 12 no-undo.
define variable pl_sales       as   decimal format "->>>>>>9" extent 12 no-undo.
define variable l_pl_cost      as   decimal format "->>>>>>9" extent 12 no-undo.
define variable pl_margin      as   decimal format "->>>>>>9" extent 12 no-undo.
define variable pl_marg_per    like margin_per.

define variable tot_pl_qty     as   decimal format "->>>>>>>>>>9" no-undo.
define variable tot_pl_sales   as   decimal format "->>>>>>>>>>9" no-undo.
define variable l_tot_pl_cost  as   decimal format "->>>>>>>>>>9" no-undo.
define variable tot_pl_margin  as   decimal format "->>>>>>>>>>9".
define variable tot_plmarg_per like tot_marg_per.

define variable rpt_qty        like qty.
define variable rpt_sales      like sales.
define variable l_rpt_cost     like cost              no-undo.
define variable rpt_margin     like margin.
define variable rpt_marg_per   like margin_per.
define variable tot_rpt_qty    like tot_pl_qty.
define variable tot_rpt_sales  like tot_pl_sales.
define variable l_tot_rpt_cost like l_tot_pl_cost     no-undo.
define variable tot_rpt_margin like tot_pl_margin.
define variable tot_rpt_marper like tot_marg_per.
define variable l-msg          like msg_mstr.msg_desc no-undo.

/* common euro variables */
{etvar.i  }

/* common euro report variables */
    /* SS - 20050912 - B */
    /*
{etrpvar.i}
    */
    {a6etrpvar.i}
    /* SS - 20050912 - E */

find first soc_ctrl no-lock.

/* SS - 20050912 - B */
/*
form
   header         space (12)
   monhead
   caps(getTermLabelRt("TOTAL",9)) format "x(9)" skip space (10)
   under
   "-----------"  skip
with frame hdr page-top width 132 no-box.

view frame hdr.
*/
/* SS - 20050912 - E */

assign
   tot_rpt_qty    = 0
   tot_rpt_sales  = 0
   l_tot_rpt_cost = 0
   tot_rpt_margin = 0
   tot_rpt_marper = 0
   rpt_qty        = 0
   rpt_sales      = 0
   l_rpt_cost     = 0
   rpt_margin     = 0
   rpt_marg_per   = 0.

/* SS - 20050912 - B */
/*
form header
   getTermLabel("SALES_AND_MARGIN_IN_1000",31) + " " format "x(32)"
   base_curr no-label
with frame footer page-bottom width 80.

if in_1000s
then
   view frame footer.
*/
/* SS - 20050912 - E */

/* MAIN LOOP */
for each cph_hist
   where cph_cust     >= cust
   and   cph_cust     <= cust1
   and   cph_part     >= part
   and   cph_part     <= part1
   and   cph_pl       >= pl
   and   cph_pl       <= pl1
   and   (   cph_year  = yr
          or cph_year  = yr1)
   and   (   cph_type  = ""
          or show_memo = yes)
   no-lock,
   each cm_mstr
   where cm_addr       = cph_cust
   and   cm_type      >= cmtype
   and   cm_type      <= cmtype1
   and   cm_slspsn[1] >= slspsn
   and   cm_slspsn[1] <= slspsn1
   and   cm_region    >= region
   and   cm_region    <= region1
   no-lock
   break by cph_cust
         by cph_ship
         by cph_pl
         by cph_part
   with frame b no-labels no-box width 132:

   {mfrpchk.i}

   if    lstype = ""
     or (lstype <> ""
         and can-find(first ls_mstr
                      where ls_type = lstype
                      and   ls_addr = cm_addr))
   then do:
       /* SS - 20050912 - B */
       /*
      if cph_smonth <> soc_fysm
      then do:
         /* Months inconsistent.  Rerun Fiscal Year Change Program */
         {pxmsg.i &MSGNUM=116 &ERRORLEVEL=3 &MSGBUFFER=l-msg}
         put l-msg format "x(74)" skip.
      end. /* IF cph_smooth <> soc_fysm */
      */
      /* SS - 20050912 - E */

       /* SS - 20050912 - B */
       /*
      if first-of(cph_cust)
      then do:
         find ad_mstr where ad_addr = cph_cust no-lock no-error no-wait.

         if page-size - line-counter < 8
         then
            page.

         put
            skip getTermLabelRtColon("CUSTOMER",13) + " " format "x(14)"
            cph_cust " ".

         if available ad_mstr
         then
            put ad_name skip.

         assign
            tot_cm_qty     = 0
            tot_cm_sales   = 0
            l_tot_cm_cost  = 0
            tot_cm_margin  = 0
            tot_cmmarg_per = 0
            cm_qty         = 0
            cm_sales       = 0
            l_cm_cost      = 0
            cm_margin      = 0
            cm_marg_per    = 0.

      end. /* IF FIRST-OF(cph_cust) */

      if first-of(cph_ship)
      then do:
         find ad_mstr where ad_addr = cph_ship no-lock no-error no-wait.

         if page-size - line-counter < 7
         then
            page.

         put
            skip
            getTermLabelRtColon("SHIP_TO",13) + " " format "x(14)"
            cph_ship " ".

         if available ad_mstr
         then
            put
               ad_name skip.

         assign
            tot_st_qty     = 0
            tot_st_sales   = 0
            l_tot_st_cost  = 0
            tot_st_margin  = 0
            tot_stmarg_per = 0
            st_qty         = 0
            st_sales       = 0
            l_st_cost      = 0
            st_margin      = 0
            st_marg_per    = 0.
      end. /* IF FIRST-OF(cph_ship) */

      if first-of(cph_pl)
      then
         assign
            tot_pl_qty     = 0
            tot_pl_sales   = 0
            l_tot_pl_cost  = 0
            tot_pl_margin  = 0
            tot_plmarg_per = 0
            pl_qty         = 0
            pl_sales       = 0
            l_pl_cost      = 0
            pl_margin      = 0
            pl_marg_per    = 0.
      */
      /* SS - 20050912 - E */

      if first-of(cph_part)
      then
         /* CLEAR VARIABLES */
         assign
            tot_qty      = 0
            tot_sales    = 0
            l_tot_cost   = 0
            tot_margin   = 0
            tot_marg_per = 0
            qty          = 0
            sales        = 0
            margin       = 0
            margin_per   = 0
            cost         = 0.

      /* ACCUMULATES VALUES */
      if cph_year = yr
      then do i = 1 to (13 - mon):

          /* SS - 20050912 - B */
          /*
         qty[i]   = qty[i]   + cph_qty[mon   + i - 1].
         sales[i] = sales[i] + cph_sales[mon + i - 1].
         cost[i]  = cost[i]  + cph_cost[mon  + i - 1].
         */
         /* SS - 20060106 - B */
         /*
         qty[i] = 0.
         sales[i] = 0.
         cost[i] = 0.
         */
         IF MON = 1 THEN DO:
            qty[i]   = qty[i]   + cph_qty[mon   + i - 1].
            sales[i] = sales[i] + cph_sales[mon + i - 1].
            cost[i]  = cost[i]  + cph_cost[mon  + i - 1].
         END.
         ELSE DO:
            qty[i] = 0.
            sales[i] = 0.
            cost[i] = 0.
         END.
         /* SS - 20060106 - E */
         /* SS - 20050912 - E */
      end.
      else
      if cph_year = yr1
        and yr    <> yr1
      then do i = (13 - mon1) to 12:
         qty[i]   = qty[i]   + cph_qty[i   - (12 - mon1) ].
         sales[i] = sales[i] + cph_sales[i - (12 - mon1) ].
         cost[i]  = cost[i]  + cph_cost[i  - (12 - mon1) ].
      end.

      if last-of(cph_part)
      then do:
         do i = 1 to 12:

            if et_report_curr <> base_curr
            then do:
               {gprunp.i "mcpl" "p" "mc-curr-conv"
                  "(input base_curr,
                    input et_report_curr,
                    input et_rate1,
                    input et_rate2,
                    input sales[i],
                    input true,   /* ROUND */
                    output sales[i],
                    output mc-error-number)"}
               if mc-error-number <> 0
               then do:
                  {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
               end.
               {gprunp.i "mcpl" "p" "mc-curr-conv"
                  "(input base_curr,
                    input et_report_curr,
                    input et_rate1,
                    input et_rate2,
                    input cost[i],
                    input true,   /* ROUND */
                    output cost[i],
                    output mc-error-number)"}
               if mc-error-number <> 0
               then do:
                  {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
               end.
            end.  /* if et_report_curr <> base_curr */
         end.  /* do i = 1 to 12 */

         /*ROUND TO NEAREST 1000 IF NECESSARY*/
         /* SS - 20050912 - B */
         /*
         if in_1000s then
         do i = 1 to 12:
            sales[i] = round(sales[i] / 1000,0).
            cost[i]  = round(cost[i]  / 1000,0).
         end.
         */
         /* SS - 20050912 - E */

         /* CALCULATE MARGINS */
         do i = 1 to 12:
            margin[i] = sales[i] - cost[i].
            /* SS - 20050912 - B */
            /*
            if sales[i] = 0
            then
               margin_per[i] = 0.
            else
               margin_per[i] = (margin[i] / sales[i]) * 100.

            if    sales[i] < cost[i]
              and sales[i] < 0
            then
               margin_per[i] = margin_per[i] * -1.
            */
            /* SS - 20050912 - E */
         end. /* DO i = 1 to 12 */

         /* PRINT PART AND MONTHS */
         /* SS - 20050912 - B */
         /*
         if page-size - line-counter < 4 then page.
         view frame hdr.
         */
         /* SS - 20050912 - E */

         if sum-yn = no
         then do:
            desc1 = "".
            find pt_mstr where pt_part = cph_part no-lock no-error no-wait.

            if available pt_mstr
            then
               assign
                  desc1 = pt_desc1
                  desc2 = pt_desc2
                  um    = pt_um.

            /* SS - 20050912 - B */
            /*
            put
               skip(1)
               cph_pl " " cph_part " " um " " desc1 " " desc2
               skip.
            */
            /* SS - 20050912 - E */

         end. /* IF sum-yn = no */

         /* SS - 20050912 - B */
         /*
         else if last-of(cph_pl)
         then do:
            find pl_mstr where pl_prod_line = cph_pl no-lock no-error.
            if available pl_mstr
            then
               pl-desc = pl_desc.
            else
               pl-desc = "".

               /* SS - 20050912 - B */
               /*
            put
                skip(1)
                cph_pl
                "  "
                pl-desc
                skip.
            */
            /* SS - 20050912 - E */
         end. /* ELSE IF LAST-OF(cph_pl) */
         */
         /* SS - 20050912 - E */

         /* TOTAL down - pl ship cust and rpt  */
         /* SS - 20050912 - B */
         /*
         do i = 1 to 12:
            assign
               pl_qty[i]     = pl_qty[i]     + qty[i]
               pl_sales[i]   = pl_sales[i]   + sales[i]
               l_pl_cost[i]  = l_pl_cost[i]  + cost[i]
               pl_margin[i]  = pl_margin[i]  + margin[i]
               st_qty[i]     = st_qty[i]     + qty[i]
               st_sales[i]   = st_sales[i]   + sales[i]
               l_st_cost[i]  = l_st_cost[i]  + cost[i]
               st_margin[i]  = st_margin[i]  + margin[i]
               cm_qty[i]     = cm_qty[i]     + qty[i]
               cm_sales[i]   = cm_sales[i]   + sales[i]
               l_cm_cost[i]  = l_cm_cost[i]  + cost[i]
               cm_margin[i]  = cm_margin[i]  + margin[i]
               rpt_qty[i]    = rpt_qty[i]    + qty[i]
               rpt_sales[i]  = rpt_sales[i]  + sales[i]
               l_rpt_cost[i] = l_rpt_cost[i] + cost[i]
               rpt_margin[i] = rpt_margin[i] + margin[i].
         end. /* DO i = 1 to 12 */
         */
         /* SS - 20050912 - E */

         /* TOTAL across */
         do i = 1 to 12:
            assign
               tot_qty    = tot_qty    + qty[i]
               tot_sales  = tot_sales  + sales[i]
               l_tot_cost = l_tot_cost + cost[i]
               tot_margin = tot_margin + margin[i].
         end. /* DO i = 1 to 12 */

         /* TOTAL across Marg% */
         /* SS - 20050912 - B */
         /*
         if tot_sales = 0
         then
            tot_marg_per = 0.
         else
            tot_marg_per = (tot_margin / tot_sales) * 100.

         if    tot_sales < l_tot_cost
           and tot_sales < 0
         then
            tot_marg_per = tot_marg_per * -1.
         */
         /* SS - 20050912 - E */

         /*DISPLAY*/
         /* SS - 20050912 - B */
         /*
         if  disp_qty = yes
           and sum-yn = no
         then
            display
               getTermLabelRtColon("QUANTITY",8) + "  " format "x(9)"
               qty
               tot_qty to 129
            with frame c no-box no-labels width 132.

         if  disp_sales = yes
           and sum-yn   = no
         then
            display
               getTermLabelRtColon("SALES",8) + "  " format "x(9)"
               sales
               tot_sales to 129
            with frame d no-box no-labels width 132.

         if disp_margin = yes
           and sum-yn   = no
         then
            display
               getTermLabelRtColon("MARGIN",8) + " " format "x(9)"
               margin
               tot_margin to 129
            with frame e no-box no-labels width 132.

         if disp_marg_per = yes
           and sum-yn     = no
         then
            display
               getTermLabelRtColon("MARGIN%",8) + " " format "x(9)"
               margin_per
               tot_marg_per to 129
            with frame f no-box no-labels width 132.
         */
         CREATE tta6sasarp03.
         ASSIGN
             tta6sasarp03_cust = cph_cust
             tta6sasarp03_pl = cph_pl
             tta6sasarp03_part = cph_part
             tta6sasarp03_um = um
             tta6sasarp03_qty12 = qty[12]
             tta6sasarp03_sales12 = sales[12]
             tta6sasarp03_margin12 = margin[12]
             tta6sasarp03_tot_qty = tot_qty
             tta6sasarp03_tot_sales = tot_sales
             tta6sasarp03_tot_margin = tot_margin
             /* SS - 20051014 - B */
             tta6sasarp03_type = cph_type
             /* SS - 20051014 - E */
             .
         /* SS - 20050912 - E */

         /* SS - 20050912 - B */
         /*
         if last-of(cph_pl)
         then do:
            /* Total PL across */
            do i = 1 to 12:
               assign
                  tot_pl_qty    = tot_pl_qty    + pl_qty[i]
                  tot_pl_sales  = tot_pl_sales  + pl_sales[i]
                  l_tot_pl_cost = l_tot_pl_cost + l_pl_cost[i]
                  tot_pl_margin = tot_pl_margin + pl_margin[i].
            end.

            /* Total PL Marg% */
            do i = 1 to 12:
               if pl_sales[i] = 0
               then
                  pl_marg_per[i] = 0.
               else
                  pl_marg_per[i] = (pl_margin[i] / pl_sales[i]) * 100.

               if    pl_sales[i] < l_pl_cost[i]
                 and pl_sales[i] < 0
               then
                  pl_marg_per[i] = pl_marg_per[i] * -1.
            end.

            /* Total Total PL Marg% */
            if tot_pl_sales = 0
            then
               tot_plmarg_per = 0.
            else
               tot_plmarg_per = (tot_pl_margin / tot_pl_sales) * 100.

            if    tot_pl_sales < l_tot_pl_cost
              and tot_pl_sales < 0
            then
               tot_plmarg_per = tot_plmarg_per * -1.

            if page-size - line-counter < 5
            then
               page.

            if sum-yn = no
            then
               display
                  "         "
                  under "-----------" skip
               with frame g no-box no-labels width 132.

            put
               {gplblfmt.i &FUNC=getTermLabel(""PRODUCT_LINE"",16)}
               space(1)
               cph_pl
               space(1)
               {gplblfmt.i &FUNC=getTermLabel(""TOTALS"",12)
               &CONCAT="': '"}
               skip.

            if in_1000s
            then
               put
                  getTermLabelRt("SALES_AND_MARGIN_IN_1000",31) + " "
                  format "x(32)" to 124.

            put
               et_report_curr to 129 skip.

            if disp_qty = yes
            then
               display
                  getTermLabelRtColon("QUANTITY",8) + " " format "x(9)"
                  pl_qty
                  tot_pl_qty to 129
               with frame h no-labels no-box width 132.

            if disp_sales = yes
            then
               display
                  getTermLabelRtColon("SALES",8) + " " format "x(9)"
                  pl_sales
                  tot_pl_sales to 129
               with frame i no-labels no-box width 132.

            if disp_margin = yes
            then
               display
                  getTermLabelRtColon("MARGIN",8) + " " format "x(9)"
                  pl_margin
                  tot_pl_margin to 129
               with frame j no-labels no-box width 132.

            if disp_marg_per = yes
            then
               display
                  getTermLabelRtColon("MARGIN%",8) + " " format "x(9)"
                  pl_marg_per
                  tot_plmarg_per to 129
               with frame k no-labels no-box width 132.

            if last-of(cph_ship)
            then do:
               /* Total Ship-to across */
               do i = 1 to 12:
                  assign
                     tot_st_qty    = tot_st_qty    + st_qty[i]
                     tot_st_sales  = tot_st_sales  + st_sales[i]
                     l_tot_st_cost = l_tot_st_cost + l_st_cost[i]
                     tot_st_margin = tot_st_margin + st_margin[i].
               end.

               /* Total Ship-to Marg% */
               do i = 1 to 12:
                  if st_sales[i] = 0
                  then
                     st_marg_per[i] = 0.
                  else
                     st_marg_per[i] = (st_margin[i] / st_sales[i]) * 100.

                  if    st_sales[i] < l_st_cost[i]
                    and st_sales[i] < 0
                  then
                     st_marg_per[i] = st_marg_per[i] * -1.
               end.

               /* Total Total Ship-to Marg% */
               if tot_st_sales = 0
               then
                  tot_stmarg_per = 0.
               else
                  tot_stmarg_per = (tot_st_margin / tot_st_sales) * 100.

               if    tot_st_sales < l_tot_st_cost
                 and tot_st_sales < 0
               then
                  tot_stmarg_per = tot_stmarg_per * -1.

               if page-size - line-counter < 5
               then
                  page.

               if sum-yn = no
               then
                  display
                     "         " under "-----------" skip
                  with frame gg no-box no-labels width 132.

               put
                  {gplblfmt.i &FUNC=getTermLabel(""SHIP_TO"",14)}
                  space(1)
                  cph_ship
                  space(1)
                  {gplblfmt.i &FUNC=getTermLabel(""TOTALS"",12)
                  &CONCAT="': '"}
                  skip.

               if in_1000s
               then
                  put
                     getTermLabelRt("SALES_AND_MARGIN_IN_1000",31) + " "
                     format "x(32)" to 124.

               put
                  et_report_curr to 129 skip.

               if disp_qty = yes
               then
                  display
                     getTermLabelRtColon("QUANTITY",8) + " " format "x(9)"
                     st_qty
                     tot_st_qty to 129
                  with frame hh no-labels no-box width 132.

               if disp_sales = yes
               then
                  display
                     getTermLabelRtColon("SALES",8) + " " format "x(9)"
                     st_sales
                     tot_st_sales to 129
                  with frame ii no-labels no-box width 132.

               if disp_margin = yes
               then
                  display
                     getTermLabelRtColon("MARGIN",8) + " " format "x(9)"
                     st_margin
                     tot_st_margin to 129
                  with frame jj no-labels no-box width 132.

               if disp_marg_per = yes
               then
                  display
                     getTermLabelRtColon("MARGIN%",8) + " " format "x(9)"
                     st_marg_per
                     tot_stmarg_per to 129
                  with frame kk no-labels no-box width 132.

               if last-of(cph_cust)
               then do:
                  /* Total Ship-to across */
                  do i = 1 to 12:
                     assign
                        tot_cm_qty    = tot_cm_qty    + cm_qty[i]
                        tot_cm_sales  = tot_cm_sales  + cm_sales[i]
                        l_tot_cm_cost = l_tot_cm_cost + l_cm_cost[i]
                        tot_cm_margin = tot_cm_margin + cm_margin[i].
                  end.

                  /* Total Ship-to Marg% */
                  do i = 1 to 12:
                     if cm_sales[i] = 0
                     then
                        cm_marg_per[i] = 0.
                     else
                        cm_marg_per[i] = (cm_margin[i] / cm_sales[i]) * 100.

                     if    cm_sales[i] < l_cm_cost[i]
                       and cm_sales[i] < 0
                     then
                        cm_marg_per[i] = cm_marg_per[i] * -1.
                  end.

                  /* Total Total Ship-to Marg% */
                  if tot_cm_sales = 0
                  then
                     tot_cmmarg_per = 0.
                  else
                     tot_cmmarg_per = (tot_cm_margin / tot_cm_sales) * 100.

                  if    tot_cm_sales < l_tot_cm_cost
                    and tot_cm_sales < 0
                  then
                     tot_cmmarg_per = tot_cmmarg_per * -1.

                  if page-size - line-counter < 5
                  then
                     page.

                  if sum-yn = no
                  then
                     display
                        "         " under "-----------" skip
                     with frame ggg no-box no-labels width 132.

                  put
                     {gplblfmt.i &FUNC=getTermLabel(""CUSTOMER"",16)}
                     space(1)
                     cph_cust
                     space(1)
                     {gplblfmt.i &FUNC=getTermLabel(""TOTALS"",12)
                     &CONCAT="': '"}
                     skip.

                  if in_1000s
                  then
                     put
                        getTermLabelRt("SALES_AND_MARGIN_IN_1000",31) + " "
                        format "x(32)" to 124.

                  put
                     et_report_curr to 129 skip.

                  if disp_qty = yes
                  then
                     display
                        getTermLabelRtColon("QUANTITY",8) + " " format "x(9)"
                        cm_qty
                        tot_cm_qty to 129
                     with frame hhh no-labels no-box width 132.

                  if disp_sales = yes
                  then
                     display
                        getTermLabelRtColon("SALES",8) + " " format "x(9)"
                        cm_sales
                        tot_cm_sales to 129
                     with frame iii no-labels no-box width 132.

                  if disp_margin = yes
                  then
                     display
                        getTermLabelRtColon("MARGIN",8) + " " format "x(9)"
                        cm_margin
                        tot_cm_margin to 129
                     with frame jjj no-labels no-box width 132.

                  if disp_marg_per = yes
                  then
                     display
                        getTermLabelRtColon("MARGIN%",8) + " " format "x(9)"
                        cm_marg_per
                        tot_cmmarg_per to 129
                     with frame kkk no-labels no-box width 132.

               end. /*last-of cph_cust*/

               put skip(1) " ".

            end. /*last-of cph_ship*/

         end.  /*last-of cph_pl*/
         */
         /* SS - 20050912 - E */

      end. /*last-of cph_part*/

   end. /* if lstype */

end. /* for each cph_hist */

/* CALCULATE REPORT TOTALS */
/* SS - 20050912 - B */
/*
do i = 1 to 12:
   if rpt_sales[i] = 0
   then
      rpt_marg_per[i] = 0.
   else
      rpt_marg_per[i] = (rpt_margin[i] / rpt_sales[i]) * 100.

   if    rpt_sales[i] < l_rpt_cost[i]
     and rpt_sales[i] < 0
   then
      rpt_marg_per[i] = rpt_marg_per[i] * -1.
end.

do i = 1 to 12:
   assign
      tot_rpt_qty    = tot_rpt_qty    + rpt_qty[i]
      tot_rpt_sales  = tot_rpt_sales  + rpt_sales[i]
      l_tot_rpt_cost = l_tot_rpt_cost + l_rpt_cost[i]
      tot_rpt_margin = tot_rpt_margin + rpt_margin[i].
end.

if tot_rpt_sales = 0
then
   tot_rpt_marper = 0.
else
   tot_rpt_marper = (tot_rpt_margin / tot_rpt_sales) * 100.

if    tot_rpt_sales < l_tot_rpt_cost
  and tot_rpt_sales < 0
then
   tot_rpt_marper = tot_rpt_marper * -1.

/* DISPLAY RPT TOTALS */
if page-size - line-counter < 5
then
   page.

display
   "         " under "-----------" to 129
with frame p no-labels no-box width 132.

display
   getTermLabel("REPORT_TOTALS",17) + ": " format "x(19)" skip.

if disp_qty = yes
then
   display
      getTermLabelRtColon("QUANTITY",8) + " " format "x(9)"
      rpt_qty
      tot_rpt_qty to 129
   with frame l no-labels no-box width 132.

if disp_sales = yes
then
   display
      getTermLabelRtColon("SALES",8) + " " format "x(9)"
      rpt_sales
      tot_rpt_sales to 129
   with frame m no-labels no-box width 132.

if disp_margin = yes
then
   display
      getTermLabelRtColon("MARGIN",8) + " " format "x(9)"
      rpt_margin
      tot_rpt_margin to 129
   with frame n no-labels no-box width 132.

if disp_marg_per = yes
then
   display
      getTermLabelRtColon("MARGIN%",8) + " " format "x(9)"
      rpt_marg_per
      tot_rpt_marper to 129
   with frame o no-labels no-box width 132.

put skip(1)
   mc-curr-label et_report_curr skip
   mc-exch-label mc-exch-line1 skip
   mc-exch-line2 at 22.

hide frame hdr.
*/
/* SS - 20050912 - E */

{wbrp04.i}
