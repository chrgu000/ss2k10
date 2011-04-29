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
define variable part3 as CHARACTER FORMAT "x(10)".
define variable DESC1 like pt_DESC1.
define variable DESC2 like pt_DESC2.
define variable work_ord like pod_wo_lot.
define variable getall like mfc_logical initial YES label {&popoiq_p_2}.
define variable ext_cost like pod_pur_cost label {&popoIQ_p_3}  format "->,>>>,>>>,>>9.99".
define variable ext_cost1 like pod_pur_cost label {&popoIQ_p_3} format "->,>>>,>>>,>>9.99".
define variable pur_cost like pod_pur_cost format "->,>>>,>>>,>>9.99<<".
define variable price_1 like sct_mtl_tl format "->>>>>>9.99".
define variable name1 like ad_name.
define variable line1 like ad_line1.
define variable ex_rate2 like po_nbr.
define variable bz as CHARACTER FORMAT "x(78)".
define variable bz1 as CHARACTER FORMAT "x(78)".
define variable bz2 as CHARACTER FORMAT "x(78)".
define variable bz3 as CHARACTER FORMAT "x(50)".

/*define new shared variable po_recno as recid.
define variable yn like mfc_logical initial yes.*/
/*L020*/ {gprunpdf.i "mcpl" "p"}

         
/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
            
 RECT-FRAME       AT ROW 1.4 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
 SKIP(.1)  /*GUI*/
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
            GETALL            colon 20 skip
            "---------------------------------------------- 文本录入栏 ---------------------------------------------" colon 2
            bz3            label "合同货款总金额(含税)：人民币(大写)" colon 30
            bz             label "三包条款" colon 20
            bz1            label "运输方式/支付方式:"  colon 20 
            bz2            label "进货检验标准或要求:"  colon 20
            
          SKIP(.4)  /*GUI*/
with frame a side-labels width 210 attr-space NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-a-title AS CHARACTER.
 F-a-title = &IF (DEFINED(SELECTION_CRITERIA) = 0)
  &THEN " 选择条件 "
  &ELSE {&SELECTION_CRITERIA}
  &ENDIF .
 RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
 RECT-FRAME-LABEL:WIDTH-PIXELS in frame a =
  FONT-TABLE:GET-TEXT-WIDTH-PIXELS(
  RECT-FRAME-LABEL:SCREEN-VALUE in frame a + " ", RECT-FRAME-LABEL:FONT).
 RECT-FRAME:HEIGHT-PIXELS in frame a =
  FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5. /*GUI*/

/*GUI preprocessor Frame A undefine */
&UNDEFINE PP_FRAME_NAME

   
         {wbrp01.i}
     
/*GUI*/ {mfguirpa.i true  "printer" 132 }

/*GUI repeat : */
/*GUI*/ procedure p-enable-ui:


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
        
run p-action-fields (input "display").
run p-action-fields (input "enable").
end procedure. /* p-enable-ui, replacement of Data-Entry GUI*/

/*GUI*/ procedure p-report-quote:


