/* sfacct02.p - CREATE GLTW_DET RECORDS FOR OPERATION ACCOUNTING REPORT  */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                   */
/* All rights reserved worldwide.  This is an unpublished work.          */
/* $Revision: 1.7 $                                                          */
/*V8:ConvertMode=Maintenance                                             */
/* REVISION: 7.3            CREATED: 02/09/96   BY: rvw *G1MW*           */
/* REVISION: 9.1      LAST MODIFIED: 10/01/99   BY: *N014* Vijaya Pakala */
/* REVISION: 9.1      LAST MODIFIED: 08/12/00   BY: *N0KN* myb           */
/* Revision: 1.6      BY: Katie Hilbert  DATE: 04/05/01 ECO: *P008*      */
/* $Revision: 1.7 $       BY: Vandna Rohira  DATE: 07/10/01 ECO: *M1DM*      */
/* $Revision: 1.7 $       BY: Bill Jiang  DATE: 09/27/05 ECO: *SS - 20050927*      */
/* $Revision: 1.7 $       BY: Bill Jiang  DATE: 10/13/05 ECO: *SS - 20051013*      */
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
/* SS - 20050927 - B */
{a6sfacrp01.i}

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
    CREATE tta6sfacrp01.
    ASSIGN
        tta6sfacrp01_acct    = opgl_dr_acct
        tta6sfacrp01_sub     = opgl_dr_sub
        tta6sfacrp01_cc      = opgl_dr_cc
        tta6sfacrp01_proj = opgl_dr_proj
        /* SS - 20051013 - B */
        tta6sfacrp01_dr_amt     = opgl_gl_amt
        tta6sfacrp01_dr_qty_wip = op_qty_wip
        tta6sfacrp01_dr_qty_comp = op_qty_comp
        tta6sfacrp01_dr_qty_rjct = op_qty_rjct
        tta6sfacrp01_dr_qty_rwrk = op_qty_rwrk
        tta6sfacrp01_dr_qty_scrap = op_qty_scrap
        tta6sfacrp01_dr_qty_adjust = op_qty_adjust
        /* SS - 20051013 - E */
        .
    /* SS - 20051013 - B */
    /*
    IF opgl_gl_amt > 0 THEN DO:
        ASSIGN
            tta6sfacrp01_dr_amt     = opgl_gl_amt
            tta6sfacrp01_dr_qty_wip = op_qty_wip
            tta6sfacrp01_dr_qty_comp = op_qty_comp
            tta6sfacrp01_dr_qty_rjct = op_qty_rjct
            tta6sfacrp01_dr_qty_rwrk = op_qty_rwrk
            tta6sfacrp01_dr_qty_scrap = op_qty_scrap
            tta6sfacrp01_dr_qty_adjust = op_qty_adjust
            .
    END.
    ELSE DO:
        ASSIGN
            tta6sfacrp01_cr_amt     = - opgl_gl_amt
            tta6sfacrp01_cr_qty_wip = op_qty_wip
            tta6sfacrp01_cr_qty_comp = op_qty_comp
            tta6sfacrp01_cr_qty_rjct = op_qty_rjct
            tta6sfacrp01_cr_qty_rwrk = op_qty_rwrk
            tta6sfacrp01_cr_qty_scrap = op_qty_scrap
            tta6sfacrp01_cr_qty_adjust = op_qty_adjust
            .
    END.
    */
    /* SS - 20051013 - E */
    run get-entity(input  opgl_gl_ref,
                   input  opgl_dr_line,
                   output tta6sfacrp01_entity).
    ASSIGN
        tta6sfacrp01_gl_ref    = opgl_gl_ref
        tta6sfacrp01_tran_date    = op_tran_date
        tta6sfacrp01_date = op_date
        tta6sfacrp01_wo_nbr    = op_wo_nbr
        tta6sfacrp01_wo_lot    = op_wo_lot
        tta6sfacrp01_wo_op    = op_wo_op
        tta6sfacrp01_site = op_site
        tta6sfacrp01_part = op_part
        tta6sfacrp01_type = op_type
        tta6sfacrp01_trnbr = op_trnbr
        tta6sfacrp01_site = op_site
        tta6sfacrp01_wkctr = op_wkctr
        tta6sfacrp01_mch = op_mch
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
    CREATE tta6sfacrp01.
    ASSIGN
        tta6sfacrp01_acct    = opgl_cr_acct
        tta6sfacrp01_sub     = opgl_cr_sub
        tta6sfacrp01_cc      = opgl_cr_cc
        tta6sfacrp01_proj = opgl_cr_proj
        /* SS - 20051013 - B */
        tta6sfacrp01_cr_amt     = - opgl_gl_amt
        tta6sfacrp01_cr_qty_wip = - op_qty_wip
        tta6sfacrp01_cr_qty_comp = - op_qty_comp
        tta6sfacrp01_cr_qty_rjct = - op_qty_rjct
        tta6sfacrp01_cr_qty_rwrk = - op_qty_rwrk
        tta6sfacrp01_cr_qty_scrap = - op_qty_scrap
        tta6sfacrp01_cr_qty_adjust = - op_qty_adjust
        /* SS - 20051013 - E */
        .
    /* SS - 20051013 - B */
    /*
    IF (- opgl_gl_amt) > 0 THEN DO:
        ASSIGN
            tta6sfacrp01_dr_amt     = - opgl_gl_amt
            tta6sfacrp01_dr_qty_wip = op_qty_wip
            tta6sfacrp01_dr_qty_comp = op_qty_comp
            tta6sfacrp01_dr_qty_rjct = op_qty_rjct
            tta6sfacrp01_dr_qty_rwrk = op_qty_rwrk
            tta6sfacrp01_dr_qty_scrap = op_qty_scrap
            tta6sfacrp01_dr_qty_adjust = op_qty_adjust
            .
    END.
    ELSE DO:
        ASSIGN
            tta6sfacrp01_cr_amt     = opgl_gl_amt
            tta6sfacrp01_cr_qty_wip = op_qty_wip
            tta6sfacrp01_cr_qty_comp = op_qty_comp
            tta6sfacrp01_cr_qty_rjct = op_qty_rjct
            tta6sfacrp01_cr_qty_rwrk = op_qty_rwrk
            tta6sfacrp01_cr_qty_scrap = op_qty_scrap
            tta6sfacrp01_cr_qty_adjust = op_qty_adjust
            .
    END.
    */
    /* SS - 20051013 - E */
    run get-entity(input  opgl_gl_ref,
                   input  opgl_cr_line,
                   output tta6sfacrp01_entity).
    ASSIGN
        tta6sfacrp01_gl_ref    = opgl_gl_ref
        tta6sfacrp01_tran_date    = op_tran_date
        tta6sfacrp01_date = op_date
        tta6sfacrp01_wo_nbr    = op_wo_nbr
        tta6sfacrp01_wo_lot    = op_wo_lot
        tta6sfacrp01_wo_op    = op_wo_op
        tta6sfacrp01_site = op_site
        tta6sfacrp01_part = op_part
        tta6sfacrp01_type = op_type
        tta6sfacrp01_trnbr = op_trnbr
        tta6sfacrp01_wkctr = op_wkctr
        tta6sfacrp01_mch = op_mch
        .
END.


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
/* SS - 20050927 - E */


PROCEDURE get-entity:

define input  parameter p_opgl_ref  like opgl_det.opgl_gl_ref  no-undo.
define input  parameter p_opgl_line like opgl_det.opgl_dr_line no-undo.
define output parameter p_entity    like gltr_hist.gltr_entity no-undo.

define buffer glt_det   for glt_det.
define buffer gltr_hist for gltr_hist.

for first glt_det
   fields (glt_entity glt_line glt_ref)
   where glt_ref  = p_opgl_ref
   and   glt_line = p_opgl_line
   no-lock:
   p_entity = glt_entity.
end. /* FOR FIRST glt_det */
if not available glt_det
then do:
   for first gltr_hist
      fields (gltr_entity gltr_line gltr_ref)
      where gltr_ref  = p_opgl_ref
      and   gltr_line = p_opgl_line
      no-lock:
      p_entity = gltr_entity.
   end. /* FOR FIRST gltr_hist */
end. /* IF NOT AVAILABLE glt_det */

END PROCEDURE. /* get-entity */
