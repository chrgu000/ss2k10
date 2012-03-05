/* poporp6a.p - PURCHASE ORDER RECEIPTS REPORT Sort By Po Num               */
/* Copyright 1986-2000 QAD Inc., Carpinteria, CA, USA.                      */
/* All rights reserved worldwide.  This is an unpublished work.             */
/*H0NK*/ /*F0PN*/ /*V8:ConvertMode=Report                                   */
/* REVISION: 7.4    LAST MODIFIED: 12/17/93                 BY: dpm *H074   */
/* REVISION: 7.4    LAST MODIFIED: 09/27/94                 BY: dpm *FR87*  */
/* REVISION: 7.4    LAST MODIFIED: 10/21/94                 BY: mmp *H573*  */
/* REVISION: 8.5    LAST MODIFIED: 11/15/95                 BY: taf *J053*  */
/* REVISION: 8.5    LAST MODIFIED: 02/12/96      BY: *J0CV* Robert Wachowicz*/
/* REVISION: 8.5    LAST MODIFIED: 04/08/96                 BY: jzw *G1LD*  */
/* REVISION: 8.5    LAST MODIFIED: 07/18/96     BY: taf *J0ZS**/
/* REVISION: 8.5    LAST MODIFIED: 10/24/96     BY: *H0NK* Ajit Deodhar     */
/* REVISION: 8.5    LAST MODIFIED: 03/07/97     BY: *J1KL* Suresh Nayak     */
/* REVISION: 8.6    LAST MODIFIED: 10/03/97     BY: mur *K0KK**/
/* REVISION: 8.6E   LAST MODIFIED: 02/23/98     BY: *L007* A. Rahane */
/* REVISION: 8.6E   LAST MODIFIED: 06/11/98     BY: *L020* Charles Yen   */
/* REVISION: 9.0    LAST MODIFIED: 02/06/99     BY: *M06R* Doug Norton      */
/* REVISION: 9.0    LAST MODIFIED: 03/13/99     BY: *M0BD* Alfred Tan       */
/* REVISION: 9.1    LAST MODIFIED: 06/28/99     BY: *N00Q* Sachin Shinde    */
/* REVISION: 9.1    LAST MODIFIED: 12/23/99     BY: *L0N3* Sandeep Rao      */
/* REVISION: 9.1    LAST MODIFIED: 03/06/00     BY: *N05Q* David Morris     */
/* REVISION: 9.1    LAST MODIFIED: 03/24/00     BY: *N08T* Annasaheb Rahane */
/* REVISION: 9.1    LAST MODIFIED: 04/27/00     BY: *N09M* Peter Faherty */
/* REVISION: 9.1    LAST MODIFIED: 06/30/00     BY: *N009* David Morris     */
/* REVISION: 9.1    LAST MODIFIED: 07/20/00     BY: *N0GF* Mudit Mehta      */
/* REVISION: 9.1    LAST MODIFIED: 08/13/00     BY: *N0KQ* myb              */
/* REVISION: 9.1    LAST MODIFIED: 01/18/01     BY: *N0VP* Sandeep P.       */
/****************************************************************************/
/****************************************************************************/

/* 以下为版本历史 */
/* SS - 090317.1 By: Bill Jiang */

/* SS - 090317.1 - B */
{xxpoporp0601.i}
/* SS - 090317.1 - E */

         {mfdeclre.i }
         {gplabel.i} /* EXTERNAL LABEL INCLUDE */

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE poporp6a_p_2 "Item Number!ERS Option"
/* MaxLen: Comment: */

/*N0GF*
 * &SCOPED-DEFINE poporp6a_p_4 "  *** Cont ***"
 * /* MaxLen: Comment: */
 *N0GF*/

&SCOPED-DEFINE poporp6a_p_8 "Recd Qty!Ps Qty"
/* MaxLen: Comment: */

&SCOPED-DEFINE poporp6a_p_9 "Receipt!Ship Date"
/* MaxLen: Comment: */

&SCOPED-DEFINE poporp6a_p_10 "Receiver!PS Nbr"
/* MaxLen: Comment: */


