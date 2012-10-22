/* GUI CONVERTED from gppiqty2.p (converter v1.69) Mon Apr 28 23:09:02 1997 */
/* gppiqty2.p - UPDATE ACCUM QTY AND REPRICING WORKFILES                */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/*V8:ConvertMode=Maintenance                                            */
/* REVISION: 8.5      LAST MODIFIED: 03/31/95   BY: afs *J042*          */
/*                                   07/24/95   BY: afs *J05H*          */
/*                                   08/09/95   BY: srk *J06N*          */
/*                                   07/15/96   BY: ajw *J0Z6*          */
/* REVISION: 8.5      LAST MODIFIED: 04/08/97   BY: *J1N4* Aruna Patil  */

/***************************************************************
*
* This subroutine creates or updates the accumulated quantity
* workfile and (optionally) the repricing workfile based on
* passed in item and quantity information.
*
* Each call to this routine may create/update up to four
* records in the quantity workfile (due to pricing break
* categories and unit of measure conversion.
*
* A single record will be created in the repricing workfile
* (unless it already exists), and any number of records may by
* updated (though in principle these records will only be
* associated with a single line).
*
***************************************************************/


/****  INPUT PARAMETERS  ************************************************

1. docline   - Document Line number.
2. docpart   - Document Part number.
3. docqtyord - Document Quantity ordered.
4. docum     - Document Unit of Measure.
5. extlist   - Extended list price.
6. parent    - Whether this part is a parent or a component.
7. reprice   - Whether this routine needs to reprice affected quantities on
               other lines.  Typically this flag is only used when new
               lines are being added to an existing document.
8. update_reprice
             - Whether the reprice flag in the workfile should be updated.
               Typically this would be 'yes' unless the program that is
               calling this routine only wants to build the workfile.
               qppiqty1.p does this.

The shared workfiles wqty_wkfl and wrep_wkfl must also be defined
before calling this subroutine.  Updates to these files are the only
effects of this subroutine.

*************************************************************************/

         {mfdeclre.i}

         define input parameter docline   like sod_line.
         define input parameter docpart   like sod_part.
         define input parameter docqtyord like sod_qty_ord.
         define input parameter extlist   like sod_list_pr.
         define input parameter docum     like sod_um.
         define input parameter parent    like mfc_logical.
         define input parameter reprice   like mfc_logical.
/*J0Z6*/ define input parameter update_reprice like mfc_logical.

         define variable add_rep_rec      like mfc_logical           no-undo.
         define variable chk_case         like mfc_logical extent 4  no-undo.
         define variable conv             as decimal           no-undo.
         define variable mark_line        like sod_line        no-undo.
         define variable mark_rep         like mfc_logical           no-undo.
         define variable ptbreakcat       like pt_break_cat    no-undo.
         define variable ptum             like pt_um           no-undo.
         define variable reprice_chk      like mfc_logical           no-undo.
         define variable temp_rep         like mfc_logical           no-undo.
         define variable tot_cases        as integer           no-undo.
         define variable tot_cases_start  as integer           no-undo.


         {pppiwqty.i}  /* Define workfile for item quantities */


         find pt_mstr where pt_part = docpart no-lock no-error.
         if available pt_mstr then do:
            assign
               ptum       = pt_um
               ptbreakcat = pt_break_cat .

            if pt_um <> docum then do:
               {gprun.i ""gpumcnv.p""
               "(docum, ptum, pt_part,output conv)"}
