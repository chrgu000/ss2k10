/* mfdeclre.i - INCLUDE FILE SHARED VARIABLES                                */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                       */
/* All rights reserved worldwide.  This is an unpublished work.              */
/*V8:ConvertMode=NoConvert                                                   */
/* REVISION: 1.0     LAST MODIFIED: 07/17/86    BY: EMB                      */
/* REVISION: 1.0     LAST MODIFIED: 05/10/86    BY: PML                      */
/* REVISION: 2.0     LAST MODIFIED: 05/21/87    BY: EMB                      */
/* REVISION: 2.1     LAST MODIFIED: 08/31/87    BY: WUG      *A94*           */
/* REVISION: 4.0     LAST MODIFIED: 01/04/88    BY: PML      *A119*          */
/* REVISION: 4.0     LAST MODIFIED: 01/12/88    BY: RL       *A140*          */
/* REVISION: 4.0     LAST MODIFIED: 02/10/88    BY: WUG      *A175*          */
/* REVISION: 4.0     LAST MODIFIED: 05/02/88    BY: FLM      *A220*          */
/* REVISION: 4.0     LAST MODIFIED: 07/11/88    BY: FLM      *A268*          */
/* REVISION: 4.0     LAST MODIFIED: 07/14/88    BY: RL       *C0028*         */
/* REVISION: 4.0     LAST MODIFIED: 11/09/88    BY: EMB      *A527*          */
/* REVISION: 4.0     LAST MODIFIED: 02/16/89    BY: WUG      *B038*          */
/* REVISION: 5.0     LAST MODIFIED: 04/20/89    BY: JMS      *B066*          */
/* REVISION: 5.0     LAST MODIFIED: 12/13/89    BY: WUG      *B445*          */
/* REVISION: 5.0     LAST MODIFIED: 02/15/90    BY: WUG      *B569*          */
/* REVISION: 6.0     LAST MODIFIED: 04/19/90    BY: MLB      *D021*          */
/* REVISION: 6.0     LAST MODIFIED: 06/20/90    BY: EMB                      */
/* REVISION: 6.0     LAST MODIFIED: 06/28/90    BY: WUG      *D043*          */
/* REVISION: 6.0     LAST MODIFIED: 06/28/90    BY: PML      *D032*          */
/* REVISION: 6.0     LAST MODIFIED: 07/24/90    BY: JMS      *D034*          */
/* REVISION: 6.0     LAST MODIFIED: 10/09/90    BY: WUG                      */
/* REVISION: 6.0     LAST MODIFIED: 12/06/90    BY: WUG      *D227*          */
/* REVISION: 6.0     LAST MODIFIED: 09/26/91    BY: afs      *D847*          */
/* REVISION: 7.0     LAST MODIFIED: 08/28/91    BY: pma      *F003*          */
/* REVISION: 7.0     LAST MODIFIED: 10/09/91    BY: dgh      *D892*          */
/* REVISION: 7.0     LAST MODIFIED: 10/15/91    BY: jjs      *F016*          */
/* REVISION: 7.0     LAST MODIFIED: 11/05/91    BY: WUG      *D912*          */
/* REVISION: 7.0     LAST MODIFIED: 11/06/91    BY: pma      *F003*          */
/* REVISION: 7.0     LAST MODIFIED: 04/06/92    By: jcd      *F394*          */
/* REVISION: 7.0     LAST MODIFIED: 05/15/92    by: jms      *F503*          */
/* REVISION: 7.3     LAST MODIFIED: 08/03/92    by: mpp      *G024*          */
/* REVISION: 7.3     LAST MODIFIED: 09/16/92    By: jcd      *G058*          */
/* REVISION: 7.4     LAST MODIFIED: 10/27/93    By: dgh      *H152*          */
/* REVISION: 7.4     LAST MODIFIED: 08/31/94    By: rmh      *H495*          */
/* REVISION: 7.4     LAST MODIFIED: 09/26/94    By: rmh      *GM84*          */
/* REVISION: 7.4     LAST MODIFIED: 09/26/94    By: rmh      *FR40*          */
/* REVISION: 7.4     LAST MODIFIED: 02/28/95    BY: jwy      *G0FB*          */
/* REVISION: 8.5     LAST MODIFIED: 09/29/95    BY: jpm      *J086*          */
/* REVISION: 7.4     LAST MODIFIED: 12/21/95    BY: jzs      *G1GR*          */
/* Revision: 8.5     Last Modified: 12/11/95    BY: BHolmes  *J0FY*          */
/* Revision: 8.6     Last Modified: 09/17/97    BY: kgs      *K0J0*          */
/* Revision: 9.1     Last Modified: 09/28/99    BY: Robin McCarthy *N014*    */
/* Revision: 9.1     Last Modified: 05/18/99    BY: Brian Compton  *N03S*    */
/* Revision: 9.1     Last Modified: 02/24/00    BY: Murali Ayyagari *N08X*   */
/* Revision: 9.1     Last Modified: 08/17/00    BY: *N0LJ* Mark Brown        */
/* Revision: 1.15    BY: Katie Hilbert  DATE: 04/06/01 ECO: *P008*    */
/* $Revision: 1.18 $  BY: Paul Donnelly  DATE: 07/01/03  ECO: *Q00H*  */
/*-Revision end---------------------------------------------------------------*/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* ADDED LINES TO SUPPRESS SHARED VARIABLE DEFINITIONS BY CHECKING THE
 * NOSHARED PARAMETER DEFINITION. THE SAME LINES HAVE BEEN ADDED IN THE
 * MFDECGUI.I AND MFDECWEB.I INCLUDE FILES. GROUPED ALL THE SHARED VARIABLES.
 * IMPORTANT: PXGBLMGR.P HAS TO BE MODIFIED FOR ANY NEWLY INTRODUCED SHARED
 * VARIABLE(S) IN THESE INCLUDE FILES.
 * USAGE:  {mfdeclre.i &NOSHARED} -  TO SUPPRESS THE SHARED VARIABLES.
 *         {mfdeclre.i "NEW"} - TO DEFINE NEW SHARED VARIABLES.
 *         {mfdeclre.i}       - TO DEFINE SHARED VARIABLES. */