/*N09M* --------- COMMENTED PREPROCESSOR DEFINITIONS ------ *
 *
 * &SCOPED-DEFINE poporp6a_p_1 " Report Total:"
 * /* MaxLen: Comment: */
 *
 * &SCOPED-DEFINE poporp6a_p_3 "Base Report Total:"
 * /* MaxLen: Comment: */
 *
 * &SCOPED-DEFINE poporp6a_p_5 "Base PO Total:"
 * /* MaxLen: Comment: */
 *
 * &SCOPED-DEFINE poporp6a_p_6 " PO Total:"
 * /* MaxLen: Comment: */
 *
 * &SCOPED-DEFINE poporp6a_p_7 "Exch Rate:"
 * /* MaxLen: Comment: */
 *
 *N09M* --------------------------------------------------- */

/* ********** End Translatable Strings Definitions ********* */


         {wbrp02.i}

         {poporp06.i} /* INCLUDE FILE FOR SHARED VARIABLES */
         define variable base_std_cost as decimal.
         define variable l_first_of_nbr as logical no-undo.
         define variable l_first_nbr    as logical no-undo.
/*L020*/ define variable mc-error-number like msg_nbr no-undo.
/*L020*/ define variable o_disp_line1   as character format "x(80)" no-undo.
/*L020*/ define variable o_disp_line2   as character format "x(80)" no-undo.
         find first gl_ctrl no-lock no-error.
         define variable poders as character format "x(2)" no-undo.

         define input parameter ers-only as logical no-undo.

         for each prh_hist
         where (prh_rcp_date >= rdate and prh_rcp_date <= rdate1
         or  (prh_rcp_date = ? and rdate = low_date))
         and (prh_vend >= vendor and prh_vend <= vendor1)
         and (prh_part >= part and prh_part <= part1)
         and (prh_site >= site and prh_site <= site1)
/*N05Q*/ and (prh_project >= pj and prh_project <= pj1)
         and (prh_ps_nbr >= fr_ps_nbr and prh_ps_nbr <= to_ps_nbr)
         and ((prh_type = "" and sel_inv = yes)
         or  (prh_type = "S" and sel_sub = yes)
         or  (prh_type <> "" and prh_type <> "S" and sel_mem = yes))
         and ((prh_last_vo = "" and uninv_only = yes)
         or uninv_only = no)
         and (base_rpt = ""
         or base_rpt = prh_curr)
         use-index prh_nbr no-lock break by prh_nbr
         with frame b down width 132 no-box:

         if first-of(prh_nbr) then do:

            l_first_of_nbr  = yes.
            if first (prh_nbr) then
               l_first_nbr  = yes.

/*N009*/    for first po_mstr
/*N009*/       fields(po_project) no-lock
/*N009*/       where po_nbr = prh_nbr:
/*N009*/    end.
         end. /* IF FIRST-OF prh_nbr */

         if ers-only then do:

          if prh_last_vo = "" then do:
           find pod_det where pod_nbr = prh_nbr and pod_line = prh_line
                              no-lock no-error.
           if available pod_det and pod_ers_opt = 1 then next.
          end. /* IF prh_last_vo = "" */
          else
          if  prh_ers_status <> 2 then  next.

         end. /* IF ERS ONLY */

            if (oldcurr <> prh_curr) or (oldcurr = "") then do:
/*L020*        {gpcurmth.i */
/*L020*     "prh_curr" */
/*L020*     "4" */
/*L020*     "leave" */
/*L020*     "pause" } */
/*L020*/       if prh_curr = gl_base_curr then
/*L020*/          rndmthd = gl_rnd_mthd.
/*L020*/       else do:
/*L020*/          /* GET ROUNDING METHOD FROM CURRENCY MASTER */
/*L020*/          {gprunp.i "mcpl" "p" "mc-get-rnd-mthd"
                   "(input prh_curr,
                     output rndmthd,
                     output mc-error-number)"}
/*L020*/          if mc-error-number <> 0 then do:
/*L020*/             {mfmsg.i mc-error-number 4}
/*L020*/             if c-application-mode <> "WEB":U then
/*L020*/                pause.
/*L0N3** /*L020*/    leave. */
/*L0N3*/             next.
/*L020*/          end.
/*L020*/       end.
               oldcurr = prh_curr.
            end.

