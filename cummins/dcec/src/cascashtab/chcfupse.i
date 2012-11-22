/* chcfupse.i - Cash flow include file                                        */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.0 $                                                           */
/* REVISION: 9.3      LAST MODIFIED: 10/11/07   BY: LinYun   ECO: *XXLY*  */
/*V8:ConvertMode=NoConvert*/
/*CF*/      /* DISPLAY UNPOSTED CASH FLOW TRANSACTION */
/*CF* Add Begin */

         find first xcf_mstr where xcf_ac_code = glt_det.glt_acct
/*XXLY*                 and xcf_sub = glt_det.glt_sub
                        and xcf_cc = glt_det.glt_cc
                        and xcf_pro = glt_det.glt_project  
*/
                        and glt_det.glt_ref begins "JL"
/*XXLY*/                and ( if xcf_sub <> "*" then glt_det.glt_sub = xcf_sub  else true )  
                        and ( if xcf_cc  <> "*" then glt_det.glt_cc = xcf_cc else true )
                        and ( if xcf_pro <> "*" then glt_det.glt_project = xcf_pro else true )  
                        and xcf_active = yes and xcf_domain = global_domain
                        no-lock no-error.
/*XXLY*/ find first xcf1_mstr where xcf1_mfgc_ac_code = glt_det.glt_acct 
               and (glt_det.glt_ref begins "AP" or glt_det.glt_ref begins "AR")
               and (if xcf1_mfgc_sub <> "*" then glt_det.glt_sub = xcf1_mfgc_sub  else true )
               and (if xcf1_mfgc_cc  <> "*" then glt_det.glt_cc = xcf1_mfgc_cc else true )
               and (if xcf1_mfgc_pro <> "*" then glt_det.glt_project = xcf1_mfgc_pro else true )  
               and xcf1_active = yes and xcf1_domain = global_domain
               no-lock no-error.                    
/*XXLY*    if available xcf_mstr then do:   */
/*XXLY*/   if available xcf_mstr or available xcf1_mstr then do:
            down 1 with frame e.
            display getTermLabelRtColon("CASHFLOW", 9)  @ account 
            with frame e.
                   down 1 with frame e.

            for each xcft_det where xcft_entity   = glt_det.glt_entity
                                and xcft_ref      = glt_det.glt_ref
                                and xcft_rflag    = glt_det.glt_rflag
                                and xcft_ac_code  = glt_det.glt_acct
                                and xcft_sub      = glt_det.glt_sub
                                and xcft_cc       = glt_det.glt_cc
                                and xcft_pro      = glt_det.glt_project
                                and xcft_glt_line = glt_det.glt_line
                                and xcft_domain = global_domain
                                   no-lock:

                   /* GENERATE DR_CR FLAG AND XAMT */
                   {chtramt1.i &glamt=xcft_amt
                               &glcurramt=xcft_curr_amt
                               &coa=glt_det.glt_correction
                               &glcurr=glt_det.glt_curr
                               &basecurr=base_curr
                               &usecurramt=yes
                               &drcr=dr_cr
                               &dispamt=xamt}
                   display /*xcft_line @ glt_det.glt_line*/
                           xcft_acct @ account
                           xcft_desc @ desc1
                           curr
                           dr_cr
                           xamt @ amt with frame e.
                   down 1 with frame e.
             end. /* for each xcft_det */

          end. /* if available xcf_mstr */
/*CF* Add End */
