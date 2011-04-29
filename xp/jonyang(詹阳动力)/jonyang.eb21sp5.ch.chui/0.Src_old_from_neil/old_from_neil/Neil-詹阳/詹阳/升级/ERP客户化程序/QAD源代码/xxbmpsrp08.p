/* GUI CONVERTED from bmpsrp06.p (converter v1.69) Thu Aug 22 10:26:39 1996 */
/* bmpsrp06.p - MATERIALS SUMMARY REPORT                                */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/*F0PN*/ /*V8:ConvertMode=FullGUIReport                                 */
/* REVISION: 5.0      LAST MODIFIED: 01/12/90   BY: MLB **B494*         */
/* REVISION: 5.0      LAST MODIFIED: 03/27/90   BY: RAM **B635*         */
/* REVISION: 6.0      LAST MODIFIED: 05/18/90   BY: WUG **D002*         */
/* REVISION: 6.0      LAST MODIFIED: 10/30/90   BY: emb **D145*         */
/* REVISION: 6.0      LAST MODIFIED: 07/02/91   BY: emb **D743*         */
/* REVISION: 6.0      LAST MODIFIED: 08/02/91   BY: bjb **D811*         */
/* Revision: 7.3      Last edit:     09/27/93   By: jcd *G247* */
/* Revision: 7.3      Last edit:     10/21/93   By: pxd *GG43*  rev only */
/* REVISION: 7.3      LAST MODIFIED: 12/29/93   BY: ais *FL07            */
/* REVISION: 7.2      LAST MODIFIED: 03/02/94   BY: ais **FM55*         */
/* REVISION: 7.2      LAST MODIFIED: 05/24/94   BY: pxd **FO43*         */
/* REVISION: 7.3      LAST MODIFIED: 10/18/94   BY: jzs *GN61*  */
/* REVISION: 7.5      LAST MODIFIED: 01/07/95   BY: tjs *J014*          */
/* REVISION: 8.5    LAST MODIFIED: 07/31/96 BY: *G2B9* Julie Milligan    */


/*GUI global preprocessor directive settings */
&GLOBAL-DEFINE PP_PGM_RP TRUE
&GLOBAL-DEFINE PP_ENV_GUI TRUE


/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

/*GN61*/ {mfdtitle.i "d+ "}

/*G247*  define shared variable mfguser as character.                    */

         define new shared variable comp like ps_comp.
         define new shared variable eff_date as date
/*FL07*     label "Eff Date".                                            */
/*FL07*/    label "起始日期".
         define new shared variable pline like pt_prod_line.
         define new shared variable pline1 like pt_prod_line.
         define new shared
         variable maxlevel as integer format ">>>" label "层次" no-undo.

         define variable level as integer.
         define variable part like pt_part.
         define variable part1 like pt_part.
         
         define variable um like pt_um.
         define variable sum_usage like ps_qty_per label "子零件用量".
         define variable parent as character format "x(6)".
         define variable pmcode like pt_pm_code.
         define variable lead_time like pt_mfg_lead column-label "提!前期".
         define variable qty_oh like in_qty_oh.
/*IFP*/  define variable qty_zlc like qty_oh label "短缺量".
/*IFP*/  define variable qty_avail like in_qty_avail.
         define variable assy_only like mfc_logical label "只打印组装件"
            initial yes.

         define new shared variable site like si_site.
/*G2B9*/ define variable item-code as character no-undo.
/*G2B9*/ define variable get-next like mfc_logical no-undo.
/*G2B9*/ define variable onlybom like mfc_logical no-undo.
/*IFP*/  define variable qty like ps_qty_per label "数量"  initial 1.
/*IFP*/  define variable total_lead like pt_cum_lead.
/*IFP*/  define variable nbr like wo_nbr.
/*IFP*/  define variable open_ref like wo_qty_ord.
         
/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
            
 RECT-FRAME       AT ROW 1.4 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
 SKIP(.1)  /*GUI*/
part      colon 15     /*IFP part1 label {t001.i} colon 49 skip */
            pline     colon 15    pline1 label {t001.i} colon 49 skip(1)
/*IFP*      qty       colon 26   */
/*IFP*/     nbr       colon 26
            site      colon 26
/*GN61*/    si_desc   no-label
            eff_date  colon 26
            maxlevel  colon 26
            assy_only colon 26
          SKIP(.4)  /*GUI*/
with frame a side-labels width 80 attr-space NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-a-title AS CHARACTER.
 F-a-title = " 选择条件 ".
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

         
/*GUI*/ {mfguirpa.i true  "printer" 132 }

