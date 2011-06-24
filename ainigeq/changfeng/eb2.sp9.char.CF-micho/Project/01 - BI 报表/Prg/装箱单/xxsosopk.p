/* sosopk.p - PACKING LIST PRINT                                              */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.11.1.7 $                                                      */
/*V8:ConvertMode=Report                                                       */
/* REVISION: 1.0      LAST MODIFIED: 10/02/86   BY: PML *26*                  */
/* REVISION: 6.0      LAST MODIFIED: 03/14/90   BY: FTB *D004*                */
/* REVISION: 6.0      LAST MODIFIED: 04/10/90   BY: ftb *Dftb* added site     */
/* REVISION: 6.0      LAST MODIFIED: 10/22/90   BY: pml *D127*                */
/* REVISION: 6.0      LAST MODIFIED: 11/12/90   BY: MLB *D200*                */
/* REVISION: 6.0      LAST MODIFIED: 01/10/91   BY: WUG *D294*                */
/* REVISION: 6.0      LAST MODIFIED: 01/30/91   BY: afs *D323*(rev only)      */
/* REVISION: 6.0      LAST MODIFIED: 03/12/91   BY: afs *D425*(rev only)      */
/* REVISION: 6.0      LAST MODIFIED: 04/29/91   BY: afs *D597*(rev only)      */
/* REVISION: 6.0      LAST MODIFIED: 07/13/91   BY: afs *D768*(rev only)      */
/* REVISION: 6.0      LAST MODIFIED: 09/19/91   BY: afs *F040*(rev only)      */
/* REVISION: 7.0      LAST MODIFIED: 02/07/92   BY: afs *F180*(rev only)      */
/* REVISION: 7.0      LAST MODIFIED: 03/26/92   BY: dld *F322*(rev only)      */
/* REVISION: 7.0      LAST MODIFIED: 04/28/92   BY: tjs *F444*                */
/* REVISION: 7.0      LAST MODIFIED: 06/05/92   BY: tjs *F504*(rev only)      */
/* REVISION: 7.3      LAST MODIFIED: 09/24/92   BY: tjs *G087*(rev only)      */
/* REVISION: 7.3      LAST MODIFIED: 01/06/92   BY: afs *G511*(rev only)      */
/* REVISION: 7.3      LAST MODIFIED: 09/09/93   BY: afs *GF01*(rev only)      */
/* REVISION: 7.3      LAST MODIFIED: 12/22/93   BY: WUG *GI32*                */
/* REVISION: 8.5      LAST MODIFIED: 12/22/94   BY: mwd *J034*                */
/* REVISION: 7.3      LAST MODIFIED: 03/07/95   by: srk *G0GN*                */
/* REVISION: 7.3      LAST MODIFIED: 06/09/95   by: rxm *G0PS*                */
/* REVISION: 8.5      LAST MODIFIED: 04/26/96   by: JPM *J0KK*                */
/* REVISION: 8.5      LAST MODIFIED: 06/20/96   by: taf *J0VG*                */
/* REVISION: 7.4      LAST MODIFIED: 02/05/98   BY: *H1JC* Jean Miller        */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane          */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan         */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan         */
/* REVISION: 9.1      LAST MODIFIED: 08/23/99   BY: *N01B* Poonam Bahl        */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *M0QW* Falguni Dalal      */
/* REVISION: 9.1      LAST MODIFIED: 08/12/00   BY: *N0KN* Mark Brown         */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.11.1.6       BY: Kirti Desai       DATE: 05/22/01  ECO: *N0Y4* */
/* $Revision: 1.11.1.7 $    BY: Jean Miller       DATE: 05/14/02  ECO: *P05V* */
/* $Revision: 1.11.1.7 $    BY: Micho Yang        DATE: 03/20/06  ECO: *SS - Micho 20060320* */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* DISPLAY TITLE */
{mfdtitle.i "2+ "}

define new shared variable due_date like sod_due_date.
define new shared variable due_date1 like sod_due_date.
define new shared variable nbr      like so_nbr.
define new shared variable nbr1     like so_nbr.
define new shared variable site     like sod_site.
define new shared variable site1    like sod_site.
define new shared variable all_only like mfc_logical initial yes
   label "Print Only Lines to Pick".

define new shared variable print_options like mfc_logical initial no
   label "Print Features and Options".
define new shared variable addr as character format "x(38)" extent 6.
define new shared variable include_partial like mfc_logical
   label "Override Partial OK Flag".
