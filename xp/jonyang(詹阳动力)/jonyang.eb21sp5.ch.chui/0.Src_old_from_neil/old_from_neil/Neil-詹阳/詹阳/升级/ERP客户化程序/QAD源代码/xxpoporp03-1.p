/* GUI CONVERTED from poporp03.p (converter v1.71) Tue Oct  6 14:37:30 1998 */
/* poporp03.p - PURCHASE ORDER PRINT AND UPDATE                         */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/*F0PN*/ /*V8:ConvertMode=FullGUIReport                                 */
/*K1Q4*/ /*V8:WebEnabled=No                                             */
/* REVISION: 1.0    LAST MODIFIED: 08/30/86     BY: PML *15*            */
/* REVISION: 1.0    LAST MODIFIED: 09/02/86     BY: EMB *12*            */
/* REVISION: 2.0    LAST MODIFIED: 12/23/86     BY: PML *A8*            */
/* REVISION: 2.0    LAST MODIFIED: 01/29/87     BY: EMB *A23*           */
/* REVISION: 2.1    LAST MODIFIED: 09/09/87     BY: WUG *A94*           */
/* REVISION: 4.0    LAST MODIFIED: 12/18/87     BY: PML *A113           */
/* REVISION: 4.0    LAST MODIFIED: 02/01/88     BY: FLM *A108           */
/* REVISION: 4.0    LAST MODIFIED: 12/30/87     BY: WUG *A137*          */
/* REVISION: 4.0    LAST MODIFIED: 01/29/88     BY: PML *A119*          */
/* REVISION: 4.0    LAST MODIFIED: 02/22/88     BY: WUG *A177*          */
/* REVISION: 4.0    LAST MODIFIED: 02/29/88     BY: WUG *A175*          */
/* REVISION: 4.0    LAST MODIFIED: 06/14/88     BY: FLM *A268*          */
/* REVISION: 4.0    LAST MODIFIED: 08/24/88     BY: FLM *A406*          */
/* REVISION: 4.0    LAST MODIFIED: 09/08/88     BY: FLM *A430*          */
/* REVISION: 4.0    LAST MODIFIED: 02/09/89     BY: FLM *A641*          */
/* REVISION: 4.0    LAST MODIFIED: 02/22/89     BY: WUG *A657*          */
/* REVISION: 5.0    LAST MODIFIED: 03/14/89     BY: MLB *B056*          */
/* REVISION: 5.0    LAST MODIFIED: 04/07/89     BY: WUG *B094*          */
/* REVISION: 4.0    LAST MODIFIED: 05/05/89     BY: MLB *A730*          */
/* REVISION: 5.0    LAST MODIFIED: 06/08/89     BY: MLB *B130*          */
/* REVISION: 5.0    LAST MODIFIED: 07/25/89     BY: WUG *B198*          */
/* REVISION: 5.0    LAST MODIFIED: 10/27/89     BY: MLB *B324*          */
/* REVISION: 5.0    LAST MODIFIED: 02/13/90     BY: FTB *B565*          */
/* REVISION: 5.0    LAST MODIFIED: 03/13/90     BY: MLB *B586*          */
/* REVISION: 5.0    LAST MODIFIED: 03/28/90     BY: MLB *B615*          */
/* REVISION: 6.0    LAST MODIFIED: 06/14/90     BY: RAM *D030*          */
/* REVISION: 6.0    LAST MODIFIED: 09/18/90     BY: MLB *D055*          */
/* REVISION: 6.0    LAST MODIFIED: 11/12/90     BY: MLB *D200*          */
/* REVISION: 6.0    LAST MODIFIED: 08/14/91     BY: RAM *D828*          */
/* REVISION: 6.0    LAST MODIFIED: 09/26/91     BY: RAM *D881*          */
/* REVISION: 6.0    LAST MODIFIED: 11/05/91     BY: RAM *D913*          */
/* REVISION: 7.3    LAST MODIFIED: 02/22/93     by: jms *G712*(rev only)*/
/* REVISION: 7.4    LAST MODIFIED: 07/20/93     by: bcm *H033*(rev only)*/
/* REVISION: 7.4    LAST MODIFIED: 07/25/94     BY: dpm *FP50*          */
/*                                 09/10/94     BY: bcm *GM03*          */
/* REVISION: 8.5    LAST MODIFIED: 04/26/96     BY: jpm *H0KS*          */
/* REVISION: 8.6    LAST MODIFIED: 11/21/96     BY: *K022* Tejas Modi   */
/* REVISION: 8.6    LAST MODIFIED: 04/03/97     BY: *K09K* Arul Victoria */

/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan    */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan    */

         /* DISPLAY TITLE */

/*GUI global preprocessor directive settings */
&GLOBAL-DEFINE PP_PGM_RP TRUE
&GLOBAL-DEFINE PP_ENV_GUI TRUE


/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

