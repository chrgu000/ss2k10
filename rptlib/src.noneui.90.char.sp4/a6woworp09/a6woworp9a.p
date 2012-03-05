/* woworp9a.p - WORK ORDER WIP COST REPORT                              */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/*F0PN*/ /*K0YS*/
/*V8:ConvertMode=Report                                        */
/* REVISION: 7.0    LAST EDIT: 10/23/91   MODIFIED BY: pma  *F003* */
/* REVISION: 7.0    LAST EDIT: 08/30/94   MODIFIED BY: ais  *FQ61* */
/* REVISION: 7.5    LAST EDIT: 10/19/94   MODIFIED BY: taf  *J035* */
/* REVISION: 7.5    LAST EDIT: 02/27/94   MODIFIED BY: tjs  *J027* */
/* REVISION: 8.5    LAST MODIFIED: 02/04/97    BY: *J1GW* Julie Milligan */
/* REVISION: 8.6    LAST MODIFIED: 10/14/97    BY: ays *K0YS*  */
/* REVISION: 8.6    LAST MODIFIED: 11/22/97    BY: *J26S* Sandesh Mahagaokar */

/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane         */
/* REVISION: 8.6E     LAST MODIFIED: 05/17/98   BY: *J2MS* Dana Tunstall     */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan        */
/* REVISION: 9.0      LAST MODIFIED: 12/27/00   BY: *M0YW* Vandna Rohira     */
/* REVISION: 9.0      LAST MODIFIED: 08/23/05   BY: *SS - 20050823* Bill Jiang     */

/* SS - 20050823 - B */
{a6woworp09.i}

    define input parameter acct like wo_acct.
    define input parameter acct1 like wo_acct.
    define input parameter cc like wo_cc.
    define input parameter cc1 like wo_cc.
    define input parameter proj like wo_project.
    define input parameter proj1 like wo_project.

    define input parameter nbr like wo_nbr.
    define input parameter nbr1 like wo_nbr.
    define input parameter lot like wo_lot.
    define input parameter lot1 like wo_lot.
    define input parameter part like wo_part.
    define input parameter part1 like wo_part.
    define input parameter site like wo_site.
    define input parameter site1 like wo_site.

    define input parameter so_job like wo_so_job.
    define input parameter vend like wo_vend.
/* SS - 20050823 - E */

/*F003*/ {mfdeclre.i}

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE woworp9a_p_1 "物料!人工"
/* MaxLen: Comment: */

&SCOPED-DEFINE woworp9a_p_2 "转包!附加成本"
/* MaxLen: Comment: */

&SCOPED-DEFINE woworp9a_p_3 "帐户"
/* MaxLen: Comment: */

&SCOPED-DEFINE woworp9a_p_4 "平均单件成本"
/* MaxLen: Comment: */

&SCOPED-DEFINE woworp9a_p_5 "复合产品/副产品："
/* MaxLen: Comment: */

&SCOPED-DEFINE woworp9a_p_6 "完工成本!在制成本"
/* MaxLen: Comment: */

&SCOPED-DEFINE woworp9a_p_7 "项目"
/* MaxLen: Comment: */

&SCOPED-DEFINE woworp9a_p_8 "合计:"
/* MaxLen: Comment: */

&SCOPED-DEFINE woworp9a_p_9 "在制品成本:"
/* MaxLen: Comment: */

&SCOPED-DEFINE woworp9a_p_10 "加工单!批处理"
/* MaxLen: Comment: */

&SCOPED-DEFINE woworp9a_p_11 "完成量!短缺量"
/* MaxLen: Comment: */

&SCOPED-DEFINE woworp9a_p_12 "  报表合计:"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

/*K0YS*/ {wbrp02.i}


    /* SS - 20050823 - B */
    /*
         define shared variable nbr like wo_nbr.
         define shared variable nbr1 like wo_nbr.
         define shared variable lot like wo_lot.
         define shared variable lot1 like wo_lot.
         define shared variable part like wo_part.
         define shared variable part1 like wo_part.
/*FQ61*/ define shared variable site like wo_site.
/*FQ61*/ define shared variable site1 like wo_site.
         define shared variable acct like wo_acct.
         define shared variable acct1 like wo_acct.
         define shared variable cc like wo_cc.
         define shared variable cc1 like wo_cc.
         define shared variable proj like wo_project.
         define shared variable proj1 like wo_project.
         define shared variable vend like wo_vend.
         define shared variable so_job like wo_so_job.
         */
         /* SS - 20050823 - E */
         define variable desc1 like pt_desc1.
         define variable qty_comp like wo_qty_comp
            column-label {&woworp9a_p_11}.
         define variable qty_open like qty_comp.
