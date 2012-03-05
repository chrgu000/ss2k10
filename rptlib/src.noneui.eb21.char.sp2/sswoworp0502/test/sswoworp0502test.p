/* woworp05.p - WORK ORDER COST REPORT                                        */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.15 $                                                        */
/*V8:ConvertMode=FullGUIReport                                                */
/* REVISION: 1.0     LAST MODIFIED: 05/01/86    BY: emb                       */
/* REVISION: 2.1     LAST MODIFIED: 09/11/87    BY: wug *A94*                 */
/* REVISION: 4.0     LAST MODIFIED: 02/24/88    BY: wug *A175*                */
/* REVISION: 4.0     LAST MODIFIED: 03/30/88    BY: rxl *A171*                */
/* REVISION: 4.0     LAST MODIFIED: 01/04/89    BY: flm *A579*                */
/* REVISION: 5.0     LAST MODIFIED: 01/24/90    BY: ftb *B531*                */
/* REVISION: 5.0     LAST MODIFIED: 02/12/90    BY: wug *B562*                */
/* REVISION: 5.0     LAST MODIFIED: 05/15/90    BY: ram *B688*                */
/* REVISION: 5.0     LAST MODIFIED: 01/08/91    BY: ram *B870*                */
/* REVISION: 6.0     LAST MODIFIED: 05/01/91    BY: ram *D611*                */
/* REVISION: 7.0     LAST MODIFIED: 10/23/91    BY: pma *F003*                */
/* REVISION: 7.3     LAST MODIFIED: 04/23/93    BY: ram *GA24*                */
/* REVISION: 7.3     LAST MODIFIED: 04/28/93    BY: pma *GA47*(rev only)      */
/* REVISION: 7.4     LAST MODIFIED: 03/29/95    BY: dzn *F0PN*                */
/* REVISION: 8.6     LAST MODIFIED: 10/14/97    BY: ays *K0XV*                */
/* REVISION: 7.4     LAST MODIFIED: 02/05/98    BY: *H1JC* Jean Miller        */
/* REVISION: 8.6E    LAST MODIFIED: 02/23/98    BY: *L007* A. Rahane          */
/* REVISION: 8.6E    LAST MODIFIED: 10/04/98    BY: *J314* Alfred Tan         */
/* REVISION: 9.1     LAST MODIFIED: 03/24/00    BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1     LAST MODIFIED: 08/12/00    BY: *N0KC* Mark Brown         */
/* Revision: 1.11    BY: Jyoti Thatte           DATE: 04/03/01 ECO: *P008*    */
/* Revision: 1.14    BY: Vivek Gogte            DATE: 04/30/01 ECO: *P001*    */
/* $Revision: 1.15 $  BY: Manjusha Inglay        DATE: 08/28/01 ECO: *P01R*   */
/* $Revision: 1.15 $  BY: Bill Jiang        DATE: 07/19/08 ECO: *SS - 20080719.1*   */

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* SS - 20080719.1 - B */
{sswoworp0502.i "new"}
/* SS - 20080719.1 - E */                                                                              

/* DISPLAY TITLE */
/* SS - 20080719.1 - B */
/*
{mfdtitle.i "b+ "}
*/
{mfdtitle.i "20080719.1"}
/* SS - 20080719.1 - E */                                                                              

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE woworp05_p_1 "Subcontract"
/* MaxLen: Comment: */

&SCOPED-DEFINE woworp05_p_2 "Material"
/* MaxLen: Comment: */

&SCOPED-DEFINE woworp05_p_3 "Page Break on Work Order"
/* MaxLen: Comment: */

&SCOPED-DEFINE woworp05_p_4 "Burden"
/* MaxLen: Comment: */

&SCOPED-DEFINE woworp05_p_5 "Labor"
/* MaxLen: Comment: */

&SCOPED-DEFINE woworp05_p_6 "Detail/Summary"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

