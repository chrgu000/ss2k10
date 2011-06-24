/* Revision: eb2sp9  BY: Micho Yang         DATE: 12/28/06  ECO: *SS - 20061228.1*  */

/* DISPLAY TITLE */
{mfdtitle.i "2+ "}
{cxcustom.i "xxptcorp.p"}

{xxbmpkiq.i "new"}

DEF VAR v_qty AS DECIMAL INIT 1.
DEF VAR v_site AS CHAR INIT "CF".
DEF VAR v_part LIKE wo_part .
DEF VAR v_tot AS DECIMAL.

FORM
    v_part     COLON 20     
    v_site     COLON 20
    v_qty      COLON 20   
    WITH FRAME a SIDE-LABELS WIDTH 80.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

{wbrp01.i}
repeat:

    if c-application-mode <> 'web' then
       update v_part v_site v_qty 
    with frame a.

    {wbrp06.i &command = update &fields = " v_part v_site v_qty " &frm = "a"}

    if (c-application-mode <> 'web') or
       (c-application-mode = 'web' and
       (c-web-request begins 'data')) then do:

      bcdparm = "".
      {mfquoter.i v_part       }
      {mfquoter.i v_site        }
      {mfquoter.i v_qty         }

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
    FOR EACH wo_mstr NO-LOCK WHERE wo_site = v_site
                               AND wo_part = v_part :

        /* CALL TO SECOND HALF OF PROGRAM */
        /* 展开BOM，以及取得BOM用量 */
        {gprun.i ""xxbmpkiq.p"" "(
                   INPUT wo_part , 
                   INPUT TODAY ,   
                   INPUT v_site , 
                   INPUT v_qty , 
                   INPUT 0     
                   )"  }

    END.
     
    for each tta6bmpkiq break by tta6bmpkiq_part :
        if first-of ( tta6bmpkiq_part) then do:

	put unformatted tta6bmpkiq_par_part  ';'
                        tta6bmpkiq_part   ';'
                        tta6bmpkiq_part_desc ';'
                        tta6bmpkiq_loc  ';'
                        tta6bmpkiq_qty  ';'
                        tta6bmpkiq_um  ';'
                        tta6bmpkiq_op   ';' skip .
			end.
    end.

   /* REPORT TRAILER  */
   {xxmfrtrail.i}
END.  /* repeat: */

{wbrp04.i &frame-spec = a}
