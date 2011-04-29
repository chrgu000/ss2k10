/**此文件为系统内的16。13。10*/
/* xxwowarp07.p - ALLOCATIONS BY ORDER REPORT                             */
/* GUI CONVERTED from wowarp07.p (converter v1.69) Sat Mar 30 01:26:46 1996 */
/* wowarp07.p - ALLOCATIONS BY ORDER REPORT                             */
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
/* REVISION: 8.5    LAST MODIFIED: 11/05/99    BY: jy015 *Infopower*/
/*By: Neil Gao 09/02/07 ECO: *SS 20090207* */
/* SS - 090925.1 By: Neil Gao */

/*GUI global preprocessor directive settings */
&GLOBAL-DEFINE PP_PGM_RP TRUE
&GLOBAL-DEFINE PP_ENV_GUI TRUE


/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

/* SS 090925.1 - B */
	 {mfdtitle.i "090925.1"}
/* SS 090925.1 - E */	 

	 define variable vend like wo_vend.
	 define variable nbr like wod_nbr.
	 define variable nbr1 like wod_nbr.
	 define variable lot like wod_lot.
/*F0KM   define variable part like wod_part.  */
/*F0KM*/ define variable part like wod_part   label "子零件".
	 define variable part1 like wod_part.
	 define variable desc1 like pt_desc1 .
	 define variable desc2 like pt_desc2 .
	 define variable desc3 as character format "x(24)".
	 define variable desc4 as character format "x(24)".
	 define variable desc5 as character format "x(24)".
	 define variable wodesc1 like pt_desc1.
	 define variable wodesc2 like pt_desc1.
	 define variable wkctr like ro_wkctr.
	 define variable open_ref like wod_qty_req label "短缺量".
	 define variable all_pick like wod_qty_req label "备料量/领料量".
	 define variable s_num as character extent 4.
	 define variable d_num as decimal decimals 9 extent 4.
	 define variable i as integer.
	 define variable j as integer.
/*IFP*/  define variable deliver like wod_deliver label "工作中心".
/*IFP*/  define variable deliver1 like wod_deliver label "工作中心".
/*IFP*/	 define variable lot1 like wod_lot.
/*IFP*/  define variable parn  like wo_part label "父零件".
/*IFP*/  define variable parn1 like wo_part.
/*IFP*/  define variable rel_date like wo_rel_date.
/*IFP*/  define variable rel_date1 like wo_rel_date.
/*IFP*/  define variable due_date like wo_due_date.
/*IFP*/  define variable due_date1 like wo_due_date.
/*IFP*/  define variable printline as character format "x(90)" extent 27.
/*IFP*/  define variable iss_date like wod_iss_date.
/*IFP*/  define variable iss_date1 like wod_iss_date.
         define variable um like pt_um.


	 /* DISPLAY TITLE */
/*GUI moved mfdeclre/mfdtitle.*/

	 
/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
			nbr            colon 15
	    nbr1           label {t001.i} colon 49 skip
/*IFP*/     parn          colon 15 
/*IFP*/     parn1          label {t001.i} colon 49 skip
	    part           colon 15
	    part1          label {t001.i} colon 49 skip
/*IFP*/     deliver        colon 15
/*IFP*/     deliver1       label {t001.i} colon 49 skip
	    lot            colon 15
/*IFP*/     lot1           label {t001.i} colon 49 skip
/*IFP*/     rel_date       colon 15 
/*IFP*/     rel_date1      label {t001.i} colon 49 skip
/*IFP*/     due_date       colon 15
/*IFP*/     due_date1      label {t001.i} colon 49 skip
/*IFP*/     iss_date       colon 15
/*IFP*/     iss_date1      label {t001.i} colon 49 skip
	  SKIP(.4)  /*GUI*/
with frame a width 80 side-labels .

setFrameLabels(frame a:handle).

/*GUI preprocessor Frame A undefine */
&UNDEFINE PP_FRAME_NAME


repeat :

	    if nbr1 = hi_char then nbr1 = "".
