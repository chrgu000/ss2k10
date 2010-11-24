/* mrwoap.p - COMPUTER PLANNED WORK ORDER APPROVAL                      */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/* $Revision: 1.18 $                                                         */
/*V8:ConvertMode=Maintenance                                            */
/* REVISION: 1.0      LAST MODIFIED: 06/26/86   BY: EMB                 */
/* REVISION: 1.0      LAST MODIFIED: 12/23/87   BY: EMB                 */
/* REVISION: 4.0      LAST MODIFIED: 05/30/89   BY: EMB *A740*          */
/* REVISION: 6.0      LAST MODIFIED: 09/12/90   BY: emb *D040*          */
/* REVISION: 6.0      LAST MODIFIED: 12/17/91   BY: emb *D966*          */
/* REVISION: 7.3      LAST MODIFIED: 01/06/93   BY: emb *G508*          */
/* REVISION: 7.3      LAST MODIFIED: 11/17/94   BY: aed *GO05*          */
/* REVISION: 7.5      LAST MODIFIED: 01/05/95   BY: mwd *J034*          */
/* REVISION: 7.5      LAST EDIT: 09/28/94   MODIFIED BY: tjs *J027**/
/* REVISION: 8.5      LAST MODIFIED: 10/13/97  BY: *G2PT*  Felcy D'Souza   */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane       */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan      */
/* REVISION: 8.6E     LAST MODIFIED: 07/10/98   BY: *J2QS* Samir Bavkar    */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan      */
/* REVISION: 9.0      LAST MODIFIED: 01/26/99   BY: *M066* Patti Gaultney  */
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan      */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00 BY: *N08T* Annasaheb Rahane */
/* REVISION: 9.1      LAST MODIFIED: 08/13/00 BY: *N0KR* myb               */
/* Revision: 1.16  BY: Paul Donnelly (SB) DATE: 06/28/03 ECO: *Q00J* */
/* Old ECO marker removed, but no ECO header exists *D040*               */
/* Old ECO marker removed, but no ECO header exists *F0PN*               */
/* $Revision: 1.18 $    BY: Subramanian Iyer   DATE: 11/24/03 ECO: *P13Q* */
/*By: Neil Gao 08/09/17 ECO: *SS 20080917* */

/*-Revision end---------------------------------------------------------------*/
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

{mfdtitle.i "N+ "}

define new shared variable release_all like mfc_logical
   label "Default Approve".
define new shared variable numlines    as integer initial 10.
define variable show_phantom like mfc_logical
   label "Include Phantoms" initial no.
define variable show_purchased like mfc_logical initial no
   label "Include Purchased Items".
define variable show_line_mfg like mfc_logical initial no
   label "Include Line Manufactured Items".
define variable buyer like pt_buyer.
define variable nbr like wo_nbr.
define variable part like mrp_part.
define variable part2 like mrp_part.
define variable bom         like wo_bom_code.
define variable bom2        like wo_bom_code.
define variable rel_date like mrp_rel_date.
define variable rel_date2 like mrp_rel_date.
define variable dwn as integer.
define new shared variable mindwn as integer.
define new shared variable maxdwn as integer.
define new shared variable worecno as recid extent 10 no-undo.
define variable yn like mfc_logical.

define new shared variable site like si_site.
define new shared variable site2 like si_site.

/* INPUT OPTION FORM */
form
   part                     colon 15
   /*V8! View-as fill-in size 18 by 1 */
   part2 label {t001.i}     colon 45
   /*V8! View-as fill-in size 18 by 1 */
   bom                      colon 15
   bom2  label {t001.i}     colon 45
   site                     colon 15
   site2 label {t001.i}     colon 45
   rel_date                 colon 15
   rel_date2 label {t001.i} colon 45 skip(1)
   release_all              colon 36
   buyer                    colon 36
   show_phantom             colon 36
   show_line_mfg            colon 36
   show_purchased           colon 36
with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

assign release_all = yes
   site = global_site
   site2 = global_site.

