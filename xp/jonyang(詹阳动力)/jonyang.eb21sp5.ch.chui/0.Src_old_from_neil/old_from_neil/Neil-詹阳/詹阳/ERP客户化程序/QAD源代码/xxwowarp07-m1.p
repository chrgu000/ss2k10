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
/* SS - 090924.1 By: Neil Gao */

/*GUI global preprocessor directive settings */
&GLOBAL-DEFINE PP_PGM_RP TRUE
&GLOBAL-DEFINE PP_ENV_GUI TRUE


/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

	 {mfdtitle.i "090924.1"} /*G656*/ /*GUI moved to top.*/

	 define variable vend like wo_vend.
	 define variable nbr like wod_nbr.
	 define variable nbr1 like wod_nbr.
	 define variable lot like wod_lot.
/*F0KM   define variable part like wod_part.  */
/*F0KM*/ define variable part like wod_part   label "子零件".
	 define variable part1 like wod_part.
	 define variable desc1 like pt_desc1.
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
with frame a side-labels WIDTH 80.

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
				
				
				update nbr nbr1 parn parn1 part part1 lot lot1 deliver deliver1
								rel_date rel_date1 due_date due_date1 iss_date iss_date1 
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

					{mfselbpr.i "printer" 132}
/*GUI*/   mainloop: do on error undo, return error on endkey undo, return error:

/*IFP****   {mfphead.i} */
/*IFP*/     printline[1]  = " 工作中心:         描述:                     加工单:         标志:              ".
/*IFP*/     printline[2]  = "┌────┬──────────┬───┬─────────────┬────┐".
/*IFP*/     printline[3]  = "│子零件  │                    │描述1 │                          │生效日期│".
/*IFP*/     printline[4]  = "├────┴──┬───────┴───┼─────────----──┴────┤".
/*                            123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789*/
/*IFP*/     printline[16] = "│（代用）子零件│                      │描述                                │".
/*IFP*/     printline[17] = "├────┬──┴───────┬───┼─────────----──┬────┤".
/*IFP*/     printline[5]  = "│需求量  │                    │描述2 │                          │        │".
/*IFP*/     printline[6]  = "├────┼──┬────┬──┴───┴──┬─-─┬─-----------┴────┤".
/*IFP*/     printline[7]  = "│单位    │   │领料量  │                  │备注1│                       │".
/*IFP*/     printline[8]  = "├────┼──┴─┬──┴-┬──--─┬-──┴┬-─┴---┬-------┬────-┤".
/*IFP*/     printline[9]  = "│1次实发 │        │2次实发│        │3次实发│        │4次实发│         │".
/*IFP*/     printline[10] = "├────┼──--─┼──-─┼─--─--┼──---┼───--┼-----─┼--───-┤".
/*IFP*/     printline[11] = "│日   期 │        │日   期│        │日   期│        │日   期│         │".
/*IFP*/     printline[12] = "├────┼─----─┴─-──┴-┬──-┼---──┴--───┴-------┼--───-┤".
/*IFP*/     printline[13] = "│父零件  │                    │描述1│                          ".
/*IFP*/     printline[14] = "├────┼──────────┼──-┼───────-─-----──┼─-───┤".
/*IFP*/     printline[15] = "│订货量  │                    │描述2│                          │         │".
/*IFP*/     printline[18] = "├────┼──────┬───┼──-┴─-─┬──-┬─------──┴──-──┤".
/*IFP*/     printline[19] = "│下达日  │            │到期日│            │备注2│                       │".
/*IFP*/     printline[20] = "├────┴──────┴───┴────----┴─---┴─---------------------┤".
/*IFP*/     printline[21] = "│ :                                                                          │".
/*IFP*/     printline[22] = "│ 1次经领:_________ 2次经领:_________ 3次经领:_________ 4次经领:__________   │".
/*IFP*/     printline[23] = "│ :                                                                          │".
/*IFP*/     printline[24] = "│ 计   划:_________ 检   查:_________ 发   料:__________                     │".
/*IFP*/     printline[25] = "└──────────────────────────────────────┘".

	    /* FIND AND DISPLAY */
	    for each wo_mstr no-lock where (wo_nbr >= nbr and wo_nbr <= nbr1)
/*SS 20090207 - B*/
			and wo_domain = global_domain
/*SS 20090207 - E*/
	    and (wo_lot >= lot and wo_lot <= lot1) 
/*IFP*/     and (wo_rel_date >= rel_date and wo_rel_date <= rel_date1)
/*IFP*/     and (wo_due_date >= due_date and wo_due_date <= due_date1)	    
	    and (wo_part >= parn and wo_part <= parn1),
	    each wod_det where wod_lot = wo_lot
/*SS 20090207 - B*/
			and wod_domain = global_domain
/*SS 20090207 - E*/
	    and (wod_part >= part) and (wod_part <= part1 or part1 = "")
	    and wod_part matches "*M"
/*IFP*/     and (wod_deliver >= deliver and wod_deliver <= deliver1)
/*IFP*/	    and (wod_qty_all + wod_qty_pick <> 0)
/*IFP*/     and (wod_iss_date >= iss_date and wod_iss_date <= iss_date1)
	    no-lock break by wo_nbr by wod_lot by wod_part
	    with frame b width 132 no-attr-space:

	       if first-of(wod_lot) then do with frame c:
		  desc1 = "".
		  find pt_mstr where pt_part = wo_part 
