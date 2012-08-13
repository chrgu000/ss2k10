/* sofmsv01.p - SHIPPER FORM SERVICE ENCAPSULATION PROCEDURE                 */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK.      */
/*V8:ConvertMode=Report                                                      */
/*K1Q4*/ /*V8:WebEnabled=No                                                  */
/* REVISION: 8.6      LAST MODIFIED: 11/12/96   BY: *K003* Steve Goeke       */
/* REVISION: 8.6      LAST MODIFIED: 12/06/96   BY: *K02Z* Vinay Nayak-Sujir */
/* REVISION: 8.6      LAST MODIFIED: 12/19/96   BY: *K03J* Vinay Nayak-Sujir */
/* REVISION: 8.6      LAST MODIFIED: 01/28/97   BY: *K04R* Kieu Nguyen       */
/* REVISION: 8.6      LAST MODIFIED: 02/05/97   BY: *K05Z* Steve Goeke       */
/* REVISION: 8.6      LAST MODIFIED: 03/15/97   BY: *K04X* Steve Goeke       */
/* REVISION: 8.6      LAST MODIFIED: 03/28/97   BY: *G2LS* Jim Williams      */
/* REVISION: 8.6      LAST MODIFIED: 03/25/97   BY: *K0DH* Arul Victoria     */
/* REVISION: 8.6      LAST MODIFIED: 06/20/97   BY: *H19N* Aruna Patil       */
/* REVISION: 8.6      LAST MODIFIED: 09/09/97   BY: *J20J* Suresh Nayak      */
/* REVISION: 8.6      LAST MODIFIED: 09/25/97   BY: *K0JZ* Joe Gawel         */
/* REVISION: 8.6      LAST MODIFIED: 10/01/97   BY: *K0KF* Joe Gawel         */
/* REVISION: 8.6      LAST MODIFIED: 10/23/97   BY: *J23T* Aruna Patil       */
/* REVISION: 8.6      LAST MODIFIED: 11/07/97   BY: *K18J* Jean Miller       */
/* REVISION: 8.6      LAST MODIFIED: 11/19/97   BY: *K19X* Jim Williams      */
/* REVISION: 8.6      LAST MODIFIED: 11/25/97   BY: *J26R* Niranjan R.       */
/* REVISION: 8.6      LAST MODIFIED: 12/13/97   BY: *J20Q* Aruna Patil       */
/* REVISION: 8.6      LAST MODIFIED: 12/19/97   BY: *J28J* Manish K.         */
/* REVISION: 8.6      LAST MODIFIED: 01/01/98   BY: *K1DL* Suresh Nayak      */

/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan        */
/* REVISION: 8.6E     LAST MODIFIED: 07/20/98   BY: *H1MC* Manish K.         */
/* REVISION: 8.6E     LAST MODIFIED: 08/05/98   BY: *J2VP* Manish K.         */
/* REVISION: 8.6E     LAST MODIFIED: 08/22/98   BY: *K1W8* Poonam Bahl       */
/* REVISION: 8.6E     LAST MODIFIED: 09/30/98   BY: *K1XF* Surekha Joshi     */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan        */

/*K05Z*/ /* Modified various comments throughout this */
/*K05Z*/ /* routine, but made no functional changes */
/*K1XF*/ /* ADDED MAXLEN AND COMMENT FOR THE PREPROCESSOR SOFMSV01_P_21 */

/*****************************************************************************/
/*                                                                           */

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE sofmsv01_p_1 "采购单号"
/* MaxLen: Comment: */

&SCOPED-DEFINE sofmsv01_p_2 "FOB 易主处"
/* MaxLen: Comment: */

&SCOPED-DEFINE sofmsv01_p_3 " 备料单标志: "
/* MaxLen: Comment: */

&SCOPED-DEFINE sofmsv01_p_4 " 预  货  运  单 "
/* MaxLen: Comment: */

&SCOPED-DEFINE sofmsv01_p_5 "客户零件:"
/* MaxLen: Comment: */

&SCOPED-DEFINE sofmsv01_p_6 "** 继续 **"
/* MaxLen: Comment: */

&SCOPED-DEFINE sofmsv01_p_7 "页号:"
/* MaxLen: Comment: */

&SCOPED-DEFINE sofmsv01_p_8 "累计发货量"
/* MaxLen: Comment: */

&SCOPED-DEFINE sofmsv01_p_9 " 项目: "
/* MaxLen: Comment: */

&SCOPED-DEFINE sofmsv01_p_10 "     装  箱  单     "
/* MaxLen: Comment: */

&SCOPED-DEFINE sofmsv01_p_11 "零件号!版本"
/* MaxLen: Comment: */

&SCOPED-DEFINE sofmsv01_p_12 "            货 运 单   "
/* MaxLen: Comment: */

&SCOPED-DEFINE sofmsv01_p_13 "固定数量"
/* MaxLen: Comment: */

&SCOPED-DEFINE sofmsv01_p_14 "零件号 :"
/* MaxLen: Comment: */

&SCOPED-DEFINE sofmsv01_p_15 "      货运单标志:"
/* MaxLen: Comment: */

&SCOPED-DEFINE sofmsv01_p_16 "打印日期:"
/* MaxLen: Comment: */

&SCOPED-DEFINE sofmsv01_p_17 "运输方式:"
/* MaxLen: Comment: */

&SCOPED-DEFINE sofmsv01_p_18 "      集装箱标志:"
/* MaxLen: Comment: */

&SCOPED-DEFINE sofmsv01_p_19 "核准号"
/* MaxLen: Comment: */

&SCOPED-DEFINE sofmsv01_p_20 "承运人发货参考:"
/* MaxLen: Comment: */

&SCOPED-DEFINE sofmsv01_p_21 "费用"
/* MaxLen:4 Comment:To identify qad_wkfl record holding trailer information. */

&SCOPED-DEFINE sofmsv01_p_22 "UM"
/* MaxLen: Comment: */

&SCOPED-DEFINE sofmsv01_p_23 "销往:"
/* MaxLen: Comment: */

&SCOPED-DEFINE sofmsv01_p_24 "车辆标志:"
/* MaxLen: Comment: */

&SCOPED-DEFINE sofmsv01_p_25 "已发货量"
/* MaxLen: Comment: */

&SCOPED-DEFINE sofmsv01_p_26 "客户订单: "
/* MaxLen: Comment: */

&SCOPED-DEFINE sofmsv01_p_27 "发货日期:"
/* MaxLen: Comment: */

&SCOPED-DEFINE sofmsv01_p_28 "运输代理:"
/* MaxLen: Comment: */

&SCOPED-DEFINE sofmsv01_p_29 "货物发往:"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

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

         {mfdeclre.i}


         /* Define the name of this procedure, used to identify records */
         /* in qad_wkfl that are created, modified, or deleted by any   */
         /* service encapsulated here.                                  */

         &scoped-define PROC-NAME 'sofmsv01.p'


         /* Define prefixes used to identify qad_wkfl records holding   */
         /* additional header, line item, or trailer information.       */

         &scoped-define HDR-PREFIX 'HDR'
         &scoped-define ITM-PREFIX 'ITM'
         &scoped-define TRL-PREFIX {&sofmsv01_p_21}


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

         &scoped-define DELIMITER chr(1)


         /* HEADER DATA-GATHERING SERVICE DEFINITIONS */

         /* < Add defs required by the header data-gathering service here > */


         /* LINE ITEM DATA-GATHERING SERVICE DEFINITIONS */

         /* < Add defs required by line item data-gathering service here > */


         /* TRAILER DATA-GATHERING SERVICE DEFINITIONS */

         /* < Add defs required by the trailer data-gathering service here > */


         /* PRINT SERVICE DEFINITIONS */

         /* Required for external procedure gpaddr.p */
         define new shared variable addr as character format "x(38)" extent 6.
         
         define shared variable loc_fm as character.  /*Lu_2*/


         define temp-table t_abs_det no-undo
            field det_item     like abs_item
            field det_order    like abs_order
            field det_line     like abs_line
            field det_qty      like abs_qty
            field det_ship_qty like abs_ship_qty
