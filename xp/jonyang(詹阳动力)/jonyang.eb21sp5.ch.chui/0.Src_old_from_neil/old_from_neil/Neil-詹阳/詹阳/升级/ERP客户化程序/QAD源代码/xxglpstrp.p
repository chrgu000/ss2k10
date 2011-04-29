/* xxglpstrp.p - GENERAL LEDGER UNPOSTED TRANSACTION REGISTER             */
/* GUI CONVERTED from glutrrp.p (converter v1.71) Tue Oct  6 14:28:53 1998 */
/* glutrrp.p - GENERAL LEDGER UNPOSTED TRANSACTION REGISTER             */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/* web convert glutrrp.p (converter v1.00) Fri Oct 10 13:57:12 1997 */
/* web tag in glutrrp.p (converter v1.00) Mon Oct 06 14:17:33 1997 */
/*F0PN*/ /*K11J*/ /*V8#ConvertMode=WebReport                            */
/*V8:ConvertMode=FullGUIReport                                 */
/* REVISION: 5.0      LAST MODIFIED: 03/16/89   BY: JMS   *B066*        */
/*                                   10/06/89   by: jms   *B330*        */
/* REVISION: 6.0      LAST MODIFIED: 07/06/90   by: jms   *D034*        */
/*                                   02/20/91   by: jms   *D366*        */
/* REVISION: 7.0      LAST MODIFIED: 10/18/91   by: jjs   *F058*        */
/*                                   02/26/92   by: jms   *F231*        */
/*                                   08/15/94   by: pmf   *FQ15*        */
/*                                   09/03/94   by: srk   *FQ80*        */
/*                                   11/17/94   by: str   *FT77*        */
/*                                   12/11/96   by: bjl   *K01S*        */
/*                                   04/10/97   BY: *K0BF* E. Hughart   */
/* REVISION: 8.6      LAST MODIFIED: 10/16/97   by: bvm   *K11J*        */

/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan   */
/* REVISION: 8.6E     LAST MODIFIED: 10/18/2000  BY: *JY000* **FRankie Xu*/

          /* DISPLAY TITLE */

/*GUI global preprocessor directive settings */
&GLOBAL-DEFINE PP_PGM_RP TRUE
&GLOBAL-DEFINE PP_ENV_GUI TRUE


/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

          {mfdtitle.i "e+ "}

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE glutrrp_p_1 "只打印未平衡帐务"
/* MaxLen: Comment: */

&SCOPED-DEFINE glutrrp_p_2 "贷方合计:      "
/* MaxLen: Comment: */

&SCOPED-DEFINE glutrrp_p_3 "帐户"
/* MaxLen: Comment: */

&SCOPED-DEFINE glutrrp_p_4 "    借方合计:  "
/* MaxLen: Comment: */

&SCOPED-DEFINE glutrrp_p_5 "*不平*"
/* MaxLen: Comment: */

&SCOPED-DEFINE glutrrp_p_6 "* 没有日记帐分录# *"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */


/*K01S*/  {gldydef.i new}

          define variable ref like gltr_ref.
          define variable ref1 like gltr_ref.
          define variable dt like gltr_ent_dt.
          define variable dt1 like gltr_ent_dt.
          define variable effdt like gltr_eff_dt.
          define variable effdt1 like gltr_eff_dt.
/*F058*/  define variable btch like gltr_batch.
          define variable unb like gltr_unb label {&glutrrp_p_1}.
          define variable unb_msg as character format "X(5)".
          define variable drtot as decimal format ">>>,>>>,>>>,>>>,>>>.99cr".
          define variable crtot like drtot.
          define variable type like gltr_tr_type.
          define variable amt like gltr_amt.
          define variable unbflag like mfc_logical.
/*F058*/  define variable account as character format "x(14)" label {&glutrrp_p_3}.
/*FQ15*/  define variable glname like en_name.
/*FQ15*/  define variable entity like gltr_entity.
/*FQ15*/  define variable entity1 like gltr_entity.
/*FT77*/  define variable entity_flag like mfc_logical.
/*JY000*/ define variable trtype like tr_type.

/*FT77*/  

/*FQ15*/  /* BEGIN: ADDED SECTION */
          /* GET NAME OF CURRENT ENTITY */
          find en_mstr where en_entity = current_entity no-lock no-error.
          if not available en_mstr then do:
             {mfmsg.i 3059 3} /* NO PRIMARY ENTITY DEFINED */

/*K11J*/     if c-application-mode <> 'web':u then
             pause.
             leave.
          end.
          else do:
             glname = en_name.
             release en_mstr.
          end.
          entity = current_entity.
          entity1 = entity.
/*FQ15*/  /* END: ADDED SECTION */

          /* SELECT FORM */
          
/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
/*FQ15*/     
 RECT-FRAME       AT ROW 1.4 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
 SKIP(.1)  /*GUI*/
             entity   colon 25    entity1 colon 50 label {t001.i}
             ref      colon 25    ref1    colon 50 label {t001.i}
             dt       colon 25    dt1     colon 50 label {t001.i}
             effdt    colon 25    effdt1  colon 50 label {t001.i}