/*IFP*/     if deliver1 = hi_char then deliver1 = "".
/*IFP*/     if lot1 = hi_char then lot1 = "".
/*IFP*/     if parn1 = hi_char then parn1 = "".
/*IFP*/     if rel_date1 = hi_date then rel_date1 = ?.
/*IFP*/     if due_date1 = hi_date then due_date1 = ?.
/*IFP*/     if iss_date1 = hi_date then iss_date1 = ?.
/*IFP*/     if rel_date = low_date then rel_date = ?.
/*IFP*/     if due_date = low_date then due_date = ?.
/*IFP*/     if iss_date = low_date then iss_date = ?.

			update 			nbr
	    nbr1           
/*IFP*/     parn     
/*IFP*/     parn1    
	    part           
	    part1          
/*IFP*/     deliver  
/*IFP*/     deliver1 
	    lot            
/*IFP*/     lot1     
/*IFP*/     rel_date 
/*IFP*/     rel_date1
/*IFP*/     due_date 
/*IFP*/     due_date1
/*IFP*/     iss_date 
/*IFP*/     iss_date1
			with frame a.
	    
	    bcdparm = "".
	    {mfquoter.i nbr    }
	    {mfquoter.i nbr1   }
/*IFP*/	    {mfquoter.i parn   }
/*IFP*/	    {mfquoter.i parn1  }
	    {mfquoter.i part   }
	    {mfquoter.i part1  }
	    {mfquoter.i lot    }
/*IFP*/     {mfquoter.i lot1   }
/*IFP*/     {mfquoter.i deliver }
/*IFP*/     {mfquoter.i deliver1 }
/*IFP*/     {mfquoter.i rel_date}
/*IFP*/     {mfquoter.i rel_date1}
/*IFP*/     {mfquoter.i due_date}
/*IFP*/     {mfquoter.i due_date1}
/*IFP*/     {mfquoter.i iss_date}
/*IFP*/     {mfquoter.i iss_date1}

	    if  nbr1 = "" then nbr1 = hi_char.
/*IFP*/     if  deliver1 = "" then deliver1 = hi_char.
/*IFP*/     if  lot1 = "" then lot1 = hi_char.
/*IFP*/     if  parn1 = "" then parn1 = hi_char.
/*IFP*/     if  rel_date1 = ? then rel_date1 = hi_date.
/*IFP*/     if  due_date1 = ? then due_date1 = hi_date.
/*IFP*/     if  iss_date1 = ? then iss_date1 = hi_date.
/*IFP*/     if  rel_date = ? then rel_date = low_date.
/*IFP*/     if  due_date = ? then due_date = low_date.
/*IFP*/     if  iss_date = ? then iss_date = low_date.

	    /* SELECT PRINTER  */

				{mfselbpr.i "printer" 132}
/*GUI*/   mainloop: do on error undo, return error on endkey undo, return error:
/*                            123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789*/
	    /* FIND AND DISPLAY */
	    for each wo_mstr no-lock where wo_domain = global_domain and (wo_nbr >= nbr and wo_nbr <= nbr1)
	    and (wo_lot >= lot and wo_lot <= lot1)  
/*IFP*/     and (wo_rel_date >= rel_date and wo_rel_date <= rel_date1)
/*IFP*/     and (wo_due_date >= due_date and wo_due_date <= due_date1)	    
	    and (wo_part >= parn and wo_part <= parn1),
	    each wod_det where wod_domain = global_domain and wod_lot = wo_lot
	    and (wod_part >= part) and (wod_part <= part1 or part1 = "")
/*IFP*/     and (wod_deliver >= deliver and wod_deliver <= deliver1)
/*IFP*/	    and (wod_qty_all + wod_qty_pick <> 0)
/*IFP*/     and (wod_iss_date >= iss_date and wod_iss_date <= iss_date1)
	    no-lock break by wo_nbr by wod_lot by wod_part
	    with frame b down width 132 :
			setFrameLabels(frame b:handle).
			
	     /*  if first-of(wod_lot) then do with frame b:*/
		  desc1 = "".
		  desc2 = "".
		  um = "".
		  find pt_mstr where pt_domain = global_domain and pt_part = wo_part no-lock no-error.
		  if available pt_mstr then desc1 = pt_desc1.
		  if available pt_mstr then desc2 = pt_desc2.
		  if available pt_mstr then um = pt_um.
		  if page-size - line-counter < 9 then page.
