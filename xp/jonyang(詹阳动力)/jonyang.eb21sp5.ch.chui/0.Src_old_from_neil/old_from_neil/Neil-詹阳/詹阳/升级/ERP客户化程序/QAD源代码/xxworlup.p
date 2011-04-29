/* xxworlup.p - REGAIN RELEASE / PRINT WORK ORDERS SELECT RANGE OF ORDERS   */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */

/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan     */
/* REVISION: 8.6E     LAST MODIFIED: 12/14/00   BY: *JY000* Frankie Xu    */

         /* DISPLAY TITLE */

/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

         {mfdtitle.i "e+ "}

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE woworl01_p_1 "打印复合产品/副产品"
/* MaxLen: Comment: */

&SCOPED-DEFINE woworl01_p_2 "打印装箱单"
/* MaxLen: Comment: */

&SCOPED-DEFINE woworl01_p_3 "打印工艺流程"
/* MaxLen: Comment: */

&SCOPED-DEFINE woworl01_p_4 "打印条形码"
/* MaxLen: Comment: */

&SCOPED-DEFINE woworl01_p_5 "包括虚零件"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */


/*G247** define shared variable mfguser as character.  ***/
         define new shared variable comp like ps_comp.
         define new shared variable qty as decimal.
         define new shared variable eff_date as date.
         define new shared variable wo_recno as recid.
         define new shared variable leadtime like pt_mfg_lead.
         define new shared variable prev_status like wo_status.
         define new shared variable prev_release like wo_rel_date.
         define new shared variable prev_due like wo_due_date.
         define new shared variable prev_qty like wo_qty_ord.
         define new shared variable del-yn like mfc_logical initial no.
         define new shared variable deliv like wod_deliver.
         define new shared variable barcode like mfc_logical
            label {&woworl01_p_4}.
         define new shared variable wo_des like pt_desc1.
         define new shared variable wo_qty like wo_qty_ord.
         define new shared variable wo_um like pt_um.
         define new shared variable wc_description like wc_desc.
/*G1XY*/ define new shared variable critical-part like wod_part no-undo.
/*J027*/ /* Begin added block */
         define new shared variable prd_recno as recid.
         define new shared variable joint_type like wo_joint_type.
         define new shared variable wonbr like wo_nbr.
         define new shared variable wonbr1 like wo_nbr.
         define new shared variable wolot like wo_lot.
         define new shared variable wolot1 like wo_lot.
         define new shared variable part like wo_part.
         define new shared variable part1 like wo_part.
         define new shared variable woreldate like wo_rel_date.
         define new shared variable woreldate1 like wo_rel_date.
         define new shared variable wotype like wo_type.
         define new shared variable planner  like pt_buyer.
         define new shared variable planner1 like pt_buyer.
         define new shared variable wostatus like wo_status.
         define new shared variable ptplanner like pt_buyer.
         define new shared variable ptphantom like pt_phantom.
         define new shared variable move like woc_move.
         define new shared variable print_pick like mfc_logical
            label {&woworl01_p_2} initial yes.
         define new shared variable print_rte like mfc_logical
            label {&woworl01_p_3} initial yes.
         define new shared variable print_jp like mfc_logical
/*J1GW*     label "Print Joint Products" initial yes. */
/*J1GW*/    label {&woworl01_p_1} initial yes.
         define new shared variable phantom like mfc_logical initial no
            label {&woworl01_p_5}.
