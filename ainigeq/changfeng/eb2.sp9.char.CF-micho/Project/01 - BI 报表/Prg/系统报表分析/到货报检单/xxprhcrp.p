/* Revision: eb2sp9  BY: Micho Yang         DATE: 12/28/06  ECO: *SS - 20061228.1*  */

/* DISPLAY TITLE */
{mfdtitle.i "2+ "}
{cxcustom.i "xxprhcrp.P"}

DEF VAR receiver LIKE prh_receiver .
DEF VAR receiver1 LIKE prh_receiver.
DEF VAR v_desc1 LIKE pt_desc1 .
DEF VAR v_desc2 LIKE pt_desc2 .
DEF VAR v_ad_name LIKE ad_name .
DEF VAR v_vp_vend_part LIKE vp_vend_part .
DEF VAR V_LOC LIKE TR_LOC.

FORM
    receiver    COLON 20      receiver1     COLON 54 SKIP(1)
    WITH FRAME a SIDE-LABELS WIDTH 80.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

{wbrp01.i}
repeat:
    IF receiver1 = hi_char THEN receiver1 = "" .

    if c-application-mode <> 'web' then
       update receiver receiver1 
    with frame a.

    {wbrp06.i &command = update &fields = " receiver receiver1 " &frm = "a"}

    if (c-application-mode <> 'web') or
       (c-application-mode = 'web' and
       (c-web-request begins 'data')) then do:

      bcdparm = "".
      {mfquoter.i receiver       }
      {mfquoter.i receiver1      }

      if receiver1 = "" then receiver1 = hi_char.
    end.

    /* OUTPUT DESTINATION SELECTION */
    {gpselout.i &printType = "printer"
               &printWidth = 132
               &pagedFlag = " "
               &stream = " "
               &appendToFile = " "
               &streamedOutputToTerminal = " "
               &withBatchOption = "yes"
               &displayStatementType = 1
               &withCancelMessage = "yes"
               &pageBottomMargin = 6
               &withEmail = "yes"
               &withWinprint = "yes"
               &defineVariables = "yes"}

        /*
    {mfphead.i}
           */

    PUT ";" ";" "到货报检单"  SKIP(1).
    FOR EACH prh_hist NO-LOCK WHERE prh_receiver >= receiver 
                                AND prh_receiver <= receiver1
                      BREAK BY prh_vend BY prh_rcp_date
                            BY prh_nbr BY prh_receiver :
        v_ad_name = "" .
        IF FIRST-OF(prh_receiver) THEN DO:
            FIND FIRST ad_mstr WHERE ad_addr = prh_vend NO-LOCK NO-ERROR.
            IF AVAIL ad_mstr THEN v_ad_name = ad_name .

            PUT UNFORMATTED ";" "供应商: " ";" prh_vend  ";" ";" "到货日期: " ";" string(year(prh_rcp_date)) + "-" + string(MONTH(prh_rcp_date),'99') + '-' + STRING(DAY(prh_rcp_date),'99')
                ";" ";" "采购单号: " ";" prh_nbr SKIP .
            PUT UNFORMATTED ";" "供应商名称: " ";" v_ad_name ";" ";" ";" ";" ";" "收货单号: " ";" prh_receiver SKIP.
            PUT UNFORMATTED ";" "送检部门: " SKIP .
            PUT UNFORMATTED "项" ';' '件号' ';' '名称' ';' '规格型号' ';' '旧料号' ';' 
                            '到货数量' ';' '单位' ';' "库位" ";" '备注' SKIP .
        END.
        
        v_desc1 = '' .
        v_desc2 = '' .
        FIND FIRST pt_mstr WHERE pt_part = prh_part NO-LOCK NO-ERROR.
        IF AVAIL pt_mstr THEN DO:
            v_desc1 = pt_desc1 .
            v_desc2 = pt_desc2 .
        END.
        v_vp_vend_part = '' .
        FIND FIRST vp_mstr WHERE vp_vend = prh_vend AND vp_part = pt_part NO-LOCK NO-ERROR.
        IF AVAIL vp_mstr THEN v_vp_vend_part = vp_vend_part .

        find first tr_hist where tr_lot = prh_receiver and tr_part = prh_part and tr_line = prh_line no-lock no-error.
	if avail tr_hist then v_loc = tr_loc .

        PUT UNFORMATTED prh_line ';' prh_part ';' v_desc1 ';' v_desc2 ';'
                        v_vp_vend_part ';' prh_rcvd ';' prh_um ';' v_loc ";" ' ' SKIP .
    END.
    PUT UNFORMATTED "经办人: "  ';' ';' ";" '报检日期: '  ';'
                    ';' ';' '品保签收: ' SKIP . 


   /* REPORT TRAILER  */
   {xxmfrtrail.i}

END. /* Repeat : */

{wbrp04.i &frame-spec = a}
              
			   
