/* GUI CONVERTED from poporp.p (converter v1.71) Thu Jul 16 13:58:34 1998 */
/* poporp.p - PURCHASE ORDER REPORT BY ORDER                            */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/* web convert poporp.p (converter v1.00) Fri Oct 10 13:57:14 1997 */
/* web tag in poporp.p (converter v1.00) Mon Oct 06 14:17:37 1997 */
/*F0PN*/ /*K0M3*/ /*V8#ConvertMode=WebReport                            */
/*V8:ConvertMode=FullGUIReport                                 */
/* REVISION: 6.0     LAST MODIFIED: 04/18/90    BY: PML *D001**/
/* REVISION: 6.0     LAST MODIFIED: 10/22/90    BY: RAM *D125**/
/* REVISION: 6.0     LAST MODIFIED: 10/31/90    BY: pml *D157**/
/* REVISION: 6.0     LAST MODIFIED: 01/02/91    BY: RAM *D282**/
/* REVISION: 6.0     LAST MODIFIED: 03/19/91    BY: bjb *D461**/
/* REVISION: 7.0     LAST MODIFIED: 03/18/92    BY: TMD *F261** (rev only) */
/* REVISION: 7.3     LAST MODIFIED: 02/18/93    BY: tjs *G704** (rev only) */
/* REVISION: 7.3     LAST MODIFIED: 10/31/94    BY: ame *GN82**/
/* REVISION: 8.5     LAST MODIFIED: 09/27/95    BY: taf *J053**/
/* REVISION: 8.5     LAST MODIFIED: 04/08/96    BY: jzw *G1LD**/
/* REVISION: 8.6     LAST MODIFIED: 11/21/96    BY: *K022* Tejas Modi   */
/* REVISION: 8.6     LAST MODIFIED: 04/03/97    BY: *K09K* Arul Victoria */
/* REVISION: 8.6     LAST MODIFIED: 10/11/97    BY: mur *K0M3**/
/* REVISION: 8.6E    LAST MODIFIED: 02/23/98    BY: *L007* A. Rahane */
/* REVISION: 8.6E    LAST MODIFIED: 06/11/98    BY: *L020* Charles Yen   */
/*By: Neil Gao 09/02/07 ECO: *SS 20090207* */

/* ********** Begin Translatable Strings Definitions ********* */


/*GUI global preprocessor directive settings */
&GLOBAL-DEFINE PP_PGM_RP TRUE
&GLOBAL-DEFINE PP_ENV_GUI TRUE


/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

         {mfdtitle.i "e+ "} /*GUI moved to top.*/
&SCOPED-DEFINE popoIQ_p_1 "短缺量"
/* MaxLen: Comment: */

&SCOPED-DEFINE popoIQ_p_2 "只打印未结采购单"
/* MaxLen: Comment: */

&SCOPED-DEFINE popoIQ_p_3 "汇总金额"
/* MaxLen: Comment: */
/* ********** End Translatable Strings Definitions ********* */

         /* DISPLAY TITLE */
/*GUI moved mfdeclre/mfdtitle.*/

         {gppopp.i}

define variable vend like po_vend.
define variable vend1 like po_vend.
define variable nbr like po_nbr.
define variable nbr1 like po_nbr.
define variable nbr2 like Wo_nbr.
define variable nbr3 like Wo_nbr.
define variable nbr4 like Wo_nbr.
define variable LOT like WO_LOT.
define variable LOT1 like WO_LOT.