/*F003   define variable avg_cost like pt_tot_std label "Avg Unit Cost". */
/*F003*/ define variable avg_cost like sct_cst_tot label {&woworp9a_p_4}.
/*F003   define variable cost_std like pt_tot_std. */
/*F003*/ define variable cost_std like sct_cst_tot.
         define variable total_std like wo_wip_tot
         column-label {&woworp9a_p_6}.
         define variable mtl_tot like wo_mtl_tot
            format "->>>,>>>,>>9.99<<<<<<<<".
         define variable lbr_tot like wo_lbr_tot
            format "->>>,>>>,>>9.99<<<<<<<<".
         define variable bdn_tot like wo_bdn_tot
            format "->>>,>>>,>>9.99<<<<<<<<".
         define variable sub_tot like wo_sub_tot
            format "->>>,>>>,>>9.99<<<<<<<<".
         define variable comp_tot like wo_wip_tot
            format "->>>,>>>,>>9.99<<<<<<<<".
         define variable wip_tot like wo_wip_tot
            format "->>>,>>>,>>9.99<<<<<<<<".
/*J027*/ define variable save_base_id like wo_base_id.
/*J027*/ define variable base_wip_tot like wo_wip_tot.
/*J027*/ define variable jp_hdr_reqd like mfc_logical initial no.
/*J027*/ define variable wip_cost_reqd like mfc_logical initial no.

/*J26S*/ define variable skip_last_of_proj  like mfc_logical no-undo.
/*J26S*/ define variable skip_last_of_cc    like mfc_logical no-undo.
/*J26S*/ define variable skip_last_of_acct  like mfc_logical no-undo.
/*J26S*/ define variable skip_last_of_nbr   like mfc_logical no-undo.
/*J26S*/ define variable skip_report_totals like mfc_logical no-undo.

         /* FIND AND DISPLAY */

/*J027*  for each wo_mstr where wo_wip_tot <> 0                         */
/*M0YW** /*J027*/ for each wo_mstr where                                */
/*J027*  and (wo_acct >= acct) and (wo_acct <= acct1 or acct1 = "" )    */

/*M0YW*/ /* CUMULATIVE AND SCHEDULED WORK ORDERS SHOULD NOT BE SELECTED */

/*M0YW*/ for each wo_mstr
/*M0YW*/    fields (wo_acct     wo_base_id  wo_batch      wo_bdn_tot
/*M0YW*/            wo_bdn_totx wo_cc       wo_joint_type wo_lbr_tot
/*M0YW*/            wo_lbr_totx wo_lot      wo_mtl_tot    wo_mtl_totx
/*M0YW*/            wo_nbr      wo_part     wo_project    wo_qty_comp
/*M0YW*/            wo_qty_ord  wo_qty_rjct wo_site       wo_so_job
/*M0YW*/            wo_status   wo_sub_tot  wo_sub_totx   wo_type
/*M0YW*/            wo_vend     wo_wip_tot)
/*M0YW*/ where

/*J027*/     (wo_acct >= acct) and (wo_acct <= acct1 or acct1 = "" )
         and (wo_cc >= cc) and (wo_cc <= cc1 or cc1 = "" )
         and (wo_project >= proj) and (wo_project <= proj1 or proj1 = "" )
         and (wo_nbr >= nbr) and (wo_nbr <= nbr1 or nbr1 = "" )
         and (wo_lot >= lot) and (wo_lot <= lot1 or lot1 = "" )
         and (wo_part >= part) and (wo_part <= part1 or part1 = "" )
/*FQ61*/ and (wo_site >= site) and (wo_site <= site1 or site1 = "" )
         and (wo_vend = vend or vend = "" )
         and (wo_so_job = so_job or so_job = "" )
         and wo_status <> "P"
/*M0YW*/ and wo_type <> "C"
/*M0YW*/ and wo_type <> "S"

