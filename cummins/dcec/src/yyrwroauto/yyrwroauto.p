/* yyrwroauto.p - convert from xxtestoprp.p  - operation report print         */
/* COPYRIGHT DCEC. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/* V1                 Developped: 09/05/01      BY: Kang Jian          */
/* V2                 Developped: 09/16/01      BY: Kang Jian     *对自制零件的子件不进行检查**/
/*表与字段说明
pt_mstr 零件数据表
pt_iss_pol 虚实
pt_phantom 发放
ps_mstr BOM数据表
ps_par 零件号
ps_comp 子零件
ps_op 工序
ps_qty_per 用量
ps_start 起始日期
ps_end 中止日期

ro_det 工艺流程数据表
ro_routing 工艺流程代码
ro_op 工艺流程代码工序
ro_std_op 标准工序

opm_mstr 标准工序数据表
opm_std_op 标准工序 */
{mfdtitle.i "120817.1"}
def var rmks as char format "x(80)" label "说明".
define workfile bom1 field bom1_par like ps_par
                     field bom1_op like ps_op
                     field bom1_i as integer.
define workfile bom2 field bom2_par like ps_par label "零件号"
                     field bom2_op like ps_op label "BOM中工序"
                     field bom2_ro_op like ro_op label "工艺流程中工序"
                     field bom2_start like ps_start label "起始日期"
                     field bom2_end like ps_end label "中止日期"
                     field bom2_std_op like opm_std_op label "标准工序"
                     field bom2_pt_iss_pol like pt_iss_pol label "放"
                     field bom2_pt_phantom like pt_phantom label "虚实"
                     field bom2_pt_pm_code like pt_pm_code label "采/制"
                     field bom2_i as integer.
define var bom1 like ps_par.
define var level as integer.
/*start format of query screen*/
&SCOPED-DEFINE PP_FRAME_NAME A
FORM      
   RECT-FRAME       AT ROW 1.4 COLUMN 1.25
   RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
   SKIP(.1)  
   bom1 colon 30 
with frame a side-labels width 80 attr-space NO-BOX THREE-D.

DEFINE VARIABLE F-a-title AS CHARACTER.
   F-a-title = " 选择条件 ".
   RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
   RECT-FRAME-LABEL:WIDTH-PIXELS in frame a =
   FONT-TABLE:GET-TEXT-WIDTH-PIXELS(
   RECT-FRAME-LABEL:SCREEN-VALUE in frame a + " ", RECT-FRAME-LABEL:FONT).
   RECT-FRAME:HEIGHT-PIXELS in frame a =
   FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
   RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5.
&UNDEFINE PP_FRAME_NAME	  
/*judy 05/08/05*/ /* SET EXTERNAL LABELS */
/*judy 05/08/05*/  setFrameLabels(frame a:handle).

{mfguirpa.i true  "printer" 132 }
/*end format of query screen*/

/*start query preference initialize*/
/*start procefuer p-enable-ui*/
procedure p-enable-ui:
   
   if bom1     = hi_char  then bom1 = "". 
     
   run p-action-fields (input "display").
   run p-action-fields (input "enable").
end procedure. 
/*end procefuer p-enable-ui*/
/*end query preference initialize*/

/*start procedure of p-report-quote*/
/*start receive query preference*/
procedure p-report-quote:
   bcdparm = "".
   {mfquoter.i bom1} 
/*end receive query preference*/

/*start check the validity of query preference*/
   if bom1     = ""  then do:
      {mfmsg.i 40 3}
      undo,retry.
   end.
/*end check the validity of query preference*/
end procedure. 
/*end procedure of p-report-quote*/

/*end query  preference */

/*start procedure of p-report*/
/*start report out put*/
procedure p-report:
{gpprtrpa.i  "window" 132}                               
create bom1.
bom1_par = bom1.
bom1_i = 0.
do level = 0 to 99 :
    for each bom1 where bom1_i = level :
        for each ps_mstr where ps_domain = global_domain and 
        				 ps_par = bom1_par use-index ps_par no-lock:
            create bom2.
            bom2_par = ps_comp.
            bom2_op = ps_op.
            bom2_start = ps_start.
            bom2_end = ps_end.
            bom2_i = level + 1.
            find pt_mstr where pt_domain = global_domain and
            		 pt_part = ps_comp no-lock no-error .
            if available pt_mstr then do:
                 bom2_pt_pm_code = pt_pm_code.
               bom2_pt_iss_pol = pt_iss_pol.
               bom2_pt_phantom = pt_phantom.
            end.
        end.
    end.
    find first bom2 where bom2_i = (level + 1) no-error.
    if not available bom2 then leave.
    for each bom2 :
         if not (bom2_pt_pm_code="M" and (not bom2_pt_phantom)) then do:            
          create bom1.
            bom1_par = bom2_par.
            bom1_i = bom2_i.
       end.
    end.   
end.
for each bom2 :    
    if bom2_op <> 0 then do:
       find first ro_det where ro_domain = global_domain and 
       			ro_routing = bom1 and ro_op = bom2_op no-lock no-error .
       if available ro_det then do:
        bom2_ro_op = ro_op.
        bom2_std_op = ro_std_op.
       end.
    end.
end.
/*产生工艺流程*/
for each bom2 where bom2_op <> 0 and bom2_ro_op = 0:
          find first ro_det where ro_domain = global_domain and ro_routing = bom1 and ro_op = bom2_op no-error.
              if not available ro_det then do:
                    create ro_det. ro_domain = global_domain.
                    assign ro_routing = bom1
                           ro_op = bom2_op.
/*                         ro__chr01 = bom__chr01.                           */

                    find opm_mstr where opm_domain = global_domain and opm_std_op = string(bom2_op) no-lock no-error.
                    if available opm_mstr then do:
                        assign ro_std_op = opm_std_op
                               ro_desc = opm_desc
                               ro_wkctr = opm_wkctr
                               ro_mch = opm_mch
                               ro_tran_qty = opm_tran_qty
                               ro_milestone = opm_mile
                               ro_sub_lead = opm_sub_lead
                               ro_setup = opm_setup
                               ro_run = opm_run
                               ro_move = opm_move
                               ro_yield_pct = opm_yld_pct
                               ro_tool = opm_tool
                               ro_vend = opm_vend
                               ro_inv_value = opm_inv_val
                               ro_sub_cost = opm_sub_cost
                               ro_mv_nxt_op = yes
                               ro_auto_lbr = yes.
                        find wc_mstr where wc_domain = global_domain and wc_wkctr = opm_wkctr and wc_mch = opm_mch no-lock no-error.
                        if available wc_mstr then do:
                               assign ro_mch_op = wc_mch_op
                                      ro_queue = wc_queue
                                      ro_wait = wc_wait
                                      ro_men_mc = wc_men_mch
                                      ro_setup_men = wc_setup_men.
                        end.
                    end.

              end. /*if not available ro_det*/
end.

for each bom_mstr where bom_domain = global_domain and bom_parent = BOM1 no-lock:
        rmks = "".
 find first ro_det where ro_domain = global_Domain and ro_routing = bom1 no-lock no-error.
        if available ro_det then do:
              disp bom_parent bom_desc "成功创建工艺流程!" @ rmks with width 132 stream-io.
        end.
        else do:
              disp bom_parent bom_desc "失败!" @ rmks with width 132 stream-io.
        end.
end.
for each bom1:
   delete bom1.
end.
for each bom2:
  delete bom2.
end.

{mfreset.i}    
{mfgrptrm.i}
 
/* reset variable */

end. /*end of the procedure*/
{mfguirpb.i &flds="bom1 "}

