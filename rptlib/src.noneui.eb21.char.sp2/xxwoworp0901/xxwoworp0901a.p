/* woworp9a.p - WORK ORDER WIP COST REPORT                              */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/* $Revision: 1.20 $                                                    */
/*V8:ConvertMode=Report                                                 */
/* REVISION: 7.0    LAST EDIT: 10/23/91   MODIFIED BY: pma  *F003* */
/* REVISION: 7.0    LAST EDIT: 08/30/94   MODIFIED BY: ais  *FQ61* */
/* REVISION: 7.5    LAST EDIT: 10/19/94   MODIFIED BY: taf  *J035* */
/* REVISION: 7.5    LAST EDIT: 02/27/94   MODIFIED BY: tjs  *J027* */
/* REVISION: 8.5    LAST MODIFIED: 02/04/97   BY: *J1GW* Julie Milligan     */
/* REVISION: 8.6    LAST MODIFIED: 10/14/97   BY: ays *K0YS*                */
/* REVISION: 8.6    LAST MODIFIED: 11/22/97   BY: *J26S* Sandesh Mahagaokar */
/* REVISION: 8.6E   LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane          */
/* REVISION: 8.6E   LAST MODIFIED: 05/17/98   BY: *J2MS* Dana Tunstall      */
/* REVISION: 8.6E   LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan         */
/* REVISION: 9.1    LAST MODIFIED: 10/01/99   BY: *N014* Patti Gaultney     */
/* REVISION: 9.1    LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1    LAST MODIFIED: 08/12/00   BY: *N0KC* myb                */
/* REVISION: 9.1    LAST MODIFIED: 08/17/00   BY: *N0LW* Arul Victoria      */
/* REVISION: 9.1    LAST MODIFIED: 12/27/00   BY: *M0YW* Vandna Rohira      */
/* Old ECO marker removed, but no ECO header exists *F0PN*                  */
/* Revision: 1.16          BY: Katie Hilbert      DATE: 04/01/01  ECO: *P008* */
/* Revision: 1.18  BY: Dave Caveney DATE: 08/12/02 ECO: *P0DY* */
/* $Revision: 1.20 $ BY: Paul Donnelly (SB) DATE: 06/28/03 ECO: *Q00N* */
/* $Revision: 1.20 $ BY: Bill Jiang DATE: 05/06/08 ECO: *SS - 090411.1* */
/*-Revision end---------------------------------------------------------------*/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* SS - 090411.1 - B */
{xxwoworp0901.i}
/* SS - 090411.1 - E */

{mfdeclre.i}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE woworp9a_p_1 "Material!Labor"
/* MaxLen: Comment: */

&SCOPED-DEFINE woworp9a_p_2 "Burden!Subcontract"
/* MaxLen: Comment: */

&SCOPED-DEFINE woworp9a_p_4 "Avg Unit Cost"
/* MaxLen: Comment: */

&SCOPED-DEFINE woworp9a_p_6 "Completed Cost! WIP Cost"
/* MaxLen: Comment: */

&SCOPED-DEFINE woworp9a_p_10 "Work Order!Batch"
/* MaxLen: Comment: */

&SCOPED-DEFINE woworp9a_p_11 "Qty Finish!Open"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

{wbrp02.i}

define shared variable nbr                like wo_nbr.
define shared variable nbr1               like wo_nbr.
define shared variable lot                like wo_lot.
define shared variable lot1               like wo_lot.
define shared variable part               like wo_part.
define shared variable part1              like wo_part.
define shared variable site               like wo_site.
define shared variable site1              like wo_site.
define shared variable acct               like wo_acct.
define shared variable acct1              like wo_acct.
define shared variable sub                like wo_sub.
define shared variable sub1               like wo_sub.
define shared variable cc                 like wo_cc.
define shared variable cc1                like wo_cc.
define shared variable proj               like wo_project.
define shared variable proj1              like wo_project.
define shared variable vend               like wo_vend.
define shared variable so_job             like wo_so_job.
define        variable desc1              like pt_desc1.
define        variable qty_comp           like wo_qty_comp
   column-label {&woworp9a_p_11}.
define        variable qty_open           like qty_comp.
define        variable avg_cost           like sct_cst_tot
   label {&woworp9a_p_4}.
