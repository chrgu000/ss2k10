/* sfacct02.p - CREATE GLTW_DET RECORDS FOR OPERATION ACCOUNTING REPORT  */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                   */
/* All rights reserved worldwide.  This is an unpublished work.          */
/* $Revision: 1.9 $                                                          */
/*V8:ConvertMode=Maintenance                                             */
/* REVISION: 7.3            CREATED: 02/09/96   BY: rvw *G1MW*           */
/* REVISION: 9.1      LAST MODIFIED: 10/01/99   BY: *N014* Vijaya Pakala */
/* REVISION: 9.1      LAST MODIFIED: 08/12/00   BY: *N0KN* myb           */
/* Revision: 1.6      BY: Katie Hilbert  DATE: 04/05/01 ECO: *P008*      */
/* Revision: 1.7  BY: Vandna Rohira DATE: 07/10/01 ECO: *M1DM* */
/* $Revision: 1.9 $ BY: Paul Donnelly (SB) DATE: 06/28/03 ECO: *Q00L* */
/* $Revision: 1.9 $ BY: Bill Jiang DATE: 05/06/08 ECO: *SS - 20080506.1* */
/*-Revision end---------------------------------------------------------------*/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* FOR IMPROVEMENT IN PERFORMANCE:                             */
/* 1. CREATING TEMP-TABLE tt_glt_wkfl INSTEAD OF gltw_wkfl.    */
/* 2. CHANGING FIND STATEMENTS WITH NO-LOCK TO FOR FIRST WITH  */
/*    FIELD LIST ATTACHED                                      */
/* 3. USING BUFFERS opgl_det and opgl_hist                     */

{mfdeclre.i}

define parameter buffer opgl_det for opgl_det.
define parameter buffer op_hist  for op_hist.

/* SS - 20080506.1 - B */
{sssfacrp0101.i}

define input parameter acct like glt_acct.
define input parameter acct1 like glt_acct.
define input parameter sub like glt_sub.
define input parameter sub1 like glt_sub.
define input parameter cc like glt_cc.
define input parameter cc1 like glt_cc.
define input parameter proj like glt_project.
define input parameter proj1 like glt_project.

IF opgl_dr_acct >= acct 
    and opgl_dr_acct <= acct1
    and opgl_dr_sub >= sub 
    and opgl_dr_sub <= sub1
    and opgl_dr_cc >= cc 
    and opgl_dr_cc <= cc1
    and opgl_dr_proj >= proj 
    and opgl_dr_proj <= proj1
    THEN DO:
    CREATE ttsssfacrp0101.
    ASSIGN
        ttsssfacrp0101_acct    = opgl_dr_acct
        ttsssfacrp0101_sub     = opgl_dr_sub
        ttsssfacrp0101_cc      = opgl_dr_cc
        ttsssfacrp0101_proj = opgl_dr_proj
        ttsssfacrp0101_dr_amt     = opgl_gl_amt
        ttsssfacrp0101_dr_qty_wip = op_qty_wip
        ttsssfacrp0101_dr_qty_comp = op_qty_comp
        ttsssfacrp0101_dr_qty_rjct = op_qty_rjct
        ttsssfacrp0101_dr_qty_rwrk = op_qty_rwrk
        ttsssfacrp0101_dr_qty_scrap = op_qty_scrap
        ttsssfacrp0101_dr_qty_adjust = op_qty_adjust
        .

    run get-entity(input  opgl_gl_ref,
                   input  opgl_dr_line,
                   output ttsssfacrp0101_entity).
    ASSIGN
        ttsssfacrp0101_gl_ref    = opgl_gl_ref
        ttsssfacrp0101_tran_date    = op_tran_date
        ttsssfacrp0101_date = op_date
        ttsssfacrp0101_wo_nbr    = op_wo_nbr
        ttsssfacrp0101_wo_lot    = op_wo_lot
        ttsssfacrp0101_wo_op    = op_wo_op
        ttsssfacrp0101_site = op_site
        ttsssfacrp0101_part = op_part
        ttsssfacrp0101_type = op_type
        ttsssfacrp0101_trnbr = op_trnbr
        ttsssfacrp0101_site = op_site
        ttsssfacrp0101_wkctr = op_wkctr
        ttsssfacrp0101_mch = op_mch
        .
END.