/*N05Q*/    /* **** BEGIN NEW CODE **** */
/*N009*/    /* RETRIEVE THE PROJECT FROM THE PURCHASE ORDER HEADER */
/*N009*/    if available po_mstr then
               for first pj_mstr
                  fields (pj_project pj_desc) no-lock
/*N009*           where pj_project = prh_project: */
/*N009*/          where pj_project = po_project:
               end.
/*N05Q*/    /* **** END NEW CODE **** */

         do with frame bhead:
            if l_first_of_nbr = yes  or prh_vend <> last_vend then do:

               l_first_of_nbr = no.

               if l_first_nbr  or prh_vend <> last_vend  then do:
                  l_first_nbr = no.
                  /* SS - 090317.1 - B
                  put skip(1).
                  SS - 090317.1 - E */
               end.
               /* SS - 090317.1 - B
               else if page-size - line-counter < 7 then do:
                     page.
                     put skip(1).
               end.
               SS - 090317.1 - E */
               last_vend = prh_vend.
               descname = "".
               find vd_mstr where vd_addr = prh_vend no-lock no-error.
               if available vd_mstr then descname = vd_sort.
               /* SET EXTERNAL LABELS */
               setFrameLabels(frame bhead:handle).
               /* SS - 090317.1 - B
               display
                        prh_nbr
                        prh_vend
                        descname no-label
               with frame bhead no-box width 132.
/*N05Q*/       /* **** BEGIN NEW CODE **** */
               if available pj_mstr then
                  display
                     pj_project
                     pj_desc no-label
                  with frame bhead.
               SS - 090317.1 - E */
/*N05Q*/       /* **** END NEW CODE **** */
            end.

            /* SS - 090317.1 - B
            if page-size - line-counter < 0 then do:
               page.
               put skip(1).

/*N05Q*        **** BEGIN DELETED CODE ****
 *             display
 *                      prh_nbr
 *                      prh_vend
 *                      descname + {&poporp6a_p_4} format "x(64)"
 *                      @ descname
 *             with frame bhead no-box width 132.
 *N05Q*        **** END DELETED CODE ****/

/*N05Q*/       /* **** BEGIN NEW CODE **** */
               if available pj_mstr then
                  display
                     prh_nbr
                     prh_vend
                     descname
                     pj_project
                     pj_desc      no-label
                  with frame bhead.
               else
                  display
                     prh_nbr
                     prh_vend
                     descname
                     "" @ pj_project
                     "" @ pj_desc no-label
/*N0GF*              {&poporp6a_p_4} */
/*N0GF*/             "  " + dynamic-function('getTermLabelFillCentered' in h-label,
/*N0GF*/              input "CONTINUE", input 12, input '*') format "x(14)"
                  with frame bhead.
/*N05Q*/       /* **** END NEW CODE **** */

            end.
            SS - 090317.1 - E */
            /* PRH_PUR_STD IS IN BASE CURRENCY */
            std_cost = prh_pur_std.
            if prh_type = ""  then std_cost = prh_mtl_std.
            if use_tot = yes or prh_type = "S"  then std_cost = prh_pur_std.

            /* SAVE THE BASE CURRENCY STANDARD UNIT COST */
            base_std_cost = std_cost.
            /* IF RPT NOT IN BASE AND PRH_CURR DIFF THEN CONVERT THE STD_COST*/
            /* TO DOCUMENT CURRENCY */
            if base_rpt <> ""
            and prh_curr <> base_curr then
/*N00Q*/    do:
/*L020*        std_cost = std_cost * prh_ex_rate. */
/*L020*/       /* CONVERT FROM BASE TO FOREIGN CURRENCY */
/*L020*/       {gprunp.i "mcpl" "p" "mc-curr-conv"
                "(input base_curr,
                  input prh_curr,
                  input prh_ex_rate2,
                  input prh_ex_rate,
                  input std_cost,
                  input false, /* DO NOT ROUND */
                  output std_cost,
                  output mc-error-number)"}.
