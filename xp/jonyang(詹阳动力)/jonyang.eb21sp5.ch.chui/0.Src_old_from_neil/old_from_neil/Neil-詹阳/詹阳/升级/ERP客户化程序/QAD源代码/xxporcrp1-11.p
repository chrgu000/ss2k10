/* GUI CONVERTED from porcrp.p (converter v1.69) Mon Apr 14 16:34:54 1997 */
/* porcrp.p - RECEIVER PRINT AND UPDATE                                 */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/*H0J4*/ /*V8:ConvertMode=Report                                        */
/*H0J4 /*F0PN*/ /*V8:ConvertMode=FullGUIReport               */         */
/* REVISION: 8.5     LAST MODIFIED: 04/10/97    BY: *H0Q6* Ajit Deodhar */

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
         define variable part like pt_part.
         define variable part1 like pt_part.
/*J053*/ find first gl_ctrl no-lock no-error.
/*IFP*/  define new shared variable last_rec like mfc_logical initial no.

/*J053      DEFINE & INITIALIZE CURRENCY DEPENDENT ROUNDING FORMAT VARS  */
/*J053*/    {pocurvar.i "NEW"}
/*J053*/    {txcurvar.i "NEW"}
/*J053*/
/*J053*/    /* DEFINE TRAILER VARS AS NEW, SO THAT CORRECT _OLD FORMATS */
/*J053*/    /* CAN BE ASSIGNED BASED ON INITIAL DEFINE                  */
/*J053*/    {potrldef.i "NEW"}
/*J053*/    assign
/*J053*/            nontax_old         = nontaxable_amt:format
/*J053*/            taxable_old        = taxable_amt:format
/*J053*/            lines_tot_old      = lines_total:format
/*J053*/            tax_tot_old        = tax_total:format
/*J053*/            order_amt_old      = order_amt:format
/*J053*/            line_tax_old       = line_tax:format
/*J053*/            line_tot_old       = line_total:format
/*J053*/            tax_old            = tax_2:format
/*J053*/            tax_amt_old        = tax_amt:format
/*J053*/            ord_amt_old        = ord_amt:format
/*J053*/            vtord_amt_old      = vtord_amt:format
/*J053*/            line_pst_old       = line_pst:format
/*J053*/            prepaid_old        = po_prepaid:format
/*J053*/            frt_old            = po_frt:format
/*J053*/            spec_chg_old       = po_spec_chg:format
/*J053*/            serv_chg_old       = po_serv_chg:format.

         
/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
            
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
            nbr            colon 15
            nbr1           label {t001.i} colon 49
            part           colon 15
            part1          label {t001.i} colon 49
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
/*J053*/ with frame a attr-space side-labels width 80 NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-a-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
 RECT-FRAME-LABEL:HIDDEN in frame a = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame a =
  FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5.  /*GUI*/

/*GUI preprocessor Frame A undefine */
&UNDEFINE PP_FRAME_NAME


/*J053*         with frame a attr-space side-labels.  */

/*GB61** form with frame d down no-attr-space no-box width 80. **/

/*H0JJ*/ convertmode = "REPORT".

         view frame a.
         find first poc_ctrl no-lock no-error.
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
            if part1 = hi_char then part1 = "".
            if rcvr1 = hi_char then rcvr1 = "".
            if vend1 = hi_char then vend1 = "".
            if rcv_date = low_date then rcv_date = ?.
            if rcv_date1 = hi_date then rcv_date1 = ?.

            update
            nbr nbr1 part part1 rcvr rcvr1 vend vend1 rcv_date rcv_date1 new_only
            printcmts print_approval printwo
/*H035*/    print_trlr
            with frame a.

            bcdparm = "".
            {mfquoter.i nbr}
            {mfquoter.i nbr1}
            {mfquoter.i part}
            {mfquoter.i part1}
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
            if part1 = "" then part1 = hi_char.
            if rcvr1 = "" then rcvr1 = hi_char.
            if vend1 = "" then vend1 = hi_char.
            if rcv_date = ? then rcv_date = low_date.
            if rcv_date1 = ? then rcv_date1 = hi_date.

            /* SELECT PRINTER */
            {mfselbpr.i "printer" 132}
/*GUI*/ RECT-FRAME:HEIGHT-PIXELS in frame a = FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.


/*J0NX*/    assign
               pages = 0
               pdate = today
               old_receiver = ?.


