/* porvrp.p - PURCHASE ORDER RETURN TO VENDOR PRINT                     */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/* $Revision: 1.14 $                                                */
/*V8:ConvertMode=Report                                                 */
/* REVISION: 6.0     LAST MODIFIED: 08/10/90    BY: RAM *D030*          */
/* REVISION: 6.0     LAST MODIFIED: 09/18/90    BY: MLB *D055*          */
/* REVISION: 6.0     LAST MODIFIED: 11/02/90    BY: PML *D171*          */
/* REVISION: 6.0     LAST MODIFIED: 11/14/90    BY: MLB *D200*          */
/* REVISION: 6.0     LAST MODIFIED: 10/03/91    BY: RAM *D890*          */
/* REVISION: 6.0     LAST MODIFIED: 01/07/92    BY: RAM *D979*          */
/* REVISION: 7.0     LAST MODIFIED: 02/03/92    BY: RAM *F144*          */
/* REVISION: 7.3     LAST MODIFIED: 09/29/92    BY: tjs *G088*(rev only)*/
/* REVISION: 7.3     LAST MODIFIED: 04/09/93    BY: afs *G926*          */
/*                                  09/10/94    BY: bcm *GM03*          */
/*                                  11/18/94    BY: bcm *GO37*          */
/* REVISION: 7.4     LAST MODIFIED: 01/18/96    BY: rxm *H0J4*          */
/* REVISION: 8.5     LAST MODIFIED: 04/26/96    BY: jpm *H0KS*          */
/* REVISION: 7.4     LAST MODIFIED: 02/25/97    BY: *H0ST* Aruna Patil  */
/* REVISION: 8.6E    LAST MODIFIED: 02/23/98    BY: *L007* A. Rahane    */
/* REVISION: 8.6E    LAST MODIFIED: 05/20/98    BY: *K1Q4* Alfred Tan   */
/* REVISION: 8.6E    LAST MODIFIED: 10/04/98    BY: *J314* Alfred Tan   */
/* REVISION: 9.0     LAST MODIFIED: 02/06/99    BY: *M06R* Doug Norton  */
/* REVISION: 9.0     LAST MODIFIED: 03/13/99    BY: *M0BD* Alfred Tan   */
/* REVISION: 9.1     LAST MODIFIED: 07/29/99    BY: *N01B* John Corda   */
/* REVISION: 9.1     LAST MODIFIED: 03/24/00    BY: *N08T* Annasaheb Rahane */
/* REVISION: 9.1     LAST MODIFIED: 08/13/00    BY: *N0KQ* myb          */
/* Old ECO marker removed, but no ECO header exists *F0PN*              */
/* $Revision: 1.14 $    BY: Katie Hilbert  DATE: 04/01/01 ECO: *P002*  */
/* $Revision: 1.14 $    BY: Micho Yang     DATE: 03/20/06 ECO: *SS - 20060320*  */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* DISPLAY TITLE */
{mfdtitle.i "b+ "}

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE porvrp_p_1 "Print Receipt Trailer"
/* MaxLen: Comment: */

&SCOPED-DEFINE porvrp_p_2 "Print Bill-To Address"
/* MaxLen: Comment: */

&SCOPED-DEFINE porvrp_p_3 "Print Lot/Serial Numbers Shipped"
/* MaxLen: Comment: */

&SCOPED-DEFINE porvrp_p_4 "Message"
/* MaxLen: Comment: */

&SCOPED-DEFINE porvrp_p_5 "Form Code"
/* MaxLen: Comment: */

&SCOPED-DEFINE porvrp_p_6 "Return Date"
/* MaxLen: Comment: */

&SCOPED-DEFINE porvrp_p_7 "Unprinted RTV's Only"
/* MaxLen: Comment: */

&SCOPED-DEFINE porvrp_p_8 "Update"
/* MaxLen: 9 Comment: FACILITATE SIMULATION MODE PRINTING*/

/* ********** End Translatable Strings Definitions ********* */