/*K04X*/    field det_um       like abs__qad02
/*J20Q*/    field det_conv     like abs__qad03
            field det_cmtindx  like abs_cmtindx
            field det_id       like abs_id
            field det_shipfrom like abs_shipfrom
            index item is primary
               det_item
               det_order
               det_line
            index order
               det_order.

         define temp-table t_abs_comp no-undo
            field comp_item     like abs_item
            field comp_shipfrom like abs_shipfrom
            field comp_order    like abs_order
            field comp_line     like abs_line
            field comp_qty      like abs_qty
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

/*K1DL*/   /* ADDED  THE FOLLOWING CODE TO PRINT AUTHORIZATION NUMBER */
/*K1DL*/  define temp-table t_absr_det no-undo
/*K1DL*/         field t_absr_reference like absr_reference
/*K1DL*/         field t_absr_qty like absr_qty.

         /* ARCHIVE SERVICE DEFINITIONS */

         define stream s_history.


         /* RENAME SERVICE DEFINITIONS */

         /* < Add defs required by the rename service here > */


         /* DELETE SERVICE DEFINITIONS */

         /* < Add defs required by the delete service here > */


         /* END OF COMMON DEFINITIONS */


/*K03J*/ /* Dummy references for BOMs, unreferenced-file reports, etc. */
/*K03J*/ if false then do:
/*K03J*/    {gprun.i ""gpqwdel.p""}
/*K03J*/    {gprun.i ""gpqwren.p""}
/*K03J*/ end.


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
 *            if keyfunction(lastkey) ne "END-ERROR" then
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
 *               v_char  colon 15
 *               v_int   colon 15
 *               v_dec   colon 15
 *               v_log   colon 15
 *               v_date  colon 15
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
 *            /* Display info */
 *            display
 *               abs_item abs_lotser abs_ref
 *           v_char v_int v_dec v_log v_date
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
 *            if keyfunction(lastkey) ne "END-ERROR" then
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
 *            if keyfunction(lastkey) ne "END-ERROR" then
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

         procedure xxsh_print:

            /* Prints a single shipper */

            /* This routine is logically equivalent to rcrp1301.p */

            /* INPUT PARAMETERS */
            define input parameter i_abs_recid     as recid   no-undo.

/*H1MC* **BEGIN DELETE**
 *          define input parameter i_ship_comments as logical no-undo.
 *          define input parameter i_pack_comments as logical no-undo.
 *          define input parameter i_features      as logical no-undo.
 * /*H19N*/ define input parameter i_print_sodet   as logical no-undo.
 *H1MC* **END DELETE** */

/*H1MC*/    define input parameter i_ship_comments like mfc_logical no-undo.
/*H1MC*/    define input parameter i_pack_comments like mfc_logical no-undo.
/*H1MC*/    define input parameter i_features      like mfc_logical no-undo.
/*H1MC*/    define input parameter i_print_sodet   like mfc_logical no-undo.
/*J2VP*/    define input parameter i_so_um         like mfc_logical no-undo.
            /* LOCAL VARIABLES */
            define variable company      as   character format "x(38)" extent 6
                                                                       no-undo.
            define variable billto       as   character format "x(38)" extent 6
                                                                       no-undo.
            define variable shipto       as   character format "x(38)" extent 6
                                                                       no-undo.
            define variable rpt_type     as   character format "x(23)" no-undo.
            define variable type_nbr     as   character format "x(17)" no-undo.
            define variable shipper_id   like abs_id                   no-undo.
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
/*G2LS    define variable disp_item    like pt_part   format "x(24)" no-undo. */
/*J26R** /*G2LS*/define variable disp_item like pt_part format "x(22)"no-undo.*/
/*J26R*/    define variable disp_item    like pt_part   format "x(26)" no-undo.
            define variable cum_qty      like sod_cum_qty[1] extent 0  no-undo.
            define variable cmtindx_cdl  as   character                no-undo.
            define variable cmt_ctr      as   integer                  no-undo.
            define variable i            as   integer                  no-undo.
            define variable dqty         like sob_qty_req
                                             format "->>>>>>>9.9<<<<<" no-undo.
/*K04X*/    define variable v_tr_type    like im_tr_type               no-undo.
/*K04X*/    define variable v_start_page as   integer                  no-undo.
/*H19N*/    define variable msgdesc like msg_desc initial "" format "x(62)"
/*H19N*/         no-undo.
/*J23T*/    define variable addr_id      as   character                no-undo.
/*J26R** /*K18J*/ define variable shipper-po   as  character format "x(19)" */
/*J26R**    no-undo. */
/*J26R*/    define variable shipper-po   as   character format "x(22)" no-undo.
/*yf*/      define var i2 as integer.
/*yf*/      DEFINE VAR i1 AS INTEGER.
/*yf*/      define var temp_string as character.
/*yf*/      define var temp_string1 as character.
/*yf*/      DEFINE VARIABLE desc1 LIKE pt_desc1.
/*yf*/      DEFINE VARIABLE temp_1 AS INTEGER.
/*yf*/      DEFINE VARIABLE temp_2 AS INTEGER.
/*yf*/      DEFINE VARIABLE temp_3 AS INTEGER.
/*yf*/      DEFINE VARIABLE temp_4 AS CHARACTER.
/*yf*/      DEFINE VARIABLE temp_5 AS INTEGER.
/*yf*/      DEFINE VARIABLE temp_6 AS INTEGER.
/*yf*/      DEFINE VARIABLE temp_7 AS CHARACTER INITIAL "销售".
/*yf*/      DEFINE VARIABLE temp_num AS INTEGER . /*total page*/
/*yf*/      define variable temp_8 as character.
/*yf*/      define variable temp_9 as character.
/*yf*/      define variable temp_10 as decimal.
/*yf*/      define variable temp_12 as character.
/*yf*/      DEFINE VARIABLE head_1  AS CHARACTER INITIAL "共".
/*yf*/      DEFINE VARIABLE head_2  AS CHARACTER INITIAL "页 第".
/*yf*/      DEFINE VARIABLE head_3  AS CHARACTER INITIAL "页".
/*yf*/      DEFINE VARIABLE head_4  AS INTEGER INITIAL 1.
/*yf*/      define variable temp_cust_part as character.

/*yf*/      head_4 = 1.


            /* FRAMES */ /*yf
/*yf*/      FORM /*yf HEADER */
/*yf0915               SKIP(3)      */
               shipper_id at 120 
               temp_12 at 80
               head_1  at 120 FORMAT "x(2)" temp_num format ">9" head_2 FORMAT "x(5)"  head_4  format ">9" head_3 FORMAT "x(2)"  SKIP(1)
               billto[1] AT 20 FORMAT "x(30)"
               billto[2] AT 87 FORMAT "x(50)" SKIP
               ABS_shipvia AT 20 FORMAT "x(16)"
               ABS_trans_mode AT 52 FORMAT "x(12)"
               ABS_veh_ref AT 87 FORMAT "x(12)"
               temp_7 AT 133 SKIP(4)
            WITH FRAME f_head /*PAGE-TOP */ WIDTH 200 NO-BOX NO-ATTR-SPACE NO-LABELS. */