define        variable cost_std           like sct_cst_tot.
define        variable total_std          like wo_wip_tot
   column-label {&woworp9a_p_6}.
define        variable mtl_tot            like wo_mtl_tot
   format "->>>,>>>,>>9.99<<<<<<<<".
define        variable lbr_tot            like wo_lbr_tot
   format "->>>,>>>,>>9.99<<<<<<<<".
define        variable bdn_tot            like wo_bdn_tot
   format "->>>,>>>,>>9.99<<<<<<<<".
define        variable sub_tot            like wo_sub_tot
   format "->>>,>>>,>>9.99<<<<<<<<".
define        variable comp_tot           like wo_wip_tot
   format "->>>,>>>,>>9.99<<<<<<<<".
define        variable wip_tot            like wo_wip_tot
   format "->>>,>>>,>>9.99<<<<<<<<".
define        variable save_base_id       like wo_base_id.
define        variable base_wip_tot       like wo_wip_tot.
define        variable jp_hdr_reqd        like mfc_logical initial no.
define        variable wip_cost_reqd      like mfc_logical initial no.

define        variable skip_last_of_proj  like mfc_logical no-undo.
define        variable skip_last_of_cc    like mfc_logical no-undo.
define        variable skip_last_of_sub   like mfc_logical no-undo.
define        variable skip_last_of_acct  like mfc_logical no-undo.
define        variable skip_last_of_nbr   like mfc_logical no-undo.
define        variable skip_report_totals like mfc_logical no-undo.

/* FIND AND DISPLAY */
/* CUMULATIVE AND SCHEDULED WORK ORDERS SHOULD NOT BE SELECTED */

