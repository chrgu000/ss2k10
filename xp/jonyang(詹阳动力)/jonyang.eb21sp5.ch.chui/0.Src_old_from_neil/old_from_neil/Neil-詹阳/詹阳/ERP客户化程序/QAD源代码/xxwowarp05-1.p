/* xxwowarp05.p - ALLOCATIONS BY ORDER REPORT                             */
/* GUI CONVERTED from wowarp05.p (converter v1.69) Sat Mar 30 01:26:46 1996 */
/* wowarp05.p - ALLOCATIONS BY ORDER REPORT                             */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/*F0PN*/ /*V8:ConvertMode=FullGUIReport                                 */
/* REVISION: 1.0      LAST MODIFIED: 05/12/86   BY: PML      */
/* REVISION: 1.0      LAST MODIFIED: 05/13/86   BY: EMB      */
/* REVISION: 1.0      LAST MODIFIED: 09/02/86   BY: EMB *12* */
/* REVISION: 2.1      LAST MODIFIED: 10/16/87   BY: WUG *A94**/
/* REVISION: 4.0    LAST MODIFIED: 02/24/88    BY: WUG *A175**/
/* REVISION: 5.0    LAST MODIFIED: 10/26/89    BY: emb *B357**/
/* REVISION: 5.0    LAST MODIFIED: 11/30/89    BY: emb *B409**/
/* REVISION: 5.0    LAST MODIFIED: 04/13/90    BY: emb *B663**/
/* REVISION: 7.3    LAST MODIFIED: 02/09/93    BY: emb *G656**/
/* REVISION: 7.2    LAST MODIFIED: 02/28/95    BY: ais *F0KM**/
/* REVISION: 8.5    LAST MODIFIED: 11/05/99    BY: jy014 *Infopower*/

/*GUI global preprocessor directive settings */
&GLOBAL-DEFINE PP_PGM_RP TRUE
&GLOBAL-DEFINE PP_ENV_GUI TRUE


/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

	 {mfdtitle.i "f "} /*G656*/ /*GUI moved to top.*/
	 define variable nbr like wod_nbr.
	 define variable nbr1 like wod_nbr.
	 define variable lot like wod_lot.
         define variable part like wod_part   label "子零件".
	 define variable part1 like wod_part.
	 define variable open_ref like wod_qty_req label "短缺量".
	 define variable all_pick like wod_qty_req label "备料量/领料量".
/*IFP*/  define variable deliver like wod_deliver label "工作中心".
/*IFP*/  define variable deliver1 like wod_deliver label "工作中心".
/*IFP*/	 define variable lot1 like wod_lot.
/*IFP*/  define variable skpage like mfc_logical label "按工作中心分页".
/*IFP*/  define variable parn  like wo_part label "父零件".
/*IFP*/  define variable parn1 like wo_part.
/*IFP*/  define variable wodesc1 like pt_desc1.
/*IFP*/  define variable wodesc2 like pt_desc2.
/*IFP*/  define variable laddesc1 like pt_desc1.
/*IFP*/  define variable laddesc2 like pt_desc2.
/*IFP*/  define variable only_pick like mfc_logical label "仅领料量".
/*IFP*/  define variable only_all like mfc_logical label "仅备料量".
/*IFP*/  define variable iss_date like wod_iss_date.
/*IFP*/  define variable iss_date1 like wod_iss_date.
/*IFP*/  define variable rel_date like wo_rel_date.
/*IFP*/  define variable rel_date1 like wo_rel_date.
/*IFP*/  define variable due_date like wo_due_date.
/*IFP*/  define variable due_date1 like wo_due_date.
/*IFP*/	 define variable summary like mfc_logical label "S-汇总/D-明细" format "S-汇总/D-明细".
/*IFP*/  def new shared var sortoption      as int label "排序选项" format "9" init 2.
/*IFP*/  def new shared var sortextoption   as char extent 2 format "x(30)"
             init [
             "1 - 按工作中心, 仓库排序",
             "2 - 按仓库, 工作中心排序"].