/*yf*/
       
/*yf            form /* header */
               skip (3)
               company[1]  at 4        rpt_type      to 79
               company[2]  at 4
               company[3]  at 4        type_nbr      to 58   shipper_id
               company[4]  at 4        {&sofmsv01_p_27}  to 58   ship_date
               company[5]  at 4        {&sofmsv01_p_16} to 58   print_date
/*K04X*                                "Page:"       to 58   page-number  *K04X*/
/*K04X*/ /*yf      {&sofmsv01_p_7}    to 58  /*yf trim(string(page-number - v_start_page + 1)) */
/*K04X*/                         format "XXXX" */
               company[6]  at 4
               skip (1)
               {&sofmsv01_p_23}  at 8  cust  {&sofmsv01_p_29}    at 46   ship
               skip (1)
               billto[1]   at 8        shipto[1]     at 46
               billto[2]   at 8        shipto[2]     at 46
               billto[3]   at 8        shipto[3]     at 46
               billto[4]   at 8        shipto[4]     at 46
               billto[5]   at 8        shipto[5]     at 46
               billto[6]   at 8        shipto[6]     at 46
               skip(5)
               {&sofmsv01_p_28}             to 12  abs_shipvia
               {&sofmsv01_p_17}    to 58  abs_trans_mode
               {&sofmsv01_p_2}            to 12  abs_fob
               {&sofmsv01_p_20} to 58  abs_carr_ref
/*K0JZ* /*K0DH*/  "Ship To PO:"           to 12  so_mstr.so_ship_po  */
               {&sofmsv01_p_24}           to 58  abs_veh_ref
               skip(3)
            with frame f_formhdr /* page-top*/ width 90
            no-box no-attr-space no-labels. yf*/
            form
/*J26R**       disp_item */
/*J26R*/       disp_item                      column-label {&sofmsv01_p_11}
/*J23T**       cp_cust_eco  format "x(4)"     column-label "Rev" */
/*J23T**       sod_contr_id format "x(22)"                       */
/*J26R** /*J23T*/ cp_cust_eco                 column-label "Rev" */
/*K18J*/ /* /*J23T*/ sod_contr_id format "x(19)" */
/*K19X* /*K18J*/     shipper-po                  */
/*K19X*/       shipper-po                          column-label {&sofmsv01_p_1}
/*J26R**       det_qty   format "->>>>>>9.9<<<<<<" column-label "Qty Shipped" */
/*J26R*/       det_qty     format "->>>>>>9.99<<<<<<" column-label {&sofmsv01_p_25}
/*G2LS         cum_qty     format "->>>>>>9.9<<<<<<"   */
/*J26R** /*G2LS*/ cum_qty  format "->>>>>>>>>9.9<<<<<<" */
/*J26R*/       cum_qty     format "->>>>>>>>>9.99<<<<<<"
                           column-label {&sofmsv01_p_8}
               abs__qad02   format "x(2)"             column-label {&sofmsv01_p_22}
/*K02Z*     with frame f_det width 80 no-box. */
/*K02Z*/    with frame f_det down width 80 no-box.
/*yf*//*      FORM
           
               DISP_item  AT 11 FORMAT "x(8)"
               shipper-po  FORMAT "x(18)"
               desc1       FORMAT "x(24)"
               temp_8     at 66 format "x(1)"
               temp_1     AT 69 FORMAT ">>9" /*长*/
               temp_2     FORMAT ">>9" /*宽*/
               temp_3     FORMAT ">>9" /*高*/
               ABS__qad02  AT 82 FORMAT "x(2)" /*um*/
               det_qty     at 89 format ">>>9"
               temp_5      AT 102 FORMAT ">>9"  /*package*/
               temp_6     at 108 FORMAT ">>9" /*package*/
            WITH FRAME ff_det NO-LABELS DOWN WIDTH 200 NO-BOX.
  */     /* form
   /*           shipper-po at 11 format "(18)"  */
              disp_item  at 11 format "x(8)"
              shipper-po format "x(18)"
              desc1   format "x(24)"
    /*          shipper-po  format "x(18)"     */
              temp_9    format "x(6)"
              temp_8   format "x(3)"
              temp_1  format "999"
              temp_2  format "999"
              temp_3 format "999"
              abs__qad02 format "x(3)"
              det_qty   format ">>>9.99"
              temp_10   format ">>>>9.99"
              temp_5    format ">>9"
              temp_6    format ">>9"
           with frame ff_det no-labels down width 200 no-box.       */   
/*end define yf*/
/*K1DL*/  /* DEFININGS THE FORM FOR AUTHORIZATION NUMBER */
/*K1DL*/    form t_absr_reference column-label {&sofmsv01_p_19}  at 11
/*K1DL*/         t_absr_qty column-label {&sofmsv01_p_13}
/*K1DL*/          sod_um
/*K1DL*/    with down frame auth.

            /* PREPROCESSORS */

/*K18J*/ /*Changed sod_contr_id to shipper-po in scoped-define*/

            &scoped-define PAGEBREAK                                           
/*yf           if page-size - line-count lt 1 then do with frame f_det:                  /*yf  page. */                                                                   display disp_item {&sofmsv01_p_6} @ shipper-po.
           down 1.
        end. */


            /* PROCEDURE BODY */

/*K04X*/  /*yf  v_start_page = page-number. */

            find abs_mstr no-lock where recid(abs_mstr) = i_abs_recid
               no-error.
            if not available abs_mstr then return.

/*K04X*/    /* Get the shipper's transaction type */
/*K04X*/    {gprun.i ""icshtyp.p"" "(i_abs_recid, output v_tr_type)" }

            assign
               shipper_id = substring(abs_id,2)
               ship_date  = abs_shp_date.

/*J23T*/ /* NOW DOCKTO, SHIPTO AND SOLDTO WILL BE TAKEN FROM ls_mstr */
/*J23T*/ /* INSTEAD OF ad_mstr                                       */

/*J23T** BEGIN DELETE **
 *          /* Get sold-to and ship-to addresses */
 *
 *          find ad_mstr no-lock where ad_addr = abs_shipto no-error.
 *
 *          if available ad_mstr then do:
 *
 *             /* Dock address */
 *
 *             if ad_type = "dock" then do:
 *
 *                shipto_id = ad_ref.
 *
 *                find ad_mstr no-lock where ad_addr = shipto_id no-error.
 *                if available ad_mstr then
 *                   soldto_id =
 *                      if ad_type = "ship-to" then ad_ref else ad_addr.
 *
 *             end.  /* if ad_type = "dock" */
 *
 *             /* Ship-to address */
 *
 *             else if ad_type = "ship-to" then
 *                assign
 *                   shipto_id = ad_addr
 *                   soldto_id = ad_ref.
 *
 *             /* Customer address */
 *
 *             else
 *                assign
 *                   shipto_id = ad_addr
 *                   soldto_id = ad_addr.
 *
 *             /* Get ship-to address print fields */
 *J23T** END DELETE ** */

/*J20J**       find ad_mstr no-lock where ad_addr = shipto_id no-error.   */
/*J20J*/       find ad_mstr no-lock where ad_addr = abs_shipto no-error.


               if available ad_mstr then do:

/*J23T*/          assign shipto_id = ad_addr
/*J23T*/                 ship      = ad_addr.

                  assign
                     addr[1] = ad_name
                     addr[2] = ad_line1
                     addr[3] = ad_line2
                     addr[4] = ad_line3
                     addr[6] = ad_country.

                  {mfcsz.i addr[5] ad_city ad_state ad_zip}

                  {gprun.i ""gpaddr.p"" }

                  assign
                     shipto[1] = addr[1]
                     shipto[2] = addr[2]
                     shipto[3] = addr[3]
                     shipto[4] = addr[4]
                     shipto[5] = addr[5]
