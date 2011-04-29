/* GUI CONVERTED from bmpsrp06.p (converter v1.71) Tue Oct  6 14:17:10 1998 */
/* bmpsrp06.p - MATERIALS SUMMARY REPORT                                */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/* web convert bmpsrp06.p (converter v1.00) Fri Oct 10 13:57:06 1997 */
/* web tag in bmpsrp06.p (converter v1.00) Mon Oct 06 14:17:24 1997 */
/*F0PN*/ /*K12M*/ /*V8#ConvertMode=WebReport                            */
/*V8:ConvertMode=FullGUIReport                                 */
/* REVISION: 5.0      LAST MODIFIED: 01/12/90   BY: MLB **B494*          */
/* REVISION: 5.0      LAST MODIFIED: 03/27/90   BY: RAM **B635*          */
/* REVISION: 6.0      LAST MODIFIED: 05/18/90   BY: WUG **D002*          */
/* REVISION: 6.0      LAST MODIFIED: 10/30/90   BY: emb **D145*          */
/* REVISION: 6.0      LAST MODIFIED: 07/02/91   BY: emb **D743*          */
/* REVISION: 6.0      LAST MODIFIED: 08/02/91   BY: bjb **D811*          */
/* Revision: 7.3      Last edit:     09/27/93   By: jcd *G247*           */
/* Revision: 7.3      Last edit:     10/21/93   By: pxd *GG43*  rev only */
/* REVISION: 7.3      LAST MODIFIED: 12/29/93   BY: ais *FL07            */
/* REVISION: 7.2      LAST MODIFIED: 03/02/94   BY: ais **FM55*          */
/* REVISION: 7.2      LAST MODIFIED: 05/24/94   BY: pxd **FO43*          */
/* REVISION: 7.3      LAST MODIFIED: 10/18/94   BY: jzs *GN61*           */
/* REVISION: 7.5      LAST MODIFIED: 01/07/95   BY: tjs *J014*           */
/* REVISION: 7.3    LAST MODIFIED: 07/31/96 BY: *G2B9* Julie Milligan    */
/* REVISION: 8.6    LAST MODIFIED: 10/17/97 BY: *K12M* Madhusudhana Rao  */
/* REVISION: 7.4    LAST MODIFIED: 02/04/98 BY: *H1JC* Jean Miller       */

/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan    */

/*GUI global preprocessor directive settings */
&GLOBAL-DEFINE PP_PGM_RP TRUE
&GLOBAL-DEFINE PP_ENV_GUI TRUE


/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

/*GN61*/ {mfdtitle.i "e+ "}

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE bmpsrp06_p_1 "(物料单)"
/* MaxLen: Comment: */

&SCOPED-DEFINE bmpsrp06_p_2 "BOM起始日期"
/* MaxLen: Comment: */

&SCOPED-DEFINE bmpsrp06_p_3 "(父零件)"
/* MaxLen: Comment: */

&SCOPED-DEFINE bmpsrp06_p_4 "只打印组装件"
/* MaxLen: Comment: */

&SCOPED-DEFINE bmpsrp06_p_5 "物料单 = "
/* MaxLen: Comment: */

&SCOPED-DEFINE bmpsrp06_p_6 "BOM"
/* MaxLen: Comment: */

&SCOPED-DEFINE bmpsrp06_p_7 "层次"
/* MaxLen: Comment: */

&SCOPED-DEFINE bmpsrp06_p_8 "提!前期"
/* MaxLen: Comment: */

&SCOPED-DEFINE bmpsrp06_p_9 "子零件用量"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */


/*G247*  define shared variable mfguser as character.                    */

         define new shared variable comp like ps_comp.
         define new shared variable eff_date as date
/*FL07*     label "Eff Date".                                            */
/*FL07*/    label {&bmpsrp06_p_2}.
         define new shared variable pline like pt_prod_line.
         define new shared variable pline1 like pt_prod_line.
         define new shared variable maxlevel as integer format ">>>"
            label {&bmpsrp06_p_7} no-undo.

         define variable level as integer no-undo.
         define variable part  like pt_part no-undo LABEL "父零件(预测)".
         define variable part1 like pt_part no-undo.
         define variable part2  like pt_part no-undo LABEL "子零件".
         define variable part3 like pt_part no-undo.

         define variable BUYER  like pt_buyer no-undo.
         define variable BUYER1 like pt_buyer no-undo.
         define variable PM  like pt_PM_CODE no-undo.
         define variable WKCTR1 AS  CHARACTER FORMAT "xxxxxxx" label "交库类型" .