/*IFP*/  define variable loc as char format "x(2)" label "仓库".
/*IFP*/  define variable loc1 as char format "x(2)".
/*IFP*/  define variable prod_line    like pt_prod_line.
/*IFP*/  define variable prod_line1   like pt_prod_line.
/*IFP*/  define variable tot_qty_req  like wod_qty_req.
/*IFP*/  define variable tot_qty_iss  like wod_qty_iss.
/*IFP*/  define variable tot_open_ref like wod_qty_req.
/*IFP*/  define variable disp_qty as character label "实发量" initial "(________________)" format "x(18)".
/*IFP*/  define variable disp_zero like mfc_logical label "抑制显示零数量".
         define variable price_1 like sct_mtl_tl format "->>>>>>9.99".

	 /* DISPLAY TITLE */
/*GUI moved mfdeclre/mfdtitle.*/

	 
/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
/*IFP*/     prod_line      colon 15
/*IFP*/     prod_line1     label {t001.i} colon 49 skip
            nbr            colon 15
	    nbr1           label {t001.i} colon 49 skip
	    lot            colon 15
/*IFP*/     lot1           label {t001.i} colon 49 skip
/*IFP*/     parn           colon 15 
/*IFP*/     parn1          label {t001.i} colon 49 skip
	    part           colon 15
	    part1          label {t001.i} colon 49 skip
/*IFP*/     rel_date       colon 15 
/*IFP*/     rel_date1      label {t001.i} colon 49 skip
/*IFP*/     due_date       colon 15
/*IFP*/     due_date1      label {t001.i} colon 49 skip
/*IFP*/     iss_date       colon 15
/*IFP*/     iss_date1      label {t001.i} colon 49 skip
/*IFP*/     loc            colon 15
/*IFP*/     loc1           label {t001.i} colon 49 skip
/*IFP*/     deliver        colon 15
/*IFP*/     deliver1       label {t001.i} colon 49 skip(1)
/*IFP*/     skpage         colon 15
/*IFP*/     summary        colon 49 skip
/*IFP*/     only_pick      colon 15
/*IFP*/     sortoption     colon 49 skip
/*IFP*/     only_all       colon 15
/*IFP*/     sortextoption[1]  colon 49 no-label
/*IFP*/     disp_zero      colon 15
/*IFP*/     sortextoption[2]  colon 49 no-label
	  SKIP(.4)  /*GUI*/
with frame a side-labels WIDTH 80.

setFrameLabels(frame a:handle).

/*GUI preprocessor Frame A undefine */
&UNDEFINE PP_FRAME_NAME

repeat:

/*IFP*/     display sortextoption with frame a .
	    if nbr1 = hi_char then nbr1 = "".
/*IFP*/     if deliver1 = hi_char then deliver1 = "".
/*IFP*/     if lot1 = hi_char then lot1 = "".
/*IFP*/     if part1 = hi_char then part1 = "".
/*IFP*/     if parn1 = hi_char then parn1 = "".
/*IFP*/     if rel_date1 = hi_date then rel_date1 = ?.
/*IFP*/     if due_date1 = hi_date then due_date1 = ?.
/*IFP*/     if rel_date = low_date then rel_date = ?.
/*IFP*/     if due_date = low_date then due_date = ?.
/*IFP*/     if iss_date = low_date then iss_date = ?.
/*IFP*/     if iss_date1 = hi_date then iss_date1 = ?.
/*IFP*/     if loc1 = hi_char then loc1 = "".
/*IFP*/     if prod_line1 = hi_char then prod_line1 = hi_char.
			
			update prod_line prod_line1 nbr nbr1 lot lot1 parn parn1 part part1 rel_date rel_date1
     due_date due_date1 iss_date iss_date1 loc loc1 deliver deliver1 skpage summary 
     only_pick sortoption only_all disp_zero with frame a.

	    bcdparm = "".
/*IFP*/     {mfquoter.i prod_line   }
/*IFP*/     {mfquoter.i prod_line1 }
	    {mfquoter.i nbr    }
	    {mfquoter.i nbr1   }
	    {mfquoter.i lot    }
/*IFP*/     {mfquoter.i lot1   }
/*IFP*/	    {mfquoter.i parn   }
/*IFP*/	    {mfquoter.i parn1  }
	    {mfquoter.i part   }
	    {mfquoter.i part1  }