/*N00Q*/       if mc-error-number <> 0 then do:
/*N00Q*/          {mfmsg.i mc-error-number 2}
/*N00Q*/       end.
/*N00Q*/    end. /* IF BASE_RPT <> "" AND PRH_CURR <> BASE_CURR */

            /* ALWAYS BEGIN WITH THE DOCUMENT CURRENCY UNIT COST */
            base_cost = prh_curr_amt.
            disp_curr = "".

            /* NO NEED FOR CONVERSION BASE_COST = DOC CURR UNIT COST */

            if base_rpt = ""
            and prh_curr <> base_curr then do:
               /* IF BASE RPT, SET BASE_COST TO BASE FOR DISPLAY ONLY */
               base_cost = prh_pur_cost.
               disp_curr = "Y".
            end.
            if uninv_only then
                              qty_open = (prh_rcvd - prh_inv_qty) * prh_um_conv.
                          else qty_open = prh_rcvd * prh_um_conv.

            /* CALCULATE THE EXTENDED STANDARD COST FIRST IN BASE CURRENCY */
            /* BECAUSE STD COST IS ALWAYS STORED IN BASE */
            std_ext = base_std_cost * qty_open.
            /* ROUND PER BASE CURRENCY ROUND METHOD */
/*L020*     {gprun.i ""gpcurrnd.p"" "(input-output std_ext, */
/*L020*/    {gprunp.i "mcpl" "p" "mc-curr-rnd"
             "(input-output std_ext,
               input gl_rnd_mthd,
/*L020*/       output mc-error-number)"}
            /* CONVERT STD_EXT TO DOCUMENT CURRENCY IF NECESSARY */
            if base_rpt <> ""
            and prh_curr <> base_curr
            then do:
/*L020*         std_ext = std_ext * prh_ex_rate. */
/*L020*/        /* CONVERT FROM BASE TO FOREIGN CURRENCY */
/*L020*/        {gprunp.i "mcpl" "p" "mc-curr-conv"
                 "(input base_curr,
                   input prh_curr,
                   input prh_ex_rate2,
                   input prh_ex_rate,
                   input std_ext,
                   input true, /* DO ROUND */
                   output std_ext,
                   output mc-error-number)"}.
/*L020*/       if mc-error-number <> 0 then do:
/*L020*/          {mfmsg.i mc-error-number 2}
/*L020*/       end.
                /* ROUND PER DOC CURRENCY ROUND METHOD */
/*L020*         {gprun.i ""gpcurrnd.p"" "(input-output std_ext,
*                input rndmthd)"}
*L020*/
            end.

            /* CALCULATE THE EXTENDED PUR COST IN DOCUMENT CURRENCY */
            pur_ext = prh_curr_amt * qty_open.
            /* ROUND PER DOCUMENT CURRENCY ROUND METHOD */
/*L020*     {gprun.i ""gpcurrnd.p"" "(input-output pur_ext, */
/*L020*/    {gprunp.i "mcpl" "p" "mc-curr-rnd"
             "(input-output pur_ext,
               input rndmthd,
/*L020*/       output mc-error-number)"}
            /* CONVERT PUR EXT AMT TO BASE IF NECESSARY */
            if base_rpt = ""
            and prh_curr <> base_curr then do:
/*L020*         pur_ext = pur_ext / prh_ex_rate. */
/*L020*/        /* CONVERT FROM FOREIGN TO BASE CURRENCY */
/*L020*/        {gprunp.i "mcpl" "p" "mc-curr-conv"
                 "(input prh_curr,
                   input base_curr,
                   input prh_ex_rate,
                   input prh_ex_rate2,
                   input pur_ext,
                   input true, /* DO ROUND */
                   output pur_ext,
                   output mc-error-number)"}.
/*L020*/       if mc-error-number <> 0 then do:
/*L020*/          {mfmsg.i mc-error-number 2}
/*L020*/       end.
                /* ROUND PER BASE CURRENCY ROUND METHOD */