for each wo_mstr
   fields( wo_domain wo_acct     wo_base_id  wo_batch      wo_bdn_tot
           wo_bdn_totx wo_cc       wo_joint_type wo_lbr_tot
           wo_lbr_totx wo_lot      wo_mtl_tot    wo_mtl_totx
           wo_nbr      wo_part     wo_project    wo_qty_comp
           wo_qty_ord  wo_qty_rjct wo_site       wo_so_job
           wo_status   wo_sub      wo_sub_tot    wo_sub_totx
           wo_type     wo_vend     wo_wip_tot)
 where wo_mstr.wo_domain = global_domain and (
      (wo_acct >= acct) and (wo_acct <= acct1 or acct1 = "" )
      and (wo_sub >= sub) and (wo_sub <= sub1 or sub1 = "" )
      and (wo_cc >= cc) and (wo_cc <= cc1 or cc1 = "" )
      and (wo_project >= proj) and (wo_project <= proj1 or proj1 = "" )
      and (wo_nbr >= nbr) and (wo_nbr <= nbr1 or nbr1 = "" )
      and (wo_lot >= lot) and (wo_lot <= lot1 or lot1 = "" )
      and (wo_part >= part) and (wo_part <= part1 or part1 = "" )
      and (wo_site >= site) and (wo_site <= site1 or site1 = "" )
      and (wo_vend = vend or vend = "" )
      and (wo_so_job = so_job or so_job = "" )
      and wo_status <> "P"
      /* SS - 090411.1 - B 
      and wo_type <> "C"
      SS - 090411.1 - E */
      and wo_type <> "S"
      ) no-lock break by wo_acct
      by wo_sub
      by wo_cc
      by wo_project
      by wo_nbr
      by wo_type
      by wo_base_id
      by wo_lot
   with frame b:

   /* ANY OF THE FOLLOWING LOGICAL VARIABLE WILL BE SET IF FIRST RECORD    */
   /* FOR THE RESPECTIVE BREAK GROUP IS FOUND.                             */
   if first    (wo_acct)    then skip_report_totals = yes.
   if first-of (wo_project) then skip_last_of_proj  = yes.
   if first-of (wo_cc)      then skip_last_of_cc    = yes.
   if first-of (wo_sub)     then skip_last_of_sub   = yes.
   if first-of (wo_acct)    then skip_last_of_acct  = yes.
   if first-of (wo_nbr)     then skip_last_of_nbr   = yes.

   /*  FOLLOWING SECTION IS MODIFIED TO ALLOW EACH AND EVERY wo_mstr RECORD */
   /*  TO EXECUTE last-of LOGIC FOLLOWED IN THIS PROGRAM.                   */
   if (wo_wip_tot <> 0 or
      (index("1234",wo_joint_type) > 0 and save_base_id = wo_base_id))
   then do:

      form
         wo_nbr         column-label {&woworp9a_p_10}
         wo_lot
         wo_part        format "x(24)"
         wo_mtl_tot     column-label {&woworp9a_p_1}
                        format "->>>,>>>,>>9.99<<<<<<<<"
         wo_bdn_tot     column-label {&woworp9a_p_2}
                        format "->>>,>>>,>>9.99<<<<<<<<"
         qty_comp
         avg_cost       format "->>>,>>>,>>9.99<<<<<<<<"
         total_std      format "->>>,>>>,>>9.99<<<<<<<<"
      with frame b down width 132 no-attr-space.

      /* SS - 090411.1 - B */
      /*
      /* SET EXTERNAL LABELS */
      setFrameLabels(frame b:handle).

      form
         wo_acct
         wo_sub    no-label
         wo_cc     no-label
         wo_project
      with frame phead1 width 132 page-top no-attr-space side-labels.

      /* SET EXTERNAL LABELS */
      setFrameLabels(frame phead1:handle).
      */
      /* SS - 090411.1 - B */

      if wo_joint_type = "5" then
         save_base_id = wo_lot. /*BaseSorts 1st*/

      /* THE FOLLOWING SECTION WILL RESET THE LOGICAL VARIABLE FOR A BREAK   */
      /* GROUP AFTER PROCESSING FIRST VALID RECORD OF THE RESPECTIVE BREAK   */
      /* GROUP                                                               */
      assign
         skip_report_totals = no
         skip_last_of_nbr   = no.
      if (skip_last_of_proj = yes or
          skip_last_of_cc   = yes or
          skip_last_of_sub  = yes or
          skip_last_of_acct = yes)
      then do:
         if skip_last_of_proj = yes then skip_last_of_proj = no.
         if skip_last_of_cc   = yes then skip_last_of_cc   = no.
         if skip_last_of_sub  = yes then skip_last_of_sub  = no.
         if skip_last_of_acct = yes then skip_last_of_acct = no.

         /* SS - 090411.1 - B */
         /*
         if page-size - line-counter < 7 then page.

         display
            wo_acct
            wo_sub
            wo_cc
            wo_project
         with frame phead1.
         */
         /* SS - 090411.1 - B */
      end.
      /* SS - 090411.1 - B */
      /*
      else view frame phead1.
      */
      /* SS - 090411.1 - E */

      desc1 = "".
       for first pt_mstr
         fields( pt_domain pt_desc1 pt_part)
          where pt_mstr.pt_domain = global_domain and  pt_part = wo_part
          no-lock:
      end. /* FOR FIRST pt_mstr */
      if available pt_mstr
      then do:
         desc1 = pt_desc1.

         for first in_mstr
            fields( in_domain in_cur_set in_gl_set in_part in_site
            in_gl_cost_site)
             where in_mstr.in_domain = global_domain and  in_part = pt_part and
                  in_site = wo_site
            no-lock:
         end. /* FOR FIRST in_mstr */
         {gpsct03.i &cost=sct_cst_tot}
         cost_std = glxcst.
      end.
      assign
         qty_comp = wo_qty_comp + wo_qty_rjct
         qty_open = wo_qty_ord - qty_comp.

      /* REGULAR PRODUCTS */
      if wo_joint_type = "" then
      assign
         total_std = wo_mtl_tot + wo_lbr_tot + wo_bdn_tot + wo_sub_tot
                     - wo_wip_tot
         avg_cost = ((wo_mtl_tot + wo_lbr_tot + wo_bdn_tot + wo_sub_tot)
                      - wo_wip_tot) / qty_comp.
      /* JOINT PRODUCTS */
      else do:
         if wo_joint_type = "5" then total_std = 0.
         else
         assign
            total_std = wo_mtl_totx + wo_lbr_totx +
                        wo_bdn_totx + wo_sub_totx
            avg_cost = total_std / qty_comp.
      end.
      if avg_cost = ? then avg_cost = cost_std.

      /* SS - 090411.1 - B */
      /*
      accumulate wo_mtl_tot (total by wo_project by wo_cc by wo_sub by wo_acct).
      accumulate wo_lbr_tot (total by wo_project by wo_cc by wo_sub by wo_acct).
      accumulate wo_bdn_tot (total by wo_project by wo_cc by wo_sub by wo_acct).
      accumulate wo_sub_tot (total by wo_project by wo_cc by wo_sub by wo_acct).
      accumulate total_std  (total by wo_project by wo_cc by wo_sub by wo_acct).
      accumulate wo_wip_tot (total by wo_project by wo_cc by wo_sub by wo_acct).

      if page-size - line-counter < 2 then page.
      */
      /* SS - 090411.1 - E */

      if jp_hdr_reqd then do:

         /* SS - 090411.1 - B */
         /*
         display
            getTermLabelRtColon("CO/BY-PRODUCTS",18) @ wo_part
         with frame b.
         down with frame b.
         */
         /* SS - 090411.1 - E */
         jp_hdr_reqd = no.
      end.

      /* SS - 090411.1 - B */
      /*
      display
         wo_nbr
         wo_lot
         wo_part
         wo_mtl_tot when (index("1234",wo_joint_type) = 0)
         wo_bdn_tot when (index("1234",wo_joint_type) = 0)
         qty_comp   when (wo_joint_type <> "5")
         avg_cost   when (wo_joint_type <> "5" and avg_cost <> ?)
         total_std  when (wo_joint_type <> "5")
      with frame b.
      down with frame b.
      */
      /* SS - 090411.1 - E */

      if wo_joint_type = "" then
      /* SS - 090411.1 - B */
      /*
      display
         desc1 @ wo_part
         wo_lbr_tot @ wo_mtl_tot
         wo_sub_tot @ wo_bdn_tot
         qty_open @ qty_comp
         wo_wip_tot @ total_std
      with frame b.
      */
      DO:
            CREATE ttxxwoworp0901.
            ASSIGN
               ttxxwoworp0901_acct = wo_acct
               ttxxwoworp0901_sub = wo_sub
               ttxxwoworp0901_cc = wo_cc
               ttxxwoworp0901_project = wo_project

               ttxxwoworp0901_nbr = wo_nbr
               ttxxwoworp0901_lot = wo_lot
               ttxxwoworp0901_part = wo_part
               ttxxwoworp0901_mtl_tot = wo_mtl_tot
               ttxxwoworp0901_bdn_tot = wo_bdn_tot
               ttxxwoworp0901_qty_comp = qty_comp
               ttxxwoworp0901_avg_cost = avg_cost
               ttxxwoworp0901_total_std = total_std

               ttxxwoworp0901_desc1 = desc1
               ttxxwoworp0901_lbr_tot = wo_lbr_tot
               ttxxwoworp0901_sub_tot = wo_sub_tot
               ttxxwoworp0901_qty_open = qty_open
               ttxxwoworp0901_wip_tot = wo_wip_tot

               ttxxwoworp0901_site = wo_site
               ttxxwoworp0901_qty_ord = wo_qty_ord

               .
      END.
      /* SS - 090411.1 - E */

      /* SS - 090411.1 - B */
      /*
      else
      if wo_joint_type = "5" then  /* Base Process */
      display
         wo_batch @ wo_nbr
         desc1 @ wo_part
         wo_lbr_tot @ wo_mtl_tot
         wo_sub_tot @ wo_bdn_tot
      with frame b.

      else                         /* Joint Products */
      display
         desc1 @ wo_part
         qty_open @ qty_comp
         wo_wip_tot @ total_std
      with frame b.
      down with frame b.
      */
      else
      if wo_joint_type = "5" then  /* Base Process */
      DO:
          CREATE ttxxwoworp0901.
               ASSIGN
                  ttxxwoworp0901_acct = wo_acct
                  ttxxwoworp0901_sub = wo_sub
                  ttxxwoworp0901_cc = wo_cc
                  ttxxwoworp0901_project = wo_project
   
                  ttxxwoworp0901_nbr = wo_nbr
                  ttxxwoworp0901_lot = wo_lot
                  ttxxwoworp0901_part = wo_part
                  ttxxwoworp0901_mtl_tot = wo_mtl_tot
                  ttxxwoworp0901_bdn_tot = wo_bdn_tot
                  ttxxwoworp0901_qty_comp = qty_comp
                  ttxxwoworp0901_avg_cost = avg_cost
                  ttxxwoworp0901_total_std = total_std
   
                  ttxxwoworp0901_desc1 = desc1
                  ttxxwoworp0901_lbr_tot = wo_lbr_tot
                  ttxxwoworp0901_sub_tot = wo_sub_tot
                  ttxxwoworp0901_qty_open = qty_open
                  ttxxwoworp0901_wip_tot = wo_wip_tot
   
                  ttxxwoworp0901_site = wo_site
                  ttxxwoworp0901_qty_ord = wo_qty_ord

                  /* 2.1 */
                  ttxxwoworp0901_batch = wo_batch
                  .
      END.
      /* SS - 090411.1 - E */

      if wo_joint_type = "5" then
      assign
         jp_hdr_reqd = yes
         wip_cost_reqd = yes
         base_wip_tot = wo_wip_tot.

   end. /* IF wo_mstr RECORD IS VALID */

   /* THE WIP COST WILL BE DISPLAYED IF THE FLAG skip_last_of_nbr = no   */
   if wip_cost_reqd and last-of (wo_nbr) and skip_last_of_nbr = no
   then do:
      /* SS - 090411.1 - B */
      /*
      display
         getTermLabelRtColon("WIP_COST",15) @ avg_cost
         base_wip_tot @ total_std
      with frame b.
      down with frame b.
      */
      DO:
          CREATE ttxxwoworp0901.
          ASSIGN
             ttxxwoworp0901_acct = wo_acct
             ttxxwoworp0901_sub = wo_sub
             ttxxwoworp0901_cc = wo_cc
             ttxxwoworp0901_project = wo_project

             ttxxwoworp0901_nbr = wo_nbr
             ttxxwoworp0901_lot = wo_lot
             ttxxwoworp0901_part = wo_part
             ttxxwoworp0901_mtl_tot = wo_mtl_tot
             ttxxwoworp0901_bdn_tot = wo_bdn_tot
             ttxxwoworp0901_qty_comp = qty_comp
             ttxxwoworp0901_avg_cost = avg_cost
             ttxxwoworp0901_total_std = total_std

             ttxxwoworp0901_desc1 = desc1
             ttxxwoworp0901_lbr_tot = wo_lbr_tot
             ttxxwoworp0901_sub_tot = wo_sub_tot
             ttxxwoworp0901_qty_open = qty_open
             /* 3.1 */
             ttxxwoworp0901_wip_tot = base_wip_tot

             ttxxwoworp0901_site = wo_site
             ttxxwoworp0901_qty_ord = wo_qty_ord
             .
      END.
      /* SS - 090411.1 - E */
      wip_cost_reqd = no.
   end.

   /*  FOLOWING SECTION WILL PRINT PROJECT TOTAL IF THERE EXISTS AT   */
   /*  LEAST ONE RECORD IN BREAK GROUPS wo_project and wo_cc WHICH    */
   /*  ACCUMULATE TOTALS.                                             */
   /* SS - 090411.1 - B */
   /*
   if last-of (wo_project)   and
      skip_last_of_proj = no and
      (wo_project <> ""      or
      not (last-of (wo_cc)  and skip_last_of_cc = yes)
      )
   then do with frame b:

      if page-size - line-counter < 4 then do:
         down with frame b.
         page.
      end.
      else down 2 with frame b.

      display
         getTermLabel("PROJECT",7) + " " + wo_project + " " +
         getTermLabelRtColon("TOTAL",7) @ wo_part
         accum total by wo_project wo_mtl_tot @ wo_mtl_tot
         accum total by wo_project wo_bdn_tot @ wo_bdn_tot
         accum total by wo_project total_std  @ total_std.
      down with frame b.

      display
         accum total by wo_project wo_lbr_tot @ wo_mtl_tot
         accum total by wo_project wo_sub_tot @ wo_bdn_tot
         accum total by wo_project wo_wip_tot @ total_std.
   end.

   /* THE FOLLOWING SECTION WILL PRINT CC TOTAL IF THERE EXISTS AT   */
   /* LEAST ONE RECORD IN BREAK GROUPS wo_cc AND wo_sub WHICH        */
   /* ACCUMULATES TOTALS.                                            */
   if last-of (wo_cc)         and
      skip_last_of_cc = no    and
      (wo_cc <> ""            or
      not (last-of (wo_sub) and skip_last_of_sub = yes)
      )
   then do with frame b:

      if page-size - line-counter < 4 then do:
         down with frame b.
         page.
      end.
      else down 2 with frame b.

      display
         getTermLabel("COST_CENTER",10) + " " + wo_cc + " " +
         getTermLabelRtColon("TOTAL",8) @ wo_part
         accum total by wo_cc wo_mtl_tot @ wo_mtl_tot
         accum total by wo_cc wo_bdn_tot @ wo_bdn_tot
         accum total by wo_cc total_std  @ total_std.
      down with frame b.
      display
         accum total by wo_cc wo_lbr_tot @ wo_mtl_tot
         accum total by wo_cc wo_sub_tot @ wo_bdn_tot
         accum total by wo_cc wo_wip_tot @ total_std.
   end.

   /* THE FOLLOWING SECTION WILL PRINT SUB TOTAL IF THERE EXISTS AT  */
   /* LEAST ONE RECORD IN BREAK GROUPS wo_sub AND wo_acct WHICH      */
   /* ACCUMULATES TOTALS.                                            */
   if last-of (wo_sub)         and
      skip_last_of_sub = no    and
      (wo_sub <> ""            or
      not (last-of (wo_acct) and skip_last_of_acct = yes)
      )
   then do with frame b:

      if page-size - line-counter < 4 then do:
         down with frame b.
         page.
      end.
      else down 2 with frame b.

      display
         getTermLabel("SUB-ACCOUNT",8) + " " + wo_sub + " " +
         getTermLabelRtColon("TOTAL",6) @ wo_part
         accum total by wo_sub wo_mtl_tot @ wo_mtl_tot
         accum total by wo_sub wo_bdn_tot @ wo_bdn_tot
         accum total by wo_sub total_std  @ total_std.
      down with frame b.
      display
         accum total by wo_sub wo_lbr_tot @ wo_mtl_tot
         accum total by wo_sub wo_sub_tot @ wo_bdn_tot
         accum total by wo_sub wo_wip_tot @ total_std.
   end.

   /*  FOLOWING SECTION WILL PRINT ACCOUNT TOTAL IF THERE EXISTS AT       */
   /*  LEAST ONE RECORD IN BREAK GROUP wo_acct WHICH ACCUMULATE TOTALS.   */
   if last-of (wo_acct) and skip_last_of_acct = no
   then do:

      if page-size - line-counter < 4 then do:
         down with frame b.
         page.
      end.
      else down 2 with frame b.

      display
         getTermLabel("ACCOUNT",7) + " " + wo_acct + " " +
         getTermLabelRtColon("TOTAL",7) @ wo_part
         accum total by wo_acct wo_mtl_tot @ wo_mtl_tot
         accum total by wo_acct wo_bdn_tot @ wo_bdn_tot
         accum total by wo_acct total_std  @ total_std.
      down with frame b.
      display
         accum total by wo_acct wo_lbr_tot @ wo_mtl_tot
         accum total by wo_acct wo_sub_tot @ wo_bdn_tot
         accum total by wo_acct wo_wip_tot @ total_std.
   end.

   /* FOLOWING SECTION WILL PRINT REPORT TOTAL IF THERE EXISTS AT */
   /* LEAST ONE RECORD WHICH ACCUMULATE TOTALS.                   */
   if last (wo_acct) and skip_report_totals = no
   then do with frame b:

      hide frame phead1.

      if page-size - line-counter < 4 then do:
         down with frame b.
         page.
      end.
      else down 2 with frame b.

      display
         getTermLabelRtColon("REPORT_TOTAL",18) @ wo_part
         accum total wo_mtl_tot @ wo_mtl_tot
         accum total wo_bdn_tot @ wo_bdn_tot
         accum total total_std  @ total_std.
      down with frame b.

      display
         accum total wo_lbr_tot @ wo_mtl_tot
         accum total wo_sub_tot @ wo_bdn_tot
         accum total wo_wip_tot @ total_std.
   end.
   */
   /* SS - 090411.1 - E */

   {mfrpchk.i}
end.
{wbrp04.i}
