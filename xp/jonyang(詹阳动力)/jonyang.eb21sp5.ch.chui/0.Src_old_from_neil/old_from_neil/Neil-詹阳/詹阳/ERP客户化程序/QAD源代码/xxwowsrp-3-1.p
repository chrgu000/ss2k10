/* GUI CONVERTED from wowsrp.p (converter v1.71) Tue Oct  6 14:59:18 1998 */
/* wowsrp.p - WORK ORDER COMPONENT SHORTAGE BY ORDER REPORT             */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/* web convert wowsrp.p (converter v1.00) Fri Oct 10 13:57:25 1997 */
/* web tag in wowsrp.p (converter v1.00) Mon Oct 06 14:17:53 1997 */
/*F0PN*/ /*K0YQ*/ /*V8#ConvertMode=WebReport                            */
/*V8:ConvertMode=FullGUIReport                                 */
/* REVISION: 4.0    LAST MODIFIED: 04/26/89    BY: emb *A722**/
/* REVISION: 6.0    LAST MODIFIED: 04/16/91    BY: RAM *D530**/
/* REVISION: 8.5    LAST MODIFIED: 11/21/96    BY: *J196*  Russ Witt       */
/* REVISION: 8.6    LAST MODIFIED: 10/14/97    BY: ays *K0YQ* */

/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan      */
/*By: Neil Gao 09/02/06 ECO: *SS 20090206* */

         /* DISPLAY TITLE */

/*GUI global preprocessor directive settings */
&GLOBAL-DEFINE PP_PGM_RP TRUE
&GLOBAL-DEFINE PP_ENV_GUI TRUE


/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

         {mfdtitle.i "e+ "}

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE wowsrp_p_1 "子零件"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */


         define variable nbr   like wod_nbr.
         define variable nbr1  like wod_nbr.
         define variable lot   like wod_lot.
         define variable lot1   like wod_lot.
         define variable part  like wod_part LABEL "父零件".
         define variable part1 like wod_part.
         define variable part2 like wod_part.
         define variable rel_date like wo_rel_date.
         define variable rel_date1 like wo_rel_date.
         define variable rel_date2 like wo_rel_date.

         define variable due_date like wo_due_date.
         define variable due_date1 like wo_due_date.
         define variable due_date2 like wo_due_date.

         define variable BUYER  like PT_BUYER  LABEL "父零件采计".
         define variable BUYER1 like PT_BUYER.
         define variable ord_okay like wod_lot.
         define variable ord_ignore like wod_lot.
         define variable old_lot like wod_lot.
         define variable open_ref like wod_qty_req format ">>>,>>9.99" LABEL "短缺量".
         define variable desc1 AS CHARACTER FORMAT "X(36)" LABEL "描述".
         define variable WKCTR like RO_WKCTR label "工作中心".
         define variable WKCTR1 like RO_WKCTR.
         define variable WKCTR2 like RO_WKCTR.
         define variable LOC like PT_LOC.
         define variable OP AS CHARACTER FORMAT "X(60)" LABEL "工艺流程".
         define variable OPA like ro_wkctr.
         define variable OPAA like ro_wkctr.
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
         define variable OPb AS  CHARACTER FORMAT "xx" label "父件交库类型".
         define variable OPC AS  CHARACTER FORMAT "xx".
         define variable BZ AS  CHARACTER FORMAT "xx".
         define variable BZ1 AS  CHARACTER FORMAT "xx".

         define variable XZ AS  CHARACTER FORMAT "x" label "加工单状态".
         define variable XZ1 AS  CHARACTER FORMAT "x" label "父件到期日内的子零件(Y/N)".
         define variable XZ2 AS  CHARACTER FORMAT "x" label "工作中心相同的子零件(Y/N)".
         define variable XZ3 AS  CHARACTER FORMAT "x" label "加工单号相同的子零件(Y/N)".

         define new shared temp-table tmp 
    field tmp_userid like mfguser
    field tmp_site like in_site 
    field tmp_BOM_QTY AS CHARACTER FORMAT "X(9)" LABEL "单位用量" 
    field tmp_loc like PT_loc label "库位"
    field tmp_part like PT_part label "父零件号" 
    field tmp_DESC1 AS  CHARACTER FORMAT "X(42)" label "描述"
    field tmp_UM like PT_UM label "单位"
    field tmp_BUYER like PT_BUYER label "采计" 
    field tmp_NBR like WO_NBR label "加工单号"
    field tmp_LOT like WO_LOT label "标志号"
    field tmp_STATUS like WO_STATUS label "状态"
    field tmp_REL_DATE like WO_REL_DATE label "下达日期"
    field tmp_due_DATE like WO_due_DATE label "到 期 日"
    field tmp_QTY_ORD  like WO_QTY_ORD format "->>,>>>,>>9.99" label "订货量"
    field tmp_QTY_COMP like WO_QTY_COMP format "->>,>>>,>>9.99" label "已完成量"
    field tmp_QTY_rjct like WO_QTY_RJCT format "->>,>>>,>>9.99" label "废品量"
    field tmp_QTY_OH like IN_QTY_OH format "->>,>>>,>>9.99"
    field tmp_wkctr like ro_wkctr
    field tmp_OP AS CHARACTER FORMAT "X(60)" LABEL "工艺流程"
    field tmp_OPA like ro_wkctr label "交库类型"
    field tmp_OPAA like ro_wkctr label "首道工序"
    field tmp_OPB AS CHARACTER FORMAT "X(2)" .

  XZ1 = "Y".
  XZ2 = "Y".
  XZ3 = "Y".
  XZ = "".         

         
/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
           nbr      colon 20 nbr1      label {t001.i} colon 49 skip
           lot      colon 20 lot1      label {t001.i} colon 49 skip
           rel_date colon 20 rel_date1 label {t001.i} colon 49 skip
           due_date colon 20 due_date1      label {t001.i} colon 49 skip
           part     colon 20 part1     label {t001.i} colon 49 skip
           wkctr    colon 20 wkctr1    label {t001.i} colon 49 skip
           BUYER    colon 20 BUYER1    label {t001.i} colon 49 skip
           opb      colon 20 skip
           xz      colon 20 skip
           xz1     colon 20 skip
           XZ2     COLON 20 SKIP
           XZ3     COLON 20 SKIP
         /* SKIP(.4)*/  /*GUI*/
with frame a side-labels width 80 attr-space /*GUI*/.

setFrameLabels(frame a:handle).

/*J196*/ FORM /*GUI*/  WO_NBR WO_LOT wo_status op opa wo_part desc1 PT_BUYER wo_qty_ord wo_qty_comp 
/*J196*/       open_ref
/*J196*/ with STREAM-IO /*GUI*/  down frame b width 210 no-attr-space.

repeat:

/*K0YQ*/ {wbrp01.i}


            if nbr1  = hi_char then  nbr1 = "".
            if lot1  = hi_char then  lot1 = "".
            if part1 = hi_char then part1 = "".
            if wkctr1 = hi_char then wkctr1 = "".
            if BUYER1 = hi_char then BUYER1 = "".
            if rel_date1 = hi_date then rel_date1 = ?.
/*IFP*/     if due_date1 = hi_date then due_date1 = ?.
/*IFP*/     if rel_date = low_date then rel_date = ?.
/*IFP*/     if due_date = low_date then due_date = ?.




						update nbr nbr1 lot lot1 part part1 wkctr wkctr1 BUYER BUYER1 opb with frame a.

/*K0YQ*/ if (c-application-mode <> 'web':u) or
/*K0YQ*/ (c-application-mode = 'web':u and
/*K0YQ*/ (c-web-request begins 'data':u)) then do:


/*A175      CREATE BATCH INPUT STRING */
/*A175*/    bcdparm = "".
/*A175*/    {mfquoter.i nbr    }
/*A175*/    {mfquoter.i nbr1   }
/*A175*/    {mfquoter.i rel_date    }
/*A175*/    {mfquoter.i rel_date1   }
/*A175*/    {mfquoter.i due_date    }
/*A175*/    {mfquoter.i due_date1   }
/*A175*/    {mfquoter.i part   }
/*A175*/    {mfquoter.i part1  }
            {mfquoter.i wkctr   }