/*L020*/ /* CURRENCY CODE VALIDATION */
/*L020*/ 

         {wbrp06.i &command = update &fields = " part part1  vend vend1 nbr nbr1  LOT LOT1 due due1
 buyer buyer1 req req1 getall bz bz1 BZ2" &frm = "a"}

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
     
/*GUI*/ end procedure. /* p-report-quote */
/*GUI - Field Trigger Section */

/*GUI MFSELxxx removed*/

/*GUI*/ procedure p-report:

/*GUI*/   {gpprtrpa.i  "printer" 132}
/*GUI*/   mainloop: do on error undo, return error on endkey undo, return error:
find first po_wkfl no-error.




  
        

 for each po_mstr where (po_nbr >= nbr) and (po_nbr <= nbr1)
      and (po_vend >= vend) and (po_vend <= vend1)   
      and (po_buyer >= buyer and po_buyer <= buyer1)  
      and (po_due_date >= due and po_due_date <= due1)
      and (po_ord_date >= ord and po_ord_date <= ord1)
      and  po_type <> "B" no-lock ,
    /*  and ((po_print = no and getall = yes ) or getall = no ) */
      each pod_det where pod_nbr = po_nbr 
          and (pod_wo_lot >= LOT AND POD_WO_LOT <= LOT1)
          and (pod_part >= part and pod_part <= part1)
          and (pod_req_nbr  >= req and pod_req_nbr <= req1)
          and not pod_sched
          and ((pod_status <> "c" and pod_status <> "x" and getall = yes) or getall = no )
          no-lock break by po_vend by po_nbr by pod_line by pod_part  by po_buyer :
          /*po_recno = recid(po_mstr).*/
    find ad_mstr where ad_addr = po_ship no-lock no-error.
       if available ad_mstr then do:
           name1 = ad_name.
           line1 = ad_line1.
           end.
       
          find ad_mstr where ad_mstr.ad_addr = po_vend no-lock no-error.  
              find PT_MSTR WHERE PT_PART = POD_PART no-lock no-error.     
              if available pt_mstr then do:
    if first-of (po_nbr) or page-size - line-counter < 2 then do:
    if substring(string(po_ex_rate2),1,1) = "." then ex_rate2 = "0" + string(po_ex_rate2).
    if substring(string(po_ex_rate2),1,1) <> "." then ex_rate2 = string(po_ex_rate2).

        /*  {mfphead.i}*/
           page.
           put "打印日期:" at 70 today.
           put skip(1).
      put "                             贵州詹阳动力重工有限公司"at 2  "页号:" at 70
                   string(page-number)  skip .
      put "                                   采购合同" at 2.

      find PT_MSTR WHERE PT_PART = POD_PART no-lock no-error.                 
      put " " at 2 skip.                                               
      put "采 购 单:" at 2 po_nbr    "订货日期:" at 24  po_ord_date .
      if available pt_mstr and pt_prod_line <> "400" then put  "到 期 日:" at 64 po_due_dat.       
      put "供 应 商:" at 2 po_vend   "名    称:" at 24 ad_name           "联 系 人:" at 64 po_contact.
      put "货物发往:" at 2 po_ship   "名    称:" at 24  name1            "地    址:" at 64 line1.
      put "开户银行:交通银行贵阳分行小河支行" at 24   "税    号: 52011478016884X" at 64 .
      put "帐    号:521146000018150008733" at 24      "电    话:3898827" at 64.
      put "采 购 员:"at 2 po_buyer   "合 同 号:" at 24 po_contract.       
      put "付 款 日" at 2           "支付方式:" at 24 po_cr_terms    "应付帐户:" at 64 po_ap_acct " " po_ap_cc.
      put "货    币:" at 2 po_curr   "兑 换 率:"at 24 " " string(po_ex_rate) + " : "  ex_rate2 .
 

      /*put "备    注:"at 2 po_rmks.*/
  /*    if po_curr = "rmb" or po_curr = "cny" then do:
/*      put skip(1).*/
      put " 序         零件号           单   订货量    采购单价     金额合计    合同单价   合同价合计   采购帐户  " at 2 skip .
      put " 号         描  述           位             (不含税)     (不含税)     (含税)      (含税)              " at 2 skip.
      put "--- ------------------------ -- ---------- ---------- ------------- ---------- ------------- --------" at 2 skip.
      PUT SKIP(1).
      end.*/
/*      if po_curr <> "rmb" and po_curr <> "cny" then do:*/
    put skip(1).
     put "序  零件号              描述            单  订货量     采购单价     金额合计     采购帐户  " at 2 skip .
     put "号                                      位             (不含税)     (不含税)      到期日   " at 2 skip.
     put "-- ----------- ------------------------ -- ---------- ----------- --------------- --------" at 2 skip.

  /*    PUT SKIP(1).*/
/*      end.*/

   end.

  /*  NBR2 = WO_NBR.*/
       find PT_MSTR WHERE PT_PART = POD_PART no-lock no-error.  
  if  available pt_mstr and pod_desc = "" then do :
      desc1 = pt_desc1.
      desc2 = pt_desc2.
    end.
   else do:
     desc1 = substring(pod_desc,1,24).
     /*"主文件无此零件".*/
     desc2 = "".
   end. 
           
  
      {mfguichk.i } /*Replace mfrpchk*/
                                                                                                                                                  
      open_ref = pod_qty_ord - pod_qty_rcvd.
      ext_cost = open_REF * pod_pur_cost.
      pur_cost = pod_pur_cost * 1.17.
      if (integer(pur_cost) - pur_cost <= 0.01 and  integer(pur_cost) - pur_cost >= -0.01) then pur_cost = integer(pur_cost).
       ext_cost1 = open_REF * pur_cost.
      
  FIND WO_MSTR WHERE WO_LOT = POD_WO_LOT NO-LOCK NO-ERROR.
        IF AVAILABLE WO_MSTR THEN NBR2 = WO_NBR.
        ELSE  NBR2 = "".   
  accumulate ext_cost (total by PO_NBR).
  accumulate ext_cost1 (total by PO_NBR).
 /* not first-of(po_nbr) then*/
 /* if po_curr = "rmb" or po_curr = "cny" then do:
     put  
     POd_line at 1  
     pod_part at 6 
    /*   desc1 at 25
   desc2 at 50*/
     pod_um at 29
    open_ref format "->,>>>,>>9.9<" at 33
     pod_pur_cost format "->>>,>>9.999<"  at 46
     EXT_COST  format "->,>>>,>>9.99" at 55
     pur_cost  format "->>>,>>9.9<"  at 69
     EXT_COST1   format "->,>>>,>>9.9<" at 80
     (pod_acct + " " + pod_cc) at 94.
     put substring(pod_desc,1,24) at 7.
     if substring(pod_desc,24,1) <> "" then
     put substring)pod_desc,24,16) at 6 .
   
     put "" skip.
     end.
     */
     part3 = pod_part.
