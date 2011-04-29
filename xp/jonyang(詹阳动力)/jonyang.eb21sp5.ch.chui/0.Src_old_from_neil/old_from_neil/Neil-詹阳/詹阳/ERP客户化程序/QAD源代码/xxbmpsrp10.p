/* xxbmpsrp10.p - MATERIALS SUMMARY REPORT                                */
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
/*SS 20090317 - B*/
					define new shared variable l_gl_std like mfc_logical no-undo.
/*SS 20090317 - E*/
         define variable level as integer.
         define variable part like pt_part.
         define variable part1 like pt_part.
         
         define variable um like pt_um.
         define variable sum_usage like ps_qty_per label "子零件用量".
         define variable parent as character format "x(6)".
         define variable pmcode like pt_pm_code.
         define variable lead_time like pt_mfg_lead column-label "提!前期".
         define variable assy_only like mfc_logical label "只打印组装件"
            initial yes.

         define new shared variable site like si_site.
/*G2B9*/ define variable item-code as character no-undo.
/*G2B9*/ define variable get-next like mfc_logical no-undo.
/*G2B9*/ define variable onlybom like mfc_logical no-undo.
/*IFP*/  define variable qty like ps_qty_per label "数量"  initial 1.
/*IFP*/  define variable total_lead like pt_cum_lead.
/*IFP*/  define variable routing like ro_routing.
/*IFP*/  define variable run_sub like ro_run.
/*IFP*/  define variable run_total like ro_run.
/*IFP*/  define variable setup_sub like ro_setup.
/*IFP*/  define variable setup_total like ro_setup.
/*IFP*/  define variable dis_ro_sub like mfc_logical label "显示工艺流程小计" initial yes.
/*IFP*/  define variable summary like mfc_logical label "S-汇总/D-明细" format "S-汇总/D-明细".
/*IFP*/  define variable ro_part like pt_part.
/*IFP*/  define variable desc1 like pt_desc1.
/*IFP*/  define temp-table rodet 
               field mfguserid like mfguser
               field rorouting like ro_routing
               field roop like ro_op
               field rowkctr like ro_wkctr
               field romch like ro_mch
               field rodesc like ro_desc
               field rorun like ro_run
               field rosetup like ro_setup
               field roqty like qty
               field ropart like pt_part.

/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
            
            part      colon 15     part1 label {t001.i} colon 49 skip
            pline     colon 15    pline1 label {t001.i} colon 49 skip(1)
/*IFP*/     qty       colon 26
            site      colon 26
/*GN61*/    si_desc   no-label
            eff_date  colon 26
            maxlevel  colon 26
            assy_only colon 26
/*IFP*/     dis_ro_sub colon 26 skip(1)
/*IFP*/     summary   colon 26
          SKIP(.4)  /*GUI*/
with frame a side-labels width 80 attr-space.

/*GUI preprocessor Frame A undefine */
&UNDEFINE PP_FRAME_NAME

/*SS 20090316 - B*/
/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).
/*SS 20090316 - E*/



         eff_date = today.
         site = global_site.
/*GN61*/ find si_mstr where 
		si_domain = global_domain and /*---Add by davild 20090205.1*/
		si_site = site  no-lock no-error.
/*GN61*/ if available si_mstr then display si_desc with frame a.

repeat:

            if pline1 = hi_char then pline1 = "".
            if part1 = hi_char then part1 = "".

/*IFP*/     find first rodet no-error.
/*IPF*/     if available rodet then
/*IFP*/          for each rodet:
/*IPF*/             delete rodet.
/*IFP*/          end.
            

						update part part1 pline pline1 qty site eff_date maxlevel assy_only dis_ro_sub summary with frame a.

            find si_mstr no-lock where si_site = site no-error.
            if not available si_mstr then do:
               {mfmsg.i 708 3}
               next-prompt site with frame a.
               undo, retry.
            end.


            bcdparm = "".
            {mfquoter.i part      }
            {mfquoter.i part1     }
            {mfquoter.i pline     }
            {mfquoter.i pline1    }
/*IFP*/     {mfquoter.i qty       }            
            {mfquoter.i site      }
            {mfquoter.i eff_date  }
            {mfquoter.i maxlevel  }
            {mfquoter.i assy_only }
