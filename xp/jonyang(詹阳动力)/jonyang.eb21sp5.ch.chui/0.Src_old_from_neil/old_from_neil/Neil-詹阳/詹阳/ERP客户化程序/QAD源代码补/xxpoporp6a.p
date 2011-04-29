/* GUI CONVERTED from poporp6a.p (converter v1.71) Thu Jul 16 13:58:46 1998 */
/* poporp6a.p - PURCHASE ORDER RECEIPTS REPORT Sort By Po Num               */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK.     */
/*V8:ConvertMode=Report                                            */
/*H0NK** /*F0PN*/ /*V8:ConvertMode=Maintenance                           */ */
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
/****************************************************************************/

/* ********** Begin Translatable Strings Definitions ********* */


/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

         {mfdeclre.i } /*GUI moved to top.*/
&SCOPED-DEFINE poporp6a_p_1 "     报表合计:"
/* MaxLen: Comment: */

&SCOPED-DEFINE poporp6a_p_2 "零件号!评价收货结算选项"
/* MaxLen: Comment: */
&SCOPED-DEFINE poporp6a_p_3 "     基本报表合计:"
/* MaxLen: Comment: */

&SCOPED-DEFINE poporp6a_p_4 "  *** 继续 ***"
/* MaxLen: Comment: */

&SCOPED-DEFINE poporp6a_p_5 "基本采单合计:"
/* MaxLen: Comment: */

&SCOPED-DEFINE poporp6a_p_6 " 采单合计:"
/* MaxLen: Comment: */

&SCOPED-DEFINE poporp6a_p_7 "兑换率:"
/* MaxLen: Comment: */

&SCOPED-DEFINE poporp6a_p_8 "收货量!装箱单量"
/* MaxLen: Comment: */

&SCOPED-DEFINE poporp6a_p_9 "收货!发货日期"
/* MaxLen: Comment: */

&SCOPED-DEFINE poporp6a_p_10 "收货单!装箱单号"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

/*GUI moved mfdeclre/mfdtitle.*/

         {wbrp02.i}

         {poporp06.i} /* INCLUDE FILE FOR SHARED VARIABLES */
         define variable base_std_cost as decimal.
         define variable l_first_of_nbr like mfc_logical no-undo.
         define variable l_first_nbr    like mfc_logical no-undo.
/*L020*/ define variable mc-error-number like msg_nbr no-undo.
/*L020*/ define variable o_disp_line1   as character format "x(80)" no-undo.
/*L020*/ define variable o_disp_line2   as character format "x(80)" no-undo.
         find first gl_ctrl no-lock no-error.
         define variable poders as character format "x(2)" no-undo.
         define input parameter ers-only like mfc_logical no-undo.
         define variable ptdesc1 like pt_desc1.
         define variable ptdesc2 like pt_desc2.
         for each prh_hist
         where (prh_rcp_date >= rdate and prh_rcp_date <= rdate1
         or  (prh_rcp_date = ? and rdate = low_date))
         and (prh_vend >= vendor and prh_vend <= vendor1)
         and (prh_part >= part and prh_part <= part1)
         and (prh_site >= site and prh_site <= site1)
         and (prh_ps_nbr >= fr_ps_nbr and prh_ps_nbr <= to_ps_nbr)
         and ((prh_type = "" and sel_inv = yes)
         or  (prh_type = "S" and sel_sub = yes)
         or  (prh_type <> "" and prh_type <> "S" and sel_mem = yes))
         and ((prh_last_vo = "" and uninv_only = yes)
         or uninv_only = no)
         and (base_rpt = ""
         or base_rpt = prh_curr)
         use-index prh_nbr no-lock break by prh_nbr
         with frame b down width 175 no-box:

         if first-of(prh_nbr) then do:

            l_first_of_nbr  = yes.
            if first (prh_nbr) then
               l_first_nbr  = yes.

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
/*L020*/             leave.
/*L020*/          end.
/*L020*/       end.
               oldcurr = prh_curr.
            end.

            if l_first_of_nbr = yes  or prh_vend <> last_vend then do:

               l_first_of_nbr = no.

               if l_first_nbr  or prh_vend <> last_vend  then do:
                  l_first_nbr = no.
                  put skip(1).
               end.
               else if page-size - line-counter < 7 then do:
                     page.
                     put skip(1).
               end.
               last_vend = prh_vend.
               descname = "".
               find vd_mstr where vd_addr = prh_vend no-lock no-error.
               if available vd_mstr then descname = vd_sort.
               display
                        prh_nbr
                        prh_vend
                        descname no-label
                with frame bhead no-box width 175 STREAM-IO /*GUI*/ .
            end.

            if page-size - line-counter < 0 then do:
               page.
               put skip(1).
               display
                        prh_nbr
                        prh_vend
                        descname + {&poporp6a_p_4} format "x(64)"
                        @ descname
               with frame bhead no-box width 175 STREAM-IO /*GUI*/ .
            end.
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
            find pt_mstr where pt_part = prh_part.
               if available pt_mstr then do :
                  ptdesc1 = pt_desc1.    
                  ptdesc2 = pt_desc2.
               end.
               else do:
                  ptdesc1 = "".
                  ptdesc2 = "".
               end.                                 
            display
                    prh_receiver column-label {&poporp6a_p_10}
                                 format "x(12)"
                    prh_line
                    prh_part
                        column-label {&poporp6a_p_2}
                    ptdesc1                             
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
                     STREAM-IO /*GUI*/ .

            down.
            display prh_ps_nbr @ prh_receiver
                    prh_ps_qty @ qty_open with frame b STREAM-IO /*GUI*/ .

            display poders @ prh_part
                    prh_ship_date @ prh_rcp_date 
                    ptdesc2 @ ptdesc1
                    with frame b STREAM-IO /*GUI*/ .
                   
            if last-of (prh_nbr) and show_sub = yes then do:
               if page-size - line-counter < 3 then do:
                  page.
                  put skip(1).
                  display
                            prh_nbr
                            prh_vend
                            descname + {&poporp6a_p_4} format "x(64)"
                            @ descname
                  with frame bhead no-box width 175 STREAM-IO /*GUI*/ .
               end.
               underline std_ext pur_ext std_var.
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
/*L020*/          put {&poporp6a_p_7} at 10 o_disp_line1 format "x(80)" skip.
/*L020*/          put "          " at 10 o_disp_line2 format "x(80)".
               end.

               put
               (if base_rpt = ""
                then {&poporp6a_p_5}
                else base_rpt + {&poporp6a_p_6})
               format "x(14)" to  84
               accum total by prh_nbr std_ext
                                    format "->>>>>>>>>>9.99<<<<" to 102
               accum total by prh_nbr pur_ext
                                    format "->>>>>>>>>>9.99<<<<" to 118
               accum total by prh_nbr std_var
                                    format "->>>>>>>>9.99<<<<" to 131
               skip(1).
            end.
         end.
         if page-size - line-counter < 4 then do:
            page.
            put skip(1).
         end.
         display
                 "--------------- --------------- ---------------" to 175 
                 (if base_rpt = ""
                  then {&poporp6a_p_3}
                  else base_rpt + {&poporp6a_p_1})
                 format "x(18)"   to 84
                 accum total std_ext format "->>>>>>>>>>9.99<<<<"  to 100
                 accum total pur_ext format "->>>>>>>>>>9.99<<<<"  to 116
                 accum total std_var format "->>>>>>>>>>9.99<<<<"  to 131
                 "=============== =============== ===============" to 131
         with frame g width 175 no-labels no-box STREAM-IO /*GUI*/ .

         /*V8+*/