define new shared variable nbr         like prh_nbr.
define new shared variable nbr1        like prh_nbr.
define new shared variable vend        like prh_vend.
define new shared variable vend1       like prh_vend.
define new shared variable buyer       like prh_buyer.
define new shared variable buyer1      like prh_buyer.
define new shared variable rcp_date    like prh_rcp_date
   label {&porvrp_p_6}.
define new shared variable rcp_date1   like prh_rcp_date.
define new shared variable new_only    like mfc_logical  initial yes
   label {&porvrp_p_7}.
define new shared variable print_bill  like mfc_logical  initial yes
   label {&porvrp_p_2}.
define new shared variable print_lotserials like mfc_logical initial no
   label  {&porvrp_p_3}.
define            variable form_code   as character
   format "x(2)"  label {&porvrp_p_5}.
define new shared variable msg         as character
   format "x(60)" label {&porvrp_p_4}.
define            variable run_file    as character
   format "x(12)".

define variable update_yn like mfc_logical initial yes
   label {&porvrp_p_8} no-undo.

define new shared variable print_trlr like mfc_logical initial no
   label {&porvrp_p_1}.

/* FACILITATE UPDATE FLAG AS REPORT INPUT CRITERIA, TO */
/* ELIMINATE USER INTERACTION AT THE END OF REPORT     */

form
   nbr              colon 15
   nbr1             colon 49 label {t001.i}
   vend             colon 15
   vend1            colon 49 label {t001.i}
   buyer            colon 15
   buyer1           colon 49 label {t001.i}
   rcp_date         colon 15
   rcp_date1        colon 49 label {t001.i} skip(1)
   new_only         colon 35
   print_bill       colon 35
   print_lotserials colon 35
   print_trlr       colon 35
   form_code        colon 35 deblank
   update_yn        colon 35                skip
   space(1)
   msg
with frame a width 80 attr-space side-labels.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

repeat:

   if nbr1 = hi_char       then nbr1 = "".
   if vend1 = hi_char      then vend1 = "".
   if buyer1 = hi_char     then buyer1 = "".
   if rcp_date = low_date  then rcp_date = ?.
   if rcp_date1 = hi_date  then rcp_date1 = ?.
   if form_code = ""       then form_code = "1".

   update
      nbr         nbr1
      vend        vend1
      buyer       buyer1
      rcp_date    rcp_date1
      new_only
      print_bill
      print_lotserials
      print_trlr
      form_code
      update_yn
      msg
   with frame a.

   if lookup(form_code,"1") = 0 then do:
      {pxmsg.i &MSGNUM=129 &ERRORLEVEL=3}
      next-prompt form_code with frame a.
      undo, retry.
   end.

   bcdparm = "".
   {mfquoter.i nbr             }
   {mfquoter.i nbr1            }
   {mfquoter.i vend            }
   {mfquoter.i vend1           }
   {mfquoter.i buyer           }
   {mfquoter.i buyer1          }
   {mfquoter.i rcp_date        }
   {mfquoter.i rcp_date1       }
   {mfquoter.i new_only        }
   {mfquoter.i print_bill      }
   {mfquoter.i print_lotserials}
   {mfquoter.i print_trlr      }
   {mfquoter.i form_code       }
   {mfquoter.i update_yn       }
   {mfquoter.i msg             }

   if nbr1 = ""      then nbr1 = hi_char.
   if vend1 = ""     then vend1 = hi_char.
   if buyer1 = ""    then buyer1 = hi_char.
   if rcp_date = ?   then rcp_date = low_date.
   if rcp_date1 = ?  then rcp_date1 = hi_date.

   /* SELECT PRINTER */
   {mfselbpr.i "printer" 80}

   mainloop:
   do transaction on error undo, leave on endkey undo, leave:

      /*RUN SELECTED FORMAT */
      {gprfile.i}

      if false then do:
         {gprun.i ""xxporvrp01.p"" "(input update_yn)"}
      end.
      
      {gprun.i """xxporvrp"" + run_file + "".p""" "(input update_yn)"}
          
      {mfreset.i}

      /* OBSOLETED MESSAGE 378 AND MOVED USER INTERACTION */
      /* TO REPORT INPUT CRITERIA.                        */
      if not update_yn then
         undo mainloop, leave mainloop.

   end. /* mainloop */
end.
