/* rcrp1301.p - SHIPPER PRINT                                                */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                       */
/* All rights reserved worldwide.  This is an unpublished work.              */
/* $Revision: 1.9.1.3 $                                                         */
/*V8:ConvertMode=Report                                                      */
/* REVISION: 7.5      LAST MODIFIED: 07/19/95           BY: GWM *J049*       */
/* REVISION: 8.5      LAST MODIFIED: 05/15/96           BY: GWM *J0MJ*       */
/* REVISION: 8.5      LAST MODIFIED: 06/26/96           BY: taf *J0WC*       */
/* REVISION: 8.6      LAST MODIFIED: 09/13/96   BY: *K003* Vinay Nayak-Sujir */
/* REVISION: 8.6      LAST MODIFIED: 10/04/96   BY: *K003* Kieu Nguyen       */
/* REVISION: 8.6      LAST MODIFIED: 10/31/96   BY: *K003* Steve Goeke       */
/* REVISION: 8.6      LAST MODIFIED: 06/20/97   BY: *H19N* Aruna Patil       */
/* REVISION: 8.6      LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan        */
/* REVISION: 8.6      LAST MODIFIED: 07/20/98   BY: *H1MC* Manish K.         */
/* REVISION: 9.1      LAST MODIFIED: 12/28/99   BY: *N05X* Surekha Joshi     */
/* REVISION: 9.1      LAST MODIFIED: 08/12/00   BY: *N0KP* myb               */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* $Revision: 1.9.1.3 $    BY: Jean Miller           DATE: 04/26/02  ECO: *P06H*  */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* This entire routine is effectively (though not actually)          */
/* obsoleted by the shipper print form service encapsulated in       */
/* sofmsv01.p.  Thus the bulk of the routine is commented out and    */
/* replaced by a call to the service within the encapsulating        */
/* routine.  Since the system should always attempt to run the       */
/* encapsulation routine before rcrp1301.p, and the encapsulation    */
/* routine sofmsv01.p should always exist, this routine could        */
/* actually be safely deleted.  However, it is retained here for     */
/* historical purposes.                                              */

{mfdeclre.i}

/* INPUT PARAMETERS */
define input parameter i_abs_recid     as recid         no-undo.
define input parameter i_ship_comments like mfc_logical no-undo.
define input parameter i_pack_comments like mfc_logical no-undo.
define input parameter i_printed_opt   like mfc_logical no-undo.
define input parameter i_print_sodet   like mfc_logical no-undo.
define input parameter i_so_um         like mfc_logical no-undo.
define input parameter i_comp_addr     like ad_addr     no-undo.

/* LOCAL VARIABLES */
define variable h_form_svc as handle no-undo.

/* MAIN PROCEDURE BODY */

/* Run routine encapsulating shipper form print service */

{gprun.i "'xgsofmsv01.p'"  " "  "persistent set h_form_svc" }

if lookup ("xxsh_print",h_form_svc:INTERNAL-ENTRIES) > 0 then
   run xxsh_print in h_form_svc
      (i_abs_recid, i_ship_comments, i_pack_comments, i_printed_opt,
       i_print_sodet, i_so_um).

delete PROCEDURE h_form_svc.

return.