/*IFP*/     {mfquoter.i rel_date}
/*IFP*/     {mfquoter.i rel_date1}
/*IFP*/     {mfquoter.i due_date}
/*IFP*/     {mfquoter.i due_date1}
/*IFP*/     {mfquoter.i iss_date}
/*IFP*/     {mfquoter.i iss_date1}
/*IFP*/     {mfquoter.i loc      }
/*IFP*/     {mfquoter.i loc1     }
/*IFP*/     {mfquoter.i deliver  }
/*IFP*/     {mfquoter.i deliver1 }
/*IFP*/     {mfquoter.i skpage   }
/*IFP*/     {mfquoter.i only_pick}
/*IFP*/     {mfquoter.i only_all }
/*IFP*/     {mfquoter.i disp_zero}

	    if  nbr1 = "" then nbr1 = hi_char.
/*IFP*/     if  deliver1 = "" then deliver1 = hi_char.
/*IFP*/     if  lot1  = "" then lot1 = hi_char.
/*IFP*/     if  part1 = "" then part1 = hi_char.
/*IFP*/     if  parn1 = "" then parn1 = hi_char.
/*IFP*/     if  rel_date1 = ? then rel_date1 = hi_date.
/*IFP*/     if  due_date1 = ? then due_date1 = hi_date.
/*IFP*/     if  rel_date = ? then rel_date = low_date.
/*IFP*/     if  due_date = ? then due_date = low_date.
/*IFP*/     if  iss_date = ? then iss_date = low_date.
/*IFP*/     if  iss_date1 = ? then iss_date1 = hi_date.
/*IFP*/     if  loc1 = "" then loc1 = hi_char.
/*IFP*/     if  prod_line1 = "" then prod_line1 = hi_char.

/*IFP*/     if  sortoption < 1 or sortoption > 2 then do:
/*IFP*/          {mfmsg.i 712 3}
/*IFP*/          next-prompt sortoption with frame a.
/*IFP*/          undo, retry.
/*IFP*/     end.

	    /* SELECT PRINTER  */
	    
					{mfselbpr.i "printer" 132}


	    {mfphead.i}

/*Assign wod_deliver to Work center*/

	    for each wo_mstr no-lock where 
		wo_domain = global_domain and /*---Add by davild 20090205.1*/
		(wo_nbr >= nbr and wo_nbr <= nbr1)	    
	    and (wo_lot >= lot and wo_lot <= lot1) 
/*IFP*/     and (wo_rel_date >= rel_date and wo_rel_date <= rel_date1)
/*IFP*/     and (wo_due_date >= due_date and wo_due_date <= due_date1)	    
	    and (wo_part >= parn and wo_part <= parn1),
	    each wod_det where wod_lot = wo_lot
	    and (wod_part >= part) and (wod_part <= part1 or part1 = "")
/*IFP*/	    exclusive-lock break by wo_nbr by wod_lot :
                if wod_deliver = "" then do:
                   if wo_routing <> "" then do:
                      find first ro_det where 
					  ro_domain = global_domain and /*---Add by davild 20090205.1*/
					  ro_routing = wo_routing and ro_op = wod_op no-lock no-error.
                      if available ro_det then assign wod_deliver = ro_wkctr.
                      else do:
                         find first ro_det where 
						 ro_domain = global_domain and /*---Add by davild 20090205.1*/
						 ro_routing = wo_routing no-lock no-error.
                         if available ro_det then assign wod_deliver = ro_wkctr.                   
                      end.
                   end.
                   else do:
                      find first ro_det where 
					  ro_domain = global_domain and /*---Add by davild 20090205.1*/
					  ro_routing = wo_part and ro_op = wod_op no-lock no-error.
                      if available ro_det then assign wod_deliver = ro_wkctr.
                      else do:
                         find first ro_det where 
						 ro_domain = global_domain and /*---Add by davild 20090205.1*/
						 ro_routing = wo_part no-lock no-error.
                         if available ro_det then assign wod_deliver = ro_wkctr.                   
                      end.
                   end.
                end.
                for each lad_det where 
				lad_domain = global_domain and /*---Add by davild 20090205.1*/
				lad_dataset = "wod_det" 
                and lad_nbr = wod_lot and lad_part = wod_part 
                and lad_user1 = ""
                exclusive-lock  use-index lad_det:
                    assign lad_user1 = wod_deliver.
                end.                    
            end.