/*J027*  no-lock break by wo_acct by wo_cc by wo_project by wo_nbr by wo_lot */
/*J027*/ no-lock break by wo_acct by wo_cc by wo_project by wo_nbr
/*J027*/ by wo_type by wo_base_id by wo_lot
         with frame b:

/*J26S*  ANY OF THE FOLLOWING LOGICAL VARIABLE WILL BE SET IF FISRST RECORD   */
/*J26S*  FOR THE RESPECTIVE BREAK GROUP IS FOUND.                             */
/*J26S*  BEGIN ADD SECTION  */
            if first    (wo_acct)    then skip_report_totals = yes.
            if first-of (wo_project) then skip_last_of_proj  = yes.
            if first-of (wo_cc)      then skip_last_of_cc    = yes.
            if first-of (wo_acct)    then skip_last_of_acct  = yes.
            if first-of (wo_nbr)     then skip_last_of_nbr   = yes.
/*J26S*  END ADD SECTION  */

/*J26S   FOLLOWING SECTION IS MODIFIED TO ALLOW EACH AND EVERY wo_mstr RECORD */
/*J26S   TO EXECUTE last-of LOGIC FOLLOWED IN THIS PROGRAM.                   */
/*J26S**    BEGIN DELETE SECTION
 * /*J027*/ if not (wo_wip_tot <> 0 or
 * /*J027*/     (index("1234",wo_joint_type) > 0 and save_base_id = wo_base_id))
 * /*J027*/ then next.
 *J26S**    END DELETE SECTION  */

/*J26S*     BEGIN ADD SECTION */
            if (wo_wip_tot <> 0 or
               (index("1234",wo_joint_type) > 0 and save_base_id = wo_base_id))
            then do:
/*J26S*     END ADD SECTION */

               form
/*J035*              wo_nbr                                           */
/*J035*/         wo_nbr column-label {&woworp9a_p_10}
                 wo_lot
                 wo_part        format "x(24)"
                 wo_mtl_tot column-label {&woworp9a_p_1}
                    format "->>>,>>>,>>9.99<<<<<<<<"
                 wo_bdn_tot column-label {&woworp9a_p_2}
                    format "->>>,>>>,>>9.99<<<<<<<<"
                 qty_comp
                 avg_cost      format "->>>,>>>,>>9.99<<<<<<<<"
                 total_std     format "->>>,>>>,>>9.99<<<<<<<<"

               with frame b down width 132 no-attr-space.


               /* SS - 20050823 - B */
               /*
/*J1GW*/       form
/*J1GW*/         wo_acct
/*J1GW*/         wo_cc no-label
/*J1GW*/         wo_project
/*J1GW*/       with frame phead1 width 132 page-top no-attr-space side-labels.
*/
/* SS - 20050823 - E */

/*J027*/       if wo_joint_type = "5" then save_base_id = wo_lot. /*BaseSorts 1st*/

/*J26S*  THE FOLLOWING SECTION WILL RESET THE LOGICAL VARIABLE FOR A BREAK   */
/*J26S*  GROUP AFTER PROCESSING FIRST VALID RECORD OF THE RESPECTIVE BREAK   */
/*J26S*  GROUP                                                               */
/*J26S** BEGIN DELETE SECTION
 *          if (first-of (wo_project) or first-of (wo_cc) or first-of (wo_acct))
 *          then do:
 *J26S** END DELETE SECTION */

/*J26S*  BEGIN ADD SECTION */
               skip_report_totals = no.
               skip_last_of_nbr   = no.
               if (skip_last_of_proj = yes or
                   skip_last_of_cc   = yes or
                   skip_last_of_acct = yes)
               then do:
                  if skip_last_of_proj = yes then skip_last_of_proj = no.
                  if skip_last_of_cc   = yes then skip_last_of_cc   = no.
                  if skip_last_of_acct = yes then skip_last_of_acct = no.
/*J26S*  END ADD SECTION */

                  /* SS - 20050823 - B */
                  /*
                  if page-size - line-counter < 7 then page.
/*J1GW         display wo_acct wo_cc no-label wo_project
 *             with frame phead1 width 132 page-top no-attr-space side-labels.
 *J1GW*/
/*J2MS** /*J1GW*/       display with frame phead1.  */
/*J2MS*/       display wo_acct wo_cc wo_project with frame phead1.
*/
/* SS - 20050823 - E */


               end. /* IF (skip_last_of_proj = YES ... */
               /* SS - 20050823 - B */
               /*
               else view frame phead1.
               */
               /* SS - 20050823 - E */

               desc1 = "".