/*GUI repeat : */
/*GUI*/ procedure p-enable-ui:

            if pline1 = hi_char then pline1 = "".
            if part1 = hi_char then part1 = "".

            
run p-action-fields (input "display").
run p-action-fields (input "enable").
end procedure. /* p-enable-ui, replacement of Data-Entry GUI*/

/*GUI*/ procedure p-report-quote:


/*GN61 move below batching as field validation **************************
            find si_mstr no-lock where si_site = site no-error.
            if not available si_mstr then do:
               {mfmsg.i 708 3}
               next-prompt site with frame a.
               undo, retry.
            end.
*GN61 ********************************************************************/

            bcdparm = "".
            {mfquoter.i part      }
            {mfquoter.i part1     }
            {mfquoter.i pline     }
            {mfquoter.i pline1    }
/*IFP*      {mfquoter.i qty       }            */
/*IFP*/     {mfquoter.i nbr       }
            {mfquoter.i site      }
            {mfquoter.i eff_date  }
            {mfquoter.i maxlevel  }
            {mfquoter.i assy_only }

            if  pline1 = "" then pline1 = hi_char.
            if  part1 = "" then part1 = part.
/*IFP*/     find first wo_mstr where wo_part = part and wo_nbr = nbr no-lock no-error.
/*IFP*/     if available wo_mstr then qty = wo_qty_ord.
/*IFP*/     else qty = 1.
/*GN61*/    

            /* SELECT PRINTER */
/*D743*/    
/*GUI*/ end procedure. /* p-report-quote */
/*GUI - Field Trigger Section */

on leave of nbr do:
assign nbr.
assign part.
if not can-find(first wo_mstr  where wo_nbr = nbr and wo_part = part) then do:
               {mfmsg.i 503 3} /* WORK NUMBER DOES NOT EXIST. */
               /*GUI NEXT-PROMPT removed */
               display "" @ nbr with frame a.
               /*GUI UNDO removed */ Validation-Error = yes. RETURN NO-APPLY.
/*GN61*/    end.
/*GN61*/    else do:
/*GN61*/       find wo_mstr where wo_nbr = nbr  no-lock no-error.
/*GN61*/       if available so_mstr then display wo_nbr @ nbr with frame a.
/*GN61*/    end.

end.

on leave of site do:
assign site.
if not can-find(si_mstr  where si_site = site) then do:
               {mfmsg.i 708 3} /* SITE DOES NOT EXIST. */
               display "" @ si_desc with frame a.
               /*GUI NEXT-PROMPT removed */
               /*GUI UNDO removed */ Validation-Error = yes. RETURN NO-APPLY.
/*GN61*/    end.
/*GN61*/    else do:
/*GN61*/       find si_mstr where si_site = site  no-lock no-error.
/*GN61*/       if available si_mstr then display si_desc with frame a.
/*GN61*/    end.
end.

/*GUI MFSELxxx removed*/
/*GUI*/ procedure p-report:
/*GUI*/   {gpprtrpa.i  "printer" 132}
/*GUI*/   mainloop: do on error undo, return error on endkey undo, return error:
find si_mstr where si_site = site  no-lock no-error.

define buffer ptmstr for pt_mstr.



            /* CREATE PAGE TITLE BLOCK */
            {mfphead.i}

            global_site = site.

            FORM /*GUI*/  site
            with STREAM-IO /*GUI*/  frame pageheader side-labels no-attr-space page-top
/*G2B9*/      width 132.

            display site with frame pageheader STREAM-IO /*GUI*/ .

/*G2B9* * * BEGIN ADD SECTION */
            find first bom_mstr where bom_parent >= part and
              bom_parent <= part1 no-lock no-error.
            find first pt_mstr no-lock where pt_part >=part and
              pt_part <= part1 no-error.
/*G2B9* * * END ADD SECTION */

/*FM55*     for each pt_mstr no-lock                                   */
/*FM55*     where pt_part >= part and pt_part <= part1                 */
/*FM55*     and pt_prod_line >= pline and pt_prod_line <= pline1       */
/*FM55*     and (assy_only = no                                        */
/*FM55*     or can-find (first ps_mstr where ps_par = pt_part))        */