/*GUI*/ if global-beam-me-up then undo, leave.

               /* This shouldn't happen, but if we can't convert, ignore */
               if conv = ? then assign
                  ptum = ""
                  conv = 1 .
            end.
            else
               conv = 1.
         end.
         else assign
            ptum       = ""
            ptbreakcat = ""
            conv       = 1 .


         /*****************************************************************
         *
         *  In order to process the quantity workfile (which could be
         *  large) in a single pass, I'm going to determine which quantity
         *  records could be updated by the passed-in item/qty/um
         *  combination.  Then I will mark the cases as I encounter them
         *  in the loop and leave the loop as soon as all cases are
         *  accounted for.  If I get to the end of the loop and still have
         *  cases not accounted for, I will create the appropriate records.
         *
         *  The combinations that could occur are:
         *
         *     1   item      - ord UM
         *     2   break cat - ord UM
         *     3   item      - stock UM
         *     4   break cat - stock UM
         *
         *  Only the first case is guaranteed to occur.
         *
         *****************************************************************/

         /* Check to see which cases occur */
         /* Case 1 - Item + Order UM */
         assign
            chk_case[1] = true
            tot_cases   = 1 .
         /* Case 2 - Break Cat + Order UM */
         if ptbreakcat <> "" and ptbreakcat <> docpart then assign
            chk_case[2] = true
            tot_cases   = tot_cases + 1 .
         /* Case 3 - Item + Stock UM */
         if ptum <> "" and ptum <> docum then assign
            chk_case[3] = true
            tot_cases   = tot_cases + 1 .
         /* Case 4 - Break Cat + Stock UM */
         if chk_case[2] and chk_case[3] then assign
            chk_case[4] = true
            tot_cases   = tot_cases + 1 .

         tot_cases_start = tot_cases.

         /* Check for existing Quantity Workfile records to update */
         for each wqty_wkfl
            where (wqty_cat = docpart
                   or ptbreakcat <> "" and wqty_cat = ptbreakcat)
              and (wqty_um = docum
                   or ptum <> "" and wqty_um = ptum)
            exclusive-lock.

            if wqty_cat = docpart then do:
               if wqty_um = docum then
                  chk_case[1] = false.
               else
                  chk_case[3] = false.
            end.
            else do:
               if wqty_um = docum then
                  chk_case[2] = false.
               else
                  chk_case[4] = false.
            end.

            if wqty_um = docum then assign
               wqty_qty  = wqty_qty + docqtyord
               wqty_ext  = wqty_ext + extlist .
            else assign
               wqty_qty  = wqty_qty + docqtyord * conv
               wqty_ext  = wqty_ext + extlist .

            tot_cases = tot_cases - 1.
            if tot_cases = 0 then leave.

         end.

         /* Check for repricing if any qty updates occured */
         if reprice and tot_cases < tot_cases_start then reprice_chk = true.

         /* Create new records for any cases not covered */
         if chk_case[1] then do:
            create wqty_wkfl.
            assign
               wqty_cat = docpart
               wqty_um  = docum
               wqty_qty = docqtyord
               wqty_ext = extlist .
         end.
         if chk_case[2] then do:
            create wqty_wkfl.
            assign
               wqty_cat = ptbreakcat
               wqty_um  = docum
               wqty_qty = docqtyord
               wqty_ext = extlist .
         end.
         if chk_case[3] then do:
            create wqty_wkfl.
            assign
               wqty_cat = docpart
               wqty_um  = ptum
               wqty_qty = docqtyord * conv
               wqty_ext = extlist .
         end.
         if chk_case[4] then do:
            create wqty_wkfl.
            assign
               wqty_cat = ptbreakcat
               wqty_um  = ptum
               wqty_qty = docqtyord * conv
               wqty_ext = extlist .
         end.

         /* And now, the REPRICE thang */
         if reprice then do:

            /* OK, kids, listen up, this is going to be FUN, but I'm    */
            /* only going to go through this loop once.                 */
            /* Cycle through the Repricing workfile, looking for        */
            /* existing lines that might be affected by the currently   */
            /* line quantities (shared items or break categories with   */
            /* shared ordered or stocking units of measure, excluding   */
            /* the current line and any line which is already flagged   */
            /* for repricing).  If we find a line to reprice, we need   */
            /* to make sure that we mark all of the workfile records    */
            /* for this line (remember that there is (at least) one     */
            /* reprice workfile record for each line/component).        */
            /*                                                          */
            /* At the same time, we need to make sure that we add the   */
            /* current line to the Repricing workfile.  Since the file  */
            /* is sorted by line number, if we get past our line number */
            /* without finding our line/comp, we will add it.  If other */
            /* components exist for this line, we will make sure the    */
            /* new line matches the others.  We also check at the end   */
            /* to make sure that we did find (or add) the current line. */

            find first wrep_wkfl exclusive-lock no-error.

            add_rep_rec = true.
/*J0Z6* /*J05H*/    do while available wrep_wkfl:         */
/*J0Z6*/    do while (available wrep_wkfl) and update_reprice:

               /* Check for current line/comp */
               if wrep_line = docline and wrep_part = docpart then
                  add_rep_rec = false.

               /* Add current line if we've gone past were it should be */
               if wrep_line > docline and add_rep_rec then do:
                  find prev wrep_wkfl no-lock no-error.
                  /* Match new reprice flag for others for this line */
                  if available wrep_wkfl and wrep_line = docline
                     then temp_rep = wrep_rep.
                     else temp_rep = false.
                  create wrep_wkfl.
                  assign wrep_line   = docline
                         wrep_part   = docpart
                         wrep_um     = docum
                         wrep_cat    = ptbreakcat
                         wrep_parent = parent
                         wrep_rep    = temp_rep.
                  add_rep_rec = false.
                  if not reprice_chk then leave.
                  find next wrep_wkfl exclusive-lock.
               end.

               /* Mark this line/comp if it matches */
               if     (wrep_part = docpart
                       or (ptbreakcat <> "" and wrep_cat = ptbreakcat))
/*J1N4**          and (wrep_um = docum                       */
/*J1N4**                or (ptum <> "" and wrep_um = ptum))  */
                  and not wrep_rep
                  and wrep_line <> docline
                  then do:
/*J1N4*/          if wrep_part <> docpart and wrep_cat = ptbreakcat then
/*J1N4*/             find pt_mstr where pt_part = wrep_part no-lock no-error.
/*J1N4*/          if available pt_mstr and pt_um = ptum then do:
                  mark_line = wrep_line.
                  /* Find first record for this line */
                  find prev wrep_wkfl no-lock no-error.
/*J05H*/          do while available wrep_wkfl
                               and wrep_line = mark_line:
                     find prev wrep_wkfl no-lock no-error.
                  end.
                  find next wrep_wkfl exclusive-lock no-error.
                  /* Mark all records for this line */
/*J05H*/          do while available wrep_wkfl
                               and wrep_line = mark_line:
                     wrep_rep = true.
                     find next wrep_wkfl exclusive-lock no-error.
                  end.
/*J1N4*/       end. /* IF AVAILABLE pt_mstr AND pt_um = ptum */
               end.

               /* Otherwise just move on */
               else
                  find next wrep_wkfl exclusive-lock no-error.

            end.

            /* Add the current line/comp if we haven't already done so */
            if add_rep_rec then do:
               create wrep_wkfl.
               assign wrep_line   = docline
                      wrep_part   = docpart
                      wrep_um     = docum
                      wrep_cat    = ptbreakcat
                      wrep_parent = parent
                      wrep_rep    = false.
            end.

         end.  /* Repricing File Update */