define new shared variable company as character format "x(38)" extent 6.
define new shared variable lang like so_lang.
define new shared variable lang1 like lang.
define new shared variable print_neg like mfc_logical
   label "Print Negative Quantities".

/* MADE AS NO-UNDO, SO THAT WHEN THE REPORT IS RUN IN SIMULATION   */
/* MODE AND THE PACKLIST IS ALREADY PRINTED, THEN THE ERROR        */
/* MESSAGE SHOULD BE CORRECTLY ISSUED. THIS SHOULD BE NO-UNDO      */
/* BECAUSE IN SIMULATION MODE, THE TRANSACTION WILL BE UNDONE, BUT */
/* THE VALUE OF PACK_LIST_EXISTS HAS TO BE RETAINED                */
define new shared variable pack_list_exists as logical no-undo.
define new shared variable picked_site like sod_site.
define new shared variable ship like so_ship.
define new shared variable ship1 like so_ship.

define variable l_disp_ch1 as character format "x(70)" no-undo.
define variable l_msg      like msg_mstr.msg_desc      no-undo.
define variable update_yn  like mfc_logical initial yes label "Update" no-undo.
define variable comp_addr  like ad_addr label "Company Address" no-undo.
define variable form_code  as character format "x(2)" label "Form Code" no-undo.
define variable run_file   as character format "x(12)" no-undo.

{sotmpdef.i new}

/* FACILITATE UPDATE FLAG AS REPORT INPUT CRITERIA, TO      */
/* ELIMINATE USER INTERACTION AT THE END OF THE REPORT      */
form
   due_date         colon 15
   due_date1        colon 49 label "To" skip
   nbr              colon 15
   nbr1             colon 49 label "To" skip
   ship             colon 15
   ship1            colon 49 label "To" skip
   lang             colon 15
   lang1            colon 49 label "To"
   site             colon 15
   site1            colon 49 label "To" skip(1)
   comp_addr        colon 35
   all_only         colon 35
   include_partial  colon 35
   print_options    colon 35 skip
   print_neg        colon 35 skip
   form_code        colon 35 deblank
   update_yn        colon 35 skip(1)
   l_disp_ch1 no-label at 5
   skip (1)
with frame a side-labels width 80.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

/* Only orders with an action status of blank will print */
{pxmsg.i &MSGNUM=4648 &ERRORLEVEL=1 &MSGBUFFER=l_msg}

l_disp_ch1:screen-value = getTermLabel("NOTE",8) + ":" + l_msg.

/****************************** SS - Micho 20060320 B *************************/
for each t_all_data exclusive-lock:
   delete t_all_data.
end. /* FOR EACH t_all_data */
/****************************** SS - Micho 20060320 E *************************/

find first soc_ctrl no-lock no-error.
if available soc_ctrl then
   all_only = soc_pick.
include_partial = no.

if comp_addr = "" then do:
   if available soc_ctrl then comp_addr = soc_comp.
end.

if form_code = "" then form_code = "1".

display
   due_date due_date1
   nbr nbr1
   ship ship1
   lang lang1
   site site1
   comp_addr
   all_only
   include_partial
   print_options
   print_neg
   form_code
   update_yn
with frame a.