/*Assign wod_deliver to Work center*/


/*IFP*/  if summary then do:
	    /* FIND AND DISPLAY */
	    for each wod_det no-lock where  
					wod_domain = global_domain and /*---Add by davild 20090205.1*/
/*G656*/                 wod_lot >= lot and wod_lot <= lot1
                     and wod_nbr >= nbr and wod_nbr <= nbr1
                     and wod_part >= part and wod_part <= part1
                     and wod_deliver >= deliver and wod_deliver <= deliver1
                     and wod_iss_date >= iss_date and wod_iss_date <= iss_date1
                     ,first wo_mstr where 
					  wo_domain = global_domain and /*---Add by davild 20090205.1*/
					  wo_lot = wod_lot and wo_part >= parn 
                      and wo_part <= parn1 and wo_rel_date >= rel_date 
                      and wo_rel_date <= rel_date1 and wo_due_date >= due_date
                      and wo_due_date <= due_date1 
                     with frame c width 255 DOWN STREAM-IO 
/*F822*/             break by wod_deliver by wod_part
                     by wod_nbr by wod_op:
                  setFrameLabels(frame c:handle).   
                  FORM
                      wo_part label "父零件" wodesc1
                      wod_part label "子零件" pt_desc1 pt_um 
                      price_1 LABEL "计划价" PT_LOC PT_PROD_LINE
                      wo_nbr column-label "加工单!标志" wod_op   
                      wod_qty_req wod_qty_all wod_qty_pick wod_qty_iss open_ref
                  with frame c width 255 down stream-io.    
                   
                  find first pt_mstr where 
				  pt_domain = global_domain and /*---Add by davild 20090205.1*/
				  pt_part = wo_part no-lock no-error.
                  assign wodesc1 = pt_desc1 wodesc2 = pt_desc2.
                  
                  find first pt_mstr where 
				  pt_domain = global_domain and /*---Add by davild 20090205.1*/
				  pt_part = wod_part 
/*IFP*/               and pt_prod_line >= prod_line and pt_prod_line <= prod_line1
                      no-lock no-error.
                  
/*IFP*/           if available pt_mstr then do:                      
/*IFP*/                if wod_qty_req > 0 then open_ref = max(wod_qty_req - wod_qty_iss,0).
/*IFP*/                else open_ref = min(wod_qty_req - wod_qty_iss,0).
  
/*IFP*/                if wo_status = "C" then open_ref = 0.
                       tot_open_ref = tot_open_ref + open_ref.
                       if first-of(wod_deliver) then do with frame c1 STREAM-IO side-labels:
                           find first wc_mstr where 
						   wc_domain = global_domain and /*---Add by davild 20090205.1*/
						   wc_wkctr = wod_deliver no-lock no-error.
                           display wod_deliver label "工作中心"  wc_desc when (available wc_mstr).
                       end.
                       ACCUMULATE wod_qty_req(SUB-TOTAL BY wod_deliver by wod_part).
                       ACCUMULATE wod_qty_all(SUB-TOTAL BY wod_deliver by wod_part).
                       ACCUMULATE wod_qty_pick(SUB-TOTAL BY wod_deliver by wod_part).
                       ACCUMULATE wod_qty_iss(SUB-TOTAL BY wod_deliver by wod_part).
             find sct_det where 
			 sct_domain = global_domain and /*---Add by davild 20090205.1*/
			 WOD_part = sct_part AND sct_sim = "Standard" and WOD_site = sct_site no-lock no-error.
               if available sct_det then do:
                  price_1 = sct_mtl_tl + sct_sub_tl . 
               end.
                 
                       display wo_nbr wod_op wod_part wodesc1
                               pt_desc1  wo_part price_1  PT_LOC PT_PROD_LINE
                               wod_qty_req  when (disp_zero = no or wod_qty_req <> 0 )
                               wod_qty_all  when (disp_zero = no or wod_qty_all <> 0 )
                               wod_qty_pick when (disp_zero = no or wod_qty_pick <> 0)
                               wod_qty_iss  when (disp_zero = no or wod_qty_iss <> 0 )
                               open_ref     when (disp_zero = no or open_ref <> 0    )
                               pt_um.
                       down 1.
                       display wodesc2 @ wodesc1 pt_desc2 @ pt_desc1 wod_lot @ wo_nbr.
                       if last-of(wod_part) then do:
                              underline wod_qty_req wod_qty_all wod_qty_pick wod_qty_iss open_ref.
                              display ACCUM SUB-TOTAL BY wod_part wod_qty_req  @ wod_qty_req
                                      ACCUM SUB-TOTAL BY wod_part wod_qty_all  @ wod_qty_all
                                      ACCUM SUB-TOTAL BY wod_part wod_qty_pick @ wod_qty_pick
                                      ACCUM SUB-TOTAL BY wod_part wod_qty_iss  @ wod_qty_iss
                                      tot_open_ref @ open_ref.
                              down 1.
                       end.
