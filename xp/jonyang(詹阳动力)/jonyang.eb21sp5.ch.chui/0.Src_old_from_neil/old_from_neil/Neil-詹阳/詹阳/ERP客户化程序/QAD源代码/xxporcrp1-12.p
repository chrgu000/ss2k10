/* GUI CONVERTED from porcrp.p (converter v1.69) Mon Apr 14 16:34:54 1997 */
/* porcrp.p - RECEIVER PRINT AND UPDATE                                 */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/*H0J4*/ /*V8:ConvertMode=Report                                        */
/*H0J4 /*F0PN*/ /*V8:ConvertMode=FullGUIReport               */         */
/* REVISION: 8.5     LAST MODIFIED: 04/10/97    BY: *H0Q6* Ajit Deodhar */
/*By: Neil Gao 09/02/07 ECO: *SS 20090207* */

/***********************************************************************/


/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

/*GN91*/ {mfdtitle.i "e+ "}

/*H0JJ*/ define new shared variable convertmode as character no-undo.
/*J053*/ define new shared variable rndmthd like rnd_rnd_mthd.
/*J053*/ define new shared variable oldcurr like po_curr.
/*J053*/ /* CORRECT INITIAL TAX TYPE TO INDICATE RECEIPT (21) NOT RETURN (25)*/
/*GO37*/ define new shared variable tax_tr_type     like tx2d_tr_type no-undo
/*J053*/                                            initial '21'.
         define variable nbr like prh_nbr.
         define variable nbr1 like prh_nbr.
         define variable vend like prh_vend.
         define variable vend1 like prh_vend.
         define variable rcvr like prh_receiver.
         define variable rcvr1 like prh_receiver.
         define variable rcv_date like prh_rcp_date.
         define variable rcv_date1 like prh_rcp_date.
         define variable new_only like mfc_logical initial yes.
         define variable revision like po_rev.
         define variable buyer like po_buyer.
         define variable tranqty like tr_qty_chg.
         define variable pdate like prh_rcp_date.
         define variable pages as integer.
         define variable old_receiver like prh_receiver.
         define variable location like pt_loc.
         define variable det_lines as integer.
         define variable vendor as character format "x(38)" extent 6.
         define variable vend_phone like ad_phone.
         define variable duplicate as character format "x(11)" label "".
         define variable newline like mfc_logical initial yes.
         define variable continue_yn like mfc_logical initial no.
         define new shared variable prh_recno as recid.
         define variable desc1 like pt_desc1.
         define variable desc2 like pt_desc2.
         define variable line like pt_prod_line.
         define variable printwo like mfc_logical initial yes.
         define variable rmks like po_rmks.
/*GB61*/ define new shared variable printcmts like mfc_logical initial no.
         define variable i as integer.
         define variable cont_lbl as character format "x(12)"
            initial "*** 继续 ***".
/*GB61*/ define new shared variable tr_count as integer.
/*GB61*/ define new shared variable print_approval like mfc_logical initial yes
/*F006*/    label "打印核准的收货单".
/*H035*/ define new shared variable print_trlr like mfc_logical initial no
        label "打印收货尾栏".
/*H035*/ define new shared variable maint like mfc_logical initial false
/*H035*/                                    no-undo.
/*H035*/ define new shared variable po_recno as recid. /* USED FOR RCVR NBR */
/*H035*/ define new shared variable receivernbr like prh_receiver.
/*H035*/ define new shared variable eff_date like glt_effdate.
/*FM02*/ define buffer prhhist for prh_hist.
/*H543*/ define new shared variable fiscal_id      like prh_receiver.
/*H543*/ define new shared variable fiscal_rec     like mfc_logical init false.
/*H0JJ
 * /*FT65*/ define variable loc_qty like ld_qty_all.
 * /*FT65*/ define variable avail_qty like ld_qty_all. */
/*J053*/ define variable oldsession as character no-undo.
/*H0Q6*/ define variable l_prh_recno as recid no-undo.
         define variable ext_cost like pod_pur_cost format "->,>>>,>>>,>>9.99".
/*J053*/ find first gl_ctrl where gl_domain = global_domain no-lock no-error.
/*IFP*/  define new shared variable last_rec like mfc_logical initial no.