/*J23T*/             shipto[6] = addr[6].
/*J23T**             shipto[6] = addr[6]  */
/*J23T**             ship      = ad_addr. */

                 end.  /* if available ad_mstr */

               /* Get sold-to address print fields */

/*J23T**       find ad_mstr no-lock where ad_addr = soldto_id no-error. */

/*J23T*/       find ad_mstr no-lock where ad_addr = abs_shipto.
/*J23T*/       assign soldto_id = ad_addr
/*J23T*/              cust      = ad_addr.

/*J23T*/       find ls_mstr where ls_addr = ad_addr and ls_type = "customer"
/*J23T*/       no-lock no-error.
/*J23T*/       if not available ls_mstr and ad_ref > "" then do :

/*J23T*/          find ls_mstr where ls_addr = ad_ref and
/*J23T*/          ls_type = "customer" no-lock no-error.

/*J23T*/          if available ls_mstr then do  :
/*J23T*/            assign soldto_id = ad_ref
/*J23T*/               cust      = ad_ref.
/*J23T*/          end. /* END OF IF AVAILABLE ls_mstr */
/*J23T*/          else do :
/*J23T*/            assign addr_id = ad_ref.
/*J23T*/            find first ad_mstr where ad_addr = addr_id no-lock.

/*J23T*/            if ad_ref > "" then do :
/*J23T*/              find ls_mstr where ls_addr = ad_ref and
/*J23T*/              ls_type = "customer" no-lock no-error.
/*J23T*/              if available ls_mstr then do :
/*J23T*/                 assign soldto_id = ad_ref
/*J23T*/                        cust      = ad_ref.
/*J23T*/              end. /* END OF IF AVAILABLE ls_mstr */

/*J23T*/            end. /* END OF IF ad_ref > "" */

/*J23T*/          end. /* END OF ELSE DO */

/*J23T*/       end. /* END OF NOT AVAILABLE ls_mstr */
/*J23T*/       find first ad_mstr where ad_addr = soldto_id no-lock.

               if available ad_mstr then do:

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
/*J23T*/             billto[6] = addr[6].
/*yf*/               billto[2] = addr[2] + addr[3] + addr[4].
/*J23T**             billto[6] = addr[6]  */
/*J23T**             cust      = ad_addr. */

               end.  /* if available (soldto) ad_mstr */

/*J23T**    end.  /* if available (shipto) ad_mstr */   */

            /* Get ship-from address print fields */

        find ad_mstr no-lock where ad_addr = abs_shipfrom no-error.

            if available ad_mstr then do:

               assign
                  addr[1] = ad_name
                  addr[2] = ad_line1
                  addr[3] = ad_line2
                  addr[4] = ad_line3
                  addr[6] = ad_country.

               {mfcsz.i addr[5] ad_city ad_state ad_zip}

               {gprun.i ""gpaddr.p"" }

               assign
                  company[1] = addr[1]
                  company[2] = addr[2]
                  company[3] = addr[3]
                  company[4] = addr[4]
                  company[5] = addr[5] 
                  company[6] = addr[6].

            end.  /* if available (shipfrom) ad_mstr */
      
            /* Explode shipper/container to get low-level item detail */

            for each t_abs_det exclusive-lock:
               delete t_abs_det.
            end.

            run supp_build_det (i_abs_recid).

            assign
               print_date     = today
               abs_shipvia    = substr(abs__qad01, 1,20)
               abs_fob        = substr(abs__qad01,21,20)
               abs_carr_ref   = substr(abs__qad01,41,20)
               abs_trans_mode = substr(abs__qad01,61,20)
               abs_veh_ref    = substr(abs__qad01,81,20).

            if abs_id begins "s" then
               assign
                  rpt_type = {&sofmsv01_p_12}
                  type_nbr = {&sofmsv01_p_15}.

            else if abs_id begins "c" then
               assign
                  rpt_type = {&sofmsv01_p_10}
                  type_nbr = {&sofmsv01_p_18}.

            else if abs_id begins "p" then
               assign
                  rpt_type = {&sofmsv01_p_4}
                  type_nbr = {&sofmsv01_p_3}.


/*yf           view frame f_head. */
/*yf            ASSIGN head_4 = PAGE-NUMBER. */


 /*yf           if abs_cmtindx > 0 and i_ship_comments then do:
               {gpcmtprt.i &type=SH &id=abs_cmtindx &pos=3}
               put skip(1).
            end. */

            /* Print sales order comments */

/*K04X*     if i_pack_comments then  *K04X*/

/*K04X*/    if i_pack_comments and v_tr_type = "ISS-SO" then
               for each t_abs_det no-lock break by det_order:

               if first-of(det_order) then do:

                  find so_mstr no-lock where so_nbr = det_order no-error.

/*K1W8*/          /* USING IDH_CONTR_ID TO FACILITATE PO NUMBER PRINTING FOR */
/*K1W8*/          /* DISCRETE AS WELL AS SCHEDULED ORDERS,                   */
/*K1W8*/          /* IF SALES ORDER IS NOT AVAILABLE                         */

/*K1W8*/          /* FINDING IDH_CONTR_ID BELOW IN SHIPPER DETAIL LOOPING    */
/*K1W8*/          /* STRUCTURE AS ONE SHIPPER CAN HAVE MANY SALES ORDERS     */
/*K1W8** BEGIN DELETE
 * /*K18J*/          if not available so_mstr then
 * /*K19X*/ /*NEED TO FIND THE FIRST AVAILABLE ih_hist. THIS SHOULD BE OK     */
 * /*K19X*/ /*BECAUSE THE INFORMATION RETRIEVED SHOULD BE THE SAME FOR ALL    */
 * /*K19X*/ /*INVOICES REFERENCING A PARTICULAR SO NUMBER.  THIS DOES NOT FIND*/
 * /*K19X*/ /*A SPECIFIC INVOICE RECORD ONLY THE FIRST OCCURRENCE OF ih_hist. */
 * /*K19X* /*K18J*/    find ih_hist no-lock where ih_nbr = det_order no-error.*/
 * /*K19X*/             find first ih_hist no-lock where ih_nbr = det_order
 * /*K19X*/                  no-error.
 *K1W8** END DELETE */

                  if available so_mstr and so_cmtindx > 0 then do:
 /*yf                    {gpcmtprt.i &type=PA &id=so_cmtindx &pos=3} */
                  end.
               end.  /* if first-of */
            end.  /* if i_pack_comments ... then for */

            /* Loop through shipper details */
/*yf calc page total number*/
            i2 = 0.
            FOR EACH t_abs_det NO-LOCK :
                i2 = i2 + 1.
            END.
            IF  (i2 MODULO 12 ) < 6 AND (i2 MODULO 12) > 0 THEN temp_num = integer(i2 / 12) + 1.
            ELSE temp_num = INTEGER((i2 / 12)).
/*end calc */

/*yf           view frame f_head. */
/*yf            ASSIGN head_4 = PAGE-NUMBER. */

/*yf*/         if substring(abs_status,1,1) = "y" then
/*yf*/          temp_12 = "**副本**".
/*yf*/          else temp_12  = "".
/*yf            view frame f_formhdr. 

            page. */


/*yf
                     PUT SKIP(3).

                     DISP 
                         shipper_id  
                         temp_12 
                         head_1  temp_num  head_2 head_4  head_3  
                         billto[1] 
                         billto[2] 
                         ABS_shipvia 
                         ABS_trans_mode 
                         /* ABS_veh_ref  */
                         temp_7  WITH FRAME f_head. */
                     /* Display header */
            /* Print shipper comments */
