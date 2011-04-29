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
/* REVISION: 8.5    LAST MODIFIED: 02/25/02    BY: LW *JHC*/
/*By: Neil Gao 09/02/07 ECO: *SS 20090207* */

/*GUI global preprocessor directive settings */
&GLOBAL-DEFINE PP_PGM_RP TRUE
&GLOBAL-DEFINE PP_ENV_GUI TRUE


/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

	 {mfdtitle.i "f "} /*G656*/ /*GUI moved to top.*/
	 define variable nbr like wod_nbr.
	 define variable nbr1 like wod_nbr.
	 define variable nbr3 like wod_nbr.
	 define variable nbr4 like so_nbr.
	 define variable nbr5 like so_nbr.
	 define variable lot like wod_lot.
/*IFP*/	 define variable lot1 like wod_lot.
/*IFP*/	 define variable lot3 like wod_lot.
/*F0KM*/ define variable part like wod_part   label "子零件".
	 define variable part1 like wod_part.
	 define variable part2 like wod_part.
         define variable part3 like wod_part.
	 define variable desc1 as character format "X(48)"  label "描述".
	 define variable desc2 as character format "X(48)".
	 define variable open_ref like wod_qty_req .
	 define variable open_ref1 like wod_qty_req .
	 define variable all_pick like wod_qty_req label "备料量/领料量".
	 define variable s_num as character extent 4.
	 define variable d_num as decimal decimals 9 extent 4.
	 define variable i as integer.
	 define variable j as integer.
/*IFP*/  define variable deliver like wod_deliver label "父件工作中心".
/*IFP*/  define variable deliver1 like wod_deliver .
/*IFP*/  define variable deliver2 like wod_deliver label "子件工作中心".
/*IFP*/  define variable deliver3 like wod_deliver .
/*IFP*/  define variable WKCTR like RO_WKCTR label "父件首工序".
/*IFP*/  define variable WKCTR1 AS CHARACTER FORMAT "xxxxxx" .

/*IFP*/  define variable parn  like wo_part label "父零件".
/*IFP*/  define variable parn1 like wo_part.
/*IFP*/  define variable rel_date like wo_rel_date.
/*IFP*/  define variable rel_date1 like wo_rel_date.
/*IFP*/  define variable rel_date3 like wo_rel_date.
/*IFP*/  define variable due_date like wo_due_date.
/*IFP*/  define variable due_date1 like wo_due_date.
/*IFP*/  define variable due_date3 like wo_due_date.
/*IFP*/  define variable xz like wo_status.
/*IFP*/  define variable PTPM like PT_PM_CODE.
/*IFP*/  define variable BUYER like PT_BUYER.
/*IFP*/  define variable BUYER1 like PT_BUYER.
/*lw*/  define variable qty_oh  like in_qty_oh LABEL "库存".
/*lw*/  define variable qty_oh1  like in_qty_oh label "累计缺件数".
        define variable qty_oh2 like in_qty_oh.
        define variable USER1 like wod_USER1.
        define variable bz AS CHARACTER FORMAT "xxxxxxxxxxxxxxxxxxxx" .
        define variable kw AS CHARACTER FORMAT "xxxxxxxxxx" .
        define variable bz1 AS CHARACTER FORMAT "X(1)". 
       /* define variable bz2 AS CHARACTER FORMAT "X(1)" label "替代". */
        define variable OP AS CHARACTER FORMAT "X(40)" LABEL "工艺流程".
         define variable OP1 AS  CHARACTER FORMAT "xxxx".
         define variable OP2 AS  CHARACTER FORMAT "xxxxxx".
         define variable OP3 AS  CHARACTER FORMAT "xxxxxx".
         define variable OP4 AS  CHARACTER FORMAT "xxxxxx".
         define variable OP5 AS  CHARACTER FORMAT "xxxxxx".
         define variable OP6 AS  CHARACTER FORMAT "xxxxxx".
         define variable OP7 AS  CHARACTER FORMAT "xxxxxx".
         define variable OP8 AS  CHARACTER FORMAT "xxxxxx".
         define variable OP9 AS  CHARACTER FORMAT "xxxxxx".
         define variable OP10 AS  CHARACTER FORMAT "xxxxxx".
         define variable OP11 AS  CHARACTER FORMAT "xxxxxx".
         define variable OP12 AS  CHARACTER FORMAT "xxxxxx".
       define variable getall AS  CHARACTER FORMAT "x" label "显示到期日内的资源".
       define variable getall1 AS  CHARACTER FORMAT "x" label "计算客户订单".
       define buffer womstr for wo_mstr.