/*IFP*/  define variable sl like ps_qty_per label "数量"  initial 1.
         define variable um like pt_um no-undo.
         define variable sum_usage like ps_qty_per
            label {&bmpsrp06_p_9} no-undo.
         define variable parent as character format "x(6)" no-undo.
         define variable pmcode    like pt_pm_code no-undo.
         define variable lead_time like pt_mfg_lead column-label {&bmpsrp06_p_8} no-undo.
         define variable qty_oh    like in_qty_oh no-undo.
        /* define variable assy_only like mfc_logical. label {&bmpsrp06_p_4}
            initial yes no-undo.*/
         define variable assy_only like mfc_logical. 
         define new shared variable site like si_site.
/*G2B9*/ define variable item-code as character no-undo.
/*G2B9*/ define variable get-next like mfc_logical no-undo.
/*G2B9*/ define variable onlybom  like mfc_logical no-undo.
         define variable due_date like wo_due_date label "到期日(预测)".
         define variable due_date1 like wo_due_date.
         define variable due_date2 like wo_due_date.
         define variable qty_oh1 like wo_qty_ord.
         define variable qty_oh2 like wo_qty_ord.
         define variable qty_oh3 like wo_qty_ord.
         define variable qty_oh4 like wo_qty_ord.
         define variable qty_oh5 like wo_qty_ord.
         define variable qty_req1 like wo_qty_ord.
         define variable qty_req2 like wo_qty_ord.
         define variable open_ref like wo_qty_ord.
         define variable dataset like mrp_dataset label "类型".
         define variable ppart like pt_part.
         define variable mrp_qty1 like mrp_qty.
    define temp-table tmp 
    field tmp_USER like pk_USER 
    field tmp_PART like pk_PART
    field tmp_QTY like pk_QTY 
    field tmp_loc like pk_loc 
    field tmp_lot like pk_lot
    field tmp_par like pt_part
    field tmp_user1 like pk_user1 
    field tmp_user2 like pt_user2.

   
   
  dataset = "资源".       
/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
            
 RECT-FRAME       AT ROW 1.4 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
 SKIP(.1)  /*GUI*/
            part      colon 15     part1 label {t001.i} colon 49 skip
            part2      colon 15    part3 label {t001.i} colon 49 skip

            pline     colon 15    pline1 label {t001.i} colon 49 skip
            
            BUYER     colon 15    BUYER1 label {t001.i} colon 49 skip
            due_date colon 15 due_date1 label {t001.i} colon 49 skip

            PM COLON 15
           site      colon 15
/*GN61*/    si_desc   no-label
            eff_date  colon 15
         /**   sl        colon 26**/
            maxlevel  colon 15
        /**   assy_only colon 15 **/
          SKIP(.4)  /*GUI*/
with frame a side-labels width 80 attr-space NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-a-title AS CHARACTER.
 F-a-title = &IF (DEFINED(SELECTION_CRITERIA) = 0)
  &THEN " 选择条件 "
  &ELSE {&SELECTION_CRITERIA}
  &ENDIF .
 RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
 RECT-FRAME-LABEL:WIDTH-PIXELS in frame a =
  FONT-TABLE:GET-TEXT-WIDTH-PIXELS(
  RECT-FRAME-LABEL:SCREEN-VALUE in frame a + " ", RECT-FRAME-LABEL:FONT).
 RECT-FRAME:HEIGHT-PIXELS in frame a =
  FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5. /*GUI*/

/*GUI preprocessor Frame A undefine */
&UNDEFINE PP_FRAME_NAME



         eff_date = today.
         site = global_site.
/*GN61*/ find si_mstr where si_site = site  no-lock no-error.
/*GN61*/ if available si_mstr then display si_desc with frame a.

/*K12M*/ {wbrp01.i}

         
/*GUI*/ {mfguirpa.i true  "printer" 132 }

/*GUI repeat : */
/*GUI*/ procedure p-enable-ui:

            if pline1 = hi_char then pline1 = "".
            if BUYER1 = hi_char then BUYER1 = "".
            if due_date1 = hi_date then due_date1 = ?.
            if due_date = low_date then due_date = ?.
            if part1 = hi_char then part1 = "".
            if part3 = hi_char then part3 = "".