/*H033*/ {mfdtitle.i "e+ "}

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE poporp03_p_1 "只打印未结的采购单"
/* MaxLen: Comment: */
&SCOPED-DEFINE poporp03_p_8 "只打印未打印过的采购单"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */


         define variable ord_date like po_ord_date.       
         define variable ord_date1 like po_ord_date.
         define variable nbr like po_nbr.
         define variable nbr1 like po_nbr.
         define variable vend like po_vend.
         define variable vend1 like po_vend.
         define variable line like pod_line .
         define variable line1 like pod_line initial 100.  
         define variable buyer like po_buyer.
         define variable buyer1 like po_buyer.      
         define new shared variable new_only like mfc_logical initial yes.
         define new shared variable open_only like mfc_logical initial yes.
         define new shared variable last_rec like mfc_logical initial no.
         define new shared variable pages as integer.
         define variable price like prh_pur_cost format "->,>>>,>>9.99<<<".
/*IFP*/  define variable desc2 like pt_desc2.
/*IFP*/  define variable prodline like pt_prod.
/*PLJ*/  define variable amt_1 like sct_mtl_tl format "->>>>>9.99".
/*PLJ*/  define variable price_1 like sct_mtl_tl format "->>>>>>>9.99".
/*PLJ*/  define variable loc_1 like pt_loc.
         define variable prhpart like pod_part.
         define variable podpart like pod_Part.
         define variable podpart1 like pod_part.
         define variable prhline like pod_line.
         define variable proline like pt_prod.
         define variable loc like pt_loc.
         define variable desc1 like pt_desc1.
         define variable prhum like pod_um.
         define variable qty_ord like pod_qty_ord.
         define buffer poddet for pod_det.
         define variable podqtyord like pod_qty_ord.
         define variable adname like ad_name.
         define variable adline1 like ad_line1.
         define variable adline2 like ad_line2.
         define variable adline3 like ad_line3.
/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
            
 RECT-FRAME       AT ROW 1.4 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
 SKIP(.1)  /*GUI*/
nbr            colon 15
            nbr1           label {t001.i} colon 49
            vend           colon 15
            vend1          label {t001.i} colon 49  
            buyer          colon 15
            buyer1         label {t001.i} colon 49 
            ord_date       colon 15
            ord_date1      label {t001.i} colon 49 skip
            line           colon 15
            line1          label {t001.i} colon 49 
            podpart        colon 15
            podpart1       label {t001.i} colon 49 skip  
            open_only      colon 35 label {&poporp03_p_1}
/*            new_only       colon 35 label {&poporp03_p_8}*/
          SKIP(.4)  /*GUI*/
with frame a width 80 attr-space side-labels NO-BOX THREE-D /*GUI*/.

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
         
/*GUI*/ {mfguirpa.i true  "printer" 80 }

/*GUI repeat : */
/*GUI*/ procedure p-enable-ui:
            if nbr1 = hi_char then nbr1 = "".
            if vend1 = hi_char then vend1 = "".
            if ord_date = low_date then ord_date = ?.
            if ord_date1 = hi_date then ord_date1 = ?.
            if buyer1 = hi_char then buyer1="".
            if podpart1 =hi_char then podpart1="".
run  p-action-fields (input "display").
run p-action-fields (input "enable").
end procedure. /* p-enable-ui, replacement of Data-Entry GUI*/

/*GUI*/ procedure p-report-quote:
          

            bcdparm = "".
            {mfquoter.i nbr    }
            {mfquoter.i nbr1   }
            {mfquoter.i vend   }
            {mfquoter.i vend1  }
            {mfquoter.i buyer  }
            {mfquoter.i buyer  }
            {mfquoter.i ord_date}
            {mfquoter.i ord_date1}
            {mfquoter.i line}
            {mfquoter.i line1}
            {mfquoter.i open_only}
            {mfquoter.i podpart}
            {mfquoter.i podpart1}

            if  nbr1 = "" then nbr1 = hi_char.
            if  vend1 = "" then vend1 = hi_char.
            if  buyer1 = "" then buyer1 =hi_char.
            if  ord_date = ? then ord_date = low_date.
            if  ord_date1 = ? then ord_date1 = hi_date.
            if  podpart1 = "" then podpart1 = hi_char.         
            /* SELECT PRINTER */
            
/*GUI*/ end procedure. /* p-report-quote */
/*GUI - Field Trigger Section */


/*GUI MFSELxxx removed*/
/*GUI*/ procedure p-report:
/*GUI*/   {gpprtrpa.i  "printer" 80}
/*GUI*/ mainloop: do on error undo, return error on endkey undo, return error:
      for each po_mstr where (po_nbr >= nbr) and (po_nbr <= nbr1)
         and (po_vend >= vend) and (po_vend <= vend1)
         and (po_buyer >= buyer and po_buyer <= buyer1)
/*/*zym*/      and (po_print or not new_only)*/
         and (po_ord_date >= ord_date) and (po_ord_date <= ord_date1),
         each pod_det where (pod_nbr = po_nbr)
         and (pod_part >= podpart and pod_part <= podpart1) 
         and  (pod_line >= line) and (pod_line<= line1)
