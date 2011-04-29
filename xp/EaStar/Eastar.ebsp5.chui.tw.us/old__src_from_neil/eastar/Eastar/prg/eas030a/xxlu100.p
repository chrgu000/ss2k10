/************************************************************************
 * Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.
 * All rights reserved worldwide.  This is an unpublished work.
 * 
 *          File: xxlu100.p for xx100
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
 *  Revision:   Created: 09/22/03 17:21  **  By: US
 ************************************************************************/

&SCOPED-DEFINE GENERATOR-ID 1.08
&SCOPED-DEFINE COMP_REV_LEVEL 

{mfdeclre.i}

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE BR-TITLE ""
/* MaxLen:  Comment: */

&SCOPED-DEFINE BR-COLUMN-LABEL-1 "可輸入值"
/* MaxLen: 8  Comment: */

&SCOPED-DEFINE BR-COLUMN-LABEL-2 "欄位名稱"
/* MaxLen: 32  Comment: */

/* *********** End Translatable Strings Definitions ********** */

&SCOPED-DEFINE BR-NAME xx100
&SCOPED-DEFINE Q-DRAG-BACK-COL 1

&SCOPED-DEFINE Q-FIRST-TABLE code_mstr
&SCOPED-DEFINE Q-FIRST-FIELD-LIST (code_value code_fldname)
&SCOPED-DEFINE Q-NUM-TABLES 1

&SCOPED-DEFINE Q-BROWSE-DISP-EXPR-1 code_value
&SCOPED-DEFINE Q-BROWSE-DEF-EXPR-1 code_mstr.code_value
&SCOPED-DEFINE TT-Q-BROWSE-DEF-EXPR-1 tt-code_value
&SCOPED-DEFINE BR-K-COL-LABEL-1 COLUMN-LABEL
&SCOPED-DEFINE BR-FIELD-TYPE-1 character
&SCOPED-DEFINE BR-FIELD-FRMT-1 FORMAT "x(8)"
&SCOPED-DEFINE BR-FIELD-WIDTH-1 9

&SCOPED-DEFINE Q-BROWSE-DISP-EXPR-2 code_fldname
&SCOPED-DEFINE Q-BROWSE-DEF-EXPR-2 code_mstr.code_fldname
&SCOPED-DEFINE TT-Q-BROWSE-DEF-EXPR-2 tt-code_fldname
&SCOPED-DEFINE BR-K-COL-LABEL-2 COLUMN-LABEL
&SCOPED-DEFINE BR-FIELD-TYPE-2 character
&SCOPED-DEFINE BR-FIELD-FRMT-2 FORMAT "x(32)"
&SCOPED-DEFINE BR-FIELD-WIDTH-2 33

&SCOPED-DEFINE Q-NUM-FILT-VALS 2
&SCOPED-DEFINE BR-MAX-FIELD-WIDTH 33
&SCOPED-DEFINE BR-BROWSE-WIDTH 42
&SCOPED-DEFINE WHERE-CLAUSE code_fldname = 'loc_type' 
&SCOPED-DEFINE BR-INDEXED-FIELDS 1,2

{wbbr01.i &string-4 = 'LOOKUP'}
if c-application-mode <> 'WEB' then do:
   {lookup.i}
end.


{crevlvl.i}