/*G2B9* * * BEGIN DELETED SECTION *
./*FM55*/    for each bom_mstr no-lock
./*FM55*/       where bom_parent >= part and bom_parent <= part1
./*FM55*/       and (assy_only = no
./*FM55*/       or can-find (first ps_mstr where ps_par = bom_parent))
.            with frame b:
.
./*FM55*/       find pt_mstr no-lock where pt_part = bom_parent no-error.
./*FM55*/       if (not available pt_mstr and (pline = "" or pline1 = hi_char))
./*FM55*/       or (available pt_mstr and
./*FM55*/           (pt_prod_line >= pline and pt_prod_line <= pline1))
./*FM55*/       then do:
.
./*J014*/       if available pt_mstr then
./*J014*/       find ptp_det no-lock where ptp_part = pt_part
./*J014*/       and ptp_site = site no-error.
./*J014*/       if not available pt_mstr
./*J014*/       or (available pt_mstr and index("1234",pt_joint_type) = 0
./*J014*/           and not available ptp_det)
./*J014*/       or (available ptp_det and index("1234",ptp_joint_type) = 0)
./*J014*/       then do:
**G2B9* * * END DELETED SECTION */

/*G2B9*/    
/*GUI mainloop removed */

/*G2B9*/    repeat with frame b:

                  FORM /*GUI*/ 
                     pk_part format "x(30)"
                     pt_mstr.pt_desc1
                     sum_usage
                     qty_oh
/*IFP*/              qty_avail                     
/*IFP*/              qty_zlc
                     pt_mstr.pt_um
/*IFP*                     
                     pt_mstr.pt_status label "状态"
                     pt_mstr.pt_part_type
                     pt_mstr.pt_pm_code
                     pt_mstr.pt_prod_line
                     lead_time column-label "提前期"
                     pt_mstr.pt_cum_lead column-label "制造!提前期"
                     total_lead column-label "累计制造!提前期"
*****/                     
/*IFP*/              wo_lot label "标志" wo_status wo_qty_ord wo_qty_comp 
/*IFP*/              wo_qty_rjct open_ref wo_due_date
                  with STREAM-IO /*GUI*/  frame b width 255 down no-attr-space no-box.

/*G2B9* * * BEGIN ADD SECTION */
              get-next = no.
              onlybom = no.

              if available bom_mstr and available pt_mstr then do:
                assign
                  item-code = pt_part.
                if pt_part = bom_parent and
                  pt_prod_line < pline or pt_prod_line > pline1 then
                  get-next = yes.
                else if pt_part > bom_parent then
                  assign
                    onlybom = yes
                    item-code = bom_parent.
              end. /* HAVE BOTH BOM_MSTR & PT_MSTR */
              else if available bom_mstr then
                assign
                  onlybom = yes
                  item-code = bom_parent.
              else if available pt_mstr then do:
                assign item-code = pt_part.
                if pt_prod_line < pline or pt_prod_line > pline1 then
                  get-next = yes.
              end.
              else leave.

              comp = item-code.

              if not onlybom and available pt_mstr then do:
                if pt_bom_code <> ""
                  then comp = pt_bom_code.
                find ptp_det no-lock where ptp_part = pt_part
                  and ptp_site = site no-error.
                if available ptp_det then do:
                  comp = if ptp_bom_code <> "" then ptp_bom_code
                    else ptp_part.
                  if index("1234",ptp_joint_type) = 0 then .
                    else get-next = yes.
                  if can-do("p,d",ptp_pm_code) then get-next = yes.
                end. /* available ptp_det */
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

              if not can-find(bom_mstr where bom_parent = comp) then
                get-next = yes.


              if not get-next then do:
/*G2B9* * * END ADD SECTION */

/*FM55*           comp = pt_part.                             */
/*G2B9* /*FM55*/          comp = bom_parent. */

                  /*EXPLODE PART BY MODIFIED PICKLIST LOGIC*/
                  {gprun.i ""bmpsrp5a.p""}

/*G2B9*/        find first pk_det where eff_date = ? or (eff_date <> ?
/*G2B9*/            and (pk_start = ? or pk_start <= eff_date)
/*G2B9*/            and (pk_end = ? or eff_date <= pk_end)) no-error.
/*G2B9*/        if not available pk_det then get-next = yes.
/*G2B9*/      end. /* not get-next */

/*G2B9*/      if not get-next then do:

                  /*DISPLAY END-ITEM*/
/*G2B9* /*FM55*/          if available pt_mstr then do: */
/*G2B9*/          if not onlybom and available pt_mstr then do:
/*J014*              find ptp_det no-lock where ptp_part = pt_part */
/*J014*              and ptp_site = site no-error.                 */
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

/*G2B9* /*FM55*/          if available pt_mstr  */
/*G2B9*/          if not onlybom and available pt_mstr
/*FM55*/          then
                     display
                        string(pt_part,"x(18)") + "    " + "(父零件)" @ pk_part
                        pt_desc1
                        pt_um 
