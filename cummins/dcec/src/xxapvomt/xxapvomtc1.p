/* apvomtc1.p  - AP VOUCHER MAINTENANCE - PO List Frame                       */
/* Copyright 1986-2006 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* REVISION: 7.4      LAST MODIFIED: 10/09/93            BY: pcd *H199*       */
/*                                   04/01/94            BY: pcd *H312*       */
/*                                   04/04/94            BY: pcd *H314*       */
/*                                   05/13/94            by: pmf *FO17*       */
/*                                   01/28/95            by: ljm *H09Z*       */
/*                                   04/18/95            by: jzw *H0CR*       */
/*                                   04/28/95            by: jzw *H0DJ*       */
/*                                   11/16/95            by: mys *H0GP*       */
/*                                   01/02/96            by: jzs *H0J0*       */
/* REVISION: 8.6E     LAST MODIFIED: 04/10/98            by: rvsl *L00K       */
/* REVISION: 8.6E     LAST MODIFIED: 05/09/98   BY: *L00Y* Jeff Wootton       */
/* Pre-86E commented code removed, view in archive revision 1.11              */
/* REVISION: 8.6E     LAST MODIFIED: 07/23/98   BY: *L03K* Jeff Wootton       */
/* REVISION: 9.0      LAST MODIFIED: 03/10/99   BY: *M0B3* Michael Amaladhas  */
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan         */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1      LAST MODIFIED: 06/12/00   BY: *L0YW* Mark Christian     */
/* REVISION: 9.1      LAST MODIFIED: 07/04/00   BY: *L10Z* Veena Lad          */
/* REVISION: 9.1      LAST MODIFIED: 08/11/00   BY: *N0KK* jyn                */
/* REVISION: 9.1      LAST MODIFIED: 09/18/00 BY: *N0W0* Mudit Mehta          */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Old ECO marker removed, but no ECO header exists *L00K*                    */
/* Revision: 1.13.1.8      BY: Mamata Samant      DATE: 03/02/02  ECO: *P04F* */
/* Revision: 1.13.1.9      BY: Gnanasekar         DATE: 09/11/02  ECO: *N1PG* */
/* Revision: 1.13.1.11     BY: Paul Donnelly (SB) DATE: 06/26/03  ECO: *Q00B* */
/* Revision: 1.13.1.12     BY: Jean Miller        DATE: 11/10/04  ECO: *Q0F9* */
/* $Revision: 1.13.1.12.1.1 $            BY: Tejasvi Kulkarni   DATE: 08/09/06  ECO: *P4ZD* */
/*-Revision end---------------------------------------------------------------*/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/
/*****************************************************************************/

/*V8:ConvertMode=Maintenance                                                  */
{mfdeclre.i}
{cxcustom.i "APVOMTC1.P"}
/* EXTERNAL LABEL INCLUDE */
{gplabel.i}

define input  parameter ap_recid      as   recid.
define input  parameter vo_recid      as   recid.
define output parameter poattached    like mfc_logical.
define output parameter povendor      like po_vend.

define shared variable new_vchr         like mfc_logical.
define        variable po-attached      like mfc_logical             no-undo.
define        variable last_ln          like vod_ln      initial 1   no-undo.
define        variable del-yn           like mfc_logical initial yes no-undo.
define        variable del_flg          like mfc_logical initial no  no-undo.
define        variable current-vend     like po_vend                 no-undo.
define        variable current-curr     like po_curr                 no-undo.
define        variable current-cr-terms like po_cr_terms             no-undo.
define        variable batch            like ap_batch                no-undo.
define shared variable l_flag           like mfc_logical             no-undo.

define shared frame order.

{apvofmo.i}

/* COMMON EURO VARIABLES */
{etvar.i}

/*V8:HiddenDownFrame=order */

/* FIND AP MASTER RECORDS */
find ap_mstr
   where recid (ap_mstr) = ap_recid
exclusive-lock no-error.
find vo_mstr
   where recid (vo_mstr) = vo_recid
exclusive-lock no-error.

clear frame order all.

/* SEE IF ANY DETAIL RECORDS EXIST                         */
/* DISPLAY THE FIRST RECORD, FIND THE SECOND RECORD,       */
/* MAINLOOP WILL DISPLAY THE SECOND RECORD AND LEAVE THIRD */
/* LINE BLANK FOR ENTRY OF A PO NUMBER                     */
po-attached = false.
{&APVOMTC1-P-TAG1}