/*M0YW**       find pt_mstr where pt_part = wo_part no-lock no-error. */
/*M0YW*/       for first pt_mstr
/*M0YW*/          fields (pt_desc1 pt_part)
/*M0YW*/          where pt_part = wo_part no-lock:
/*M0YW*/       end. /* FOR FIRST pt_mstr */

               if available pt_mstr
               then do:
                  desc1 = pt_desc1.
/*F003         cost_std = pt_tot_std. */

/*M0YW** /*F003*/ find in_mstr where in_part = pt_part and     */
/*M0YW** /*F003*/                    in_site = wo_site no-lock */
/*M0YW** /*F003*/ no-error.                                    */

/*M0YW*/          for first in_mstr
/*M0YW*/             fields (in_cur_set in_gl_set in_part in_site)
/*M0YW*/             where in_part = pt_part and
/*M0YW*/                   in_site = wo_site
/*M0YW*/             no-lock:
/*M0YW*/          end. /* FOR FIRST in_mstr */

/*J027*/          {gpsct03.i &cost=sct_cst_tot}
/*F003*/          cost_std = glxcst.
               end. /* IF AVAILABLE pt_mstr */

               qty_comp = wo_qty_comp + wo_qty_rjct.
               qty_open = wo_qty_ord - qty_comp.

/*J027*/       /* REGULAR PRODUCTS */
/*J027*/       if wo_joint_type = "" then do:
                  total_std = wo_mtl_tot + wo_lbr_tot + wo_bdn_tot + wo_sub_tot
                              - wo_wip_tot.
                  avg_cost = ((wo_mtl_tot + wo_lbr_tot + wo_bdn_tot
                             + wo_sub_tot)
                             - wo_wip_tot) / qty_comp.
/*J027*/       end. /* IF wo_joint_type = "" */
/*J027*/       /* JOINT PRODUCTS */
/*J027*/       else do:
/*J027*/          if wo_joint_type = "5" then total_std = 0.
/*J027*/          else do:
/*J027*/             total_std = wo_mtl_totx + wo_lbr_totx +
/*J027*/                         wo_bdn_totx + wo_sub_totx.
/*J027*/             avg_cost = total_std / qty_comp.
/*J027*/          end. /* ELSE DO */
/*J027*/       end. /* ELSE DO */
               if avg_cost = ? then avg_cost = cost_std.

               /* SS - 20050823 - B */
               /*
               accumulate wo_mtl_tot (total by wo_project by wo_cc by wo_acct).
               accumulate wo_lbr_tot (total by wo_project by wo_cc by wo_acct).
               accumulate wo_bdn_tot (total by wo_project by wo_cc by wo_acct).
               accumulate wo_sub_tot (total by wo_project by wo_cc by wo_acct).
               accumulate total_std  (total by wo_project by wo_cc by wo_acct).
               accumulate wo_wip_tot (total by wo_project by wo_cc by wo_acct).

               if page-size - line-counter < 2 then page.
               */
               /* SS - 20050823 - E */

/*J027*/       if jp_hdr_reqd then do:
/*J1GW*  /*J027*/       display "Joint Products:" @ wo_part with frame b. */
    /* SS - 20050823 - B */
    /*
/*J1GW*/          display {&woworp9a_p_5} @ wo_part with frame b.
/*J027*/          down with frame b.
*/
/* SS - 20050823 - E */
/*J027*/          jp_hdr_reqd = no.
/*J027*/       end. /* IF jp_hdr_reqd */

/* SS - 20050823 - B */
/*
               display
                  wo_nbr
                  wo_lot
                  wo_part
                  wo_mtl_tot
/*J027*/             when (index("1234",wo_joint_type) = 0)
                  wo_bdn_tot
/*J027*/             when (index("1234",wo_joint_type) = 0)
                  qty_comp
/*J027*/             when (wo_joint_type <> "5")
                  avg_cost
/*J027*/             when (wo_joint_type <> "5" and avg_cost <> ?)
                  total_std
/*J027*/             when (wo_joint_type <> "5")
               with frame b.

               down with frame b.
               */
/* SS - 20050823 - E */