define new shared variable nbr    like wo_nbr.
define new shared variable nbr1   like wo_nbr.
define new shared variable lot    like wo_lot.
define new shared variable lot1   like wo_lot.
define new shared variable site   like wo_site no-undo.
define new shared variable site1  like wo_site no-undo.
define new shared variable part   like wo_part.
define new shared variable part1  like wo_part.
define new shared variable due    like wo_due_date.
define new shared variable due1   like wo_due_date.
define new shared variable vend   like wo_vend.
define new shared variable so_job like wo_so_job.
define new shared variable stat   like wo_status.

define new shared variable skpage like mfc_logical initial yes
                                  label "Page Break on Work Order".
define new shared variable mtlyn  like mfc_logical initial yes
                                  label "Material" format "Detail/Summary".
define new shared variable lbryn  like mfc_logical initial yes
                                  label "Labor" format "Detail/Summary".
define new shared variable bdnyn  like mfc_logical initial yes
                                  label "Burden" format "Detail/Summary".
define new shared variable subyn  like mfc_logical initial yes
                                  label "Subcontract" format "Detail/Summary".

/* SS - 20080719.1 - B */
define variable acct_close like wo_acct_close initial yes .
define variable CLOSE_date   like wo_close_date.
define variable close_date1  like wo_close_date.
define variable CLOSE_eff   like wo_close_eff.
define variable close_eff1  like wo_close_eff.
/* SS - 20080719.1 - E */

form
   nbr         colon 15
   nbr1        label {t001.i} colon 49 skip
   lot         colon 15
   lot1        label {t001.i} colon 49 skip
   site        colon 15
   site1       label {t001.i} colon 49 skip
   part        colon 15
   part1       label {t001.i} colon 49 skip
   due         colon 15
   due1        label {t001.i} colon 49 
   skip (1)
   /* SS - 20080719.1 - B */
   acct_close      colon 30
   CLOSE_date         colon 15
   close_date1        label {t001.i} colon 49 skip 
   CLOSE_eff         colon 15
   close_eff1        label {t001.i} colon 49 skip (1)
   /* SS - 20080719.1 - E */
   so_job      colon 30 skip
   vend        colon 30 skip
   stat        colon 30 
   /* SS - 20080719.1 - B */
   /*
   skip (1)
   mtlyn       colon 30 skip
   lbryn       colon 30 skip
   bdnyn       colon 30 skip
   subyn       colon 30 skip
   skpage      colon 30
   */
   /* SS - 20080719.1 - E */
with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

{wbrp01.i}

