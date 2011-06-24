/* Revision: eb2sp9  BY: Micho Yang         DATE: 12/28/06  ECO: *SS - 20061228.1*  */

/* DISPLAY TITLE */
{mfdtitle.i "2+ "}
{cxcustom.i "xxwowrrp.P"}

DEF VAR nbr LIKE wo_nbr .
DEF VAR nbr1 LIKE wo_nbr.
def var lot like wo_lot .
def var lot1 like wo_lot .
DEF VAR loc LIKE IN_loc.
DEF VAR loc1 LIKE IN_loc .
DEF VAR v_qty AS DECIMAL INIT 1 .
DEF VAR v_flag AS LOGICAL INIT NO LABEL "是否显示未短缺量" .
def var v_in_qty as decimal.
DEF VAR v_page_flag AS LOGICAL .

DEF TEMP-TABLE tt 
    FIELD tt_wo_nbr LIKE wo_nbr 
    field tt_wo_lot like wo_lot 
    FIELD tt_wo_part LIKE wo_part
    FIELD tt_wod_part LIKE wod_part
    field tt_pt_desc1 like pt_desc1 
    FIELD tt_req_qty AS DECIMAL
    FIELD tt_qty_oh AS DECIMAL
    FIELD tt_wr_qty AS DECIMAL
    INDEX nbr_part tt_wo_nbr tt_wo_part tt_wod_part  
    .

FORM
    nbr    COLON 20      nbr1     COLON 54 SKIP
    lot    colon 20      lot1     colon 54 skip
    loc    COLON 20      loc1     COLON 54 SKIP
    v_qty  COLON 20      SKIP
    v_flag COLON 20      SKIP
    WITH FRAME a SIDE-LABELS WIDTH 80.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

{wbrp01.i}
repeat:
    IF nbr1 = hi_char THEN nbr1 = "" .
    IF lot1 = hi_char THEN lot1 = "" .
    IF loc1 = hi_char THEN loc1 = "" .

    if c-application-mode <> 'web' then
       update nbr nbr1 lot lot1 loc loc1 v_qty v_flag 
    with frame a.

    {wbrp06.i &command = update &fields = " nbr nbr1 lot lot1 loc loc1 v_qty 
               v_flag " &frm = "a"}

    if (c-application-mode <> 'web') or
       (c-application-mode = 'web' and
       (c-web-request begins 'data')) then do:

      bcdparm = "".
      {mfquoter.i nbr       }
      {mfquoter.i nbr1      }
      {mfquoter.i lot       }
      {mfquoter.i lot1      }
      {mfquoter.i loc       }
      {mfquoter.i loc1      }
      {mfquoter.i v_qty     }
      {mfquoter.i v_flag    }

      if nbr1 = "" then nbr1 = hi_char.
      if lot1 = "" then lot1 = hi_char.
      if loc1 = "" then loc1 = hi_char.
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

    /* PUT ";" ";" ";" "工单欠料表" SKIP. */
    for each wo_mstr no-lock where wo_nbr >= nbr AND wo_nbr <= nbr1
                               and wo_lot >= lot and wo_lot <= lot1 ,
        each wod_det no-lock where wod_nbr = wo_nbr and wod_lot = wo_lot,
        each pt_mstr no-lock where pt_part = wod_part  :
   
        v_in_qty = 0.
        for each ld_det no-lock where ld_site = wod_site and ld_part = wod_part
	                           and ld_loc >= loc and ld_loc <= loc1 :
            v_in_qty = v_in_qty + ld_qty_oh .
	    end.

        IF v_flag = NO THEN DO:
           IF (wod_bom_qty * v_qty) > v_in_qty THEN DO:
                CREATE tt.
                ASSIGN
                    tt_wo_nbr = wo_nbr 
		            tt_wo_lot = wo_lot 
                    tt_wo_part = wo_part
                    tt_wod_part = wod_part
		            tt_pt_desc1 = pt_desc1
                    tt_req_qty = (wod_bom_qty * v_qty)
                    tt_qty_oh  = v_in_qty
                    tt_wr_qty  = ((wod_bom_qty * v_qty) - v_in_qty)
                    .
           END.                                                                                                                                                             
        END.
        ELSE DO:
                CREATE tt.
                ASSIGN
                    tt_wo_nbr = wo_nbr 
		            tt_wo_lot = wo_lot
                    tt_wo_part = wo_part
                    tt_wod_part = wod_part
		            tt_pt_desc1 = pt_desc1
                    tt_req_qty = (wod_bom_qty * v_qty)
                    tt_qty_oh  = v_in_qty
                    .
           IF (wod_bom_qty * v_qty) > v_in_qty THEN ASSIGN tt_wr_qty  = ((wod_bom_qty * v_qty) - v_in_qty ) .
                                               ELSE ASSIGN tt_wr_qty  = 0 .
        END.                                                                                                 
    end.  /* for each wo_mstr */

    FOR EACH tt BREAK BY tt_wo_nbr by tt_wo_lot :
        IF FIRST-OF(tt_wo_lot) OR v_page_flag = YES THEN DO:
            PUT UNFORMATTED "工单: " + tt_wo_nbr + "    标志: " + tt_wo_lot  +  "    数量: " + STRING(v_qty) FORMAT "x(95)" SKIP(1).
            PUT UNFORMATTED "父料号             料号               名称                         需求量   库存数量     欠料量" SKIP.
            PUT UNFORMATTED "------------------ ------------------ ------------------------ ---------- ---------- ----------" SKIP .
        END.    
        v_page_flag = NO.
        IF PAGE-SIZE - LINE-COUNTER <= 4 THEN DO:
            PAGE .
            v_page_flag = YES .
        END.
        PUT UNFORMATTED tt_wo_part  AT 1.
        PUT UNFORMATTED tt_wod_part AT 20.
        PUT UNFORMATTED tt_pt_desc1 AT 39.
        PUT UNFORMATTED tt_req_qty  TO 73.
        PUT UNFORMATTED tt_qty_oh   TO 84.
        PUT UNFORMATTED tt_wr_qty   TO 95.
        PUT SKIP.
        IF LAST-OF(tt_wo_lot) THEN DO:
            PAGE.
        END.
    END.
    
   /* REPORT TRAILER  */
   {mfrtrail.i}

END. /* Repeat : */

{wbrp04.i &frame-spec = a}
              
			   
