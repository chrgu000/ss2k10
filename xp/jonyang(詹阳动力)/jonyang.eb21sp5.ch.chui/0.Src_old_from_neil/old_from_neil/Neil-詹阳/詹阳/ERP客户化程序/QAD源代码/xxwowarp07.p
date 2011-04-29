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
/* SS - 090818.1 By: Neil Gao */

/*GUI global preprocessor directive settings */
&GLOBAL-DEFINE PP_PGM_RP TRUE
&GLOBAL-DEFINE PP_ENV_GUI TRUE


/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT
/* SS 090818.1 - B */
/*
	 {mfdtitle.i "f "} /*G656*/ /*GUI moved to top.*/
*/
	 {mfdtitle.i "090818.1"}
/* SS 090818.1 - E */
	 define variable vend like wo_vend.
	 define variable nbr like wod_nbr.
	 define variable nbr1 like wod_nbr.
	 define variable lot like wod_lot.
/*F0KM*/ define variable part like wod_part   label "子零件".
	 define variable part1 like wod_part.
	 define variable part2 like wod_part.
	 define variable desc1 like pt_desc1.
	 define variable desc2 like pt_desc1.
	 define variable wodesc1 like pt_desc1.
	 define variable wodesc2 like pt_desc1.
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
/*IFP*/  define variable printline as character format "x(90)" extent 19.
/*IFP*/  define variable iss_date like wod_iss_date.
/*IFP*/  define variable iss_date1 like wod_iss_date.
         define variable bz as character format "xx".
         define variable wkctr like wr_wkctr.
         define variable qty_oh like in_qty_oh.
         define variable qty_oh1 like wr_qty_comp.
         define variable qty_req like wod_qty_req.
         define variable xz as character format "x" label "只打印库存不为零记录".
xz = "Y".
	 /* DISPLAY TITLE */
/*GUI moved mfdeclre/mfdtitle.*/

	 
/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
/* SS 090818.1 - B */
/*	    
 RECT-FRAME       AT ROW 1.4 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
 SKIP(.1)  /*GUI*/
*/
/* SS 090818.1 - E */
			nbr            colon 17
	    nbr1           label {t001.i} colon 49 skip
/*IFP*/     parn          colon 17 
/*IFP*/     parn1          label {t001.i} colon 49 skip
	    part           colon 17
	    part1          label {t001.i} colon 49 skip
/*IFP*/     deliver        colon 17
/*IFP*/     deliver1       label {t001.i} colon 49 skip
	    lot            colon 17
/*IFP*/     lot1           label {t001.i} colon 49 skip
/*IFP*/     rel_date       colon 17 
/*IFP*/     rel_date1      label {t001.i} colon 49 skip
/*IFP*/     due_date       colon 17
/*IFP*/     due_date1      label {t001.i} colon 49 skip
/*IFP*/     iss_date       colon 17
/*IFP*/     iss_date1      label {t001.i} colon 49 skip
            xz     colon 22
          
	  SKIP(.4)  /*GUI*/
/* SS 090818.1 - B */
/*
with frame a side-labels WIDTH 80 /*GUI*/ NO-BOX THREE-D /*GUI*/.
*/
with frame a side-labels WIDTH 80 attr-space.
/*
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
*/
setframelabels(frame a:handle).
/* SS 090818.1 - E */

/* SS 090818.1 - B */
/*
/*GUI*/ {mfguirpa.i true  "printer" 132 }

/*GUI repeat : */
/*GUI*/ procedure p-enable-ui:
*/
Mainloop:
repeat:
/* SS 090818.1 - E */

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


/* SS 090818.1 - B */
			update nbr nbr1 parn parn1 part part1 deliver deliver1 lot lot1 
           rel_date rel_date1 due_date due_date1 iss_date iss_date1 xz
       with frame a.

/* SS 090818.1 - B */
/*	    
run p-action-fields (input "display").
run p-action-fields (input "enable").
end procedure. /* p-enable-ui, replacement of Data-Entry GUI*/