/*A175*/    {mfquoter.i wkctr1  }
            {mfquoter.i BUYER   }
/*A175*/    {mfquoter.i BUYER1  }

/*A175*/    {mfquoter.i lot    }
/*A175*/    {mfquoter.i lot1    }
            if nbr1  = "" then nbr1  = hi_char.
/*IFP*/     if lot1 = "" then lot1 = hi_char.
            if part1 = "" then part1 = hi_char.
            if wkctr1 = "" then wkctr1 = hi_char.
            if BUYER1 = "" then BUYER1 = hi_char.
            if  rel_date1 = ? then rel_date1 = hi_date.
/*IFP*/     if  due_date1 = ? then due_date1 = hi_date.
/*IFP*/     if  rel_date = ? then rel_date = low_date.
/*IFP*/     if  due_date = ? then due_date = low_date.



/*K0YQ*/ end.

            /* SELECT PRINTER  */


				{mfselbpr.i "printer" 132}
				
/*GUI*/   mainloop: do on error undo, return error on endkey undo, return error:

define buffer wod_det1 for wod_det.


            {mfphead.i}

           
            desc1 = "".
          
            /* FIND AND DISPLAY */
        for each wo_mstr where (wo_part >= part and wo_part <= part1) 
/*SS 20090206 - B*/
						and wo_domain = global_domain
/*SS 20090206 - E*/
            and (wo_nbr >= nbr and wo_nbr <= nbr1)
            and (wo_lot >= lot and wo_lot <= lot1)
            and (wo_rel_date >= rel_date and wo_rel_date <= rel_date1)
            and (wo_due_date >= due_date and wo_due_date <= due_date1)
            and (wo_qty_ord > wo_qty_comp)
            and (wo_status = XZ OR (WO_STATUS <> "C" AND XZ = "")) 
            no-lock by wo_rel_date by wo_part by wo_nbr by wo_lot 
            with frame b width 270:
    find first WR_ROUTE where (WR_PART = wo_part AND WR_LOT = WO_LOT ) and (WR_wkctr >= wkctr and WR_wkctr <= wkctr1)
/*SS 20090206 - B*/
						and wr_domain = global_domain
/*SS 20090206 - E*/
          no-lock no-error.
                           
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
          
    IF AVAILABLE WR_ROUTE Then do:      
         wkctr2 = WR_wkctr.
   
         FIND FIRST WR_ROUTE WHERE (WR_PART = WO_PART AND WR_LOT = WO_LOT) AND (WR_WKCTR MATCHES "*95" OR WR_WKCTR MATCHES "*96" OR WR_WKCTR MATCHES "*99" OR WR_WKCTR MATCHES "*98" OR WR_WKCTR MATCHES "*97") 
/*SS 20090206 - B*/
					and wr_domain = global_domain 
/*SS 20090206 - E*/
        no-lock no-error.
        
        IF AVAILABLE WR_ROUTE  THEN DO:
           IF SUBSTRING(WR_WKCTR,1,3) = "231" THEN OP1 = "备料".
           IF SUBSTRING(WR_WKCTR,1,3) = "232" or SUBSTRING(WR_WKCTR,1,3) = "233" THEN OP1 = "计划".
           IF SUBSTRING(WR_WKCTR,1,2) = "01" THEN OP1 = "铸铁".
           IF SUBSTRING(WR_WKCTR,1,2) = "02" THEN OP1 = "铸钢".
           IF SUBSTRING(WR_WKCTR,1,2) = "03" THEN OP1 = "锻造".
           IF SUBSTRING(WR_WKCTR,1,2) = "04" THEN OP1 = "结构".
           IF SUBSTRING(WR_WKCTR,1,2) = "05" THEN OP1 = "传动".
           IF SUBSTRING(WR_WKCTR,1,2) = "06" THEN OP1 = "液压".
           IF SUBSTRING(WR_WKCTR,1,2) = "07" THEN OP1 = "桥箱".
           IF SUBSTRING(WR_WKCTR,1,3) = "082" THEN OP1 = "热电".
           IF SUBSTRING(WR_WKCTR,1,3) = "081" THEN OP1 = "电镀".
           IF SUBSTRING(WR_WKCTR,1,3) = "104" THEN OP1 = "装配油漆".
           IF SUBSTRING(WR_WKCTR,1,2) = "10" AND SUBSTRING(WR_WKCTR,1,3) <> "104" THEN OP1 = "→装配".
           IF SUBSTRING(WR_WKCTR,1,2) = "12" THEN OP1 = "工具".
           IF SUBSTRING(WR_WKCTR,1,2) = "13" THEN OP1 = "机修动力".
           IF SUBSTRING(WR_WKCTR,1,2) = "99" THEN OP1 = "外协".                       
         
           
  FIND NEXT WR_ROUTE WHERE (WR_PART = WO_PART AND WR_LOT = WO_LOT) AND (WR_WKCTR MATCHES "*95" OR WR_WKCTR MATCHES "*96" OR WR_WKCTR MATCHES "*99" OR WR_WKCTR MATCHES "*98" OR WR_WKCTR MATCHES "*97") 
/*SS 20090206 - B*/
				and wr_domain = global_domain
/*SS 20090206 - E*/
               no-lock no-error.
        IF AVAILABLE WR_ROUTE THEN DO:
           IF SUBSTRING(WR_WKCTR,1,3) = "231" THEN OP2 = "→备料".
           IF SUBSTRING(WR_WKCTR,1,3) = "232" or SUBSTRING(WR_WKCTR,1,3) = "233" THEN OP2 = "→计划".
           IF SUBSTRING(WR_WKCTR,1,2) = "01" THEN OP2 = "→铸铁".
           IF SUBSTRING(WR_WKCTR,1,2) = "02" THEN OP2 = "→铸钢".
           IF SUBSTRING(WR_WKCTR,1,2) = "03" THEN OP2 = "→锻造".
           IF SUBSTRING(WR_WKCTR,1,2) = "04" THEN OP2 = "→结构".
           IF SUBSTRING(WR_WKCTR,1,2) = "05" THEN OP2 = "→传动".
           IF SUBSTRING(WR_WKCTR,1,2) = "06" THEN OP2 = "→液压".
           IF SUBSTRING(WR_WKCTR,1,2) = "07" THEN OP2 = "→桥箱".
           IF SUBSTRING(WR_WKCTR,1,3) = "082" THEN OP2 = "→热电".
           IF SUBSTRING(WR_WKCTR,1,3) = "081" THEN OP2 = "→电镀".
           IF SUBSTRING(WR_WKCTR,1,3) = "104" THEN OP2 = "→装配油漆".
           IF SUBSTRING(WR_WKCTR,1,2) = "10" AND SUBSTRING(WR_WKCTR,1,3) <> "104" THEN OP2 = "→装配".
           IF SUBSTRING(WR_WKCTR,1,2) = "12" THEN OP2 = "→工具".
           IF SUBSTRING(WR_WKCTR,1,2) = "13" THEN OP2 = "→机修动力".
           IF SUBSTRING(WR_WKCTR,1,2) = "99" THEN OP2 = "→外协".                       
   
  FIND NEXT WR_ROUTE WHERE (WR_PART = WO_PART AND WR_LOT = WO_LOT) AND (WR_WKCTR MATCHES "*95" OR WR_WKCTR MATCHES "*96" OR WR_WKCTR MATCHES "*99" OR WR_WKCTR MATCHES "*98" OR WR_WKCTR MATCHES "*97") 
/*SS 20090206 - B*/
				and wr_domain = global_domain 