/*IFP*/           end.
                  else next.
                  
/*IFP*/           if skpage and last-of(wod_deliver) then page.
                  if last-of(wod_deliver) then tot_open_ref = 0.
/*GUI*/ {mfguirex.i } /*Replace mfrpexit*/

	    end.
/*IFP*/ end.
/*IFP*/ else if sortoption = 1 then do:
	    for each lad_det no-lock where 
		lad_domain = global_domain and /*---Add by davild 20090205.1*/
		lad_dataset = "wod_det"
/*G656*/             and lad_nbr >= lot and lad_nbr <= lot1
                     and lad_part >= part and lad_part <= part1
                     and lad_user1 >= deliver and lad_user1 <= deliver1
/*IFP*/              and substring(lad_loc,1,2) >= loc and substring(lad_loc,1,2) <= loc1                     
                     with frame d width 255 DOWN STREAM-IO break
/*F822*/             by lad_dataset by lad_user1 by substring(lad_loc,1,2)
/*F822*/             by lad_part
                     by lad_nbr by lad_line
                     by lad_lot by lad_ref:
                  find first wo_mstr where 
					wo_domain = global_domain and /*---Add by davild 20090205.1*/
					wo_lot = lad_nbr no-lock no-error.
/*IFP*/              if available wo_mstr then do:
/*IFP*/              if wo_nbr < nbr and wo_nbr > nbr1 then next.
/*IFP*/              if wo_part < parn and wo_part > parn1 then next.
/*IFP*/              if wo_rel_date < rel_date or wo_rel_date > rel_date1 then next.                     
/*IFP*/              if wo_due_date < due_date or wo_due_date > due_date1 then next.                     
/*IFP*/           end.
                  else next.

/*IFP*/           find first wod_det where 
					wod_domain = global_domain and /*---Add by davild 20090205.1*/
					wod_lot = wo_lot no-lock no-error.
/*IFP*/           if available wod_det then do:
/*IFP*/              if wod_iss_date < iss_date or wod_iss_date > iss_date1 then next.
/*IFP*/           end.
/*IFP*/           else next.

                  if only_pick then if lad_qty_pick = 0 and lad_qty_all = 0 then next.
                  if only_all then if lad_qty_all = 0 and lad_qty_pick = 0 then next.
                  
                  
                  FORM
                      lad_part label "子零件" pt_desc1 pt_um 
                      wo_part label "父零件" wodesc1 
                      wo_nbr column-label "加工单!标志" lad_line label "工序"  
                      PT_loc PT_PROD_LINE
                      lad_lot label "批序号/参考" 
                      wod_qty_req
                      lad_qty_all lad_qty_pick 
                      wod_qty_iss
                      open_ref 
                  with frame d width 255 down stream-io.    
                  setFrameLabels(frame d:handle).
                  if available wo_mstr then do:
                     find first pt_mstr where 
					 pt_domain = global_domain and /*---Add by davild 20090205.1*/
					 pt_part = wo_part no-lock no-error.
                     if available pt_mstr then assign wodesc1 = pt_desc1 wodesc2 = pt_desc2.
                     else assign wodesc1 = "" wodesc2 = "".
                  end.
                  
                  if first-of(substring(lad_loc,1,2)) then do with frame d1 STREAM-IO side-labels width 255:
                       find first wc_mstr where 
					   wc_domain = global_domain and /*---Add by davild 20090205.1*/
					   wc_wkctr = lad_user1 no-lock no-error.
                       display lad_user1 label "工作中心"  wc_desc when (available wc_mstr) substring(lad_loc,1,2) label "仓库" 
                                "计划员:________________" no-label at 150.
                  end.

