/************************************************************************
 * Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.
 * All rights reserved worldwide.  This is an unpublished work.
 * 
 *          File: xxlu190.p for xx190
 * 
 *   Description: 
 * 
 *   Object Type: Lookup UI
 * 
 * Primary Table: N/A
 * 
 *   Input Parms: <none>
 * 
 *  Output Parms: <none>
 * 
 *  Browse Generator ID: 1.08
 * 
 ************************************************************************/

/******************************** Tokens ********************************/
/*V8:ConvertMode=NoConvert                                              */
/*V8:ClientServerMode=Client                                            */
/*V8:RunMode=Character,Windows                                          */
/************************************************************************/

/******************************** History *******************************
 *  Revision:   Created: 07/26/07 12:34  **  By: MFG
 ************************************************************************/

&SCOPED-DEFINE GENERATOR-ID 1.08
&SCOPED-DEFINE COMP_REV_LEVEL 

{mfdeclre.i}

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE BR-TITLE ""
/* MaxLen:  Comment: */

&SCOPED-DEFINE BR-COLUMN-LABEL-1 "价格单"
/* MaxLen: 8  Comment: */

&SCOPED-DEFINE BR-COLUMN-LABEL-2 "货币"
/* MaxLen: 4  Comment: */

&SCOPED-DEFINE BR-COLUMN-LABEL-3 "产品类"
/* MaxLen: 6  Comment: */

&SCOPED-DEFINE BR-COLUMN-LABEL-4 "零件号"
/* MaxLen: 18  Comment: */

&SCOPED-DEFINE BR-COLUMN-LABEL-5 "起始日"
/* MaxLen: 8  Comment: */

&SCOPED-DEFINE BR-COLUMN-LABEL-6 "单位"
/* MaxLen: 4  Comment: */

/* *********** End Translatable Strings Definitions ********** */

&SCOPED-DEFINE BR-NAME xx190
&SCOPED-DEFINE Q-DRAG-BACK-COL 1

&SCOPED-DEFINE Q-FIRST-TABLE pc_mstr
&SCOPED-DEFINE Q-FIRST-FIELD-LIST (pc_list pc_curr pc_prod_line pc_part pc_start pc_um)
&SCOPED-DEFINE Q-NUM-TABLES 1

&SCOPED-DEFINE Q-BROWSE-DISP-EXPR-1 pc_list
&SCOPED-DEFINE Q-BROWSE-DEF-EXPR-1 pc_mstr.pc_list
&SCOPED-DEFINE TT-Q-BROWSE-DEF-EXPR-1 tt-pc_list
&SCOPED-DEFINE BR-K-COL-LABEL-1 COLUMN-LABEL
&SCOPED-DEFINE BR-FIELD-TYPE-1 character
&SCOPED-DEFINE BR-FIELD-FRMT-1 FORMAT "x(8)"
&SCOPED-DEFINE BR-FIELD-WIDTH-1 9

&SCOPED-DEFINE Q-BROWSE-DISP-EXPR-2 pc_curr
&SCOPED-DEFINE Q-BROWSE-DEF-EXPR-2 pc_mstr.pc_curr
&SCOPED-DEFINE TT-Q-BROWSE-DEF-EXPR-2 tt-pc_curr
&SCOPED-DEFINE BR-K-COL-LABEL-2 COLUMN-LABEL
&SCOPED-DEFINE BR-FIELD-TYPE-2 character
&SCOPED-DEFINE BR-FIELD-FRMT-2 FORMAT "x(3)"
&SCOPED-DEFINE BR-FIELD-WIDTH-2 5

&SCOPED-DEFINE Q-BROWSE-DISP-EXPR-3 pc_prod_line
&SCOPED-DEFINE Q-BROWSE-DEF-EXPR-3 pc_mstr.pc_prod_line
&SCOPED-DEFINE TT-Q-BROWSE-DEF-EXPR-3 tt-pc_prod_line
&SCOPED-DEFINE BR-K-COL-LABEL-3 COLUMN-LABEL
&SCOPED-DEFINE BR-FIELD-TYPE-3 character
&SCOPED-DEFINE BR-FIELD-FRMT-3 FORMAT "x(4)"
&SCOPED-DEFINE BR-FIELD-WIDTH-3 7

&SCOPED-DEFINE Q-BROWSE-DISP-EXPR-4 pc_part
&SCOPED-DEFINE Q-BROWSE-DEF-EXPR-4 pc_mstr.pc_part
&SCOPED-DEFINE TT-Q-BROWSE-DEF-EXPR-4 tt-pc_part
&SCOPED-DEFINE BR-K-COL-LABEL-4 COLUMN-LABEL
&SCOPED-DEFINE BR-FIELD-TYPE-4 character
&SCOPED-DEFINE BR-FIELD-FRMT-4 FORMAT "x(18)"
&SCOPED-DEFINE BR-FIELD-WIDTH-4 19

&SCOPED-DEFINE Q-BROWSE-DISP-EXPR-5 pc_start
&SCOPED-DEFINE Q-BROWSE-DEF-EXPR-5 pc_mstr.pc_start
&SCOPED-DEFINE TT-Q-BROWSE-DEF-EXPR-5 tt-pc_start
&SCOPED-DEFINE BR-K-COL-LABEL-5 COLUMN-LABEL
&SCOPED-DEFINE BR-FIELD-TYPE-5 date
&SCOPED-DEFINE BR-FIELD-FRMT-5 FORMAT "99/99/99"
&SCOPED-DEFINE BR-FIELD-WIDTH-5 9

&SCOPED-DEFINE Q-BROWSE-DISP-EXPR-6 pc_um
&SCOPED-DEFINE Q-BROWSE-DEF-EXPR-6 pc_mstr.pc_um
&SCOPED-DEFINE TT-Q-BROWSE-DEF-EXPR-6 tt-pc_um
&SCOPED-DEFINE BR-K-COL-LABEL-6 COLUMN-LABEL
&SCOPED-DEFINE BR-FIELD-TYPE-6 character
&SCOPED-DEFINE BR-FIELD-FRMT-6 FORMAT "x(2)"
&SCOPED-DEFINE BR-FIELD-WIDTH-6 5

&SCOPED-DEFINE Q-NUM-FILT-VALS 6
&SCOPED-DEFINE BR-MAX-FIELD-WIDTH 19
&SCOPED-DEFINE BR-BROWSE-WIDTH 54
&SCOPED-DEFINE WHERE-CLAUSE pc_amt_type = 'L' or pc_amt_type = 'P'
&SCOPED-DEFINE BR-INDEXED-FIELDS 1,3,4

{wbbr01.i &string-4 = 'LOOKUP'}
if c-application-mode <> 'WEB' then do:
   {lookup.i}
end.


{crevlvl.i}