define variable due like po_due_date.
define variable due1 like po_due_date.
define variable ord   like po_ord_date.
define variable ord1   like po_ord_date.
define variable buyer like po_buyer.
define variable buyer1 like po_buyer.
define variable req   like pod_req_nbr.
define variable req1   like pod_req_nbr.
define variable sord like pod_so_job.
define variable open_ref like pod_qty_ord label {&popoiq_p_1}.
define variable part like pt_part.
define variable part1 like pt_part.
define variable DESC1 like pt_DESC1.
define variable DESC2 like pt_DESC2.
define variable work_ord like pod_wo_lot.
define variable getall like mfc_logical initial YES label {&popoiq_p_2}.
define variable ext_cost like pod_pur_cost label {&popoIQ_p_3}  format "->,>>>,>>>,>>9.99".
define variable ext_cost1 like pod_pur_cost label {&popoIQ_p_3} format "->,>>>,>>>,>>9.99".
define variable pur_cost like pod_pur_cost format "->,>>>,>>>,>>9.99".
define variable price_1 like sct_mtl_tl format "->>>>>>9.99".
define variable name1 like ad_name.
define variable line1 like ad_line1.
define variable ex_rate2 like po_nbr.
define variable descc AS CHARACTER FORMAT "X(42)". 
/*define new shared variable po_recno as recid.
define variable yn like mfc_logical initial yes.*/
/*L020*/ {gprunpdf.i "mcpl" "p"}

         
/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
					 	PART        colon 20
            PART1      label {t001.i} colon 49 skip

vend           colon 20

            vend1          label {t001.i} colon 49 skip
            nbr            colon 20
            nbr1           label {t001.i} colon 49 skip
          /*  nbr3            colon 20
            nbr4           label {t001.i} colon 49 skip*/
            LOT            colon 20
            LOT1           label {t001.i} colon 49 skip
            due            colon 20
            due1           label {t001.i} colon 49 skip
            ord            colon 20
            ord1           label {t001.i} colon 49 skip

            buyer          colon 20
            buyer1         label {t001.i} colon 49 skip
            req            colon 20
            req1           label {t001.i} colon 49 skip
            GETALL            colon 20

          SKIP(.4)  /*GUI*/
with frame a side-labels width 80 attr-space.

setFrameLabels(frame a:handle).

/*GUI preprocessor Frame A undefine */
&UNDEFINE PP_FRAME_NAME

   
         {wbrp01.i}
repeat : 

/*  Remove remnants from last iteration.    */
            find first po_wkfl no-error.
            if available po_wkfl then
               for each po_wkfl exclusive-lock:
                  delete po_wkfl.
               end.

            if nbr1 = hi_char then nbr1 = "".
            if nbr4 = hi_char then nbr4 = "".
            if LOT1 = hi_char then LOT1 = "".

            if vend1 = hi_char then vend1 = "".
            if part1 = hi_char then PART1 = "".
 /*IFP*/     if due1 = hi_date then due1 = ?.
/*IFP*/     if ord1 = hi_date then ord1 = ?.
/*IFP*/     if due = low_date then due = ?.
/*IFP*/     if ord = low_date then ord = ?.
            if buyer1 = hi_char then buyer1 = "".
            if req1   = hi_char then req1   = "".           
         if c-application-mode <> "WEB":U then
        


/*L020*/ /* CURRENCY CODE VALIDATION */
/*L020*/ 

        	update part part1  vend vend1 nbr nbr1  LOT LOT1 due due1
 						buyer buyer1 req req1 getall with frame a.

         if (c-application-mode <> "WEB":U) or
         (c-application-mode = "WEB":U and
         (c-web-request begins "DATA":U)) then do:

            bcdparm = "".
            {mfquoter.i vend       }
            {mfquoter.i vend1      }
            {mfquoter.i nbr        }
            {mfquoter.i nbr1       }
         /*   {mfquoter.i nbr3        }
            {mfquoter.i nbr4       }*/
            {mfquoter.i LOT        }
            {mfquoter.i LOT1       }

            
            {mfquoter.i due        }
            {mfquoter.i due1       }
            {mfquoter.i ord        }
            {mfquoter.i ord1       }

            
            {mfquoter.i part}
            {mfquoter.i part1  }            
            {mfquoter.i buyer      }
            {mfquoter.i buyer1     }
            {mfquoter.i req        }
            {mfquoter.i req1       }
            if nbr1 = "" then nbr1 = hi_char.
            if nbr4 = "" then nbr4 = hi_char.
            if LOT1 = "" then LOT1 = hi_char.
            if vend1 = "" then vend1 = hi_char.
            if part1 = "" then PART1 = hi_char.
            if ord1 = ? then due1 = hi_date.
            if  due1 = ? then due1 = hi_date.