/*SS 20090206 - E*/
               no-lock no-error.
        IF AVAILABLE WR_ROUTE THEN DO:
           IF SUBSTRING(WR_WKCTR,1,3) = "231" THEN OP3 = "→备料".
           IF SUBSTRING(WR_WKCTR,1,3) = "232" or SUBSTRING(WR_WKCTR,1,3) = "233" THEN OP3 = "→计划".
           IF SUBSTRING(WR_WKCTR,1,2) = "01" THEN OP3 = "→铸铁".
           IF SUBSTRING(WR_WKCTR,1,2) = "02" THEN OP3 = "→铸钢".
           IF SUBSTRING(WR_WKCTR,1,2) = "03" THEN OP3 = "→锻造".
           IF SUBSTRING(WR_WKCTR,1,2) = "04" THEN OP3 = "→结构".
           IF SUBSTRING(WR_WKCTR,1,2) = "05" THEN OP3 = "→传动".
           IF SUBSTRING(WR_WKCTR,1,2) = "06" THEN OP3 = "→液压".
           IF SUBSTRING(WR_WKCTR,1,2) = "07" THEN OP3 = "→桥箱".
           IF SUBSTRING(WR_WKCTR,1,3) = "082" THEN OP3 = "→热电".
           IF SUBSTRING(WR_WKCTR,1,3) = "081" THEN OP3 = "→电镀".
           IF SUBSTRING(WR_WKCTR,1,3) = "104" THEN OP3 = "→装配油漆".
           IF SUBSTRING(WR_WKCTR,1,2) = "10" AND SUBSTRING(WR_WKCTR,1,3) <> "104" THEN OP3 = "→装配".
           IF SUBSTRING(WR_WKCTR,1,2) = "12" THEN OP3 = "→工具".
           IF SUBSTRING(WR_WKCTR,1,2) = "13" THEN OP3 = "→机修动力".
           IF SUBSTRING(WR_WKCTR,1,2) = "99" THEN OP3 = "→外协".                        
   FIND NEXT WR_ROUTE WHERE (WR_PART = WO_PART AND WR_LOT = WO_LOT) AND (WR_WKCTR MATCHES "*95" OR WR_WKCTR MATCHES "*96" OR WR_WKCTR MATCHES "*99" OR WR_WKCTR MATCHES "*98" OR WR_WKCTR MATCHES "*97") 
/*SS 20090206 - B*/
					and wr_domain = global_domain
/*SS 20090206 - E*/
               no-lock no-error.
        IF AVAILABLE WR_ROUTE THEN DO:
           IF SUBSTRING(WR_WKCTR,1,3) = "231" THEN OP4 = "→备料".
           IF SUBSTRING(WR_WKCTR,1,3) = "232" or SUBSTRING(WR_WKCTR,1,3) = "233" THEN OP4 = "→计划".
           IF SUBSTRING(WR_WKCTR,1,2) = "01" THEN OP4 = "→铸铁".
           IF SUBSTRING(WR_WKCTR,1,2) = "02" THEN OP4 = "→铸钢".
           IF SUBSTRING(WR_WKCTR,1,2) = "03" THEN OP4 = "→锻造".
           IF SUBSTRING(WR_WKCTR,1,2) = "04" THEN OP4 = "→结构".
           IF SUBSTRING(WR_WKCTR,1,2) = "05" THEN OP4 = "→传动".
           IF SUBSTRING(WR_WKCTR,1,2) = "06" THEN OP4 = "→液压".
           IF SUBSTRING(WR_WKCTR,1,2) = "07" THEN OP4 = "→桥箱".
           IF SUBSTRING(WR_WKCTR,1,3) = "082" THEN OP4 = "→热电".
           IF SUBSTRING(WR_WKCTR,1,3) = "081" THEN OP4 = "→电镀".
           IF SUBSTRING(WR_WKCTR,1,3) = "104" THEN OP4 = "→装配油漆".
           IF SUBSTRING(WR_WKCTR,1,2) = "10" AND SUBSTRING(WR_WKCTR,1,3) <> "104" THEN OP4 = "→装配".
           IF SUBSTRING(WR_WKCTR,1,2) = "12" THEN OP4 = "→工具".
           IF SUBSTRING(WR_WKCTR,1,2) = "13" THEN OP4 = "→机修动力".
           IF SUBSTRING(WR_WKCTR,1,2) = "99" THEN OP4 = "→外协".                  
  FIND NEXT WR_ROUTE WHERE (WR_PART = WO_PART AND WR_LOT = WO_LOT) AND (WR_WKCTR MATCHES "*95" OR WR_WKCTR MATCHES "*96" OR WR_WKCTR MATCHES "*99" OR WR_WKCTR MATCHES "*98" OR WR_WKCTR MATCHES "*97") 
/*SS 20090206 - B*/
			and wr_domain = global_domain
/*SS 20090206 - E*/
               no-lock no-error.
        IF AVAILABLE WR_ROUTE THEN DO:
           IF SUBSTRING(WR_WKCTR,1,3) = "231" THEN OP5 = "→备料".
           IF SUBSTRING(WR_WKCTR,1,3) = "232" or SUBSTRING(WR_WKCTR,1,3) = "233" THEN OP5 = "→计划".
           IF SUBSTRING(WR_WKCTR,1,2) = "01" THEN OP5 = "→铸铁".
           IF SUBSTRING(WR_WKCTR,1,2) = "02" THEN OP5 = "→铸钢".
           IF SUBSTRING(WR_WKCTR,1,2) = "03" THEN OP5 = "→锻造".
           IF SUBSTRING(WR_WKCTR,1,2) = "04" THEN OP5 = "→结构".
           IF SUBSTRING(WR_WKCTR,1,2) = "05" THEN OP5 = "→传动".
           IF SUBSTRING(WR_WKCTR,1,2) = "06" THEN OP5 = "→液压".
           IF SUBSTRING(WR_WKCTR,1,2) = "07" THEN OP5 = "→桥箱".
           IF SUBSTRING(WR_WKCTR,1,3) = "082" THEN OP5 = "→热电".
           IF SUBSTRING(WR_WKCTR,1,3) = "081" THEN OP5 = "→电镀".
           IF SUBSTRING(WR_WKCTR,1,3) = "104" THEN OP5 = "→装配油漆".
           IF SUBSTRING(WR_WKCTR,1,2) = "10" AND SUBSTRING(WR_WKCTR,1,3) <> "104" THEN OP5 = "→装配".
           IF SUBSTRING(WR_WKCTR,1,2) = "12" THEN OP5 = "→工具".
           IF SUBSTRING(WR_WKCTR,1,2) = "13" THEN OP5 = "→机修动力".
           IF SUBSTRING(WR_WKCTR,1,2) = "99" THEN OP5 = "→外协".                  
 FIND NEXT WR_ROUTE WHERE (WR_PART = WO_PART AND WR_LOT = WO_LOT) AND (WR_WKCTR MATCHES "*95" OR WR_WKCTR MATCHES "*96" OR WR_WKCTR MATCHES "*99" OR WR_WKCTR MATCHES "*98" OR WR_WKCTR MATCHES "*97") 
/*SS 20090206 - B*/
					and wr_domain = global_domain
/*SS 20090206 - E*/
               no-lock no-error.
        IF AVAILABLE WR_ROUTE THEN DO:
           IF SUBSTRING(WR_WKCTR,1,3) = "231" THEN OP6 = "→备料".
           IF SUBSTRING(WR_WKCTR,1,3) = "232" or SUBSTRING(WR_WKCTR,1,3) = "233" THEN OP6 = "→计划".
           IF SUBSTRING(WR_WKCTR,1,2) = "01" THEN OP6 = "→铸铁".
           IF SUBSTRING(WR_WKCTR,1,2) = "02" THEN OP6 = "→铸钢".
           IF SUBSTRING(WR_WKCTR,1,2) = "03" THEN OP6 = "→锻造".
           IF SUBSTRING(WR_WKCTR,1,2) = "04" THEN OP6 = "→结构".
           IF SUBSTRING(WR_WKCTR,1,2) = "05" THEN OP6 = "→传动".
           IF SUBSTRING(WR_WKCTR,1,2) = "06" THEN OP6 = "→液压".
           IF SUBSTRING(WR_WKCTR,1,2) = "07" THEN OP6 = "→桥箱".
           IF SUBSTRING(WR_WKCTR,1,3) = "082" THEN OP6 = "→热电".
           IF SUBSTRING(WR_WKCTR,1,3) = "081" THEN OP6 = "→电镀".
           IF SUBSTRING(WR_WKCTR,1,3) = "104" THEN OP6 = "→装配油漆".
           IF SUBSTRING(WR_WKCTR,1,2) = "10" AND SUBSTRING(WR_WKCTR,1,3) <> "104" THEN OP6 = "→装配".

           IF SUBSTRING(WR_WKCTR,1,2) = "12" THEN OP6 = "→工具".
           IF SUBSTRING(WR_WKCTR,1,2) = "13" THEN OP6 = "→机修动力".
           IF SUBSTRING(WR_WKCTR,1,2) = "99" THEN OP6 = "→外协".                
  FIND NEXT WR_ROUTE WHERE (WR_PART = WO_PART AND WR_LOT = WO_LOT) AND (WR_WKCTR MATCHES "*95" OR WR_WKCTR MATCHES "*96" OR WR_WKCTR MATCHES "*99" OR WR_WKCTR MATCHES "*98" OR WR_WKCTR MATCHES "*97") 
