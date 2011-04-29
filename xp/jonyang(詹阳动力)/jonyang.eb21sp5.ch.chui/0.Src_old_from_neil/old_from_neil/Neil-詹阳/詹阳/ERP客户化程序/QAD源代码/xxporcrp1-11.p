/* GUI CONVERTED from porcrp.p (converter v1.69) Mon Apr 14 16:34:54 1997 */
/* porcrp.p - RECEIVER PRINT AND UPDATE                                 */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/*H0J4*/ /*V8:ConvertMode=Report                                        */
/*H0J4 /*F0PN*/ /*V8:ConvertMode=FullGUIReport               */         */
/* REVISION: 8.5     LAST MODIFIED: 04/10/97    BY: *H0Q6* Ajit Deodhar */
/* Revision: Version.ui    Modified: 02/25/2009   By: Kaine Zhang     Eco: *ss_20090225* */
/***********************************************************************/


&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

{mfdtitle.i "e+ "}

define new shared variable convertmode as character no-undo.
define new shared variable rndmthd like rnd_rnd_mthd.
define new shared variable oldcurr like po_curr.

define new shared variable tax_tr_type     like tx2d_tr_type no-undo
initial '21'.
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
define new shared variable printcmts like mfc_logical initial no.
define variable i as integer.
define variable cont_lbl as character format "x(12)"
initial "*** 继续 ***".
define new shared variable tr_count as integer.
define new shared variable print_approval like mfc_logical initial yes
label "打印核准的收货单".
define new shared variable print_trlr like mfc_logical initial no
label "打印收货尾栏".
define new shared variable maint like mfc_logical initial false
no-undo.
define new shared variable po_recno as recid.
define new shared variable receivernbr like prh_receiver.
define new shared variable eff_date like glt_effdate.
define buffer prhhist for prh_hist.
    define new shared variable fiscal_id      like prh_receiver.
    define new shared variable fiscal_rec     like mfc_logical init false.

    define variable oldsession as character no-undo.
    define variable l_prh_recno as recid no-undo.
    define variable part like pt_part.
    define variable part1 like pt_part.
    find first gl_ctrl no-lock no-error.
    define new shared variable last_rec like mfc_logical initial no.


    {pocurvar.i "NEW"}
    {txcurvar.i "NEW"}



    {potrldef.i "NEW"}
/*SS 20090317 - B*/
/*
    assign
    nontax_old         = nontaxable_amt:format
    taxable_old        = taxable_amt:format
    lines_tot_old      = lines_total:format
    tax_tot_old        = tax_total:format
    order_amt_old      = order_amt:format
    line_tax_old       = line_tax:format
    line_tot_old       = line_total:format
    tax_old            = tax_2:format
    tax_amt_old        = tax_amt:format
    ord_amt_old        = ord_amt:format
    vtord_amt_old      = vtord_amt:format
    line_pst_old       = line_pst:format
    prepaid_old        = po_prepaid:format
    frt_old            = po_frt:format
    spec_chg_old       = po_spec_chg:format
    serv_chg_old       = po_serv_chg:format.
*/
/*SS 20090317 - E*/


    &SCOPED-DEFINE PP_FRAME_NAME A

    FORM
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

    printcmts      colon 30 label "列出全部说明"
    print_approval colon 30
    printwo        colon 30 label "打印加工单短缺量"
    print_trlr     colon 30
    with frame a attr-space side-labels width 80.


    &UNDEFINE PP_FRAME_NAME

