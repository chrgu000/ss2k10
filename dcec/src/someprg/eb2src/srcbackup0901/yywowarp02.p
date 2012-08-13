/* xxunrp.p  - UNPLANNED RECEIPTS PRINT                               */
/* COPYRIGHT DCEC. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/* V1                 Developped: 08/23/01      BY: Kang Jian          */

/* GUI CONVERTED from wowarp01.p (converter v1.69) Sat Mar 30 01:26:46 1996 */
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


/*GUI global preprocessor directive settings */
&GLOBAL-DEFINE PP_PGM_RP TRUE
&GLOBAL-DEFINE PP_ENV_GUI TRUE


/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

	 {mfdtitle.i "f "} /*G656*/ /*GUI moved to top.*/
	 define variable vend like wo_vend.
	 define variable nbr like wod_nbr label "加工单号".
	 define variable nbr1 like wod_nbr label "加工单号".
	 define variable lot like wod_lot label "标".
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
	 define variable line as integer.
	 define variable pageno as integer.
	 define variable site like tr_site.  /* Modify by Zhang weihua  --2004-09-28 */
	 define variable nextp as integer initial 0.
	 define workfile workorder field woor_part like wod_part
	                         field woor_desc like pt_desc2
	                         field woor_qty like wod_qty_req
                                field woor_open_ref like wod_qty_req label "短缺量"
                                field woor_all_pick like wod_qty_req label "备料量/领料量"
                                field woor_op like wod_op .

/*cj*/ DEF VAR defaultloc LIKE pt_loc .

pageno = 1.	 

	 /* DISPLAY TITLE */
/*GUI moved mfdeclre/mfdtitle.*/

	 
/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
	    
 RECT-FRAME       AT ROW 1.4 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
 SKIP(.1)  /*GUI*/
nbr            colon 15
	    nbr1           label {t001.i} colon 49 skip
	    part           colon 15
	    part1          label {t001.i} colon 49 skip (1)
	    site           label "地点"  colon 15   /* Modify by Zhang weihua  --2004-09-28 */
	    lot            colon 15 skip
	  SKIP(.4)  /*GUI*/
with frame a side-labels WIDTH 80 /*GUI*/ NO-BOX THREE-D /*GUI*/.

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
/*cj*/ setFrameLabels(frame a:handle).


	 
/*GUI*/ {mfguirpa.i true  "printer" 132 }

/*GUI*/ procedure p-enable-ui:


	    if nbr1 = hi_char then nbr1 = "".
        pageno = 1.	 
	    
run p-action-fields (input "display").
run p-action-fields (input "enable").
end procedure. /* p-enable-ui, replacement of Data-Entry GUI*/

/*GUI*/ procedure p-report-quote:

	    bcdparm = "".
	    {mfquoter.i nbr    }
	    {mfquoter.i nbr1   }
	    {mfquoter.i part   }
	    {mfquoter.i part1  }
	    {mfquoter.i lot    }
           {mfquoter.i site  }  /* Modify by Zhang weihua  --2004-09-28 */
	    if  nbr1 = "" then nbr1 = hi_char.

	    /* SELECT PRINTER  */
	    
/*GUI*/ end procedure. /* p-report-quote */
/*GUI - Field Trigger Section */