getall = "Y".
getall1 = "n".
            


	 /* DISPLAY TITLE */
/*GUI moved mfdeclre/mfdtitle.*/

	 
/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
            nbr            colon 15
            nbr1          label {t001.i} colon 49 skip
	    lot            colon 15
            lot1           label {t001.i} colon 49 
            nbr4            colon 15
            nbr5          label {t001.i} colon 49 skip
/*IFP*/     parn          colon 15 
/*IFP*/     parn1          label {t001.i} colon 49 skip
	    part           colon 15
	    part1          label {t001.i} colon 49 skip
/*IFP*/     deliver        colon 15
/*IFP*/     deliver1       label {t001.i} colon 49 skip
/*IFP*/     deliver2        colon 15
/*IFP*/     deliver3       label {t001.i} colon 49 skip
/*IFP*/     rel_date       colon 15 
/*IFP*/     rel_date1      label {t001.i} colon 49 skip
/*IFP*/     due_date       colon 15
/*IFP*/     due_date1      label {t001.i} colon 49 skip
/*IFP*/     buyer          colon 15
/*IFP*/     buyer1         label {t001.i} colon 49 skip
            xz       colon 15 SKIP
            PTPM       colon 15 SKIP
            getall1 colon 15 skip
            getall colon 15 skip 
	  SKIP(.4)  /*GUI*/
with frame a side-labels WIDTH 80 /*GUI*/.

setFrameLabels(frame a:handle).

/*GUI preprocessor Frame A undefine */
&UNDEFINE PP_FRAME_NAME

repeat : 
	
/*IFP*/     if deliver1 = hi_char then deliver1 = "".
/*IFP*/     if deliver3 = hi_char then deliver3 = "".
/*IFP*/     if NBR1 = hi_char then nbr1 = "".
/*IFP*/     if NBR5 = hi_char then nbr5 = "".
/*IFP*/     if lot1 = hi_char then lot1 = "".
            if buyer1 = hi_char then buyer1 = "".
/*IFP*/     if parn1 = hi_char then parn1 = "".
/*IFP*/     if part1 = hi_char then part1 = "".
/*IFP*/     if rel_date1 = hi_date then rel_date1 = ?.
/*IFP*/     if due_date1 = hi_date then due_date1 = ?.
/*IFP*/     if rel_date = low_date then rel_date = ?.
/*IFP*/     if due_date = low_date then due_date = ?.
			
			update nbr nbr1     
	    lot            
            lot1     
            nbr4     
            nbr5     
/*IFP*/     parn     
/*IFP*/     parn1    
	    part           
	    part1          
/*IFP*/     deliver  
/*IFP*/     deliver1 
/*IFP*/     deliver2 
/*IFP*/     deliver3 
/*IFP*/     rel_date 
/*IFP*/     rel_date1
/*IFP*/     due_date 
/*IFP*/     due_date1
/*IFP*/     buyer   
/*IFP*/     buyer1  
            xz      
            PTPM    
            getall1 
            getall with frame a.
			
	    bcdparm = "".
	    {mfquoter.i nbr    }
	    {mfquoter.i nbr1   }
	    {mfquoter.i nbr4    }
	    {mfquoter.i nbr5   }
/*IFP*/	    {mfquoter.i parn   }
/*IFP*/	    {mfquoter.i parn1  }
	    {mfquoter.i part   }
	    {mfquoter.i part1  }
	    {mfquoter.i lot    }
/*IFP*/     {mfquoter.i lot1   }
/*IFP*/     {mfquoter.i deliver }
/*IFP*/     {mfquoter.i deliver1 }
/*IFP*/     {mfquoter.i deliver2 }
/*IFP*/     {mfquoter.i deliver3 }
/*IFP*/     {mfquoter.i rel_date}
/*IFP*/     {mfquoter.i rel_date1}
/*IFP*/     {mfquoter.i due_date}
/*IFP*/     {mfquoter.i due_date1}
/*IFP*/     {mfquoter.i PTPM     }
/*IFP*/     {mfquoter.i BUYER    }