/*GUI*/ procedure p-report-quote:
*/
/* SS 090818.1 - E */
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


/* SS 090818.1 - E */

	    /* SELECT PRINTER  */

/* SS 090818.1 - B */
/*	    
/*GUI*/ end procedure. /* p-report-quote */
/*GUI - Field Trigger Section */

/*GUI MFSELxxx removed*/
/*GUI*/ procedure p-report:
/*GUI*/   {gpprtrpa.i  "printer" 132}
/*GUI*/   mainloop: do on error undo, return error on endkey undo, return error:
*/
					{mfselprt.i "printer" 132}
/* SS 090818.1 - E */

/*IFP****   {mfphead.i} */
/*IFP*/     printline[1]  = " 工作中心:         描述:                     加工单:         标志:              ".
/*IFP*/     printline[2]  = "┌────┬──────────┬───┬─────────────┬────┐".
/*IFP*/     printline[3]  = "│子零件  │                    │描述1 │                         │生效日期│".
/*IFP*/     printline[4]  = "├────┴──┬───────┴───┼─────────----──┴────┤".
/*                            123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789*/
/*IFP*/     printline[16] = "│（代用）子零件│                      │描述                                │".
/*IFP*/     printline[17] = "├────┬──┴───────┬───┼─────────----──┬────┤".
/*IFP*/     printline[5]  = "│需求量  │                    │描述2 │                          │        │".
/*IFP*/     printline[6]  = "├────┼──┬--──┬--──┴─┬─┴┬─-─-─--┬------┬----┴-─-──┤".
/*IFP*/     printline[7]  = "│单位    │   │领料量│          │库存│          │实发量│              │".
/*IFP*/     printline[8]  = "├────┼──┴─-─-┴--──┬─┴─┬┴--------─┴─--─┴----┬--───┤".
/*IFP*/     printline[9]  = "│父零件  │                    │描述1 │                         │父件用量│".
/*IFP*/     printline[10] = "├────┼──────────┼───┼───────-─-----──┼────┤".
/*IFP*/     printline[11] = "│订货量  │                    │描述2 │                          │        │".
/*IFP*/     printline[12] = "├────┼──────┬───┼───┴──┬──┬------────┴────┤".
/*IFP*/     printline[13] = "│下达日  │            │到期日│            │备注│                        │".
/*IFP*/     printline[14] = "├────┴──────┴───┴────----┴──┴─----------------------┤".
/*IFP*/     printline[15] = "│                                                                            │".
/*IFP*/     printline[18] = "│  计划:___________  采购:___________   经领:___________   发料:__________   │".
/*IFP*/     printline[19] = "└──────────────────────────────────────┘".

	    /* FIND AND DISPLAY */
	    for each wo_mstr no-lock where (wo_nbr >= nbr and wo_nbr <= nbr1)
/* SS 090818.1 - B */
			and wo_domain = global_domain 
/* SS 090818.1 - E */
	    and (wo_lot >= lot and wo_lot <= lot1) 
/*IFP*/     and (wo_rel_date >= rel_date and wo_rel_date <= rel_date1)
/*IFP*/     and (wo_due_date >= due_date and wo_due_date <= due_date1)	    
	    and (wo_part >= parn and wo_part <= parn1),
	    each wod_det where wod_lot = wo_lot
/* SS 090818.1 - B */
			and wod_domain = global_domain
/* SS 090818.1 - E */
	    and (wod_part >= part) and (wod_part <= part1 or part1 = "")
/*IFP*/     and (wod_deliver >= deliver and wod_deliver <= deliver1)
/*IFP*/	/*    and (wod_qty_all + wod_qty_pick <> 0)*/
/*IFP*/     and (wod_iss_date >= iss_date and wod_iss_date <= iss_date1)
	    no-lock break by wo_nbr by wod_lot by wod_part
	    with frame b width 132 no-attr-space:
			find first wr_route where 
/* SS 090818.1 - B */
			wr_domain = global_domain and