/*SS 20090207 - B*/
				and pt_domain = global_domain
/*SS 20090207 - E*/		  
		  no-lock no-error.
		  if available pt_mstr then desc1 = pt_desc1.
		  if page-size - line-counter < 9 then page.
/*IFP*/           find first wc_mstr where wc_wkctr = wod_deliver 
/*SS 20090207 - B*/
									and wc_domain = global_domain
/*SS 20090207 - E*/
									no-lock no-error.
		  
/*IFP*/           if available wc_mstr then substr(printline[1],7,8)  = substr(wc_wkctr + fill(" ",8),1,8). 
/*IFP*/           if available wc_mstr then substr(printline[1],19,18) = substr(wc_desc + fill(" ",18),1,18). 
/*IFP*/           substr(printline[1],44,8)  = substr(wo_nbr + fill(" ",8),1,8). 
/*IFP*/           substr(printline[1],56,8)  = substr(wo_lot,1,8 ). 
/*IFP*/           substr(printline[13],8,18) = substr(string(wo_part,"x(18)") + fill(" ",18),1,18).
/*IFP*/           if available pt_mstr then substr(printline[13],33,20)  = substr(string(pt_desc1,"x(20)") + fill(" ",20),1,20).
                  substr(printline[13],57,13) = "│ 父件用量│".
/*IFP*/           if available pt_mstr then substr(printline[15],33,24) = substr(string(pt_desc2,"x(24)") + fill(" ",24),1,24).
/*IFP*/           substr(printline[15],61,8) = substr(string(wod_bom_qty,"->>>9.99") + fill(" ",8),1,8).
/*IFP*/           substr(printline[15],10,18) = substr(string(wo_qty_ord,"->>>,>>>,>>9.99<<<") + fill(" ",18),1,18).
                  substr(printline[19],8,8) = string(wo_rel_date,"99/99/99")  .
                  substr(printline[19],26,8) = string(wo_DUE_date,"99/99/99").

	       end.

/*B357*        open_ref = wod_qty_req - wod_qty_iss. */
/*B357*/       if wod_qty_req >= 0
/*B357*/       then open_ref = max(wod_qty_req - wod_qty_iss,0).
/*B357*/       else open_ref = min(wod_qty_req - wod_qty_iss,0).

	       all_pick = wod_qty_all + wod_qty_pick.

/*B357*/       if wo_status = "C" then do:
/*B357*/          open_ref = 0.
/*B357*/          all_pick = 0.
/*B357*/       end.

	       desc1 = "".
	       find pt_mstr where pt_part = wod_part 
/*SS 20090207 - B*/
						and pt_domain = global_domain
/*SS 20090207 - E*/	       
	       no-lock no-error.
	       if available pt_mstr then desc1 = pt_desc1.

/*IFP*/           substr(printline[3],8,18) = substr(string(wod_part,"x(18)") + fill(" ",18),1,18).
/*IFP*/           if available pt_mstr then substr(printline[3],34,24) = substr(string(pt_desc1,"x(24)") + fill(" ",24),1,24).
/*IFP*/           if available pt_mstr then substr(printline[5],34,24) = substr(string(pt_desc2,"x(24)") + fill(" ",24),1,24).
/*IFP*/           if wod_iss_date <> ? then substr(printline[5],61,8) = string(wod_iss_date,"99/99/99").
/*IFP*/           substr(printline[7],9,2)  = substr(pt_um + fill(" ",2),1,2).
/*IFP*/           substr(printline[7],20,18) = substr(string(all_pick,"->>>,>>>,>>9.99<<<<") + fill(" ",18),1,18).
/*IFP*/           substr(printline[5],10,18) = substr(string(wod_qty_req,"->>>,>>>,>>9.99<<<") + fill(" ",18),1,18).
         if  substring(wc_wkctr,1,2) = "23" then
            find first ro_det where ro_routing = wo_part and substring(ro_wkctr,1,2) <> "23" 
/*SS 20090207 - B*/
							and ro_domain = global_domain
/*SS 20090207 - E*/            
            no-lock no-error.
/*IFP*/        do with frame printline width 132 STREAM-IO no-labels no-box down:
                    if page-size - line-counter < 19 then page.
                    display "送 料 单"  at 37 skip(1).
                   display printline[1] at 1.
                    display printline[2] at 1.
                    display printline[3] at 1.
                    display printline[4] at 1.
                    display printline[16] at 1.
                    display printline[17] at 1.
                    display printline[5] at 1.
                    display printline[6] at 1.
                    display printline[7] at 1.
                    display printline[8] at 1.
                    display printline[9] at 1.
                    display printline[10] at 1.
                    display printline[11] at 1.
                    display printline[12] at 1.
                    display printline[13] at 1.
                    display printline[14] at 1.
                    display printline[15] at 1.
                    display printline[18] at 1.
                    display printline[19] at 1.
                    display printline[20] at 1.
                    display printline[21] at 1.
                    display printline[22] at 1.
                    display printline[23] at 1.
                    display printline[24] at 1.
                    display printline[25] at 1.



/*IFP*/        end.
               down 2.
               
	    end.

	    /* REPORT TRAILER  */

/* SS 090924.1 - B */
/*	    
  {mfguirex.i }.
 {mfguitrl.i}.
 {mfgrptrm.i} .
*/
		{mfreset.i}
		{mfgrptrm.i}
/* SS 090924.1 - E */

	 end.

/*GUI*/ end.
