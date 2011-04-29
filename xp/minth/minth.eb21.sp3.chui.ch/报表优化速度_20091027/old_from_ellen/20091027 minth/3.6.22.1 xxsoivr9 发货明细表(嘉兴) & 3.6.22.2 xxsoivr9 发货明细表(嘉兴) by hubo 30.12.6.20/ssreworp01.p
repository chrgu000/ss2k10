/* reworp01.p - REPETITIVE   CUM WORKORDER REPORT BASIC wo_mstr DATA          */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.6.1.7 $                                                           */
/* REVISION: 7.3      LAST MODIFIED: 10/31/94   BY: WUG *GN77*                */
/* REVISION: 7.3      LAST MODIFIED: 03/29/95   BY: dzn *F0PN*                */
/* REVISION: 8.5      LAST MODIFIED: 05/12/95   BY: pma *J04T*                */
/* REVISION: 8.6      LAST MODIFIED: 10/14/97   BY: mzv *K0Y7*                */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane          */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan         */
/* REVISION: 9.1      LAST MODIFIED: 11/17/99   BY: *N04H* Vivek Gogte        */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1      LAST MODIFIED: 08/12/00   BY: *N0KP* Mark Brown         */
/* REVISION: 9.1      LAST MODIFIED: 09/11/00   BY: *N0RQ* Mudit Mehta        */
/* Revision: 1.7.1.5.1  BY: Hill Cheng  DATE: 08/12/19  ECO: *SS - 20081219.01* */
/* Revision: 1.6.1.5  BY: Robin McCarthy DATE: 10/01/01 ECO: *P025* */
/* $Revision: 1.6.1.7 $ BY: Paul Donnelly (SB) DATE: 06/28/03 ECO: *Q00K* */
/*-Revision end---------------------------------------------------------------*/


/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/*V8:ConvertMode=FullGUIReport                                                */
/*
{mfdtitle.i "2+ "}
*/
{mfdeclre.i}
{ssvdef2.i " " }
/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE reworp01_p_1 "Start Eff"
/* MaxLen: Comment: */

&SCOPED-DEFINE reworp01_p_2 "Status"
/* MaxLen: Comment: */

&SCOPED-DEFINE reworp01_p_3 "Cum Moved In"
/* MaxLen: Comment: */

&SCOPED-DEFINE reworp01_p_4 "End Effective"
/* MaxLen: Comment: */

&SCOPED-DEFINE reworp01_p_5 "End Eff"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

define variable line like wo_line.
define variable line1 like wo_line label {t001.i}.
define variable lot like wo_lot.
define variable lot1 like wo_lot label {t001.i}.
define variable part like wo_part.
define variable part1 like wo_part label {t001.i}.
define variable site like wo_site.
define variable site1 like wo_site label {t001.i}.
define variable endeff as date label {&reworp01_p_4}.
define variable endeff1 as date label {t001.i}.
define variable moved_in like wr_qty_cummove label {&reworp01_p_3}.

define variable wostatus as character label {&reworp01_p_2}.
define variable active_wolot as CHARACTER.

/*SS - 20081219.01 - B*/
   DEFINE  INPUT PARAMETER i_Lot like  wo_nbr .
   DEFINE  INPUT PARAMETER i_Lot1 like wo_nbr .
   DEFINE  INPUT PARAMETER i_Part like wo_part .
   DEFINE  INPUT PARAMETER i_Part1 like wo_part .
   DEFINE  INPUT PARAMETER i_Site like wo_site .
   DEFINE  INPUT PARAMETER i_Site1 like wo_site .   
   DEFINE  INPUT PARAMETER i_Line LIKE ln_line .
   DEFINE  INPUT PARAMETER  i_Line1 LIKE ln_line .
   DEFINE  INPUT PARAMETER i_SDate like wo_rel_date .
   DEFINE  INPUT PARAMETER i_EDate like wo_rel_date .
/*SS - 20081219.01 - E*/

form
   lot                  colon 20
   lot1                 colon 45
   part                 colon 20
   part1                colon 45
   site                 colon 20
   site1                colon 45
   line                 colon 20
   line1                colon 45
   endeff               colon 20
   endeff1              colon 45
with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
/*SS - 20081219.01 - B&E*/
/*
setFrameLabels(frame a:handle).
*/
/*SS - 20081219.01 - B*/
    ASSIGN lot  = i_Lot
           lot1 = i_Lot1 
           part     = i_part    
           part1    = i_part1   
           line     = i_line    
           line1    = i_line1            
           site     = i_site    
           site1    = i_site1   
          endeff    = i_SDate
          endeff1   = I_EDate
           .	