/*FM02*     for each prh_hist exclusive */
/*FM02*/    for each prh_hist no-lock
            where (prh_nbr >= nbr) and (prh_nbr <=nbr1)
            and (prh_part >= part and prh_part <= part1)
            and (prh_receiver >= rcvr) and (prh_receiver <= rcvr1)
            and (prh_vend >= vend) and (prh_vend <= vend1)
            and (prh_rcp_date >= rcv_date) and (prh_rcp_date <= rcv_date1)
            and (prh_print = yes or not new_only)
/*GO37*/    and prh_rcp_type <> "R"
            
/*D978      use-index prh_rcp_date break by prh_receiver: */
/*D978*/    use-index prh_rcp_date break by prh_receiver
/*D978*/    by prh_nbr by prh_line:

            FIND  pt_mstr where pt_part = prh_part NO-LOCK NO-ERROR.
            /*******
/*J0ZS*/       if (oldcurr <> prh_curr) or (oldcurr = "") then do:
/*J0ZS*/          {gpcurmth.i
		       "prh_curr"
		       "4"
		       "next"
		       "pause" }
         

/*J053*/          /* DETERMINE CURRENCY DISPLAY AMERICAN OR EUROPEAN        */
/*J053*/          find rnd_mstr where rnd_rnd_mthd = rndmthd no-lock no-error.
/*J053*/          if not available rnd_mstr then do:
/*J053*/             {mfmsg.i 863 4}    /* ROUND METHOD RECORD NOT FOUND */
/*J053*/             next.
/*J053*/          end.
/*J053*/          /* IF RND_DEC_PT = COMMA FOR DECIMAL POINT */
/*J053*/          /* THIS IS A EUROPEAN STYLE CURRENCY */
/*J053*/          if (rnd_dec_pt = "," )
/*J053*/          then SESSION:numeric-format = "European".
/*J053*/          else SESSION:numeric-format = "American".
/*J053*/          {pocurfmt.i}
/*J053*/          oldcurr = prh_curr.
/*J053*/       end.

/*J0NX*/       assign
                  prh_recno = recid(prh_hist)
                  duplicate = ""
                  revision  = 0
                  buyer     = ""
                  rmks      = "".

               if prh_print = no then duplicate = "** 副 本 **".

               find po_mstr where po_nbr = prh_nbr no-lock no-error.
               if available po_mstr then
/*J0NX**       do:   **/
/*J0NX*/          assign
                     revision = po_rev
                     buyer    = po_buyer
                     rmks     = po_rmks.
/*J0NX**       end.  **/

/*GN91         update vendor = "". */
/*GN91*/       assign vendor = "".
*********/
               find ad_mstr where ad_addr = prh_vend
               no-lock no-wait no-error.
           find po_mstr where po_nbr = prh_nbr no-lock no-error.
/**************
               if available ad_mstr then do:
/*J0NX*/          assign
                     vendor[1]  = ad_name
                     vendor[2]  = ad_line1
                     vendor[3]  = ad_line2
                     vendor[4]  = ad_line3
                     vendor[6]  = ad_country
                     vend_phone = ad_phone.
                  {mfcsz.i vendor[5] ad_city ad_state ad_zip}
                  {mfaddr.i
                     vendor[1]
                     vendor[2]
                     vendor[3]
                     vendor[4]
                     vendor[5]
                     vendor[6]}.
               end.
    **************/       
               find  TR_HIST WHERE TR_LOT = PRH_RECEIVER AND TR_NBR = PRH_NBR and tr_line = prh_line and tr_part = prh_part no-lock no-error.
               

    FIND  pt_mstr where pt_part = prh_part NO-LOCK NO-ERROR.
 if available pt_mstr then do:
              desc1 = pt_desc1.
              desc2 = pt_desc2.
              line = pt_prod_line.
            
               FORM /*GUI*/  header
                  "  贵州詹阳动力重工收货单"   at 40
               /*  "页号:"             to 84
                 string(page-number
                  -
                  pages  ) skip(1)*/
                 " 单据编号:" AT 2 prh_ps_nbr AT 12 "打印日期:" at 78 today
/*IFP*/          "┌────┬────┬───--─┬────┬────┬──────┬──--─┬─────────┐" at 2
/*IFP*/          "│ 采购单 │" at 2 prh_nbr at 14  "│采购单序号│" at 22 prh_line at 36  
/*IFP*/          "│收货单号│" at 44 prh_receiver at 56 "│生效日期│" at 68 prh_rcp_date format "99/99/99" at 83 "│" at 98
/*IFP*/          "├───┬┴────┼───--┬┴────┴────┴──────┼----──┼─────────┤" at 2
/*IFP*/          "│供应商│" at 2 prh_vend at 12 "│名   称 │" at 22 ad_name at 34 "│ 采购员 │" at 68 po_buyer "│" at 98
/*IFP*/          "├───┼─────┴───┬┴───┬─────────────┴────┴------──────┤" at 2
                 "│零件号│" at 2 prh_part at 12 "│描   述 │" at 30 desc1 AT 42  desc2   "│" at 98