/*F058*/     btch     colon 25
/*JY000*/    trtype   colon 25
             type     colon 25
             unb      colon 25
/*FQ80*   with frame a side-labels attr-space */
/*FQ80*/   SKIP(.4)  /*GUI*/
with frame a side-labels attr-space width 80
/*FQ15*/   NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-a-title AS CHARACTER.
 F-a-title = glname.
 RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
 RECT-FRAME-LABEL:WIDTH-PIXELS in frame a =
  FONT-TABLE:GET-TEXT-WIDTH-PIXELS(
  RECT-FRAME-LABEL:SCREEN-VALUE in frame a + " ", RECT-FRAME-LABEL:FONT).
 RECT-FRAME:HEIGHT-PIXELS in frame a =
  FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5. /*GUI*/

/*GUI preprocessor Frame A undefine */
&UNDEFINE PP_FRAME_NAME



/*JY000**     type = "JL".     **/
/*JY000*/     type = "".

          /* REPORT BLOCK */

/*K11J*/  {wbrp01.i}

          
/*GUI*/ {mfguirpa.i true  "printer" 132 }

/*GUI repeat : */
/*GUI*/ procedure p-enable-ui:

             if ref1 = hi_char then ref1 = "".
             if dt =  low_date then dt = ?.
             if dt1 = hi_date then dt1 = ?.
             if effdt = low_date then effdt = ?.
             if effdt1 = hi_date then effdt1 = ?.
/*FQ15*/     if entity1 = hi_char then entity1 = "".
             unb = no.

/*F058*/
/*K11J*/     if c-application-mode <> 'web':u then
             
run p-action-fields (input "display").
run p-action-fields (input "enable").
end procedure. /* p-enable-ui, replacement of Data-Entry GUI*/

/*GUI*/ procedure p-report-quote:

/**JY000***/
/*K11J*/ {wbrp06.i &command = update &fields = "   entity entity1 ref ref1 dt dt1
effdt effdt1 btch trtype type unb" &frm = "a"}
/***JY0000**/

/**JY000****
/*K11J*/ {wbrp06.i &command = update &fields = "   entity entity1 ref ref1 dt dt1
effdt effdt1 btch type unb" &frm = "a"}
****JY0000***/

/*K11J*/ if (c-application-mode <> 'web':u) or
/*K11J*/ (c-application-mode = 'web':u and
/*K11J*/ (c-web-request begins 'data':u)) then do:


             /* CREATE BATCH INPUT STRING */
             bcdparm = "".
/*FQ15*/     {mfquoter.i entity  }
/*FQ15*/     {mfquoter.i entity1 }
             {mfquoter.i ref     }
             {mfquoter.i ref1    }
             {mfquoter.i dt      }
             {mfquoter.i dt1     }
             {mfquoter.i effdt   }
             {mfquoter.i effdt1  }
/*F058*/     {mfquoter.i btch    }
             {mfquoter.i type    }
             {mfquoter.i unb     }
/*JY000*/    {mfquoter.i trtype    }

             if ref1 = "" then ref1 = hi_char.
             if dt = ?  then dt = low_date.
             if dt1 = ? then dt1 = hi_date.
             if effdt = ? then effdt = low_date.
             if effdt1 = ? then effdt1 = hi_date.
/*FQ15*/     if entity1 = "" then entity1 = hi_char.
             crtot = 0.
             drtot = 0.

/*K11J*/ end.

             /* SELECT PRINTER */
             
/*GUI*/ end procedure. /* p-report-quote */
/*GUI - Field Trigger Section */

/*GUI MFSELxxx removed*/
/*GUI*/ procedure p-report:
/*GUI*/   {gpprtrpa.i  "printer" 132}
/*GUI*/   mainloop: do on error undo, return error on endkey undo, return error:
find en_mstr where en_entity = current_entity no-lock no-error.

define buffer gltdet for gltr_hist.


             {mfphead.i}

             for each gltr_hist where
/*FQ15*/                            gltr_entity >= entity and
/*FQ15*/                            gltr_entity <= entity1 and
                                    gltr_ref >= ref and gltr_ref <= ref1 and
                                    gltr_ent_dt >= dt and
                                    gltr_ent_dt <= dt1 and
                                    gltr_eff_dt >= effdt and
                                    gltr_eff_dt <= effdt1 and
/*JY000*/                           (substring(gltr_desc,1,7) = trtype or trtype = "") and                                 
/*F058*/                            (gltr_batch = btch or btch = "")
                                    no-lock use-index gltr_ref
                                    break by gltr_ref
                                    with width 132 no-attr-space
/*K0BF*/                            no-box:
                if type <> "" and substring(gltr_ref, 1, 2) <> type then next.
                if unb = yes and gltr_unb = no then next.

                if first-of(gltr_ref) then do:
/*FT77*/           entity_flag = no.
/*FT77*/           find first gltdet where
/*FT77*/              gltdet.gltr_ref = gltr_hist.gltr_ref and
/*FT77*/              (gltdet.gltr_entity < entity or
/*FT77*/               gltdet.gltr_entity > entity1) no-lock no-error.
/*FT77*/           if available gltdet then do:
/*FT77*/              entity_flag = yes.
/*FT77*/              next.
/*FT77*/           end.
                   display gltr_hist.gltr_ref
                           gltr_hist.gltr_ent_dt
                           gltr_hist.gltr_eff_dt
                           WITH STREAM-IO /*GUI*/ .
                   unb_msg = "".
                   unbflag = no.
                end.
/*FT77*                else display "" @ gltr_ref        */
/*FT77*                             "" @ gltr_ent_dt       */
/*FT77*                             "" @ gltr_eff_dt    */
/*FT77*                             "" @ gltr_userid.    */
/*FT77*/        else do:
/*FT77*/           if entity_flag = yes then next.
/*FT77*/           display "" @ gltr_hist.gltr_ref
/*FT77*/                   "" @ gltr_hist.gltr_ent_dt
/*FT77*/                   "" @ gltr_hist.gltr_eff_dt
/*FT77*/                   WITH STREAM-IO /*GUI*/ .
/*FT77*/        end.

                amt = gltr_hist.gltr_amt.
                if gltr_hist.gltr_curr <> base_curr
                   then amt = gltr_hist.gltr_curramt.
/*F058*/        find ac_mstr where ac_code = gltr_hist.gltr_acc no-lock no-error.
                if not available ac_mstr then do:
                   accumulate gltr_hist.gltr_amt (total by gltr_hist.gltr_ref).
                   if gltr_hist.gltr_amt < 0
                      then crtot = crtot - gltr_hist.gltr_amt.
                   else drtot = drtot + gltr_hist.gltr_amt.
                end.
                else if ac_type <> "S" and ac_type <> "M" then do:
                   accumulate gltr_hist.gltr_amt (total by gltr_hist.gltr_ref).
                   if gltr_hist.gltr_amt < 0
                      then crtot = crtot - gltr_hist.gltr_amt.
                   else drtot = drtot + gltr_hist.gltr_amt.
                end.
/*F058*/        {glacct.i &acc=gltr_hist.gltr_acc
                          &sub=gltr_hist.gltr_sub
                          &cc=gltr_hist.gltr_ctr
                          &acct=account}
                display gltr_hist.gltr_line
/*F058*/                account
                        gltr_hist.gltr_project
                        gltr_hist.gltr_entity
                        gltr_hist.gltr_desc
                        amt
                        gltr_hist.gltr_curr
/*K0BF*/                gltr_hist.gltr_dy_code WITH STREAM-IO /*GUI*/ .
                if gltr_hist.gltr_error <> "" then do:
                   down 1.
/*K11J*            disp gltr_hist.gltr_error @ gltr_hist.gltr_desc. **/
/*K11J*/           display gltr_hist.gltr_error @ gltr_hist.gltr_desc WITH STREAM-IO /*GUI*/ .
                end.

/*K01S*/        if daybooks-in-use and gltr_hist.gltr_dy_code > "" and
/*K01S*/           (gltr_hist.gltr_dy_num = "" or gltr_hist.gltr_dy_num = ?) then do:
/*K01S*/           down 1.
/*K01S*/ /*K11J*   disp "* No Daybook Entry# *" **/
/*K11J*/           display {&glutrrp_p_6}
/*K01S*/                @ gltr_hist.gltr_desc WITH STREAM-IO /*GUI*/ .
/*K01S*/        end.

                if gltr_hist.gltr_unb = yes then unbflag = yes.

                if last-of(gltr_hist.gltr_ref) then do:
/*F231*/           if unbflag = yes then unb_msg = {&glutrrp_p_5}.
                   underline amt.
/*K11J*            disp accum total by gltr_hist.gltr_ref gltr_hist.gltr_amt @ amt */
/*K11J*/           display accum total by gltr_hist.gltr_ref gltr_hist.gltr_amt @ amt
                   base_curr @ gltr_hist.gltr_curr
/*K0BF**              unb_msg no-label. **/
/*K0BF*/              unb_msg @ gltr_hist.gltr_dy_code WITH STREAM-IO /*GUI*/ .
                   down 1.
                end.

                
/*GUI*/ {mfguirex.i } /*Replace mfrpexit*/

             end.

             /* PRINT DEBIT AND CREDIT TOTALS */
/*F231*/     put skip(2)  {&glutrrp_p_4}  at 25 drtot space(1) base_curr
/*F231*/                  {&glutrrp_p_2}  at 75 crtot space(1) base_curr.

             /* REPORT TRAILER  */
             
/*GUI*/ {mfguitrl.i} /*Replace mfrtrail*/

/*GUI*/ {mfgrptrm.i} /*Report-to-Window*/

          end.

/*K11J*/ {wbrp04.i &frame-spec = a}

/*GUI*/ end procedure. /*p-report*/
/*JY000** /*GUI*/ {mfguirpb.i &flds="  entity entity1 ref ref1 dt dt1 effdt effdt1 btch type unb "} /*Drive the Report*/   **/
/*JY000*/ /*GUI*/ {mfguirpb.i &flds="  entity entity1 ref ref1 dt dt1 effdt effdt1 btch trtype type unb "} /*Drive the Report*/