/*J053      DEFINE & INITIALIZE CURRENCY DEPENDENT ROUNDING FORMAT VARS  */
/*J053*/    {pocurvar.i "NEW"}
/*J053*/    {txcurvar.i "NEW"}
/*J053*/
/*J053*/    /* DEFINE TRAILER VARS AS NEW, SO THAT CORRECT _OLD FORMATS */
/*J053*/    /* CAN BE ASSIGNED BASED ON INITIAL DEFINE                  */
/*J053*/    {potrldef.i "NEW"}

/*SS 20090207 - B*/
/*
/*J053*/    assign
/*J053*/            nontax_old         = nontaxable_amt:format
/*J053*/            taxable_old        = taxable_amt:format
/*J053*/            lines_tot_old      = lines_total:format
/*J053*/            tax_tot_old        = tax_total:format
/*J053*/            order_amt_old      = order_amt:format

/*J053*/            ord_amt_old        = ord_amt:format
/*J053*/            vtord_amt_old      = vtord_amt:format
/*J053*/            line_pst_old       = line_pst:format
/*J053*/            prepaid_old        = po_prepaid:format
/*J053*/            frt_old            = po_frt:format
/*J053*/            spec_chg_old       = po_spec_chg:format
/*J053*/            serv_chg_old       = po_serv_chg:format.
*/
/*SS 20090207 - E*/
         
/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
						nbr            colon 15
            nbr1           label {t001.i} colon 49
            rcvr           colon 15
            rcvr1          label {t001.i} colon 49
            vend           colon 15
            vend1          label {t001.i} colon 49
            rcv_date       colon 15
            rcv_date1      label {t001.i} colon 49
            skip(1)
            new_only       colon 30 label "只打印未打印过的收货单"
/*G718*     printcmts      colon 30 label "List Comments" */
/*G718*/    printcmts      colon 30 label "列出全部说明"
            print_approval colon 30
            printwo        colon 30 label "打印加工单短缺量"
/*H035*/    print_trlr     colon 30
/*J053*/ with frame a attr-space side-labels width 80.

setFrameLabels(frame a:handle).


/*GUI preprocessor Frame A undefine */
&UNDEFINE PP_FRAME_NAME


/*J053*         with frame a attr-space side-labels.  */

/*GB61** form with frame d down no-attr-space no-box width 80. **/

/*H0JJ*/ convertmode = "REPORT".

         view frame a.
         find first poc_ctrl where poc_domain = global_domain no-lock no-error.
         if available poc_ctrl and poc_rcv_typ = 0 then do:
            continue_yn = no.
            bell.
            {mfmsg01.i 353 2 continue_yn}
            if continue_yn = no then leave.
         end.

/*J0NX*/ assign
/*D978*/    rcv_date   = today
/*D978*/    rcv_date1  = today
/*J053*/    oldcurr    = ""
/*J053*/    oldsession = SESSION:numeric-format.

         repeat:
            if nbr1 = hi_char then nbr1 = "".
            if rcvr1 = hi_char then rcvr1 = "".
            if vend1 = hi_char then vend1 = "".
            if rcv_date = low_date then rcv_date = ?.
            if rcv_date1 = hi_date then rcv_date1 = ?.

            update
            nbr nbr1 rcvr rcvr1 vend vend1 rcv_date rcv_date1 new_only
            printcmts print_approval printwo
/*H035*/    print_trlr
            with frame a.

            bcdparm = "".
            {mfquoter.i nbr}
            {mfquoter.i nbr1}
            {mfquoter.i rcvr}
            {mfquoter.i rcvr1}
            {mfquoter.i vend}
            {mfquoter.i vend1}
            {mfquoter.i rcv_date}
            {mfquoter.i rcv_date1}
            {mfquoter.i new_only}
            {mfquoter.i printcmts}
            {mfquoter.i print_approval}
            {mfquoter.i printwo}
            {mfquoter.i print_trlr}

            if nbr1 = "" then nbr1 = hi_char.
            if rcvr1 = "" then rcvr1 = hi_char.
            if vend1 = "" then vend1 = hi_char.
            if rcv_date = ? then rcv_date = low_date.
            if rcv_date1 = ? then rcv_date1 = hi_date.

            /* SELECT PRINTER */
            {mfselbpr.i "printer" 132}


/*J0NX*/    assign
               pages = 0
               pdate = today
               old_receiver = ?.