/*IFP*/           if wod_qty_req > 0 then open_ref = max(wod_qty_req - wod_qty_iss,0).
/*IFP*/           else open_ref = min(wod_qty_req - wod_qty_iss,0).

/*IFP*/           if wo_status = "C" then open_ref = 0.
                  
                  find first pt_mstr where 
					pt_domain = global_domain and /*---Add by davild 20090205.1*/
					pt_part = lad_part 
/*IFP*/               and pt_prod_line >= prod_line and pt_prod_line <= prod_line1
                      no-lock no-error.
/*IFP*/           if available pt_mstr then do:                      
                       ACCUMULATE lad_qty_pick(SUB-TOTAL BY lad_dataset BY lad_user1 BY substring(lad_loc,1,2) by lad_part).
                       ACCUMULATE lad_qty_all(SUB-TOTAL BY lad_dataset BY lad_user1 BY substring(lad_loc,1,2) by lad_part).
                       display wo_nbr when(available wo_mstr) lad_line wo_part when (available wo_mstr) wodesc1
                                 lad_part pt_desc1 PT_loc PT_PROD_LINE
                                 lad_lot 
                                 lad_qty_all when (disp_zero = no or lad_qty_all <> 0)
                                 lad_qty_pick when (disp_zero = no or lad_qty_pick <> 0)
                                 pt_um.
                       if last-of(lad_nbr) then display wod_qty_req wod_qty_iss open_ref.
                       if wodesc2 <> "" or pt_desc2 <> "" or lad_lot <> "" or lad_nbr <> "" then do:
                              down 1.
                              display wodesc2 @ wodesc1 pt_desc2 @ pt_desc1 lad_ref @ lad_lot lad_nbr @ wo_nbr.
                       end.
                       if last-of(lad_part) then do:
                              underline lad_qty_all lad_qty_pick.
                              display ACCUM SUB-TOTAL BY lad_part lad_qty_pick @ lad_qty_pick
                                      ACCUM SUB-TOTAL BY lad_part lad_qty_all @ lad_qty_all.
                              down 1.
                       end.
/*IFP*/           end.
                  
/*IFP*/           if skpage and last-of(lad_user1) then page.
/*IFP*/           if skpage and last-of(substring(lad_loc,1,2)) then page.                  
                  
/*GUI*/ {mfguirex.i } /*Replace mfrpexit*/

	    end.
/*IFP*/ end.
/*IFP*/ else if sortoption = 2 then do:
	    for each lad_det no-lock where 
		lad_domain = global_domain and /*---Add by davild 20090205.1*/
		lad_dataset = "wod_det"
/*G656*/             and lad_nbr >= lot and lad_nbr <= lot1
                     and lad_part >= part and lad_part <= part1
                     and lad_user1 >= deliver and lad_user1 <= deliver1
/*IFP*/              and substring(lad_loc,1,2) >= loc and substring(lad_loc,1,2) <= loc1                     
                     ,first wod_det where 
					 wod_domain = global_domain and /*---Add by davild 20090205.1*/
					 wod_lot = lad_nbr and wod_part = lad_part
                     with frame e width 255 DOWN STREAM-IO break
/*F822*/             by lad_dataset by substring(lad_loc,1,2) by lad_user1 
/*F822*/             by lad_part
                     by lad_nbr by lad_line
                     by lad_lot by lad_ref:
										setFrameLabels(frame e:handle).
                  find first wo_mstr where 
				  wo_domain = global_domain and /*---Add by davild 20090205.1*/
				  wo_lot = lad_nbr no-lock no-error.
/*IFP*/              if available wo_mstr then do:
/*IFP*/              if wo_nbr < nbr and wo_nbr > nbr1 then next.
/*IFP*/              if wo_part < parn and wo_part > parn1 then next.
/*IFP*/              if wo_rel_date < rel_date or wo_rel_date > rel_date1 then next.                     
/*IFP*/              if wo_due_date < due_date or wo_due_date > due_date1 then next.                     
/*IFP*/           end.
                  else next.