/*ZYM and (((pod_status = "C" or pod_status = "") and not open_only) or 
          (pod_status <> "C" and open_only))*/ 
        
         no-lock BREAK by po_nbr:
         qty_ord = pod_qty_ord - pod_qty_rcvd.
         find ad_mstr where ad_addr = po_vend
               no-lock no-wait no-error.
            if available ad_mstr then do:
               adname = ad_name.
               adline1 = ad_line1.
               adline2 = ad_line2.
               adline3 = ad_line3.
               end.
            else do:
               adname = "".
               adline1 ="".
               adline2="".
               adline3="".
            end.     
         FORM /*GUI*/  header
/*zym*/  
           " 贵州詹阳动力重工采购单 "   at 34
                  
                   skip(1)

          "   采购员:"at 2 po_buyer at 12          "20  年  月  日" at 40 "发票字号______________________件" at 65
          "┌────┬──────┬────┬─────┬────┬────┬───┬──────────┐" at 2                                
          "│合 同 号│" at 2 po_contract at 14 format "x(10)" "│收料单号│" at 26 "│ 采购单 │" at 48 po_nbr to 67 "│装箱单│" at 68 "│" at 98
          "├───┬┴────┬─┴──┬─┴─────┴────┴────┼───┴┬─────────┤" at 2
          "│供应商│" at 2 po_vend at 12 "│名   称 │" at 22 adname at 34 "│主要用途│" at 68  "│" at 98
          "├───┼─────┴────┴─────────────────┼────┼─────────┤" at 2
          "│地  址│" at 2 (adline1 + " " + adline2 + " " + adline3) format "x(50)" at 12 "│支付方式│" at 68 po_cr_terms to 97 "│" at 98
          "├──┬┴────────┬───────────────────┴───┬┴─┬──┬────┤" at 2
          "│序号│    零件号        │       描     述                              │单位│ 类 │收料日期│" at 2
          "├──┼─────────┼───────────────────────┼──┼──┼────┤" at 2
               with STREAM-IO /*GUI*/  frame phead2 width 132.
               
/*plj*/        view frame phead2.                 
               find pt_mstr where pt_part = pod_part  no-lock no-error.
               if available pt_mstr then do:
                   loc_1 = pt_loc.
                   desc1 = pt_desc1.
                   desc2 = pt_desc2.
                   proline = pt_prod.
                 end.
                 else  assign
                       loc_1 = ""
                       desc1 = ""
                       desc2 = ""
                       proline = "".


    
        /*       if page-size - line-count < 6 then do:
                   page.
               end.   */
                               
          put  "│" at 2 pod_line at 4 "│" at 8 pod_part at 10 "│" at 28 desc1 + desc2 format "X(46)" at 30 "│" 
                  at 76 pod_um at 78 "│" at 82 proline at 84  "│" at 88 "│" at 98.
          put  "├──┴─┬───────┴┬─────────┬────────┬───┴─┬┴──┴────┤" at 2.
          put  "│采购数量│" at 2 qty_ord at 14 "│采购单价格(不含税)│" at 30 pod_pur_cost at 52 "│采购单金额│" at 68 (pod_pur_cost * qty_ord)  format "->,>>>,>>9.9<" at 82 "│" at 98.
          put  "├────┼────┬───┴┬────┬───┴─┬──────┼─────┴┬───────┤" at 2.
          put  "│到货数量│        │收货数量│        │实际收货价│            │实际收货金额│              │" at 2. 
          put  "├───┬┴───┬┴──┬─┴─┬──┴──┬──┴─┬────┼────┬─┴─┬─────┤" at 2.
          put  "│运  费│        │杂  费│      │委托加工费│        │费用合计│        │增值税│          │" at 2. 
          put  "├───┴────┴───┴┬──┴─────┴────┴─┬──┴────┴───┴─────┤" at 2.
          put  "│     已 暂 估 收 料 数    │      检   验   结    果      │          备        考            │" at 2.
          put  "├─┬─┬──────┬──┼───────────────┼─────────────────┤" at 2.
          put  "│月│日│原验收单编号│数量│                              │                                  │" at 2.
          put  "├─┼─┼──────┼──┤                              │                                  │" at 2.
          put  "│  │  │            │    │                              │                                  │" at 2.
/*zym*/   put  "└─┴─┴──────┴──┴───────────────┴─────────────────┘" at 2.
          put " 采购主管：_________ 采购：_________检查：__________  核算：__________  库管：__________ 库房:    " at 2. 
          put "                                                                                                  " at 2. 
               down 1.
               page.           
/*IFP*/

end.  
end.
/*GUI*/ {mfgrptrm.i} /*Report-to-Window*/
/*GUI*/ end procedure. /*p-report*/
/*GUI*/ {mfguirpb.i &flds=" nbr nbr1 vend vend1 buyer buyer1 ord_date ord_date1 line line1  podpart podpart1 open_only "} /*Drive the Report*/