/*IFP*/           find first wc_mstr where wc_domain = global_domain and wc_wkctr = wod_deliver no-lock no-error.
	
	 /******      end.**********/

/*B357*        open_ref = wod_qty_req - wod_qty_iss. */
/*B357*/       if wod_qty_req >= 0
/*B357*/       then open_ref = max(wod_qty_req - wod_qty_iss,0).
/*B357*/       else open_ref = min(wod_qty_req - wod_qty_iss,0).

	       all_pick = wod_qty_all + wod_qty_pick.

/*B357*/       if wo_status = "C" then do:
/*B357*/          open_ref = 0.
/*B357*/          all_pick = 0.
/*B357*/       end.

	      
	       desc3 = "".
	       find pt_mstr where pt_domain = global_domain and pt_part = wod_part no-lock no-error.
	       if available pt_mstr then desc4 = trim(pt_desc1) .
	       if available pt_mstr then desc5 = pt_desc2.
               if wc_wkctr = "231-01" then find first wr_route where wr_domain = global_domain and wr_lot = wo_lot and wr_part = wo_part no-lock no-error. 
               if available wr_route then desc3 = wr_desc.
               if substring(wc_wkctr,1,2) = "23" then find first ro_det where ro_domain = global_domain and ro_routing = wo_part and substring(ro_wkctr,1,2) <> "23" no-lock no-error.
               if open_ref <> 0 then do:
            put "贵 州 詹 阳 动 力 送 料 单" at 34 skip (1).        
            put " 工作中心:" at 3 wc_wkctr "  描述:" wc_desc    " 加工单:" wo_nbr   "标志:" wo_lot skip.
           if  available ro_det and substring(wc_wkctr,1,2) = "23" then put " 下道工序：" at 3 ro_wkctr skip.
  /******          put "┌────┬──────────┬───┬─────────------------------───--─--┬──┬─-┬------------------┐" at 2 skip.
           /*       123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456 */
            put "│子零件  │" at 2 wod_part "│ 描述 │"  at 34 desc2  " │单位│"  pt_um  "│生效日期" to 113 "│" to 125 skip.
/*IFP*/     put "├────┴──┬───────┴───┼------------------─────────----─----─┼──┴─-┴----------------─┤" at 2 skip.
/*IFP*/     put "│（代用）子零件│                      │描述                                            │批准：                       │" at 2 skip.
            put "├──----┬─--┴--┬--------┬---──-┼---------┬---──────┬──---┬──------┬-----─---------------------─┤" at 2 skip.
/*IFP*/     put "│需求量  │" at 2 trim(string(open_ref,"->>>,>>>,>>9.99<<<"))  "│实际发放│        │超发    %│批准：         │批/序号│          │尺寸:" desc3 "│" at 125 skip.
/*IFP*/     put "├────┼─----─┴─--──┴┬─-─-┼-----──┴--──-------─┴-------┴----------┴-----┬-----------------------┤" at 2 skip.
/*IFP*/     put "│父零件  │" at 2 wo_part "│描述  │" at 34  desc1 "│单位│"  um "│" at 123 skip.
/*IFP*/     put "├────┼────┬------┬--┴----┬┴─--─┬────┬──--┬─-----─┬-----------┴----┴----------──---───┤" at 2 skip.
/*IFP*/     put "│父件用量│" at 2 trim(string(wod_bom_qty,"->>>,>>>,>>9.99<<<")) "│订货量│" trim(string(wo_qty_ord)) "│已完成量│" trim(string(wo_qty_rjct + wo_qty_comp)) "│短缺量│" trim(string(wo_qty_ord - wo_qty_rjct - wo_qty_comp)) "  │加工单修改批准：" "│" at 123 skip.
/*IFP*/     put "├────┼────┼──--┼─-──-┼-----┬-┴─------┴------┴---------┴--------------------------------------──┤" at 2 skip.
/*IFP*/     put "│下达日  │" at 2 wo_rel_date "│到期日│" wo_due_date "│备注 │" "│" at 123 skip.
/*IFP*/     put "├────┴────┴───┴───--┴─---┴─------------------------------------------------------------------------┤" at 2 skip.
            put "│                                                                                                                       │" at 2 skip.