/*IFP*/     if  ord1 = ? then ord1 = hi_date.
/*IFP*/     if  due = ? then due = low_date.
/*IFP*/     if  ord = ? then ord = low_date.
            if buyer1 = "" then buyer1 = hi_char.
            if req1   = "" then req1   = hi_char.
           

         end.
            /* SELECT PRINTER */

					{mfselbpr.i "printer" 132}
/*GUI*/   mainloop: do on error undo, return error on endkey undo, return error:
find first po_wkfl no-error.

 for each po_mstr where (po_nbr >= nbr) and (po_nbr <= nbr1)
/*SS 20090207 - B*/
			and po_domain = global_domain
/*SS 20090207 - E*/
      and (po_vend >= vend) and (po_vend <= vend1)   
      and (po_buyer >= buyer and po_buyer <= buyer1)  
      and (po_due_date >= due and po_due_date <= due1)
      and (po_ord_date >= ord and po_ord_date <= ord1)
      and  po_type <> "B" no-lock ,
    /*  and ((po_print = no and getall = yes ) or getall = no ) */
      each pod_det where pod_nbr = po_nbr 
/*SS 20090207 - B*/
					and pod_domain = global_domain
/*SS 20090207 - E*/
          and (pod_wo_lot >= LOT AND POD_WO_LOT <= LOT1)
          and (pod_part >= part and pod_part <= part1)
          and (pod_req_nbr  >= req and pod_req_nbr <= req1)
          and not pod_sched /*and pod_cc <> "0000"*/
          and ((pod_status <> "c" and pod_status <> "x" and getall = yes) or getall = no )
          no-lock break by po_vend by po_nbr  by pod_line by pod_part by po_buyer :
          /*po_recno = recid(po_mstr).*/
          
          
    find pt_mstr where pt_part = pod_part 
/*SS 20090207 - B*/
			and pt_domain = global_domain
/*SS 20090207 - E*/    
    no-lock no-error.
          if not available pt_mstr then do:
          
    find ad_mstr where ad_addr = po_ship 
/*SS 20090207 - B*/
		and ad_domain = global_domain
/*SS 20090207 - E*/    
    no-lock no-error.
       if available ad_mstr then do:
           name1 = ad_name.
           line1 = ad_line1.
           end.
       
          find ad_mstr where ad_mstr.ad_addr = po_vend 
/*SS 20090207 - B*/
					and ad_domain = global_domain
/*SS 20090207 - E*/          
          no-lock no-error.  
          
    if first-of (po_nbr)  or page-size - line-counter < 2 then do:
    if substring(string(po_ex_rate2),1,1) = "." then ex_rate2 = "0" + string(po_ex_rate2).
    if substring(string(po_ex_rate2),1,1) <> "." then ex_rate2 = string(po_ex_rate2).

        /*  {mfphead.i}*/
           page.
           put "打印日期:" at 70 today.
           put skip(1).
      put "                             贵州詹阳动力重工有限公司"at 2  "页号:" at 70
                   string(page-number)  skip .
      put "                                   行政采购合同" at 2.
      put " " at 2 skip.                                               
      put "采 购 单:" at 2 po_nbr    "订货日期:" at 24  po_ord_date      "到 期 日:" at 64 po_due_dat.       
      put "供 应 商:" at 2 po_vend   "名    称:" at 24 ad_name           "联 系 人:" at 64 po_contact.
      put "货物发往:" at 2 po_ship   "名    称:" at 24  name1            "地    址:" at 64 line1.
      put "开户银行:交通银行贵阳分行小河支行" at 24   "税    号: 52011478016884X" at 64 .
      put "帐    号:521146000018150008733" at 24      "电    话:3898827" at 64.
      put "采 购 员:"at 2 po_buyer   "合 同 号:" at 24 po_contract  "应付帐户:" at 64 po_ap_acct " " po_ap_cc.       
      put "控 制 号:" at 2 po_rmk                   "支付方式:" at 64 po_cr_terms .   
      put "付 款 日" at 2         "货    币:" at 24 po_curr   "兑 换 率:"at 64 " " string(po_ex_rate) + " : "  ex_rate2 .
      
             put skip(1).
     put "序  单   订货量   采购单价     金额合计     采购帐户            采购帐户 成本中心        " at 2 skip .
     put "号  位            (不含税)     (不含税)     成本中心                   描述              " at 2 skip.
     put "--  -- ---------- --------- ------------- -------------- ---------------------------------" at 2 skip.
      end.

  
                                                                                                                                         
      open_ref = pod_qty_ord - pod_qty_rcvd.
      ext_cost = open_REF * pod_pur_cost.
      ext_cost1 = ext_cost .
     find cc_mstr where cc_ctr = pod_cc 