/*FM02*     for each prh_hist exclusive */
/*FM02*/    for each po_mstr where po_domain = global_domain and po_stat = "c"
            and (po_nbr >= nbr and po_nbr <= nbr1) ,
            each pod_det where pod_domain = global_domain and pod_nbr = po_nbr ,
            each prh_hist no-lock
            where prh_domain = global_domain and prh_nbr = pod_nbr and prh_line = pod_line
            and (prh_receiver >= rcvr) and (prh_receiver <= rcvr1)
            and (prh_vend >= vend) and (prh_vend <= vend1)
            and (prh_rcp_date >= rcv_date) and (prh_rcp_date <= rcv_date1)
            and (prh_print = yes or not new_only)
/*GO37*/    and prh_rcp_type <> "R"
            
/*D978      use-index prh_rcp_date break by prh_receiver: */
/*D978*/    use-index prh_rcp_date break 
/*D978*/    by prh_nbr by prh_line:

        find pt_mstr where pt_domain = global_domain and pt_part = pod_part no-lock no-error.
        if not available pt_mstr then do:

               find ad_mstr where ad_domain = global_domain and  ad_addr = prh_vend
               no-lock no-wait no-error.
   
               find  TR_HIST WHERE tr_domain = global_domain and TR_LOT = PRH_RECEIVER AND TR_NBR = PRH_NBR and tr_line = prh_line and tr_part = prh_part no-lock no-error.
               ext_cost = (prh_pur_cost * prh_rcvd).
            accumulate ext_cost (total by PRH_NBR).
               
               if first-of (prh_nbr)  or page-size - line-counter < 2 then do:
       
        /*  {mfphead.i}*/
           page.
           put "打印日期:" at 50 today.
           put skip(1).
      put "                               贵州詹阳动力重工收货单"at 2  "页号:" at 70
                   string(page-number)  skip .
      put " " at 2 skip.                                               
      put "采购单:" at 2 po_nbr    "供应商:" at 20  po_vend      "名称:" at 40 ad_name "采购员：" at 78 po_buyer . 
             put skip(1).
     put "序        描述              单  收货单价    收货数量    金额合计    收货单号  生效日期      采购帐户     " at 2 skip .
     put "号                          位                                                              成本中心     " at 2 skip.
     put "--  ------------------------ -- ---------- --------- ------------- --------- --------- ----------------" at 2 skip.
      end.
     put  
     POd_line at 1  
     pod_part at 6 
     pod_um at 30
     prh_pur_cost format "->>>>>>9.9<" at 34
     prh_RCVD format "->>>>>9.99"  at 44
     (prh_pur_cost * prh_rcvd)  format "->,>>>,>>9.99" at 55
     prh_receiver at 70
     prh_rcp_date at 80
     
     pod_acct at 91
     pod_cc at 100.
     if pod_desc <> "零件无库存" then 
     put
     pod_desc at 6.
     
     put "" skip.
     if last-of (prh_nbr) then do:
             put "----------------- " at 55. 
             put "金额合计:" at 44 .
             PUT  (accum total by Prh_nbr (ext_cost)) format "->,>>>,>>9.99" AT 55.
             put " " at 2.
             put  "    核准：                                 " at 2 tr_loc.
            end.
               /* DISPLAY PO RECEIPT LINE INFORMATION */
/*GB61************************************************************************
 *      ALL DISPLAYS USING FRAME d MOVED TO PORCRPB.P                        *
 *****************************************************************************/
/*GB61*       {gprun.i ""porcrpb.p""} */
/*IFP*/    /*   if last-of(prh_receiver) then last_rec = yes.
/*IFP*/       else last_rec = no.
*/

               /* DISPLAY TRANSACTION HISTORY DETAIL FOR LOT/SERIAL NBRS */
 /***              if tr_count > 1 then do:
/*J0NX*/          prh_recno = recid(prh_hist).
/*IFP***          {gprun.i ""porcrpc.p""}   */

               end.  /* (IF TR_COUNT > 1) */

                if printwo then do:
/*H0Q6*/          l_prh_recno = recid(prh_hist).
/*H0Q6** /*H0JJ*/ {gprun.i ""porcrpwo.p"" "(prh_part)"} */
/*IFP*            {gprun.i ""porcrpwo.p"" "(prh_part,l_prh_recno)"}*/

                end.
****/
               
  end.
            end.
            /* End Processing prh_hist */
           
 {mfguirex.i }.
 {mfguitrl.i}.
 {mfgrptrm.i} .



         end.