/*IFP*/     {mfquoter.i summary   }

            if  pline1 = "" then pline1 = hi_char.
            if  part1 = "" then part1 = hi_char.

/*GN61*/    


on leave of site do:
assign site.
if not can-find(si_mstr  where 
		si_domain = global_domain and /*---Add by davild 20090205.1*/
		si_site = site) then do:
               {mfmsg.i 708 3} /* SITE DOES NOT EXIST. */
               display "" @ si_desc with frame a.
               /*GUI NEXT-PROMPT removed */
               RETURN .
/*GN61*/    end.
/*GN61*/    else do:
/*GN61*/       find si_mstr where 
				si_domain = global_domain and /*---Add by davild 20090205.1*/
				si_site = site  no-lock no-error.
/*GN61*/       if available si_mstr then display si_desc with frame a.
/*GN61*/    end.
end.
/*GUI MFSELxxx removed*/

/*SS 20090316 - B*/
/*
/*GUI*/   {gpprtrpa.i  "printer" 132}
*/
					{mfselbpr.i "printer" 132}
/*SS 20090316 - E*/

find si_mstr where 
si_domain = global_domain and /*---Add by davild 20090205.1*/
si_site = site  no-lock no-error.

define buffer ptmstr for pt_mstr.



            /* CREATE PAGE TITLE BLOCK */
            {mfphead.i}

            global_site = site.
/*IFP*/     run_sub = 0.
/*IFP*/     run_total = 0.
/*IFP*/     setup_sub = 0.
/*IFP*/     setup_total = 0.

            FORM /*GUI*/  site
            with STREAM-IO /*GUI*/  frame pageheader side-labels no-attr-space page-top
/*G2B9*/      width 132.
						setFrameLabels(frame pageheader:handle).
            display site with frame pageheader STREAM-IO /*GUI*/ .

/*G2B9* * * BEGIN ADD SECTION */
            find first bom_mstr where 
				bom_domain = global_domain and /*---Add by davild 20090205.1*/
				bom_parent >= part and
              bom_parent <= part1 no-lock no-error.
            find first pt_mstr no-lock where 
				pt_domain = global_domain and /*---Add by davild 20090205.1*/
				pt_part >=part and
              pt_part <= part1 no-error.

/*GUI mainloop removed */

/*G2B9*/    repeat with frame b:

                  FORM /*GUI*/ 
                     pk_part format "x(30)"
                     pt_mstr.pt_desc1
                     sum_usage
                     pt_mstr.pt_um
                     ro_routing
                     ro_op
                     ro_wkctr
                     ro_desc 
                     ro_run column-label "加工时间"
                     ro_setup column-label "准备时间"
                 with STREAM-IO /*GUI*/  frame b width 255 down no-attr-space no-box.
									setFrameLabels(frame b:handle).
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
                find ptp_det no-lock where 
					ptp_domain = global_domain and /*---Add by davild 20090205.1*/
					ptp_part = pt_part
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
                find first ps_mstr where 
					ps_domain = global_domain and /*---Add by davild 20090205.1*/
					ps_par = comp no-lock no-error.
                if not available ps_mstr then get-next = yes.
              end.

              if not can-find(bom_mstr where 
				bom_domain = global_domain and /*---Add by davild 20090205.1*/
				bom_parent = comp) then
                get-next = yes.


              if not get-next then do:
/*G2B9* * * END ADD SECTION */

/*FM55*           comp = pt_part.                             */
/*G2B9* /*FM55*/          comp = bom_parent. */

                  /*EXPLODE PART BY MODIFIED PICKLIST LOGIC*/
                  {gprun.i ""bmpsrp5a.p""}

/*G2B9*/        find first pk_det where 
					pk_domain = global_domain and /*---Add by davild 20090205.1*/
					eff_date = ? or (eff_date <> ?
/*G2B9*/            and (pk_start = ? or pk_start <= eff_date)
/*G2B9*/            and (pk_end = ? or eff_date <= pk_end)) no-error.
/*G2B9*/        if not available pk_det then get-next = yes.
/*G2B9*/      end. /* not get-next */

/*G2B9*/      if not get-next then do:

                  /*DISPLAY END-ITEM*/
/*G2B9* /*FM55*/          if available pt_mstr then do: */

/*G2B9*/          if not onlybom and available pt_mstr
/*FM55*/          then do:
                     ro_part = pt_part.
                  end.