/*     if po_curr <> "rmb" and po_curr <> "cny" then do:*/
        put  
     POd_line at 1  
     part3 at 5 
     desc1 at 18

     pod_um at 42
    open_ref format "->>>>>>9.9<" at 44

     pod_pur_cost format "->>>>>9.99<<"  at 56
     EXT_COST  format "->,>>>,>>9.9<" at 68

     (pod_acct + pod_cc) at 84.
     if substring(pod_part,11,8) <> "" or desc2 <> "" then
     put substring(pod_part,11,8) at 5.
     put desc2 at 18 .
     if pt_prod_line = "400" then 
     put pod_DUE_DATE at 84.
   /*  put "" AT 2.*/
/*     end.*/


    /*with fram b width 215  no-label .*/
  
  IF LAST-OF(PO_NBR) THEN DO:
    /*  if po_curr = "rmb" or po_curr = "cny" then PUT "-------------" AT 56 “---------------" AT 82.*/
     /* if po_curr <> "rmb" and po_curr <> "cny" then*/  PUT "-------------" AT 68 .

/*      if po_curr = "rmb" or po_curr = "cny" then PUT "汇总金额" AT 52 (accum total by PO_NBR (ext_cost)) format "->>>,>>>,>>9.999<" AT 54 (accum total by PO_NBR (ext_cost1)) format "->>>,>>>,>>9.99" AT 80.*/
/*      if po_curr <> "rmb" and po_curr <> "cny" then*/
       PUT "汇总金额" AT 58 (accum total by PO_NBR (ext_cost)) format "->>>,>>>,>>9.9<" AT 66 .

      put " " at 2.
     if bz3 = "" then  PUT "合同货款总金额(含税)：人民币(大写)________________________________________________________________" at 2.
     if bz3 <> "" then  PUT "合同货款总金额(含税)：人民币(大写)" at 2 bz3.
      put "" at 2.
      if bz = "" then    PUT "三    包   条   款 : ______________________________________________________________________________" at 2.
      if bz <> ""  then 
      PUT "三    包   条   款 :" AT 2 BZ.
      /*______________________________________________________________________________" at 2.*/
      put "" at 2.
      if bz1 = "" then put "运输方式 / 支付方式: ______________________________________________________________________________" at 2.
      if bz1 <> "" then 
      put "运输方式 / 支付方式:" AT 2 BZ1.
/*      ______________________________________________________________________________" at 2.  */
      put "" at 2.
      if bz2 = "" then put "进货检验标准或要求 :______________________________________________________________________________" at 2 .
      if bz2 <> "" then 
      put "进货检验标准或要求 :" AT 2 BZ2 .
      /*______________________________________________________________________________" at 2 .*/
      put "" at 2 .
      put "备注栏: " at 2 .
      put "       送货时附上送货清单，清单列明采购单号、零件号、数量、单位;发票也需列出采购单号。" at 2.
      put "      --------------------------------------------------------------------------------------------" at 2.
      put "      " at 2  .
      put "      --------------------------------------------------------------------------------------------" at 2.
      put "      " at 2  .
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
/*            
/*GUI*/ {mfguitrl.i} /*Replace mfrtrail*/
*/
/*GUI*/ {mfgrptrm.i} /*Report-to-Window*/
end.

         {wbrp04.i &frame-spec = a}
/*
/*GUI*/ end procedure. /*p-report*/
*/

/*GUI*/ {mfguirpb.i &flds="  part part1 vend vend1 nbr nbr1  lot lot1 due due1  ord ord1 buyer buyer1 req req1 getall bz3 bz bz1 BZ2"} /*Drive the Report*/