/*yf*/      i1 = 0.       
            for each t_abs_det no-lock
               with frame f_det break by det_item by det_order by det_line:

               cmtindx_cdl = cmtindx_cdl + string(det_cmtindx) + ",".

/*J2VP*/       /* TO PRINT SHIPPER IN SO UM OR INVENTORY UM  */
/*J2VP*/       if i_so_um then do:
/*J2VP*/          for first sod_det
/*J2VP*/              fields ( sod_cfg_type sod_cmtindx sod_contr_id
/*J2VP*/                       sod_cum_qty  sod_custpart sod_line sod_nbr
                   sod_part sod_qty_ord sod_um sod_um_conv )
/*J2VP*/              where sod_nbr  = det_order
/*J2VP*/              and sod_line = integer (det_line) no-lock :
/*J2VP*/          end. /* FOR FIRST SOD_DET */

/*J2VP*/          if available sod_det then
/*J2VP*/             assign det_qty = ( det_qty * decimal(det_conv) )
/*J2VP*/                              / sod_um_conv
/*J2VP*/                    det_um = sod_um
/*J2VP*/                    det_conv = string(sod_um_conv).
/*J2VP*/       end. /* IF I_SO_UM */

/*yf*/         IF i1 = 0 THEN DO:
/*yf*/         PUT /*yf HEADER */
               SKIP(3.5)      
               temp_12 at 80
               shipper_id at 120   SKIP
               head_1  at 120 FORMAT "x(2)" temp_num format ">9" head_2 FORMAT "x(5)"  head_4  format ">9" head_3 FORMAT "x(2)" 
               shipto[1] AT 20 FORMAT "x(30)"
               shipto[2] AT 87 FORMAT "x(50)" SKIP(0.5)
               ABS_shipvia AT 20 FORMAT "x(16)"
               ABS_trans_mode AT 52 FORMAT "x(12)"
               ABS_veh_ref AT 87 FORMAT "x(12)"
               temp_7 AT 129 SKIP(4) .
               END.
               accumulate det_qty     (sub-total by det_line).
               accumulate det_ship_qty(sub-total by det_line).

               /* Add workfile entry for component quantities for kit items */

               run supp_build_comp (det_shipfrom, det_id, det_order, det_line).

/*K1DL*/ /* CREATING THE WORKFILE FOR PRINTING THE AUTHORIZATION NUMBER */
/*K1DL*/       for each absr_det no-lock where
/*K1DL*/       absr_shipfrom = det_shipfrom
/*K1DL*/       and absr_id = det_id :
/*K1DL*/           if absr_reference <> "" then do:
/*K1DL*/              find first t_absr_det where
/*K1DL*/              t_absr_reference = absr_reference no-error.
/*K1DL*/              if not available t_absr_det then
/*K1DL*/              do:
/*K1DL*/                  create t_absr_det.
/*K1DL*/                  assign t_absr_reference = absr_reference
/*K1DL*/                         t_absr_qty = absr_qty.
/*K1DL*/              end.
/*K1DL*/              else do:
/*K1DL*/                  t_absr_qty = t_absr_qty + absr_qty.
/*K1DL*/              end.
/*K1DL*/           end. /* end of if absr_reference <> "" */
/*K1DL*/       end. /* end of for each absr_det */


               /* Print details */

               if last-of(det_line) then do:

                  assign
                     disp_item = det_item.
                     cum_qty   =
                        (accum sub-total by det_line det_qty) -
                        (accum sub-total by det_line det_ship_qty).

/*K04X*/          if v_tr_type = "ISS-SO" then do:

                     find sod_det no-lock where
                        sod_nbr  = det_order and
                        sod_line = integer(det_line) no-error.

                     if available sod_det then do:

/*J23T**                find cp_mstr no-lock where                */
/*J23T**                   cp_cust      = abs_shipto and         */
/*J23T**                   cp_cust_part = sod_custpart no-error. */

/*J23T*/                find cp_mstr where cp_cust = abs_shipto
/*J23T*/                no-lock no-error.

/*J23T*/                if not available cp_mstr then
/*J23T*/                   find cp_mstr where cp_cust = cust and
/*J23T*/                   cp_cust_part = sod_custpart no-lock no-error.

                          assign
                           disp_item =
                              if available cp_mstr and cp_cust_partd ne ""
                                 then cp_cust_partd
                                 else if sod_custpart ne ""
                                    then sod_custpart
                                    else sod_part
/*J20Q*/                   /* CUM_QTY NEED TO DISPLAYED IN SHIP UM */
/*J20Q**                   cum_qty = cum_qty + sod_cum_qty[1].  */
/*J20Q*/                   cum_qty = cum_qty + ((sod_cum_qty[1] *
/*J20Q*/                      sod_um_conv) / decimal(det_conv)).

                        find pt_mstr no-lock where pt_part = sod_part no-error.
/*K1W8*/                shipper-po = sod_contr_id.
                     end.  /* if available sod_det */
/*K1W8*/             else do :
/*K1W8*/                for first idh_hist
/*K1W8*/                    fields (idh_contr_id idh_line idh_nbr idh_part)
/*K1W8*/                    where idh_nbr = det_order and
/*K1W8*/                          idh_line = integer(det_line) and
/*K1W8*/                          idh_part = det_item no-lock.
/*K1W8*/                end. /* FOR FIRST IDH_HIST */
/*K1W8*/                if available idh_hist then
/*K1W8*/                   shipper-po = idh_contr_id.
/*K1W8*/                else
/*K1W8*/                   shipper-po = "".
/*K1W8*/             end. /* NOT AVAILABLE SOD_DET */
/*K04X*/          end.  /* if v_tr_type */

/*K1W8** BEGIN DELETE
 * /*K18J*/          if available so_mstr then
 * /*K18J*/            shipper-po = so_ship_po.
 * /*K18J*/          else if available ih_hist then
 * /*K18J*/            shipper-po = ih_ship_po.
 * /*K18J*/          else
 * /*K18J*/            shipper-po = "".
 *K1W8** END DELETE */

                  /* Display the line item */
/*yf                  display
                     disp_item
/*J26R**             cp_cust_eco  when (available cp_mstr) */
/*K18J*/             shipper-po
/*K18J* /*K139*/     so_ship_po when (available so_mstr) @ sod_contr_id */
/*K139*              sod_contr_id when (available sod_det)  */
                     accum sub-total by det_line det_qty @ det_qty
                     cum_qty      when (available sod_det)
/*K04X*/             det_um       @ abs__qad02.
/*K04X*              abs__qad02.  *K04X*/

/*K02Z*/          down with frame f_det.  */
/*yf add for get length width and hight*/
                  find first sod_det where sod_nbr = det_order and sod_line = integer(det_line) no-lock no-error.
                  if available sod_det then do:
                     find first pt_mstr where pt_part = sod_part no-lock no-error.
                  end.
/*yf*/            temp_8 = "".
                  temp_9 = "".
                  temp_5 = 0.
                  temp_6 = 0.
                  temp_1 = 0.
                  temp_2 = 0.
                  temp_3 = 0.
                  IF AVAILABLE pt_mstr THEN DO:

                      if pt_ship_wt <> 0 then do:
                      IF det_qty MODULO pt_ship_wt > 0 THEN DO:
                          temp_6 = INTEGER(det_qty / pt_ship_wt) + 1.
                      END.
                      ELSE DO:
                          temp_6 = det_qty / pt_ship_wt.
                      END.
                      end.
                      temp_5 = pt_ship_wt.
                      temp_8 = pt_ship_wt_um.
