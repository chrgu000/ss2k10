/* sofmsv01.p - SHIPPER FORM SERVICE ENCAPSULATION PROCEDUrE                  */
/* Copyright 1986-2003 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.26.3.34.1.1 $                                                     */
/*V8:ConvertMode=Report                                                       */
/* REVISION: 8.6      LAST MODIFIED: 11/12/96   BY: *K003* Steve Goeke        */
/* REVISION: 8.6      LAST MODIFIED: 12/06/96   BY: *K02Z* Vinay Nayak-Sujir  */
/* REVISION: 8.6      LAST MODIFIED: 12/19/96   BY: *K03J* Vinay Nayak-Sujir  */
/* REVISION: 8.6      LAST MODIFIED: 01/28/97   BY: *K04R* Kieu Nguyen        */
/* REVISION: 8.6      LAST MODIFIED: 02/05/97   BY: *K05Z* Steve Goeke        */
/* REVISION: 8.6      LAST MODIFIED: 03/15/97   BY: *K04X* Steve Goeke        */
/* REVISION: 8.6      LAST MODIFIED: 03/28/97   BY: *G2LS* Jim Williams       */
/* REVISION: 8.6      LAST MODIFIED: 03/25/97   BY: *K0DH* Arul Victoria      */
/* REVISION: 8.6      LAST MODIFIED: 06/20/97   BY: *H19N* Aruna Patil        */
/* REVISION: 8.6      LAST MODIFIED: 09/09/97   BY: *J20J* Suresh Nayak       */
/* REVISION: 8.6      LAST MODIFIED: 09/25/97   BY: *K0JZ* Joe Gawel          */
/* REVISION: 8.6      LAST MODIFIED: 10/01/97   BY: *K0KF* Joe Gawel          */
/* REVISION: 8.6      LAST MODIFIED: 10/23/97   BY: *J23T* Aruna Patil        */
/* REVISION: 8.6      LAST MODIFIED: 11/07/97   BY: *K18J* Jean Miller        */
/* REVISION: 8.6      LAST MODIFIED: 11/19/97   BY: *K19X* Jim Williams       */
/* REVISION: 8.6      LAST MODIFIED: 11/25/97   BY: *J26R* Niranjan R.        */
/* REVISION: 8.6      LAST MODIFIED: 12/13/97   BY: *J20Q* Aruna Patil        */
/* REVISION: 8.6      LAST MODIFIED: 12/19/97   BY: *J28J* Manish K.          */
/* REVISION: 8.6      LAST MODIFIED: 01/01/98   BY: *K1DL* Suresh Nayak       */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane          */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan         */
/* REVISION: 8.6E     LAST MODIFIED: 07/20/98   BY: *H1MC* Manish K.          */
/* REVISION: 8.6E     LAST MODIFIED: 08/05/98   BY: *J2VP* Manish K.          */
/* REVISION: 8.6E     LAST MODIFIED: 08/22/98   BY: *K1W8* Poonam Bahl        */
/* REVISION: 8.6E     LAST MODIFIED: 09/30/98   BY: *K1XF* Surekha Joshi      */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan         */
/* REVISION: 8.6E     LAST MODIFIED: 07/12/98   BY: *K21J* Poonam Bahl        */
/* REVISION: 9.1      LAST MODIFIED: 08/27/99   BY: *N024* J. Fernando        */
/* REVISION: 9.1      LAST MODIFIED: 09/23/99   BY: *K230* Santosh Rao        */
/* REVISION: 9.1      LAST MODIFIED: 10/25/99   BY: *N002* B. Gates           */
/* REVISION: 9.1      LAST MODIFIED: 06/30/99   BY: *N004* Patrick Rowan      */
/* REVISION: 9.1      LAST MODIFIED: 12/28/99   BY: *N05X* Surekha Joshi      */
/* REVISION: 9.1      LAST MODIFIED: 02/10/00   BY: *L0RC* Santosh Rao        */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1      LAST MODIFIED: 04/10/00   BY: *L0RG* Santosh Rao        */
/* REVISION: 9.1      LAST MODIFIED: 05/01/00   BY: *N0BG* Steve Nugent       */
/* REVISION: 9.1      LAST MODIFIED: 06/20/00   BY: *J3PY* Santosh Rao        */
/* REVISION: 9.1      LAST MODIFIED: 07/06/00   BY: *N0F4* Mudit Mehta        */
/* REVISION: 9.1      LAST MODIFIED: 07/10/00   BY: *L118* Abhijeet Thakur    */
/* REVISION: 9.1      LAST MODIFIED: 08/08/00   BY: *M0QZ* Rajesh Kini        */
/* REVISION: 9.1      LAST MODIFIED: 08/18/00   BY: *N0MC* Annasaheb Rahane   */
/* REVISION: 9.1      LAST MODIFIED: 12/02/00   BY: *M0X8* Santosh Rao        */
/* REVISION: 9.1      LAST MODIFIED: 10/14/00   BY: *N0W8* BalbeerS Rajput    */
/* Old ECO marker removed, but no ECO header exists *K139*                    */
/* Revision: 1.26.3.18       BY: Rajiv Ramaiah   DATE: 05/18/01   ECO: *M17M* */
/* Revision: 1.26.3.19       BY: Steve Nugent    DATE: 07/09/01   ECO: *P007* */
/* Revision: 1.26.3.20       BY: Chris Green     DATE: 07/27/01   ECO: *N101* */
/* Revision: 1.26.3.22       BY: Nikita Joshi    DATE: 09/07/01   ECO: *M1JZ* */
/* Revision: 1.26.3.23       BY: Ashwini G.      DATE: 11/09/01   ECO: *N160* */
/* Revision: 1.26.3.24       BY: Rajaneesh S.    DATE: 03/08/02   ECO: *N1CC* */
/* Revision: 1.26.3.25       BY: Katie Hilbert   DATE: 04/15/02   ECO: *P03J* */
/* Revision: 1.26.3.26     BY: Jean Miller     DATE: 05/13/02   ECO: *P05M* */
/* Revision: 1.26.3.28     BY: Ashish Kapadia  DATE: 08/16/02   ECO: *N1Q1* */
/* Revision: 1.26.3.31     BY: Rajiv Ramaiah   DATE: 08/20/02   ECO: *N1R4* */
/* Revision: 1.26.3.34     BY: Shilpa Athalye  DATE: 05/14/03   ECO: *N2FK* */
/* $Revision: 1.26.3.34.1.1 $    BY: K Paneesh       DATE: 06/12/03   ECO: *P0VB* */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/
/* REVISION: 9.1      LAST MODIFIED: 05/03/04   BY: *nad001* Apple Tam        */

/*****************************************************************************/
/*                                                                           */
/* sofmsv01.p - Service encapsulation for processing regular shipper forms   */
/*                                                                           */
/*****************************************************************************/

/*****************************************************************************/
/*                                                                           */
/* GENERAL DESCRIPTION OF SHIPPER FORM SERVICE ENCAPSULATION                 */
/*                                                                           */
/* All procedures of the form "sofmsvXX.p" - where "XX" is the two-character */
/* form code associated with the document format of a shipper - may          */
/* encapsulate any of the following set of shipper service procedures:       */
/*                                                                           */
/*   sh_gather_header  - invoked during maintenance of a shipper to gather   */
/*                       additional header-level information required to     */
/*                       appear on the printed shipper document              */
/*   sh_gather_item    - invoked during maintenance of a shipper to gather   */
/*                       additional line item-level information required to  */
/*                       appear on the printed shipper document              */
/*   sh_gather_trailer - invoked during maintenance of a shipper to gather   */
/*                       additional trailer-level information required to    */
/*                       appear on the printed shipper document              */
/*   sh_print          - invoked to perform the actual printing of a single  */
/*                       shipper document                                    */
/*   sh_rename         - invoked to change the key fields of the additional  */
/*                       header-, line item-, and trailer- level information */
/*                       records when the shipper number changes             */
/*   sh_archive        - invoked to archive the additional header, line      */
/*                       item, and trailer information associated with a     */
/*                       single shipper header or detail record, as well as  */
/*                       all of its descendant (children, grandchildren,     */
/*                       etc.) records                                       */
/*   sh_delete         - invoked to delete the additional header, line item, */
/*                       and trailer information associated with a single    */
/*                       shipper header or detail record, as well as all of  */
/*                       its descendant records                              */
/*                                                                           */
/*                                                                           */
/* It is not required for a given service encapsulation routine to include   */
/* all of the above services, since not all of the services may be           */
/* applicable to a given format.  Hence it is necessary to check the         */
/* availability of any service before attempting to invoke it.               */
/*                                                                           */
/*****************************************************************************/
/*                                                                           */
/* INVOKING SERVICES                                                         */
/*                                                                           */
/* Shipper services are invoked from within MFG/PRO by running the           */
/* encapsulation procedure appropriate to the shipper's document format      */
/* PERSISTENT, checking whether the desired service(s) is available, running */
/* either the available internal service routine(s) encapsulated in the      */
/* persistent procedure or some alternative routine, and deleting the        */
/* encapsulation procedure.                                                  */
/*                                                                           */
/* The following serves as an example:                                       */
/*                                                                           */
/*                                                                           */
/*       define variable h_form_svc as handle no-undo.                       */
/*                                                                           */
/*       run sofmsvXX.p persistent set h_form_svc.                           */
/*                                                                           */
/*       if lookup ("sh_delete",h_form_svc:INTERNAL-ENTRIES) > 0 then       */
/*                                                                           */
/*          run sh_delete in h_form_svc (recid(abs_mstr)).                   */
/*                                                                           */
/*       else                                                                */
/*                                                                           */
/*          <take appropriate alternative action>.                           */
/*                                                                           */
/*       delete procedure h_form_svc.                                        */
/*                                                                           */
/*                                                                           */
/*****************************************************************************/
/*                                                                           */
/* ADDING ADDITIONAL SETS OF SERVICES                                        */
/*                                                                           */
/* Shipper form services may be added to support additional document formats */
/* as required.  To add a set of services, an encapsulation routine of the   */
/* form "sofmsvXX.p" must be created, where "XX" is a unique two-character   */
/* form code associated with the document format of a shipper.  This should  */
/* encapsulate - that is, include as an internal routine - any of the seven  */
/* possible services required by shippers using the format.  These internal  */
/* service routines MUST accept input parameters as follows:                 */
/*                                                                           */
/*   sh_gather_header  - recid of shipper for which data is to be gathered   */
/*   sh_gather_item    - recid of shipper for which data is to be gathered   */
/*   sh_gather_trailer - recid of shipper for which data is to be gathered   */
/*   sh_print          - recid of shipper to be printed,                     */
/*                       logical indicating whether to print ship comments,  */
/*                       logical indicating whether to print pack comments,  */
/*                       logical indicating whether to print features and    */
/*                       options                                             */
/*   sh_rename         - recid of shipper whose number is to change,         */
/*                       new value of the abs_id field                       */
/*   sh_archive        - recid of shipper or shipper line to be archived,    */
/*                       name of archive file                                */
/*   sh_delete         - recid of shipper or shipper line to be deleted      */
/*                                                                           */
/* It should not be required to modify any other standard MFG/PRO routines   */
/* to invoke these services, since the invokation points are already         */
/* provided.                                                                 */
/*                                                                           */
/* A service encapsulation routine should NEVER directly create, modify, or  */
/* delete any database table.  Such updates should always be performed in a  */
/* separately-compiled procedure.  This ensures that users without full      */
/* Progress can add or modify services.                                      */
/*                                                                           */
/*****************************************************************************/
/*                                                                           */
/* INTERNAL SUPPORT ROUTINES                                                 */
/*                                                                           */
/* It may be necessary to create additional routines internal to the service */
/* encapsulation procedure to support the provided service routines.  In     */
/* such cases, it is suggested that the support routines be named using a    */
/* "supp_" prefix, rather than the "sh_" prefix used by the service          */
/* routines, so that the two types of routines may be easily distinguished.  */
/*                                                                           */
/* Support routines should NEVER be invoked from outside of the service      */
/* encapsulation procedure.                                                  */
/*                                                                           */
/*****************************************************************************/

/*****************************************************************************/
/*                                                                           */
/* SPECIFIC DESCRIPTION - sofmsv01.p                                         */
/*                                                                           */
/* This particular instance of a service encapsulation routine, sofmsv01.p,  */
/* provides the services required for processing standard shippers.  Since   */
/* no additional information is required for such shippers, the only         */
/* functional service routine provided here is sh_print.  However,           */
/* non-functional examples of each of the other service routines -           */
/* sh_gather_header, sh_gather_item, sh_gather_trailer, sh_rename,           */
/* sh_archive, and sh_delete - are also included, to serve as models for     */
/* later development of actual service routines to fulfill localization      */
/* requirements.                                                             */
/*                                                                           */
/* A new service encapsulation routine can be created by simply copying and  */
/* modifying sofmsv01.p.  The sample service routines are disabled by being  */
/* enclosed in comments, but are otherwise fully functional.  Remove the     */
/* comments disabling whichever service procedures are required, and then    */
/* make the appropriate modifications.                                       */
/*                                                                           */
/*****************************************************************************/