setFrameLabels(frame a:handle).

	
    convertmode = "REPORT".

    view frame a.
    find first poc_ctrl no-lock no-error.
    if available poc_ctrl and poc_rcv_typ = 0 then do:
        continue_yn = no.
        bell.
        {mfmsg01.i 353 2 continue_yn}
        if continue_yn = no then leave.
    end.

    assign
    rcv_date   = today
    rcv_date1  = today
    oldcurr    = ""
    oldsession = SESSION:numeric-format.

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
        print_trlr
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


        {mfselbpr.i "printer" 132}


        assign
        pages = 0
        pdate = today
        old_receiver = ?.



        for each prh_hist no-lock
            where 
            /* *ss_20090225* */  prh_domain = global_domain and
            (prh_nbr >= nbr) and (prh_nbr <=nbr1)
            and (prh_part >= part and prh_part <= part1)
            and (prh_receiver >= rcvr) and (prh_receiver <= rcvr1)
            and (prh_vend >= vend) and (prh_vend <= vend1)
            and (prh_rcp_date >= rcv_date) and (prh_rcp_date <= rcv_date1)
            and (prh_print = yes or not new_only)
            and prh_rcp_type <> "R"


            use-index prh_rcp_date break by prh_receiver
            by prh_nbr by prh_line:

            FIND  pt_mstr where 
            /* *ss_20090225* */  pt_domain = global_domain and
            pt_part = prh_part NO-LOCK NO-ERROR.

            find ad_mstr where 
            /* *ss_20090225* */  ad_domain = global_domain and
            ad_addr = prh_vend
            no-lock no-wait no-error.
            find po_mstr where 
            /* *ss_20090225* */  po_domain = global_domain and
            po_nbr = prh_nbr no-lock no-error.

            find  TR_HIST WHERE 
            /* *ss_20090225* */  tr_domain = global_domain and
            TR_LOT = PRH_RECEIVER AND TR_NBR = PRH_NBR and tr_line = prh_line and tr_part = prh_part no-lock no-error.


            FIND  pt_mstr where 
            /* *ss_20090225* */  pt_domain = global_domain and
            pt_part = prh_part NO-LOCK NO-ERROR.
            if available pt_mstr then do:
                desc1 = pt_desc1.
                desc2 = pt_desc2.
                line = pt_prod_line.

                FORM   header
                "  贵州詹阳动力重工收货单"   at 40

                " 单据编号:" AT 2 prh_ps_nbr AT 12 "打印日期:" at 78 today
                "┌────┬────┬───--─┬────┬────┬──────┬──--─┬─────────┐" at 2
                "│ 采购单 │" at 2 prh_nbr at 14  "│采购单序号│" at 22 prh_line at 36
                "│收货单号│" at 44 prh_receiver at 56 "│生效日期│" at 68 prh_rcp_date format "99/99/99" at 83 "│" at 98
                "├───┬┴────┼───--┬┴────┴────┴──────┼----──┼─────────┤" at 2
                "│供应商│" at 2 prh_vend at 12 "│名   称 │" at 22 ad_name at 34 "│ 采购员 │" at 68 po_buyer "│" at 98
                "├───┼─────┴───┬┴───┬─────────────┴────┴------──────┤" at 2
                "│零件号│" at 2 prh_part at 12 "│描   述 │" at 30 desc1 AT 42  desc2   "│" at 98
                "├───┼─────────┼────┼───────────--------------──────────┤" at 2
                "│单  位│" at 2 prh_um AT 12    "│产 品 类│" AT 30 line  "│" at 98
                "├───┴┬───────┬┴────┴--─┬─────────-┬--------┬-─────────┤" at 2
                "│收货数量│" at 2 prh_RCVD at 15 "│收贷单价(不含税)│" at 28 prh_pur_cost "│资金合计│" (prh_RCVD * prh_pur_cost) FORMAT "->>>,>>>,>>9.99<<<"  "│" at 98
                "├───--┴───────┴────--------┴─-----------------┴--------┴-----───────┤" at 2
                "│备注：                                                                                        │" at 2
                "│                                                                                              │" at 2
                "│                                                                                              │" at 2
                "│                                                                                              │" at 2
                "└──────────────────────────────------------------────────┘" at 2
                "    核准：                                               库房：  " at 2 tr_loc
                with STREAM-IO   frame phead2 width 132.
                page.
                view frame phead2.










                {mfguirex.i }


            end.

        END.
/*SS 20090317 - B*/
        {mfreset.i}
        {mfgrptrm.i}
/*SS 20090317 - E*/

    end.