/*IFP*/     put "│ 经领:___________          计   划:__________             检   查:__________               发   料:________            │" at 2 skip.  
/*IFP*/     put "└─────────────────────────────────────-------------------------------------------─┘" at 2 skip.
*********/
            put "┌───┬──────────------┬----┬---┬--┬────┬─----┬--─---------------┐" at 2 skip.
       /*          123456789 123456789 123456789 123456789 123456789 123456789 123456789 12345679 12345679 */
            put "│子零件│" at 2 wod_part "│单位│" at 38 pt_um " │代│批准：  │子零件│                   │" at 48 skip.
            put "├───┼────────--------─┼----┴---┤  │        ├------┼─────---------┤" at 2 skip.
            put "│ 描述 │" at 2 desc4 format "x(23)" "│生效日期 │用│        │ 描述 │" at 38 "│" at 92 skip.              
            put "│      │" at 2 pt_desc2 "  │" wod_iss_date "│  │        │      │                   │" at 49 skip.
            put "├──--┼---------┬--------┬--─-┼---------┼--┴-───-┴-┬─-┴--┬──-----------┤" at 2 skip.
            put "│需求量│" at 2 trim(string(open_ref,"->>>,>>>,>>9.99<<<")) "│实际发放│     │超发    %│批准：         │批/序号│               │" at 21 skip.
            put "├───┼─-----─┴─--──┴-----┼─--┬-─┼--──-------─┴-------┴---------------┤" at 2 skip.
            put "│父零件│" at 2 wo_part "│单位│"  at 38 um " │下料尺寸:"  "│" at 92 skip.
            put "├───┼────────--------─┼----┴---┤" at 2 desc3 at 54.
            put "│" at 92 skip.
            put "│描述  │" at 2 desc1 "│父件用量 │" at 38 "│" to 93 skip.
            put "│      │" at 2 desc2  "│" at 38 trim(string(wod_bom_qty,"->>>,>>>,>>9.99<<<")) " │                                         │" skip. 
            put "├------┼--------┬--------┬------┴┬-------┼---------┬------------------------------┤" at 2 skip .
            put "│订货量│" at 2  trim(string(wo_qty_ord)) "│已完成量│" trim(string(wo_qty_rjct + wo_qty_comp)) "│短缺量 │" trim(string(wo_qty_ord - wo_qty_rjct - wo_qty_comp)) " │加工单修改批准：              │" skip.
            put "├───┼────┼──----┼─-──-┼----┬-┴─-------┴--------------------------──┤" at 2  skip.
            put "│下达日│" at 2 wo_rel_date "│到期日  │"  wo_due_date "│备注│                                            │" skip.
            put "├───┴────┴───--┴───--┴─--┴─------------------------------------------┤" at 2 skip.
            put "│                                                                                        │"at 2 skip.                                 
            put "│ 经领:___________    计   划:__________    检   查:__________    发   料:________       │"at 2 skip.
            put "└─────────────────────────────────────------------─┘" at 2 skip.

/* SS 090925.1 - B */
/*
down 2.
*/
down 1.
/* SS 090925.1 - E */
/*IFP*/        
if page-size - line-count < 13 then do:
	if not last(wo_nbr) then page.
end.
else do:
	put " " skip(4).
end.


end.
    end. /*enf for open_ref <> 0*/      
               

  /* end.*/

	    /* REPORT TRAILER  */
/* SS 090925.1 - B */
/*
 {mfguirex.i }.
 {mfguitrl.i}.
 {mfgrptrm.i} .
*/
	{mfreset.i}
	{mfgrptrm.i}
/* SS 090925.1 - E */

	 end.

/*GUI*/ end.
