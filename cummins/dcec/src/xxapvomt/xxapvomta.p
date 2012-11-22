/* apvomta.p - qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK.     */
/* Copyright 1986-2006 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/*                                                                            */
/* REVISION: 4.0      LAST MODIFIED: 03/10/88   BY: FLM *A108*                */
/* REVISION: 6.0      LAST MODIFIED: 02/27/91   BY: WUG *D384*                */
/*                                   03/12/91   BY: MLB *D360*                */
/*                                   08/28/91   BY: MLV *D796*                */
/* REVISION: 7.0      LAST MODIFIED: 07/26/91   BY: mlv *F001*                */
/*                                   08/12/91   BY: mlv *F002*                */
/*                                   12/03/91   BY: pma *F003*                */
/*                                   01/24/92   BY: MLV *F094*                */
/*                                   01/27/92   BY: MLV *F096*                */
/*                                   02/05/92   BY: MLV *F164*                */
/*                                   03/03/92   BY: pma *F085*                */
/*                                   04/10/92   BY: MLV *F380*                */
/*                                   04/14/92   BY: MLV *f387*                */
/*                                   06/18/92   BY: JJS *F672*   (rev only)   */
/*                                   06/24/92   BY: jjs *F681*   (rev only)   */
/*                                   07/02/92   BY: MLV *F725*                */
/* Revision: 7.3      Last Modified: 07/24/92   By: mpp *G004*                */
/*                                   08/17/92   BY: MLV *G031*                */
/*                                   10/14/92   BY: MPP *G186*                */
/*                                   12/02/92   BY: bcm *G381*                */
/*                                   12/11/92   BY: bcm *G418*                */
/*                                   02/24/93   by: jms *G742*                */
/*                                   04/07/93   by: jms *G860*                */
/*                                   04/19/93   by: jms *G965*                */
/*                                   06/29/93   by: jms *GD32*                */
/* REVISION: 7.4      LAST MODIFIED: 07/13/93   by: wep *H037*                */
/*                                   08/08/93   by: bcm *H060*                */
/*                                   09/23/93   by: jjs *H149*                */
/*                                   09/24/93   by: bcm *H161*                */
/*                    MAJOR REWRITE: 02/25/94   by: pcd *H199*                */
/*                    LAST MODIFIED: 05/09/94   by: pmf *FO06*                */
/*                                   02/22/95   by: str *F0JB*                */
/*                                   03/25/95   by: dzn *F0PN*                */
/* REVISION: 8.5      LAST MODIFIED: 09/29/95   BY: mwd *J053*                */
/*                                   01/09/96   by: mys *G1JH*                */
/* REVISION: 8.5      LAST MODIFIED: 10/03/97   BY: *J22C* Irine D'mello      */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* Annasaheb Rahane   */
/* REVISION: 8.6E     LAST MODIFIED: 04/10/98   BY: *L00K* RVSL               */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan         */
/* REVISION: 8.6E     LAST MODIFIED: 07/23/98   BY: *L03K* Jeff Wootton       */
/* REVISION: 9.0      LAST MODIFIED: 03/10/99   BY: *M0B3* Michael Amaladhas  */
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan         */
/* Pre-86E commented code removed, view in archive revision 1.13              */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1      LAST MODIFIED: 08/11/00   BY: *N0KK* Jacolyn Needer     */
/* REVISION: 9.1      LAST MODIFIED: 11/22/00   BY: *L15T* Veena Lad          */
/* REVISION: 9.1      LAST MODIFIED: 08/02/00   BY: *N0W0* Mudit Mehta        */
/* Revision: 1.14.2.7     BY: Jean Miller         DATE: 12/07/01  ECO: *P03F* */
/* Revision: 1.14.2.8     BY: Dan Herman          DATE: 03/11/02  ECO: *P043* */
/* Revision: 1.14.2.9     BY: Samir Bavkar        DATE: 03/16/02  ECO: *P04G* */
/* Revision: 1.14.2.10    BY: Luke Pokic          DATE: 07/01/02  ECO: *P09Z* */
/* Revision: 1.14.2.11    BY: Patrick Rowan       DATE: 11/05/02  ECO: *P0K4* */
/* Revision: 1.14.2.12    BY: Jyoti Thatte        DATE: 02/20/03  ECO: *P0MX* */
/* Revision: 1.14.2.13    BY: Orawan Songmoungsuk DATE: 04/21/03  ECO: *P0Q8* */
/* Revision: 1.14.2.14    BY: Mercy Chittilapilly DATE: 05/21/03  ECO: *P0RM* */
/* Revision: 1.14.2.16    BY: Paul Donnelly (SB)  DATE: 06/26/03  ECO: *Q00B* */
/* Revision: 1.14.2.17    BY: Vandna Rohira       DATE: 11/03/03  ECO: *P14V* */
/* Revision: 1.14.2.18    BY: Preeti Sattur       DATE: 05/19/04  ECO: *P217* */
/* Revision: 1.14.2.19    BY: Shivanand Hiremath  DATE: 07/13/04  ECO: *P29R* */
/* Revision: 1.14.2.20    BY: Robin McCarthy      DATE: 01/05/05  ECO: *P2P6* */
/* $Revision: 1.14.2.20.2.1 $           BY: Dilip Manawat       DATE: 09/20/06  ECO: *P56T* */
/*-Revision end---------------------------------------------------------------*/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/*V8:ConvertMode=Maintenance                                                  */