/*IFP*/          "├───┼─────────┼────┼───────────--------------──────────┤" at 2                 
                 "│单  位│" at 2 prh_um AT 12    "│产 品 类│" AT 30 line  "│" at 98
/*IFP*/          "├───┴┬───────┬┴────┴--─┬─────────-┬--------┬-─────────┤" at 2
/*IFP*/          "│收货数量│" at 2 prh_RCVD at 15 "│收贷单价(不含税)│" at 28 prh_pur_cost "│资金合计│" (prh_RCVD * prh_pur_cost) FORMAT "->>>,>>>,>>9.99<<<"  "│" at 98
/*IFP*/          "├───--┴───────┴────--------┴─-----------------┴--------┴-----───────┤" at 2
/*PLJ*/          "│备注：                                                                                        │" at 2
/*PLJ*/          "│                                                                                              │" at 2
/*PLJ*/          "│                                                                                              │" at 2
/*PLJ*/          "│                                                                                              │" at 2
/*PLJ*/          "└──────────────────────────────------------------────────┘" at 2 
                  "    核准：                                               库房：  " at 2 tr_loc 
               with STREAM-IO /*GUI*/  frame phead2 width 132.
             page.
/*plj*/        view frame phead2.
/********               if first-of (prh_receiver) then do:
/*J15T*/           assign
                     pages        = page-number - 1
                     old_receiver = prh_receiver.


                  if printcmts then do:   /* PRINT ALL COMMENTS */
                     if available po_mstr then do:
                        {gpcmtprt.i &type=RP &id=po_cmtindx &pos=3}
                     end.
                  end.
/*G718*/          else do:                /* PRINT RECEIVER COMMENTS ONLY */
/*G718*/             if available po_mstr then do:
/*G718*/                {gpcmtprt.i &type=RC &id=po_cmtindx &pos=3}
/*G718*/             end.
/*G718*/          end.

               end.
**********/
               /* DISPLAY PO RECEIPT LINE INFORMATION */
/*GB61************************************************************************
 *      ALL DISPLAYS USING FRAME d MOVED TO PORCRPB.P                        *
 *****************************************************************************/
/*GB61*       {gprun.i ""porcrpb.p""} */
/*IFP*/    /*   if last-of(prh_receiver) then last_rec = yes.
/*IFP*/       else last_rec = no.
*/
/* /*IFP*/       {gprun.i ""xxrcrpb.p""} 
/*plj*/       {gprun.i ""xxrcrpb1-2.p""} 
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
               
/*GUI*/ {mfguirex.i } /*Replace mfrpexit*/

/********
               /* TRAILER */
/*H035*/       if last-of(prh_receiver) and print_trlr and {txnew.i} then do:
/*H035*/          find po_mstr where po_nbr = prh_nbr no-lock.
/*J0NX*/          assign
/*H035*/             undo_trl2   = true
/*H035*/             po_recno    = recid(po_mstr)
/*H035*/             receivernbr = prh_receiver.

/*IFP*               {gprun.i ""porctrl2.p""}  */
/*H035*/          if undo_trl2 then undo, leave.
/*H035*/       end.
/*H035*/       else
/*plj
/*G0HT*/ /*V8+*/
               if not last(prh_receiver) and
               last-of (prh_receiver) then do:
/*IFP*            page. */
/*IFP*/           if page-size - line-count >= 20 then view frame phead2. 
/*J15T*/          assign
                     pdate        = today
                     old_receiver = ?.
               end.
plj*/
/*FM02*/       find prhhist where recid(prhhist) = prh_recno exclusive-lock.
               /* CHANGE PRINT FLAG TO "NO" */
/*FM02*/       if available prhhist then
/*FM02*/       prhhist.prh_print = no.
/*FM02*        prh_print = no. */
 ************/
            end.
            /* End Processing prh_hist */
        END.   
            {mfreset.i}
/*GUI*/ {mfgrptrm.i} /*Report-to-Window*/


         end.
/*J053*/ SESSION:numeric-format = oldsession.
