/* GUI CONVERTED from txedit.i (converter v1.78) Fri Oct 29 14:38:16 2004 */
/* txedit.i - qad DISPLAY TAX DETAIL FIELDS                                */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.            */
/* $Revision: 1.4.2.6 $                                                           */
/*F0PN*/ /*V8:ConvertMode=Maintenance                                                  */
/* REVISION: 7.4            CREATED: 12/20/93   By: bcm              *H028**/
/*                         MODIFIED: 03/17/94   By: bcm              *H296**/
/* REVISION: 8.6           MODIFIED: 11/25/96   By: jzw              *K01X**/
/* REVISION: 8.6           MODIFIED: 05/20/98   By: *K1Q4* Alfred Tan      */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00 BY: *N08T* Annasaheb Rahane */
/* REVISION: 9.1      LAST MODIFIED: 08/12/00 BY: *N0KC* myb               */
/* $Revision: 1.4.2.6 $    BY: Laurene Sheridan      DATE: 10/21/02  ECO: *N13P*  */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/
/* ************************************************************************** */
/* Note: This code has been modified to run when called inside an MFG/PRO API */
/* method as well as from the MFG/PRO menu, using the global variable         */
/* c-application-mode to conditionally execute API- vs. UI-specific logic.    */
/* Before modifying the code, please review the MFG/PRO API Development Guide */
/* in the QAD Development Standards for specific API coding standards and     */
/* guidelines.                                                                */
/* ************************************************************************** */

include_tax = tx2d_tax_in.

tax_by = tx2d_by_line.

nonrecov_amt = tx2d_cur_tax_amt - tx2d_cur_recov_amt.

/* SET EXTERNAL LABELS */
setFrameLabels(frame b:handle).
if c-application-mode <> "API" then
   display
      tx2d_line @ tax_line
      tx2d_totamt

      tx2d_cur_nontax_amt
      tx2d_trl @ tax_trl
      tx2d_nbr
      tx2d_tottax
      tax_by
      tx2d_tax_env @ tax_env
      include_tax
      tx2d_edited
      tx2_tax_type
      tx2d_cur_tax_amt
      tx2d_effdate
      /* BUG - WAS USING 8 CHARS OF A 3 CHAR TAX CLASS */
      tx2d_taxc @ tx2_pt_taxc
      tx2d_cur_recov_amt
      pct_field
      tx2d_tax_usage @ tx2_tax_usage
      nonrecov_amt
      tx2_tax_code
      tx2_desc
      tx2d_cur_abs_ret_amt
   with frame b.