/*GUI MFSELxxx removed*/
procedure p-report: 
   {gpprtrpa.i  "printer" 132}


    for each wo_mstr no-lock where (wo_nbr >= nbr and wo_nbr <= nbr1)
    and (wo_lot = lot or lot = "") :
          for  each wod_det where wod_lot = wo_lot
          and (wod_part >= part) and (wod_part <= part1 or part1 = "")
  	   no-lock break by wo_nbr by wod_lot by wod_part :	    

		  find pt_mstr where pt_part = wod_part no-lock no-error.
		  find first workorder where woor_part = wod_part no-lock no-error.
		  if available workorder then do:
		    woor_qty=woor_qty + wod_qty_req.		    
                  if wo_status = "C" then do:
                    woor_open_ref = woor_open_ref + 0.
                    woor_all_pick = woor_all_pick + 0.
                  end.
                  else do:
                    if wod_qty_req >= 0  then woor_open_ref = woor_open_ref + max(wod_qty_req - wod_qty_iss,0).
                    else woor_open_ref = woor_open_ref + min(wod_qty_req - wod_qty_iss,0).
                    woor_all_pick = woor_all_pick + wod_qty_all + wod_qty_pick.
                  end.
		  end.
		  else do:
                  create workorder.
	           woor_part=wod_part.
	           woor_desc=pt_desc2.
	           woor_qty=wod_qty_req.	           
                  if woor_qty >= 0  then woor_open_ref = max(wod_qty_req - wod_qty_iss,0).
                  else woor_open_ref = min(wod_qty_req - wod_qty_iss,0).
                  woor_all_pick = wod_qty_all + wod_qty_pick.
                  if wo_status = "C" then do:
                    woor_open_ref = 0.
                    woor_all_pick = 0.
                  end.
                end.
          end. /*for each wod_det*/
 FORM  
		  wo_nbr         colon 15        wo_lot  colon 38
		  wo_rmks        colon 61
		  wo_part        colon 15      /*  wo_so_job  colon 35 */
		  wo_qty_ord  colon 61
                wo_ord_date  colon 90
		  wo_qty_comp    colon 61        wo_rel_date  colon 90
		  wo_status      colon 15      /*  wo_vend  colon 35 */
		  wo_qty_rjct    colon 61        wo_due_date  colon 90
	       with   frame c side-labels width 132 no-attr-space.
 /*cj*/ setFrameLabels(frame c:handle).