/*FM55*/          else do:
                     ro_part = bom_parent.
                  end.
/*IFP* Begin */
                  if available pt_mstr then 
                        if pt_routing = "" then routing = pt_part.
                        else routing = pt_routing.
                  else routing = bom_parent.

                  for each ro_det where 
					ro_domain = global_domain and /*---Add by davild 20090205.1*/
					ro_routing = routing no-lock with frame b:
                     create rodet.
                     assign mfguserid = mfguser
                            rorouting = ro_routing 
                            roop = ro_op
                            rowkctr = ro_wkctr
                            romch = ro_mch
                            rodesc = ro_desc
                            rorun = ro_run * qty
                            rosetup = ro_setup * qty
                            roqty = qty
                            ropart = ro_part.
                  end.
/*IFP* End */                  


                  /*DISPLAY COMPONENTS BY PRODUCT LINE*/
                  for each pk_det no-lock
                  where 
				  pk_domain = global_domain and /*---Add by davild 20090205.1*/
				  (pk_user = mfguser)
                  and (eff_date = ? or (eff_date <> ?
                  and (pk_start = ? or pk_start <= eff_date)
                  and (pk_end = ? or eff_date <= pk_end) ) )
                  break by pk_user by pk_part with frame b:

                     accumulate pk_qty (total by pk_part).

                     if last-of(pk_part) then do:

                        sum_usage = (accum total by pk_part pk_qty) * qty.

                        find ptmstr where 
						ptmstr.pt_domain = global_domain and /*---Add by davild 20090205.1*/
						ptmstr.pt_part = pk_part no-lock
/*FM55*/                no-error.

/*IFP* Begin */
                        if pt_routing <> "" then routing = pt_routing.
                        else routing = pk_part.
                        for each ro_det where 
							ro_domain = global_domain and /*---Add by davild 20090205.1*/
							ro_routing = routing no-lock with frame b:
                             create rodet.
                             assign   mfguserid = mfguser
                                      rorouting = ro_routing 
                                      roop = ro_op
                                      rowkctr = ro_wkctr
                                      romch = ro_mch
                                      rodesc = ro_desc
                                      rorun = ro_run * sum_usage
                                      rosetup = ro_setup
                                      roqty = sum_usage
                                      ropart = ro_part.
                        end.
                     end.
/*GUI*/              {mfguirex.i  "false"} /*Replace mfrpexit*/
                   
                  end. /*for each pk_det*/

                 
/*GUI*/ {mfguirex.i } /*Replace mfrpexit*/

/*G2B9* /*J014*/         end.  */ /* not a joint_type */
/*G2B9*               end.   */  /*for each pt_mstr*/

/*G2B9*/      end. /* if not get-next */
/*G2B9* * * BEGIN ADD SECTION */

             /* LOGIC FOR FINDING THE NEXT BOM_MSTR AND PT_MSTR RECORDS */
             
             if avail bom_mstr and avail pt_mstr then do:
               if pt_part > bom_parent then
                 find next bom_mstr where 
					bom_domain = global_domain and /*---Add by davild 20090205.1*/
					bom_parent >= part
                   and bom_parent <= part1 no-lock no-error.
               else if bom_parent > pt_part then
                 find next pt_mstr where 
					pt_domain = global_domain and /*---Add by davild 20090205.1*/
					pt_part >= part and
                   pt_part <= part1 no-lock no-error.
               else do:
                 find next bom_mstr where 
					bom_domain = global_domain and /*---Add by davild 20090205.1*/
					bom_parent >= part
                     and bom_parent <= part1 no-lock no-error.
                 find next pt_mstr where 
					pt_domain = global_domain and /*---Add by davild 20090205.1*/
					pt_part >= part and
                   pt_part <= part1 no-lock no-error.
               end.
             end.
             else if avail bom_mstr then
               find next bom_mstr where 
				bom_domain = global_domain and /*---Add by davild 20090205.1*/
				bom_parent >= part
                 and bom_parent <= part1 no-lock no-error.
             else if avail pt_mstr then
               find next pt_mstr where 
				pt_domain = global_domain and /*---Add by davild 20090205.1*/
				pt_part >= part
                 and pt_part <= part1 no-lock no-error.
             else leave.

/*G2B9* * * END ADD SECTION */

/*FM55*/    end. /* repeat mainloop*/