/*SS - 20081219.01 - E*/  	

find first gl_ctrl  where gl_ctrl.gl_domain = global_domain no-lock.

{wbrp01.i}
/*SS - 20081219.01 - B*/
/*
repeat:
*/
/*SS - 20081219.01 - E*/

   if lot1 = hi_char then lot1 = "".
   if part1 = hi_char then part1 = "".
   if site1 = hi_char then site1 = "".
   if line1 = hi_char then line1 = "".

/*SS - 20081219.01 - B*/
/*
   if c-application-mode <> 'web' then
   update
      lot lot1
      part part1
      site site1
      line line1
      endeff endeff1
   with frame a.

   {wbrp06.i &command = update
      &fields = "lot lot1 part part1 site site1
        line line1 endeff endeff1"
      &frm = "a"}
*/
/*SS - 20081219.01 - E*/

   if (c-application-mode <> 'web') or
      (c-application-mode = 'web' and
      (c-web-request begins 'data'))
   then do:
/*SS - 20081219.01 - B*/
/*
      bcdparm = "".
      {mfquoter.i lot              }
      {mfquoter.i lot1             }
      {mfquoter.i part             }
      {mfquoter.i part1            }
      {mfquoter.i site             }
      {mfquoter.i site1            }
      {mfquoter.i line             }
      {mfquoter.i line1            }
      {mfquoter.i endeff           }
      {mfquoter.i endeff1          }

*/
/*SS - 20081219.01 - E*/

      if lot1 = "" then lot1 = hi_char.
      if part1 = "" then part1 = hi_char.
      if site1 = "" then site1 = hi_char.
      if line1 = "" then line1 = hi_char.

   end.

/*SS - 20081219.01 - B*/
/*
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
   {mfphead.i}
*/
/*SS - 20081219.01 - E*/
   /*NOTE: LOOK AT ALL ORDERS CLOSED OR NOT*/
   moved_in = 0.

   for each wo_mstr no-lock
          where wo_mstr.wo_domain = global_domain and (  wo_type = "c"
         and wo_lot >= lot and wo_lot <= lot1
         and wo_part >= part and wo_part <= part1
         and wo_site >= site and wo_site <= site1
         and wo_line >= line and wo_line <= line1
         and (wo_due_date >= endeff or endeff = ?)
         and (wo_due_date <= endeff1 or endeff1 = ?)
         and wo_nbr = ""
         ) use-index wo_type_part,
         each pt_mstr no-lock
          where pt_mstr.pt_domain = global_domain and  pt_part = wo_part,
         each pl_mstr no-lock
          where pl_mstr.pl_domain = global_domain and  pl_prod_line =
          pt_prod_line
         by substring(wo_type,1,1) by wo_site by wo_part
         by wo_line by wo_due_date by wo_lot with frame f-a:

      if wo_status = "C" THEN
      /*
         wostatus = getTermLabel("CLOSED",8)  */ .
         
      else do:

         if wo_due_date < today THEN
         /*
            wostatus = getTermLabel("EXPIRED",8) */ .
         else
            /* wostatus = getTermLabel("ACTIVE",8)  */.
      end.

      /* SET EXTERNAL LABELS */
      /*SS - 20081219.01 - B&E*/
      /*
      setFrameLabels(frame f-a:handle).
      */
/*SS - 20081219.01 - B*/
/*
      display
         wo_site
         wo_part
         wo_line
         wo_routing
         wo_bom_code
         wo_lot
         wo_rel_date column-label {&reworp01_p_1}
         wo_due_date column-label {&reworp01_p_5}
         wostatus
         wo_batch
      with width 132 no-box.
      {mfrpchk.i}
*/
  CREATE  ssvdef2 .
  ASSIGN  ssvdef2_site  = wo_site 
          ssvdef2_lot   = wo_lot
         ssvdef2_part   = wo_part
        ssvdef2_line    = wo_line
       ssvdef2_effdate  = wo_due_date 
    .
/*SS - 20081219.01 - E*/
      

   end.

/*SS - 20081219.01 - B*/
/*
   {mfrtrail.i}

end.

{wbrp04.i &frame-spec = a}
*/
/*SS - 20081219.01 - E*/