{mfdeclre.i}
{cxcustom.i "APVOMTA.P"}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */

/* LOCAL VARIABLE DEFINITIONS */
define variable yn               like mfc_logical.
define variable vp-part          like vp_part.

define variable varstd        like vod_amt format "->>,>>>,>>9.99"
                                           label "Ext PPV".
define variable stdcst        like prh_pur_std label "GL Cost".
define variable ext_open      like vod_amt format "->>,>>>,>>9.99"
                                           label "Ext Open".
define variable ext_rate_var  like vod_amt format "->>,>>>,>>9.99"
                                           label "Ext Rate Var".
define variable close_pvo     like mfc_logical label "Close Line".
define variable ext_usage_var like vod_amt format "->>,>>>,>>9.99"
                                           label "Ext Usage Var".

define shared variable auto-select     like mfc_logical.
define shared variable taxchanged      as logical no-undo.
define shared variable rndmthd         like rnd_rnd_mthd.
define shared variable l_flag          like mfc_logical no-undo.

define new shared variable process_gl  like mfc_logical initial no.

define new shared variable gpglef2 like mfc_logical no-undo.

define variable l_ctr  like mfc_integer no-undo.
define variable l_func like mfc_char    no-undo.

/* DEFINE SHARED CURRENCY-DEPENDENT FORMATTING VARIABLES */
{apcurvar.i}

{apvomta.i "NEW"}

{etvar.i } /* COMMON EURO VARIABLES */
{ieconsdf.i} /* INTRASTAT PRE-PROCESSOR CONSTANTS DEFINITION */

define variable select_logistics_charge like mfc_logical initial no no-undo.

/* DEFINE TEMP-TABLE FOR pvo_mstr/vph_hist JOIN */
define temp-table tt_pvo_mstr          no-undo
   field tt_pvo_id                     like pvo_id
   field tt_pvo_receiver               like pvo_internal_ref
   field tt_pvo_order                  like pvo_order
   field tt_pvo_line                   like pvo_line
   field tt_pvo_part            like pvo_part
   field tt_pvo_supplier        like pvo_supplier
   field tt_pvo_vouchered_qty          like pvo_vouchered_qty
   field tt_vph_ref                    like vph_ref
   index primary is unique
         tt_pvo_id
   index sort_order
         tt_pvo_receiver
         tt_pvo_line.

define new shared frame d.
define new shared frame f.
define new shared frame m.
define new shared frame match_detail.

/* FRAME DEFINITIONS */
{apvofmfm.i}

/* FIND VOUCHER AND CONTROL RECORDS */
find ap_mstr where recid(ap_mstr) = ap_recno no-lock no-error.
find vo_mstr where recid(vo_mstr) = vo_recno no-lock no-error.

find first apc_ctrl where apc_domain = global_domain no-lock.
find first gl_ctrl where gl_domain = global_domain no-lock.

l_ctr = 0.

main:
do on error undo, leave:

   loopf1:
   do on error undo, leave:

/* select_logistics_charges IS FALSE FOR RECEIVER SELECTION */

      /* RECEIVER AUTOMATIC SELECTION */
      {&APVOMTA-P-TAG1}
      if new vo_mstr and auto-select then do:

         /* l_ctr PARAMETER CAUSES PO INTRASTAT RECORDS */
         /* TO BE DELETE UPON FULL VOUCHERING.          */

         {&APVOMTA-P-TAG2}
         {gprun.i ""apvomtj.p"" "(input select_logistics_charge,
                                  no,
                                  output process_gl,
                                  input-output l_ctr)"}
      end.

      assign
         ap_amt:format in frame d = ap_amt_fmt
         aptotal:format in frame d = ap_amt_fmt.

      display
         ap_ref
         aptotal
         ap_amt
         ap_curr
      with frame d.

      view frame match_detail.
      view frame f.

      loopf2:
      repeat:
         /* OPEN PO RCPTS AVAILABLE FOR SELECT IN HELP WINDOW*/
         /* DISPLAY RCPTS ALREADY VOUCHERED BY THIS VOUCHER*/
         {swindap.i}

         /* IF BATCH MODE THEN "RECEIVER MATCHING DETAIL" FRAME WAS */
         /* SKIPPED. HOWEVER, IF ATTACHED RECEIVERS EXIST THEN WE   */
         /* STILL NEED TO CONSUME NEXT LINE IN CIM FILE.            */
         if batchrun and can-find(first vph_hist
            where vph_domain = global_domain
            and   vph_ref = vo_ref)
         then do:
            readkey.
            IF NOT BATCHRUN THEN DO:
            	 if keyfunction(lastkey) <> "RETURN" then import ^.
            END.
            /* IF CIM SAYS END-ERROR KEY THEN LEAVE LOOPF1 AND */
            /* PROCEED TO LINE DISTRIBUTION (JUST AS SWINDAP.I */
            /* DOES ABOVE FOR REGULAR INTERACTIVE MODE)        */
            if keyfunction(lastkey) = "." or keyfunction(lastkey) = "END-ERROR" then leave loopf1.
         end.

         /* EDIT RECEIVERS ONLY IF NOT CONFIRMED */
         if not (apc_confirm = no and vo_confirm = yes and not new_vchr)
         then do:

            /* UPDATE / ATTACH NEW RECEIVERS */
            taxchanged = no.

            /* INPUT-OUTPUT PARAMETER l_ctr DELETES PO */
            /* INTRASTAT RECORDS UPON FULL VOUCHERING  */
            gpglef2 = yes.
            {gprun.i ""xxapvomta5.p""
                      "(input-output l_ctr,
                        input pvoID)"}

            if gpglef2 = no then undo main, leave main.

            /* l_flag IS SET TO true IN BATCH MODE IN apvomta5.p */
            /* FOR AN ERROR ENCOUNTERED.                         */
            if l_flag then
               return.

            if not can-find (first vph_hist
               where vph_domain = global_domain
               and   vph_ref = vo_ref)
            then
               leave loopf1.

            next loopf2.

         end.  /* IF NOT CONFIRMED ... */

         leave loopf2.

      end. /* End loopf2 */

      do on endkey undo main, leave main:
         if (apc_confirm = no and vo_confirm = yes and not new_vchr)
         then do:
            /* Voucher confirmed. No modifications with GL Impact allowed */
            if batchrun = no then do:
            		{pxmsg.i &MSGNUM=2214 &ERRORLEVEL=2}
            		pause.
            end.
         end.
         else do:
            yn = yes.
            if batchrun = no then do: 
           		 {pxmsg.i &MSGNUM=12 &ERRORLEVEL=1 &CONFIRM=yn}
            end.
            if yn = no then
               undo loopf1, retry loopf1.
         end.
      end.
   end. /* End loopf1 */

   /* CREATE vod_det RECORDS FOR NEW OR MODIFIED VOUCHERS */

   {&APVOMTA-P-TAG3}
   if process_gl = yes and
      {&APVOMTA-P-TAG4}
      not (apc_confirm = no and vo_confirm = yes and not new_vchr)
   then do:
      {gprun.i ""xxapvomta4.p""}
   end. /* PROCESS GL */

end. /* MAIN */

l_func = keyfunction(lastkey).

if l_func = "END-ERROR"
then do:

   /* GET THE INTRASTAT CONTROL */
   for first iec_ctrl
      fields (iec_domain iec_authority)
      where iec_domain = global_domain
   no-lock: end.

   for each tt_pvo_mstr
   no-lock:
      /* DELETE THE INTRASTAT PO RECORDS WHEN THE PO IS FULLY        */
      /* VOUCHERED USING AUTO SELECT AND WITHOUT EDITING THE RECORD. */
      find first ieh_hist
         where ieh_domain    = global_domain
         and   ieh_authority = iec_authority
         and   ieh_type      = {&IE_TYPE_PO}
         and   ieh_nbr       = tt_pvo_order
         and   ieh_line      = tt_pvo_line
         and   ieh_ref       = tt_pvo_receiver
         and   ieh_qty       = 0
      exclusive-lock no-error.
      if available ieh_hist then
         delete ieh_hist.
   end. /* FOR EACH tt_pvo_mstr */
end. /* IF l_func = "END-ERROR" */

hide frame d no-pause.
hide frame match_detail no-pause.
hide frame f no-pause.
hide frame m no-pause.