IF opgl_cr_acct >= acct 
    and opgl_cr_acct <= acct1
    and opgl_cr_sub >= sub 
    and opgl_cr_sub <= sub1
    and opgl_cr_cc >= cc 
    and opgl_cr_cc <= cc1
    and opgl_cr_proj >= proj 
    and opgl_cr_proj <= proj1
    THEN DO:
    CREATE ttsssfacrp0101.
    ASSIGN
        ttsssfacrp0101_acct    = opgl_cr_acct
        ttsssfacrp0101_sub     = opgl_cr_sub
        ttsssfacrp0101_cc      = opgl_cr_cc
        ttsssfacrp0101_proj = opgl_cr_proj
        ttsssfacrp0101_cr_amt     = - opgl_gl_amt
        ttsssfacrp0101_cr_qty_wip = - op_qty_wip
        ttsssfacrp0101_cr_qty_comp = - op_qty_comp
        ttsssfacrp0101_cr_qty_rjct = - op_qty_rjct
        ttsssfacrp0101_cr_qty_rwrk = - op_qty_rwrk
        ttsssfacrp0101_cr_qty_scrap = - op_qty_scrap
        ttsssfacrp0101_cr_qty_adjust = - op_qty_adjust
        .

    run get-entity(input  opgl_gl_ref,
                   input  opgl_cr_line,
                   output ttsssfacrp0101_entity).
    ASSIGN
        ttsssfacrp0101_gl_ref    = opgl_gl_ref
        ttsssfacrp0101_tran_date    = op_tran_date
        ttsssfacrp0101_date = op_date
        ttsssfacrp0101_wo_nbr    = op_wo_nbr
        ttsssfacrp0101_wo_lot    = op_wo_lot
        ttsssfacrp0101_wo_op    = op_wo_op
        ttsssfacrp0101_site = op_site
        ttsssfacrp0101_part = op_part
        ttsssfacrp0101_type = op_type
        ttsssfacrp0101_trnbr = op_trnbr
        ttsssfacrp0101_wkctr = op_wkctr
        ttsssfacrp0101_mch = op_mch
        .
END.
/* SS - 20080506.1 - E */

/* SS - 20080506.1 - B */
/*
/* TEMP-TABLE DEFINITION OF tt_gltw_wkfl */
{sfgltwdf.i}

create tt_gltw_wkfl.
assign
   tt_gltw_acct    = opgl_dr_acct
   tt_gltw_sub     = opgl_dr_sub
   tt_gltw_cc      = opgl_dr_cc
   tt_gltw_project = opgl_dr_proj
   tt_gltw_date    = op_tran_date
   tt_gltw_effdate = op_date
   tt_gltw_desc    = op_wo_nbr + " " +
                     op_wo_lot + " " +
                     string(op_wo_op)
   tt_gltw_amt     = opgl_gl_amt.

/* CALLING PROCEDURE get-entity TO OBTAIN */
/* THE ENTITY VALUE FOR DEBIT LINE        */

run get-entity(input  opgl_gl_ref,
               input  opgl_dr_line,
               output tt_gltw_entity).

create tt_gltw_wkfl.
assign
   tt_gltw_acct    = opgl_cr_acct
   tt_gltw_sub     = opgl_cr_sub
   tt_gltw_cc      = opgl_cr_cc
   tt_gltw_project = opgl_cr_proj
   tt_gltw_date    = op_tran_date
   tt_gltw_effdate = op_date
   tt_gltw_desc    = op_wo_nbr + " " +
                     op_wo_lot + " " +
                     string(op_wo_op)
   tt_gltw_amt     = - opgl_gl_amt.

/* CALLING PROCEDURE get-entity TO OBTAIN */
/* THE ENTITY VALUE FOR CREDIT LINE       */

run get-entity(input  opgl_gl_ref,
               input  opgl_cr_line,
               output tt_gltw_entity).
*/
/* SS - 20080506.1 - E */


PROCEDURE get-entity:

define input  parameter p_opgl_ref  like opgl_det.opgl_gl_ref  no-undo.
define input  parameter p_opgl_line like opgl_det.opgl_dr_line no-undo.
define output parameter p_entity    like gltr_hist.gltr_entity no-undo.

define buffer glt_det   for glt_det.
define buffer gltr_hist for gltr_hist.

for first glt_det
   fields( glt_domain glt_entity glt_line glt_ref)
    where glt_det.glt_domain = global_domain and  glt_ref  = p_opgl_ref
   and   glt_line = p_opgl_line
   no-lock:
   p_entity = glt_entity.
end. /* FOR FIRST glt_det */
if not available glt_det
then do:
   for first gltr_hist
      fields( gltr_domain gltr_entity gltr_line gltr_ref)
       where gltr_hist.gltr_domain = global_domain and  gltr_ref  = p_opgl_ref
      and   gltr_line = p_opgl_line
      no-lock:
      p_entity = gltr_entity.
   end. /* FOR FIRST gltr_hist */
end. /* IF NOT AVAILABLE glt_det */

END PROCEDURE. /* get-entity */