/*J027*/       if wo_joint_type = "" then
    /* SS - 20050823 - B */
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
    CREATE tta6woworp09.
    ASSIGN
        tta6woworp09_acct = wo_acct
        tta6woworp09_cc = wo_cc
        tta6woworp09_project = wo_project
        tta6woworp09_nbr = wo_nbr
        tta6woworp09_lot = wo_lot
        tta6woworp09_part = wo_part
        tta6woworp09_wip_tot = wo_wip_tot
        .
END.
/* SS - 20050823 - E */

/*J027*/       /* Begin added block */
                   /* SS - 20050823 - B */
               else if wo_joint_type <> "5" then  /* Base Process */
                   /*
               else if wo_joint_type = "5" then  /* Base Process */
               display
/*J035*/          wo_batch @ wo_nbr
                  desc1 @ wo_part
                  wo_lbr_tot @ wo_mtl_tot
                  wo_sub_tot @ wo_bdn_tot
               with frame b.

               else                              /* Joint Products */
               display
                  desc1 @ wo_part
                  qty_open @ qty_comp
                  wo_wip_tot @ total_std
               with frame b.
               down with frame b.
               */
               DO:
                   CREATE tta6woworp09.
                   ASSIGN
                       tta6woworp09_acct = wo_acct
                       tta6woworp09_cc = wo_cc
                       tta6woworp09_project = wo_project
                       tta6woworp09_nbr = wo_nbr
                       tta6woworp09_lot = wo_lot
                       tta6woworp09_part = wo_part
                       tta6woworp09_wip_tot = wo_wip_tot
                       .
               END.
               /* SS - 20050823 - E */

               if wo_joint_type = "5" then do:
                  jp_hdr_reqd = yes.
                  wip_cost_reqd = yes.
                  base_wip_tot = wo_wip_tot.
               end. /* IF wo_joint_type = "5" */

/*J26S*/    end. /* IF wo_mstr RECORD IS VALID */

/*J26S*  THE WIP COST WILL BE DISPLAYED IF THE FLAG skip_last_of_nbr = no   */
/*J26S**    if wip_cost_reqd and last-of (wo_nbr) then do:                  */
/*J26S*/    if wip_cost_reqd and last-of (wo_nbr) and skip_last_of_nbr = no
/*J26S*/    then do:
    /* SS - 20050823 - B */
    /*
               display
                  {&woworp9a_p_9} @ avg_cost
                  base_wip_tot @ total_std
               with frame b.
               down with frame b.
               */
               DO:
                   CREATE tta6woworp09.
                   ASSIGN
                       tta6woworp09_acct = wo_acct
                       tta6woworp09_cc = wo_cc
                       tta6woworp09_project = wo_project
                       tta6woworp09_nbr = wo_nbr
                       tta6woworp09_lot = wo_lot
                       tta6woworp09_part = wo_part
                       tta6woworp09_wip_tot = base_wip_tot
                       .
               END.
               /* SS - 20050823 - E */
               wip_cost_reqd = no.
            end. /* IF wip_cost_reqd AND ... */
/*J027*/    /* End added block */

/*J26S*  FOLOWING SECTION WILL PRINT PROJECT TOTAL IF THERE EXISTS AT        */
/*J26S*  LEAST ONE RECORD IN BREAK GROUPS wo_project and wo_cc WHICH         */
/*J26S*  ACCUMULATE TOTALS.                                                  */
/*J26S** BEGIN DELETE SECTION
 *          if last-of (wo_project)
 *          and (wo_project <> "" or not last-of (wo_cc)) then do with frame b:
 *J26S** END DELETE SECTION */

/*J26S* BEGIN ADD SECTION  */
            /* SS - 20050823 - B */
            /*
            if last-of (wo_project)   and
               skip_last_of_proj = no and
               (wo_project <> ""      or
                   not (last-of (wo_cc)  and skip_last_of_cc = yes)
               )
            then do with frame b:
/*J26S*  END ADD SECTION  */

               if page-size - line-counter < 4 then do:
                  down with frame b.
                  page.
               end. /* IF page-size - line-counter */
               else down 2 with frame b.

               display
               {&woworp9a_p_7} + " " + wo_project + " " + {&woworp9a_p_8} @ wo_part
               accum total by wo_project wo_mtl_tot @ wo_mtl_tot
               accum total by wo_project wo_bdn_tot @ wo_bdn_tot
               accum total by wo_project total_std  @ total_std.

               down with frame b.

               display
               accum total by wo_project wo_lbr_tot @ wo_mtl_tot
               accum total by wo_project wo_sub_tot @ wo_bdn_tot
               accum total by wo_project wo_wip_tot @ total_std.
            end. /* IF LAST-OF (wo_project) and ... */