/*IFP*/           if wod_iss_date < iss_date or wod_iss_date > iss_date1 then next.
/*IFP*/           if wod_qty_req > 0 then open_ref = max(wod_qty_req - wod_qty_iss,0).
/*IFP*/           else open_ref = min(wod_qty_req - wod_qty_iss,0).

/*IFP*/           if wo_status = "C" then open_ref = 0.

                  if only_pick then if lad_qty_pick = 0 and lad_qty_all = 0 then next.
                  if only_all then if lad_qty_all = 0 and lad_qty_pick = 0 then next.
                  FORM skip(2)
                       "库管员:______________" at 40 
                       "经领人:_________________" at 100
                       "发料日期:_______________" at 160
                  with STREAM-IO frame phead1 page-bottom width 255 no-box.
                  
                  view frame phead1.
                  
                  FORM
                      lad_part label "子零件" pt_desc1 pt_um 
                      wo_part label "父零件" wodesc1 
                      wo_nbr column-label "加工单/标志" lad_line label "工序"  
                      PT_loc PT_PROD_LINE

                      lad_lot label "批序号/参考" 
                      lad_qty_all 
                      lad_qty_pick 
                      disp_qty
                  with frame e width 255 down stream-io.    
                   
                  if available wo_mstr then do:
                     find first pt_mstr where 
					 pt_domain = global_domain and /*---Add by davild 20090205.1*/
					 pt_part = wo_part no-lock no-error.
                     if available pt_mstr then assign wodesc1 = pt_desc1 wodesc2 = pt_desc2.
                     else assign wodesc1 = "" wodesc2 = "".
                  end.
                  
                  if first-of(lad_user1) then do with frame e1 width 255 STREAM-IO side-labels:
                       find first wc_mstr where 
					   wc_domain = global_domain and /*---Add by davild 20090205.1*/
					   wc_wkctr = lad_user1 no-lock no-error.
                       display  substring(lad_loc,1,2) label "仓库: "  lad_user1 label "工作中心: "  wc_desc when (available wc_mstr)
                                "计划员: ________________" no-label at 150.
                  end.
                  
                  find first pt_mstr where 
					pt_domain = global_domain and /*---Add by davild 20090205.1*/
					pt_part = lad_part 
/*IFP*/               and pt_prod_line >= prod_line and pt_prod_line <= prod_line1
                      no-lock no-error.
/*IFP*/           if available pt_mstr then do:                      
                       ACCUMULATE lad_qty_pick(SUB-TOTAL BY lad_dataset BY substring(lad_loc,1,2) BY lad_user1 by lad_part).
                       ACCUMULATE lad_qty_all(SUB-TOTAL BY lad_dataset BY substring(lad_loc,1,2) BY lad_user1 by lad_part).
                       down 1.
                       display wo_nbr when(available wo_mstr) lad_line wo_part when (available wo_mstr) wodesc1
                                 lad_part pt_desc1 PT_loc PT_PROD_LINE
                                 lad_lot 
                                 lad_qty_all  when (disp_zero = no or lad_qty_all <> 0)
                                 lad_qty_pick when (disp_zero = no or lad_qty_pick  <> 0)
                                 pt_um disp_qty.
                       if wodesc2 <> "" or pt_desc2 <> "" or lad_lot <> "" or lad_nbr <> "" then do:
                              down 1.
                              display wodesc2 @ wodesc1 pt_desc2 @ pt_desc1 lad_ref @ lad_lot lad_nbr @ wo_nbr.
                       end.
                       if last-of(lad_part) then do:
                              underline lad_qty_all lad_qty_pick .
                              display ACCUM SUB-TOTAL BY lad_part lad_qty_pick @ lad_qty_pick
                                      ACCUM SUB-TOTAL BY lad_part lad_qty_all @ lad_qty_all
                                      disp_qty.
                              down 2.
                       end.
/*IFP*/           end.
                  
/*IFP*/           if skpage and last-of(lad_user1) then page.
/*IFP*/           if skpage and last-of(substring(lad_loc,1,2)) then page.                  
                  
/*GUI*/ {mfguirex.i } /*Replace mfrpexit*/

	    end.
/*IFP*/ end.

	    /* REPORT TRAILER  */
	    
 {mfguirex.i }.
 {mfguitrl.i}.
 {mfgrptrm.i} .

	 end.		