/*SS 20090206 - B*/
						and wr_domain = global_domain
/*SS 20090206 - E*/
               no-lock no-error.
        IF AVAILABLE WR_ROUTE THEN DO:
           IF SUBSTRING(WR_WKCTR,1,3) = "231" THEN OP7 = "→备料".
           IF SUBSTRING(WR_WKCTR,1,3) = "232" or SUBSTRING(WR_WKCTR,1,3) = "233" THEN OP7 = "→计划".
           IF SUBSTRING(WR_WKCTR,1,2) = "01" THEN OP7 = "→铸铁".
           IF SUBSTRING(WR_WKCTR,1,2) = "02" THEN OP7 = "→铸钢".
           IF SUBSTRING(WR_WKCTR,1,2) = "03" THEN OP7 = "→锻造".
           IF SUBSTRING(WR_WKCTR,1,2) = "04" THEN OP7 = "→结构".
           IF SUBSTRING(WR_WKCTR,1,2) = "05" THEN OP7 = "→传动".
           IF SUBSTRING(WR_WKCTR,1,2) = "06" THEN OP7 = "→液压".
           IF SUBSTRING(WR_WKCTR,1,2) = "07" THEN OP7 = "→桥箱".
           IF SUBSTRING(WR_WKCTR,1,3) = "082" THEN OP7 = "→热电".
           IF SUBSTRING(WR_WKCTR,1,3) = "081" THEN OP7 = "→电镀".
           IF SUBSTRING(WR_WKCTR,1,3) = "104" THEN OP7 = "→装配油漆".
           IF SUBSTRING(WR_WKCTR,1,2) = "10" AND SUBSTRING(WR_WKCTR,1,3) <> "104" THEN OP7 = "→装配".
           IF SUBSTRING(WR_WKCTR,1,2) = "12" THEN OP7 = "→工具".
           IF SUBSTRING(WR_WKCTR,1,2) = "13" THEN OP7 = "→机修动力".
           IF SUBSTRING(WR_WKCTR,1,2) = "99" THEN OP7 = "→外协".       
                            
 FIND NEXT WR_ROUTE WHERE (WR_PART = WO_PART AND WR_LOT = WO_LOT) AND (WR_WKCTR MATCHES "*95" OR WR_WKCTR MATCHES "*96" OR WR_WKCTR MATCHES "*99" OR WR_WKCTR MATCHES "*98" OR WR_WKCTR MATCHES "*97") 
/*SS 20090206 - B*/
						and wr_domain = global_domain
/*SS 20090206 - E*/
               no-lock no-error.
        IF AVAILABLE WR_ROUTE THEN DO:
           IF SUBSTRING(WR_WKCTR,1,3) = "231" THEN OP8 = "→备料".
           IF SUBSTRING(WR_WKCTR,1,3) = "232" or SUBSTRING(WR_WKCTR,1,3) = "233" THEN OP8 = "→计划".
           IF SUBSTRING(WR_WKCTR,1,2) = "01" THEN OP8 = "→铸铁".
           IF SUBSTRING(WR_WKCTR,1,2) = "02" THEN OP8 = "→铸钢".
           IF SUBSTRING(WR_WKCTR,1,2) = "03" THEN OP8 = "→锻造".
           IF SUBSTRING(WR_WKCTR,1,2) = "04" THEN OP8 = "→结构".
           IF SUBSTRING(WR_WKCTR,1,2) = "05" THEN OP8 = "→传动".
           IF SUBSTRING(WR_WKCTR,1,2) = "06" THEN OP8 = "→液压".
           IF SUBSTRING(WR_WKCTR,1,2) = "07" THEN OP8 = "→桥箱".
           IF SUBSTRING(WR_WKCTR,1,3) = "082" THEN OP8 = "→热电".
           IF SUBSTRING(WR_WKCTR,1,3) = "081" THEN OP8 = "→电镀".
           IF SUBSTRING(WR_WKCTR,1,3) = "104" THEN OP8 = "→装配油漆".
           IF SUBSTRING(WR_WKCTR,1,2) = "10" AND SUBSTRING(WR_WKCTR,1,3) <> "104" THEN OP8 = "→装配".
           IF SUBSTRING(WR_WKCTR,1,2) = "12" THEN OP8 = "→工具".
           IF SUBSTRING(WR_WKCTR,1,2) = "13" THEN OP8 = "→机修动力".
           IF SUBSTRING(WR_WKCTR,1,2) = "99" THEN OP8 = "→外协".                       
                
  FIND NEXT WR_ROUTE WHERE (WR_PART = WO_PART AND WR_LOT = WO_LOT) AND (WR_WKCTR MATCHES "*95" OR WR_WKCTR MATCHES "*96" OR WR_WKCTR MATCHES "*99" OR WR_WKCTR MATCHES "*98" OR WR_WKCTR MATCHES "*97") 
/*SS 20090206 - B*/
						and wr_domain = global_domain
/*SS 20090206 - E*/
               no-lock no-error.
        IF AVAILABLE WR_ROUTE THEN DO:
           IF SUBSTRING(WR_WKCTR,1,3) = "231" THEN OP9 = "→备料".
           IF SUBSTRING(WR_WKCTR,1,3) = "232" or SUBSTRING(WR_WKCTR,1,3) = "233" THEN OP9 = "→计划".
           IF SUBSTRING(WR_WKCTR,1,2) = "01" THEN OP9 = "→铸铁".
           IF SUBSTRING(WR_WKCTR,1,2) = "02" THEN OP9 = "→铸钢".
           IF SUBSTRING(WR_WKCTR,1,2) = "03" THEN OP9 = "→锻造".
           IF SUBSTRING(WR_WKCTR,1,2) = "04" THEN OP9 = "→结构".
           IF SUBSTRING(WR_WKCTR,1,2) = "05" THEN OP9 = "→传动".
           IF SUBSTRING(WR_WKCTR,1,2) = "06" THEN OP9 = "→液压".
           IF SUBSTRING(WR_WKCTR,1,2) = "07" THEN OP9 = "→桥箱".
           IF SUBSTRING(WR_WKCTR,1,3) = "082" THEN OP9 = "→热电".
           IF SUBSTRING(WR_WKCTR,1,3) = "081" THEN OP9 = "→电镀".
           IF SUBSTRING(WR_WKCTR,1,3) = "104" THEN OP9 = "→装配油漆".
           IF SUBSTRING(WR_WKCTR,1,2) = "10" AND SUBSTRING(WR_WKCTR,1,3) <> "104" THEN OP9 = "→装配".
           IF SUBSTRING(WR_WKCTR,1,2) = "12" THEN OP9 = "→工具".
           IF SUBSTRING(WR_WKCTR,1,2) = "13" THEN OP9 = "→机修动力".
           IF SUBSTRING(WR_WKCTR,1,2) = "99" THEN OP9 = "→外协".       
           
                           
 FIND NEXT WR_ROUTE WHERE (WR_PART = WO_PART AND WR_LOT = WO_LOT) AND (WR_WKCTR MATCHES "*95" OR WR_WKCTR MATCHES "*96" OR WR_WKCTR MATCHES "*99" OR WR_WKCTR MATCHES "*98" OR WR_WKCTR MATCHES "*97") 
