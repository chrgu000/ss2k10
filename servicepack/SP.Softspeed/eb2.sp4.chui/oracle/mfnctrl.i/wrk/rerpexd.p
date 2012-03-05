/* rerpexd.p - REPETITIVE EXPLOSION SUBROUTINE                                */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/*F0PN*/ /*V8:ConvertMode=Maintenance                                         */
/*N014*/ /*V8:RunMode=Character,Windows                                       */
/* REVISION: 7.3      LAST MODIFIED: 03/13/95   BY: pxe *F0MF*                */
/* REVISION: 8.5      LAST MODIFIED: 06/16/95   BY: rmh *J04R*                */
/* REVISION: 7.3      LAST MODIFIED: 07/21/95   BY: dzs *F0TB*                */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane          */
/* REVISION: 8.6E     LAST MODIFIED: 03/20/98   BY: *J23R* Santhosh Nair      */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan         */
/* REVISION: 9.1      LAST MODIFIED: 10/01/99   BY: *N014* Robin McCarthy     */
/* REVISION: 9.1      LAST MODIFIED: 07/25/00   BY: *N0GD* Peggy Ng     */

/*F0TB*/ /* THIS PROGRAM DELETES OLD mrp_det RECORDS AND CREATE NEW mrp_det */
     /* BASED ON DEMAND. IT ALSO INCLUDES LOGIC TO RE-ASSIGN WORK ORDER */
     /* ID'S THAT ARE GREATER THAN 9 DIGITS.                            */

/*J04R*/ {mfdeclre.i}
/*N0GD*/ {gplabel.i}

/* ********** Begin Translatable Strings Definitions ********* */

/*N0GD* &SCOPED-DEFINE rerpexd_p_1 "Work Order" */
/*N0GD* /* MaxLen: Comment: */                  */

/* ********** End Translatable Strings Definitions ********* */


     define input-output parameter wolot like wo_lot no-undo.

     define variable old_lot like wo_lot no-undo.
     define variable rpsnbr like mrp_nbr no-undo.
     define variable rpsrecord like rps_record no-undo.
     define variable i as integer no-undo.
/*N0GD*/ define variable wkorder as character format "x(20)" no-undo.


/*N0GD*/ wkorder = getTermLabel("WORK_ORDER",20).

/*J04R*  {mfdeclre.i}     */


     do transaction:

/*J23R** find wo_mstr where wo_lot = wolot no-error.   */

/*J23R*/ for first wo_mstr
/*N014*
 * /*J23R*/     fields(wo_acct wo_bom_code wo_cc wo_due_date wo_flr_acct
 * /*J23R*/            wo_flr_cc wo_line wo_lot wo_qty_rjct wo_mvar_acct
 * /*J23R*/            wo_mvar_cc wo_mvrr_acct wo_mvrr_cc wo_nbr wo_var
 * /*J23R*/            wo_ord_date wo_part wo_qty_comp wo_qty_ord
 * /*J23R*/            wo_rel_date wo_routing wo_site wo_status wo_svar_acct
 * /*J23R*/            wo_svar_cc wo_svrr_acct wo_svrr_cc wo_type wo_xvar_acct
 * /*J23R*/            wo_xvar_cc wo_yield_pct)
 *N014*/
/*N014*        BEGIN REPLACEMENT */
               fields(wo_acct wo_sub wo_cc
                      wo_bom_code wo_due_date
                      wo_flr_acct wo_flr_sub wo_flr_cc
                      wo_line wo_lot wo_qty_rjct
                      wo_mvar_acct wo_mvar_sub wo_mvar_cc
                      wo_mvrr_acct wo_mvrr_sub wo_mvrr_cc
                      wo_nbr wo_var
                      wo_ord_date wo_part wo_qty_comp wo_qty_ord
                      wo_rel_date wo_routing wo_site wo_status
                      wo_svar_acct wo_svar_sub wo_svar_cc
                      wo_svrr_acct wo_svrr_sub wo_svrr_cc
                      wo_type
                      wo_xvar_acct wo_xvar_sub wo_xvar_cc
                      wo_yield_pct)
/*N014*        END REPLACEMENT */

/*J23R*/     where wo_lot = wolot:
/*J23R*/ end. /* for first wo_mstr */


        {mfdel.i mrp_det "where mrp_dataset = ""wod_det""
                and mrp_nbr = wo_nbr
                and mrp_line = wo_lot"}

/*N0GD* {mfmrw.i "wo_mstr" wo_part wo_nbr wo_lot """"
                wo_rel_date wo_due_date 0
                  "SUPPLYF" {&rerpexd_p_1} wo_site}     */

/*N0GD*/ {mfmrw.i "wo_mstr" wo_part wo_nbr wo_lot """"
               wo_rel_date wo_due_date 0
                  "SUPPLYF" wkorder wo_site}


        {mfmrwdel.i "wo_scrap" wo_part wo_nbr wo_lot """"}

     end.

/*J23R** find rps_mstr where rps_record = integer(wolot) no-error.   */

/*J23R*/ for first rps_mstr
/*J23R*/     fields (rps_bom_code rps_due_date rps_line rps_part
/*J23R*/             rps_qty_comp rps_qty_req rps_record rps_rel_date
/*J23R*/             rps_routing rps_site)
/*J23R*/     where rps_record = integer(wolot):
/*J23R*/ end. /* for first rps_mstr */

        if available(rps_mstr) and length(string(rps_record)) > 8 then
        do transaction:
        /* save the >8 char number */
        old_lot = wolot.

        /*delete the repetitive mrp_det records for the old lot*/
        {dateconv.i rps_due_date rpsnbr}
        rpsnbr = rpsnbr + rps_site.
        {mfmrwdel.i "rps_mstr" rps_part rpsnbr string(rps_record) """"}
        {mfmrwdel.i "rps_scrap" rps_part rpsnbr string(rps_record) """"}

        rpsrecord = integer(substring(string(rps_record),
                length(string(rps_record)) - 7,8)).
        do while
        can-find(rps_mstr where rps_record = rpsrecord):
            rpsrecord = rpsrecord + 1.
        end.
        rps_record = rpsrecord.
        if can-find(wo_mstr where wo_lot = string(rpsrecord))
        then do:
            wolot = string(rpsrecord).
            do while
            can-find(rps_mstr where rps_record = integer(wolot)):
/*J04R*         {mfnctrl.i woc_ctrl woc_lot wo_mstr wo_lot wolot} */
/*J04R*/        {mfnxtsq.i wo_mstr wo_lot woc_sq01 wolot}
            end.
            rpsrecord = integer(wolot).
        end.
        rps_record = rpsrecord.
        wolot = string(rps_record).

/*J04R*     find wo_mstr exclusive where wo_lot = old_lot no-error.    */
/*J04R*/    find wo_mstr exclusive-lock where wo_lot = old_lot no-error.
            if available wo_mstr then
            wo_lot = wolot.

/*J04R*     for each wod_det exclusive where wod_lot = old_lot :     */
/*J04R*/    for each wod_det exclusive-lock where wod_lot = old_lot :
/*F0TB              wo_lot = wolot.   */
/*F0TB*/            wod_lot = wolot.
        end.

/*J04R*     for each wr_route exclusive where wr_lot = old_lot :     */
/*J04R*/    for each wr_route exclusive-lock where wr_lot = old_lot :
            wr_lot = wolot.
        end.

        end. /* record  > 8 */
