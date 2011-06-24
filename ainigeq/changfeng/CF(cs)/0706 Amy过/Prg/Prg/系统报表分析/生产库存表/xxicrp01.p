/* Revision: eb2sp9  BY: Micho Yang         DATE: 12/28/06  ECO: *SS - 20061228.1*  */

/* DISPLAY TITLE */
{mfdtitle.i "2+ "}
{cxcustom.i "xxicrp01.P"}

DEF VAR part LIKE pt_part .
DEF VAR part1 LIKE pt_part .
DEF VAR effdate LIKE tr_effdate .
DEF VAR effdate1 LIKE tr_effdate .
DEF VAR loc LIKE ld_loc .
DEF VAR loc1 LIKE ld_loc .
DEF VAR v_loc LIKE ld_loc .
DEF VAR v_sq_qty AS DECIMAL.
DEF VAR v_th_qty AS DECIMAL.
DEF VAR v_bhg_qty AS DECIMAL.
DEF VAR v_rctwo_qty AS DECIMAL.
DEF VAR v_gf_qty AS DECIMAL.
DEF VAR v_lx_qty AS DECIMAL.
DEF VAR v_rctunp_qty AS DECIMAL.
DEF VAR v_issunp_qty AS DECIMAL.
DEF VAR v_bq_qty AS DECIMAL.
DEF VAR v_bhg_ld_qty_oh AS DECIMAL.
DEF VAR v_ld_qty_oh AS DECIMAL.
def var v_date as char.
def var v_date1 as char.

DEF BUFFER lddet FOR ld_det .

DEF TEMP-TABLE tt 
    FIELD tt_part LIKE pt_part 
    FIELD tt_desc1 LIKE pt_desc1 
    FIELD tt_um LIKE pt_um
    FIELD tt_sq_qty AS DECIMAL
    FIELD tt_th_qty AS DECIMAL
    FIELD tt_bhg_qty AS DECIMAL
    FIELD tt_rctwo_qty AS DECIMAL
    FIELD tt_gf_qty AS DECIMAL
    FIELD tt_lx_qty AS DECIMAL
    FIELD tt_rctunp_qty AS DECIMAL
    FIELD tt_issunp_qty AS DECIMAL
    FIELD tt_bq_qty AS DECIMAL
    INDEX part tt_part 
    .

FORM
    effdate    COLON 20      effdate1     COLON 54 SKIP
    loc        colon 20      loc1         colon 54 skip
    part       COLON 20      part1        COLON 54 SKIP
    v_loc      COLON 20 SKIP(1)
    WITH FRAME a SIDE-LABELS WIDTH 80.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

