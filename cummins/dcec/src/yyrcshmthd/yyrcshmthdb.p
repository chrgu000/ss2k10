/* GUI CONVERTED from icshmt.p (converter v1.77) Wed Sep 17 02:26:27 2003 */
/* icshmt.p - Multi-Transaction Shipper Maintenance                           */
/* Copyright 1986-2003 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.20.1.1 $                                                               */
/*V8:ConvertMode=Maintenance                                                  */
/* REVISION: 8.6      LAST MODIFIED: 03/15/97   BY: *K04X* Steve Goeke        */
/* REVISION: 8.6      LAST MODIFIED: 04/09/97   BY: *K08N* Steve Goeke        */
/* REVISION: 8.6      LAST MODIFIED: 04/22/97   BY: *K0C5* Taek-Soo Chang     */
/* REVISION: 8.6      LAST MODIFIED: 09/26/97   BY: *K0K1* John Worden        */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane          */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan         */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan         */
/* REVISION: 8.6E     LAST MODIFIED: 11/10/98   BY: *K1Y6* Seema Varma        */
/* REVISION: 9.0      LAST MODIFIED: 03/10/99   BY: *M0B8* Hemanth Ebenezer   */
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan         */
/* REVISION: 9.1      LAST MODIFIED: 10/25/99   BY: *N002* Bill Gates         */
/* REVISION: 9.1      LAST MODIFIED: 11/07/99   BY: *L0L4* Michael Amaladhas  */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1      LAST MODIFIED: 08/13/00   BY: *N0KS* myb                */
/* REVISION: 9.1      LAST MODIFIED: 09/29/00   BY: *N0W6* Mudit Mehta        */
/* Revision: 1.16     BY: Ellen Borden          DATE: 07/09/01   ECO: *P007*  */
/* Revision: 1.17     BY: Katie Hilbert         DATE: 12/05/01   ECO: *P03C*  */
/* Revision: 1.18     BY: Samir Bavkar          DATE: 08/15/02   ECO: *P09K*  */
/* Revision: 1.19     BY: Ashish Maheshwari     DATE: 12/03/02   ECO: *N214*  */
/* Revision: 1.20     BY: Kirti Desai           DATE: 04/16/03   ECO: *P0Q0*  */
/* $Revision: 1.20.1.1 $       BY: Sunil Fegade          DATE: 09/15/03   ECO: *P134*  */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

{mfdeclre.i}
{cxcustom.i "ICSHMT.P"}
{gplabel.i}    /* EXTERNAL LABEL INCLUDE */
{apconsdf.i}   /* PRE-PROCESSOR CONSTANTS FOR LOGISTICS ACCOUNTING */

/* INPUT PARAMETERS */
define input parameter inp_recid AS RECID NO-UNDO.


FIND FIRST ABS_mstr WHERE recid(ABS_mstr) = inp_recid NO-ERROR.
IF NOT AVAILABLE ABS_mstr THEN LEAVE.

DEFINE VARIABLE v_shp_date LIKE ABS_shp_date.
DEFINE VARIABLE v_arr_date LIKE ABS_arr_date.
DEFINE VARIABLE v_shp_time AS CHARACTER FORMAT "99:99".
DEFINE VARIABLE v_arr_time AS CHARACTER FORMAT "99:99".

FORM /*GUI*/ 
    v_shp_date COLON 20
    v_shp_time  COLON 20 LABEL "时间"
    v_arr_date COLON 20
    v_arr_time COLON 20 LABEL "时间"
    with frame aaa CENTER OVERLAY side-labels width 80 attr-space
    THREE-D /*GUI*/.

ASSIGN
    v_shp_date = abs_shp_date
    v_shp_time = SUBstring(STRING(ABS_shp_time,"HH:MM"),1,2) + SUBstring(STRING(ABS_shp_time,"HH:MM"),4,2)
    v_arr_date = ABS_arr_date
    v_arr_time = SUBSTRING(STRING(ABS_arr_time,"HH:MM"),1,2) + SUBSTRING(STRING(ABS_arr_time,"HH:MM"),4,2)
    .


DISP 
    v_shp_date
    v_shp_time
    v_arr_date
    v_arr_time
    WITH FRAME aaa.


UPDATE 
    v_shp_date VALIDATE(v_shp_date <> ?, "请输入发货日期")
    v_shp_time
    v_arr_date VALIDATE(v_arr_date <> ?, "请输入预计到达日期")
    v_arr_time
    WITH FRAME aaa.

ASSIGN
    ABS_shp_date = v_shp_date
    ABS_arr_date = v_arr_date
    ABS_shp_time = integer(SUBSTRING(v_shp_time,1,2)) * 3600 + integer(SUBSTRING(v_shp_time,3,2)) * 60
    ABS_arr_time = integer(SUBSTRING(v_arr_time,1,2)) * 3600 + integer(SUBSTRING(v_arr_time,3,2)) * 60
    .
HIDE FRAME aaa NO-PAUSE.