/*L020*         {gprun.i ""gpcurrnd.p"" "(input-output pur_ext,
*                input gl_rnd_mthd,
*L020*/
            end.

            std_var = pur_ext - std_ext.
            if prh_type <> "" and prh_type <> "S" then do:
               std_cost = 0.
               std_ext  = 0.
               std_var  = 0.
            end.
            accumulate std_ext (total by prh_nbr).
            accumulate pur_ext (total by prh_nbr).
            accumulate std_var (total by prh_nbr).

            find pod_det where pod_nbr = prh_nbr and pod_line = prh_line
               no-lock no-error.
            if available pod_det then poders = string(pod_ers_opt,">9").

            /* SET EXTERNAL LABELS */
            setFrameLabels(frame b:handle).
            /* SS - 090317.1 - B
            display
                    prh_receiver column-label {&poporp6a_p_10}
                                 format "x(12)"
                    prh_line
                    prh_part
                        column-label {&poporp6a_p_2}
                    prh_rcp_date
                        column-label {&poporp6a_p_9}
                    qty_open
                    format "->>>>>>9.9<<<<<<" column-label {&poporp6a_p_8}
                    prh_rcp_type
                    std_cost
                    disp_curr
                    base_cost
                    std_ext
                    pur_ext
                    std_var
            with frame b
                    .

/*N0VP**    down. */
/*N0VP*/    down with frame b.

            display prh_ps_nbr @ prh_receiver
                    prh_ps_qty @ qty_open with frame b.

            display poders @ prh_part
                    prh_ship_date @ prh_rcp_date with frame b.
            SS - 090317.1 - E */

            /* SS - 090317.1 - B */
            CREATE ttxxpoporp0601.

            ASSIGN 
               ttxxpoporp0601_prh_nbr = prh_nbr
               ttxxpoporp0601_prh_vend = prh_vend
               ttxxpoporp0601_descname = descname
               .

            IF AVAILABLE pj_mstr THEN DO:
               ASSIGN
                  ttxxpoporp0601_pj_project = pj_project
                  ttxxpoporp0601_pj_desc = pj_desc
                  .
            END.

            ASSIGN 
               ttxxpoporp0601_prh_receiver = prh_receiver
               ttxxpoporp0601_prh_line = prh_line
               ttxxpoporp0601_prh_part = prh_part
               ttxxpoporp0601_prh_rcp_date = prh_rcp_date
               ttxxpoporp0601_qty_open = qty_open
               ttxxpoporp0601_prh_rcp_type = prh_rcp_type
               ttxxpoporp0601_std_cost = std_cost
               ttxxpoporp0601_disp_curr = DISP_curr
               ttxxpoporp0601_base_cost = base_cost
               ttxxpoporp0601_std_ext = std_ext
               ttxxpoporp0601_pur_ext = pur_ext
               ttxxpoporp0601_std_var = std_var

               ttxxpoporp0601_prh_ps_nbr = prh_ps_nbr
               ttxxpoporp0601_prh_ps_qty = prh_ps_qty
               ttxxpoporp0601_poders = poders
               ttxxpoporp0601_prh_ship_date = prh_ship_date

               ttxxpoporp0601_prh_curr = prh_curr
               ttxxpoporp0601_base_curr = base_curr
               ttxxpoporp0601_prh_ex_rate = prh_ex_rate
               ttxxpoporp0601_prh_ex_rate2 = prh_ex_rate2
               ttxxpoporp0601_prh_exru_seq = prh_exru_seq

               ttxxpoporp0601_prh_curr_amt = prh_curr_amt
               ttxxpoporp0601_prh_um_conv = prh_um_conv
               ttxxpoporp0601_prh_pur_cost = prh_curr_amt * prh_um_conv
               .

            if uninv_only THEN DO:
               ASSIGN 
                  ttxxpoporp0601_prh_rcvd = prh_rcvd - prh_inv_qty
                  .
            END.
            else DO:
               ASSIGN 
                  ttxxpoporp0601_prh_rcvd = prh_rcvd
                  .
            END.
            /* SS - 090317.1 - E */

            if last-of (prh_nbr) and show_sub = yes then do:
               /* SS - 090317.1 - B
               if page-size - line-counter < 3 then do:
                  page.
                  put skip(1).

/*N05Q*        **** BEGIN DELETED CODE ****
 *             display
 *                      prh_nbr
 *                      prh_vend
 *                      descname + {&poporp6a_p_4} format "x(64)"
 *                      @ descname
 *             with frame bhead no-box width 132.
 *N05Q*        **** END DELETED CODE ****/

/*N05Q*/          /* **** BEGIN NEW CODE **** */
                  if available pj_mstr then
                     display
                        prh_nbr
                        prh_vend
                        descname
                        pj_project
                        pj_desc       no-label
                     with frame bhead.
                  else
                     display
                        prh_nbr
                        prh_vend
                        descname
                        "" @ pj_project
                        "" @ pj_desc no-label