/*J26S*  FOLOWING SECTION WILL PRINT CC TOTAL IF THERE EXISTS AT LEAST ONE   */
/*J26S*  RECORD IN BREAK GROUPS wo_cc AND wo_acct WHICH ACCUMULATE TOTALS.   */
/*J26S**       if last-of (wo_cc) and (wo_cc <> "" or not last-of (wo_acct))    */

/*J26S*  BEGIN ADD SECTION  */
            if last-of (wo_cc)         and
               skip_last_of_cc = no    and
               (wo_cc <> ""            or
                not (last-of (wo_acct) and skip_last_of_acct = yes)
               )
/*J26S*  END ADD SECTION  */

            then do with frame b:

               if page-size - line-counter < 4 then do:
                  down with frame b.
                  page.
               end. /* IF page-size - line-counter < 4 */
               else down 2 with frame b.

               display
               "CC:" + " " + wo_cc + " " + {&woworp9a_p_8} @ wo_part
               accum total by wo_cc wo_mtl_tot @ wo_mtl_tot
               accum total by wo_cc wo_bdn_tot @ wo_bdn_tot
               accum total by wo_cc total_std  @ total_std.
               down with frame b.
               display
               accum total by wo_cc wo_lbr_tot @ wo_mtl_tot
               accum total by wo_cc wo_sub_tot @ wo_bdn_tot
               accum total by wo_cc wo_wip_tot @ total_std.
            end. /* IF LAST-OF(wo_cc) and ... */

/*J26S*  FOLOWING SECTION WILL PRINT ACCOUNT TOTAL IF THERE EXISTS AT       */
/*J26S*  LEAST ONE RECORD IN BREAK GROUP wo_acct WHICH ACCUMULATE TOTALS.   */
/*J26S**    if last-of (wo_acct) then do:                                   */
/*J26S*/    if last-of (wo_acct) and skip_last_of_acct = no
/*J26S*/    then do:

               if page-size - line-counter < 4 then do:
                  down with frame b.
                  page.
               end. /* IF page-size - line-counter < 4 */
               else down 2 with frame b.

               display
               {&woworp9a_p_3} + " " + wo_acct + " " + {&woworp9a_p_8} @ wo_part
               accum total by wo_acct wo_mtl_tot @ wo_mtl_tot
               accum total by wo_acct wo_bdn_tot @ wo_bdn_tot
               accum total by wo_acct total_std  @ total_std.

               down with frame b.
               display
               accum total by wo_acct wo_lbr_tot @ wo_mtl_tot
               accum total by wo_acct wo_sub_tot @ wo_bdn_tot
               accum total by wo_acct wo_wip_tot @ total_std.
            end. /* IF LAST-OF(wo_acct) AND ... */

/*J26S*  FOLOWING SECTION WILL PRINT REPORT TOTAL IF THERE EXISTS AT        */
/*J26S*  LEAST ONE RECORD WHICH ACCUMULATE TOTALS.                          */
/*J26S**    if last (wo_acct) then do with frame b:                         */
/*J26S*/    if last (wo_acct) and skip_report_totals = no
/*J26S*/    then do with frame b:

               hide frame phead1.

               if page-size - line-counter < 4 then do:
                  down with frame b.
                  page.
               end. /* IF page-size - line-counter < 4 */
               else down 2 with frame b.

               display
               {&woworp9a_p_12} @ wo_part
               accum total wo_mtl_tot @ wo_mtl_tot
               accum total wo_bdn_tot @ wo_bdn_tot
               accum total total_std  @ total_std.

               down with frame b.

               display
               accum total wo_lbr_tot @ wo_mtl_tot
               accum total wo_sub_tot @ wo_bdn_tot
               accum total wo_wip_tot @ total_std.
            end. /* IF LAST (wo_acct) AND ... */
            */
            /* SS - 20050823 - E */

            {mfrpexit.i}
         end. /* FOR EACH wo_mstr */
/*K0YS*/ {wbrp04.i}