/*Lu_2                      temp_9 = pt_loc.  */
/*Lu_2*/              temp_9 = loc_fm.
                  END.
/*yf*/            IF AVAILABLE pt_mstr and length(pt_article) > 0 THEN DO: 
/*yf*/               i2 = 1.
                     temp_string = "".
                     temp_string1 = pt_article.
                     REPEAT:
                         IF substring(pt_article,i2,1) <> "x" AND SUBSTRING(pt_article,i2,1) <> "X" and substring(pt_article,i2,1) <> "*" THEN
                         temp_string = temp_string + SUBSTRING(pt_article,i2,1).
                         ELSE do:
                             temp_string1 = SUBSTRING(temp_string1,(i2 + 1), (LENGTH(temp_string1) - i2)).
                             LEAVE.
                         END.
                         i2 = i2 + 1.
                     END.
                     temp_1 = INTEGER(temp_string).
                     temp_string = "".
                     i2 = 1.
                     REPEAT:
                         if length(temp_string1) = 0 then leave.
                         IF substring(temp_string1,i2,1) <> "x" AND SUBSTRING(temp_string1,i2,1) <> "X" and substring(temp_string1,i2,1) <> "*" THEN
                         temp_string = temp_string + SUBSTRING(temp_string1,i2,1).
                         ELSE do:
                             temp_string1 = SUBSTRING(temp_string1,(i2 + 1), (LENGTH(temp_string1) - i2)).
                             LEAVE.
                         END.
                         i2 = i2 + 1.
                     END.
                     temp_2 = INTEGER(temp_string).
/*yf*/               temp_3 = INTEGER(temp_string1).
/*yf                     desc1  = pt_desc1 . */
/*here add the qty in one package and what package*/
                     if pt_ship_wt <> 0 then do:
                     IF det_qty MODULO pt_ship_wt > 0 THEN DO:
                         temp_6 = INTEGER(det_qty / pt_ship_wt) + 1.
                     END.
                     ELSE DO:
                         temp_6 = det_qty / pt_ship_wt.
                     END.
                     end.
                     temp_5 = pt_ship_wt.
                     temp_8 = pt_ship_wt_um.
/*Lu_2                     temp_9 = pt_loc.  */
/*Lu_2*/             temp_9 = loc_fm.
/*yf*/            END.
/*yf end add*/
/*yf bagin delete**********************************************
/*J28J*/          if available cp_mstr and available pt_mstr then do:
/*J28J*/             if disp_item          = cp_cust_partd
/*J28J*/                and cp_cust_partd <> cp_cust_part
/*J28J*/                or  cp_cust_part  =  pt_part
/*J28J*/                and cp_cust_partd <> "" then
/*J28J*/             put {&sofmsv01_p_5} at 1 sod_custpart.

/*J28J*/             if cp_cust_partd     <> pt_part
/*J28J*/                and cp_cust_partd <> ""
/*J28J*/                or  cp_cust_partd =  cp_cust_part then
/*J28J*/             put {&sofmsv01_p_14} at 1 pt_part .

/*J28J*/             if disp_item         = sod_custpart
/*J28J*/                and cp_cust_partd = ""
/*J28J*/                and cp_cust_part  <> pt_part  then
/*J28J*/             put {&sofmsv01_p_14} at 1 pt_part.
/*J28J*/          end. /* IF AVAILABLE CP_MSTR AND PT_MSTR */

/*J26R*/          if available cp_mstr and cp_cust_eco <> "" then do:
/*J26R*/             display cp_cust_eco @ disp_item with frame f_det.
/*J26R*/             down with frame f_det.
/*J26R*/          end. /* IF AVAILABLE CP_MSTR AND CP_CUST_ECO <> "" */

/*J28J*/          display " " @ disp_item with frame f_det.
/*J28J*/          down with frame f_det.

/*K1DL*/          /* PRINTING AUTHORIZATION NUMBER*/
/*K1DL*/          for each t_absr_det by t_absr_reference:
/*K1DL*/               {&PAGEBREAK}
/*K1DL*/               display
/*K1DL*/                  t_absr_reference
/*K1DL*/                  t_absr_qty
/*K1DL*/                   sod_um
/*K1DL*/               with frame auth.
/*K1DL*/               down with frame auth.
/*K1DL*/          end. /* END OF FOR EACH absr_det */
end delete*****************************************/
/*yf bagin display */
/*yf*/          find first sod_det where sod_nbr = det_order and sod_line = integer(det_line) no-lock no-error.
                temp_cust_part = "".
                if available sod_det then do:        /*
                   find first cp_mstr where cp_cust = abs_shipto and cp_part = sod_part no-lock no-error.
                   if available cp_mstr and length(cp_cust_partd) > 0 then do:
                      temp_cust_part = cp_cust_partd.
                   end.
                   else if length(sod_custpart) > 0 then 
                      temp_cust_part = sod_custpart.
                end.                                   */
                find first so_mstr where so_nbr = det_order no-lock no-error.
                find first cp_mstr where cp_cust = so_cust  and cp_part = sod_part no-lock no-error.
                if not available  cp_mstr then
                find first  cp_mstr where cp_cust = cust and cp_cust_part = sod_custpart no-lock no-error.
                assign 
                  temp_cust_part =
                    if available cp_mstr  then cp_cust_partd
                    else if sod_custpart ne ""
                    then sod_custpart
                    else "" .
                end.
                if available cp_mstr then temp_cust_part = cp_cust_part.   

                  /*    form
                           shipper-po at 11 format "(18)"  
                            disp_item  at 11 format "x(8)"
                            shipper-po format "x(18)"
                            desc1   format "x(24)"
                  /*          shipper-po  format "x(18)"     */
                            temp_9    format "x(6)"
                            temp_8   format "x(3)"
                            temp_1  format "999"
                            temp_2  format "999"
                            temp_3 format "999"
                            abs__qad02 format "x(3)"
                            det_qty   format ">>>9.99"
                            temp_10   format ">>>>9.99"
                            temp_5    format ">>9"
                            temp_6    format ">>9"
                         with frame ff_det no-labels down width 200 no-box.    */     
                if available sod_det  THEN  DO:
                PUT
                    pt_part AT 11 FORMAT "x(13)"   ""
                    temp_cust_part FORMAT "x(15)" ""
                    pt_desc1 FORMAT "x(20)"       "" 
                    temp_9    format "x(6)"       " "
                    temp_8   format "x(3)"        " " .
                    
                    IF temp_1 = 0 THEN PUT "    ".
                    ELSE PUT temp_1  format "999"          " ".
                    IF temp_2 = 0 THEN PUT "    ".
                    ELSE PUT temp_2 format "999"          " ".
                    IF temp_3 = 0 THEN PUT "    ".
                    ELSE PUT temp_3 format "999"           "".
                    PUT det_um format "x(3)"          " "          
                    det_qty   format "->>>9.99"    "         "  .
                    IF temp_5 = 0 THEN PUT "    ".
                    ELSE PUT temp_5    format ">>9"        " ".
                    IF temp_6 = 0 THEN PUT "    ".
                    ELSE PUT temp_6    format ">>9"        SKIP .
                END.
                else DO:
                   
                    PUT
                        pt_part AT 11 FORMAT "x(12)"   " "
                        "                  " FORMAT "x(15)" " "
                        pt_desc1 FORMAT "x(24)"       " "
                        temp_9    format "x(6)"       " "
                        temp_8   format "x(3)"        " " .

                    IF temp_1 = 0 THEN PUT "    ".
                    ELSE PUT temp_1  format "999"          " ".
                    IF temp_2 = 0 THEN PUT "    ".
                    ELSE PUT temp_2 format "999"          " ".
                    IF temp_3 = 0 THEN PUT "    ".
                    ELSE PUT temp_3 format "999"           "".
                    PUT det_um format "x(3)"          " "          
                    det_qty   format "->>>9.99"    "         "  .
                    IF temp_5 = 0 THEN PUT "    ".
                    ELSE PUT temp_5    format ">>9"        " ".
                    IF temp_6 = 0 THEN PUT "    ".
                    ELSE PUT temp_6    format ">>9"        SKIP .
                END.
 /*               disp "                  " @ shipper-po pt_part @ disp_item
                pt_desc1 @ desc1 temp_9 temp_8 temp_1 temp_2 temp_3 det_um @ abs__qad02
                det_qty temp_5 temp_6 with frame ff_det. 
                
                DOWN 1 WITH FRAME ff_det. */
                if available pt_mstr then do:
                  PUT   "        " AT 11 FORMAT "x(12)"   " "
                    "                  " FORMAT "x(15)" " "
                /*    pt_desc2 FORMAT "x(24)"*/ SKIP.     
       /*           PUT " pt_desc2 @ desc1 with frame ff_det. */
                end.  
                ELSE PUT SKIP.
  /*              down 1 with frame ff_det. */
                i1 = i1 + 1.
                find first sod_det where sod_nbr = det_order and sod_line = integer(det_line) no-lock no-error.
                find first so_mstr where so_nbr = det_order no-lock no-error.
                
                IF i1 > 11  THEN DO: /*
                  repeat:
                    i1 = i1.
                     disp line-counter.
                    if page-size - line-counter > 3 then down 1.
                    if page-size - line-counter <= 3 then leave.
                  end.                 */
                  PUT skip(6).
                    if available so_mstr then do:
                       PUT so_cust AT 100 format "x(8)" SKIP .
                    end.
                    PUT global_userid at 15 
                        year(today) at 53 format "9999"
                        month(today) at 60 format "99"
                        day(today) at 65 format "99" SKIP(6) .
                    i1 = 0.