/* COMMON DEFINITIONS */

/* Here are defined all structures which must be accessible by */
/* multiple routines internal to the service encapsulation     */
/* procedure, but which cannot be passed as parameters, as     */
/* well as structures which Progress does not allow to be      */
/* defined within any internal routine.  This includes global  */
/* variables, frames, temp tables, constants, streams, etc.    */
/* Also defined here are any shared variables required to      */
/* support calls to legacy routines, since shared variables    */
/* cannot be defined within internal routines.                 */

/* Standard MFG/PRO included variables */

/* INCLUDE FILE FOR SHARED VARIABLES */
{mfdeclre.i}

/* LOCALIZATION CONTROL FILE */
{cxcustom.i "SOFMSV01.P"}

/* EXTERNAL LABEL INCLUDE */
{gplabel.i}

/* SHIPPER TEMP TABLE DEFINITION */
{rcwabsdf.i new}

/* FRAME f_non_so_ship IN ROUTINE sh_print IS DEFINED AS DISPLAY OF */
/* Cumulative Qty Shipped IS NOT REQUIRED FOR NON SO SHIPPERS       */

/* Define the name of this procedure, used to identify records */
/* in qad_wkfl that are created, modified, or deleted by any   */
/* service encapsulated here.                                  */

&scoped-define PROC-NAME 'sofmsv01.p'

/* Define prefixes used to identify qad_wkfl records holding   */
/* additional header, line item, or trailer information.       */

&scoped-define HDR-PREFIX 'HDR'
&scoped-define ITM-PREFIX 'ITM'
&scoped-define TRL-PREFIX "TRL"

/* Define an unprintable field delimiter, to be used by all of */
/* the service routines which pack/unpack multiple variable-   */
/* length fields stored within a single character variable,    */
/* such as header, line item, and trailer data-gathering       */
/* routines.  Without using such a delimiter, fields with      */
/* values such as "AB" and "C" would be indistinguishable from */
/* those with values of "A" and "BC" when packed together.  An */
/* unprintable delimiter ensures that the user could not have  */
/* inadvertantly or intentionally entered the delimiter within */
/* any field that is to be packed. */

&scoped-define delimiter chr(1)

/* HEADER DATA-GATHERING SERVICE DEFINITIONS */

/* < Add defs required by the header data-gathering service here > */

/* LINE ITEM DATA-GATHERING SERVICE DEFINITIONS */

/* < Add defs required by line item data-gathering service here > */

/* TRAILER DATA-GATHERING SERVICE DEFINITIONS */

/* < Add defs required by the trailer data-gathering service here > */

/* PRINT SERVICE DEFINITIONS */

/* Required for external procedure gpaddr.p */
define new shared variable addr as character format "x(38)" extent 6.

define temp-table t_abs_det no-undo
   field det_item     like abs_mstr.abs_item
   field det_order    like abs_mstr.abs_order
   field det_line     like abs_mstr.abs_line
   field det_qty      like abs_mstr.abs_qty
   field det_ship_qty like abs_mstr.abs_ship_qty
   field det_um       like abs_mstr.abs__qad02
   field det_conv     like abs_mstr.abs__qad03
   field det_cmtindx  like abs_mstr.abs_cmtindx
   field det_id       like abs_mstr.abs_id
   field det_shipfrom like abs_mstr.abs_shipfrom
   index item is primary
      det_item
      det_order
      det_line
   index order
      det_order.

define temp-table t_abs_comp no-undo
   field comp_item     like abs_mstr.abs_item
   field comp_shipfrom like abs_mstr.abs_shipfrom
   field comp_order    like abs_mstr.abs_order
   field comp_line     like abs_mstr.abs_line
   field comp_qty      like abs_mstr.abs_qty
   index item_ship is primary
      comp_item
      comp_shipfrom
      comp_order
      comp_line
   index item_order
      comp_item
      comp_order
      comp_line
   index shipfrom
      comp_shipfrom
      comp_order
      comp_line.

/* ADDED  THE FOLLOWING CODE TO PRINT AUTHORIZATION NUMBER */
define temp-table t_absr_det no-undo
   field t_absr_reference like absr_reference
   field t_absr_qty like absr_qty.

/* ADDED THE FOLLOWING TABLE TO PRINT CUSTOMER SEQUENCES */
define new shared temp-table t_abss_det no-undo
   field t_abss_ship_id like abss_ship_id
   field t_abss_from_cust_job like abss_cust_job
   field t_abss_from_cust_seq like abss_cust_seq
   field t_abss_to_cust_job like abss_cust_job
   field t_abss_to_cust_seq like abss_cust_seq.

/* ARCHIVE SERVICE DEFINITIONS */

define stream s_history.

/* RENAME SERVICE DEFINITIONS */

/* < ADD DEFS REQUIRED BY THE RENAME SERVICE HERE > */

/* DELETE SERVICE DEFINITIONS */

/* < ADD DEFS REQUIRED BY THE DELETE SERVICE HERE > */

/* END OF COMMON DEFINITIONS */

/* DUMMY REFERENCES FOR bomS, UNREFERENCED-FILE REPORTS, ETC. */
if false
then do:
   {gprun.i ""gpqwdel.p""}
   {gprun.i ""gpqwren.p""}
end.

{&SOFMSV01-P-TAG1}
/*****************************************************************************/

/* HEADER DATA-GATHERING SERVICE */

/*         /* Remove comments to enable this service */
*
*         /* NOTE:  If additional header information is stored in any table */
*         /* other than abs_mstr, remember that services to rename, delete, */
*         /* and possibly archive the information will also be required. */
*
*
*         procedure sh_gather_header:
*
*            /* Gathers additional header data associated with a shipper */
*            /* and required to appear on the printed shipper document  */
*
*            /* INPUT PARAMETERS */
*            define input parameter i_abs_recid as recid no-undo.
*
*            /* LOCAL VARIABLES */
*            define variable v_char as   character   label "Local Char" no-undo.
*            define variable v_int  as   integer     label "Local Int"  no-undo.
*            define variable v_dec  like mfc_decimal label "Local Dec"  no-undo.
*            define variable v_log  like mfc_logical label "Local Log"  no-undo.
*            define variable v_date as   date        label "Local Date" no-undo.
*
*            /* FRAMES */
*            form
*               skip (1)
*               v_char  colon 15
*               v_int   colon 15
*               v_dec   colon 15
*               v_log   colon 15
*               v_date  colon 15
*               skip (1)
*            with frame a overlay side-labels centered row 8
*               title color normal " Local Header Data ".
*
*
*            /* PROCEDURE BODY */
*
*            /* Find the shipper record with which this data is associated. */
*            /* If it's not available, there's nothing to do, so leave. */
*
*            find abs_mstr no-lock where recid(abs_mstr) = i_abs_recid
*               no-error.
*            if not available abs_mstr then return.
*
*            /* Load data from qad_wkfl */
*            run
*               supp_load_qad_wkfl (
*                  {&PROC-NAME},
*                  {&HDR-PREFIX} + abs_shipfrom + {&DELIMITER} + abs_id,
*                  output v_char,
*                  output v_int,
*                  output v_dec,
*                  output v_log,
*                  output v_date ).
*
*            /* Display info */
*            display v_char v_int v_dec v_log v_date with frame a.
*
*            /* Prompt for user update */
*            do on endkey undo, leave with frame a:
*               set v_char v_int v_dec v_log v_date.
*            end.  /* do on endkey */
*
*            hide frame a.
*
*            /* Save data into qad_wkfl */
*            if keyfunction(lastkey) <> "END-ERROR" then
*               run
*                  supp_save_qad_wkfl (
*                     {&PROC-NAME},
*                     {&HDR-PREFIX} + abs_shipfrom + {&DELIMITER} + abs_id,
*                     v_char,
*                     v_int,
*                     v_dec,
*                     v_log,
*                     v_date ).
*
*         end procedure.  /* sh_gather_header */
*/
/* END OF HEADER DATA-GATHERING SERVICE */

/*****************************************************************************/

/* LINE ITEM DATA-GATHERING SERVICE */

/*         /* Remove comments to enable this service */
*
*         /* NOTE:  If additional line item information is stored in any */
*         /* table other than abs_mstr, remember that services to delete */
*         /* and possibly archive the information will also be required. */
*
*
*         procedure sh_gather_item:
*
*            /* Gathers additional line item data associated with a shipper */
*            /* and required to appear on the printed shipper document  */
*
*
*            /* INPUT PARAMETERS */
*            define input parameter i_abs_recid as recid no-undo.
*
*            /* LOCAL VARIABLES */
*            define variable v_char as   character   label "Local Char" no-undo.
*            define variable v_int  as   integer     label "Local Int"  no-undo.
*            define variable v_dec  like mfc_decimal label "Local Dec"  no-undo.
*            define variable v_log  like mfc_logical label "Local Log"  no-undo.
*            define variable v_date as   date        label "Local Date" no-undo.
*
*            /* FRAMES */
*            form
*               skip (1)
*               abs_item   colon 15  label "Item"
*               abs_lotser colon 15
*               abs_ref    colon 15
*               skip (1)
*               v_char     colon 15
*               v_int      colon 15
*               v_dec      colon 15
*               v_log      colon 15
*               v_date     colon 15
*               skip (1)
*            with frame a overlay side-labels centered row 8
*               title color normal " Local Line Item Data ".
*
*
*            /* PROCEDURE BODY */
*
*            /* Find the shipper record with which this data is associated. */
*            /* If it's not available, there's nothing to do, so leave. */
*
*            find abs_mstr no-lock where recid(abs_mstr) = i_abs_recid
*               no-error.
*            if not available abs_mstr then return.
*
*            /* Load data from qad_wkfl */
*            run
*               supp_load_qad_wkfl (
*                  {&PROC-NAME},
*                  {&ITM-PREFIX} + abs_shipfrom + {&DELIMITER} + abs_id,
*                  output v_char,
*                  output v_int,
*                  output v_dec,
*                  output v_log,
*                  output v_date ).
*
*
*            /* Display info */
*            display
*               abs_item abs_lotser abs_ref
*               v_char v_int v_dec v_log v_date
*            with frame a.
*
*            /* Prompt for user update */
*            do on endkey undo, leave with frame a:
*               set v_char v_int v_dec v_log v_date.
*            end.  /* do on endkey */
*
*            hide frame a.
*
*            /* Save data into qad_wkfl */
*            if keyfunction(lastkey) <> "END-ERROR" then
*               run
*                  supp_save_qad_wkfl (
*                     {&PROC-NAME},
*                     {&ITM-PREFIX} + abs_shipfrom + {&DELIMITER} + abs_id,
*                     v_char,
*                     v_int,
*                     v_dec,
*                     v_log,
*                     v_date ).
*
*         end procedure.  /* sh_gather_item */
*/
/* END OF LINE ITEM DATA-GATHERING SERVICE */

/*****************************************************************************/

/* TRAILER DATA-GATHERING SERVICE */

/*         /* Remove comments to enable this service */
*
*         /* NOTE:  If additional trailer information is stored in any */
*         /* table other than abs_mstr, remember that services to rename, */
*         /* delete, and possibly archive the information will also be */
*         /* required. */
*
*
*         procedure sh_gather_trailer:
*
*            /* Gathers additional trailer data associated with a shipper */
*            /* and required to appear on the printed shipper document  */
*
*            /* INPUT PARAMETERS */
*            define input parameter i_abs_recid as recid no-undo.
*
*            /* LOCAL VARIABLES */
*            define variable v_char as   character   label "Local Char" no-undo.
*            define variable v_int  as   integer     label "Local Int"  no-undo.
*            define variable v_dec  like mfc_decimal label "Local Dec"  no-undo.
*            define variable v_log  like mfc_logical label "Local Log"  no-undo.
*            define variable v_date as   date        label "Local Date" no-undo.
*
*            /* FRAMES */
*            form
*               skip (1)
*               v_char  colon 15
*               v_int   colon 15
*               v_dec   colon 15
*               v_log   colon 15
*               v_date  colon 15
*               skip (1)
*            with frame a overlay side-labels centered row 8
*               title color normal " Local Trailer Data ".
*
*
*            /* PROCEDURE BODY */
*
*            /* Find the shipper record with which this data is associated. */
*            /* If it's not available, there's nothing to do, so leave. */
*
*            find abs_mstr no-lock where recid(abs_mstr) = i_abs_recid
*               no-error.
*            if not available abs_mstr then return.
*
*            /* Load data from qad_wkfl */
*            run
*               supp_load_qad_wkfl (
*                  {&PROC-NAME},
*                  {&TRL-PREFIX} + abs_shipfrom + {&DELIMITER} + abs_id,
*                  output v_char,
*                  output v_int,
*                  output v_dec,
*                  output v_log,
*                  output v_date ).
*
*            /* Display info */
*            display v_char v_int v_dec v_log v_date with frame a.
*
*            /* Prompt for user update */
*            do on endkey undo, leave with frame a:
*               set v_char v_int v_dec v_log v_date.
*            end.  /* do on endkey */
*
*            hide frame a.
*
*            /* Save data into qad_wkfl */
*            if keyfunction(lastkey) <> "END-ERROR" then
*               run
*                  supp_save_qad_wkfl (
*                     {&PROC-NAME},
*                     {&TRL-PREFIX} + abs_shipfrom + {&DELIMITER} + abs_id,
*                     v_char,
*                     v_int,
*                     v_dec,
*                     v_log,
*                     v_date ).
*
*         end procedure.  /* sh_gather_trailer */
*/
/* END OF TRAILER DATA-GATHERING SERVICE */