/*SS 20090206 - B*/
						and wr_domain = global_domain
/*SS 20090206 - E*/
               no-lock no-error.
        IF AVAILABLE WR_ROUTE THEN DO:
           IF SUBSTRING(WR_WKCTR,1,3) = "231" THEN OP10 = "→备料".
           IF SUBSTRING(WR_WKCTR,1,3) = "232" or SUBSTRING(WR_WKCTR,1,3) = "233" THEN OP10 = "→计划".
           IF SUBSTRING(WR_WKCTR,1,2) = "01" THEN OP10 = "→铸铁".
           IF SUBSTRING(WR_WKCTR,1,2) = "02" THEN OP10 = "→铸钢".
           IF SUBSTRING(WR_WKCTR,1,2) = "03" THEN OP10 = "→锻造".
           IF SUBSTRING(WR_WKCTR,1,2) = "04" THEN OP10 = "→结构".
           IF SUBSTRING(WR_WKCTR,1,2) = "05" THEN OP10 = "→传动".
           IF SUBSTRING(WR_WKCTR,1,2) = "06" THEN OP10 = "→液压".
           IF SUBSTRING(WR_WKCTR,1,2) = "07" THEN OP10 = "→桥箱".
           IF SUBSTRING(WR_WKCTR,1,3) = "082" THEN OP10 = "→热电".
           IF SUBSTRING(WR_WKCTR,1,3) = "081" THEN OP10 = "→电镀".
           IF SUBSTRING(WR_WKCTR,1,3) = "104" THEN OP10 = "→装配油漆".
           IF SUBSTRING(WR_WKCTR,1,2) = "10" AND SUBSTRING(WR_WKCTR,1,3) <> "104" THEN OP10 = "→装配".
           IF SUBSTRING(WR_WKCTR,1,2) = "12" THEN OP10 = "→工具".
           IF SUBSTRING(WR_WKCTR,1,2) = "13" THEN OP10 = "→机修动力".
           IF SUBSTRING(WR_WKCTR,1,2) = "99" THEN OP10 = "→外协".                  
                                    
 FIND NEXT WR_ROUTE WHERE (WR_PART = WO_PART AND WR_LOT = WO_LOT) AND (WR_WKCTR MATCHES "*95" OR WR_WKCTR MATCHES "*96" OR WR_WKCTR MATCHES "*99" OR WR_WKCTR MATCHES "*98" OR WR_WKCTR MATCHES "*97") 
/*SS 20090206 - B*/
						and wr_domain = global_domain
/*SS 20090206 - E*/
               no-lock no-error.
        IF AVAILABLE WR_ROUTE THEN DO:
           IF SUBSTRING(WR_WKCTR,1,3) = "231" THEN OP11 = "→备料".
           IF SUBSTRING(WR_WKCTR,1,3) = "232" or SUBSTRING(WR_WKCTR,1,3) = "233" THEN OP11 = "→计划".
           IF SUBSTRING(WR_WKCTR,1,2) = "01" THEN OP11 = "→铸铁".
           IF SUBSTRING(WR_WKCTR,1,2) = "02" THEN OP11 = "→铸钢".
           IF SUBSTRING(WR_WKCTR,1,2) = "03" THEN OP11 = "→锻造".
           IF SUBSTRING(WR_WKCTR,1,2) = "04" THEN OP11 = "→结构".
           IF SUBSTRING(WR_WKCTR,1,2) = "05" THEN OP11 = "→传动".
           IF SUBSTRING(WR_WKCTR,1,2) = "06" THEN OP11 = "→液压".
           IF SUBSTRING(WR_WKCTR,1,2) = "07" THEN OP11 = "→桥箱".
           IF SUBSTRING(WR_WKCTR,1,3) = "082" THEN OP11 = "→热电".
           IF SUBSTRING(WR_WKCTR,1,3) = "081" THEN OP11 = "→电镀".
           IF SUBSTRING(WR_WKCTR,1,3) = "104" THEN OP11 = "→装配油漆".
           IF SUBSTRING(WR_WKCTR,1,2) = "10" AND SUBSTRING(WR_WKCTR,1,3) <> "104" THEN OP11 = "→装配".
           IF SUBSTRING(WR_WKCTR,1,2) = "12" THEN OP11 = "→工具".
           IF SUBSTRING(WR_WKCTR,1,2) = "13" THEN OP11 = "→机修动力".
           IF SUBSTRING(WR_WKCTR,1,2) = "99" THEN OP11 = "→外协".                          
        
           end.
           END.
           END.
           END.
           END.
           END.                          
           END.
           END.
           END.
           END.
           END.
           IF OPB = "95" THEN DO:
             FIND LAST WR_ROUTE WHERE ((WR_PART = WO_PART AND WR_LOT = WO_LOT ) AND SUBSTRING(WR_WKCTR,5,2) = "95") 
/*SS 20090206 - B*/
						and wr_domain = global_domain
/*SS 20090206 - E*/
                  AND  (WR_wkctr >= wkctr and WR_wkctr <= wkctr1) NO-LOCK NO-ERROR.
              IF AVAILABLE WR_ROUTE THEN OPC = "95".
              IF NOT AVAILABLE WR_ROUTE THEN OPC = "".
              END.

           IF OPB = "96" THEN DO:
             FIND LAST WR_ROUTE WHERE ((WR_PART = WO_PART AND WR_LOT = WO_LOT ) AND SUBSTRING(WR_WKCTR,5,2) = "96") 
/*SS 20090206 - B*/
						and wr_domain = global_domain
/*SS 20090206 - E*/
                  AND  (WR_wkctr >= wkctr and WR_wkctr <= wkctr1) NO-LOCK NO-ERROR.
              IF AVAILABLE WR_ROUTE THEN OPC = "96".
              IF NOT AVAILABLE WR_ROUTE THEN OPC = "".
              END.


           IF OPB = "99" THEN DO:
             FIND LAST WR_ROUTE WHERE ((WR_PART = WO_PART AND WR_LOT = WO_LOT ) AND SUBSTRING(WR_WKCTR,5,2) = "99") 
/*SS 20090206 - B*/
						and wr_domain = global_domain
/*SS 20090206 - E*/
                  AND  (WR_wkctr >= wkctr and WR_wkctr <= wkctr1) NO-LOCK NO-ERROR.
              IF AVAILABLE WR_ROUTE THEN OPC = "99".
              IF NOT AVAILABLE WR_ROUTE THEN OPC = "".
              END.

          IF OPB = "98" THEN DO:
             FIND LAST WR_ROUTE WHERE ((WR_PART = WO_PART AND WR_LOT = WO_LOT ) AND SUBSTRING(WR_WKCTR,5,2) = "98") 
/*SS 20090206 - B*/
						and wr_domain = global_domain
/*SS 20090206 - E*/
                  AND  (WR_wkctr >= wkctr and WR_wkctr <= wkctr1) NO-LOCK NO-ERROR.
              IF AVAILABLE WR_ROUTE THEN OPC = "98".
              IF NOT AVAILABLE WR_ROUTE THEN OPC = "".
              END.
           IF OPB = "97" THEN DO:
             FIND LAST WR_ROUTE WHERE ((WR_PART = WO_PART AND WR_LOT = WO_LOT ) AND SUBSTRING(WR_WKCTR,5,2) = "97") 
/*SS 20090206 - B*/
						and wr_domain = global_domain
/*SS 20090206 - E*/
                  AND  (WR_wkctr >= wkctr and WR_wkctr <= wkctr1) NO-LOCK NO-ERROR.
              IF AVAILABLE WR_ROUTE THEN OPC = "97".
              IF NOT AVAILABLE WR_ROUTE THEN OPC = "".
              END.
    FIND LAST WR_ROUTE WHERE WR_PART = WO_PART AND WR_LOT = WO_LOT 
/*SS 20090206 - B*/
						and wr_domain = global_domain