/*IFP*/     if  deliver1 = "" then deliver1 = hi_char.
/*IFP*/     if  deliver3 = "" then deliver3 = hi_char.
/*IFP*/     if  nbr1 = "" then nbr1 = hi_char.
/*IFP*/     if  nbr5 = "" then nbr5 = hi_char.
/*IFP*/     if  lot1 = "" then lot1 = hi_char.
/*IFP*/     if  parn1 = "" then parn1 = hi_char.
/*IFP*/     if  part1 = "" then part1 = hi_char.
/*IFP*/     if  rel_date1 = ? then rel_date1 = hi_date.
/*IFP*/     if  due_date1 = ? then due_date1 = hi_date.
/*IFP*/     if  rel_date = ? then rel_date = low_date.
/*IFP*/     if  due_date = ? then due_date = low_date.
            if buyer1 = "" then buyer1 = hi_char.

	    /* SELECT PRINTER  */
	    
			{mfselbpr.i "printer" 132}
/*GUI*/   mainloop: do on error undo, return error on endkey undo, return error:
	    {mfphead.i}
  if getall1 = "y" then
   for each sod_det where sod_domain = global_domain and sod_user1 = "*":
   assign sod_user1 = "".
   end.
	    /* FIND AND DISPLAY */
	    for each wo_mstr no-lock where wo_domain = global_domain and (wo_rel_date >= rel_date and wo_rel_date <= rel_date1)
            and (wo_due_date >= due_date and wo_due_date <= due_date1)	
            and (wo_nbr >= nbr and wo_nbr <= nbr1)
            and (wo_lot >= lot and wo_lot <= lot1)     
	    and (wo_part >= parn and wo_part <= parn1)
	    and (wo_status = xz OR (WO_STATUS <> "C" AND xz = "")),
	    each wod_det where wod_domain = global_domain and  wod_lot = wo_lot
	    and (wod_part >= part and wod_part <= part1)
/*	    AND ((SUBSTRING(WOD_PART,1,3) < "GYA") or (SUBSTRING(WOD_PART,1,3) > "GYZ"))*/
            AND WOD_QTY_ISS < WOD_QTY_REQ
	    break by wod_part by wo_due_date by wo_rel_date by wo_nbr by wod_lot  by wod_deliver  
	    with frame b width 620 no-attr-space:
	    	setFrameLabels(frame b:handle).
	    if first-of(wod_part) then do :
                  FIND IN_MSTR WHERE in_domain = global_domain and IN_PART = wod_PART AND IN_SITE = "10000"  no-lock NO-ERROR.
                  if available in_mstr and in_qty_oh > 0 then qty_oh = max(in_qty_avail - in_qty_all,0).
                  if not available in_mstr or in_qty_oh = 0 then qty_oh = 0.
               
                  end. /* enf for first-of(wod_part)*/ 
	     OP1 = "".
             OP2 = "".
             OP3 = "".
             OP4 = "".
             OP5 = "".
             OP6 = "".
             OP7 = "".
             OP8 = "".
             OP9 = "". 
             OP10 = "".
             OP11 = "". 
             wkctr = "".
	     wkctr1 = "".
	  /*   bz2 = "".*/
	     qty_oh1 = 0.
   	    if wo_status = "r" then 
	       find first wr_route where wr_domain = global_domain and wr_lot = wo_lot no-lock no-error.
	       if available wr_route then wkctr = wr_wkctr.
	       if not available wr_route or wo_status <> "r" then
	       find first ro_det where ro_domain = global_domain and ro_routing = wo_part no-lock no-error.
	       if available ro_Det then wkctr = ro_wkctr.
	       
	       if wkctr >= deliver and wkctr <= deliver1 then DO:
	       if page-size - line-counter < 9 then page.
	    find pt_mstr where pt_domain = global_domain and pt_part = wo_part no-lock no-error.
	    if available pt_mstr then desc2 = trim(pt_desc1) + trim(pt_desc2). 
           find pt_mstr where pt_domain = global_domain and  pt_part = wod_part 
	       and (pt_buyer >= buyer and pt_buyer <= buyer1) 
	       and ((pt_pm_code = ptpm and ptpm <> "") or ptpm = "") no-lock no-error.
	   /*    if available pt_mstr and pt_phantom = yes then do:
	          find ps_mstr where ps_par = pt_part no-lock no-error.
	             if available ps_mstr then 
	             find pt_mstr where pt_part = ps_comp no-lock no-error.
	             bz2 = "Y".
	             end.*/
	          if available pt_mstr then 
	          desc1 = trim(pt_desc1) + trim(pt_desc2).

	       
                  