/*****************************************************************************/

/* PRINT SERVICE */

PROCEDURE sh_print:

   /* Prints a single shipper */

   /* This routine is logically equivalent to rcrp1301.p */

   /* INPUT PARAMETERS */
   define input parameter i_abs_recid        as recid         no-undo.
   define input parameter i_ship_comments    like mfc_logical no-undo.
   define input parameter i_pack_comments    like mfc_logical no-undo.
   define input parameter i_features         like mfc_logical no-undo.
   define input parameter i_print_sodet      like mfc_logical no-undo.
   define input parameter i_so_um            like mfc_logical no-undo.
   define input parameter i_comp_addr        like ad_addr     no-undo.
   define input parameter i_print_lotserials like mfc_logical no-undo.

   /* LOCAL VARIABLES */
   define variable company      as   character format "x(38)" extent 6 no-undo.
/*nad001**************/
   define variable county     like ad_county no-undo.
   define variable county2     as character format "x(40)" no-undo.
   define variable phone like ad_phone no-undo.
   define variable fax like ad_fax no-undo.
   define variable rpt_type2     as   character format "x(23)" no-undo.
   define variable xxline like sod_line no-undo.
   define variable xxnbr like sod_nbr no-undo.
   define variable xxpart like sod_part no-undo.
   define variable meas       like abs_nwt                no-undo.
   define variable meas2       like abs_nwt                no-undo.
   define variable drwg_loc       like abs_nwt                no-undo.
/*   define variable drwg_loc2       like abs_nwt                no-undo.*/
   define variable drwg_loc2       as integer format "->>,>>9"                no-undo.
/*nad001**************/
   define variable billto       as   character format "x(38)" extent 6 no-undo.
   define variable shipto       as   character format "x(38)" extent 6 no-undo.
   define variable rpt_type     as   character format "x(23)" no-undo.
   define variable type_nbr     as   character format "x(17)" no-undo.
   define variable l_seq_lbl    as   character format "x(20)" no-undo.
   define variable l_job_lbl    as   character format "x(16)" no-undo.
   define variable shipper_id   like abs_mstr.abs_id          no-undo.
   define variable ship_date    as   date                     no-undo.
   define variable print_date   as   date                     no-undo.
   define variable cust         like so_cust                  no-undo.
   define variable ship         like so_ship                  no-undo.
   define variable shipto_id    as   character                no-undo.
   define variable soldto_id    as   character                no-undo.
   define variable abs_shipvia  like so_shipvia               no-undo.
   define variable abs_fob      like so_fob                   no-undo.
   define variable abs_trans_mode as character format "x(20)" no-undo.
   define variable abs_carr_ref as   character format "x(20)" no-undo.
   define variable abs_veh_ref  as   character format "x(20)" no-undo.
   define variable disp_item    like pt_part format "x(30)" no-undo.
   define variable cum_qty      like sod_cum_qty[1] extent 0  no-undo.
   define variable cmtindx_cdl  as   character                no-undo.
   define variable cmt_ctr      as   integer                  no-undo.
   define variable i            as   integer                  no-undo.
   define variable dqty         like sob_qty_req
      format "->>>>>>>9.9<<<<<" no-undo.
   define variable v_tr_type    like im_tr_type               no-undo.
   define variable v_start_page as   integer                  no-undo.
   define variable msgdesc like msg_desc initial "" format "x(62)"
      no-undo.
   define variable addr_id      as   character                no-undo.
  define variable shipper-po   as   character format "x(22)" no-undo.
   define variable l_abs_twt       like abs_gwt               no-undo.
   define variable l_abs_tare_wt   like abs_gwt               no-undo.
   define variable l_tare_wt       like abs_gwt
      label "Tare!Weight"                      no-undo.
   define variable l_par_shipfrom  as character                no-undo.
   define variable l_par_id        as character                no-undo.
   define variable l_first_part_um like abs_wt_um              no-undo.
   define variable l_conv          as   decimal                no-undo.
   define variable l_net_wt1       like abs_nwt                no-undo.
   define variable l_gross_wt1     like abs_gwt                no-undo.
   define variable l_tare_wt1      like abs_gwt                no-undo.
   define variable l_net_wt2       like abs_nwt                no-undo.
   define variable l_gross_wt2     like abs_gwt                no-undo.
   define variable l_tare_wt2      like abs_gwt                no-undo.
   define variable l_qty           like abs_mstr.abs_qty       no-undo.
   define variable l_part_um       like abs_wt_um              no-undo.
   define variable v_absd_fld_seq          like absd_fld_seq   no-undo.
   define variable v_absd_fld_name         like absd_fld_name  no-undo.
   define variable v_absd_fld_value        like absd_fld_value no-undo.
   define variable using_container_charges like mfc_logical    no-undo.
   define variable using_line_charges      like mfc_logical    no-undo.
   define variable l_lot-lbl               as  character format "x(26)" no-undo.
   define variable l_ref-lbl               as  character format "x(12)" no-undo.
   define variable l_qty-lbl               as  character format "x(12)" no-undo.
   define variable l_expire-lbl            as  character format "x(8)"  no-undo.
   define variable l_ld_expire             like ld_expire           no-undo.
   define variable l_parent_tare_wt        like abs_nwt             no-undo.
   define variable l_nonso_det_qty         like abs_mstr.abs_qty    no-undo.

   define variable l_continue_lbl          as  character
                                           format "x(22)"           no-undo.
   define variable l_printed               like mfc_logical         no-undo.
   /* VARIABLE DEFINITIONS FOR gpfile.i */
   {gpfilev.i}
   define variable using_seq_schedules like mfc_logical
      initial no no-undo.
   define variable sequence_list as character format "x(36)" no-undo.

   /* BUFFERS */
   define buffer   b_abs_mstr      for  abs_mstr.

   assign
      l_lot-lbl    = getTermLabel("LOT/SERIAL_NUMBERS_SHIPPED",26)
      l_ref-lbl    = getTermLabel("REFERENCE",12)
      l_qty-lbl    = getTermLabel("QUANTITY",12)
      l_expire-lbl = getTermLabel("EXPIRE",8)
      i = 1.

   do while program-name(i) <> ? and
      index(program-name(i), 'reshmt.') = 0 and
      index(program-name(i), 'rerp11.') = 0:
      i = i + 1.
   end.

   if index(program-name(i), 'reshmt.') > 0 or
      index(program-name(i), 'rerp11.') > 0
   then do:
      {gprun.i ""rerp11a.p"" "(i_abs_recid)"}
      leave.
   end.

   /* FRAMES */
   form header
/*      skip (3)*/
/*      rpt_type2      to 79*/
      "DELIVERY NOTE" to 79
       
/*nad001*/ county2    at 4  
      company[2]  at 4
      sequence_list to 79
      company[3]  at 4        type_nbr      to 58   shipper_id
      company[4]  at 4
      getTermLabelRtColon("SHIP_DATE",14) format "x(14)"  to 58   ship_date
      company[5]  at 4
      getTermLabelRtColon("PRINT_DATE",14) format "x(14)" to 58   print_date
      getTermLabelRtColon("PAGE_OF_REPORT",10) format "x(10)" to 58
      trim(string(page-number - v_start_page + 1)) format "XXXX"
/*      company[6]  at 4*/
/*/*nad001*/ "TEL: " at 4    */
   getTermLabel("COMP_TEL",4) + ": " at 4
          phone 
/*/*nad001*/ "FAX: " at 4*/
   getTermLabel("COMP_FAX",4) + ": " at 4
            fax  
      skip (1)
      getTermLabel("SHIP_TO",14) + ": " + ship format "x(37)" at 8
      getTermLabel("SOLD_TO",14) + ": " + cust format "x(37)" at 46
/*      skip (1)*/
      shipto[1]   at 8       /* billto[1]      at 46*/
      shipto[2]   at 8       /* billto[2]      at 46*/
      shipto[3]   at 8       /* billto[3]      at 46*/
      shipto[4]   at 8       /* billto[4]      at 46*/
      shipto[5]   at 8       /* billto[5]      at 46*/
  /*    shipto[6]   at 8        billto[6]      at 46*/
  /*    skip(3)*/
/*nad001      getTermLabelRtColon("SHIP_VIA",12)                   format "x(12)" to 12
      abs_shipvia
      getTermLabelRtColon("MODE_OF_TRANSPORT",23)          format "x(23)" to 58
      abs_trans_mode
      getTermLabelRtColon("FOB_POINT",12)                  format "x(12)" to 12
      abs_fob
      getTermLabelRtColon("CARRIER_SHIPMENT_REFERENCE",23) format "x(23)" to 58
      abs_carr_ref
      getTermLabelRtColon("VEHICLE_ID",20)                 format "x(20)" to 58
      abs_veh_ref*/
      getTermLabelRtColon("MODE_OF_TRANSPORT",23)          format "x(23)" to 23
      abs_trans_mode
      getTermLabelRtColon("VEHICLE_ID",20)                 format "x(20)" to 23
      abs_veh_ref
      skip(1)
   with frame f_formhdr page-top width 90
   no-box no-attr-space no-labels.

 form
      disp_item                               column-label "Item Number"
/*nad001*/      xxline column-label "LN"
/*nad001*/      xxnbr column-label "Sales Order"
      shipper-po                              column-label "PO Number"
      det_qty      format "->>>>>>9.99<<<<<<"
/*nad001*/                                      column-label "Qty Shipped"
/*nad001         column-label "Qty Shipped!Cumulative Qty Shipped"*/
      abs_mstr.abs__qad02   format "x(2)"     column-label "UM"
   with frame f_det down width 100 no-box.

   /* SET EXTERNAL LABELS */
   setFrameLabels(frame f_det:handle).

   /* ADDED FRAME f_non_so_ship FOR DISPLAY OF NON-SO SHIPPERS DETAILS */
   form
      disp_item                       column-label "Item Number"
      shipper-po                      column-label "PO Number"
      l_nonso_det_qty                 format "->>>>>>9.99<<<<<<"
                                      column-label "Qty Shipped"