{wbrp01.i}
repeat:
    IF effdate = low_date THEN effdate = ?  .
    IF effdate1 = hi_date THEN effdate1 = ?.
    IF loc1 = hi_char THEN loc1 = "" .
    IF part1 = hi_char THEN part1 = "" .

    effdate1 = TODAY .
    effdate = DATE( MONTH(TODAY),1 ,YEAR(TODAY) ) .

    if c-application-mode <> 'web' then
       update effdate effdate1 loc loc1 part part1 v_loc 
    with frame a.

    {wbrp06.i &command = update &fields = " effdate effdate1 loc loc1 part part1 v_loc  " &frm = "a"}

    if (c-application-mode <> 'web') or
       (c-application-mode = 'web' and
       (c-web-request begins 'data')) then do:

      bcdparm = "".
      {mfquoter.i effdate       }
      {mfquoter.i effdate1      }
      {mfquoter.i loc       }
      {mfquoter.i loc1      }
      {mfquoter.i part       }
      {mfquoter.i part1      }
      {mfquoter.i v_loc     }

      if effdate = ? THEN effdate = low_date .
      IF effdate1 = ? THEN effdate1 = hi_date .
      if loc1 = "" then loc1 = hi_char.
      IF part1 = "" THEN part1 = hi_char .

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

    FOR EACH tt :
        DELETE tt .
    END.

    v_date = STRING(YEAR(effdate)) + "-" + STRING(MONTH(effdate),'99') + "-" + STRING(DAY(effdate),"99") .
    v_date1 = STRING(YEAR(effdate1)) + "-" + STRING(MONTH(effdate1),'99') + "-" + STRING(DAY(effdate1),"99") .

    PUT ";" ";" "生产库存表" SKIP .
    PUT unformatted ";" "开始日期: " + v_date + ";" ';' 
                        "结束日期: " + v_date1  SKIP(1).
    put "料号" ';' "名称" ';' "单位" ';' "上期库存数" ';' "退货数量" ';' "不合格数量" ';' "工单入库数" ';' "股份发运数" ';' "零星销售数" ';' 
        "料单入库数" ';' '料单出库数' ';' '当前库存' skip .

    for each ld_det no-lock where ld_loc >= loc and ld_loc <= loc1 
                              AND ld_part >= part AND ld_part <= part1 ,
        each pt_mstr no-lock where pt_part =ld_part :

        v_ld_qty_oh = 0.
        v_bhg_ld_qty_oh = 0 .
	    for each lddet no-lock WHERE lddet.ld_site = pt_site AND lddet.ld_loc = pt_loc 
                                 AND lddet.ld_part = pt_part  :
            v_ld_qty_oh = v_ld_qty_oh + lddet.ld_qty_oh .
            IF lddet.ld_loc = v_loc THEN v_bhg_ld_qty_oh = v_bhg_ld_qty_oh + lddet.ld_qty_oh .
        END.

        /* MESSAGE STRING(v_ld_qty_oh) + " " + string(v_bhg_ld_qty_oh) VIEW-AS ALERT-BOX.*/
        v_sq_qty = v_ld_qty_oh .
        v_th_qty = 0.
        v_bhg_qty  = v_bhg_ld_qty_oh .
        v_rctwo_qty = 0.
        v_gf_qty    = 0.
        v_lx_qty    = 0.
        v_rctunp_qty = 0.
        v_issunp_qty = 0.
        v_bq_qty     = v_ld_qty_oh.
	    FOR each tr_hist no-lock where tr_part = pt_part 
				   and tr_site = pt_site 
				   and tr_loc = pt_loc
                   BREAK BY tr_effdate DESCENDING :
            if not (tr_type = "RCT-PO" AND tr_ship_type = "s" ) AND tr_effdate >= effdate then do:
                v_sq_qty = v_sq_qty - tr_qty_loc .
                /* MESSAGE STRING(v_sq_qty) + "  " + STRING(tr_qty_loc) VIEW-AS ALERT-BOX. */
            end.

        	if tr_effdate >= effdate and tr_effdate <= effdate1
        	   and tr_type = 'iss-so' and tr_qty_loc > 0 then do:
                v_th_qty = v_th_qty + tr_qty_loc .
        	end.
        
        	if tr_effdate >= effdate and tr_effdate <= effdate1 
               AND not (tr_type = "RCT-PO" AND tr_ship_type = "s" ) AND tr_loc = v_loc then do:
                v_bhg_qty = v_bhg_qty - tr_qty_loc  .
        	end .
        
        	if tr_effdate >= effdate and tr_effdate <= effdate1 
               AND tr_type = 'rct-wo' then do:
                v_rctwo_qty = v_rctwo_qty + tr_qty_loc .
        	end.
                
        	if tr_effdate >= effdate and tr_effdate <= effdate1 
               AND tr_type = 'iss-so' and tr_addr = '1001' then do:
        	    v_gf_qty = v_gf_qty + tr_qty_loc .
        	end.
        
        	if tr_effdate >= effdate and tr_effdate <= effdate1 
               AND tr_type = 'iss-so' and tr_addr = '1002' then do:
                v_lx_qty = v_lx_qty + tr_qty_loc .
        	end.
        
        	if tr_effdate >= effdate and tr_effdate <= effdate1  
               AND tr_type = 'rct-unp' then do:
        	    v_rctunp_qty = v_rctunp_qty + tr_qty_loc .
        	end.
        
        	if tr_effdate >= effdate and tr_effdate <= effdate1 
               AND tr_type = 'iss-unp' then do:
        	    v_issunp_qty = v_issunp_qty + tr_qty_loc .
        	end.
         
            if not (tr_type = "RCT-PO" AND tr_ship_type = "s" ) AND tr_effdate > effdate1 THEN v_bq_qty = v_bq_qty - tr_qty_loc .
        end. /* for each tr_hist */

        CREATE tt .
        ASSIGN
            tt_part = pt_part 
            tt_desc1 = pt_desc1 
            tt_um = pt_um
            tt_sq_qty = v_sq_qty 
            tt_th_qty = v_th_qty
            tt_bhg_qty = v_bhg_qty 
            tt_rctwo_qty = v_rctwo_qty 
            tt_gf_qty = v_gf_qty
            tt_lx_qty = v_lx_qty
            tt_rctunp_qty = v_rctunp_qty
            tt_issunp_qty = v_issunp_qty
            tt_bq_qty = v_bq_qty 
            .

    end. /* for each ld_det */

    FOR EACH tt :
        PUT UNFORMATTED tt_part ';' tt_desc1 ';' tt_um ';' tt_sq_qty ';' tt_th_qty ';' tt_bhg_qty ';' tt_rctwo_qty ';' tt_gf_qty ';' tt_lx_qty ';' tt_rctunp_qty ';' tt_issunp_qty ';' tt_bq_qty SKIP .
    END.
    
   /* REPORT TRAILER  */
   {xxmfrtrail.i}

END. /* Repeat : */

{wbrp04.i &frame-spec = a}
              
			   