/*显示发放物料清单*/
	   line = 1 .
	   for each workorder where woor_qty>=0  :

	      
	       if line = 1 then do :
		  desc1 = "".
		  find pt_mstr where pt_part = wo_part no-lock no-error.
		  if available pt_mstr then desc1 = pt_desc1.
                display  "  页号:" pageno format ">>>"  space(26) "DCEC加工单领料单物料发放清单" with width 132 no-labels frame bt01 STREAM-IO .
		  display wo_nbr wo_lot wo_qty_ord wo_ord_date wo_part      
		      wo_qty_comp wo_rel_date wo_qty_rjct wo_due_date
		      wo_status wo_rmks with frame c side-labels STREAM-IO .
                display "        零件号            零件名称                  库位        需求量      保管员         实际领料量 " with  width 132 frame bt1 STREAM-IO .
  	         display "        --------------------------------------------------------------------------------------------------------" with width 132 frame bt3 STREAM-IO .  	     
                line = line + 8.
	       end.
              find in_mstr where in_site = site and in_part = woor_part NO-LOCK NO-ERROR. /* Modify by Zhang weihua 2004-09-28 */
              /*cj*/ IF AVAILABLE IN_mstr THEN defaultloc = IN_user1 .
                    ELSE defaultloc = "" .
              display space(8) woor_part woor_desc /*cj*/ defaultloc woor_qty  space(5) in__qadc01 WHEN  AVAILABLE  IN_mstr WITH WIDTH 132 no-labels STREAM-IO .
	       down 1.
	       line = line + 1.
	       if page-size - line-counter < 2 then do:
                 display "        -------------------------------------------------------------------------------------------" AT 1 with width 132 frame ww STREAM-IO .  
                 display "        保管员：           库房经理：           发运人：                 接收人：" AT 1 with width 132 frame ww STREAM-IO .  	     
	          page.
	          pageno = pageno + 1.
	          line = 1.
	       end.       
        
	    end. /*for each workorder woor_qty>=0 */	

 /*judy 07/05/05*/   display "        ----------------------------------------------------------------------"  AT 1 with width 132 no-labels frame ww3 STREAM-IO .  
 /*judy 07/05/05*/     display "        保管员：           库房经理：           发运人：                 接收人："  AT 1 with width 132 no-labels frame ww3 STREAM-IO .  
 /*judy 07/05/05*/ /*   display "        ----------------------------------------------------------------------" with width 132 no-labels frame ww1.  */
 /*judy 07/05/05*/ /*    display "        保管员：           库房经理：           发运人：                 接收人：" with width 132 no-labels frame ww1.   */
           line = 1 .
	    page.
	    pageno = pageno + 1.
           for each workorder where woor_qty<0  :
	       if line = 1 then do :
		  desc1 = "".
                display  "  页号:" pageno format ">>>" space(24) "DCEC加工单领料单物料回收清单" with width 132 no-labels frame bt02 STREAM-IO .
		   display wo_nbr wo_lot wo_qty_ord wo_ord_date wo_part wo_qty_comp wo_rel_date  wo_qty_rjct wo_due_date
                 wo_status wo_rmks with frame c side-labels   .
  	         display "        零件号            零件名称                  库位        回收量      保管员          实际回收量" with width 132 no-labels frame bt2 STREAM-IO .
  	         display "        ---------------------------------------------------------------------------------------------------------" with width 132 no-labels frame bt4 STREAM-IO .  	     
  	         line = line + 8.
  	         nextp=nextp + 1.
	       end.

	       desc1 = "".
              find in_mstr where in_site = site and in_part = woor_part NO-LOCK NO-ERROR. /* Modify by Zhang weihua 2004-09-28 */
                /*cj*/ IF AVAILABLE IN_mstr THEN defaultloc = IN_user1 .
                ELSE defaultloc = "" .
              display space(8) woor_part woor_desc  /*cj*/ defaultloc woor_qty  space(5)  in__qadc01 WHEN AVAIL IN_mstr WITH WIDTH 132 STREAM-IO no-labels . /* Modify by Zhang weihua 2004-09-28 */
	       down 1.
  	       line = line + 1.
	       if page-size - line-counter < 2  then do:

 /*judy 07/05/05*/     display "        ----------------------------------------------------------------------"  at 1 with width 132 no-labels frame ww2 STREAM-IO .  
 /*judy 07/05/05*/     display "        保管员：           库房经理：           发运人：                 接收人："  at 1 with width 132 no-labels frame ww2 STREAM-IO .   
 /*judy 07/05/05*/ /*   display "        ----------------------------------------------------------------------" with width 132 no-labels frame ww2.  */
 /*judy 07/05/05*/ /*    display "        保管员：           库房经理：           发运人：                 接收人：" with width 132 no-labels frame ww2.  */ 
	          pageno = pageno + 1.
	          line =  1.
	       end.	       

	    end. /*for each workorder woor_qty<0 */
	    if nextp>=1 then do:

 /*judy 07/05/05*/   display "        ----------------------------------------------------------------------" AT 1  with width 132 no-labels frame ww3.  
 /*judy 07/05/05*/     display "        保管员：           库房经理：           发运人：                 接收人："  AT 1 with width 132 no-labels frame ww3. 
 /*judy 07/05/05*/ /*   display "        ----------------------------------------------------------------------" with width 132 no-labels frame ww3.  */
 /*judy 07/05/05*/ /*    display "        保管员：           库房经理：           发运人：                 接收人：" with width 132 no-labels frame ww3.  */
           end.	     
	 end. /*for each wo_mstr*/ 
for each workorder:
    delete workorder.
end.	 
/*        {mfphead.i}*/

 /*judy 07/05/05*/  {mfreset.i}
        {mfgrptrm.i} /*Report-to-Window*/ 

/*GUI*/ end procedure. /*p-report*/ 
/*GUI*/ {mfguirpb.i &flds=" nbr nbr1 part part1 site lot "} /*Drive the Report*/

 /*judy 07/05/05*/ /* {mfreset.i}*/