for each vpo_det
   fields( vpo_domain vpo_po vpo_ref)
    where vpo_det.vpo_domain = global_domain and  vpo_ref = vo_ref
no-lock
with frame order:
   for first po_mstr
      fields( po_domain po_cr_terms po_curr po_nbr po_site po_vend)
       where po_mstr.po_domain = global_domain and  po_nbr = vpo_po
   no-lock :
   end. /* FOR FIRST po_mstr */

   if available po_mstr
   then do:
      assign
         po-attached      = true
         current-vend     = po_vend
         current-curr     = po_curr
         current-cr-terms = po_cr_terms.
      {&APVOMTC1-P-TAG2}
   end. /* IF AVAILABLE po_mstr */
   if last_ln > 1
   then
      leave.

   if available po_mstr
   then do:
      display vpo_po.
      last_ln = last_ln + 1.
      down 1.
   end. /* IF AVAIL po_mstr */
end. /* FOR EACH VPO_DET */

ststatus = stline[12].
status input ststatus.

mainloop:
repeat with frame order:

   /* IF l_flag IS true RETURN TO THE CALLING */
   /* PROGRAM WITHOUT PROCEEDING FURTHER      */
   if l_flag = true
   then
      return.

   del_flg = no.
   if  available vpo_det
   and not retry
   then do:
      /* DISPLAY EXISTING DETAIL RECORDS, SINCE ONLY 3 LINES CAN */
      /* BE DISPLAYED, CLEAR FRAME AFTER WHEN LINE COUNT > 2 SO  */
      /* THE LAST PO'S WILL BE DISPLAYED ALONG WITH 1 BLANK LINE */
      /* FOR DATA ENTRY.                                         */
      if last_ln > 2
      then do:
         pause 1 no-message.
         clear frame order all.
         last_ln = 1.
      end. /*  IF last_ln > 2 */
      display vpo_po.
      last_ln = last_ln + 1.
      down 1.
   end. /* IF AVAILABLE vpo_det AND NOT retry */

   set-po:
   do on error undo, retry:

      prompt-for vpo_po go-on(F5 CTRL-D) with frame order
         editing:

         /*NEXT/PREVIOUS*/
         {mfnp09.i vpo_det vpo_po vpo_po vo_ref  " vpo_det.vpo_domain =
         global_domain and vpo_ref "  vpo_ref}
         if recno <> ?
         then
            display vpo_po with frame order.
         if lastkey = keycode ("F5")
         or lastkey = keycode("CTRL-D")
         then
            del_flg = yes.

      end. /* editing CLAUSE */

      if input vpo_po = ""
      then do:
         /* BLANK NOT ALLOWED */
         {pxmsg.i &MSGNUM=40 &ERRORLEVEL=3}

         /* IF AN ERROR IS ENCOUNTERED IN BATCH MODE l_flag IS SET TO true */
         /* AND RETURNED TO THE CALLING PROGRAM WITHOUT PROCEEDING FURTHER */
         if batchrun
         then do:
            l_flag = true.
            return.
         end. /* IF batchrun */

         undo, retry.
      end. /* IF INPUT vpo_po = "" */

   end. /*SET-PO*/

   ststatus = stline[12].
   status input ststatus.
   apply lastkey.

   /*READ TO OBTAIN VPO_DET RECORD.  IF NOT FOUND, CREATE IT.*/
   find vpo_det
       where vpo_det.vpo_domain = global_domain and  vpo_ref = vo_ref
        and vpo_po  = input vpo_po
   exclusive-lock no-error.
   if not available vpo_det
   then do:

      /* ADDING NEW RECORD              */
      /* ENSURE THAT PO NUMBER IS VALID */
      for first po_mstr
         fields( po_domain po_cr_terms po_curr po_nbr po_site po_vend)
          where po_mstr.po_domain = global_domain and  po_nbr = input vpo_po
      no-lock:
      end. /* FOR FIRST po_mstr */
      if not available po_mstr
      then do:
         /* PO DOES NOT EXIST */
         {pxmsg.i &MSGNUM=343 &ERRORLEVEL=3}

         if batchrun
         then
            l_flag = true.

         undo, retry.
      end. /* IF NOT AVAILABLE po_mstr */

      /* ENSURE THAT NEW PO IS COMPATIBLE WITH EXISTING ONES */

      {&APVOMTC1-P-TAG3}
      if po-attached
      then do:

         /* CHECK SUPPLIER AGAINST PREVIOUS PO */
         if po_vend <> current-vend
         then do:
            /* EARLIER POs WERE PLACED WITH DIFFERENT SUPPLIER */
            /* PO PLACED WITH SUUPLIER: */
            {pxmsg.i  &MSGNUM=344 &ERRORLEVEL=3 &MSGARG1=current-vend}

            if batchrun
            then
               l_flag = true.

            undo, retry.
         end. /* IF po_vend <> current-vend */

         /* CHECK PO CURRENCY AGAINST PREVIOUS PO,   */
         /* WITH UNION TRANSPARENCY ALLOWED          */
         /* CHANGED THIRD INPUT PARAMETER FROM today */
         /* TO ap_effdate                            */
         {gprunp.i "mcpl" "p" "mc-chk-transaction-curr"
            "(input po_curr,
              input current-curr,
              input ap_effdate,
              input true,
              output mc-error-number)"}
         if mc-error-number <> 0
         then do:
            /* CURRENCY MUST BE THE SAME FOR EACH PO */
            {pxmsg.i &MSGNUM=2219 &ERRORLEVEL=3}

            if batchrun
            then
               l_flag = true.

            undo, retry.
         end. /* IF mc-error-number <> 0 */

         /* WARN IF DIFFERENT CREDIT TERMS */
         if po_cr_terms <> current-cr-terms
         then do:
            /* PURCHASE ORDERS HAVE DIFFERENT CREDIT TERMS */
            {pxmsg.i &MSGNUM=2221 &ERRORLEVEL=2}
         end. /* IF po_cr_terms <> current-cr-terms */
      end. /* IF po-attached */

      create vpo_det. vpo_det.vpo_domain = global_domain.
      assign
         vpo_po  = input vpo_po
         vpo_ref = vo_ref.

      if not po-attached
      then do:
         assign
            po-attached      = true
            current-vend     = po_vend
            current-curr     = po_curr
            current-cr-terms = po_cr_terms
            vo_cr_terms      = po_cr_terms.

         if new_vchr
         then
            vo_curr       = po_curr.
         {&APVOMTC1-P-TAG4}

         /* SET VOUCHER ENTITY TO SITE ENTITY OF PO */
         if po_site <> ""
         then do:
            for first si_mstr
               fields( si_domain si_entity si_site)
                where si_mstr.si_domain = global_domain and  si_site = po_site
            no-lock :
            end. /* FOR FIRST si_mstr */
            if available si_mstr
            then
               ap_entity  = si_entity.
         end. /* IF po_site <> "" */
      end. /* IF NOT po-attached */
   end. /* IF NOT AVAILABLE vpo_det */
   else do:
      /*CHECK TO SEE IF "Delete" WAS PRESSED*/
      if del_flg
      then do:
         if can-find (first vph_hist
                          where vph_hist.vph_domain = global_domain and
                          vph_ref = vo_ref
                           and vph_nbr = vpo_po)
         then do:
            /* CANNOT DELETE. VOUCHERED RECEIVERS ATTACHED */
            {pxmsg.i &MSGNUM=2217 &ERRORLEVEL=3}
            undo, retry.
         end. /*  IF CAN-FIND (FIRST vph_hist... */

         del-yn = yes.
         /*CONFIRM DELETE*/
         {pxmsg.i &MSGNUM=11 &ERRORLEVEL=1 &CONFIRM=del-yn}
         if del-yn
     then do:
            delete vpo_det.
            clear frame order.
            del-yn = no.
            if not can-find (first vpo_det
                                 where vpo_det.vpo_domain = global_domain and
                                 vpo_ref = vo_ref)
            then do:
               assign
                  current-vend = ?
                  {&APVOMTC1-P-TAG5}
                  current-curr = ?
                  po-attached = false.
            end. /* IF NOT CAN-FIND (first vpo_det.. */
         end. /* IF del-yn */
      end. /* IF del_flg */
   end. /* IF NOT AVAILABLE vpo_det ELSE DO */
   next mainloop.
end. /* MAINLOOP */

if keyfunction(lastkey) = "end-error"
then
   clear frame order.

assign
   poattached = po-attached
   povendor   = if current-vend <> ?
                then
                   current-vend else "".

/* EOF */