/*SS 20090207 - B*/
				and cc_domain = global_domain
/*SS 20090207 - E*/     
     no-lock no-error.
     find Ac_mstr where Ac_CODE = pod_AccT 
/*SS 20090207 - B*/
				and ac_domain = global_domain
/*SS 20090207 - E*/     
     no-lock no-error .
  FIND WO_MSTR WHERE WO_LOT = POD_WO_LOT 
/*SS 20090207 - B*/
			and wo_domain = global_domain
/*SS 20090207 - E*/  
  NO-LOCK NO-ERROR.
        IF AVAILABLE WO_MSTR THEN NBR2 = WO_NBR.
        ELSE  NBR2 = "".   
 accumulate ext_cost (total by PO_NBR).
  accumulate open_ref (total by POD_PART).
   accumulate ext_cost1 (total by POD_PART).
   if pod_desc <> "零件无库存" then descc = (pod_part + POD_DESC).
   else descc = pod_part.
 /* not first-of(po_nbr) then*/
 if first-of (pod_part) then put "项目:" at 2 descc.
 /*(pod_part + " " + (POD_DESC)). */
        put  
     POd_line at 1  
     pod_um at 6 
     open_ref format "->>>>>>9.9<" at 8
     pod_pur_cost format "->>>>>9.9<"  at 20
     EXT_COST  format "->,>>>,>>9.99" at 30
     pod_acct at 45
     pod_cc at 54
     ac_desc at 59
     cc_desc AT 84.
     
     put "" skip.

   IF LAST-OF(POD_PART) AND (((accum total by POD_PART (ext_cost1)) <> (accum total by PO_NBR (ext_cost))) OR NOT LAST (POD_PART))  THEN DO:
     PUT "-----------" AT 8 "-------------" AT 30 .
     PUT  (accum total by POD_PART (open_ref)) format "->,>>>,>>9.99" AT 6 (accum total by POD_PART (ext_cost1)) format "->>>,>>>,>>9.99" AT 28 .
     END.
  IF LAST-OF(PO_NBR) THEN DO:
     PUT "-------------" AT 30 .
     PUT "汇总金额" AT 18 (accum total by PO_NBR (ext_cost)) format "->>>,>>>,>>9.99" AT 28 .

     put " " at 2.
      PUT "合同货款总金额(含税)：人民币(大写)________________________________________________________________" at 2.
      put "" at 2.
      PUT "三    包   条   款 :______________________________________________________________________________" at 2.
      put "" at 2.
      put "运输方式 / 支付方式:______________________________________________________________________________" at 2 .
      put "" at 2 .
      put "备注栏: " at 2 .
      put "       送货时附上送货清单，清单列明采购单号、零件号、数量、单位;发票也需列出采购单号。" at 2.
      put "      --------------------------------------------------------------------------------------------" at 2.
      put "      " at 2.
      put "      --------------------------------------------------------------------------------------------" at 2.
      put "" at 2.
      put "      --------------------------------------------------------------------------------------------" at 2.
      put skip(1).
      put "批准人签名 :___________________" at 70.
      put skip(1).
    end.
 

  /* {gprun.i ""porp0301.p""}*/

   END.
   
   end.
  end.


            /* REPORT TRAILER  */
 {mfguirex.i }.
 {mfguitrl.i}.
 {mfgrptrm.i} .



end.

         {wbrp04.i &frame-spec = a}