/*nad001*/      xxline column-label "LN"
/*nad001*/      xxnbr column-label "Sales Order"
      abs_mstr.abs__qad02             format "x(2)"
                                      column-label "UM"
   with frame f_non_so_ship down width 100 no-box.

   /* SET EXTERNAL LABELS */
   setFrameLabels(frame f_non_so_ship:handle).

   /* DEFINING THE FORM FOR AUTHORIZATION NUMBER */
   form
      t_absr_reference column-label "Authorization Number"  at 11
      t_absr_qty       column-label "Pegged Qty"
      sod_um
   with down frame auth.

   /* SET EXTERNAL LABELS */
   setFrameLabels(frame auth:handle).

   /* DEFINING FORMS FOR CUSTOMER SEQUENCES */
   form
      t_abss_from_cust_seq    at 10
      t_abss_to_cust_seq      label {t001.i}
   with down frame sequence2 width 80.

   /* SET EXTERNAL LABELS */
   setFrameLabels(frame sequence2:handle).

  /* DEFINING FORM FOR CONTAINER/LINE CHARGES */
   form
      space(5)
      v_absd_fld_seq
      v_absd_fld_name
      v_absd_fld_value
   with down frame absd_user_fields width 80.

    /* SET EXTERNAL LABELS */
   setFrameLabels(frame absd_user_fields:handle).

   /* PREPROCESSORS */
   &scoped-define PAGEBREAK

   for first abs_mstr
      fields (abs_cmtindx abs_gwt abs_id
              abs_item abs_line abs_nwt abs_vol abs_order
              abs_par_id abs_qty abs_shipfrom abs_shipto
              abs_ship_qty abs_shp_date abs_status abs_trl_cmtindx
              abs_wt_um abs__qad01 abs__qad02
              abs__qad03 abs__qad10)
      where recid(abs_mstr) = i_abs_recid
      no-lock:
   end. /* FOR FIRST abs_mstr */

   if not available abs_mstr
   then
      return.

   /* GET THE SHIPPER'S TRANSACTION TYPE */
   {gprun.i ""icshtyp.p""
            "(input i_abs_recid,
              output v_tr_type)" }

   l_continue_lbl = dynamic-function('getTermLabelFillCentered' in h-label,
                       input "CONTINUE", input 22, input '*').

   if  v_tr_type = "ISS-SO"
   and page-size - line-counter < 1
   then do with frame f_det:
      page.
      display
         disp_item
	 xxline
	 xxnbr
         l_continue_lbl @ shipper-po.
      down 1.
   end. /* IF v_tr_type = "ISS-SO" */

   if  v_tr_type <> "ISS-SO"
   and page-size - line-counter < 1
   then do with frame f_non_so_ship:
      page.
      display
         disp_item
	 xxline
	 xxnbr
         l_continue_lbl @ shipper-po.
      down 1.
   end. /* IF v_tr_type <> "ISS-SO" */


   /* PROCEDURE BODY */

   v_start_page = page-number.

   assign
      shipper_id = substring(abs_id,2)
      ship_date  = abs_shp_date.

   /* CUSTUMER SEQ. SCHEDULES INSTALLED? */
   {gpfile.i &file_name = """"rcf_ctrl""""}
   if can-find (mfc_ctrl where
                mfc_field = "enable_sequence_schedules" and mfc_logical)
                and file_found
   then
      using_seq_schedules = yes.

   /* Container and Line Charges INSTALLED? */
   {gpfile.i &file_name = """"ccl_ctrl""""}
   if can-find (mfc_ctrl where
                mfc_field = "enable_container_charges" and
                mfc_logical) and file_found
   then
      using_container_charges =  yes.

   if can-find (mfc_ctrl where
                mfc_field = "enable_line_charges" and
                mfc_logical) and file_found
   then
      using_line_charges =  yes.

   /* NOW DOCKTO, SHIPTO AND SOLDTO WILL BE TAKEN FROM ls_mstr */
   /* INSTEAD OF ad_mstr                                       */

   find ad_mstr no-lock where ad_addr = abs_shipto no-error.

   if available ad_mstr
   then do:
      assign
         shipto_id = ad_addr
         ship      = ad_addr
         addr[1]   = ad_name
         addr[2]   = ad_line1
         addr[3]   = ad_line2
         addr[4]   = ad_line3
         addr[6]   = ad_country.

      {mfcsz.i addr[5] ad_city ad_state ad_zip}

      {gprun.i ""gpaddr.p"" }

      assign
         shipto[1] = addr[1]
         shipto[2] = addr[2]
         shipto[3] = addr[3]
         shipto[4] = addr[4]
         shipto[5] = addr[5]
         shipto[6] = addr[6].

   end.  /* IF AVAILABLE ad_mstr */

   /* GET SOLD-TO ADDRESS PRINT FIELDS */

   find ad_mstr no-lock where ad_addr = abs_shipto.
   assign
      soldto_id = ad_addr
      cust      = ad_addr.

   find ls_mstr where ls_addr = ad_addr and ls_type = "customer"
   no-lock no-error.

   if not available ls_mstr and ad_ref > ""
   then do:

      find ls_mstr where ls_addr = ad_ref and
                         ls_type = "customer"
      no-lock no-error.

      if available ls_mstr
      then do:
         assign
            soldto_id = ad_ref
            cust      = ad_ref.
      end. /* END OF IF AVAILABLE ls_mstr */

      else do:

         addr_id = ad_ref.
         find first ad_mstr where ad_addr = addr_id no-lock.

         if ad_ref > "" then do:
            find ls_mstr where ls_addr = ad_ref and
                               ls_type = "customer"
            no-lock no-error.
            if available ls_mstr then
               assign
                  soldto_id = ad_ref
                  cust      = ad_ref.
         end. /* END OF IF ad_ref > "" */

      end. /* END OF ELSE DO */

   end. /* END OF NOT AVAILABLE ls_mstr */
   find first ad_mstr where ad_addr = soldto_id no-lock.

   if available ad_mstr
   then do:
      assign
         addr[1] = ad_name
         addr[2] = ad_line1
         addr[3] = ad_line2
         addr[4] = ad_line3
         addr[6] = ad_country.

      {mfcsz.i addr[5] ad_city ad_state ad_zip}

      {gprun.i ""gpaddr.p"" }

      assign
         billto[1] = addr[1]
         billto[2] = addr[2]
         billto[3] = addr[3]
         billto[4] = addr[4]
         billto[5] = addr[5]
         billto[6] = addr[6].

   end.  /* IF AVAILABLE (SOLDTO) ad_mstr */

   /* GET SHIP-FROM ADDRESS PRINT FIELDS */

   find ad_mstr no-lock where ad_addr = i_comp_addr no-error.

   if available ad_mstr
   then do:

      assign
         addr[1] = ad_name
         addr[2] = ad_line1
         addr[3] = ad_line2
         addr[4] = ad_line3
         addr[6] = ad_country.
	 /*nad001*/ phone = ad_phone.
	 /*nad001*/ fax = ad_fax.
	 /*nad001*/ county = ad_county.
	 /*nad001*/ county2 = ad_name + ad_county.

      {mfcsz.i addr[5] ad_city ad_state ad_zip}

      {gprun.i ""gpaddr.p"" }

      assign
         company[1] = addr[1]
         company[2] = addr[2]
         company[3] = addr[3]
         company[4] = addr[4]
         company[5] = addr[5]
         company[6] = addr[6].

   end.  /* IF AVAILABLE (SHIPFROM) ad_mstr */

   /* EXPLODE SHIPPER/CONTAINER TO GET LOW-LEVEL ITEM DETAIL */

   for each t_abs_det exclusive-lock:
      delete t_abs_det.
   end.

   run supp_build_det (i_abs_recid).

   assign
      print_date     = today
      abs_shipvia    = substring(abs__qad01, 1,20,"RAW")
      abs_fob        = substring(abs__qad01,21,20,"RAW")
      abs_carr_ref   = substring(abs__qad01,41,20,"RAW")
      abs_trans_mode = substring(abs__qad01,61,20,"RAW")
      abs_veh_ref    = substring(abs__qad01,81,20,"RAW").

   if abs_id begins "s" then
   assign
      {&SOFMSV01-P-TAG2}
      rpt_type2 = getTermLabelRt("BANNER_SHIPPER2",23)
      {&SOFMSV01-P-TAG3}
      type_nbr = getTermLabelRtColon("SHIPPER_ID",17).

   else
   if abs_id begins "c" then
      assign
         rpt_type = getTermLabel("BANNER_PACKING_LIST",23)
         type_nbr = getTermLabelRtColon("CONTAINER_ID",17).

   else
   if abs_id begins "p" then
      assign
         rpt_type = getTermLabel("BANNER_PRE_SHIPPER",23)
         type_nbr = " " + getTermLabel("PRE-SHIPPER_ID",15) + ":".

   /* DISPLAY HEADER */

   view frame f_formhdr.

   page.

   /* PRINT SHIPPER COMMENTS */
/*nad001********************************************
   if abs_cmtindx > 0 and i_ship_comments
   then do:
      {gpcmtprt.i &type=SH &id=abs_cmtindx &pos=3}
      put skip(1).
   end.
*nad001********************************************/

   /* PRINT SALES ORDER COMMENTS */

   {&SOFMSV01-P-TAG4}
   if i_pack_comments and v_tr_type = "ISS-SO"
   then
      {&SOFMSV01-P-TAG5}
      for each t_abs_det no-lock break by det_order:

      if first-of(det_order)
      then do:

         find so_mstr no-lock where so_nbr = det_order no-error.

         /* USING IDH_CONTR_ID TO FACILITATE PO NUMBER PRINTING FOR */
         /* DISCRETE AS WELL AS SCHEDULED ORDERS,                   */
         /* IF SALES ORDER IS NOT AVAILABLE                         */

         /* FINDING IDH_CONTR_ID BELOW IN SHIPPER DETAIL LOOPING    */
         /* STRUCTURE AS ONE SHIPPER CAN HAVE MANY SALES ORDERS     */

         if  available so_mstr and so_cmtindx > 0
         then do:
            {gpcmtprt.i &type=PA &id=so_cmtindx &pos=3}
         end.

         else do:
            for first ih_hist
               fields (ih_cmtindx ih_nbr ih_ship_po)
               where ih_nbr     = det_order
               and   ih_cmtindx > 0
            no-lock:
               {gpcmtprt.i &type=PA &id=ih_cmtindx &pos=3}
            end. /* for first ih_hist ... */
         end. /* ELSE DO */

      end.  /* IF FIRST-OF */
   end.  /* IF i_pack_comments ... THEN FOR */

    /* PRINT CONTAINER/LINE CHARGES HEADER USER FIELDS */
   if using_container_charges or using_line_charges then do:
      for each absd_det no-lock where
               absd_abs_id = abs_id  and
               absd_shipfrom = abs_shipfrom
      break by absd_abs_id:

         display
            absd_fld_seq   @ v_absd_fld_seq
            absd_fld_name  @ v_absd_fld_name
            absd_fld_value @ v_absd_fld_value
         with frame absd_user_fields.

         down 1 with frame absd_user_fields.

         if last-of(absd_abs_id) then
            down 2 with frame absd_user_fields.

      end. /* FOR EACH absd_det */
   end. /* IF using_container or using_line_charges */

   /* LOOP THROUGH SHIPPER DETAILS */

   if i_print_lotserials
   then do:

      /* INITIALIZING work_abs_mstr */
      for each work_abs_mstr
      exclusive-lock:
         delete work_abs_mstr.
      end. /* FOR EACH work_abs_mstr */

      /* EXPLODE SHIPPER TO GET ORDER DETAIL ONLY IF    */
      /* PRINT LOT/SERIAL NUMBERS IS "Yes"              */

      {gprun.i ""rcsoisa.p"" "(input i_abs_recid)"}
   end. /* IF i_print_lotserials */

   for each t_abs_det
      no-lock
      break by det_item
            by det_order
            by det_line:

      cmtindx_cdl = cmtindx_cdl + string(det_cmtindx) + ",".

      /* TO PRINT SHIPPER IN SO UM OR INVENTORY UM  */
      if i_so_um then do:

         for first sod_det
            fields ( sod_cfg_type sod_cmtindx  sod_contr_id sod_cum_qty
                     sod_custpart sod_custref  sod_line     sod_modelyr
                     sod_nbr      sod_part     sod_qty_ord  sod_um
                     sod_um_conv )
            where sod_nbr  = det_order
              and sod_line = integer (det_line)
         no-lock: end.

         if available sod_det then
            assign
               det_qty  = ( det_qty * decimal(det_conv) ) / sod_um_conv
               det_um   = sod_um
               det_conv = string(sod_um_conv).
      end. /* IF i_so_um */

      accumulate det_qty     (sub-total by det_line).
      accumulate det_ship_qty(sub-total by det_line).

      /* ADD WORKFILE ENTRY FOR COMPONENT QUANTITIES FOR KIT ITEMS */
      run supp_build_comp
         (det_shipfrom,
          det_id,
          det_order,
          det_line).

      /* CREATING THE WORKFILE FOR PRINTING THE AUTHORIZATION NUMBER */
      for each absr_det where
               absr_shipfrom = det_shipfrom
           and absr_id = det_id
      no-lock:

         if absr_reference <> ""
         then do:

            find first t_absr_det where
                       t_absr_reference = absr_reference
            no-error.

            if not available t_absr_det
            then do:
               create t_absr_det.
               assign
                  t_absr_reference = absr_reference
                  t_absr_qty       = absr_qty.
            end.
            else do:
               t_absr_qty = t_absr_qty + absr_qty.
            end.

         end. /* END OF IF absr_reference <> "" */

      end. /* END OF FOR EACH absr_det */

      /* PRINT DETAILS */
      if last-of(det_line)
      then do:

         assign
            disp_item = det_item
            cum_qty   = (accum sub-total by det_line det_qty) -
                        (accum sub-total by det_line det_ship_qty).

         {&SOFMSV01-P-TAG6}
         if v_tr_type = "ISS-SO"
         then do:
            {&SOFMSV01-P-TAG7}

            find sod_det no-lock where
               sod_nbr  = det_order and
               sod_line = integer(det_line) no-error.

            if available sod_det
            then do:

               for first cp_mstr
                  fields(cp_cust cp_cust_eco cp_cust_part
                         cp_cust_partd)
                  where cp_cust      = abs_mstr.abs_shipto and
                        cp_cust_part = sod_custpart no-lock:
               end. /* FOR FIRST cp_mstr */

               if not available cp_mstr
               then
               find cp_mstr where cp_cust = cust and
                  cp_cust_part = sod_custpart no-lock no-error.

               if not available cp_mstr
               then
               for first cp_mstr
                  fields(cp_cust cp_cust_eco cp_cust_part
                         cp_cust_partd)
                  where cp_cust      = "" and
                        cp_cust_part = sod_custpart no-lock:
               end. /* FOR FIRST cp_mstr */

               assign
                  disp_item = if available cp_mstr and cp_cust_partd <> ""
                              then
                                 cp_cust_partd
                              else if sod_custpart <> ""
                              then
                                 sod_custpart
                              else
                                 sod_part
                  xxline = sod_line
		  xxnbr = sod_nbr
		  xxpart = sod_part
		  /* cum_qty NEED TO DISPLAYED IN SHIP UM */
                  cum_qty = cum_qty +
                            ((sod_cum_qty[1] * sod_um_conv) / decimal(det_conv)).

               find pt_mstr no-lock where pt_part = sod_part no-error.

               if sod_sched then
                  shipper-po = sod_contr_id.
               else do:
                  for first so_mstr
                     fields(so_cmtindx so_nbr so_ship so_ship_po)
                     where  so_nbr = sod_nbr
                  no-lock:
                     shipper-po = so_ship_po.
                  end. /* FOR FIRST so_mstr */
               end. /* ELSE DO */

               if sod__qadc04 <> "" then
                  disp_item = sod__qadc04.

            end.  /* IF AVAILABLE sod_det */

            else do:

               for first idh_hist
                  fields (idh_contr_id idh_line idh_nbr idh_part
                          idh_cmtindx idh_sched)
                  where idh_nbr  = det_order and
                        idh_line = integer(det_line) and
                        idh_part = det_item
               no-lock: end.

               if available idh_hist
               then do:

                  if idh_sched then
                     shipper-po = idh_contr_id.
                  else do:
                     for first ih_hist
                        fields(ih_cmtindx ih_nbr ih_ship_po)
                        where ih_nbr = idh_nbr
                     no-lock:
                        shipper-po = ih_ship_po.
                     end.
                  end. /* ELSE DO */
               end. /* IF AVAILABLE idh_hist */
               else
                  shipper-po = "".

            end. /* NOT AVAILABLE sod_det */

         end.  /* IF v_tr_type */


         /* DISPLAY THE LINE ITEM */
         if v_tr_type = "ISS-SO"
         then do with frame f_det :

            /* SKIP TO NEW PAGE */
            if page-size - line-counter < 1
            then
               page.

            display
               disp_item
	       xxline
	       xxnbr
               shipper-po
               accum sub-total by det_line det_qty @ det_qty
               det_um       @ abs_mstr.abs__qad02.
            down with frame f_det.
/*nad001*/  put getTermLabel("ITEM_NUMBER",7) + ": " at 1 xxpart.

            /* DISPLAY *** Continue *** IF ITS A NEW PAGE */
            if page-size - line-counter < 1
            then do:
               page.
/*nad001                  {so05a02.i}*/
/*nad001*/                  {xxso05a02.i}
            end. /* IF PAGE-SIZE - LINE-COUNTER < 1 */
/*nad001
            display
               cum_qty @ det_qty .
*/
         end. /* IF v_tr_type = "ISS-SO" */
         else do with frame f_non_so_ship:

         /* SKIP TO NEW PAGE */
            if page-size - line-counter < 1
            then
               page.

            display
               disp_item
	       xxline
	       xxnbr
               shipper-po
               accum sub-total by det_line det_qty
                      @ l_nonso_det_qty
               det_um @ abs_mstr.abs__qad02.
            down with frame f_non_so_ship.
/*nad001*/  put getTermLabel("ITEM_NUMBER",7) + ": " at 1 xxpart.
         end. /* ELSE DO */

         if available cp_mstr
         and available pt_mstr
         then do:
            if disp_item          = cp_cust_partd
               and cp_cust_partd <> cp_cust_part
               or  cp_cust_part  =  pt_part
               and cp_cust_partd <> ""
            then do:
               /* DISPLAY *** Continue *** IF ITS A NEW PAGE */
               if page-size - line-counter < 1
               then do:
                  page.
/*nad001                  {so05a02.i}*/
/*nad001*/                  {xxso05a02.i}
               end. /* IF PAGE-SIZE - LINE-COUNTER < 1 */

               display
                  (getTermLabel("CUSTOMER_ITEM",16) + ": "
                   + sod_custpart) @ disp_item
                  with frame f_det.
               down 1 with frame f_det.

               /*IF THE CUSTOMER ITEM IS DIFFERENT THAN THE */
               /*CUSTOMER REF THEN DISPLAY THE CUST_REF     */
               if  ((available sod_det)
               and (sod_custref <> sod_custpart)
               and (sod_custref <> ""))
               then do:
                  /* DISPLAY *** Continue *** IF ITS A NEW PAGE */
                  if page-size - line-counter < 1
                  then do:
                     page.
/*nad001                  {so05a02.i}*/
/*nad001*/                  {xxso05a02.i}
                  end. /* IF PAGE-SIZE - LINE-COUNTER < 1 */

                  display
                     (getTermLabel("CUSTOMER_REFERENCE",15) + ": "
                      + sod_custref) @ disp_item
                     with frame f_det.
                  down 1 with frame f_det.
               end. /* IF AVAILABLE sod_det ... */

            end.  /* IF DISP_ITEM = CP_CUST_PARTD..... */
            if cp_cust_partd     <> pt_part
               and cp_cust_partd <> ""
               or  cp_cust_partd =  cp_cust_part
            then do:
               /* DISPLAY *** Continue *** IF ITS A NEW PAGE */
               if page-size - line-counter < 1
               then do:
                  page.
/*nad001                  {so05a02.i}*/
/*nad001*/                  {xxso05a02.i}
               end. /* IF PAGE-SIZE - LINE-COUNTER < 1 */

               display
                  (getTermLabel("ITEM_NUMBER",7) + ": "
                   + pt_part) @ disp_item
                  with frame f_det.
               down 1 with frame f_det.
            end. /* IF cp_cust_partd <> pt_part... */

            if disp_item         = sod_custpart
               and cp_cust_partd = ""
               and cp_cust_part  <> pt_part
            then do:
               /* DISPLAY *** Continue *** IF ITS A NEW PAGE */
               if page-size - line-counter < 1
               then do:
                  page.
/*nad001                  {so05a02.i}*/
/*nad001*/                  {xxso05a02.i}
               end. /* IF PAGE-SIZE - LINE-COUNTER < 1 */

               display
                  (getTermLabel("ITEM_NUMBER",7) + ": "
                   + pt_part ) @ disp_item
                  with frame f_det.
               down 1 with frame f_det.
            end. /* IF disp_item = sod_custpart... */

         end. /* IF AVAILABLE cp_mstr AND pt_mstr */
         else do:
            if  ((available sod_det)
            and (sod_custref <> ""))
            then do:
               /* DISPLAY *** Continue *** IF ITS A NEW PAGE */
               if page-size - line-counter < 1
               then do:
                  page.
/*nad001                  {so05a02.i}*/
/*nad001*/                  {xxso05a02.i}
               end. /* IF PAGE-SIZE - LINE-COUNTER < 1 */

               display
                  (getTermLabel("CUSTOMER_REFERENCE",15) + ": "
                   + sod_custref) @ disp_item
                  with frame f_det.
               down 1 with frame f_det.
            end. /* IF  ((AVAILABLE sod_det) AND (sod_custref <> ""))" */
         end. /* ELSE */

         if  ((available sod_det)
         and (sod_modelyr <> ""))
         then do:
            /* DISPLAY *** Continue *** IF ITS A NEW PAGE */
            if page-size - line-counter < 1
            then do:
               page.
/*nad001                  {so05a02.i}*/
/*nad001*/                  {xxso05a02.i}
            end. /* IF PAGE-SIZE - LINE-COUNTER < 1 */

            display
               (getTermLabel("MODEL_YEAR",15) + ": "
                + sod_modelyr) @ disp_item
               with frame f_det.
            down 1 with frame f_det.
         end. /* IF  ((AVAILABLE SOD_DET) AND (SOD_MODELYR <> ""))" */

         if  available cp_mstr
         and cp_cust_eco <> ""
         then do:
            /* DISPLAY *** Continue *** IF ITS A NEW PAGE */
            if page-size - line-counter < 1
            then do:
               page.
/*nad001                  {so05a02.i}*/
/*nad001*/                  {xxso05a02.i}
            end. /* IF PAGE-SIZE - LINE-COUNTER < 1 */

            display
               (getTermLabel("CUST_ITEM_ECO",15)
                + ": " + cp_cust_eco) @ disp_item
               with frame f_det.
            down 1 with frame f_det.
         end. /* IF available cp_mstr... */

         if v_tr_type = "ISS-SO"
         then do:
            display " " @ disp_item with frame f_det.
            down with frame f_det.
         end. /* IF v_tr_type = "ISS-SO" */

         else do:
            display
               " " @ disp_item
               with frame f_non_so_ship.
            down with frame f_non_so_ship.
         end. /* ELSE DO */

         /* PRINTING AUTHORIZATION NUMBER */
         for each t_absr_det by t_absr_reference:
            {&PAGEBREAK}

            /* DISPLAY *** Continue *** IF ITS A NEW PAGE */
            if page-size - line-counter < 1
            then do:
               page.
/*nad001                  {so05a02.i}*/
/*nad001*/                  {xxso05a02.i}
            end. /* IF PAGE-SIZE - LINE-COUNTER < 1 */

            display
               t_absr_reference
               t_absr_qty
               sod_um
            with frame auth.
            down with frame auth.
         end. /* END OF FOR EACH absr_det */

         /* DELETING THE WORKFILE */
         for each t_absr_det exclusive-lock:
            delete t_absr_det.
         end.

         {&SOFMSV01-P-TAG8}
         if i_print_sodet and v_tr_type = "ISS-SO"
         then do:

            {&SOFMSV01-P-TAG9}

            msgdesc = "".
            if substring(abs_status,2,1) <> "y"
            and not available sod_det
            then do:
               /* DOES NOT EXIST. CANNOT CONFIRM. */
               {pxmsg.i &MSGNUM=1868 &MSGBUFFER=msgdesc}
               msgdesc = getTermLabel("SALES_ORDER",15) + ": "
                       + det_order + " "
                       + getTermLabel("LINE",8) + ": "
                       + string(det_line,"x(4)")
                       + msgdesc.
            end.
            else do:
               if available sod_det then
                  msgdesc = getTermLabel("SALES_ORDER",15) + ": " +
                            sod_nbr +  " " +
                            getTermLabel("LINE",8) + ": " + string(sod_line).
               else
                  msgdesc = getTermLabel("SALES_ORDER",15) + ":" +
                            det_order +
                            " " +
                            getTermLabel("LINE",8) + ": " +
                            string(det_line,"x(4)").
            end.
            {&PAGEBREAK}
            /* DISPLAY *** Continue *** IF ITS A NEW PAGE */
            if page-size - line-counter < 1
            then do:
               page.
/*nad001                  {so05a02.i}*/
/*nad001*/                  {xxso05a02.i}
            end. /* IF PAGE-SIZE - LINE-COUNTER < 1 */
/*nad001*            put msgdesc at 3 skip(1).*/
         end. /* IF i_print_sodet */

         /* PRINT LOT/SERIAL DETAILS FOR REGULAR, MEMO AND ATO ITEMS */
         if i_print_lotserials
         then do:

            for each work_abs_mstr
            exclusive-lock
               where work_abs_mstr.abs_order = det_order
                 and work_abs_mstr.abs_item  = disp_item
                 and work_abs_mstr.abs_line  = string(det_line)
                 and not work_abs_mstr.abs_par_id begins "I"
                 and work_abs_mstr.abs_par_id <> ""
            break by work_abs_mstr.abs_order
                  by work_abs_mstr.abs_item
                  by work_abs_mstr.abs_line
                  by work_abs_mstr.abs_lotser
                  by work_abs_mstr.abs_ref :


               for first ld_det
                  fields(ld_expire ld_loc ld_lot ld_part
                         ld_ref ld_site)
                  where ld_part = work_abs_mstr.abs_item
                    and ld_site = work_abs_mstr.abs_site
                    and ld_loc  = work_abs_mstr.abs_loc
                    and ld_lot  = work_abs_mstr.abs_lotser
                    and ld_ref  = work_abs_mstr.abs_ref
               no-lock:
               end. /* FOR FIRST ld_det */

               l_ld_expire =
                            if available ld_det
                            then
                               ld_expire
                            else
                               ?.
               /* DISPLAY *** Continue *** IF ITS A NEW PAGE */
               if page-size - line-counter < 1
               then do:
                  page.
/*nad001                  {so05a02.i}*/
/*nad001*/                  {xxso05a02.i}

                  put skip(1)
                      l_lot-lbl    at 5
                      l_qty-lbl    at 32
                      l_expire-lbl at 50
                      l_ref-lbl    at 60
                      skip(1).

                  /* SET l_printed = yes TO AVOID RE-PRINTING OF LABELS */
                  /* WHEN first-of(work_abs_mstr.abs_line ON A NEW PAGE */

                  l_printed = yes.
               end. /* IF PAGE-SIZE - LINE-COUNTER < 1 */

               if first-of(work_abs_mstr.abs_line) and l_printed = no
               then
                  put l_lot-lbl    at 5
                      l_qty-lbl    at 32
                      l_expire-lbl at 50
                      l_ref-lbl    at 60
                      skip(1).

               /* DISPLAY *** Continue *** IF ITS A NEW PAGE */
               if page-size - line-counter < 1
               then do:
                  page.
/*nad001                  {so05a02.i}*/
/*nad001*/                  {xxso05a02.i}
                  put skip(1).
               end. /* IF PAGE-SIZE - LINE-COUNTER < 1 */

               /* PUT STATEMENT RETAINED INSTEAD OF DISPLAY BECAUSE */
               /* THE SCOPE OF f_det FRAME IS LOST AND IT RESULTS   */
               /* IN MULTIPLE LOT LABELS ON A SINGLE PAGE           */
               put
                  work_abs_mstr.abs_lotser at 5
                  work_abs_mstr.abs_qty    at 32 format "->>>>>>9.9<<<<<<"
                  l_ld_expire              at 50
                  work_abs_mstr.abs_ref    at 60.

               l_printed = no.

               if last-of(work_abs_mstr.abs_line)
               then
                  put skip(1).
               delete work_abs_mstr.
            end. /* FOR EACH work_abs_mstr */
         end. /* IF i_print_lotserials  */

         /* PRINT FEATURES AND OPTIONS FOR ASSEMBLE-TO-ORDER ITEMS */
         {&SOFMSV01-P-TAG10}

         if i_features            and
            v_tr_type = "ISS-SO"  and
            available sod_det     and
            sod_cfg_type = "1"
         then do:

            {&SOFMSV01-P-TAG11}
            find first sob_det no-lock where
               sob_nbr  = sod_nbr and
               sob_line = sod_line no-error.

            if available sob_det then do:
               {gprun.i ""sopkg01a.p"" "("""", 0, sod_nbr, sod_line)" }
            end.

         end.  /* IF i_features */

         /* PRINT COMPONENTS */

         for each t_abs_comp no-lock where
            comp_shipfrom = det_shipfrom and
            comp_order    = det_order    and
            comp_line     = det_line
         break by comp_shipfrom:

            find pt_mstr no-lock where pt_part = comp_item no-error.
            {&PAGEBREAK}

            /* DISPLAY *** Continue *** IF ITS A NEW PAGE */
            if /* v_tr_type = "ISS-SO" and */
            page-size - line-counter < 1
            then do:
               page.
/*nad001                  {so05a02.i}*/
/*nad001*/                  {xxso05a02.i}
            end. /* IF PAGE-SIZE - LINE-COUNTER < 1 */

            put
               comp_item at 18
               comp_qty  format "->>>>>>>9.9<<<<<" at 54 " "
               if available pt_mstr
               then
                  pt_um else "" .

            if available pt_mstr
            and pt_desc1 <> ""
            then do:
               {&PAGEBREAK}

            /* DISPLAY *** Continue *** IF ITS A NEW PAGE */
               if /* v_tr_type = "ISS-SO" and */
               page-size - line-counter < 1
               then do:
                  page.
/*nad001                  {so05a02.i}*/
/*nad001*/                  {xxso05a02.i}
               end. /* IF PAGE-SIZE - LINE-COUNTER < 1 */

               put pt_desc1 at 20 skip.
            end. /* IF AVAILABLE pt_mstr... */

            if available pt_mstr
            and pt_desc2 <> ""
            then do:
               {&PAGEBREAK}

               /* DISPLAY *** Continue *** IF ITS A NEW PAGE */
               if v_tr_type = "ISS-SO"  and
               page-size - line-counter < 1
               then do:
                  page.
/*nad001                  {so05a02.i}*/
/*nad001*/                  {xxso05a02.i}
               end. /* IF PAGE-SIZE - LINE-COUNTER < 1 */

                  put pt_desc2 at 20 skip.
            end. /* IF AVAILABLE pt_mstr... */

            if last(comp_shipfrom)
            then
               put skip (1).

            for each work_abs_mstr
               fields(abs_item   abs_line  abs_loc
                      abs_lotser abs_order abs_par_id
                      abs_qty    abs_ref   abs_site)
               where work_abs_mstr.abs_order = det_order
               and   work_abs_mstr.abs_item  = comp_item
               and   work_abs_mstr.abs_line  = string(det_line)
               no-lock
               break by work_abs_mstr.abs_order
                     by work_abs_mstr.abs_item
                     by work_abs_mstr.abs_line
                     by work_abs_mstr.abs_lotser
                     by work_abs_mstr.abs_ref:

               for first ld_det
                  fields(ld_expire ld_loc ld_lot
                         ld_part   ld_ref ld_site)
                  where ld_part = work_abs_mstr.abs_item
                  and   ld_site = work_abs_mstr.abs_site
                  and   ld_loc  = work_abs_mstr.abs_loc
                  and   ld_lot  = work_abs_mstr.abs_lotser
                  and   ld_ref  = work_abs_mstr.abs_ref
                  no-lock:
               end. /* FOR FIRST ld_det */

               l_ld_expire = if available ld_det
                             then
                                ld_expire
                             else
                                ?.

              /* DISPLAY *** Continue *** IF ITS A NEW PAGE */
              if page-size - line-counter < 1
              then do:
                 page.
/*nad001                  {so05a02.i}*/
/*nad001*/                  {xxso05a02.i}
                 put skip(1).

                  put l_lot-lbl    at 5
                      l_qty-lbl    at 32
                      l_expire-lbl at 50
                      l_ref-lbl    at 60
                      skip(1).

              /* SET FLAG TO YES TO AVOID RE-PRINT OF LOT LABELS */
              /* WHEN first-of(work_abs_mstr.abs_line).          */

              l_printed = yes.

              end. /* IF PAGE-SIZE - LINE-COUNTER < 1 */

              /* l_printed CONTROLS THE LOT/SERIAL LABELS PRINTING */
               if first-of(work_abs_mstr.abs_line) and l_printed = no
               then
                  /* CHANGED DISPLAY TO PUT, TO AVOID PRINTING OF EXTRA */
                  /* BLANK LINES AFTER THE LABELS ARE PRINTED.          */
                  put
                     l_lot-lbl    at 5
                     l_qty-lbl    at 32
                     l_expire-lbl at 50
                     l_ref-lbl    at 60
                     skip(1).

              /* DISPLAY *** Continue *** IF ITS A NEW PAGE */
              if page-size - line-counter < 1
              then do:
                 page.
/*nad001                  {so05a02.i}*/
/*nad001*/                  {xxso05a02.i}
                 put skip(1).
              end. /* IF page-size - line-counter < 1 */


              /* CHANGED DISPLAY TO PUT, TO AVOID PRINTING OF BLANK */
              /* LINES BETWEEN THE LOT/SERIAL DATA.                 */
              put
                 work_abs_mstr.abs_lotser at 5
                 work_abs_mstr.abs_qty    at 32
                             format "->>>>>>9.9<<<<<<"
                 l_ld_expire              at 50
                 work_abs_mstr.abs_ref    at 60.

             l_printed = no.

               if last-of(work_abs_mstr.abs_line)
               then
                  put skip(1).
            end. /* FOR EACH work_abs_mstr */

         end.  /* FOR EACH t_abs_comp */

         /* PRINT SHIPPER LINE ITEM COMMENTS */
         if i_ship_comments then
         do cmt_ctr = 1 to num-entries(cmtindx_cdl):
            if integer(entry(cmt_ctr,cmtindx_cdl)) > 0
            then do:
               /* INTRODUCED so05a02.i FOR DISPLAYING 'Continue' MESSAGE */
               /* WITH LINE ITEM IN FRAME f_det.                         */
                  {gpcmtprt.i &type=SH
                     &id=integer(entry(cmt_ctr,cmtindx_cdl)) &pos=3
                     &command="~{xxso05a02.i~}"}
                   put skip(1).

            end.  /* IF INTEGER(ENTRY(cmt_ctr,cmtindx_cdl)) > 0 */
         end.  /* DO cmt_ctr = 1 ... */
         cmtindx_cdl = "".

         /* PRINT PACKING LIST COMMENTS */
         {&SOFMSV01-P-TAG12}

         if i_pack_comments and v_tr_type = "ISS-SO"
         then do:

            {&SOFMSV01-P-TAG13}
            if available sod_det and sod_cmtindx > 0
            then do:

               /* DISPLAY *** Continue *** IF ITS A NEW PAGE */
               if page-size - line-counter < 1
               then do:
                  page.
/*nad001                  {so05a02.i}*/
/*nad001*/                  {xxso05a02.i}
               end. /* IF PAGE-SIZE - LINE-COUNTER < 1 */

               /* INTRODUCED so05a02.i FOR DISPLAYING 'Continue' MESSAGE */
               /* WITH LINE ITEM IN FRAME f_det.                         */
               {gpcmtprt.i &type=PA
                  &id=sod_cmtindx &pos=3
                  &command="~{xxso05a02.i~}"}
            end. /* IF AVAILABLE sod_det ... */
            if not available sod_det
            and available idh_hist and idh_cmtindx > 0
            then do:

               /* DISPLAY *** Continue *** IF ITS A NEW PAGE */
               if page-size - line-counter < 1
               then do:
                  page.
/*nad001                  {so05a02.i}*/
/*nad001*/                  {xxso05a02.i}
               end. /* IF PAGE-SIZE - LINE-COUNTER < 1 */

               /* INTRODUCED so05a02.i FOR DISPLAYING 'Continue' MESSAGE */
               /* WITH LINE ITEM IN FRAME f_det.                         */
               {gpcmtprt.i &type=PA
                  &id=idh_cmtindx &pos=3
                  &command="~{xxso05a02.i~}"}
            end. /* IF NOT AVAILABLE sod_det ... */

         end. /* IF i_pack_comments ... */
      end. /* IF LAST-OF det_line */

      {mfrpchk.i &warn=false}

      /* PRINT CONTAINER/LINE CHARGES LINE LEVEL USER FIELDS */
      if using_container_charges or using_line_charges then do:

         for each absd_det no-lock where
                  absd_abs_id = det_id  and
                  absd_shipfrom = abs_mstr.abs_shipfrom
         break by absd_abs_id:

            display
               absd_fld_seq   @ v_absd_fld_seq
               absd_fld_name  @ v_absd_fld_name
               absd_fld_value @ v_absd_fld_value
            with frame absd_user_fields.

            down 1 with frame absd_user_fields.

            if last-of(absd_abs_id) then
               down 2 with frame absd_user_fields.

         end. /* FOR EACH absd_det */

      end. /* IF using_container or using_line_charges */

   end. /* FOR EACH t_abs_det */

   /* PRINT SEQUENCES AND A SEPARATE SEQUENCE PACKING LIST */
   if using_seq_schedules
   then do:

      for first rcf_ctrl
      no-lock: end.

      for first rcc_mstr where rcc_addr = so_ship
      no-lock: end.

      /* CHECK TO MAKE SURE WE'RE AT THE */
      /* PRE-SHIPPER OR SHIPPER LEVEL.   */
      if abs_mstr.abs_id begins "p"
      or abs_mstr.abs_id begins "s"
      then do:

         /* DETERMINE IF SEQ. RANGE SHOULD BE PRINTED */
         if available rcc_mstr
         and rcc_shipper_print
         or (not available rcc_mstr and
             available rcf_ctrl and rcf_shipper_print)
         then do:

            /*GET SEQUENCE SCHEDULE DATA*/
            {gprunmo.i
               &program = ""rcsqprt.p""
               &module = "ASQ"
               &param = """(input i_abs_recid,
                            input '')"""}

            /* PRINTING CUSTOMER SEQUENCE RANGE */
            for each t_abss_det
            break by t_abss_ship_id
                  by t_abss_from_cust_job:

               {&PAGEBREAK}
               if first-of(t_abss_ship_id)
               then
                 put {gplblfmt.i &FUNC=getTermLabel(""SEQUENCE_RANGES"",18)}
                    at 25.
               if first-of(t_abss_from_cust_job) and
                  t_abss_from_cust_job <> ""
               then
                 put {gplblfmt.i &FUNC=getTermLabel(""CUSTOMER_JOB"",15)
                                 &CONCAT = "': '"}
                    at 5 t_abss_from_cust_job.
               display
                  t_abss_from_cust_seq
                  t_abss_to_cust_seq
               with frame sequence2.

               down with frame sequence2.

            end. /* END OF FOR EACH abss_det */

            /* DELETING THE WORKFILE */
            for each t_abss_det exclusive-lock:
               delete t_abss_det.
            end.

         end.  /* AVAILABLE rcc_mstr OR rcf_ctrl */

         /*PRINT SEQUENCE LIST */

         sequence_list = getTermLabel("BANNER_SEQUENCE_PACKING_LIST",35)
                       + " ".
         {gprunmo.i
            &program = ""sosob2.p""
            &module = "ASQ"
            &param = """(input i_abs_recid,
                         input-output v_start_page)"""}
         sequence_list = "".

      end.  /* IF abs_id BEGINS "p" ... */

   end. /* IF ENABLE SEQUENCED SCHEDULES */

   /* PRINT WEIGHT SUMMARY */
   assign
      l_par_shipfrom = abs_mstr.abs_shipfrom
      l_par_id       = abs_mstr.abs_id.

   /* CREATED INTERNAL PROCEDURE P-GET-PARENT-WT-UM TO GET THE */
   /* PARENT WEIGHT UM                                         */

   run p-get-parent-wt-um
      (input recid(abs_mstr),
       output l_parent_tare_wt,
       output l_first_part_um) .

   assign
      l_tare_wt2 =  l_tare_wt2  + l_parent_tare_wt
      l_gross_wt2 = l_gross_wt2 + l_parent_tare_wt .

   for each b_abs_mstr
      fields(abs_cmtindx abs_gwt abs_id abs_item abs_line abs_nwt abs_vol 
             abs_order abs_par_id abs_qty abs_shipfrom abs_shipto
             abs_ship_qty abs_shp_date abs_status abs_trl_cmtindx
             abs_wt_um abs__qad01 abs__qad02 abs__qad03 abs__qad10)
      no-lock
      where abs_shipfrom = l_par_shipfrom and
            abs_par_id   = l_par_id,
      each pt_mstr
         fields(pt_desc1 pt_desc2 pt_part pt_um pt_drwg_loc) no-lock
         where pt_part = abs_item
   break by pt_part with frame frm_part:

      setFrameLabels(frame frm_part:handle).

      assign
         l_abs_twt = abs_gwt - abs_nwt
         l_tare_wt = l_abs_twt.

      if first-of(pt_part) then
         l_part_um = abs_wt_um.

      if l_part_um <> abs_wt_um
      then do:
         {gprun.i ""gpumcnv.p""
            "(l_part_um,
              abs_wt_um,
              """",
              output l_conv)" }

         if l_conv = ? then
            l_conv = 1.

         assign
            l_qty       = l_qty       + abs_qty
            l_net_wt1   = l_net_wt1   + abs_nwt / l_conv
            meas = meas + abs_vol / l_conv
	    l_gross_wt1 = l_gross_wt1 + abs_gwt / l_conv
            l_tare_wt1  = l_tare_wt1  + l_tare_wt / l_conv.
      end. /* IF l_part_um <> abs_wt_um THEN */
      else
      assign
         l_qty       = l_qty       + abs_qty
         l_net_wt1   = l_net_wt1   + abs_nwt
	 meas = meas + abs_vol
         l_tare_wt1  = l_tare_wt1  + l_tare_wt
         l_gross_wt1 = l_gross_wt1 + abs_gwt.

      if l_first_part_um <> abs_wt_um
      then do:
         {gprun.i ""gpumcnv.p""
            "(l_first_part_um,
              abs_wt_um,
              """",
              output l_conv)" }

         if l_conv = ? then
            l_conv = 1.

         assign
            l_net_wt2   = l_net_wt2   + abs_nwt / l_conv
            meas2 = meas2 + abs_vol / l_conv
	    l_gross_wt2 = l_gross_wt2 + abs_gwt / l_conv
            l_tare_wt2  = l_tare_wt2  + l_tare_wt / l_conv.

      end. /* IF l_first_part_um <> abs_wt_um */

      else
         assign
            l_net_wt2   = l_net_wt2   + abs_nwt
            meas2 = meas2 + abs_vol
	    l_gross_wt2 = l_gross_wt2 + abs_gwt
            l_tare_wt2  = l_tare_wt2  + l_tare_wt.

/*nad002**********************************/
       if pt_drwg_loc <> "" then drwg_loc = decimal(pt_drwg_loc).
       if drwg_loc <> 0 then drwg_loc2 = integer(l_qty / drwg_loc + 0.4).
/*****************************************/
    /*nad002  if last-of(pt_part)
      then do:
*/
         display
            pt_desc1
            l_qty @ abs_qty
               column-label "Quantity" format "->>>>>>9.9"
	     drwg_loc 
             drwg_loc2
            l_net_wt1 @ abs_nwt
               column-label "   Net!Weight! (KG)" format "->>>>>>9.9"
/*nad001            l_tare_wt1 @ l_tare_wt
               column-label "Tare!Weight" format "->>>>>>9.9"*/
            l_gross_wt1 @ abs_gwt
               column-label " Gross!Weight! (KG)" format "->>>>>>9.9"
/*nad001*/  meas @ meas column-label "Measurement!   (CBM)" format "->>>>>>9.9"	       
/*            l_part_um @ abs_wt_um*/
         with width 100 /*80*/
         title color normal (getFrameTitle("SHIPMENT_WEIGHT_SUMMARY",33)).

         assign
            l_qty       = 0
            l_net_wt1   = 0
	    meas = 0
	    drwg_loc = 0
	    drwg_loc2 = 0
            l_tare_wt1  = 0
            l_gross_wt1 = 0.
/*nad002      end. /* IF LAST-OF(PT_PART) */*/

      if last(pt_part)
      then do:

        if l_parent_tare_wt > 0
         then do:
/*nad001            down.
            display
               "Parent  level Tare Wt" @ pt_desc1
               l_parent_tare_wt @ l_tare_wt   format "->>>>>>9.9<<"
/*nad001*/  meas @ meas format "->>>>>>9.9"	       
/*nad001               l_parent_tare_wt @ abs_gwt     format "->>>>>>9.9<<"
               l_first_part_um  @ abs_wt_um*/ . */
         end. /* IF l_parent_tare_wt > 0 */


         down 1.
         underline /*l_net_wt1 l_gross_wt1*/ abs_nwt /*nad001 l_tare_wt*/ abs_gwt meas.
         down 1.

         display
            l_net_wt2 @ abs_nwt
               column-label "   Net!Weight! (KG)" format "->>>>>>9.9<<"
/*nad001            l_tare_wt2 @ l_tare_wt
               column-label "Tare!Weight" format "->>>>>>9.9<<"*/
            l_gross_wt2 @ abs_gwt
               column-label " Gross!Weight! (KG)" format "->>>>>>9.9<<"
/*nad001*/  meas2 @ meas column-label "Measurement!   (CBM)" format "->>>>>>9.9"	       
/*            l_first_part_um @ abs_wt_um*/
         with width 100
         title color normal (getFrameTitle("SHIPMENT_WEIGHT_SUMMARY",33)).

      end. /* IF LAST(PT_PART) */
   end. /* FOR EACH b_abs_mstr */

   /* PRINT CARRIER INFORMATION */
   {gprun.i ""rcrpcar.p"" "(abs_mstr.abs_id, 1)"}

/*nad001********************************************/
   if abs_cmtindx > 0 and i_ship_comments
   then do:
      {gpcmtprt.i &type=SH &id=abs_cmtindx &pos=3}
      put skip(1).
   end.
                  /* ss - 120611.1 -b
                  	if page-size - line-counter < 9 then page.
                  	do while page-size - line-counter > 9:
                  	   put skip(1).
                  	end.
                  	ss - 120611.1 -e */
               /* ss - 120611.1 -b */
                  	if page-size - line-counter < 2 then page.
                  	do while page-size - line-counter > 2:
                  	   put skip(1).
                  	end.
                  /*	ss - 120611.1 -e */

/* ss - 120611.1 -b
   put skip(1).
   put "Received the above items in" at 50.
   put "FOR AND ON BEHALF OF:" at 2.
   put "good condition" at 50.
   put county2 at 2  .
   put "品质数量无误 请签收及盖章" at 50.
   put skip(3).
   put "____________________________" at 2.
   put "________________________________" at 50.
   put "AUTHORIED SIGNATURE"  at 2.
   put "AUTHORIED SIGNATURE"  at 50.
ss - 120611.1 -e */
 
/* ss - 120611.1 -b */
   
   put "____________________________" at 2.
   put "________________________________" at 50.
   put county2  at 2.
   put "品质数量无误 请签收及盖章"  at 50.

/* ss - 120611.1 -e */
/*nad001********************************************/


   /* PRINT TRAILER COMMENTS */
   if i_ship_comments
   and abs_trl_cmtindx > 0
   then do:
      {gpcmtprt.i &type=SH &id=abs_trl_cmtindx &pos=3}
      put skip(1).
   end.

   page.
   hide frame f_formhdr.

END PROCEDURE.  /* sh_print */

/* END OF PRINT SERVICE */

/*****************************************************************************/

/* Procedure sh_rename added */

/* RENAME SERVICE */

/*         /* Remove comments to enable this service */
*
*         /* NOTE:  This service is required whenever additional data is */
*         /* stored in any table other than abs_mstr, and is indexed by the */
*         /* abs_id field of the shipper record. */
*
*
*         procedure sh_rename:
*
*            /* When the key field abs_id of abs_mstr changes, this service */
*            /* changes the appropriate data in any additional information */
*            /* records. */
*
*            /* INPUT PARAMETERS */
*            define input parameter i_abs_recid as recid no-undo.
*            define input parameter i_abs_id like abs_id no-undo.
*
*            /* LOCAL VARIABLES */
*            define variable v_shipfrom like abs_shipfrom no-undo.
*            define variable v_id       like abs_id       no-undo.
*
*
*            /* PROCEDURE BODY */
*
*            /* Find the shipper record with which this data is associated. */
*            /* If it's not available, there's nothing to do, so leave. */
*
*            find abs_mstr no-lock where recid(abs_mstr) = i_abs_recid
*               no-error.
*            if not available abs_mstr then return.
*
*            assign
*               v_shipfrom = abs_shipfrom
*               v_id       = abs_id.
*
*            /* Update header data record, if any  */
*            {gprun.i
*               ""gpqwren.p""
*               "({&PROC-NAME},
*                 {&HDR-PREFIX} + v_shipfrom + {&DELIMITER} + v_id,
*                  {&PROC-NAME},
*                 {&HDR-PREFIX} + v_shipfrom + {&DELIMITER} + i_abs_id)" }
*
*            /* Update line item data record, if any  */
*            {gprun.i
*               ""gpqwren.p""
*               "({&PROC-NAME},
*                 {&ITM-PREFIX} + v_shipfrom + {&DELIMITER} + v_id,
*                  {&PROC-NAME},
*                 {&ITM-PREFIX} + v_shipfrom + {&DELIMITER} + i_abs_id)" }
*
*            /* Update trailer data record, if any */
*            {gprun.i
*               ""gpqwren.p""
*               "({&PROC-NAME},
*                 {&TRL-PREFIX} + v_shipfrom + {&DELIMITER} + v_id,
*                  {&PROC-NAME},
*                 {&TRL-PREFIX} + v_shipfrom + {&DELIMITER} + i_abs_id)" }
*
*         end procedure.  /* sh_rename */
*/
/* END OF RENAME SERVICE */

/*****************************************************************************/

/* ARCHIVE SERVICE */

/*         /* Remove comments to enable this service */
*
*         /* NOTE:  Although not required, this service is recommended */
*         /* whenever additional data is stored in any table other than */
*         /* abs_mstr */
*
*
*         procedure sh_archive:
*
*            /* Archives additional header, line item, and trailer data */
*            /* associated with a shipper header or detail record, and all */
*            /* of its descendant records */
*
*            /* INPUT PARAMETERS */
*            define input parameter i_abs_recid as recid     no-undo.
*            define input parameter i_filename  as character no-undo.
*
*            /* LOCAL VARIABLES */
*            define variable v_shipfrom like abs_shipfrom no-undo.
*            define variable v_id       like abs_id       no-undo.
*
*
*            /* PROCEDURE BODY */
*
*            /* Find the shipper record with which this data is associated. */
*            /* If it's not available, there's nothing to do, so leave. */
*
*            find abs_mstr no-lock where recid(abs_mstr) = i_abs_recid
*               no-error.
*            if not available abs_mstr then return.
*
*            assign
*               v_shipfrom = abs_shipfrom
*               v_id       = abs_id.
*
*            /* Archive info for descendant records */
*            for each abs_mstr no-lock where
*               abs_shipfrom = v_shipfrom and
*               abs_par_id   = v_id:
*
*               run sh_archive (recid(abs_mstr), i_filename).
*
*            end.  /* for each abs_mstr */
*
*            /* Archive additional header data, if any */
*            run
*               supp_archive_qad_wkfl (
*                  {&PROC-NAME},
*                  {&HDR-PREFIX} + v_shipfrom + {&DELIMITER} + v_id,
*                  i_filename ).
*
*            /* Archive additional line item data, if any */
*            run
*               supp_archive_qad_wkfl (
*                  {&PROC-NAME},
*                  {&ITM-PREFIX} + v_shipfrom + {&DELIMITER} + v_id,
*                  i_filename ).
*
*            /* Archive additional trailer data, if any */
*            run
*               supp_archive_qad_wkfl (
*                  {&PROC-NAME},
*                  {&TRL-PREFIX} + v_shipfrom + {&DELIMITER} + v_id,
*                  i_filename ).
*
*         end procedure.  /* sh_archive */
*/
/* END OF ARCHIVE SERVICE */

/*****************************************************************************/

/* DELETE SERVICE */

/*         /* Remove comments to enable this service */
*
*         /* NOTE:  This service is required whenever additional data is */
*         /* stored in any table other than abs_mstr */
*
*
*         procedure sh_delete:
*
*            /* Deletes additional header, line item, and trailer data */
*            /* associated with a shipper header or detail record, and */
*            /* all of its descendant records */
*
*            /* INPUT PARAMETERS */
*            define input parameter i_abs_recid as recid no-undo.
*
*            /* LOCAL VARIABLES */
*            define variable v_shipfrom like abs_shipfrom no-undo.
*            define variable v_id       like abs_id       no-undo.
*
*            /* BUFFERS */
*    define buffer   b_abs_mstr for  abs_mstr.
*
*   /* Replaced all references to abs_mstr to b_abs_mstr */
*
*
*            /* PROCEDURE BODY */
*
*            /* Find the shipper record with which this data is associated. */
*            /* If it's not available, there's nothing to do, so leave. */
*
*            find b_abs_mstr no-lock where recid(b_abs_mstr) = i_abs_recid
*                 no-error.
*            if not available b_abs_mstr then return.
*
*            assign
*               v_shipfrom = b_abs_mstr.abs_shipfrom
*               v_id       = b_abs_mstr.abs_id.
*
*            /* Delete info for descendant records */
*            for each b_abs_mstr no-lock where
*               abs_shipfrom = v_shipfrom and
*               abs_par_id   = v_id:
*
*               run sh_delete (recid(b_abs_mstr)).
*
*            end.  /* for each b_abs_mstr */
*
*            /* Delete additional header data, if any */
*            {gprun.i
*               ""gpqwdel.p""
*               "({&PROC-NAME},
*                 {&HDR-PREFIX} + v_shipfrom + {&DELIMITER} + v_id )" }
*
*            /* Delete additional line item data, if any */
*            {gprun.i
*               ""gpqwdel.p""
*               "({&PROC-NAME},
*                 {&ITM-PREFIX} + v_shipfrom + {&DELIMITER} + v_id )" }
*
*            /* Delete additional trailer data, if any */
*            {gprun.i
*               ""gpqwdel.p""
*               "({&PROC-NAME},
*                 {&TRL-PREFIX} + v_shipfrom + {&DELIMITER} + v_id )" }
*
*         end procedure.  /* sh_delete */
*/
/* END OF DELETE SERVICE */

/*****************************************************************************/

/* INTERNAL SUPPORT ROUTINES */

/* Each of the following routines supports one or more of the above */
/* service routines.  They should NEVER be invoked from outside of */
/* the service encapsulation procedure. */

/***************************************************************/

PROCEDURE supp_load_qad_wkfl:

   /* READ ADDITIONAL SHIPPER HEADER, LINE ITEM, OR TRAILER DATA */
   /* STORED IN A qad_wkfl RECORD AND LOAD INTO LOCAL VARIABLES */

   /* INPUT PARAMETERS */
   define input parameter i_key1 like qad_key1 no-undo.
   define input parameter i_key2 like qad_key2 no-undo.

   /* OUTPUT PARAMETERS */
   define output parameter o_char as character no-undo.
   define output parameter o_int  as integer   no-undo.
   define output parameter o_dec  as decimal   no-undo.

   define output parameter o_log  like  mfc_logical   no-undo.
   define output parameter o_date as date      no-undo.

   /* PROCEDURE BODY */

   find first qad_wkfl where
      qad_key1 = i_key1 and
      qad_key2 = i_key2
   no-lock no-error.

   if available qad_wkfl then
      assign
         o_char = qad_charfld[1]
         o_int  = integer(qad_decfld[1])
         o_dec  = qad_decfld[2]
         o_log  = qad_charfld[2] = "Y"
         o_date = qad_datefld[1].
   else
      assign
         o_char = ""
         o_int  = 0
         o_dec  = 0
         o_log  = false
         o_date = ?.

END PROCEDURE.  /* supp_load_qad_wkfl */

/***************************************************************/

PROCEDURE supp_save_qad_wkfl:

   /* SAVE ADDITIONAL SHIPPER HEADER, LINE ITEM, */
   /* OR TRAILER DATA TO A qad_wkfl RECORD */

   /* INPUT PARAMETERS */
   define input parameter i_key1 like qad_key1  no-undo.
   define input parameter i_key2 like qad_key2  no-undo.
   define input parameter i_char as   character no-undo.
   define input parameter i_int  as   integer   no-undo.
   define input parameter i_dec  as   decimal   no-undo.
   define input parameter i_log  as   logical   no-undo.
   define input parameter i_date as   date      no-undo.

   /* PROCEDURE BODY */

   /* CREATE OR UPDATE A qad_wkfl RECORD.  THIS IS DONE IN A */
   /* SEPARATE ROUTINE, SINCE NO DB UPDATES ARE ALLOWED IN A */
   /* SERVICE ENCAPSULATION PROCEDURE. */

   {gprun.i ""gpqwup.p""
       "(i_key1,
        i_key2,
        '',
        '',
        '',
        '',
        i_char,
        if i_log
        then 'Y' else 'N',
        '',
        '',
        '',
        '',
        '',
        '',
        '',
        '',
        '',
        '',
        '',
        '',
        '',
        decimal(i_int),
        i_dec,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        i_date,
        ?,
        ?,
        ?,
        '',
        '',
        '' )" }

END PROCEDURE.  /* supp_save_qad_wkfl */

/***************************************************************/

PROCEDURE supp_build_det:

   /* Build temp table of exploded details for this shipper */

   /* INPUT PARAMETERS */
   define input parameter i_abs_recid    as  recid     no-undo.

   /* LOCAL VARIABLES */
   define variable        v_abs_shipfrom as  character no-undo.
   define variable        v_abs_id       as  character no-undo.

   /* BUFFERS */
   define buffer          b_abs_mstr     for abs_mstr.

   /* PROCEDURE BODY */

   do for b_abs_mstr:

      find b_abs_mstr where recid(b_abs_mstr) = i_abs_recid
      no-lock no-error.

      if not available b_abs_mstr
      then return.

      if abs_id begins "i"
      then do:

         find first pt_mstr where pt_part = abs_item no-lock no-error.

         create t_abs_det.
         assign
            det_item     = abs_item
            det_order    = abs_order
            det_line     = abs_line
            det_qty      = abs_qty
            det_ship_qty = abs_ship_qty
            det_um       = abs__qad02
            det_conv     = abs__qad03
            det_cmtindx  = abs_cmtindx
            det_id       = abs_id
            det_shipfrom = abs_shipfrom.

      end.  /* IF abs_id begins "i" */

      else do:

         assign
            v_abs_shipfrom = abs_shipfrom
            v_abs_id       = abs_id.

         for each b_abs_mstr where
            abs_shipfrom = v_abs_shipfrom and
            abs_par_id   = v_abs_id
         no-lock:
            run supp_build_det (recid(b_abs_mstr)).
         end.  /* FOR EACH b_abs_mstr */
      end.  /* ELSE */
   end.  /* DO FOR b_abs_mstr */

END PROCEDURE.  /* supp_build_det */

/***************************************************************/

PROCEDURE supp_build_comp:

   /* ADD/UPDATE WORKFILE ENTRIES FOR KIT ITEM COMPONENT QUANTITIES */

   /* INPUT PARAMETERS */
   define input parameter i_abs_shipfrom like abs_mstr.abs_shipfrom no-undo.
   define input parameter i_abs_id       like abs_mstr.abs_id       no-undo.
   define input parameter i_abs_order    like abs_mstr.abs_order    no-undo.
   define input parameter i_abs_line     like abs_mstr.abs_line     no-undo.

   /* BUFFERS */
   define buffer          b_abs_mstr     for  abs_mstr.

   /* PROCEDURE BODY */

   for each b_abs_mstr no-lock where
      abs_shipfrom = i_abs_shipfrom and
      abs_par_id   = i_abs_id       and
      abs_order    = i_abs_order    and
      abs_line     = i_abs_line:

      find t_abs_comp exclusive-lock where
         comp_item     = abs_item     and
         comp_shipfrom = abs_shipfrom and
         comp_order    = abs_order    and
         comp_line     = abs_line no-error.

      if not available t_abs_comp
      then do:

         create t_abs_comp.
         assign
            comp_item     = abs_item
            comp_shipfrom = abs_shipfrom
            comp_order    = abs_order
            comp_line     = abs_line
            comp_qty      = 0.

      end.  /* IF NOT AVAILABLE */

      comp_qty = comp_qty + abs_qty.

   end.    /* FOR EACH b_abs_mstr */

END PROCEDURE.  /* supp_build_comp */

/***************************************************************/

PROCEDURE supp_archive_qad_wkfl:

   /* Read and archive a qad_wkfl record */

   /* INPUT PARAMETERS */
   define input parameter i_key1      like qad_key1  no-undo.
   define input parameter i_key2      like qad_key2  no-undo.
   define input parameter i_filename  as   character no-undo.

   /* PROCEDURE BODY */

   find first qad_wkfl no-lock where
      qad_key1 = i_key1 and
      qad_key2 = i_key2
      no-error.

   if available qad_wkfl
   then do:
      output stream s_history to value(i_filename) append.
      export stream s_history "qad_wkfl".
      export stream s_history qad_wkfl.
      output stream s_history close.
   end.

END PROCEDURE.  /* supp_archive_qad_wkfl */

/***************************************************************/
/* < Add additional required internal support routines here > */
/***************************************************************/

/* END OF INTERNAL SUPPORT ROUTINES */

PROCEDURE p-get-parent-wt-um:
   define input  parameter l_recid          as   recid      no-undo.
   define output parameter l_parent_tare_wt like abs_nwt    no-undo.
   define output parameter l_first_part_um  like abs_wt_um  no-undo.

   define variable l_par_recid     as recid        no-undo.
   define buffer b_abs_mstr for abs_mstr.

   /* FIND TOP-LEVEL PARENT SHIPPER OR PRESHIPPER */
   {gprun.i ""gpabspar.p""
      "(l_recid, 'PS', false, output l_par_recid)" }

   for first b_abs_mstr
      fields(abs_cmtindx abs_gwt abs_id abs_item abs_line abs_nwt abs_vol
             abs_order abs_par_id abs_qty abs_shipfrom abs_shipto
             abs_ship_qty abs_shp_date abs_status abs_trl_cmtindx
             abs_wt_um abs__qad01 abs__qad02 abs__qad03 abs__qad10)
      where recid(b_abs_mstr) = l_par_recid
   no-lock:

      if (b_abs_mstr.abs_id begins "s"    or
          b_abs_mstr.abs_id begins "p")
      then
         l_first_part_um = abs_wt_um.

   end. /* FOR FIRST b_abs_mstr */


   {absupack.i  "b_abs_mstr" 26 22 "l_parent_tare_wt" }

END PROCEDURE.