/*J027*/ /* End added block */
/*J035*/ define new shared variable wobatch like wo_batch.
/*J035*/ define new shared variable wobatch1 like wo_batch.
/*J027*  define variable nonwdays as integer.
      *  define variable overlap as integer.
      *  define variable workdays as integer.
      *  define variable interval as integer.
      *  define variable know_date as date.
      *  define variable find_date as date.
      *  define variable frwrd as integer.
      *  define variable last_due as date.
      *  define variable hours as decimal.
      *  define variable queue like wc_queue.
      *  define variable wait like wc_wait.
      *  define variable last_op like wr_op.
      *  define variable des like pt_desc1.
      *  define variable print_pick like mfc_logical
      *     label "Print Picklist" initial yes.
      *  define variable print_rte like mfc_logical
      *     label "Print Routing" initial yes.
      *  define variable yn like mfc_logical.
      *  define variable wonbr like wo_nbr.
      *  define variable wonbr1 like wo_nbr.
      *  define variable wolot like wo_lot.
      *  define variable wolot1 like wo_lot.
      *  define variable part like wo_part.
      *  define variable part1 like wo_part.
      *  define variable woreldate like wo_rel_date.
      *  define variable woreldate1 like wo_rel_date.
      *  define new shared variable move like woc_move.
      *  define variable wrnbr like wo_nbr.
      *  define variable trnbr like op_trnbr.
      *  define variable wrlot like wr_lot.
      *  define variable wostatus like wo_status.
      *  define new shared variable any_issued like mfc_logical.
      *  define new shared variable any_feedbk like mfc_logical.
      *  define new shared variable picklistprinted like mfc_logical.
      *  define new shared variable routingprinted like mfc_logical.
      *  define new shared variable prd_recno as recid.
      *  define new shared variable wr_recid as recid.
      *  define variable phantom like mfc_logical initial no
      *     label "Include Phantom Items".
      *  define new shared variable prev_site like wod_site.
      *  define new shared variable undo_all like mfc_logical no-undo.
      *  define variable wotype like wo_type.
      *  define variable planner  like pt_buyer.
      *  define variable planner1 like pt_buyer.
      *  define variable ptplanner like pt_buyer.
      *  define variable ptphantom like pt_phantom.
 *J027*/
/*F351*/ {mfworlb1.i &new="new" &row="13"}


         eff_date = today.

         find first woc_ctrl no-lock no-error.
         if available woc_ctrl then move = woc_move.
         release woc_ctrl.

         
/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
            
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
skip (1)
            wonbr          colon 20
            wonbr1         colon 45 label {t001.i}
            wolot          colon 20
            wolot1         colon 45 label {t001.i}
/*J035*/    wobatch        colon 20
/*J035*/    wobatch1       colon 45 label {t001.i}
            woreldate      colon 20
            woreldate1     colon 45 label {t001.i}
            part           colon 20
            part1          colon 45 label {t001.i}
/*F351*/    planner        colon 20
/*F351*/    planner1       colon 45 label {t001.i}
            skip (1)
/**
            wostatus       colon 40
            wotype         colon 40
            print_pick     colon 40
            print_rte      colon 40
/*J027*/    print_jp       colon 40
            barcode        colon 40
            move           colon 40
            phantom        colon 40
*****/            
         with frame a side-labels width 80 attr-space NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-a-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
 RECT-FRAME-LABEL:HIDDEN in frame a = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame a =
  FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5.  /*GUI*/

/*GUI preprocessor Frame A undefine */
&UNDEFINE PP_FRAME_NAME



         wostatus = "R".
         incl_pick_qtys = yes.

         repeat with frame a:

            if wonbr1     = hi_char  then wonbr1     = "".
            if wolot1     = hi_char  then wolot1     = "".
/*J035*/    if wobatch1   = hi_char  then wobatch1   = "".
            if woreldate1 = hi_date  then woreldate1 = ?.
            if woreldate  = low_date then woreldate  = ?.
            if part1      = hi_char  then part1      = "".
/*F351*/    if planner1   = hi_char  then planner1   = "".

/*F351*/    if not batchrun then do:
               update
                  wonbr wonbr1
                  wolot wolot1
/*J035*/          wobatch wobatch1
                  woreldate woreldate1
                  part part1
/*F351*/          planner planner1
/***
                  wostatus
                  wotype
                  print_pick
                  print_rte
/*J027*/          print_jp
                  barcode
                  move
                  phantom.
************/  .
/*J027****
/*F351*/ *     if print_pick then do:
/*F351*/ *        update
/*F351*/ *           incl_zero_reqd
/*F351*/ *           incl_zero_open
/*F351*/ *           incl_pick_qtys
/*F351*/ *           incl_floor_stk
/*F351*/ *        with frame a1.
/*F351*/ *     end.
/*F351*/ *  end.
 *J027****/
