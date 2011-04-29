/* xxglacrp.p - GENERAL LEDGER ACCOUNT MASTER REPORT                      */
/* GUI CONVERTED from glacrp.p (converter v1.69) Sat Oct 11 22:25:09 1997 */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/* web convert glacrp.p (converter v1.00) Fri Oct 10 13:57:11 1997 */
/* web tag in glacrp.p (converter v1.00) Mon Oct 06 14:17:31 1997 */
/*F0PN*/ /*K0SM*/ /*V8#ConvertMode=WebReport                            */
/*V8:ConvertMode=FullGUIReport                                 */
/* REVISION: 1.0      LAST MODIFIED: 09/22/86   BY: JMS                 */
/* REVISION: 4.0      LAST MODIFIED: 02/29/88   BY: WUG  *A175*         */
/* REVISION: 6.0      LAST MODIFIED: 08/31/90   by: jms  *D034*         */
/* REVISION: 7.0      LAST MODIFIED: 09/20/91   by: jms  *F058*         */
/* REVISION: 7.3      LAST MODIFIED: 07/30/92   by: mpp  *G036*         */
/*                                   09/03/94   by: srk  *FQ80*         */
/* REVISION: 8.6      LAST MODIFIED: 10/11/97   BY: ays  *K0SM*         */
/*By: Neil Gao 09/02/07 ECO: *SS 20090207* */


      /* DISPLAY TITLE */

/*GUI global preprocessor directive settings */
&GLOBAL-DEFINE PP_PGM_RP TRUE
&GLOBAL-DEFINE PP_ENV_GUI TRUE


/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

          {mfdtitle.i "A "}
      define variable code like ac_code.
      define variable code1 like ac_code.
      define variable fpos like ac_fpos.
      define variable fpos1 like ac_fpos.


      /* SELECT FORM */
      
/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
code   colon 25   code1  colon 50 label {t001.i}
      skip (1)
/*FQ80*   with frame a side-labels attr-space. */
/*FQ80*/   SKIP(.4)  /*GUI*/
with frame a side-labels attr-space width 80.

setFrameLabels(frame a:handle).

/*GUI preprocessor Frame A undefine */
&UNDEFINE PP_FRAME_NAME



      /* REPORT BLOCK */
      fpos1 = 999999.
    
/*K0SM*/ {wbrp01.i}

repeat:
	
     if code1 = hi_char then code1 = "".

			update code code1 with frame a.

/*K0SM*/ if (c-application-mode <> 'web':u) or
/*K0SM*/ (c-application-mode = 'web':u and
/*K0SM*/ (c-web-request begins 'data':u)) then do:


         /* CREATE BATCH INPUT STRING */
         bcdparm = "".
         {mfquoter.i code   }
         {mfquoter.i code1  }
         {mfquoter.i fpos   }
         {mfquoter.i fpos1  }

         if code1 = "" then code1 = hi_char.


/*K0SM*/ end.
         /* SELECT PRINTER */
             
					{mfselbpr.i "printer" 132}
/*GUI*/   mainloop: do on error undo, return error on endkey undo, return error:




         {mfphead.i}



  for each ac_mstr where ac_domain = global_domain and ac_code >= code and ac_code <= code1 and ac_active no-lock by ac_code :
  
      display ac_code ac_desc.

      for each sbd_det where sbd_acc_beg <= ac_code and sbd_acc_end >= ac_code  and asc(sbd_acc_end) <> 255  by sbd_sub:
          find first sb_mstr where sb_domain = global_domain and sb_sub = sbd_sub no-lock no-error.
          display space(32) sbd_sub sb_desc /* sbd_acc_beg sbd_acc_end*/ .
      
          for each ccd2_det where ccd2_sub_beg <= sbd_sub and
                                 ccd2_sub_end >= sbd_sub  and asc(ccd2_sub_end) <> 255  no-lock :
              
              find first ccd1_det where ccd1_acc_beg <= ac_code and ccd1_acc_end >= ac_code 
              and ccd1_cc = ccd2_cc  no-lock no-error.
              find first cc_mstr where cc_domain = global_domain and cc_ctr = ccd2_cc no-lock no-error.
              if available ccd1_det then display space(66) /*ccd2_sub_beg ccd2_sub_end*/ ccd2_cc space(4) cc_desc  with width 102.
              
          end.

      end.
  


/***************************

         for each ac_mstr where ac_code >= code and ac_code <= code1 and
                    ac_fpos >= fpos and ac_fpos <= fpos1
                    no-lock with frame b width 132:
        display ac_code
            ac_desc
            ac_type
            ac_curr
            ac_fpos
            ac_active
            ac_fx_index
/*G036*/                ac_modl_only
            ac_stat_acc WITH STREAM-IO /*GUI*/ .

**/
        
         end.

         /* REPORT TRAILER  */
         
/*GUI*/ {mfrtrail.i}

/*GUI*/ {mfgrptrm.i} /*Report-to-Window*/


      end.

/*K0SM*/ {wbrp04.i &frame-spec = a}

/*GUI*/ end . /*p-report*/