/*SS 20090206 - E*/    
    NO-LOCK NO-ERROR.
               opa = WR_wkctr.  
    FIND first WR_ROUTE WHERE WR_PART = WO_PART AND WR_LOT = WO_LOT 
/*SS 20090206 - B*/
						and wr_domain = global_domain
/*SS 20090206 - E*/    
    NO-LOCK NO-ERROR.
               opAa = WR_wkctr.  

               
               
                       
     FIND FIRST WR_ROUTE WHERE ((WR_PART = WO_PART AND WR_LOT = WO_LOT) AND (WR_WKCTR MATCHES "*95" OR WR_WKCTR MATCHES "*96" OR WR_WKCTR MATCHES "*99" OR WR_WKCTR MATCHES "*98" OR WR_WKCTR MATCHES "*97"))
/*SS 20090206 - B*/
						and wr_domain = global_domain
/*SS 20090206 - E*/
                 no-lock no-error.
          IF AVAILABLE WR_ROUTE AND WR_QTY_COMP >= WR_QTY_ORD THEN OP1 = "(" + OP1 + ")".
         
      FIND NEXT WR_ROUTE WHERE ((WR_PART = WO_PART AND WR_LOT = WO_LOT) AND (WR_WKCTR MATCHES "*95" OR WR_WKCTR MATCHES "*96" OR WR_WKCTR MATCHES "*99" OR WR_WKCTR MATCHES "*98" OR WR_WKCTR MATCHES "*97"))
/*SS 20090206 - B*/
						and wr_domain = global_domain
/*SS 20090206 - E*/
                 no-lock no-error.
          IF AVAILABLE WR_ROUTE AND WR_QTY_COMP >= WR_QTY_ORD THEN OP2 = SUBSTRING(OP2,1,1) + "(" + SUBSTRING(OP2,2,5)+ ")".
      FIND NEXT WR_ROUTE WHERE ((WR_PART = WO_PART AND WR_LOT = WO_LOT) AND (WR_WKCTR MATCHES "*95" OR WR_WKCTR MATCHES "*96" OR WR_WKCTR MATCHES "*99" OR WR_WKCTR MATCHES "*98" OR WR_WKCTR MATCHES "*97"))
/*SS 20090206 - B*/
						and wr_domain = global_domain
/*SS 20090206 - E*/
                 no-lock no-error.
          IF AVAILABLE WR_ROUTE AND WR_QTY_COMP >= WR_QTY_ORD THEN OP3 = SUBSTRING(OP3,1,1) + "(" + SUBSTRING(OP3,2,5)+ ")".
      FIND NEXT WR_ROUTE WHERE ((WR_PART = WO_PART AND WR_LOT = WO_LOT) AND (WR_WKCTR MATCHES "*95" OR WR_WKCTR MATCHES "*96" OR WR_WKCTR MATCHES "*99" OR WR_WKCTR MATCHES "*98" OR WR_WKCTR MATCHES "*97"))
/*SS 20090206 - B*/
						and wr_domain = global_domain
/*SS 20090206 - E*/
                 no-lock no-error.
          IF AVAILABLE WR_ROUTE AND WR_QTY_COMP >= WR_QTY_ORD THEN OP4 = SUBSTRING(OP4,1,1) + "(" + SUBSTRING(OP4,2,5)+ ")".
      FIND NEXT WR_ROUTE WHERE ((WR_PART = WO_PART AND WR_LOT = WO_LOT) AND (WR_WKCTR MATCHES "*95" OR WR_WKCTR MATCHES "*96" OR WR_WKCTR MATCHES "*99" OR WR_WKCTR MATCHES "*98" OR WR_WKCTR MATCHES "*97"))
/*SS 20090206 - B*/
						and wr_domain = global_domain
/*SS 20090206 - E*/
                 no-lock no-error.
          IF AVAILABLE WR_ROUTE AND WR_QTY_COMP >= WR_QTY_ORD THEN OP5 = SUBSTRING(OP5,1,1) + "(" + SUBSTRING(OP5,2,5)+ ")".
      FIND NEXT WR_ROUTE WHERE ((WR_PART = WO_PART AND WR_LOT = WO_LOT) AND (WR_WKCTR MATCHES "*95" OR WR_WKCTR MATCHES "*96" OR WR_WKCTR MATCHES "*99" OR WR_WKCTR MATCHES "*98" OR WR_WKCTR MATCHES "*97"))
/*SS 20090206 - B*/
						and wr_domain = global_domain
/*SS 20090206 - E*/
                 no-lock no-error.
          IF AVAILABLE WR_ROUTE AND WR_QTY_COMP >= WR_QTY_ORD THEN OP6 = SUBSTRING(OP6,1,1) + "(" + SUBSTRING(OP6,2,5)+ ")".
      FIND NEXT WR_ROUTE WHERE ((WR_PART = WO_PART AND WR_LOT = WO_LOT) AND (WR_WKCTR MATCHES "*95" OR WR_WKCTR MATCHES "*96" OR WR_WKCTR MATCHES "*99" OR WR_WKCTR MATCHES "*98" OR WR_WKCTR MATCHES "*97"))
/*SS 20090206 - B*/
						and wr_domain = global_domain
/*SS 20090206 - E*/
                 no-lock no-error.
          IF AVAILABLE WR_ROUTE AND WR_QTY_COMP >= WR_QTY_ORD THEN OP7 = SUBSTRING(OP7,1,1) + "(" + SUBSTRING(OP7,2,5)+ ")".
      FIND NEXT WR_ROUTE WHERE ((WR_PART = WO_PART AND WR_LOT = WO_LOT) AND (WR_WKCTR MATCHES "*95" OR WR_WKCTR MATCHES "*96" OR WR_WKCTR MATCHES "*99" OR WR_WKCTR MATCHES "*98" OR WR_WKCTR MATCHES "*97"))
/*SS 20090206 - B*/
						and wr_domain = global_domain
/*SS 20090206 - E*/
                 no-lock no-error.
          IF AVAILABLE WR_ROUTE AND WR_QTY_COMP >= WR_QTY_ORD THEN OP8 = SUBSTRING(OP8,1,1) + "(" + SUBSTRING(OP8,2,5)+ ")".
      FIND NEXT WR_ROUTE WHERE ((WR_PART = WO_PART AND WR_LOT = WO_LOT) AND (WR_WKCTR MATCHES "*95" OR WR_WKCTR MATCHES "*96" OR WR_WKCTR MATCHES "*99" OR WR_WKCTR MATCHES "*98" OR WR_WKCTR MATCHES "*97"))
/*SS 20090206 - B*/
					and wr_domain = global_domain
/*SS 20090206 - E*/
                 no-lock no-error.
          IF AVAILABLE WR_ROUTE AND WR_QTY_COMP >= WR_QTY_ORD THEN OP9 = SUBSTRING(OP9,1,1) + "(" + SUBSTRING(OP9,2,5)+ ")".

     
          
          
  
           OP = op1 + op2 + OP3 + OP4 + OP5 + OP6 + OP7 + OP8 + OP9.
   
    find pt_mstr where pt_part = wo_part  
/*SS 20090206 - B*/
			and pt_domain = global_domain
/*SS 20090206 - E*/    
    no-lock no-error.
    if available pt_mstr then desc1 = trim(pt_desc1) + trim(pt_desc2).
    if (available pt_mstr and pt_loc <> "")
       AND (SUBSTRING(PT_LOC,1,2) <> "31") THEN loc = pt_loc.
       ELSE do:
      find  ld_det where (ld_part = wo_part and ld_site = "10000")
/*SS 20090206 - B*/
				and ld_domain = global_domain