/*J027*/ /* Begin added block */
/******************               
               if print_pick or print_jp then do:
                  update
                     incl_zero_reqd when (print_pick)
                     incl_zero_open when (print_pick)
                     incl_pick_qtys when (print_pick)
                     incl_floor_stk when (print_pick)
                     jp_1st_last_doc when (print_jp)
                  with frame a1.
               end.
*******************/               
            end.
/*J027*/ /* End added block */
/*F351*/    else do:
/*F351*/       update
/*F351*/          wonbr wonbr1
/*F351*/          wolot wolot1
/*J035*/          wobatch wobatch1
/*F351*/          woreldate woreldate1
/*F351*/          part part1
/*F351*/          planner planner1

/*******
/*F351*/          wostatus
/*F351*/          wotype
/*F351*/          print_pick
/*F351*/          print_rte
/*J027*/          print_jp
/*F351*/          barcode
/*F351*/          move
/*F351*/          phantom
/*F351*/          incl_zero_reqd
/*F351*/          incl_zero_open
/*F351*/          incl_pick_qtys
/*F351*/          incl_floor_stk
/*J027*/          jp_1st_last_doc
*************/

/*F351*/       with frame batch.

/*G870*/       display wonbr wonbr1 wolot wolot1
/*J035*/          wobatch wobatch1
/*G870*/          woreldate woreldate1 part part1 planner planner1
/******  /*G870*/          wostatus wotype print_pick print_rte barcode move phantom  
/*J027*/          print_jp         
******/
/*G870*/       with frame a.
/*F351*/    end.

/*J027*     yn = yes. */
            if wostatus = "" then do:
              {mfmsg.i 544 2}
            end.

            bcdparm = "".
            {mfquoter.i wonbr  }
            {mfquoter.i wonbr1 }
            {mfquoter.i wolot  }
            {mfquoter.i wolot1 }
/*J035*/    {mfquoter.i wobatch  }
/*J035*/    {mfquoter.i wobatch1 }
            {mfquoter.i woreldate}
            {mfquoter.i woreldate1}
            {mfquoter.i part   }
            {mfquoter.i part1  }
/*F351*/    {mfquoter.i planner }
/*F351*/    {mfquoter.i planner1}
            {mfquoter.i wostatus}
            {mfquoter.i wotype  }
            {mfquoter.i print_pick}
            {mfquoter.i print_rte}
/*J027*/    {mfquoter.i print_jp}
            {mfquoter.i barcode}
            {mfquoter.i move}
            {mfquoter.i phantom}
/*F351*/    {mfquoter.i incl_zero_reqd}
/*F351*/    {mfquoter.i incl_zero_open}
/*F351*/    {mfquoter.i incl_pick_qtys}
/*F351*/    {mfquoter.i incl_floor_stk}
/*J027*/    {mfquoter.i jp_1st_last_doc}

            if wonbr1 = "" then wonbr1 = hi_char.
            if wolot1 = "" then wolot1 = hi_char.
/*J035*/    if wobatch1 = "" then wobatch1 = hi_char.
            if woreldate1 = ? then woreldate1 = hi_date.
            if woreldate = ? then woreldate = low_date.
            if part1 = "" then part1 = hi_char.
/*F351*/    if planner1 = "" then planner1 = hi_char.

            /* SELECT PRINTER */
            {mfselbpr.i "printer" 80}
/*GUI*/ RECT-FRAME:HEIGHT-PIXELS in frame a = FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.


            /* SAVE prd_det RECID FOR BAR-CODES LATER */
/*J027*/    find prd_det where prd_dev = dev no-lock no-error.
/*J027*/    if available prd_det then prd_recno = recid(prd_det).

/*J027*/    {gprun.i ""woworl2.p""}

/*J027********************************************** now in woworl2.p *********
            /* CREATE PAGE TITLE BLOCK */                                     *
            {mfphead2.i}                                                      *
                                                                              *
