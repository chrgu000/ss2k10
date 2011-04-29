/* GUI CONVERTED from popoiq02.p (converter v1.71) Thu Jul 16 13:58:00 1998 */
/* popoiq02.p - PURCHASE ORDER RECEIPT HISTORY INQUIRY                  */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/* web convert popoiq02.p (converter v1.00) Fri Oct 10 13:57:51 1997 */
/* web tag in popoiq02.p (converter v1.00) Mon Oct 06 14:18:29 1997 */
/*F0PN*/ /*K1L2*/ /*V8#ConvertMode=WebReport                            */
/*V8:ConvertMode=Report                                        */
/*K1Q4*/ /*V8:WebEnabled=No                                             */
/*               (replaced mfpoiq01.p which used tr_hist)     */
/* REVISION: 4.0     LAST MODIFIED: 04/15/88    BY: FLM *A108**/
/* REVISION: 4.0     LAST MODIFIED: 12/30/87    BY: WUG *A137**/
/* REVISION: 4.0     LAST MODIFIED: 12/09/88    BY: RL  *C0028*/
/* REVISION: 5.0     LAST MODIFIED: 05/03/89    BY: WUG *B098**/
/* REVISION: 5.0     LAST MODIFIED: 06/29/89    BY: RL  *B166**/
/* REVISION: 6.0     LAST MODIFIED: 05/24/90    BY: WUG *D002**/
/* REVISION: 6.0     LAST MODIFIED: 08/14/90    BY: RAM *D030**/
/* REVISION: 6.0     LAST MODIFIED: 09/19/91    BY: RAM *D868**/
/* Revision: 7.3     LAST MODIFIED: 11/19/92    By: jcd *G339* */
/* REVISION: 7.3     LAST MODIFIED: 09/20/94    BY: jpm *GM74**/
/* REVISION: 7.3     LAST MODIFIED: 11/07/94    BY: ljm *GO15**/
/* REVISION: 7.4     LAST MODIFIED: 04/10/96    BY: jzw *G1LD**/
/* REVISION: 7.4     LAST MODIFIED: 11/19/96    BY: *H0PG* Suresh Nayak */
/* REVISION: 7.4     LAST MODIFIED: 03/24/97    BY: *H0VG* Aruna Patil  */
/* REVISION: 8.6     LAST MODIFIED: 03/09/98    BY: *K1L2* Beena Mol    */
/* REVISION: 8.6     LAST MODIFIED: 05/20/98    BY: *K1Q4* Alfred Tan   */
/* REVISION: 8.6     LAST MODIFIED: 03/09/98    BY: *K1L2* Beena Mol    */
/* REVISION: 8.6     LAST MODIFIED: 05/20/98    BY: *K1Q4* Alfred Tan   */
/* REVISION: 8.6     LAST MODIFIED: 06/03/98    BY: *K1RS* A.Shobha     */
/* REVISION: 8.6E    LAST MODIFIED: 07/08/98    BY: *L020* Charles Yen   */


/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

         {mfdtitle.i "e+ "}

/*L020*/ define variable mc-error-number like msg_nbr no-undo.

     define variable vend like po_vend.
     define variable nbr like po_nbr.
     define variable sord like pod_so_job.
     define variable part like pt_part.
     define variable receiver like prh_receiver.
     define variable rcp_date like prh_rcp_date.
     define variable base_cost like prh_pur_cost.
     define variable base_rpt like po_curr.
     define variable disp_curr as character format "x(1)" label "C".
     define variable PROD_LINE like PT_PROD_LINE.

     part = global_part.

     
/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
        part
                  view-as fill-in size 10 by 1 space(.5)   
        PROD_LINE SPACE(5)                  
        nbr
                  space(.5)   
        vend
                  space(.5)   
        receiver
                  view-as fill-in size 8 by 1 space(.5)   
        rcp_date
                  view-as fill-in size 8 by 1 space(.5)   
        sord
                  space(.5)   
        base_rpt
                  view-as fill-in size 5 by 1   
     with frame a width 80 no-underline no-attr-space THREE-D /*GUI*/.

/*GUI preprocessor Frame A undefine */
&UNDEFINE PP_FRAME_NAME



/*K1L2*/ {wbrp01.i}

         repeat:

/*K1L2*/  if c-application-mode <> "WEB":U then
           update part PROD_LINE nbr vend receiver rcp_date sord base_rpt
        with frame a editing:

           if frame-field = "part" then do:
          /* FIND NEXT/PREVIOUS RECORD */
          {mfnp.i pod_det part pod_part part pod_part pod_part}
          if recno <> ? then do:
             part = pod_part.
             display part with frame a.
             recno = ?.
          end.
           end.
           else do:
          status input.
          readkey.
          apply lastkey.
           end.
        end.