/*SS 20090206 - E*/
       and (substring(ld_loc,2,1) <> "F" and substring(ld_loc,3,2) <> "ls")
       and (substring(LD_LOC,3,2) <> "FF" and substring(ld_loc,3,2) <> "sb")
       and (substring(ld_loc,3,2) <> "pj") no-lock no-error.
      if available ld_det then loc = ld_loc.
      IF NOT AVAILABLE LD_DET THEN LOC = "".
    end.
       
               
         if page-size - line-counter < 2 and available pt_mstr
           then page.
                          
               if ((opb <> "" and opb = opC) or opb = "")  and (open_ref > 0 AND AVAILABLE PT_MSTR) then 
                 {gpsct03.i &cost=sct_cst_tot}
                       create tmp.
                      assign  tmp_userid = mfguser
                               tmp_PART = WO_PART
                               tmp_DESC1  = DESC1 
                               TMP_UM = PT_UM
                               TMP_BUYER = PT_BUYER
                               TMP_LOC = LOC
                               TMP_NBR = WO_NBR
                               TMP_LOT = WO_LOT
                               tmp_rel_date = wo_rel_date
                               tmp_due_date = wo_due_date
                               TMP_STATUS = WO_STATUS
                               tmp_QTY_ORD = WO_QTY_ORD
                               tmp_QTY_COMP = WO_QTY_COMP
                               tmp_qty_rjct = wo_qty_rjct
                               tmp_wkctr = wkctr2
                               TMP_OPB = OPC
                               TMP_OPA = OPA
                               TMP_OPAA = OPAA
                               tmp_OP = OP.

               
/*GUI*/ {mfrpexit.i}
       
               end . /*end for variable ro_det*/
            end.   /* END FOR EACH WOD_DET...   */
            
/*************************************************************/            
/*************************************************************/
            
FOR EACH TMP WHERE ((TMP_OPB = OPB AND OPB <> "") OR OPB = "") 
 AND (TMP_BUYER >= BUYER AND TMP_BUYER <= BUYER1)
 and (tmp_nbr >= nbr and tmp_nbr <= nbr1)
 and (tmp_lot >= lot and tmp_lot <= lot1)
 and (tmp_wkctr >= wkctr and tmp_wkctr <= wkctr1)
 and (TMP_status = XZ OR (TMP_STATUS <> "C" AND XZ = "")) :
open_ref = max(TMP_qty_ORD - (max(TMP_qty_COMP,0) + max(TMP_qty_rjct,0)),0).
 REL_DATE2 = TMP_REL_DATE.
 DUE_DATE2 = TMP_DUE_DATE.
     BZ = "".
    for each WOD_DET where WOD_LOT = TMP_LOT
/*SS 20090206 - B*/
			and wod_domain = global_domain
/*SS 20090206 - E*/    
    :
    FIND PT_MSTR WHERE  PT_PART = WOD_PART AND PT_PM_CODE = "M" 
 /*SS 20090206 - B*/
 		and pt_domain = global_domain
 /*SS 20090206 - E*/   
    NO-LOCK NO-ERROR.
    IF AVAILABLE PT_MSTR THEN BZ = "1".
    IF AVAILABLE PT_MSTR AND WOD_PART  MATCHES "*-M" THEN BZ = "".
    END. /*END FOR EACH WOD_DET*/


 
    
    
    IF BZ = "1" THEN DO:
        FIND IN_MSTR WHERE IN_PART = TMP_PART AND IN_SITE = "10000" 
/*SS 20090206 - B*/
						and in_domain = global_domain
/*SS 20090206 - E*/
                NO-LOCK NO-ERROR.
put "" skip.                
put " 父零件号            描述                                       单位  采计     库位      库存      状态  加工单号           标志号   单位用量       订货量       已完成量     短缺量   首工序   交库类型 下达日期 到期日   工艺流程                                                     首工序描述" at 1 skip.
put " ------------------- ------------------------------------------ ---- -------- -------- ----------- ---- ------------------ -------- --------- -------------- -------------- ---------- -------- -------- -------- -------- ------------------------------------------------------------ ------------------------" at 1 skip.
/*    123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890*/
/*             1         2         3         4         5         6         7         8         9         10        11        12        13        14        15        16        17        18        19        20             */
     put     TMP_PART at 1
             TMP_DESC1 at 22
             TMP_UM at 65
             TMP_BUYER at 70
             TMP_LOC  at 79
             IN_QTY_OH  format "->>>,>>9.99" at 88
             TMP_STATUS  at 100
             TMP_NBR at 105
             TMP_LOT at 124
             TMP_BOM_QTY  at 132
             TMP_QTY_ORD at 142
             TMP_QTY_COMP at 157
             OPEN_REF at 172
             TMP_OPAA at 184
             TMP_OPA at 193
             tmp_rel_date at 202
             tmp_due_date at 211
             TMP_OP at 220
             skip.
             put "子零件：" at 2 skip.
           FOR EACH WOD_DET WHERE WOD_LOT = TMP_LOT
/*SS 20090206 - B*/
						and wod_domain = global_domain
/*SS 20090206 - E*/
           BREAK BY WOD_PART BY WOD_LOT:
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
  FIND PT_MSTR WHERE PT_PART = WOD_PART  
/*SS 20090206 - B*/
	and pt_domain = global_domain
/*SS 20090206 - E*/  
  NO-LOCK NO-ERROR.
  find first ro_det where (ro_routing = woD_part AND PT_PM_CODE = "M")
                  and (((ro_wkctr >= wkctr and ro_wkctr <= wkctr1) AND XZ2 = "Y") OR XZ2 = "N")
/*SS 20090206 - B*/
		and ro_domain = global_domain
/*SS 20090206 - E*/
          no-lock no-error.
           IF AVAILABLE RO_DET THEN DO:
           FIND FIRST RO_DET WHERE RO_ROUTING = WOD_PART 
/*SS 20090206 - B*/
						and ro_domain = global_domain
/*SS 20090206 - E*/           
           NO-LOCK NO-ERROR.
                IF AVAILABLE RO_DET THEN OP1 = SUBSTRING(RO_WKCTR,1,3) .
                           
           FIND NEXT RO_DET WHERE RO_ROUTING = WOD_PART AND SUBSTRING(RO_WKCTR,1,3) <> SUBSTRING(OP1,1,3) 
/*SS 20090206 - B*/
						and ro_domain = global_domain
/*SS 20090206 - E*/                      
           NO-LOCK NO-ERROR.
                IF AVAILABLE RO_DET THEN OP2 = "→" + SUBSTRING(RO_WKCTR,1,3) .
                
           FIND NEXT RO_DET WHERE RO_ROUTING = WOD_PART AND SUBSTRING(RO_WKCTR,1,3) <> SUBSTRING(OP2,2,4) 
/*SS 20090206 - B*/
						and ro_domain = global_domain
/*SS 20090206 - E*/                      
           NO-LOCK NO-ERROR.
                IF AVAILABLE RO_DET THEN OP3 = "→" + SUBSTRING(RO_WKCTR,1,3) .
                
           FIND NEXT RO_DET WHERE RO_ROUTING = WOD_PART AND SUBSTRING(RO_WKCTR,1,3) <> SUBSTRING(OP3,2,4) 
/*SS 20090206 - B*/
						and ro_domain = global_domain
/*SS 20090206 - E*/                      
           NO-LOCK NO-ERROR.
                IF AVAILABLE RO_DET THEN OP4 = "→" + SUBSTRING(RO_WKCTR,1,3) .
           
           FIND NEXT RO_DET WHERE RO_ROUTING = WOD_PART AND SUBSTRING(RO_WKCTR,1,3) <> SUBSTRING(OP4,2,4) 
/*SS 20090206 - B*/
						and ro_domain = global_domain
/*SS 20090206 - E*/                      
           NO-LOCK NO-ERROR.
                IF AVAILABLE RO_DET THEN OP5 = "→" + SUBSTRING(RO_WKCTR,1,3) .
                
           FIND NEXT RO_DET WHERE RO_ROUTING = WOD_PART AND SUBSTRING(RO_WKCTR,1,3) <> SUBSTRING(OP5,2,4) 
/*SS 20090206 - B*/
						and ro_domain = global_domain
/*SS 20090206 - E*/                      
           NO-LOCK NO-ERROR.
                IF AVAILABLE RO_DET THEN OP6 = "→" + SUBSTRING(RO_WKCTR,1,3) .         
                
           FIND NEXT RO_DET WHERE RO_ROUTING = WOD_PART AND SUBSTRING(RO_WKCTR,1,3) <> SUBSTRING(OP6,2,4) 