/*B357*/       if wod_qty_req >= 0
/*B357*/       then open_ref = max(wod_qty_req - wod_qty_iss - wod_qty_pick,0).
/*B357*/       else open_ref = min(wod_qty_req - wod_qty_iss - wod_qty_pick,0).
	       all_pick = wod_qty_all + wod_qty_pick.
	      
	      if available pt_mstr then  part3 = pt_part.
	       find last ro_det where ro_domain = global_domain and ro_routing = pt_part no-lock no-error.
	       if available pt_mstr and (((available ro_det and substring(ro_wkctr,5,2) <> "97") AND PT_PM_CODE = "M") 
	          or pt_pm_code = "P") then do:
	          if available ro_det then wkctr1 = ro_wkctr.
	       find first ro_det where ro_domain = global_domain and ro_routing = pt_part 
	       and ro_wkctr >= deliver2 and ro_wkctr <= deliver3 no-lock no-error.
	       if (pt_pm_code = "m" and available ro_det)
                  and (  deliver2 <> "" or deliver3 <> "")
	          or (( deliver2 = "" or deliver3 = "" )
	          and ((pt_pm_code  = "p" )
	          or (pt_pm_code = "m" and available ro_det)))
	           

	            then do:
	          rel_date3 = wo_rel_date.
	          due_date3 = wo_due_date.
	          nbr3 = wo_nbr.
	          lot3 = wo_lot.
                	                
	
              
                  
                if  pt_pm_code = "M" and available ro_det then do:
       
        
              FIND FIRST RO_DET WHERE ro_domain = global_domain and  ((RO_ROUTING = WOd_PART) AND (RO_WKCTR MATCHES "*95" OR RO_WKCTR MATCHES "*96" OR RO_WKCTR MATCHES "*99" OR RO_WKCTR MATCHES "*98" OR RO_WKCTR MATCHES "*97"))
                 no-lock no-error.
           IF SUBSTRING(RO_WKCTR,1,3) = "231" THEN OP = "备料".
           IF SUBSTRING(RO_WKCTR,1,3) = "232" or SUBSTRING(RO_WKCTR,1,3) = "233" THEN OP = "计划".
           IF SUBSTRING(RO_WKCTR,1,2) = "01" THEN OP = "铸铁".
           IF SUBSTRING(RO_WKCTR,1,2) = "02" THEN OP = "铸钢".
           IF SUBSTRING(RO_WKCTR,1,2) = "03" THEN OP = "锻造".
           IF SUBSTRING(RO_WKCTR,1,2) = "04" THEN OP = "结构".
           IF SUBSTRING(RO_WKCTR,1,2) = "05" THEN OP = "传动".
           IF SUBSTRING(RO_WKCTR,1,2) = "06" THEN OP = "液压".
           IF SUBSTRING(RO_WKCTR,1,2) = "07" THEN OP = "桥箱".
           IF SUBSTRING(RO_WKCTR,1,3) = "082" THEN OP = "热电".
           IF SUBSTRING(RO_WKCTR,1,3) = "081" THEN OP = "电镀".
           IF SUBSTRING(RO_WKCTR,1,3) = "104" THEN OP = "装配油漆".
           IF SUBSTRING(RO_WKCTR,1,2) = "10" AND SUBSTRING(RO_WKCTR,1,3) <> "104" THEN OP = "装配".
           IF SUBSTRING(RO_WKCTR,1,2) = "12" THEN OP = "工具".
           IF SUBSTRING(RO_WKCTR,1,2) = "13" THEN OP = "机修动力".
           IF SUBSTRING(RO_WKCTR,1,2) = "99" THEN OP = "外协". 

                 
                 DO WHILE  available RO_DET :
              FIND NEXT RO_DET WHERE ro_domain = global_domain and ((RO_ROUTING = WOd_PART) AND (RO_WKCTR MATCHES "*95" OR RO_WKCTR MATCHES "*96" OR RO_WKCTR MATCHES "*99" OR RO_WKCTR MATCHES "*98" OR RO_WKCTR MATCHES "*97"))
                 no-lock no-error.
            IF available RO_DET then do:
           IF SUBSTRING(RO_WKCTR,1,3) = "231" THEN OP11 = "备料".
           IF SUBSTRING(ro_WKCTR,1,3) = "232" or SUBSTRING(ro_WKCTR,1,3) = "233" THEN OP11 = "计划".
           IF SUBSTRING(ro_WKCTR,1,2) = "01" THEN OP11 = "铸铁".
           IF SUBSTRING(ro_WKCTR,1,2) = "02" THEN OP11 = "铸钢".
           IF SUBSTRING(ro_WKCTR,1,2) = "03" THEN OP11 = "锻造".
           IF SUBSTRING(ro_WKCTR,1,2) = "04" THEN OP11 = "结构".
           IF SUBSTRING(ro_WKCTR,1,2) = "05" THEN OP11 = "传动".
           IF SUBSTRING(ro_WKCTR,1,2) = "06" THEN OP11 = "液压".
           IF SUBSTRING(ro_WKCTR,1,2) = "07" THEN OP11 = "桥箱".
           IF SUBSTRING(ro_WKCTR,1,3) = "082" THEN OP11 = "热电".
           IF SUBSTRING(ro_WKCTR,1,3) = "081" THEN OP11 = "电镀".
           IF SUBSTRING(ro_WKCTR,1,3) = "104" THEN OP11 = "装配油漆".
           IF SUBSTRING(ro_WKCTR,1,2) = "10" AND SUBSTRING(ro_WKCTR,1,3) <> "104" THEN OP11 = "装配".
           IF SUBSTRING(ro_WKCTR,1,2) = "12" THEN OP11 = "工具".
           IF SUBSTRING(ro_WKCTR,1,2) = "13" THEN OP11 = "机修动力".
           IF SUBSTRING(ro_WKCTR,1,2) = "99" THEN OP11 = "外协". 
                  
                 op = op + "→" + op11.
                 end.
                 end.
                 
            
             END. 
              if qty_oh <= 0 then  qty_oh = open_ref * -1.
              if qty_oh > 0 then qty_oh = qty_oh - open_ref.