mainloop:
repeat:

   do transaction:

      if comp_addr = "" then do:
         if available soc_ctrl then comp_addr = soc_comp.
      end.

      if nbr1 = hi_char then nbr1 = "".
      if form_code = "" then form_code = "1".
      if site1 = hi_char then site1 = "".
      if due_date = low_date then due_date = ?.
      if due_date1 = hi_date then due_date1 = ?.
      if ship1 = hi_char then ship1 = "".
      if lang1 = hi_char then lang1 = "".

      set
         due_date due_date1
         nbr nbr1
         ship ship1
         lang lang1
         site site1
         comp_addr
         all_only
         include_partial
         print_options
         print_neg
         form_code
         update_yn
      with frame a.

      bcdparm = "".
      {mfquoter.i due_date}
      {mfquoter.i due_date1}
      {mfquoter.i nbr    }
      {mfquoter.i nbr1   }
      {mfquoter.i ship }
      {mfquoter.i ship1}
      {mfquoter.i lang}
      {mfquoter.i lang1}
      {mfquoter.i site}
      {mfquoter.i site1}
      {mfquoter.i comp_addr}
      {mfquoter.i all_only}
      {mfquoter.i include_partial}
      {mfquoter.i print_options}
      {mfquoter.i print_neg}
      {mfquoter.i form_code}
      {mfquoter.i update_yn}

      if nbr1 = "" then nbr1 = hi_char.
      if ship1 = "" then ship1 = hi_char.
      if site1 = "" then site1 = hi_char.
      if due_date = ? then due_date = low_date.
      if due_date1 = ? then due_date1 = hi_date.
      if lang1 = "" then lang1 = hi_char.

      company = "".

      if lookup(form_code,"1") = 0 then do:
         /* Form code not installed */
         {pxmsg.i &MSGNUM=129 &ERRORLEVEL=3}
         next-prompt form_code with frame a.
         undo, retry.
      end.

      if not batchrun then do:
         {gprun.i ""gpsirvr.p""
            "(input site, input site1, output return_int)"}
         if return_int = 0 then do:
            next-prompt site with frame a.
            undo mainloop, retry mainloop.
         end.
      end.

      find ad_mstr where ad_addr = comp_addr no-lock no-error.
      if available ad_mstr then do:

         find ls_mstr where ls_addr = ad_addr and ls_type = "company"
         no-lock no-error.

         if not available ls_mstr and comp_addr <> "" then do:
            {pxmsg.i &MSGNUM=28 &ERRORLEVEL=3}
            /* NOT A VALID COMPANY */
            next-prompt comp_addr with frame a.
            undo , retry.
         end.

/****************************** SS - Micho 20060320 B *************************/
/*          if available ls_mstr then do:                 */
/*             assign                                     */
/*                addr[1] = ad_name                       */
/*                addr[2] = ad_line1                      */
/*                addr[3] = ad_line2                      */
/*                addr[4] = ad_line3                      */
/*                addr[6] = ad_country.                   */
/*             {mfcsz.i addr[5] ad_city ad_state ad_zip}. */
/*             {gprun.i ""gpaddr.p"" }                    */
/*             assign                                     */
/*                company[1] = addr[1]                    */
/*                company[2] = addr[2]                    */
/*                company[3] = addr[3]                    */
/*                company[4] = addr[4]                    */
/*                company[5] = addr[5]                    */
/*                company[6] = addr[6].                   */
/*          end.                                          */
         if available ls_mstr then do:
            assign
               addr[1] = ad_name
               addr[2] = ad_line1 + " " + ad_Line2 + " " + ad_line3 
               addr[3] = ad_state
               addr[4] = ad_city
               addr[6] = ad_country.
            assign
               company[1] = addr[1]
               company[2] = addr[2]
               company[3] = addr[3]
               company[4] = addr[4]
               company[5] = addr[5]
               company[6] = addr[6].
         end.
/****************************** SS - Micho 20060320 E *************************/

      end. /* if available ad_mstr */

   end. /* DO TRANSACTION */

   /* OUTPUT DESTINATION SELECTION */
   {gpselout.i &printType = "printer"
               &printWidth = 80
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

   if not update_yn then do:
      /* FACILITATING ROLLING BACK OF TRANSACTIONS BEFORE EXECUTING */
      /* THE REPORT AND LOCKING ANY RECORDS                         */
      mainprt:
      do transaction on error undo , leave on endkey undo , leave:

         run p_packlist.

         /* UNDOING CHANGES TO THE DATABASE IN SIMULATION MODE */
         undo mainprt, leave mainprt.

      end. /* DO TRANSACTION */
   end. /* IF NOT UPDATE_YN */

   else do:
      /* DISALLOWING ROLLBACK OF RECORDS MODIFIED DURING THE REPORT */
      /* WHEN UPDATE INPUT CRITERIA IS YES                          */
      run p_packlist.
   end. /* UPDATE_YN = YES */

   {mfreset.i}

   if not batchrun then do:
      if pack_list_exists then do:
         /* PACKLIST LIST ALREADY PRINTED AT SITE */
         {pxmsg.i &MSGNUM=659 &ERRORLEVEL=3 &MSGARG1=picked_site}
      end.
   end. /* IF NOT BATCHRUN */

end. /* repeat */

PROCEDURE p_packlist:
   /*RUN SELECTED FORMAT */
   {gprfile.i}

   if false then do:
      {gprun.i ""sopk01.p""}
   end.
   
   /* SS - Micho 20060320 B */
   /*
   {gprun.i """sopk"" + run_file + "".p""" "(input update_yn)"}
    */
   {gprun.i """xxsopk"" + run_file + "".p""" "(input update_yn)"}
   /* SS - Micho 20060320 E */

END PROCEDURE.