/*L020*/ /* CURRENCY CODE VALIDATION */
/*L020*/ if base_rpt <> "" then do:
/*L020*/ {gprunp.i "mcpl" "p" "mc-chk-valid-curr"
          "(input input base_rpt,
           output mc-error-number)"}
/*L020*/ if mc-error-number <> 0 then do:
/*L020*/    {mfmsg.i mc-error-number 3} /* INVALID CURRENCY */
/*L020*/    next-prompt base_rpt.
/*L020*/    next.
/*L020*/ end.
/*L020*/ end.

/*K1L2*/ {wbrp06.i &command = update &fields = "  part PROD_LINE nbr vend receiver
          rcp_date sord base_rpt" &frm = "a"}

/*K1L2*/ if (c-application-mode <> "WEB":U) or
/*K1L2*/ (c-application-mode = "WEB":U and
/*K1L2*/ (c-web-request begins "DATA":U)) then do:

        hide frame b.
        hide frame c.
        hide frame d.
        hide frame e.
        hide frame f.
        hide frame g.
        hide frame h.

/*K1L2*/ end.

        /* SELECT PRINTER */
           {mfselprt.i "terminal" 80}

        if part <> "" then
        repeat for prh_hist with frame b width 100 on endkey undo, leave:
           find prev prh_hist where prh_part = part
           and (vend = "" or prh_vend = vend)
           and (nbr = "" or prh_nbr = nbr)
           and (receiver = "" or prh_receiver = receiver)
           and (rcp_date = ? or prh_rcp_date = rcp_date)
       and (base_rpt = prh_curr
               or base_rpt = "")
           no-lock.
           if available prh_hist then do:

          base_cost = prh_pur_cost.
      disp_curr = "".
      if prh_curr <> base_curr then do:
                     if base_rpt <> "" then
/*L020*     base_cost = base_cost * prh_ex_rate. */
/*L020*/    /* CONVERT FROM BASE TO FOREIGN CURRENCY */
/*L020*/    do:
/*L020*/     {gprunp.i "mcpl" "p" "mc-curr-conv"
             "(input base_curr,
               input prh_curr,
               input prh_ex_rate2,
               input prh_ex_rate,
               input base_cost,
               input false, /* DO NOT ROUND */
               output base_cost,
               output mc-error-number)"}.
/*L020*/     end.
         else disp_curr = "Y".
          end.

              if sord <> "" then do:
                      find pod_det where pod_nbr = prh_nbr
                            and pod_line = prh_line
                          and pod_so_job = sord no-lock no-error.
                       

                     if not available pod_det then next.
                  end. /* IF sord <> "" */
if sord = "" then do:
find pod_det where pod_nbr = prh_nbr no-lock no-error.
end.
          display
             prh_vend
             prh_nbr
              pod_qty_ord
             prh_rcvd * prh_um_conv
             @ prh_rcvd format "->>>>>>9.99<<<<<<"
             prh_rcp_type
             base_cost @ prh_pur_cost
             disp_curr
             prh_rcp_date
             prh_receiver
             prh_site WITH STREAM-IO /*GUI*/ .
           end.
        end.

        else if nbr <> "" then
        loopc:
        for each prh_hist where (prh_nbr = nbr) no-lock
        with frame c width 100 on endkey undo, leave loopc:
               
/*GUI*/ {mfguichk.i } /*Replace mfrpchk*/

           if (vend = "" or prh_vend = vend)
           and (receiver = "" or prh_receiver = receiver)
           and (rcp_date = ? or prh_rcp_date = rcp_date)
       and (base_rpt = prh_curr
               or base_rpt = "")
           then do:
          base_cost = prh_pur_cost.
      disp_curr = "".
      if prh_curr <> base_curr then do:
                     if base_rpt <> "" then
/*L020*     base_cost = base_cost * prh_ex_rate. */
/*L020*/    /* CONVERT FROM BASE TO FOREIGN CURRENCY */
/*L020*/    do:
/*L020*/     {gprunp.i "mcpl" "p" "mc-curr-conv"
             "(input base_curr,
               input prh_curr,
               input prh_ex_rate2,
               input prh_ex_rate,
               input base_cost,
               input false, /* DO NOT ROUND */
               output base_cost,
               output mc-error-number)"}.
/*L020*/     end.
         else disp_curr = "Y".
          end.

              if sord <> "" then do:
                      find pod_det where pod_nbr = prh_nbr
                          and pod_line   = prh_line
                          and pod_so_job = sord no-lock no-error.
                   if not available pod_det then next.
                  end. /* IF sord <> "" */
if sord = "" then do:
find pod_det where pod_nbr = prh_nbr no-lock no-error.
end.
find pT_MSTR WHERE pT_PART  = prh_PART AND (PT_PROD_LINE = PROD_LINE OR PROD_LINE = "") no-lock no-error.

IF available  pT_MSTR THEN display
             prh_part
             PT_PROD_LINE
                pod_qty_ord
             prh_rcvd * prh_um_conv
             @ prh_rcvd format "->>>>>>9.99<<<<<<"
             prh_rcp_type
             base_cost @ prh_pur_cost format "->>>>,>>>,>>9.99<<<"
             disp_curr
             prh_rcp_date
             prh_receiver
             prh_site WITH STREAM-IO /*GUI*/ .
           end.
        end.

        else if vend <> "" then
        repeat for prh_hist with frame d width 150 on endkey undo, leave:
           find prev prh_hist where prh_vend = vend
           and (receiver = "" or prh_receiver = receiver)
           and (rcp_date = ? or prh_rcp_date = rcp_date)
       and (base_rpt = prh_curr
               or base_rpt = "")
           no-lock.
           if available prh_hist then do:
              base_cost = prh_pur_cost.

              if sord <> "" then do:
                      find pod_det where pod_nbr = prh_nbr
                          and pod_line   = prh_line
                          and pod_so_job = sord no-lock no-error.
                   if not available pod_det then next.
                  end.  /* IF sord <> "" */
if sord = "" then do:
find pod_det where pod_nbr = prh_nbr no-lock no-error.
end.
find pT_MSTR WHERE pT_PART  = prh_PART AND (PT_PROD_LINE = PROD_LINE OR PROD_LINE = "") no-lock no-error.

   IF available  PT_MSTR THEN  display
             prh_nbr
             prh_part
             PT_PROD_LINE
                 pod_qty_ord
             prh_rcvd * prh_um_conv @ prh_rcvd
             base_cost @ prh_pur_cost format "->>>>,>>>,>>9.99<<<"

             prh_rcp_type
             prh_rcp_date
             prh_receiver
             prh_site WITH STREAM-IO /*GUI*/ .
           find pod_det where pod_nbr = prh_nbr
           and pod_line = prh_line
              and (sord = "" or pod_so_job = sord) no-lock no-error.
           if available pod_det then display pod_so_job WITH STREAM-IO /*GUI*/ .
           end.
        end.

        else if receiver <> "" then
        repeat for prh_hist with frame e width 100 on endkey undo, leave:
           find prev prh_hist where prh_receiver = receiver
           and (rcp_date = ? or rcp_date = prh_rcp_date)
           and (vend = "" or prh_vend = vend)
       and (base_rpt = prh_curr
               or base_rpt = "")
           no-lock.
           if available prh_hist then do:
          base_cost = prh_pur_cost.
      disp_curr = "".
      if prh_curr <> base_curr then do:
                     if base_rpt <> "" then
/*L020*     base_cost = base_cost * prh_ex_rate. */
/*L020*/    /* CONVERT FROM BASE TO FOREIGN CURRENCY */
/*L020*/    do:
/*L020*/    {gprunp.i "mcpl" "p" "mc-curr-conv"
             "(input base_curr,
               input prh_curr,
               input prh_ex_rate2,
               input prh_ex_rate,
               input base_cost,
               input false, /* DO NOT ROUND */
               output base_cost,
               output mc-error-number)"}.
/*L020*/     end.
         else disp_curr = "Y".
          end.

              if sord <> "" then do:
                      find pod_det where pod_nbr = prh_nbr
                          and pod_line   = prh_line
                          and pod_so_job = sord no-lock no-error.
                   if not available pod_det then next.
                  end. /* IF sord <> "" */
if sord = "" then do:
find pod_det where pod_nbr = prh_nbr no-lock no-error.
end.
find pT_MSTR WHERE pT_PART  = prh_PART AND (PT_PROD_LINE = PROD_LINE OR PROD_LINE = "") no-lock no-error.
IF available PT_MSTR THEN
          display
             prh_nbr
             prh_part
             PT_PROD_LINE
               pod_qty_ord
             prh_rcvd * prh_um_conv
             @ prh_rcvd format "->>>>>>9.99<<<<<<"
           
             prh_rcp_type
                     base_cost @ prh_pur_cost format "->>>>,>>>,>>9.99<<<"
             disp_curr
             prh_rcp_date
                     prh_site WITH STREAM-IO /*GUI*/ .
           end.
        end.

        else if rcp_date <> ? then
        repeat for prh_hist with frame f width 100 on endkey undo, leave:
           find prev prh_hist where prh_rcp_date = rcp_date
           and (vend = "" or prh_vend = vend)
       and (base_rpt = prh_curr
               or base_rpt = "")
           no-lock.
           if available prh_hist then do:
          base_cost = prh_pur_cost.
      disp_curr = "".
      if prh_curr <> base_curr then do:
                     if base_rpt <> "" then
/*L020*     base_cost = base_cost * prh_ex_rate. */
/*L020*/    /* CONVERT FROM BASE TO FOREIGN CURRENCY */
/*L020*/    do:
/*L020*/    {gprunp.i "mcpl" "p" "mc-curr-conv"
             "(input base_curr,
               input prh_curr,
               input prh_ex_rate2,
               input prh_ex_rate,
               input base_cost,
               input false, /* DO NOT ROUND */
               output base_cost,
               output mc-error-number)"}.
/*L020*/     end.
         else disp_curr = "Y".
          end.

              if sord <> "" then do:
                      find pod_det where pod_nbr = prh_nbr
                          and pod_line   = prh_line
                          and pod_so_job = sord no-lock no-error.
                   if not available pod_det then next.
                  end.  /* IF sord <> "" */
if sord = "" then do:
find pod_det where pod_nbr = prh_nbr no-lock no-error.
end.
find pT_MSTR WHERE pT_PART  = prh_PART AND (PT_PROD_LINE = PROD_LINE OR PROD_LINE = "") no-lock no-error.
IF available  PT_MSTR THEN
          display
             prh_nbr
             prh_part
             PT_PROD_LINE
               pod_qty_ord
             prh_rcvd * prh_um_conv
             @ prh_rcvd format "->>>>>>9.99<<<<<<"
      
             prh_rcp_type
                     base_cost @ prh_pur_cost format "->>>>,>>>,>>9.99<<<"
             disp_curr
             prh_receiver
                     prh_site WITH STREAM-IO /*GUI*/ .
           end.
        end.

        else if sord <> "" then
        for each pod_det where pod_so_job = sord no-lock
        with frame g width 80:
               
/*GUI*/ {mfguichk.i } /*Replace mfrpchk*/

           repeat for prh_hist with frame g width 80
           on endkey undo, leave:
          find prev prh_hist where prh_nbr = pod_nbr
              and prh_line = pod_line and (base_rpt = prh_curr
                  or base_rpt = "") no-lock.
  if available prh_hist THEN   base_cost = prh_pur_cost.
               
/*find pod_det where pod_nbr = prh_nbr no-lock no-error.*/
find pT_MSTR WHERE pT_PART  = prh_PART AND (PT_PROD_LINE = PROD_LINE OR PROD_LINE = "") no-lock no-error.
                  
          if available prh_hist AND available  PT_MSTR then do:
             display
            prh_vend
            prh_nbr
            prh_part
            PT_PROD_LINE
              pod_qty_ord
            prh_rcvd * prh_um_conv @ prh_rcvd
            base_cost @ prh_pur_cost format "->>>>,>>>,>>9.99<<<"

            prh_rcp_type
            prh_rcp_date
            prh_receiver
            prh_site WITH STREAM-IO /*GUI*/ .
          end.
           end.
        end.

        else /* DISPLAY IF NO PARAMETERS INPUT */
            for each prh_hist where prh_nbr >= "" and prh_receiver >= "" and
            prh_part >= "" no-lock
        by prh_rcp_date desc
        with frame h width 150 on endkey undo, leave:
           base_cost = prh_pur_cost.
     
/*GUI*/ {mfguichk.i } /*Replace mfrpchk*/
find pod_det where pod_nbr = prh_nbr no-lock no-error.

       if (base_rpt <> prh_curr
               and base_rpt <> "") then next.
find pT_MSTR WHERE pT_PART  = prh_PART AND (PT_PROD_LINE = PROD_LINE OR PROD_LINE = "") no-lock no-error.
               
IF available  PT_MSTR THEN  display
             prh_nbr
             prh_vend
             prh_part
             PT_PROD_LINE
             pod_qty_ord
             prh_rcvd * prh_um_conv @ prh_rcvd
             base_cost @ prh_pur_cost format "->>>>,>>>,>>9.99<<<"
             prh_rcp_type
             prh_rcp_date
             prh_receiver
             prh_site WITH STREAM-IO /*GUI*/ .
        end.

        {mfreset.i}
/*GUI*/ {mfgrptrm.i} /*Report-to-Window*/

        {mfmsg.i 8 1}
     end.
     global_part = part.

/*K1L2*/ {wbrp04.i &frame-spec = a}