/*yf              PUT SKIP(6).    */
         /*           PUT SKIP(3).    */

/*yf*/      ASSIGN head_4 = head_4 + 1.
/*
            DISP 
                shipper_id  
                temp_12 
                head_1  temp_num  head_2 head_4  head_3  
                billto[1] 
                billto[2] 
                ABS_shipvia 
                ABS_trans_mode 
                /* ABS_veh_ref  */
                temp_7  WITH FRAME f_head.       */

/*yf      PUT /*yf HEADER */
               SKIP(3)      
               shipper_id at 120   SKIP
               temp_12 at 80
               head_1  at 120 FORMAT "x(2)" temp_num format ">9" head_2 FORMAT "x(5)"  head_4  format ">9" head_3 FORMAT "x(2)"  SKIP(1)
               billto[1] AT 20 FORMAT "x(30)"
               billto[2] AT 87 FORMAT "x(50)" SKIP
               ABS_shipvia AT 20 FORMAT "x(16)"
               ABS_trans_mode AT 52 FORMAT "x(12)"
               ABS_veh_ref AT 87 FORMAT "x(12)"
               temp_7 AT 133 SKIP(4) . */
                   /*  PAGE. */   
                END.
/*yf  end display*/
/*K1DL*/          /* DELETING THE WORKFILE */
/*K1DL*/          for each t_absr_det exclusive-lock :
/*K1DL*/              delete t_absr_det.
/*K1DL*/          end.
                     /*yf
/*H19N*/          if i_print_sodet and v_tr_type = "ISS-SO" then do:
/*H19N*/             msgdesc = "".
/*H19N*/             if substring(abs_status,2,1) <> "y" and
/*H19N*/               not available sod_det then do:
/*H19N*/               /* DOES NOT EXIST. CANNOT CONFIRM. */
/*H19N*/               {mfmsg09.i 1868 msgdesc """" """" """"}.
/*H19N*/           msgdesc = {&sofmsv01_p_26} + det_order +
/*H19N*/                         {&sofmsv01_p_9} + string(det_line,"x(4)") + msgdesc.
/*H19N*/             end.
/*H19N*/             else  do:
/*K18J*/               if available sod_det then
/*H19N*/           msgdesc = {&sofmsv01_p_26} + sod_nbr +
/*H19N*/                         {&sofmsv01_p_9} + string(sod_line).
/*K18J*/               else
/*K18J*/           msgdesc = {&sofmsv01_p_26} + det_order +
/*K18J*/                         {&sofmsv01_p_9} + string(det_line,"x(4)").
/*H19N*/             end.
/*H19N*/             {&PAGEBREAK}
/*H19N*/             put msgdesc at 3 skip(1).
/*H19N*/          end. /* IF i_print_sodet */
                         yf*/
                  /* Print features and options for assemble-to-order items */
                    /*yf
                  if i_features            and
/*K04X*/             v_tr_type = "ISS-SO" and
                     available sod_det     and
                     sod_cfg_type = "1"
/*K04R*/          then do:
/*K04R*/             find first sob_det no-lock where
/*K04R*/                sob_nbr  = sod_nbr and
/*K04R*/                sob_line = sod_line no-error.
/*K04R*/             if available sob_det and
/*K04R*/                substring(sob_serial, 16, 1) = "Y" then do:
/*K04X*  /*K04R*/       {gprun.i ""sopkg01.p"" "("""", 0, sod_nbr, sod_line)"}  *K04X*/
/*K04X*/                {gprun.i ""sopkg01a.p"" "("""", 0, sod_nbr, sod_line)" }
/*K04R*/             end.
/*K04R*/             else do:

                        for each sob_det no-lock where
                           sob_nbr     = det_order         and
                           sob_line    = integer(det_line) and
                           (sob_parent = det_item          or
                            sob_parent = "")               and
                           sob_qty_req ne 0
                           break by sob_nbr:

                           dqty =
                              if sod_qty_ord = 0
                                 then 0
                                 else sob_qty_req / sod_qty_ord.

                           find pt_mstr no-lock where pt_part = sob_part
                              no-error.

                           {&PAGEBREAK}
                           put
                              sob_feature format "x(12)" at 5 " "
                              sob_part
                              dqty " "
                              if available pt_mstr then pt_um else "".

                           if available pt_mstr and pt_desc1 ne "" then do:
                              {&PAGEBREAK}
                              put pt_desc1 at 20 skip.
                           end.
                           if available pt_mstr and pt_desc2 ne "" then do:
                              {&PAGEBREAK}
                              put pt_desc2 at 20 skip.
                           end.

                           if last(sob_nbr) then put skip (1).

/*K04R*/                end.  /* for each sob_det */
/*K04R*/             end.  /* else */
                  end.  /* if i_features */
                  yf*/
                  /* Print components */
/*yf
                  for each t_abs_comp no-lock where
                     comp_shipfrom = det_shipfrom and
                     comp_order    = det_order    and
                     comp_line     = det_line
                     break by comp_shipfrom:

                     find pt_mstr no-lock where pt_part = comp_item no-error.

                     {&PAGEBREAK}
                     put
                        comp_item at 18
                        comp_qty  format "->>>>>>>9.9<<<<<" at 54 " "
                        if available pt_mstr then pt_um else "".

                     if available pt_mstr and pt_desc1 ne "" then do:
                        {&PAGEBREAK}
                        put pt_desc1 at 20 skip.
                     end.
                     if available pt_mstr and pt_desc2 ne "" then do:
                        {&PAGEBREAK}
                        put pt_desc2 at 20 skip.
                     end.

                     if last(comp_shipfrom) then put skip (1).

                  end.  /* for each t_abs_comp */ yf*/

                  /* Print shipper line item comments */
/*yf
                  if i_ship_comments then
                     do cmt_ctr = 1 to num-entries(cmtindx_cdl):
                     if integer(entry(cmt_ctr,cmtindx_cdl)) > 0 then do:
                       {gpcmtprt.i &type=SH
                         &id=integer(entry(cmt_ctr,cmtindx_cdl)) &pos=3}
                        put skip(1).
                     end.
                  end.  /* if i_ship_comments */  yf*/

                  cmtindx_cdl = "".

                  /* Print packing list comments */
                  if i_pack_comments       and
/*K04X*/             v_tr_type = "ISS-SO" and
                     available sod_det     and
                     sod_cmtindx > 0 then do:
 /*yf                    {gpcmtprt.i &type=PA &id=sod_cmtindx &pos=3} */
                  end.

               end. /* if last-of det_line */

 /*yf              {mfrpchk.i &warn=false} */

            end. /* for each t_abs_det */

            /* Print carrier information */
/*yf            {gprun.i ""rcrpcar.p"" "(abs_id, 1)"}     */

            /* Print trailer comments */
/*yf            if i_ship_comments and abs_trl_cmtindx > 0 then do:
               {gpcmtprt.i &type=SH &id=abs_trl_cmtindx &pos=3}
               put skip(1).
            end. */
/*yf*/          
                IF i1 < 12  and i1 <> 0 THEN DO:
                   repeat:
                     if i1 >= 12 then leave.
                     i1 = i1 + 1.
                     PUT  skip(2).
        /*             if page-size - line-counter > 3 then do:
                        down 1.
                     end.
                     if page-size - line-counter <= 4 then leave.
                      
                     */  
                    end.
                    PUT skip(6).
                    if available so_mstr then 
                        PUT so_cust AT 100 format "x(8)" SKIP .
                    ELSE PUT SKIP.
                    PUT global_userid at 15
                        year(today) at 53 format "9999"
                        month(today) at 60 format "99"
                        day(today) at 65 format "99"  /*change SKIP(3) */  .
               /*     PUT SKIP(3).   */
                                                
                    PUT SKIP(6).   /*tanweijuan changes number 6*/
                    i1 = 0.
                END.
/*yf*/
/*K04X*/    /*    page. */
/*yf            hide frame f_formhdr. */
/*yf      HIDE FRAME f_head. */

         end procedure.  /* sh_print */

         /* END OF PRINT SERVICE */


/*****************************************************************************/


/*K03J*/ /* Procedure sh_rename added */


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
 * /*K03J*/   define buffer   b_abs_mstr for  abs_mstr.
 *
 * /*K03J*/   /* Replaced all references to abs_mstr to b_abs_mstr */
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


         procedure supp_load_qad_wkfl:

            /* Read additional shipper header, line item, or trailer data */
            /* stored in a qad_wkfl record and load into local variables */

            /* INPUT PARAMETERS */
            define input parameter i_key1 like qad_key1 no-undo.
            define input parameter i_key2 like qad_key2 no-undo.

            /* OUTPUT PARAMETERS */
            define output parameter o_char as character no-undo.
            define output parameter o_int  as integer   no-undo.
            define output parameter o_dec  as decimal   no-undo.
/*H1MC**    define output parameter o_log  as logical   no-undo. */
/*H1MC*/    define output parameter o_log  like  mfc_logical   no-undo.
            define output parameter o_date as date      no-undo.


            /* PROCEDURE BODY */

            find first qad_wkfl no-lock where
               qad_key1 = i_key1 and
               qad_key2 = i_key2
               no-error.

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

         end procedure.  /* supp_load_qad_wkfl */


         /***************************************************************/


         procedure supp_save_qad_wkfl:

            /* Save additional shipper header, line item, */
            /* or trailer data to a qad_wkfl record */

            /* INPUT PARAMETERS */
            define input parameter i_key1 like qad_key1  no-undo.
            define input parameter i_key2 like qad_key2  no-undo.
            define input parameter i_char as   character no-undo.
            define input parameter i_int  as   integer   no-undo.
            define input parameter i_dec  as   decimal   no-undo.
            define input parameter i_log  as   logical   no-undo.
            define input parameter i_date as   date      no-undo.


            /* PROCEDURE BODY */

            /* Create or update a qad_wkfl record.  This is done in a */
            /* separate routine, since no DB updates are allowed in a */
            /* service encapsulation procedure. */

            {gprun.i
               ""gpqwup.p""
               "(i_key1,
                 i_key2,
                 '',
                 '',
                 '',
                 '',
                 i_char,
                 if i_log then 'Y' else 'N',
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

         end procedure.  /* supp_save_qad_wkfl */


         /***************************************************************/


         procedure supp_build_det:

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

               find b_abs_mstr no-lock where recid(b_abs_mstr) = i_abs_recid
                  no-error.

               if not available b_abs_mstr then return.

               if abs_id begins "i" then do:

/*K0KF*/          find first pt_mstr where pt_part = abs_item no-lock no-error.

                  create t_abs_det.

                  assign
                     det_item     = abs_item
                     det_order    = abs_order
                     det_line     = abs_line
                     det_qty      = abs_qty
                     det_ship_qty = abs_ship_qty
/*K0KF* /*K04X*/     det_um       = abs__qad02 */
/*J20Q** /*K0KF*/    det_um       = if available pt_mstr then pt_um */
/*J20Q** /*K0KF*/                            else abs__qad02        */
/*J20Q*/             det_um       = abs__qad02
/*J20Q*/             det_conv     = abs__qad03
                     det_cmtindx  = abs_cmtindx
                     det_id       = abs_id
                     det_shipfrom = abs_shipfrom.

               end.  /* if abs_id begins "i" */

               else do:

                  assign
                     v_abs_shipfrom = abs_shipfrom
                     v_abs_id       = abs_id.

                  for each b_abs_mstr no-lock where
                     abs_shipfrom = v_abs_shipfrom and
                     abs_par_id   = v_abs_id:

                     run supp_build_det (recid(b_abs_mstr)).

                  end.  /* for each b_abs_mstr */
               end.  /* else */
            end.  /* do for b_abs_mstr */

         end procedure.  /* supp_build_det */


         /***************************************************************/


         procedure supp_build_comp:

            /* Add/update workfile entries for kit item component quantities */

            /* INPUT PARAMETERS */
            define input parameter i_abs_shipfrom like abs_shipfrom no-undo.
            define input parameter i_abs_id       like abs_id       no-undo.
            define input parameter i_abs_order    like abs_order    no-undo.
            define input parameter i_abs_line     like abs_line     no-undo.

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

               if not available t_abs_comp then do:

                  create t_abs_comp.
                  assign
                     comp_item     = abs_item
                     comp_shipfrom = abs_shipfrom
                     comp_order    = abs_order
                     comp_line     = abs_line
                     comp_qty      = 0.

               end.  /* if not available */

               comp_qty = comp_qty + abs_qty - abs_ship_qty.

            end.    /* for each b_abs_mstr */

         end procedure.  /* supp_build_comp */


         /***************************************************************/


         procedure supp_archive_qad_wkfl:

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

            if available qad_wkfl then do:
               output stream s_history to value(i_filename) append.
               export stream s_history "qad_wkfl".
               export stream s_history qad_wkfl.
               output stream s_history close.
            end.

         end procedure.  /* supp_archive_qad_wkfl */


         /***************************************************************/


         /* < Add additional required internal support routines here > */


         /***************************************************************/


         /* END OF INTERNAL SUPPORT ROUTINES */
