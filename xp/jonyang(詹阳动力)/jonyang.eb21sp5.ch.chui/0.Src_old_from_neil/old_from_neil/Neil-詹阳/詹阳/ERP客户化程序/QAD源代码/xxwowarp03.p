/* xxwowarp03.p - ALLOCATIONS BY ORDER REPORT                             */
/* GUI CONVERTED from wowarp03.p (converter v1.69) Sat Mar 30 01:26:46 1996 */
/* wowarp01.p - ALLOCATIONS BY ORDER REPORT                             */
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
/* REVISION: 8.5    LAST MODIFIED: 11/05/99    BY: **JY012 *Infopower*/

/*GUI global preprocessor directive settings */
&GLOBAL-DEFINE PP_PGM_RP TRUE
&GLOBAL-DEFINE PP_ENV_GUI TRUE


/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

	 {mfdtitle.i "f "} /*G656*/ /*GUI moved to top.*/
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
	  SKIP(.4)  /*GUI*/
with frame a side-labels WIDTH 80 .

setFrameLabels(frame a:handle).

/*GUI preprocessor Frame A undefine */
&UNDEFINE PP_FRAME_NAME

repeat:
	
	    if nbr1 = hi_char then nbr1 = "".
/*IFP*/     if deliver1 = hi_char then deliver1 = "".
/*IFP*/     if lot1 = hi_char then lot1 = "".
/*IFP*/     if parn1 = hi_char then parn1 = "".
/*IFP*/     if rel_date1 = hi_date then rel_date1 = ?.
/*IFP*/     if due_date1 = hi_date then due_date1 = ?.
/*IFP*/     if rel_date = low_date then rel_date = ?.
/*IFP*/     if due_date = low_date then due_date = ?.
	    
			update nbr nbr1 parn parn1 part part1 deliver deliver1 lot lot1 rel_date rel_date1 due_date due_date1 with frame a.


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

	    if  nbr1 = "" then nbr1 = hi_char.
/*IFP*/     if  deliver1 = "" then deliver1 = hi_char.
/*IFP*/     if  lot1 = "" then lot1 = hi_char.
/*IFP*/     if  parn1 = "" then parn1 = hi_char.
/*IFP*/     if  rel_date1 = ? then rel_date1 = hi_date.
/*IFP*/     if  due_date1 = ? then due_date1 = hi_date.
/*IFP*/     if  rel_date = ? then rel_date = low_date.
/*IFP*/     if  due_date = ? then due_date = low_date.

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
	    each wod_det where 
		wod_domain = global_domain and /*---Add by davild 20090205.1*/
		wod_lot = wo_lot
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
                exclusive-lock use-index lad_det:
                    assign lad_user1 = wod_deliver.
                end.                    
            end.
/*Assign wod_deliver to Work center*/


	    /* FIND AND DISPLAY */
	    for each wo_mstr no-lock where 
		wo_domain = global_domain and /*---Add by davild 20090205.1*/
		(wo_nbr >= nbr and wo_nbr <= nbr1)
	    and (wo_lot >= lot and wo_lot <= lot1) 
/*IFP*/     and (wo_rel_date >= rel_date and wo_rel_date <= rel_date1)
/*IFP*/     and (wo_due_date >= due_date and wo_due_date <= due_date1)	    
	    and (wo_part >= parn and wo_part <= parn1),
	    each wod_det where 
		wod_domain = global_domain and /*---Add by davild 20090205.1*/
		wod_lot = wo_lot
	    and (wod_part >= part) and (wod_part <= part1 or part1 = "")
/*IFP*/     and (wod_deliver >= deliver and wod_deliver <= deliver1)
/*IFP*/	    no-lock break by wo_nbr by wod_lot by wod_deliver by wod_part  
/*IFP*	    no-lock break by wo_nbr by wod_lot by wod_part */ 
	    with frame b width 132 no-attr-space:

setFrameLabels(frame b:handle).
	
	       FORM /*GUI*/ 
		  wo_nbr         colon 15        wo_lot  colon 45
		  wo_rmks        colon 71
		  wo_part        colon 15        wo_so_job  colon 45
		  wo_qty_ord  colon 71
/*G656*/                           pt_um no-label
						 wo_ord_date  colon 104
		  desc1          at 17 no-label
		  wo_qty_comp    colon 71        wo_rel_date  colon 104
		  wo_status      colon 15        wo_vend  colon 45
		  wo_qty_rjct    colon 71        wo_due_date  colon 104
	       with STREAM-IO /*GUI*/  frame c side-labels width 132 no-attr-space.
setFrameLabels(frame c:handle).
/*IFP*	       if first-of(wod_lot) then do with frame c:*/
/*IFP*/	       if first-of(wod_deliver) then do with frame c:
		  desc1 = "".
		  find pt_mstr where 
		  pt_domain = global_domain and /*---Add by davild 20090205.1*/
		  pt_part = wo_part no-lock no-error.
		  if available pt_mstr then desc1 = pt_desc1.
		  if page-size - line-counter < 9 then page.

		  display wo_nbr wo_lot wo_qty_ord wo_ord_date wo_part desc1
/*G656*/          pt_um when available pt_mstr
		  wo_qty_comp wo_rel_date wo_so_job wo_qty_rjct wo_due_date
		  wo_vend wo_status wo_rmks with frame c side-labels STREAM-IO /*GUI*/ .
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
	       find pt_mstr where 
		   pt_domain = global_domain and /*---Add by davild 20090205.1*/
		   pt_part = wod_part no-lock no-error.
	       if available pt_mstr then desc1 = pt_desc1.

	       if page-size - line-counter < 2 and available pt_mstr
	       and pt_desc2 <> "" then page.

	       display space(8) wod_part desc1
/*G656*/       wod_op wod_deliver label "工作中心" 
	       wod_qty_req
/*G656*/       pt_um when available pt_mstr
	       all_pick wod_qty_iss open_ref
	       space(2) wod_iss_date WITH STREAM-IO width 255 /*GUI*/ .
/*G656*        space(2) wod_deliver. */

/*IFP*/        find first wc_mstr where 
wc_domain = global_domain and /*---Add by davild 20090205.1*/
wc_wkctr = wod_deliver no-lock no-error.
	       if (available pt_mstr and pt_desc2 <> "") or available wc_mstr then do with frame b:
		  down 1.
/*IFP		  display pt_desc2 @ desc1 WITH STREAM-IO /*GUI*/ .*/
/*IFP*/           if available pt_mstr then put pt_desc2 at 28.
/*IFP*/           if available wc_mstr then put wc_desc at 60 skip.
	       end.
	       
/*GUI*/ {mfguirex.i } /*Replace mfrpexit*/

	    end.

	    /* REPORT TRAILER  */
	    
		 {mfguirex.i }.
 {mfguitrl.i}.
 {mfgrptrm.i} .


	 end.
