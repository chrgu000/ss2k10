/************************************************************************
 * COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK.
 * 
 *          File: zzlu901.p for zz901
 * 
 *   Description: Default Vendor
 * 
 *   Object Type: Lookup UI
 * 
 * Primary Table: N/A
 * 
 *   Input Parms: <none>
 * 
 *  Output Parms: <none>
 * 
 *  Browse Generator ID: 1.05
 * 
 ************************************************************************/

/******************************** Tokens ********************************/
/*V8:ConvertMode=NoConvert                                              */
/*V8:ClientServerMode=Client                                            */
/************************************************************************/

/******************************** History *******************************
 *      Revision: 8.5      Created: 04/01/14 19:01    By: johnqi      **
 ************************************************************************/

&SCOPED-DEFINE GENERATOR-ID 1.05
&SCOPED-DEFINE COMP_REV_LEVEL 

{mfdeclre.i}

&SCOPED-DEFINE BR-TITLE "Default Vendor"
&SCOPED-DEFINE BR-NAME zz901
&SCOPED-DEFINE Q-DRAG-BACK-COL 1

&SCOPED-DEFINE Q-FIRST-TABLE xxvp_mstr
&SCOPED-DEFINE Q-FIRST-FIELD-LIST (xxvp_vend xxvp_part xxvp_rmks)
&SCOPED-DEFINE Q-NUM-TABLES 1

&SCOPED-DEFINE Q-BROWSE-DISP-EXPR-1 xxvp_vend
&SCOPED-DEFINE Q-BROWSE-DEF-EXPR-1 xxvp_mstr.xxvp_vend
&SCOPED-DEFINE TT-Q-BROWSE-DEF-EXPR-1 tt-xxvp_vend
&SCOPED-DEFINE BR-K-COL-LABEL-1 COLUMN-LABEL
&SCOPED-DEFINE BR-COLUMN-LABEL-1 "供应商"
&SCOPED-DEFINE BR-FIELD-TYPE-1 character
&SCOPED-DEFINE BR-FIELD-FRMT-1 FORMAT "X(8)"
&SCOPED-DEFINE BR-FIELD-WIDTH-1 9

&SCOPED-DEFINE Q-BROWSE-DISP-EXPR-2 xxvp_part
&SCOPED-DEFINE Q-BROWSE-DEF-EXPR-2 xxvp_mstr.xxvp_part
&SCOPED-DEFINE TT-Q-BROWSE-DEF-EXPR-2 tt-xxvp_part
&SCOPED-DEFINE BR-K-COL-LABEL-2 COLUMN-LABEL
&SCOPED-DEFINE BR-COLUMN-LABEL-2 "零件号"
&SCOPED-DEFINE BR-FIELD-TYPE-2 character
&SCOPED-DEFINE BR-FIELD-FRMT-2 FORMAT "X(18)"
&SCOPED-DEFINE BR-FIELD-WIDTH-2 19

&SCOPED-DEFINE Q-BROWSE-DISP-EXPR-3 xxvp_rmks
&SCOPED-DEFINE Q-BROWSE-DEF-EXPR-3 xxvp_mstr.xxvp_rmks
&SCOPED-DEFINE TT-Q-BROWSE-DEF-EXPR-3 tt-xxvp_rmks
&SCOPED-DEFINE BR-K-COL-LABEL-3 COLUMN-LABEL
&SCOPED-DEFINE BR-COLUMN-LABEL-3 "备注"
&SCOPED-DEFINE BR-FIELD-TYPE-3 character
&SCOPED-DEFINE BR-FIELD-FRMT-3 FORMAT "X(40)"
&SCOPED-DEFINE BR-FIELD-WIDTH-3 41

&SCOPED-DEFINE Q-NUM-FILT-VALS 3
&SCOPED-DEFINE BR-MAX-FIELD-WIDTH 41
&SCOPED-DEFINE BR-BROWSE-WIDTH 69
&SCOPED-DEFINE BR-INDEXED-FIELDS 1,2

{lookup.i}
{crevlvl.i}