define variable next_seq  as  integer format ">>>>>>>>" no-undo.
define variable recno as recid.
define variable mrp_recno as recid.

/* THE FOLLOWING VARIABLE IS USED IN THE LOGIC OF MFDECGUI.I INCLUDE FILE.
 * SO THIS IS NOT ADDED IN THE SHARED VARIABLE SUPPRESSION. */
define {1} shared variable global_user_lang_dir like lng_mstr.lng_dir.

/* DOMAIN VARIABLES MUST NOT BE SUPPRESSED */
define {1} shared variable global_domain as character.
define {1} shared variable ecom_domain as character.

define {1} shared variable global_usrc_right_hdr_disp like usrc_right_hdr_disp no-undo.
/* THE FOLLOWING VARIABLE IS USED NEW SHARED VARIABLE. SO THIS IS NOT
 * ADDED IN THE SHARED VARIABLE SUPPRESSION. */
define new shared variable mfquotec as character.

define variable msg_temp like msg_mstr.msg_desc.
define variable msg_var1 like msg_mstr.msg_desc.

define variable null_char as character initial "".

define variable curcst like sct_det.sct_cst_tot label "Current Cost".
define variable glxcst like sct_det.sct_cst_tot label "GL Cost".
define variable gllinenum like glt_det.glt_line.

/* GROUPED ALL THE SHARED VARIABLES THAT ARE TO USED IN PXGBLMGR.P. */

&IF DEFINED(NOSHARED) = 0 &THEN
   define {1} shared variable dtitle as character format "x(78)".
   define {1} shared variable global_part like pt_mstr.pt_part.
   define {1} shared variable global_site like si_mstr.si_site.
   define {1} shared variable global_loc  like loc_mstr.loc_loc.
   define {1} shared variable global_lot  like ld_det.ld_lot.
   define {1} shared variable global_userid as character.
   define {1} shared variable pt_recno as recid.
   define {1} shared variable stline as character format "x(78)"
      extent 13.
   define {1} shared variable ststatus as character format "x(78)".
   define {1} shared variable global_char as character format "x(78)".
   define {1} shared variable hi_char as character.
   define {1} shared variable hi_date as date.
   define {1} shared variable low_date as date.
   define {1} shared variable global_user_lang like cmt_det.cmt_lang.
   define {1} shared variable global_user_lang_nbr like lng_mstr.lng_nbr.
   define {1} shared variable global_ref like cmt_det.cmt_ref.
   define {1} shared variable global_type like cmt_det.cmt_type.
   define {1} shared variable global_lang like cmt_det.cmt_lang.
   define {1} shared variable bcdparm as character.
   define {1} shared variable execname as character.
   define {1} shared variable batchrun like mfc_ctrl.mfc_logical.
   define {1} shared variable report_userid as character.
   define {1} shared variable base_curr like gl_ctrl.gl_base_curr.
   define {1} shared variable window_row as integer.
   define {1} shared variable window_down as integer.
   define {1} shared variable global_addr like ad_mstr.ad_addr.
   define {1} shared variable glentity like en_mstr.en_entity.
   define {1} shared variable current_entity like en_mstr.en_entity.
   define {1} shared variable global_db as character.
   define {1} shared variable trmsg like tr_hist.tr_msg.
   define {1} shared variable global_site_list as character.
   define {1} shared variable global_lngd_raw like mfc_ctrl.mfc_logical.
   define {1} shared variable mfguser as character.
   define {1} shared variable maxpage like prd_max_page.
   define {1} shared variable printlength as integer.
   define {1} shared variable runok like mfc_ctrl.mfc_logical.
   define {1} shared variable l-obj-in-use like mfc_logical.

   {mfdecweb.i " {1} "}

   if c-application-mode <> 'WEB' then do:
      {mfdecgui.i " {1} " }
   end.

   {gpreturn.i " {1} "}

   {eudeclre.i " {1} "}

   {pxgblmgr.i " {1} "}

&ELSE

  {mfdecweb.i &NOSHARED}

  if c-application-mode <> 'WEB' then do:
     {mfdecgui.i &NOSHARED}
  end.

  {gpreturn.i &NOSHARED}

  {eudeclre.i &NOSHARED}

  {pxgblmgr.i &NOSHARED}

&ENDIF