/*SS 20090206 - B*/
						and ro_domain = global_domain
/*SS 20090206 - E*/                      
           NO-LOCK NO-ERROR.
                IF AVAILABLE RO_DET THEN OP7 = "→" + SUBSTRING(RO_WKCTR,1,3) .     
                    
           FIND NEXT RO_DET WHERE RO_ROUTING = WOD_PART AND SUBSTRING(RO_WKCTR,1,3) <> SUBSTRING(OP7,2,4) 
/*SS 20090206 - B*/
						and ro_domain = global_domain
/*SS 20090206 - E*/                      
           NO-LOCK NO-ERROR.
                IF AVAILABLE RO_DET THEN OP8 = "→" + SUBSTRING(RO_WKCTR,1,3) .    
                
           FIND NEXT RO_DET WHERE RO_ROUTING = WOD_PART AND SUBSTRING(RO_WKCTR,1,3) <> SUBSTRING(OP8,2,4)
/*SS 20090206 - B*/
						and ro_domain = global_domain
/*SS 20090206 - E*/                      
            NO-LOCK NO-ERROR.
                IF AVAILABLE RO_DET THEN OP9 = "→" + SUBSTRING(RO_WKCTR,1,3) .        
                
           FIND NEXT RO_DET WHERE RO_ROUTING = WOD_PART AND SUBSTRING(RO_WKCTR,1,3) <> SUBSTRING(OP9,2,4) 
/*SS 20090206 - B*/
						and ro_domain = global_domain
/*SS 20090206 - E*/                      
           NO-LOCK NO-ERROR.
                IF AVAILABLE RO_DET THEN OP10 = "→" + SUBSTRING(RO_WKCTR,1,3) .                                        
                
           FIND NEXT RO_DET WHERE RO_ROUTING = WOD_PART AND SUBSTRING(RO_WKCTR,1,3) <> SUBSTRING(OP10,2,4) 
/*SS 20090206 - B*/
						and ro_domain = global_domain
/*SS 20090206 - E*/                      
           NO-LOCK NO-ERROR.
                IF AVAILABLE RO_DET THEN OP11 = "→" + SUBSTRING(RO_WKCTR,1,3) .                     
                
                
           FIND IN_MSTR WHERE IN_PART = WOD_PART AND IN_SITE = "10000" 
/*SS 20090206 - B*/
						and in_domain = global_domain
/*SS 20090206 - E*/
                NO-LOCK NO-ERROR.
                
           FIND PT_MSTR WHERE PT_PART = WOD_PART 
/*SS 20090206 - B*/
							and pt_domain = global_domain
/*SS 20090206 - E*/           
           NO-LOCK NO-ERROR.
        if available pt_mstr then desc1 = trim(pt_desc1) + trim(pt_desc2).

              
        OP = OP1 + OP2 +  OP3 +  OP4 + OP5 + OP6 + OP7 + OP8 + OP9 + OP10 + OP11.
        FIND LAST RO_DET WHERE RO_ROUTING = WOD_PART 
/*SS 20090206 - B*/
				and ro_domain = global_domain
/*SS 20090206 - E*/        
        NO-LOCK NO-ERROR.
        IF AVAILABLE RO_DET THEN opa = ro_wkctr.  
        FIND FIRST RO_DET WHERE RO_ROUTING = WOD_PART 
/*SS 20090206 - B*/
					and ro_domain = global_domain
/*SS 20090206 - E*/        
        NO-LOCK NO-ERROR.
        IF AVAILABLE RO_DET THEN OPAA = RO_WKCTR.
       if (available pt_mstr and pt_loc <> "")
          AND (SUBSTRING(PT_LOC,1,2) <> "31") THEN loc = pt_loc.
          ELSE  do:
         find  ld_det where (ld_part = woD_part and ld_site = "10000")
/*SS 20090206 - B*/
					and ld_domain = global_domain
/*SS 20090206 - E*/
         and (substring(ld_loc,2,1) <> "F" and substring(ld_loc,3,2) <> "ls")
         and (substring(LD_LOC,3,2) <> "FF" and substring(ld_loc,3,2) <> "sb")
         and (substring(ld_loc,3,2) <> "pj") no-lock no-error.
         if available ld_det then loc = ld_loc.
         IF NOT AVAILABLE LD_DET THEN LOC = "".
         end.
     
             if xz1 = "y" then do:
           FIND  WO_MSTR WHERE WO_PART = WOD_PART 
/*SS 20090206 - B*/
						and wo_domain = global_domain
/*SS 20090206 - E*/
           AND ((WO_STATUS = XZ and xz <> "") OR (WO_STATUS <> "C" AND XZ = ""))
           AND WO_DUE_DATE <= tmp_due_dATE /*AND WO_DUE_DATE <= TMP_DUE_DATE*/ 
           AND ((WO_NBR = TMP_NBR AND XZ3 = "Y") OR XZ3 = "N" ) NO-LOCK NO-ERROR.
       if available wo_mstr then open_ref = max(WO_qty_ORD - max(WO_qty_COMP,0),0).  
          
           put WOD_PART   at 1
           DESC1  at 22
           PT_UM  at 65
           PT_BUYER  at 70
           LOC   at 79
           IN_QTY_OH format "->>>,>>9.99" at 87.
          if available wo_mstr then put WO_STATUS at 100 .
          if available wo_mstr then put WO_NBR at 105 .
          if available wo_mstr then  put WO_LOT at 124.
          put WOD_BOM_QTY  FORMAT ">,>>9.99" at 132.
          if available wo_mstr then  put WO_QTY_ORD  format "->>,>>>,>>9.99" at 142 .
          if available wo_mstr then  put WO_QTY_COMP format "->>,>>>,>>9.99" at 157 .
          if available wo_mstr then  put OPEN_REF  at 172.
          put OPAA at 184.
          put opa at 193.
          if available wo_mstr then  put    wo_rel_date at 202.
          if available wo_mstr then  put    wo_due_date at 211.
            put  OP at 220 .
            IF AVAILABLE RO_DET THEN PUT RO_DESC AT 282
              skip. 
  
         
         END. /* FOR EACH xz1="y"*/
     
        if xz1 = "n" then do:
         for each  WO_MSTR WHERE  WO_PART = WOD_PART
/*SS 20090206 - B*/
						and wo_domain = global_domain
/*SS 20090206 - E*/
           AND ((WO_STATUS = XZ and xz <> "") OR (WO_STATUS <> "C" AND XZ = ""))
           AND ((XZ3 = "Y" AND WO_NBR = TMP_NBR ) OR XZ3="N") :
          if available wo_mstr then open_ref = max(WO_qty_ORD - max(WO_qty_COMP,0),0).  
   
           put WOD_PART   at 1
           DESC1  at 22
           PT_UM  at 65
           PT_BUYER  at 70
           LOC   at 79
           IN_QTY_OH format "->>>,>>9.99" at 87
           WO_STATUS at 100 
           WO_NBR at 105 
           WO_LOT at 124
           WOD_BOM_QTY  FORMAT ">,>>9.99" at 132
           WO_QTY_ORD  format "->>,>>>,>>9.99" at 142
           WO_QTY_COMP format "->>,>>>,>>9.99" at 157 
           OPEN_REF  at 172
           OPAA at 184
           opa at 193
           wo_rel_date at 202
           wo_due_date at 211
           OP at 220.
             IF AVAILABLE RO_DET THEN PUT RO_DESC AT 282
           skip. 
      end. /*end for each wo_mstr */
         end. /*end for xz1 ="n"*/
           END . /*FOR EACH AVAILABLE RO_DET*/
     END. /*END FOR EACH WOD_DET*/
END . /*END FOR BZ="1"*/
    

END. /*END FOR EACH TMP*/

            /* REPORT TRAILER  */
            
/*GUI*/ {mfrtrail.i}

/*GUI*/ {mfgrptrm.i} /*Report-to-Window*/


         end.  /* END REPEAT LOOP   */

/*K0YQ*/ {wbrp04.i &frame-spec = a}

/*GUI*/ end . /*p-report*/