repeat on error undo, retry:

   if nbr1  = hi_char then nbr1 = "".
   if lot1  = hi_char then lot1 = "".
   if site1 = hi_char then site1 = "".

   if c-application-mode <> "WEB" then
   update
      nbr      nbr1
      lot      lot1
      site     site1
      part     part1
      due      due1
      /* SS - 20080719.1 - B */
      acct_close
      CLOSE_date CLOSE_date1
      CLOSE_eff CLOSE_eff1
      /* SS - 20080719.1 - E */
      so_job
      vend
      stat
      /* SS - 20080719.1 - B */
      /*
      mtlyn lbryn bdnyn subyn
      skpage
      */
      /* SS - 20080719.1 - E */
   with frame a.

   /* SS - 20080719.1 - B */
   /*
   {wbrp06.i &command = update &fields = "  nbr nbr1 lot lot1 site site1
             part part1 due due1 so_job vend stat   mtlyn lbryn bdnyn subyn
             skpage" &frm = "a"}
   */
   {wbrp06.i &command = update &fields = "  nbr nbr1 lot lot1 site site1
             part part1 due due1 
      acct_close close_date close_date1 close_eff close_eff1 
      so_job vend stat   
      " &frm = "a"}
   /* SS - 20080719.1 - E */

   if (c-application-mode <> "WEB") or
      (c-application-mode = "WEB" and
      (c-web-request begins "DATA")) then do:

      bcdparm = "".
      {mfquoter.i nbr     }
      {mfquoter.i nbr1    }
      {mfquoter.i lot     }
      {mfquoter.i lot1    }
      {mfquoter.i site    }
      {mfquoter.i site1   }
      {mfquoter.i part    }
      {mfquoter.i part1   }
      {mfquoter.i due     }
      {mfquoter.i due1    }
      /* SS - 20080719.1 - B */
      {mfquoter.i acct_close     }
      {mfquoter.i CLOSE_date     }
      {mfquoter.i close_date1    }
      {mfquoter.i CLOSE_eff     }
      {mfquoter.i close_eff1    }
      /* SS - 20080719.1 - E */
      {mfquoter.i so_job  }
      {mfquoter.i vend    }
      {mfquoter.i stat    }
      {mfquoter.i mtlyn   }
      {mfquoter.i lbryn   }
      {mfquoter.i bdnyn   }
      {mfquoter.i subyn   }
      {mfquoter.i skpage  }

      /* ADD THIS DO LOOP SO THE CONVERTER WONT CREATE AN 'ON LEAVE' */
      do:

         if index("PFEARCB",stat) = 0 and stat <> ""
            then do with frame a:
            /* INVALID STATUS */
            {pxmsg.i &MSGNUM=19 &ERRORLEVEL=3}
            if c-application-mode = "WEB" then return.
            else
               next-prompt stat with frame a.
            undo, retry.
         end.
      end.

   end. /* if c-application-mode */

   /* SELECT PRINTER */
   {gpselout.i
       &printType = "printer"
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

   /* SS - 20080719.1 - B */
   /*
   {mfphead.i}
   */
   /* SS - 20080719.1 - E */

   if nbr1  = "" then nbr1 = hi_char.
   if lot1  = "" then lot1 = hi_char.
   if site1 = "" then site1 = hi_char.

   /* SS - 20080719.1 - B */
   /*
   {gprun.i ""woworp5a.p""}

   {mfrtrail.i}
    */
   PUT UNFORMATTED "BEGIN: " + STRING(TIME, "HH:MM:SS") SKIP.

   EMPTY TEMP-TABLE ttsswoworp0502.

    {gprun.i ""sswoworp0502.p"" "(
        INPUT nbr,
        INPUT nbr1,
        INPUT lot,
        INPUT lot1,
        INPUT site,
        INPUT site1,
        INPUT part,
        INPUT part1,
        INPUT due,
        INPUT due1,

        INPUT so_job,
        INPUT vend,
        INPUT stat,

        INPUT mtlyn,
        INPUT lbryn,
        INPUT bdnyn,
        INPUT subyn,

        INPUT skpage,

        INPUT acct_close,
        INPUT CLOSE_date,
        INPUT CLOSE_date1,
        INPUT CLOSE_eff,
        INPUT CLOSE_eff1
        )"}

    EXPORT DELIMITER ";" "wo_nbr" "wo_lot" "wo_batch" "wo_rmks" "wo_part" "wo_so_job" "wo_qty_ord" "wo_ord_date" "glx_mthd" "desc1" "wo_qty_comp" "wo_rel_date" "premsg" "wo_status" "wo_vend" "wo_qty_rjct" "wo_due_date" "mtl_expcst" "mtl_acrvar" "mtl_acccst" "mtl_rtevar" "mtl_usevar" "mtl_wowipx" "mtl_wipamt" "lbr_expcst" "lbr_acrvar" "lbr_acccst" "lbr_rtevar" "lbr_usevar" "lbr_wowipx" "lbr_wipamt" "bdn_expcst" "bdn_acrvar" "bdn_acccst" "bdn_rtevar" "bdn_usevar" "bdn_wowipx" "bdn_wipamt" "sub_expcst" "sub_acrvar" "sub_acccst" "sub_rtevar" "sub_usevar" "sub_wowipx" "sub_wipamt".
    FOR EACH ttsswoworp0502:
        EXPORT DELIMITER ";" ttsswoworp0502.
    END.

    PUT UNFORMATTED "END: " + STRING(TIME, "HH:MM:SS") SKIP.

    {ssmfrtrail.i}
    /* SS - 20080719.1 - E */

end. /* REPEAT */

{wbrp04.i &frame-spec = a}