/*GB43*/    rpt-block:                                                        *
            repeat:                                                           *
                                                                              *
               find next wo_mstr no-lock use-index wo_nbr                     *
               where wo_nbr >= wonbr and wo_nbr <= wonbr1                     *
               and wo_lot >= wolot and wo_lot <= wolot1                       *
               and wo_rel_date >= woreldate and wo_rel_date <= woreldate1     *
               and wo_part >= part and wo_part <= part1                       *
               and wo_type = wotype                                           *
/*GN76*/       and not (wo_type = "c" and wo_nbr = "")
               and (wo_status = wostatus                                      *
               or (wostatus = "" and wo_status <> "R"))                       *
               and wo_status <> "C" no-error.                                 *
                                                                              *
               if not available wo_mstr then leave.                           *
                                                                              *
/*F351         if phantom = no then do:                                 */    *
/*F351            find pt_mstr no-lock where pt_part = wo_part no-error.*/    *
/*F351            if available pt_mstr and pt_phantom = yes then next.  */    *
/*F351         end.                                                     */    *
                                                                              *
/*F351*/       if planner <> "" or planner1 <> hi_char                        *
/*F351*/       or phantom = no then do:                                       *
/*F351*/          find ptp_det where ptp_part = wo_part and ptp_site = wo_site*
/*F351*/          no-lock no-error.                                           *
/*F351*/          if available ptp_det then do:                               *
/*F351*/             ptplanner = ptp_buyer.                                   *
/*F351*/             ptphantom = ptp_phantom.                                 *
/*F351*/          end.                                                        *
/*F351*/          else do:                                                    *
/*F351*/             find pt_mstr where pt_part = wo_part no-lock no-error.   *
/*F351*/             if available pt_mstr then do:                            *
/*F351*/                ptplanner = pt_buyer.                                 *
/*F351*/                ptphantom = pt_phantom.                               *
/*F351*/             end.                                                     *
/*F351*/             else do:                                                 *
/*F351*/                ptplanner = "".                                       *
/*F351*/                ptphantom = no.                                       *
/*F351*/             end.                                                     *
/*F351*/          end.                                                        *
/*F351*/          if ptplanner < planner or ptplanner > planner1              *
/*F351*/          or (phantom = no and ptphantom = yes) then next.            *
/*F351*/       end.                                                           *
                                                                              *
               wo_recno = recid(wo_mstr).                                     *
               comp = wo_part.                                                *
                                                                              *
/*G870*        find wo_mstr where recid(wo_mstr) = wo_recno. */               *
                                                                              *
               prev_status = wo_status.                                       *
               prev_release = wo_rel_date.                                    *
               prev_due = wo_due_date.                                        *
               prev_qty = wo_qty_ord.                                         *
                                                                              *
               if wo_qty_ord >= 0 then                                        *
                  qty = max (wo_qty_ord - wo_qty_comp - wo_qty_rjct,0).       *
               else                                                           *
                  qty = min (wo_qty_ord - wo_qty_comp - wo_qty_rjct,0).       *
                                                                              *
               wo_qty = qty.                                                  *
                                                                              *
/*GB43*/       trac-block:                                                    *
/*G870*/       do transaction:                                                *
/*G870*/          find wo_mstr exclusive where recid(wo_mstr) = wo_recno.     *
                                                                              *
/*G1DW*           if wo_rel_date <> today then wo_rel_date = today.    */     *
/*G1DW*/          if wo_rel_date <> today and wo_status <> "R" then           *
/*G1DW*/             wo_rel_date = today.                                     *
                                                                              *
                  if index("PFBEA",wo_status) <> 0 then wo_status = "R".      *