/* SS 090818.1 - E */			
			wr_lot = wo_lot and substring(wr_wkctr,1,2) = "99"  no-lock no-error.
                  if available wr_route then do:

	     /*  if first-of(wod_lot) then do with frame c:*/
                  wkctr = wr_wkctr.
		  desc1 = "".
		  PART2 = "".
		  find pt_mstr where 
/* SS 090818.1 - B */
			pt_domain = global_domain and
/* SS 090818.1 - E */		  
		  pt_part = wo_part no-lock no-error.
		  if available pt_mstr then desc1 = pt_desc1.
		  if page-size - line-counter < 9 then page.
/*IFP*/           
                                   
        find first wc_mstr where 
/* SS 090818.1 - B */
				wc_domain = global_domain and
/* SS 090818.1 - E */                  
        wc_wkctr = wkctr  no-lock no-error.
/*          if available wc_mstr then substr(printline[1],7,8)  = substr(wc_wkctr + fill(" ",8),1,8). 
           if available wc_mstr then substr(printline[1],19,18) = substr(wc_desc + fill(" ",18),1,18). 
*/
     	  find first wr_route where 
/* SS 090818.1 - B */
				wr_domain = global_domain and
/* SS 090818.1 - E */     	  
     	  wr_lot = wo_lot no-lock no-error.
		  
		  if available wr_route and substring(wr_wkctr,1,2) <> "99" then do:
		     part2 = wo_part.
		     bz = "1". 
		     find first wc_mstr where 
/* SS 090818.1 - B */
					wc_domain = global_domain and
/* SS 090818.1 - E */		     
		     wc_wkctr = wkctr  no-lock no-error.
		     

		     end.
		  if available wr_route and substring(wr_wkctr,1,2) = "99" then do:
		      part2 = wod_part.
		      bz = "".
		      find first wc_mstr where 
/* SS 090818.1 - B */
  				wc_domain = global_domain and
/* SS 090818.1 - E */
		      wc_wkctr = wod_deliver  no-lock no-error.
	              find pt_mstr where 
/* SS 090818.1 - B */
								pt_domain = global_domain and
/* SS 090818.1 - E */	              
	              pt_part = WOD_PART no-lock no-error.
                      if available pt_mstr then desc1 = pt_desc1.
                      if available pt_mstr then desc2 = pt_desc2.
                      find pt_mstr where 
/* SS 090818.1 - B */
											pt_domain = global_domain and
/* SS 090818.1 - E */                      
                      pt_part = wo_part no-lock no-error.

                      end.
                   
                    if available wc_mstr then substr(printline[1],7,8)  = substr(wc_wkctr + fill(" ",8),1,8). 
/*IFP*/           if available wc_mstr then substr(printline[1],19,18) = substr(wc_desc + fill(" ",18),1,18). 


/*B357*/       if wod_qty_req >= 0
/*B357*/       then open_ref = max(wod_qty_req - wod_qty_iss,0).
/*B357*/       else open_ref = min(wod_qty_req - wod_qty_iss,0).

	       if bz = "" then do:
	        all_pick = wod_qty_all + wod_qty_pick.
	        find in_mstr where 
/* SS 090818.1 - B */
					in_domain = global_domain and
/* SS 090818.1 - E */	        
	        in_part = part2 and in_site = "10000" no-lock no-error.
	        if available in_mstr then qty_oh = in_qty_oh.
	        if not available in_mstr then qty_oh = 0.
	        end.
               if bz = "1" then do:
                  find first wr_route where 
/* SS 090818.1 - B */
									wr_domain = global_domain and 
/* SS 090818.1 - E */                  
                  wr_lot = wo_lot and substring(wr_wkctr,1,2) = "99"  no-lock no-error.
                  IF AVAILABLE WR_ROUTE THEN all_pick = wr_qty_ord - wr_qty_comp.
                  qty_oh1 = wr_qty_comp.
                  find prev wr_route 
/* SS 090818.1 - B */
									where wr_domain = global_domain
/* SS 090818.1 - E */                  
                  no-lock no-error.
                  IF AVAILABLE WR_ROUTE THEN qty_oh = wr_qty_comp - qty_oh1.
                  IF QTY_OH < 0 THEN QTY_OH = 0.
                  end.
 