/*IFP*                  pt_status pt_part_type
                        ptp_pm_code when (available ptp_det) @ pt_pm_code
                        pt_pm_code when (not available ptp_det)
                        pt_prod_line lead_time
                        ptp_cum_lead when (available ptp_det) @ pt_cum_lead
                     pt_cum_lead when (not available ptp_det) 
*****/                        
                     WITH STREAM-IO /*GUI*/ .
/*FM55*/          else
/*FM55*/             display
/*G2B9* /*FM55*/        string(bom_parent,"x(18)") + "    " + "(PARENT)" */
/*G2B9*/                string(bom_parent,"x(18)") + "    " + "(物料单)"
/*FM55*/                   @ pk_part
/*FM55*/                bom_desc @ pt_desc1
/*FM55*/                bom_batch_um @ pt_um
/*/*FM55*/                "BOM" @ pt_part_type*/ WITH STREAM-IO /*GUI*/ .

                  down 1 with frame b.

/*FM55*           if pt_desc2 > "" then display pt_desc2 @ pt_desc1.      */
/*FM55*           if pt_desc2 > "" then down 1 with frame b.              */
/*G2B9* /*FM55*/ if available pt_mstr and pt_desc2 > "" then do with frame b:*/
/*G2B9*/          if not onlybom and available pt_mstr and
/*G2B9*/            pt_desc2 > "" then do with frame b:
/*FM55*/             display pt_desc2 @ pt_desc1 WITH STREAM-IO /*GUI*/ .
/*FM55*/             down 1.
/*FM55*/          end.
/*G2B9*/          if not onlybom and available pt_mstr and item-code <> comp
/*G2B9*/          then do:
/*G2B9*/            display "物料单 = " + comp @ pt_desc1 WITH STREAM-IO /*GUI*/ .
/*G2B9*/            down 1.
/*G2B9*/          end.

                  /*DISPLAY COMPONENTS BY PRODUCT LINE*/
                  for each pk_det no-lock
                  where (pk_user = mfguser)
                  and (eff_date = ? or (eff_date <> ?
                  and (pk_start = ? or pk_start <= eff_date)
                  and (pk_end = ? or eff_date <= pk_end) ) )
                  break by pk_user by pk_part with frame b:

                     accumulate pk_qty (total by pk_part).

                     if last-of(pk_part) then do:

                        sum_usage = (accum total by pk_part pk_qty) * qty.

                        find ptmstr where ptmstr.pt_part = pk_part no-lock
/*FM55*/                no-error.

/*FM55*/                if available ptmstr then do:
                           find ptp_det no-lock where ptp_part = pk_part
                           and ptp_site = site no-error.
                           if available ptp_det then do:
                              if ptp_pm_code = "P" then do:
                                 lead_time = ptp_pur_lead.
                                 if ptp_ins_rqd
                                 then lead_time = lead_time + ptp_ins_lead.
                              end.
                              else lead_time = ptp_mfg_lead.
                           end.
                           else do:
                              if ptmstr.pt_pm_code = "P" then do:
                                 lead_time = ptmstr.pt_pur_lead.
                                 if ptmstr.pt_insp_rqd then
                                 lead_time = lead_time + ptmstr.pt_insp_lead.
                              end.
                              else lead_time = pt_mfg_lead.
                           end.
/*FM55*/                end.
/*FM55*/                else lead_time = 0.

                        qty_oh = 0.
/*IFP*/                 qty_zlc = 0.                        
/*IFP*/                 qty_avail = 0.
                        for each in_mstr no-lock where in_part = ptmstr.pt_part
                        and in_site = site:
                           qty_oh = qty_oh + in_qty_oh.
/*IFP*/                    qty_avail = qty_avail + in_qty_avail.                           
                        end.
/*IFP*/                 if qty_avail < sum_usage then qty_zlc = sum_usage - qty_avail.
/*IFP*/                 else qty_zlc = 0.

                        if page-size - line-counter < 2 and ptmstr.pt_desc2 > ""
                        then page.

/*FM55*/                if available ptmstr then do:
                           display "   " + pk_part @ pk_part
                              ptmstr.pt_desc1 @ pt_mstr.pt_desc1
                              sum_usage qty_oh
/*IFP*/                       qty_avail                              
/*IFP*/                       qty_zlc
                              ptmstr.pt_um @ pt_mstr.pt_um
/*IFP****
                              ptmstr.pt_status @ pt_mstr.pt_status
                              ptmstr.pt_part_type @ pt_mstr.pt_part_type
                              ptp_pm_code when (available ptp_det)
                                 @ pt_mstr.pt_pm_code
                              ptmstr.pt_pm_code when (not available ptp_det)
                                 @ pt_mstr.pt_pm_code
                              ptmstr.pt_prod_line @ pt_mstr.pt_prod_line
                              lead_time
                              ptp_cum_lead when (available ptp_det)
                                 @ pt_mstr.pt_cum_lead
                           ptmstr.pt_cum_lead when (not available ptp_det)
                           @ pt_mstr.pt_cum_lead 
*****/
                           WITH STREAM-IO /*GUI*/ .