main-loop:
repeat:

   assign worecno = ?
          dwn     = 0
          mindwn  = 1
          maxdwn  = 0.

   ststatus = stline[1].
   status input ststatus.

   if part2 = hi_char
   then
      part2 = "".
   if bom2 = hi_char
   then
      bom2 = "".
   if site2 = hi_char
   then
      site2 = "".
   if  rel_date = low_date
   then
      rel_date = ?.
   if rel_date2 = hi_date
   then
      rel_date2 = ?.

   update part part2
      bom bom2
      site site2
      rel_date rel_date2
      release_all
      buyer show_phantom show_line_mfg show_purchased
      with frame a
   editing:

      if frame-field = "part"
      then do:

         /* FIND NEXT/PREVIOUS RECORD */
         {mfnp.i wo_mstr part  " wo_mstr.wo_domain = global_domain and
                  wo_part "  part wo_part wo_part}

         if recno <> ?
         then do:
            part = wo_part.
            display part with frame a.
            recno = ?.
         end. /* IF recno <> ? */
      end. /* IF FRAME-FIELD = "part" */
      else if frame-field = "part2"
      then do:

         /* FIND NEXT/PREVIOUS RECORD */
         {mfnp.i wo_mstr part2  " wo_mstr.wo_domain = global_domain
                  and wo_part "  part2 wo_part wo_part}

         if recno <> ?
         then do:
            part2 = wo_part.
            display part2 with frame a.
            recno = ?.
         end. /* IF recno <> ? */
      end. /* IF FRAME-FIELD = "part2" */
      else if frame-field = "site"
      then do:

         /* FIND NEXT/PREVIOUS RECORD */
         {mfnp.i si_mstr site  " si_mstr.si_domain = global_domain and
                  si_site "  site si_site si_site}

         if recno <> ?
         then
            display si_site @ site with frame a.
      end. /* IF FRAME-FIELD = "site" */
      else if frame-field = "site2"
      then do:

         /* FIND NEXT/PREVIOUS RECORD */
         {mfnp.i si_mstr site2  " si_mstr.si_domain = global_domain
                  and si_site "  site2 si_site si_site}

         if recno <> ?
         then
            display si_site @ site2 with frame a.
      end. /* IF FRAME-FIELD = "site2" */
      else do:
         ststatus = stline[3].
         status input ststatus.
         readkey.
         apply lastkey.
      end. /* ELSE */
   end. /* EDITING */

   status input "".

   if part2 = ""
   then
      part2 = hi_char.
   if site2 = ""
   then
      site2 = hi_char.
   if  rel_date = ?
   then
      rel_date = low_date.
   if rel_date2 = ?
   then
      rel_date2 = hi_date.
   if bom2 = ""
   then
      bom2 = hi_char.

   {gprun.i ""gpsirvr.p""
      "(input site, input site2, output return_int)"}
   if return_int = 0
   then do:
      next-prompt site with frame a.
      undo main-loop, retry main-loop.
   end. /* IF return_int = 0 */

   /* FOLLOWING CODE IS COMMENTED AND RESTRUCTURED BELOW SINCE THIS LOGIC */
   /* SEARCHES THROUGH THE WORK ORDER TABLE FOR ORDERS WITH PLANNED       */
   /* STATUS AND THEN VALIDATES THE BUYER/PLANNER FOR THAT ITEM TO CHECK  */
   /* WHETHER IT MATCHES WITH THAT OF SELECTION CRITERIA. THIS RESULTS IN */
   /* A LONG PROCESS OF READING AND DISPLAY OF THE APPROPRIATE RECORDS.   */

   /* BELOW CODE STARTS WITH THE PT_MSTR AND IN_MSTR TABLES,         */
   /* SELECTING THE RECORDS WITHIN THE SELECTION CRITERIA OF ITEM    */
   /* AND SITE FOR WHICH WO EXISTS. THEN A CHECK IS MADE FOR PURCHASE*/
   /* MANUFACTURE, PHANTOM, BUYER/PLANNER VALUES BEFORE SEARCHING FOR*/
   /* WORK ORDERS WITH A PLANNED STATUS CODE. THIS IS SIGNIFICANTLY  */
   /* FASTER WHEN THERE ARE LARGE NUMBER OF WORK ORDERS AND WHEN     */
   /* BUYER/PLANNER FIELD IS ENTERED IN THE SELECTION CRITERIA.      */

   for each pt_mstr
      fields (pt_buyer pt_domain pt_part pt_phantom pt_pm_code pt_part_type) no-lock
      where pt_mstr.pt_domain = global_domain
        and (pt_part         >= part
        and  pt_part         <= part2),
      each in_mstr
         fields (in_domain in_part in_site) no-lock
         where in_mstr.in_domain = global_domain
           and in_part           = pt_part
           and (in_site         >= site
           and  in_site         <= site2)
           and can-find (first wo_mstr
                            where wo_mstr.wo_domain = global_domain
                              and wo_part           = in_part
                              and wo_site           = in_site):

      find ptp_det no-lock
         where ptp_det.ptp_domain = global_domain
           and ptp_part           = in_part
           and ptp_site           = in_site
      no-error.

      if (available ptp_det
         and (ptp_phantom = no    or show_phantom   = yes)
         and (ptp_buyer   = buyer or buyer          = "" )
         and (ptp_pm_code <> "L"  or show_line_mfg  = yes)
/*SS 20080917 - B*/
					and (ptp_pm_code = "M" and pt_part_type = "W")
/*SS 20080917 - E*/
         and (ptp_pm_code <> "P"  or show_purchased = yes))

         or
         (not available ptp_det
         and (pt_phantom  = no    or show_phantom   = yes)
         and (pt_buyer    = buyer or buyer          = "" )
         and (pt_pm_code <> "L"   or show_line_mfg  = yes)
/*SS 20080917 - B*/
					and (pt_pm_code = "M" and pt_part_type = "W")
/*SS 20080917 - E*/
         and (pt_pm_code <> "P"   or show_purchased = yes))
      then do:

         for each wo_mstr
            fields (wo_bom_code wo_domain wo_part wo_rel_date wo_site
                    wo_status) no-lock
            where wo_mstr.wo_domain = global_domain
              and wo_part           = in_part
              and wo_site           = in_site
              and (wo_bom_code     >= bom
              and wo_bom_code      <= bom2)
              and wo_rel_date      >= rel_date
              and wo_rel_date      <= rel_date2
              and wo_status         = "P"
            use-index wo_part_rel:

            dwn = dwn + 1.
            maxdwn = maxdwn + 1.
            worecno[dwn] = recid(wo_mstr).

            /* RESTRICTING maxdwn TO 999 AND REASSIGNING dwn TO 0 */
            /* SO THAT DETAIL LINES TO APPROVE WOULD START FROM   */

            if dwn    = numlines
            or maxdwn = 999
            then do:

               hide frame a.
/*SS 20080917 - B*/
/*
               {gprun.i ""mrwoapa.p""}
*/
               {gprun.i ""xxmrwoapa.p""}
/*SS 20080917 - E*/
               if maxdwn = 999
               then do:
                  assign
                     mindwn = 1
                     maxdwn = 0.
               end. /* IF maxdwn = 999 */

               if worecno[1] = ?
               then do:
                  worecno = ?.
                  dwn = 0.
                  undo main-loop, next main-loop.
               end. /* IF worecno[1] = ? */

               worecno = ?.
               dwn = 0.
               mindwn = maxdwn + 1.
            end. /* IF dwn = numlines */

         end. /* FOR EACH wo_mstr */
      end. /* IF AVAILABLE ptp_det */
   end. /* FOR EACH pt_mstr */

   if dwn <> 0
   then do:
      hide frame a.
/*SS 20080917 - B*/
/*
      {gprun.i ""mrwoapa.p""}
*/
      {gprun.i ""xxmrwoapa.p""}
/*SS 20080917 - E*/
      if worecno[1] = ? then undo main-loop, next main-loop.
   end. /* IF dwn <> 0 */
   else do:
      {pxmsg.i &MSGNUM=501 &ERRORLEVEL=1}
      /* NO MORE PLANNED WORK ORDERS SATISFY CRITERIA".*/
   end. /* ELSE */
end. /* REPEAT */
