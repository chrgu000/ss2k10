/* Revision: eb2sp9  BY: Micho Yang         DATE: 12/28/06  ECO: *SS - 20061228.1*  */

/* DISPLAY TITLE */
{mfdtitle.i "090923 "}
{cxcustom.i "xxptcorp.p"}

{xxbmpkiq.i "new"}

DEF VAR v_qty AS DECIMAL INIT 1.
DEF VAR v_site AS CHAR INIT "CS".   /*090923 SamSong*/
DEF VAR part LIKE wo_part .
DEF VAR part1 LIKE wo_part .
DEF VAR v_tot AS DECIMAL.

def temp-table tt 
    field tt_par_part like pt_part
    field tt_part     like pt_part
    field tt_loc      like in_loc
    field tt_qty      as decimal
    field tt_um       like pt_um
    index part tt_par_part tt_part 
    .

FORM
    v_site    COLON 20     
    v_qty     COLON 20
    part      COLON 20        part1    COLON 54 SKIP
    WITH FRAME a SIDE-LABELS WIDTH 80.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

{wbrp01.i}
repeat:
    IF part1 = hi_char THEN part1 = "" .

    if c-application-mode <> 'web' then
       update v_site v_qty part part1 
    with frame a.

    {wbrp06.i &command = update &fields = "v_site v_qty part part1 " &frm = "a"}

    if (c-application-mode <> 'web') or
       (c-application-mode = 'web' and
       (c-web-request begins 'data')) then do:

      bcdparm = "".
      {mfquoter.i v_site       }
      {mfquoter.i v_qty        }
      {mfquoter.i part         }
      {mfquoter.i part1        }

      if part1 = "" then part1 = hi_char.
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
               
    FOR EACH tta6bmpkiq :
        DELETE tta6bmpkiq .
    END.
    for each tt:
        delete tt .
    end.
    FOR EACH pt_mstr NO-LOCK WHERE pt_site = v_site
                               AND pt_part >= part
                               AND pt_part <= part1 :

        /* CALL TO SECOND HALF OF PROGRAM */
        /* 展开BOM，以及取得BOM用量 */
        {gprun.i ""xxbmpkiq.p"" "(
                   INPUT pt_part , 
                   INPUT TODAY ,   
                   INPUT v_site , 
                   INPUT v_qty , 
                   INPUT 0     
                   )"  }

    END.

    for each tta6bmpkiq break by tta6bmpkiq_par_part by tta6bmpkiq_part : 
        if first-of( tta6bmpkiq_part) then do:
           create tt .
	   assign 
	       tt_par_part = tta6bmpkiq_par_part 
	       tt_part = tta6bmpkiq_part
	       tt_loc = tta6bmpkiq_loc 
	       tt_qty = tta6bmpkiq_qty 
	       tt_um = tta6bmpkiq_um 
	       .
	end.
    end.
           
    v_tot = 0.
    PUT ";" ";" "材料成本表" SKIP .
    FOR EACH tt,
        EACH pt_mstr NO-LOCK WHERE tt_part = pt_part,
        EACH sct_det NO-LOCK WHERE sct_sim = 'standard' 
                               AND sct_site = v_site 
                               AND sct_part = pt_part
                     BREAK BY tt_par_part :

        IF FIRST-OF(tt_par_part) THEN DO:
            PUT UNFORMATTED "父件号: " + tt_par_part + ";" + "数量: " + STRING(v_qty) SKIP.
            PUT UNFORMATTED "子件号" ';' '名称1' ';' "名称2" ";" '单位' ';' '标准成本' ';' '标准数量' ';' "金额" SKIP .
        END.
        PUT UNFORMATTED tt_part ';' pt_desc1 ';' pt_desc2 ';' 
            tt_um ';' sct_cst_tot ';' tt_qty ';' 
            (sct_cst_tot * tt_qty ) SKIP .
        v_tot = v_tot + (sct_cst_tot * tt_qty) .
        IF LAST-of(tt_par_part) THEN do:
            PUT UNFORMATTED '合计' ';' ';' ';' ';' ';' ';' v_tot SKIP .
	    v_tot = 0.
	end.
    END.

   /* REPORT TRAILER  */
   {xxmfrtrail.i}
END.  /* repeat: */

{wbrp04.i &frame-spec = a}
