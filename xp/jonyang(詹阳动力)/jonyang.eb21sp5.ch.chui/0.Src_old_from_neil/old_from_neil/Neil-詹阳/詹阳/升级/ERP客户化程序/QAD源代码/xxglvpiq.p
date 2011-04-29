/* xxglvpiq.p - Voucher INQUIRY                 */
/* GUI CONVERTED from xxglvpiq.p (converter v1.71) Tue Oct  6 14:28:52 1998 */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK.    */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan      */
/***************************************************************************/

          /* DISPLAY TITLE */

/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

/*F535*/ {mfdtitle.i "e+ "}

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE xxglvpiq_p_1 "帐户"
/* MaxLen: Comment: */

&SCOPED-DEFINE xxglvpiq_p_2 "期间/年份"
/* MaxLen: Comment: */

&SCOPED-DEFINE xxglvpiq_p_3 "凭证"
/* MaxLen: Comment: */

&SCOPED-DEFINE xxglvpiq_p_4 "合计 "
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */


          define variable ref like gltr_ref.
          define variable vounbr like gltr_user1 column-label {&xxglvpiq_p_3}.
          define variable vounbr_msg as character format "x(7)".
          define variable tot_amt like gltr_amt label {&xxglvpiq_p_4}.
          define variable peryr as character format "x(8)" label {&xxglvpiq_p_2}.
          define variable desc1 like gltr_desc format "x(21)".
          define variable amt like gltr_amt.
          define variable batch like gltr_batch.
          define variable account as character format "x(14)" label {&xxglvpiq_p_1}.
          define variable curr like ac_curr.
/*F506*/  define variable accurr like ac_curr.
/*K001*/  define variable corr-flag like gltr_hist.gltr_correction no-undo.
          define buffer hist for gltr_hist.

          /* DISPLAY SELECTION FORM*/
          
/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
          ref
/*G1K3*/  view-as fill-in size 14 by 1   
          batch
          curr
          vounbr
          with frame a no-underline width 80 attr-space THREE-D /*GUI*/.

/*GUI preprocessor Frame A undefine */
&UNDEFINE PP_FRAME_NAME


/*K120*/ {wbrp01.i}
          mainloop: repeat:
             vounbr = "".
             curr = base_curr.

/*K120*/ if c-application-mode <> 'web':u then
             update ref with frame a editing:

                /* FIND NEXT/PREVIOUS RECORD */
                {mfnp.i gltr_hist ref gltr_ref ref gltr_ref gltr_ref}
                if recno <> ? then do:
                   ref = gltr_ref.
                   display ref with frame a.
                   recno = ?.
                end.
             end.

/*K120*/ {wbrp06.i  &comand = update &fields = "ref" &frm = "a"}
/*K120*/ if (c-application-mode <> 'web':u) or
        (c-application-mode = 'web':u and (c-web-request begins 'data':u)) then
         do:

             /* INPUT REMAINING VARIABLES */
             if ref = "" then do:
                batch = "".
             end.
/*K120*/ end.
/*K120*/ if c-application-mode <> 'web':u then
             update batch curr vounbr with frame a.

/*K120*/ {wbrp06.i &command = update &fields = "batch curr vounbr" &frm = "a"}
/*K120*/ if (c-application-mode <> 'web':u) or
        (c-application-mode = 'web':u and (c-web-request begins 'data':u)) then
         do:

             /* CLEAR FRAMES */
             hide frame b.
             hide frame c.
             hide frame d.
             hide frame e.
             hide frame f.
/*K120*/ end.
             /* SELECT PRINTER */
             {mfselprt.i "terminal" 90}

             /* DISPLAY INFORMATION */
             FORM /*GUI*/ 
             gltr_ref
             gltr_batch
             gltr_eff_dt
             gltr_ent_dt
             gltr_user
             tot_amt
/*K001**     vounbr_msg no-label **/
/*K001*/     gltr_user1 label "凭证号"
             with STREAM-IO /*GUI*/  frame b 1 down width 90 no-attr-space.

                 if batch = "" then do:
                    for each gltr_hist where gltr_ref >= ref and gltr_user1 >= vounbr
                                           no-lock use-index gltr_ref
                                           break by gltr_ref
                                           with frame c width 80 no-attr-space
                                           on endkey undo, leave.
                       if first-of(gltr_ref) then do:
/*K001*/                  corr-flag = gltr_hist.gltr_correction.
                          
/*GUI*/ {mfguichk.i } /*Replace mfrpchk*/

/*G339*/                  {xxglvpiq1.i}
                          clear frame c all.
                          {xxglvpiq2.i}
                       end.
/*K0BN** /*K001*/               corr-flag = gltr_hist.gltr_correction. **/
/*K0BN** /*K001*/               display corr-flag with frame b. **/
                       {xxglvpiq3.i}
                    end.
                 end.
                 else do:
                    for each gltr_hist where gltr_batch = batch and gltr_user1 >= vounbr and 
                                           gltr_ref >= ref no-lock
                                           use-index gltr_batch
                                           break by gltr_batch by gltr_ref
                                           with frame d width 80 no-attr-space
                                           on endkey undo, leave.
                       if first-of(gltr_ref) then do:
/*K001*/                  corr-flag = gltr_hist.gltr_correction.
                          
/*GUI*/ {mfguichk.i } /*Replace mfrpchk*/
                     /*G339*/
                          {xxglvpiq1.i}
                          clear frame d all.
                          {xxglvpiq2.i}
                       end.
/*K0BN** /*K001*/               corr-flag = gltr_hist.gltr_correction. */
/*K0BN** /*K001*/               display corr-flag with frame b. */
                       {xxglvpiq3.i}
                    end.
                 end.

             /* END OF LIST MESSAGE */
             {mfreset.i}
/*GUI*/ {mfgrptrm.i} /*Report-to-Window*/

             {mfmsg.i 8 1}
          end.
/*K120*/ {wbrp04.i &frame-spec = a}
