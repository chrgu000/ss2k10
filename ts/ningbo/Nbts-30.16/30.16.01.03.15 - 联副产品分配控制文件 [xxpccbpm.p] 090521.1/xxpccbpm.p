/* appm.p - AP CONTROL PARAMETER MAINTAINCE                                   */
/* Copyright 1986-2003 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.9.2.11 $                                                      */
/* REVISION: 1.0      LAST MODIFIED: 08/18/86   BY: PML                       */
/* REVISION: 6.0      LAST MODIFIED: 05/03/91   BY: mlv *D595*                */
/* REVISION: 7.0      LAST MODIFIED: 08/09/91   BY: mlv *F002*                */
/*                                   11/15/91   BY: mlv *F037*                */
/*                                   07/10/92   BY: mlv *F725*                */
/* REVISION: 7.3      LAST MODIFIED: 07/24/92   By: mpp *G004*                */
/*                                   08/17/92   BY: mlv *G031*                */
/*                                   09/04/92   BY: mlv *G042*                */
/*                                   02/17/93   by: jms *G698*                */
/* REVISION: 7.4      LAST MODIFIED: 11/30/93   BY: pcd *H249*                */
/*                                   11/30/93   BY: pcd *H255*(rev only)      */
/*                                   11/30/93   BY: wep *H201*                */
/*                                   09/28/94   BY: bcm *H479*                */
/* REVISION: 7.4      LAST MODIFIED: 10/27/94   BY: ame *FS90*                */
/* REVISION: 8.5      LAST MODIFIED: 02/27/96   BY: *J0CV* Brandy J Ewing     */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane          */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan         */
/* REVISION: 8.6E     LAST MODIFIED: 06/30/98   BY: *J2P4* Samir Bavkar       */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan         */
/* REVISION: 9.0      LAST MODIFIED: 03/10/99   BY: *M0B3* Michael Amaladhas  */
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan         */
/* REVISION: 9.1      LAST MODIFIED: 10/01/99   BY: *N014* Murali Ayyagari    */
/* REVISION: 9.1      LAST MODIFIED: 05/25/99   BY: *N00D* Adam Harris        */
/* REVISION: 9.1      LAST MODIFIED: 01/19/00   BY: *N077* Vijaya Pakala      */
/* REVISION: 9.1      LAST MODIFIED: 08/11/00   BY: *N0KK* Jacolyn Neder      */
/* REVISION: 9.1      LAST MODIFIED: 08/21/00   BY: *N0MH* Arul Victoria      */
/* REVISION: 9.1      LAST MODIFIED: 08/04/00   BY: *N0VN* BalbeerS Rajput    */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.9.2.9       BY: Paul Donnelly      DATE: 12/18/01  ECO: *N16J* */
/* Revision: 1.9.2.10    BY: Jean Miller        DATE: 05/07/02  ECO: *P066* */
/* $Revision: 1.9.2.11 $   BY: Orawan S.          DATE: 04/17/03  ECO: *P0Q3* */

/* SS - 090521.1 By: Bill Jiang */

/* SS - 090521.1 - RNB
[090521.1]

包含以下字段:
  - SoftspeedPC_al98: 联副产品自定义分配方法所使用的属性名(供应商)

[090521.1]

SS - 090521.1 - RNE */

/*V8:ConvertMode=Maintenance                                                  */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* DISPLAY TITLE */
/*
{mfdtitle.i "2+ "}
*/
{mfdtitle.i "090521.1"}

define variable c-label as character no-undo.

define variable SoftspeedPC_al98 like mfc_char FORMAT "x(8)".

/* DISPLAY SELECTION FORM */
{&APPMFRM-I-TAG1}
form
   SoftspeedPC_al98          colon 38
with frame appm-a width 80 side-labels attr-space
/*V8! title color normal (getFrameTitle("ACCOUNTS_PAYABLE_CONTROL",41)) */.
{&APPMFRM-I-TAG2}

/* SET EXTERNAL LABELS */
setFrameLabels(frame appm-a:handle).
{&APPMFRM-I-TAG3}

/* DISPLAY */
ststatus = stline[3].
status input ststatus.
view frame appm-a.

repeat with frame appm-a:

   /* ADD MFC_CTRL FIELD SoftspeedPC_al98 */
   for first mfc_ctrl where mfc_domain = global_domain and mfc_field = "SoftspeedPC_al98"
   exclusive-lock: end.

   if not available mfc_ctrl then do:

      c-label = getTermLabel("FROM_ENTITY", 45).

      create mfc_ctrl.
      assign
         mfc_domain = GLOBAL_domain
         mfc_field   = "SoftspeedPC_al98"
         mfc_type    = "C"
         mfc_label   = c-label
         mfc_module  = execname
         mfc_seq     = 10
         mfc_char = "".

   end.

   assign
      SoftspeedPC_al98 = mfc_char.

   display
      SoftspeedPC_al98
   with frame appm-a.

   seta:
   do on error undo, retry:

      set
         SoftspeedPC_al98
      with frame appm-a.
      {&APPM-P-TAG3}

      if SoftspeedPC_al98 = "" then do:
         /* Blank not allowed */
         {pxmsg.i &MSGNUM=40 &ERRORLEVEL=3}
         next-prompt SoftspeedPC_al98.
         undo seta, retry.
      end.

      FIND FIRST vd_mstr
         WHERE vd_domain = GLOBAL_domain
         AND vd_addr = SoftspeedPC_al98
         NO-LOCK NO-ERROR.
      IF NOT AVAILABLE vd_mstr THEN DO:
         /* Not a valid supplier */
         {pxmsg.i &MSGNUM=2 &ERRORLEVEL=3}
         next-prompt SoftspeedPC_al98.
         undo seta, retry.
      END.
   end.

   find first mfc_ctrl where mfc_domain = global_domain and mfc_field = "SoftspeedPC_al98" no-error.
   if available mfc_ctrl then mfc_char = SoftspeedPC_al98.
end.

status input.