/*N0GF*                {&poporp6a_p_4} */
/*N0GF*/        "  " + dynamic-function('getTermLabelFillCentered' in h-label,
/*N0GF*/        input "CONTINUE",  input 12,  input '*') format "x(14)"
                     with frame bhead.
/*N05Q*/          /* **** END NEW CODE **** */

               end.

/*N0VP**       underline std_ext pur_ext std_var. */
/*N0VP*/       underline std_ext pur_ext std_var
/*N0VP*/          with frame b.
               SS - 090317.1 - E */

/*N0VP*/ /* END MOVED AFTER THE END OF IF LAST-OF (prh_nbr) CONDITION */
/*N0VP** end. /* DO WITH */                                           */

               if prh_curr <> base_curr then do:
/*L020*           {gpgtex7.i  &ent_curr = base_curr */
/*L020*                       &curr = prh_curr */
/*L020*                       &exch_from = prh_ex_rate */
/*L020*                       &exch_to = exdrate} */
                  assign exdrate = prh_ex_rate
                         exdrate2 = prh_ex_rate2.
/*L020*           put {&poporp6a_p_7} at 10 exdrate. */
/*L020*/       /* CALL MCUI.P TO FORMAT OUTPUT LINE */
/*L020*/          {gprunp.i "mcui" "p" "mc-ex-rate-output"
                   "(input prh_curr,
                     input base_curr,
                     input prh_ex_rate,
                     input prh_ex_rate2,
                     input prh_exru_seq,
                     output o_disp_line1,
                     output o_disp_line2)"}.
/* SS - 090317.1 - B
/*N09M* /*L020*/  put {&poporp6a_p_7} at 10 o_disp_line1 format "x(80)" skip.*/
/*N09M*/          put {gplblfmt.i
              &FUNC=getTermLabel(""EXCHANGE_RATE"",10) &CONCAT="':'"} at 10
              o_disp_line1 format "x(80)" skip.
/*L020*/          put "          " at 10 o_disp_line2 format "x(80)".
SS - 090317.1 - E */
               end.

               /* SS - 090317.1 - B
               put
               (if base_rpt = ""
/*N09M*         then {&poporp6a_p_5}
                else base_rpt + {&poporp6a_p_6}) */
/*N09M*/        then getTermLabel("BASE_PURCHASE_ORDER_TOTAL",13) + ":"
                else base_rpt + getTermLabel("PURCHASE_ORDER_TOTAL",13) + ":")
               format "x(14)" to  84
               accum total by prh_nbr std_ext
                                    format "->>>>>>>>>>9.99<<<<" to 102
               accum total by prh_nbr pur_ext
                                    format "->>>>>>>>>>9.99<<<<" to 118
               accum total by prh_nbr std_var
                                    format "->>>>>>>>9.99<<<<" to 131
               skip(1).
               SS - 090317.1 - E */
            end.

/*N0VP*/ end. /* DO WITH */

         end.
         /* SS - 090317.1 - B
         if page-size - line-counter < 4 then do:
            page.
            put skip(1).
         end.
         display
                 "--------------- --------------- ---------------" to 132
                 (if base_rpt = ""
/*N09M*           then {&poporp6a_p_3}
                  else base_rpt + {&poporp6a_p_1}) */
/*N09M*/      then getTermLabel("BASE_REPORT_TOTAL",20) + ":"
          else base_rpt + getTermLabel("REPORT_TOTAL",15) + ":")
                 format "x(18)"   to 84
                 accum total std_ext format "->>>>>>>>>>9.99<<<<"  to 100
                 accum total pur_ext format "->>>>>>>>>>9.99<<<<"  to 116
                 accum total std_var format "->>>>>>>>>>9.99<<<<"  to 132
                 "=============== =============== ===============" to 132
         with frame g width 132 no-labels no-box.
/*N09M*         SET EXTERNAL LABELS                                    */
/*N09M*/        setFrameLabels(frame g:handle).
         SS - 090317.1 - E */

         /*V8-*/
         {wbrp04.i}
         /*V8+*/