/*               qty_oh1 = decimal(in_user1) * -1.*/
              /*if decimal(in_user1) < 0  then  */
             OPEN_REF1 = (WOD_QTY_REQ - WOD_QTY_ISS).
             if qty_oh < 0 then accumulate qty_oh (total by wod_part) .
         
    if qty_oh < 0 then
               display 
               WO_PART LABEL "父零件"
            /*   desc2 label "父件描述"*/
               wkctr label "首工序"
	       rel_date3
	       due_date3
	       nbr3 
	       lot3 
	       WO_STATUS
	       pt_part 
	       desc1  
	       pt_um 
	       pt_loc
	       pt_buyer
	       wkctr1 label "交库类型" 
               max(in_qty_avail - in_qty_all,0) label "可备料量" /* when available in_mstr*/
	       open_ref1 LABEL "需求量"
	       qty_oh  label "缺件数"
	       qty_oh1  label "计划订货量"
	       op when pt_pm_code = "m"
	       space(2)  WITH frame b STREAM-IO /*width 650 GUI*/ .
	     qty_oh2 = 0.
	     if getall1 = "y" then do:
       if last-of(wod_part) then do:
             find first sod_det where sod_domain = global_domain and sod_part = wod_part and sod_qty_ord > sod_qty_ship no-lock no-error.
             if available sod_det then do:
	    /*    down .*/
	       for each sod_det where sod_domain = global_domain and sod_part = wod_part 
	           and sod_qty_ord > sod_qty_ship 
	           and (sod_nbr >= nbr4 and sod_nbr <= nbr5)
	           and (sod_req_date >= rel_date and sod_req_date <= rel_date1)
                   and (sod_due_date >= due_date and sod_due_date <= due_date1)	
	           break by sod_part by sod_due_date 
	           with frame b width 620 no-attr-space:
	           assign sod_user1 = "*".
	           if qty_oh <= 0 then  qty_oh = (sod_qty_ord - sod_qty_ship - sod_qty_all - sod_qty_pick) * -1.
                   if qty_oh > 0 then qty_oh = qty_oh - (sod_qty_ord - sod_qty_ship - sod_qty_all - sod_qty_pick).
                   if qty_oh < 0 then qty_oh2 = qty_oh2 + qty_oh.
                   if qty_oh < 0 then
                   display   sod_req_date @ rel_date3
                	   sod_due_date @ due_date3
                           sod_nbr  @  nbr3 
	                   trim(string(sod_line))  @  lot3 
	                   sod_part  @  pt_part
	                   desc1  
                           pt_um 
	                   pt_loc
	                   pt_buyer
	                   wkctr1 label "交库类型" 
                      /*     max(in_qty_avail - in_qty_all,0) label "可备料量"    when first-of (wod_part)*/
	                   (soD_QTY_ord - SOD_QTY_SHIP - sod_qty_all)  @ open_ref1
	                   qty_oh  
	                   qty_oh1  label "计划订货量"
                           op when pt_pm_code = "m"
	                    space(2)  WITH frame b  STREAM-IO /*width 650 GUI*/ .
                          down .
	                   end. /*end for each sod_det */
	                   end. /* end for available sod_det */
                     end.
	       end. /*end for getall1 = "y"*/
	       
	      if (last-of(wod_part)) and ((accum total by wod_part (qty_oh)) < 0 or qty_oh2 < 0) then do:
	          down 1.
              for each mrp_det where mrp_domain = global_domain and (mrp_dataset = "wo_mstr" or mrp_dataset = "pod_det")
                                      and mrp_part = wod_part 
                                      and (mrp_due_date <= due_date3 and getall = "Y")
                                       break by mrp_part by mrp_due_date with frame b width 620 no-attr-space:
                   
                    due_date3 = mrp_due_date.
                    nbr3 = mrp_nbr.
                    lot3 = mrp_line.
                  find womstr where womstr.wo_domain = global_domain and womstr.wo_lot = mrp_line no-lock no-error.  
         if available mrp_det  then           display 
                    "资 源" @ rel_date3 column-label "发布日期"
	       due_date3 column-label "到期日"
	       nbr3 column-label "加工单"
	       lot3 column-label "id"
	       womstr.WO_STATUS WHEN AVAILABLE WOMSTR @ WO_MSTR.WO_STATUS 
	       pt_part 
	       desc1  
	       pt_um 
	       pt_loc
	       pt_buyer
	       wkctr1 column-label "交库类型" 
	       mrp_qty @ qty_oh1
	       op when pt_pm_code = "m"
	       space(2)  WITH frame b STREAM-IO width 620 /*GUI*/.
                down 1.
                     accumulate mrp_qty (total by mrp_part).
                      qty_oh1 = (accum total by mrp_part (mrp_qty)).

               
                   
                       end. /*end for each mrp_det */   
                     
                
                  underline qty_oh qty_oh1.
                  display "合计" @ wkctr1
                   ((accum total by wod_part (qty_oh)) + qty_oh2) @ qty_oh
                   qty_oh1 
                   WITH frame b STREAM-IO /*GUI*/ . 
                   DOWN 1.
          
                      end. /*end for last-of(wod_part) */      


	       end. /* end for available ro_det*/
	       END. /* end for pt_pm_code = "m" and available ro_det*/
	       END. /*end for wkctr >= deliver and wkctr <= deliver1*/
       	    END. /* end for each wo_mstr*/
       	    
       	    
       if getall1 = "Y" THEN DO:
            for each sod_det where sod_domain = global_domain and sod_user1 = "" and sod_qty_ord > sod_qty_ship
                   and (sod_nbr >= nbr4 and sod_nbr <= nbr5)
                   and (sod_part >= part and sod_part <= part1)
	           and (sod_req_date >= rel_date and sod_req_date <= rel_date1)
                   and (sod_due_date >= due_date and sod_due_date <= due_date1)	,
                   each pt_mstr where pt_domain = global_domain and pt_part = sod_part 
                   and (pt_buyer >= buyer and pt_buyer <= buyer1)
                   and ((pt_pm_code = ptpm and ptpm <> "") or ptpm = "")
	           break by sod_part by sod_due_date 
	           with frame C width 600 no-attr-space:
	           	setFrameLabels(frame c:handle).
	            desc1 = trim(pt_desc1) + trim(pt_desc2).
	           if deliver2 <> "" or deliver3 <> "" then 
	                 find first ro_det where ro_domain = global_domain and ro_routing = pt_part 
                         and ro_wkctr >= deliver2 and ro_wkctr <= deliver3 no-lock no-error.
                        if (pt_pm_code = "m" and available ro_det)
                           and (  deliver2 <> "" or deliver3 <> "")
	                   or (( deliver2 = "" or deliver3 = "" )
	                   and ((pt_pm_code  = "p" )
	                   or (pt_pm_code = "m" and available ro_det))) then do:
	           
	         
	          open_ref = (sod_qty_ord - sod_qty_ship).
	           IF FIRST (SOD_PART) THEN 
                  display "*********** 附 录 ：在选择条件范畴内没有对应的物料需求的客户订单缺件。********* " space(2)  WITH  STREAM-IO /*width 650 GUI*/ .
                  down 1.
	          IF FIRST-OF (SOD_PART) THEN DO:
                      FIND IN_MSTR WHERE in_domain = global_domain and  IN_PART = sod_PART AND IN_SITE = "10000"  no-lock NO-ERROR.
                      if available in_mstr and in_qty_oh > 0 then qty_oh = max(in_qty_avail - in_qty_all,0).
                      if not available in_mstr or in_qty_oh = 0 then qty_oh = 0.
               if pt_pm_code = "m" then  
                         
        
              FIND FIRST RO_DET WHERE ro_domain = global_domain and ((RO_ROUTING = sOd_PART) AND (RO_WKCTR MATCHES "*95" OR RO_WKCTR MATCHES "*96" OR RO_WKCTR MATCHES "*99" OR RO_WKCTR MATCHES "*98" OR RO_WKCTR MATCHES "*97"))
                 no-lock no-error.
                 if available RO_DET then op1 = substring(RO_wkctr,1,2).
              FIND NEXT RO_DET WHERE ro_domain = global_domain and  ((RO_ROUTING = sOd_PART) AND (RO_WKCTR MATCHES "*95" OR RO_WKCTR MATCHES "*96" OR RO_WKCTR MATCHES "*99" OR RO_WKCTR MATCHES "*98" OR RO_WKCTR MATCHES "*97"))
                 no-lock no-error.
                 if available RO_DET then op2 = "→" + substring(RO_wkctr,1,2).
              FIND NEXT RO_DET WHERE ro_domain = global_domain and ((RO_ROUTING = sOd_PART) AND (RO_WKCTR MATCHES "*95" OR RO_WKCTR MATCHES "*96" OR RO_WKCTR MATCHES "*99" OR RO_WKCTR MATCHES "*98" OR RO_WKCTR MATCHES "*97"))
                 no-lock no-error.
                 if available RO_DET then op3 = "→" + substring(RO_wkctr,1,2).      
               FIND NEXT RO_DET WHERE ro_domain = global_domain and  ((RO_ROUTING = sOd_PART) AND (RO_WKCTR MATCHES "*95" OR RO_WKCTR MATCHES "*96" OR RO_WKCTR MATCHES "*99" OR RO_WKCTR MATCHES "*98" OR RO_WKCTR MATCHES "*97"))
                 no-lock no-error.
                 if available RO_DET then op4 = "→" + substring(RO_wkctr,1,2).      
               FIND NEXT RO_DET WHERE ro_domain = global_domain and ((RO_ROUTING = sOd_PART) AND (RO_WKCTR MATCHES "*95" OR RO_WKCTR MATCHES "*96" OR RO_WKCTR MATCHES "*99" OR RO_WKCTR MATCHES "*98" OR RO_WKCTR MATCHES "*97"))
                 no-lock no-error.
                 if available RO_DET then op5 = "→" + substring(RO_wkctr,1,2).      
              FIND NEXT RO_DET WHERE ro_domain = global_domain and ((RO_ROUTING = sOd_PART) AND (RO_WKCTR MATCHES "*95" OR RO_WKCTR MATCHES "*96" OR RO_WKCTR MATCHES "*99" OR RO_WKCTR MATCHES "*98" OR RO_WKCTR MATCHES "*97"))
                 no-lock no-error.
                 if available RO_DET then op6 = "→" + substring(RO_wkctr,1,2).      
              FIND NEXT RO_DET WHERE ro_domain = global_domain and ((RO_ROUTING = sOd_PART) AND (RO_WKCTR MATCHES "*95" OR RO_WKCTR MATCHES "*96" OR RO_WKCTR MATCHES "*99" OR RO_WKCTR MATCHES "*98" OR RO_WKCTR MATCHES "*97"))
                 no-lock no-error.
                 if available RO_DET then op7 = "→" + substring(RO_wkctr,1,2).      
              FIND NEXT RO_DET WHERE ro_domain = global_domain and ((RO_ROUTING = sOd_PART) AND (RO_WKCTR MATCHES "*95" OR RO_WKCTR MATCHES "*96" OR RO_WKCTR MATCHES "*99" OR RO_WKCTR MATCHES "*98" OR RO_WKCTR MATCHES "*97"))
                 no-lock no-error.
                 if available RO_DET then op8 = "→" + substring(RO_wkctr,1,2).      
              FIND NEXT RO_DET WHERE ro_domain = global_domain and ((RO_ROUTING = sOd_PART) AND (RO_WKCTR MATCHES "*95" OR RO_WKCTR MATCHES "*96" OR RO_WKCTR MATCHES "*99" OR RO_WKCTR MATCHES "*98" OR RO_WKCTR MATCHES "*97"))
                 no-lock no-error.
                 if available RO_DET then op9 = "→" + substring(RO_wkctr,1,2).      
              FIND NEXT RO_DET WHERE ro_domain = global_domain and ((RO_ROUTING = sOd_PART) AND (RO_WKCTR MATCHES "*95" OR RO_WKCTR MATCHES "*96" OR RO_WKCTR MATCHES "*99" OR RO_WKCTR MATCHES "*98" OR RO_WKCTR MATCHES "*97"))
                 no-lock no-error.
                 if available RO_DET then op10 = "→" + substring(RO_wkctr,1,2).      
              FIND NEXT RO_DET WHERE ro_domain = global_domain and ((RO_ROUTING = sOd_PART) AND (RO_WKCTR MATCHES "*95" OR RO_WKCTR MATCHES "*96" OR RO_WKCTR MATCHES "*99" OR RO_WKCTR MATCHES "*98" OR RO_WKCTR MATCHES "*97"))
                 no-lock no-error.
                 if available RO_DET then op11 = "→" + substring(RO_wkctr,1,2).  
                                                                                                                        
             OP = OP1 + OP2 + OP3 + OP4 + OP5 + OP6 + OP7 + OP8 + OP9 + OP10 + OP11.
           
            
             END. 
                     end. /*end for first-of sod_part */
                     
              if qty_oh <= 0 then  qty_oh = open_ref * -1.
              if qty_oh > 0 then qty_oh = qty_oh - open_ref.


             OPEN_REF1 = (sod_qty_ord - sod_qty_ship).

             if qty_oh < 0 then accumulate qty_oh (total by sod_part) .
      
                 
                 IF QTY_OH < 0 
                    then 
                   display   sod_req_date 
                	   sod_due_date 
                           sod_nbr  
	                   trim(string(sod_line))  @  lot3 
	                   sod_part 
	                   desc1  
                           pt_um 
	                   pt_loc
	                   pt_buyer
	               /*      wkctr1 label "交库类型" */
                         max(in_qty_avail - in_qty_all,0) label "可备料量"  
	                   open_ref1 LABEL "需求量"
	                   qty_oh  label "缺件数"
 	                   qty_oh1  label "计划订货量"
                           op when pt_pm_code = "m"
	                    space(2)  WITH frame C STREAM-IO /*width 650 GUI*/ .

                  if last-of (sod_part) and qty_oh < 0 
                   then do:
                   underline qty_oh .
                  display (accum total by sod_part (qty_oh))  @ qty_oh .
                  end.

	           end.
	           end. /* end for each sod_det */

            end. /*end for getall1 = "y"*/
      
	    /* REPORT TRAILER  */
	    
 {mfguirex.i }.
 {mfguitrl.i}.
 {mfgrptrm.i} .



	/* end.*/

/*GUI*/ end.