/*K12M*/    if c-application-mode <> "WEB":U then
            
run p-action-fields (input "display").
run p-action-fields (input "enable").
end procedure. /* p-enable-ui, replacement of Data-Entry GUI*/

/*GUI*/ procedure p-report-quote:


/*K12M*/    {wbrp06.i &command = update &fields = "  part part1 part2 part3 pline pline1 buyer buyer1 due_date due_date1 pm site
             eff_date maxlevel " &frm = "a"}

/*K12M*/    if (c-application-mode <> "WEB":U) or
/*K12M*/       (c-application-mode = "WEB":U and
/*K12M*/       (c-web-request begins "DATA":U)) then do:

/*GN61 MOVE BELOW BATCHING AS FIELD VALIDATION **************************
 *            find si_mstr no-lock where si_site = site no-error.
 *            if not available si_mstr then do:
 *               {mfmsg.i 708 3}
 *               next-prompt site with frame a.
 *               undo, retry.
 *            end.
 *GN61 ********************************************************************/

               bcdparm = "".
               {mfquoter.i part      }
               {mfquoter.i part1     }
               {mfquoter.i part2     }
               {mfquoter.i part3     }
               {mfquoter.i pline     }
               {mfquoter.i pline1    }
               {mfquoter.i BUYER     }
               {mfquoter.i BUYER1    }
               {mfquoter.i PM        }
               {mfquoter.i site      }
               {mfquoter.i due_date}
               {mfquoter.i due_date1}
               {mfquoter.i eff_date  }
               {mfquoter.i maxlevel  }
            /*   {mfquoter.i assy_only }*/

               if pline1 = "" then pline1 = hi_char.
               if BUYER1 = "" then BUYER1 = hi_char.
               if  due_date1 = ? then due_date1 = hi_date.
               if  due_date = ? then due_date = low_date.
               if part1 = "" then part1 = hi_char.
               if part3 = "" then part3 = hi_char.
               
/*H1JC*/       /* Add do loop to prevent converter from creating on leave of */
/*H1JC*/       do:

/*GN61*/          if not can-find(si_mstr where si_site = site) then do:
                     {mfmsg.i 708 3} /* SITE DOES NOT EXIST. */
                     display "" @ si_desc with frame a.
/*K12M*/             if c-application-mode = "WEB":U then return.
/*K12M*/             else
                        /*GUI NEXT-PROMPT removed */
                     /*GUI UNDO removed */ RETURN ERROR.
/*GN61*/          end.
/*GN61*/          else do:
/*GN61*/             find si_mstr where si_site = site  no-lock no-error.
/*GN61*/             if available si_mstr then display si_desc with frame a.
/*GN61*/          end.

/*H1JC*/       end.

/*K12M*/    end. /* if c-application-mode */

            /* SELECT PRINTER */
/*D743*/    
/*GUI*/ end procedure. /* p-report-quote */
/*GUI - Field Trigger Section */

/*GUI MFSELxxx removed*/
/*GUI*/ procedure p-report:
/*GUI*/   {gpprtrpa.i  "printer" 132}
/*GUI*/   mainloop: do on error undo, return error on endkey undo, return error:
find si_mstr where si_site = site  no-lock no-error.
find si_mstr where si_site = site  no-lock no-error.

define buffer ptmstr for pt_mstr.
define buffer mrpdet for mrp_det.


            /* CREATE PAGE TITLE BLOCK */
            {mfphead.i}

            global_site = site.

            FORM /*GUI*/  site
            with STREAM-IO /*GUI*/  frame pageheader side-labels no-attr-space page-top
/*G2B9*/    width 132.

            display site with frame pageheader STREAM-IO /*GUI*/ .

/*G2B9*/    /* BEGIN ADD SECTION */

   for each mrp_det where mrp_det.mrp_dataset = "fcs_sum" 
   and mrp_due_date >= due_date and mrp_due_date <= due_date1
   and mrp_part >= part and mrp_part <= part1
   break by mrp_part by mrp_due_date:
       if last-of (mrp_part) then do:

         part = mrp_part.
         part1 = mrp_part.

            find first bom_mstr where bom_parent >= PART and
                                      bom_parent <= PART1
            no-lock no-error.
            find first pt_mstr where (pt_part >= PART and
                                     pt_part <= part1) 
            no-lock no-error.
/*G2B9*/    /* END ADD SECTION */

/*FM55* * * BEGIN DELETED SECTION *
 *FM55*     for each pt_mstr no-lock
 *FM55*     where pt_part >= part and pt_part <= part1
 *FM55*     and pt_prod_line >= pline and pt_prod_line <= pline1
 *FM55*     and (assy_only = no
 *FM55*     or can-find (first ps_mstr where ps_par = pt_part))
**FM55* * * END DELETED SECTION */

/*G2B9* * * BEGIN DELETED SECTION *
 * /*FM55*/ for each bom_mstr no-lock
 * /*FM55*/    where bom_parent >= part and bom_parent <= part1
 * /*FM55*/    and (assy_only = no
 * /*FM55*/    or can-find (first ps_mstr where ps_par = bom_parent))
 *          with frame b:
 *
 * /*FM55*/    find pt_mstr no-lock where pt_part = bom_parent no-error.
 * /*FM55*/    if (not available pt_mstr and (pline = "" or pline1 = hi_char))
 * /*FM55*/    or (available pt_mstr and
 * /*FM55*/        (pt_prod_line >= pline and pt_prod_line <= pline1))
 * /*FM55*/    then do:
 *
 * /*J014*/       if available pt_mstr then
 * /*J014*/       find ptp_det no-lock where ptp_part = pt_part
 * /*J014*/       and ptp_site = site no-error.
 * /*J014*/       if not available pt_mstr
 * /*J014*/       or (available pt_mstr and index("1234",pt_joint_type) = 0
 * /*J014*/           and not available ptp_det)
 * /*J014*/       or (available ptp_det and index("1234",ptp_joint_type) = 0)
 * /*J014*/       then do:
 **G2B9* * * END DELETED SECTION */

/*G2B9*/    
/*GUI mainloop removed */


/*G2B9*/       /* BEGIN ADD SECTION */
               get-next = no.
               onlybom = no.

               if available bom_mstr and available pt_mstr then do:
                  assign
                     item-code = pt_part.
                  if pt_part = bom_parent and
                     pt_prod_line < pline or pt_prod_line > pline1
                  then
                     get-next = yes.
                  else if pt_part > bom_parent then
                     assign
                        onlybom = yes
                        item-code = bom_parent.
               end. /* if available bom_mstr and pt_mstr */
               else if available bom_mstr
               then
                  assign
                     onlybom = yes
                     item-code = bom_parent.
               else if available pt_mstr then do:
                  assign
                     item-code = pt_part.
                  if pt_prod_line < pline or pt_prod_line > pline1 then
                  get-next = yes.
               end.
               else leave.

               comp = item-code.

               if not onlybom and available pt_mstr then do:
                  if pt_bom_code <> ""
                  then comp = pt_bom_code.
                  find ptp_det where ptp_part = pt_part
                                 and ptp_site = site
                  no-lock no-error.
                  if available ptp_det then do:
                     comp = if ptp_bom_code <> "" then ptp_bom_code
                            else ptp_part.
                     if index("1234",ptp_joint_type) = 0 then .
                     else get-next = yes.
                     if can-do("p,d",ptp_pm_code) then get-next = yes.
                  end.
                  else do:
                     if index("1234",pt_joint_type) = 0 then .
                     else get-next = yes.
                     if can-do("p,d",pt_pm_code) then get-next = yes.
                  end.
               end.

               if assy_only = yes then do:
                  find first ps_mstr where ps_par = comp no-lock no-error.
                  if not available ps_mstr then get-next = yes.
               end.

               if not can-find(bom_mstr where bom_parent = comp)
               then
                  get-next = yes.

               if not get-next then do:
/*G2B9*/       /* END ADD SECTION */

/*FM55*           comp = pt_part.    */
/*G2B9* /*FM55*/  comp = bom_parent. */

                  /*EXPLODE PART BY MODIFIED PICKLIST LOGIC*/
                  {gprun.i ""bmpsrp5a.p""}

/*G2B9*/          find first pk_det where eff_date = ? or (eff_date <> ?
/*G2B9*/              and (pk_start = ? or pk_start <= eff_date)
/*G2B9*/              and (pk_end = ? or eff_date <= pk_end))
/*G2B9*/          no-error.
/*G2B9*/          if not available pk_det then get-next = yes.
/*G2B9*/       end. /* not get-next */

/*G2B9*/       if not get-next then do:

                  /*DISPLAY END-ITEM*/
/*G2B9* /*FM55*/  if available pt_mstr then do: */
/*G2B9*/          if not onlybom and available pt_mstr then do:
/*J014*              find ptp_det where ptp_part = pt_part */
/*J014*                             and ptp_site = site    */
/*J014*              no-lock no-error.                     */
                     if available ptp_det then do:
                        if ptp_pm_code = "P" then do:
                           lead_time = ptp_pur_lead.
                           if ptp_ins_rqd
                           then lead_time = lead_time + ptp_ins_lead.
                        end.
                        else lead_time = ptp_mfg_lead.
                     end.
                     else do:
                        if pt_pm_code = "P" then do:
                           lead_time = pt_pur_lead.
                           if pt_insp_rqd
                           then lead_time = lead_time + pt_insp_lead.
                        end.
                        else lead_time = pt_mfg_lead.
                     end.
/*FM55*/          end.
/*FM55*/          else lead_time = 0.

                  if page-size - line-counter < 4 then page.

/*G2B9* /*FM55*/  if available pt_mstr */
      
                  /*DISPLAY COMPONENTS BY PRODUCT LINE*/
                  for each pk_det no-lock
                    where (pk_user = mfguser)
                      and (eff_date = ? or (eff_date <> ?
                      and (pk_part >= part2 and pk_part <= part3)
                      and (pk_start = ? or pk_start <= eff_date)
                      and (pk_end = ? or eff_date <= pk_end) ) )
                  break by pk_user by pk_part with frame b:

                     accumulate pk_qty (total by pk_part).

                     if last-of(pk_part) then do:

                        sum_usage = accum total by pk_part pk_qty.
                        
                        create tmp .
                         assign  tmp_part = pk_part
                          tmp_user = pk_user
                          tmp_qty = sum_usage
                          tmp_par = pt_part.
                          end.
                   end.
            
/*GUI*/ {mfguirex.i } /*Replace mfrpexit*/

/*G2B9* /*J014*/  end.  */ /* not a joint_type */
/*G2B9*           end.   */  /*for each pt_mstr*/

/*G2B9*/       end. /* if not get-next */

/*G2B9*/       /* BEGIN ADD SECTION */
               /* LOGIC FOR FINDING THE NEXT BOM_MSTR AND PT_MSTR RECORDS */

               if available bom_mstr and available pt_mstr then do:
                  if pt_part > bom_parent then
                     find next bom_mstr where (bom_parent >= part
                                          and bom_parent <= part1) 
                     no-lock no-error.
                  else if bom_parent > pt_part then
                     find next pt_mstr where (pt_part >= part and
                                             pt_part <= part1) 
                     no-lock no-error.
                  else do:
                     find next bom_mstr where (bom_parent >= part
                                          and bom_parent <= part1)
                     no-lock no-error.
                     find next pt_mstr where (pt_part >= part and
                                             pt_part <= part1) 
                     no-lock no-error.
                  end.
               end.
               else if available bom_mstr then
                  find next bom_mstr where (bom_parent >= part
                                       and bom_parent <= part1) 
                  no-lock no-error.
               else if available pt_mstr then
                  find next pt_mstr where (pt_part >= part
                                      and pt_part <= part1) 
                  no-lock no-error.
               else leave.

/*G2B9*/       /* END ADD SECTION */

/*FM55*/    end. /* repeat mainloop */
end . /*end for last-of mrp_part*/
end. /*end for each mrpdet*/
 
               for each mrp_det where mrp_dataset = "fcs_sum"
                 and mrp_due_date >= due_date and mrp_due_date <= due_date1,
                    each tmp where tmp_par = mrp_part,
                    each pt_mstr where pt_part = tmp_part
                    and (pt_prod_line >= pline and pt_prod_line <= pline1)
                    and (pt_buyer >= buyer and pt_buyer <= buyer1)
                   break by tmp_part by mrp_due_date with frame c width 500 down no-attr-space no-box:
          

                
                    if first-of (tmp_part) then  do:
                    qty_oh1 = 0.
                    qty_oh2 = 0.
                    qty_oh3 = 0.
                    qty_oh4 = 0.
                    QTY_OH5 = 0.
                        find in_mstr where in_part = tmp_part and in_site = "10000" no-lock no-error.
                        if available in_mstr then qty_oh5 = in_qty_oh.
                        qty_req1 = 0. 
               
                      for each mrpdet where mrpdet.mrp_part = tmp_part break by mrpdet.mrp_part by mrpdet.mrp_dataset
                           with frame c width 500 down no-attr-space no-box:

                          if mrpdet.mrp_dataset = "wo_mstr" then do:
                         find wo_mstr where wo_lot = mrpdet.mrp_line no-lock no-error.
                         open_ref = (wo_qty_ord - wo_qty_rjct - wo_qty_comp).
                         if wo_status = "r" then qty_oh1 = qty_oh1 + open_ref.
                         if wo_status = "f" then qty_oh2 = qty_oh2 + open_ref.
                         if wo_status = "p" then qty_oh3 = qty_oh3 + open_ref.
                         end.
                         if mrpdet.mrp_dataset = "pod_det" then qty_oh4 = qty_oh4 + mrpdet.mrp_qty.
                         if last (mrpdet.mrp_part) then
                             display 
                             dataset
                             due_date2 
                             ppart LABEL "零件号(预测)"
                             mrp_qty1 label "预测数量" 
                             tmp_part 
                             pt_desc1 
                             pt_desc2 
                             pt_um
                             pt_buyer
                             pt_pm_code
                             qty_req1  label "需求量" 
                             qty_oh5 when available in_mstr label "库存"
                             qty_oh1 label "R状态工单" 
                             qty_oh2 label "F状态工单" 
                             qty_oh3 label "P状态工单" 
                             qty_oh4 label "采购单" 

                             with STREAM-IO.
                             down.

                             
                      
                        end. /*end for each mrpdet*/
                   end.
                       
                  qty_req1 = (tmp_qty * mrp_qty).
                  accumulate qty_req1 (total by tmp_part).
                  qty_req2 = (accum total by tmp_part (qty_req1)).

                 
                    display 
                    "预测"  @ dataset
                    mrp_due_date @ due_date2
                    tmp_par @ ppart
                    mrp_qty  when mrp_qty <> 0 @ mrp_qty1
                    tmp_part 
                    pt_desc1 
                    pt_desc2 
                    pt_um
                    pt_buyer
                    pt_pm_code
                    qty_req1  label "需求量" when qty_req1 <> 0
                    (qty_oh5 - qty_req2)  when  (qty_oh5 - qty_req2) > 0 @ qty_oh5 
                    
                    (qty_oh1 + qty_oh5 - qty_req2) 
                    WHEN ((qty_oh1 + qty_oh5 - qty_req2) > 0  AND (qty_oh5 - qty_req2) < 0) @ qty_oh1 
                    (qty_oh1) 
                    WHEN (qty_oh5 - qty_req2) > 0 @ qty_oh1 

                    
                    (qty_oh2 + qty_oh1 + qty_oh5 - qty_req2) 
                    WHEN ((qty_oh2 + qty_oh1 + qty_oh5 - qty_req2) > 0  AND (qty_oh1 + qty_oh5 - qty_req2) < 0) @ qty_oh2 
                    (qty_oh2) 
                    WHEN (qty_oh1 + qty_oh5 - qty_req2) > 0 @ qty_oh2 

                    
                    (qty_oh3 + qty_oh2 + qty_oh1 + qty_oh5 - qty_req2) 
                    WHEN ((qty_oh3 + qty_oh2 + qty_oh1 + qty_oh5 - qty_req2) > 0 AND (qty_oh2 + qty_oh1 + qty_oh5 - qty_req2) < 0 )  @ qty_oh3 
                   (qty_oh3) 
                    WHEN (qty_oh2 + qty_oh1 + qty_oh5 - qty_req2) > 0   @ qty_oh3 
                    
                    (qty_oh4 + qty_oh5 - qty_req2) 
                    WHEN ((qty_oh4 + qty_oh5 - qty_req2) > 0  AND (qty_oh5 - qty_req2) < 0) @ qty_oh4 
                    (qty_oh4) 
                    WHEN (qty_oh5 - qty_req2) > 0 @ qty_oh4 

            
                    
                    space(2)  WITH STREAM-IO.
                 
                     
                  end.
/*GUI*/ {mfguitrl.i} /*Replace mfrtrail*/

/*GUI*/ {mfgrptrm.i} /*Report-to-Window*/


      
/*K12M*/ {wbrp04.i &frame-spec = a}

/*GUI*/ end procedure. /*p-report*/
/*GUI*/ {mfguirpb.i &flds=" part part1 part2 part3  pline pline1 buyer buyer1 due_date due_date1 pm site eff_date  maxlevel  "} /*Drive the Report*/