/*B357*/       if wo_status = "C" then do:
/*B357*/          open_ref = 0.
/*B357*/          all_pick = 0.
/*B357*/       end.

	      
	      IF (PART2 <> "" and all_pick > 0) and ((first-of(wod_lot) and bz = "1") or bz = "" ) 
  and ((xz = "y" and qty_oh <> 0 ) or xz = "n") THEN DO:
  substr(printline[1],44,8)  = substr(wo_nbr + fill(" ",8),1,8). 
/*IFP*/           substr(printline[1],56,6)  = substr(wo_lot + fill(" ",6),1,6). 
/*IFP*/           substr(printline[9],8,18) = substr(string(wo_part,"x(18)") + fill(" ",18),1,18).
/*IFP*/           if available pt_mstr then substr(printline[9],34,24)  = substr(string(pt_desc1,"x(24)") + fill(" ",24),1,24).
/*IFP*/           if available pt_mstr then substr(printline[11],34,24) = substr(string(pt_desc2,"x(24)") + fill(" ",24),1,24).
/*IFP*/          if bz = "" then  substr(printline[11],61,8) = substr(string(wod_bom_qty,"->>>9.99") + fill(" ",8),1,8).
/*IFP*/           substr(printline[11],10,18) = substr(string(wo_qty_ord,"->>>,>>>,>>9.99<<<") + fill(" ",18),1,18).
                  substr(printline[13],8,8) = string(wo_rel_date,"99/99/99")  .
                  substr(printline[13],26,8) = string(wo_DUE_date,"99/99/99").
/*IFP*/           substr(printline[3],8,18) = substr(string(part2,"x(18)") + fill(" ",18),1,18).
/*IFP*/           if available pt_mstr then substr(printline[3],34,24) = substr(string(desc1,"x(24)") + fill(" ",24),1,24).
/*IFP*/           if available pt_mstr then substr(printline[5],34,24) = substr(string(desc2,"x(24)") + fill(" ",24),1,24).
/*IFP*/           if wod_iss_date <> ? then substr(printline[5],61,8) = string(wod_iss_date,"99/99/99").
/*IFP*/           if available pt_mstr then substr(printline[7],9,2)  = substr(pt_um + fill(" ",2),1,2).
/*IFP*/           substr(printline[7],18,9) = substr(string(all_pick,"->,>>9.99<") + fill(" ",9),1,9).
                  substr(printline[7],31,10) = substr(string(qty_oh,"->>,>>9.99<") + fill(" ",10),1,10).

/*IFP*/        if bz = "" then substr(printline[5],10,18) = substr(string(wod_qty_req,"->>>,>>>,>>9.99<<<") + fill(" ",18),1,18).
               if bz = "1" then substr(printline[5],10,18) = substr(string(wo_qty_ord,"->>>,>>>,>>9.99<<<") + fill(" ",18),1,18).
 

/*IFP*/       do with frame printline width 132 STREAM-IO no-labels no-box down:
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

/*IFP*/        end.
               down 2.
  	END.             
  
/* SS 090818.1 - B */
/*  
/*GUI*/ {mfguirex.i } /*Replace mfrpexit*/
*/
/* SS 090818.1 - E */
	    end.
	end.
	    /* REPORT TRAILER  */
/* SS 090818.1 - B */
/*
/*GUI*/ {mfreset.i} /*Replace mfrtrail*/

/*GUI*/ {mfgrptrm.i} /*Report-to-Window*/
*/
 					{mfreset.i}
					{mfgrptrm.i}
/* SS 090818.1 - E */

end.
/* SS 090818.1 - B */
/*
/*GUI*/ end procedure. /*p-report*/
/*GUI*/ {mfguirpb.i &flds=" nbr nbr1 parn parn1 part part1 deliver deliver1 lot lot1 
           rel_date rel_date1 due_date due_date1 iss_date iss_date1 xz"} /*Drive the Report*/
*/
/* SS 090818.1 - E */