/*IFP**************/
            find first rodet where mfguserid = mfguser no-lock no-error.
            if available rodet then do:
               if not summary then do:
                  FORM /*GUI*/ 
                     ropart
                     desc1
                     rowkctr column-label "分厂"
                     romch	column-label "机器"
                     qty column-label "数量"
                     rorouting column-label "工艺流程代码"
                     roop
                     rodesc 
                     rosetup column-label "准备时间"
                     rorun column-label "加工时间"
                 with STREAM-IO /*GUI*/  frame f width 255 down no-attr-space no-box.
   								setFrameLabels(frame f:handle).
                 for each rodet where mfguserid = mfguser break by ropart by rowkctr by romch 
                    with frame f width 255 STREAM-IO:
                    accumulate rorun (sub-total by ropart by rowkctr by romch).
                    accumulate rosetup (sub-total by ropart by rowkctr by romch).
                    if first-of(romch) then do:
                        find first pt_mstr where 
							pt_domain = global_domain and /*---Add by davild 20090205.1*/
							pt_part = ropart no-lock no-error.
                        if not available pt_mstr then find first bom_mstr where 
							bom_domain = global_domain and /*---Add by davild 20090205.1*/
							bom_parent = ropart no-lock.
                        if available pt_mstr then desc1 = pt_desc1.
                        else desc1 = bom_desc.
                        display ropart desc1 rowkctr romch qty with STREAM-IO.
                    end.
                    display  rorouting roop rodesc rorun rosetup.
                    down.
                    if dis_ro_sub then do:
                     if last-of(romch) then do:
                        underline rorun rosetup.
                        display accum sub-total by romch rorun @ rorun
                                accum sub-total by romch rosetup @ rosetup
                                "              按设备小计" @ rodesc .
                        down 2.
                     end.
                     if last-of(rowkctr) then do:
                        underline rorun rosetup.
                        display accum sub-total by rowkctr rorun @ rorun
                                accum sub-total by rowkctr rosetup @ rosetup
                                "          按加工中心小计" @ rodesc .
                        down 2.
                        end.
                    end.
                    if last-of(ropart) then do:
                         underline rorun rosetup.
                         display "                    总计" @ rodesc
                                 accum sub-total by ropart rorun @ rorun 
                                 accum sub-total by ropart rosetup @ rosetup.
                         down 2.
                    end.
                 end.            
              end.
              else do:
                 FORM 
                      ropart
                      desc1
                      rowkctr column-label "分厂"
                      qty column-label "数量"
                      rosetup column-label "准备时间"
                      rorun column-label "加工时间"
                 with STREAM-IO frame g 132 down no-attr-space no-box.
                 setFrameLabels(frame g:handle).
                 for each rodet where mfguserid = mfguser no-lock break by ropart by substring(rowkctr,1,2) 
                      with frame g width 132 STREAM-IO:
                      accumulate rorun (sub-total by ropart by substring(rowkctr,1,2)).
                      accumulate rosetup (sub-total by ropart by substring(rowkctr,1,2)).
                      if first-of(ropart) then do:
                        find first pt_mstr where 
							pt_domain = global_domain and /*---Add by davild 20090205.1*/
							pt_part = ropart no-lock no-error.
                        if not available pt_mstr then find first bom_mstr where 
							bom_domain = global_domain and /*---Add by davild 20090205.1*/
							bom_parent = ropart no-lock.
                        if available pt_mstr then desc1 = pt_desc1.
                        else desc1 = bom_desc.
                        display ropart desc1 qty with STREAM-IO.
                      end.
                      if last-of(substring(rowkctr,1,2)) then do:
                          display substring(rowkctr,1,2) @ rowkctr
                                  (accum sub-total by substring(rowkctr,1,2) rorun) @ rorun
                                  (accum sub-total by substring(rowkctr,1,2) rosetup) @ rosetup.
                          down.
                      end.
                      if last-of(ropart) then do:
                         underline rorun rosetup.
                         display accum sub-total by ropart rorun @ rorun 
                                 accum sub-total by ropart rosetup @ rosetup
                                 "          总计" @ qty.
                         down 2.
                      end.
                 end.
              end.
            end.


/*IFP*************/
            
 {mfguirex.i }.
 {mfguitrl.i}.
 {mfgrptrm.i} .


         end.