/*GB43*/ /*                                                                   *
/*G870*/       end.                                                           *
/*GB43*/  */                                                                  *
               prev_site = wo_site.                                           *
               undo_all = no.                                                 *
                                                                              *
               {gprun.i ""wowomta.p""}                                        *
                                                                              *
               picklistprinted = no.                                          *
               routingprinted = no.                                           *
               if undo_all = no then do:                                      *
                  if print_pick then do:                                      *
                     page_counter = page-number - 1.                          *
                     wo_recno = recid(wo_mstr).                               *
                     {gprun.i ""woworlb.p""}                                  *
                     /* print picklist  */                                    *
                  end.                                                        *
                  if print_rte then do:                                       *
                     page_counter = page-number - 1.                          *
                     wo_recno = recid(wo_mstr).                               *
                     prd_recno = recid(prd_det).                              *
                     {gprun.i ""woworld.p""}                                  *
                     /* print routing   */                                    *
                  end.                                                        *
               end.                                                           *
               if (print_pick and not picklistprinted)                        *
               or (print_rte and not routingprinted)                          *
               or undo_all = yes                                              *
/*GB43*/       then do:                                                       *
/*GB43*/  /*   then do                                                        *
/*G870*/       transaction:                                                   *
/*GB43*/  */                                                                  *
                  page.                                                       *
                  if undo_all then do:                                        *
                     find msg_mstr where msg_lang = global_user_lang          *
                     and msg_nbr = 4984 no-lock no-error.                     *
                     if available msg_mstr then                               *
                        put                                                   *
                           substr(msg_desc,1,40) +                            *
                           substr(wo_nbr,1,length(wo_nbr)) +                  *
/*F351                     substr(msg_desc,41) format "x(78)" skip. */        *
/*F351*/                   substr(msg_desc,40) format "x(78)" skip.           *
/*GB43*/  /*         wo_status = prev_status.      */                         *
/*GB43*/             undo trac-block, leave.                                  *
                  end.                                                        *
                  if (print_pick and not picklistprinted) then                *
                     put                                                      *
                        "***No picklist was printed for work order "          *
                        wo_nbr skip.                                          *
                  if (print_rte and not routingprinted) then                  *
                     put                                                      *
                        "***No routing was printed for work order "           *
                        wo_nbr skip.                                          *
                  page.                                                       *
                  end.                                                        *
/*GB43*/       end. /* trac-block*/                                           *
                                                                              *
/*GB43*/       if undo_all then next rpt-block.                               *
                                                                              *
               if undo_all = no then do                                       *
/*G870*/       transaction:                                                   *
                  if wo_status <> "R" then wo_status = "R".                   *
                                                                              *
                  if move                                                     *
                  then do:                                                    *
                     move = no.                                               *
                     find first wr_route where wr_lot = wo_lot                *
                     and wr_nbr = wo_nbr no-lock no-error.                    *
                     if available wr_route and wr_status = ""                 *
                     then do:                                                 *
                        wr_recid = recid(wr_route).                           *
                        {gprun.i ""woopmv.p""}                                *
                     end.                                                     *
                     move = yes.                                              *
                  end.                                                        *
                                                                              *
/*G870*           /* Deleted section */                                       *
 *                /* UPDATE MRP WORKFILE */                                   *
 *                {mfmrw.i "wo_mstr" wo_part wo_nbr wo_lot """"               *
 *                wo_rel_date wo_due_date                                     *
 *                "wo_qty_ord - wo_qty_comp - wo_qty_rjct"                    *
 *                "SUPPLY" "Work Order" wo_site }                             *
 *                                                                            *
 *                if available mrp_det and index("FBE",wo_status) > 0 then    *
 *                   mrp_type = "SUPPLYF".                                    *
 *                                                                            *
 *                {mfmrw.i "wo_scrap" wo_part wo_nbr wo_lot """"              *
 *                wo_rel_date wo_due_date                                     *
 *                "(wo_qty_ord - wo_qty_comp - wo_qty_rjct)                   *
 *                      * (1 - wo_yield_pct / 100)"                           *
 *                "DEMAND" "Scrap Requirement" wo_site }                      *
**G870*/          /* End of deleted section */                                *
                                                                              *
               end. /*undo_all = no*/                                         *
            end.                                                              *
                                                                              *
 *J027*************************************************************************/
/*J0RK*/    /* REPORT TRAILER */
/*J0RK*/    {mfrtrail.i}

         end.
