/* GUI CONVERTED from sfopiq12.p (converter v1.71) Tue Oct  6 14:48:24 1998 */
/* sfopiq12.p - OPERATION HISTORY TRANSACTION DETAIL INQUIRY            */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/* web convert sfopiq12.p (converter v1.00) Fri Oct 10 13:58:02 1997 */
/* web tag in sfopiq12.p (converter v1.00) Mon Oct 06 14:18:42 1997 */
/*F0PN*/ /*K0X0*/ /*V8#ConvertMode=WebReport                            */
/*V8:ConvertMode=Report                                        */
/* REVISION: 1.0      LAST MODIFIED: 05/06/86   BY: PML    */
/* REVISION: 4.0      LAST MODIFIED: 03/09/88   BY: RL  *A171**/
/* REVISION: 4.0      LAST MODIFIED: 07/18/88   BY: flm *A329**/
/* REVISION: 7.3      LAST MODIFIED: 12/08/92   BY: emb *G864*/
/* REVISION: 7.3      LAST MODIFIED: 05/17/94   BY: pxd *FO19*/
/* REVISION: 7.3      LAST MODIFIED: 12/23/94   BY: cpp *FT95*/
/* REVISION: 7.3      LAST MODIFIED: 03/14/95   By: DZN *G0G8*     */
/* REVISION: 7.4    LAST MODIFIED: 01/09/97  BY: *H0QZ* Julie Milligan   */
/* REVISION: 8.6      LAST MODIFIED: 10/13/97   By: ckm *K0X0**/

/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan    */
         /* DISPLAY TITLE */

/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

/*FO19*/ {mfdtitle.i "e+ "}

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE sfopiq12_p_1 "  Àà"
/* MaxLen: Comment: */

&SCOPED-DEFINE sfopiq12_p_2 " ×ÜÕÊÕÊÎñ "
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */


/*G0G8*/ /*V8:DontRefreshTitle=a1 */

         define variable optime as character.
/*FT95*  define variable trnbr like op_trnbr. */
/*FT95*/ define variable trnbr like op_trnbr format ">>>>>>>9".
         define variable last-recno as integer.
         define variable name as character format "x(34)".


         
/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/  
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
trnbr          colon 18
         with side-labels frame a width 80 NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-a-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
 RECT-FRAME-LABEL:HIDDEN in frame a = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame a =
  FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5.  /*GUI*/

/*GUI preprocessor Frame A undefine */
&UNDEFINE PP_FRAME_NAME



         FORM /*GUI*/ 
            op_type        colon 18 op_rsn no-label rsn_desc no-label
            op_tran_date   colon 18 optime no-label  op_wo_nbr colon 58
            op_date        colon 18 op_shift         op_wo_lot colon 58
            OP_USERID      COLON 18
            op_emp         colon 18                   op_wo_op colon 58
            name           at 20 no-label
            op_part        colon 18                op_qty_comp colon 58
            pt_desc1 at 20 no-label                op_qty_rjct colon 58
            op_site        colon 18 op_line label {&sfopiq12_p_1}
                                                   op_rsn_rjct colon 58
            op_wkctr       colon 18 op_mch         op_qty_rwrk colon 58
            op_dept        colon 18                op_rsn_rwrk colon 58
/*FO19      op_std_setup   colon 18               op_act_setup colon 58   */
/*FO19*/    op_std_setup   colon 18  format "->,>>9.9<<"
/*FO19*/                                          op_act_setup colon 58
            op_std_run     colon 18                 op_act_run colon 58
            op_lbr_std colon 18                    op_lbr_cost colon 58
            op_bdn_std colon 18                    op_bdn_cost colon 58
            op_sub_std colon 18                    op_sub_cost colon 58
         with STREAM-IO /*GUI*/  side-labels frame a1 width 90.

         find last op_hist no-lock
/*H0QZ*/   where op_trnbr >= 0
         no-error.
         if available op_hist then do:
            trnbr = op_trnbr.
            last-recno = recid(op_hist).

            find pt_mstr no-lock where pt_part = op_part no-error.
            find rsn_ref no-lock where rsn_type = op_type
            and rsn_code = op_rsn no-error.
            find emp_mstr no-lock where emp_addr = op_emp no-error.

            display op_trnbr @ trnbr with frame a.

            display
               op_type op_rsn
               rsn_desc when (available rsn_ref)
               "" when (not available rsn_ref) @ rsn_desc
               op_tran_date string(op_time,"hh:mm:ss") @ optime
               op_date op_shift    OP_USERID op_emp 
               emp_fname + " "+ emp_lname when (available emp_mstr) @ name
               "" when (not available emp_mstr) @ name
            
               op_part
               pt_desc1 when (available pt_mstr)
               "" when (not available pt_mstr) @ pt_desc1
               op_site op_line op_wkctr op_mch op_dept
               op_wo_nbr op_wo_lot op_wo_op
               op_qty_comp op_qty_rjct op_rsn_rjct op_qty_rwrk op_rsn_rwrk
               op_std_setup op_std_run op_act_setup op_act_run
               op_lbr_std op_bdn_std op_sub_std
               op_lbr_cost op_bdn_cost op_sub_cost
            with frame a1 STREAM-IO /*GUI*/ .
         end.


/*K0X0*/ {wbrp01.i}

         repeat with frame a:

/*K0X0*/ if c-application-mode <> 'web':u then
            update trnbr with frame a editing:


               /* FIND NEXT/PREVIOUS RECORD */
               {mfnp.i op_hist trnbr op_trnbr trnbr op_trnbr op_trnbr}
               if recno <> ? then do:
                  find pt_mstr no-lock where pt_part = op_part no-error.
                  find rsn_ref no-lock where rsn_type = op_type
                  and rsn_code = op_rsn no-error.
                  find emp_mstr no-lock where emp_addr = op_emp no-error.

                  display op_trnbr @ trnbr with frame a.

                  display
                     op_type op_rsn
                     rsn_desc when (available rsn_ref)
                     "" when (not available rsn_ref) @ rsn_desc
                     op_tran_date string(op_time,"hh:mm:ss") @ optime
                     op_date op_shift OP_USERID op_emp 
                     emp_fname + " "+ emp_lname when (available emp_mstr) @ name
                     "" when (not available emp_mstr) @ name
                     op_part
                     pt_desc1 when (available pt_mstr)
                     "" when (not available pt_mstr) @ pt_desc1
                     op_site op_line op_wkctr op_mch op_dept
                     op_wo_nbr op_wo_lot op_wo_op
                     op_qty_comp op_qty_rjct op_rsn_rjct op_qty_rwrk op_rsn_rwrk
                     op_std_setup op_std_run op_act_setup op_act_run
                     op_lbr_std op_bdn_std op_sub_std
                     op_lbr_cost op_bdn_cost op_sub_cost
                  with frame a1 STREAM-IO /*GUI*/ .

                  last-recno = recno.
               end.
            end.

/*K0X0*/ {wbrp06.i &command = update &fields = "  trnbr" &frm = "a"}

/*K0X0*/ if (c-application-mode <> 'web':u) or
/*K0X0*/ (c-application-mode = 'web':u and
/*K0X0*/ (c-web-request begins 'data':u)) then do:


            find op_hist no-lock where op_trnbr = trnbr no-error.
            if not available op_hist then do:
               last-recno = ?.
               clear frame a1.
               {mfmsg.i 13 3} /*Record not found */
/*K0X0*/        if c-application-mode = 'web':u then return.
               undo, retry.
            end.

            find pt_mstr no-lock where pt_part = op_part no-error.
            find rsn_ref no-lock where rsn_type = op_type
            and rsn_code = op_rsn no-error.
            find emp_mstr no-lock where emp_addr = op_emp no-error.

            if recid(op_hist) <> last-recno then do:
               display op_trnbr @ trnbr with frame a.

               display
                  op_type op_rsn
                  rsn_desc when (available rsn_ref)
                  "" when (not available rsn_ref) @ rsn_desc
                  op_tran_date string(op_time,"hh:mm:ss") @ optime
                  op_date op_shift op_emp OP_USERID
                  emp_fname + " "+ emp_lname when (available emp_mstr) @ name
                  "" when (not available emp_mstr) @ name
                  op_part
                  pt_desc1 when (available pt_mstr)
                  "" when (not available pt_mstr) @ pt_desc1
                  op_site op_line op_wkctr op_mch op_dept
                  op_wo_nbr op_wo_lot op_wo_op
                  op_qty_comp op_qty_rjct op_rsn_rjct op_qty_rwrk op_rsn_rwrk
                  op_std_setup op_std_run op_act_setup op_act_run
                  op_lbr_std op_bdn_std op_sub_std
                  op_lbr_cost op_bdn_cost op_sub_cost
               with frame a1 STREAM-IO /*GUI*/ .
            end.


/*K0X0*/ end.
            {mfselprt.i "terminal" 80}
/*GUI*/ RECT-FRAME:HEIGHT-PIXELS in frame a = FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.


            if dev <> "terminal"
/*K0X0*/        or c-application-mode = 'web':u then do:
               display op_trnbr @ trnbr with frame a.

               display
                  op_type op_rsn
                  rsn_desc when (available rsn_ref)
                  "" when (not available rsn_ref) @ rsn_desc
                  op_tran_date string(op_time,"hh:mm:ss") @ optime
                  op_date op_shift op_emp OP_USERID
                  emp_fname + " "+ emp_lname when (available emp_mstr) @ name
                  "" when (not available emp_mstr) @ name
                  op_part
                  pt_desc1 when (available pt_mstr)
                  "" when (not available pt_mstr) @ pt_desc1
                  op_site op_line op_wkctr op_mch op_dept
                  op_wo_nbr op_wo_lot op_wo_op
                  op_qty_comp op_qty_rjct op_rsn_rjct op_qty_rwrk op_rsn_rwrk
                  op_std_setup op_std_run op_act_setup op_act_run
                  op_lbr_std op_bdn_std op_sub_std
                  op_lbr_cost op_bdn_cost op_sub_cost
               with frame a1 STREAM-IO /*GUI*/ .
/*K0X0*/        put skip.
            end.

            for each opgl_det no-lock where opgl_trnbr = op_trnbr
            with frame b width 80 row 16 overlay no-underline
            title {&sfopiq12_p_2}:
               if opgl_gl_amt >= 0
               then
                  display opgl_gl_ref opgl_gl_amt
                     opgl_dr_acct opgl_dr_cc opgl_dr_proj
                  opgl_cr_acct opgl_cr_cc opgl_cr_proj WITH STREAM-IO /*GUI*/ .
               else
                  display opgl_gl_ref
                  opgl_gl_amt * -1 @ opgl_gl_amt
                  opgl_dr_acct @ opgl_cr_acct
                  opgl_dr_cc @ opgl_cr_cc
                  opgl_dr_proj @ opgl_cr_proj
                  opgl_cr_acct @ opgl_dr_acct
                  opgl_cr_cc @ opgl_dr_cc
                  opgl_cr_proj @ opgl_dr_proj WITH STREAM-IO /*GUI*/ .
            end.

            last-recno = recid(op_hist).
            hide frame b.

            {mfreset.i}
/*GUI*/ {mfgrptrm.i} /*Report-to-Window*/

            {mfmsg.i 8 1}

            status input.
         end.

/*K0X0*/ {wbrp04.i &frame-spec = a}