/*IFP*/                 for each wo_mstr where wo_part = pk_part and wo_nbr = nbr 
                           with frame b stream-io:
                           if wo_status <> "C" then 
                               if wo_qty_ord - wo_qty_comp - wo_qty_rjct >= 0 then do:
                                  open_ref = wo_qty_ord - wo_qty_comp - wo_qty_rjct .
                               end.
                               else open_ref = 0.
                               
                           else open_ref = 0.    
                           display wo_lot wo_status wo_qty_ord wo_qty_comp wo_qty_rjct open_ref wo_due_date with stream-io.
                           down.
/*IFP*/                 end.
/*IFP*/                 end.   
/*FM55*/                else
/*FM55*/                   display
                              "   " + pk_part @ pk_part
/*FO43*//*FM55*/              bom_desc @ pt_mstr.pt_desc1
/*FM55*/                      sum_usage
/*FM55*/                      qty_oh
/*IFP*/                       qty_avail
/*IFP*/                       qty_zlc
/*FO43*//*FM55*/              bom_batch_um @ pt_mstr.pt_um
/*IFP****
/*FO43*//*FM55*/              "BOM" @ pt_mstr.pt_part_type
/*FM55*/                   lead_time 
*****/
                           WITH STREAM-IO /*GUI*/ .
/*IFP*/                 if available ptmstr then if available ptp_det then 
/*IFP*/                           assign total_lead = total_lead + ptp_cum_lead * sum_usage.
/*IFP*/                 else 
/*IFP*/                           assign total_lead = total_lead + ptmstr.pt_cum_lead * sum_usage.

                        down 1 with frame b.

/*FM55*                 if ptmstr.pt_desc2 > "" then                      */
/*FM55*                    display ptmstr.pt_desc2 @ pt_mstr.pt_desc1.    */
/*FM55*                 if ptmstr.pt_desc2 > "" then down 1 with frame b. */

/*FM55*/                if available ptmstr and ptmstr.pt_desc2 > ""
/*FM55*/                then do with frame b:
/*FM55*/                   display ptmstr.pt_desc2 @ pt_mstr.pt_desc1 WITH STREAM-IO /*GUI*/ .
/*FM55*/                   down 1.
/*FM55*/                end.

                     end.

/*D811*/             
/*GUI*/ {mfguirex.i  "false"} /*Replace mfrpexit*/

                  end. /*for each pk_det*/

/*IFP*            display total_lead with frame b stream-io.*/
/*IFP*/           total_lead = 0.
                  
/*GUI*/ {mfguirex.i } /*Replace mfrpexit*/

/*G2B9* /*J014*/         end.  */ /* not a joint_type */
/*G2B9*               end.   */  /*for each pt_mstr*/

/*G2B9*/      end. /* if not get-next */
/*G2B9* * * BEGIN ADD SECTION */

             /* LOGIC FOR FINDING THE NEXT BOM_MSTR AND PT_MSTR RECORDS */

             if avail bom_mstr and avail pt_mstr then do:
               if pt_part > bom_parent then
                 find next bom_mstr where bom_parent >= part
                   and bom_parent <= part1 no-lock no-error.
               else if bom_parent > pt_part then
                 find next pt_mstr where pt_part >= part and
                   pt_part <= part1 no-lock no-error.
               else do:
                 find next bom_mstr where bom_parent >= part
                     and bom_parent <= part1 no-lock no-error.
                 find next pt_mstr where pt_part >= part and
                   pt_part <= part1 no-lock no-error.
               end.
             end.
             else if avail bom_mstr then
               find next bom_mstr where bom_parent >= part
                 and bom_parent <= part1 no-lock no-error.
             else if avail pt_mstr then
               find next pt_mstr where pt_part >= part
                 and pt_part <= part1 no-lock no-error.
             else leave.

/*G2B9* * * END ADD SECTION */

/*FM55*/    end. /* repeat mainloop*/
            
/*GUI*/ {mfguitrl.i} /*Replace mfrtrail*/

/*GUI*/ {mfgrptrm.i} /*Report-to-Window*/


         end.

/*GUI*/ end procedure. /*p-report*/
/*GUI*/ {mfguirpb.i &flds=" part pline pline1 nbr site eff_date maxlevel assy_only "} /*Drive the Report*/
