/* woworp09.p - WORK ORDER WIP VALUATION REPORT                               */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.8 $                                                       */
/*V8:ConvertMode=FullGUIReport                                                */
/* REVISION: 4.0    LAST EDIT:     04/14/88   MODIFIED BY: flm  *    *        */
/* REVISION: 4.0    LAST EDIT:     03/06/88   MODIFIED BY: flm  *A663*        */
/* REVISION: 5.0    LAST EDIT:     04/10/89   MODIFIED BY: MLB  *B096         */
/* REVISION: 7.0    LAST EDIT:     08/30/94   MODIFIED BY: ais  *FQ61*        */
/* REVISION: 8.6    LAST MODIFIED: 10/14/97            BY: ays *K0YS*         */
/* REVISION: 9.1    LAST MODIFIED: 10/01/99   BY: *N014* Patti Gaultney       */
/* REVISION: 9.1    LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane     */
/* REVISION: 9.1    LAST MODIFIED: 08/12/00   BY: *N0KC* Mark Brown           */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.7     BY: Jyoti Thatte      DATE: 04/03/01 ECO: *P008*         */
/* $Revision: 1.8 $  BY: Manjusha Inglay   DATE: 08/28/01 ECO: *P01R*      */
/* $Revision: 1.8 $  BY: Bill Jiang   DATE: 05/06/08 ECO: *SS - 20080506.1*      */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* DISPLAY TITLE */
/* SS - 20080506.1 - B */
define input parameter i_acct   like wo_acct.
define input parameter i_acct1  like wo_acct.
define input parameter i_sub    like wo_sub.
define input parameter i_sub1   like wo_sub.
define input parameter i_cc     like wo_cc.
define input parameter i_cc1    like wo_cc.
define input parameter i_proj   like wo_project.
define input parameter i_proj1  like wo_project.

define input parameter i_nbr    like wo_nbr.
define input parameter i_nbr1   like wo_nbr.
define input parameter i_lot    like wo_lot.
define input parameter i_lot1   like wo_lot.
define input parameter i_part   like wo_part.
define input parameter i_part1  like wo_part.
define input parameter i_site   like wo_site.
define input parameter i_site1  like wo_site.

define input parameter i_so_job like wo_so_job.
define input parameter i_vend   like wo_vend.
/*
{mfdtitle.i "b+ "}
*/
{ssmfdtitle.i "b+ "}
/* SS - 20080506.1 - E */

define new shared variable nbr    like wo_nbr.
define new shared variable nbr1   like wo_nbr.
define new shared variable lot    like wo_lot.
define new shared variable lot1   like wo_lot.
define new shared variable part   like wo_part.
define new shared variable site1  like wo_site.
define new shared variable site   like wo_site.
define new shared variable part1  like wo_part.
define new shared variable acct   like wo_acct.
define new shared variable acct1  like wo_acct.
define new shared variable sub    like wo_sub.
define new shared variable sub1   like wo_sub.
define new shared variable cc     like wo_cc.
define new shared variable cc1    like wo_cc.
define new shared variable proj   like wo_project.
define new shared variable proj1  like wo_project.
define new shared variable vend   like wo_vend.
define new shared variable so_job like wo_so_job.

form
   acct                          colon 15
   acct1          label {t001.i} colon 49 skip
   sub                           colon 15
   sub1           label {t001.i} colon 49 skip
   cc                            colon 15
   cc1            label {t001.i} colon 49 skip
   proj                          colon 15
   proj1          label {t001.i} colon 49 skip (1)
   nbr                           colon 15
   nbr1           label {t001.i} colon 49 skip
   lot                           colon 15
   lot1           label {t001.i} colon 49 skip
   part                          colon 15
   part1          label {t001.i} colon 49
   site                          colon 15
   site1          label {t001.i} colon 49 skip (1)
   so_job                        colon 15 skip
   vend                          colon 15 skip (1)
with frame a side-labels width 80 attr-space.

/* SS - 20080506.1 - B */
/*
/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).
*/
acct = i_acct.
acct1 = i_acct1.
sub = i_sub.
sub1 = i_sub1.
cc = i_cc.
cc1 = i_cc1.
proj = i_proj.
proj1 = i_proj1.
nbr = i_nbr.
nbr1 = i_nbr1.
lot = i_lot.
lot1 = i_lot1.
part = i_part.
part1 = i_part1.
site = i_site.
site1 = i_site1.
so_job = i_so_job.
vend = i_vend.
/* SS - 20080506.1 - E */

{wbrp01.i}

    /* SS - 20080506.1 - B */
    /*
repeat:

   if c-application-mode <> 'web' then
   update
      acct   acct1
      sub    sub1
      cc     cc1
      proj   proj1
      nbr    nbr1
      lot    lot1
      part   part1
      site   site1
      so_job vend
   with frame a.

   /* ADD SUB AND SUB1 TO PARAMETER LIST BELOW */
   {wbrp06.i &command = update
      &fields = " acct   acct1
                  sub    sub1
                  cc     cc1
                  proj   proj1
                  nbr    nbr1
                  lot    lot1
                  part   part1
                  site   site1
                  so_job vend"
      &frm = "a"}
   */
   /* SS - 20080506.1 - E */

   if (c-application-mode <> "WEB") or
      (c-application-mode = "WEB" and
      (c-web-request begins 'data'))
   then do:

      bcdparm = "".
      {mfquoter.i acct   }
      {mfquoter.i acct1  }
      {mfquoter.i sub    }
      {mfquoter.i sub1   }
      {mfquoter.i cc     }
      {mfquoter.i cc1    }
      {mfquoter.i proj   }
      {mfquoter.i proj1  }
      {mfquoter.i nbr    }
      {mfquoter.i nbr1   }
      {mfquoter.i lot    }
      {mfquoter.i lot1   }
      {mfquoter.i part   }
      {mfquoter.i part1  }
      {mfquoter.i site   }
      {mfquoter.i site1  }
      {mfquoter.i so_job }
      {mfquoter.i vend   }
   end.

   /* SS - 20080506.1 - B */
   /*
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

   {mfphead.i}

   {gprun.i ""woworp9a.p""}

   {mfrtrail.i}

end. /*REPEAT*/
   */
   define variable l_textfile        as character no-undo.
   {gprun.i ""sswoworp0901a.p""}
   /* SS - 20080506.1 - E */

{wbrp04.i &frame-spec = a}
