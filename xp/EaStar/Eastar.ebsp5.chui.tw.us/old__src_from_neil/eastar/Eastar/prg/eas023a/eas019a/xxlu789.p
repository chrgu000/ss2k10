/************************************************************************
 * Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.
 * All rights reserved worldwide.  This is an unpublished work.
 * 
 *          File: xxlu789.p for xx789
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
 *  Revision:   Created: 05/27/03 10:58  **  By: APPLE
 ************************************************************************/

&SCOPED-DEFINE GENERATOR-ID 1.08
&SCOPED-DEFINE COMP_REV_LEVEL 

{mfdeclre.i}

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE BR-TITLE ""
/* MaxLen:  Comment: */

&SCOPED-DEFINE BR-COLUMN-LABEL-1 "供應商料品"
/* MaxLen: 30  Comment: */

&SCOPED-DEFINE BR-COLUMN-LABEL-2 "供應商"
/* MaxLen: 8  Comment: */

&SCOPED-DEFINE BR-COLUMN-LABEL-3 "料號"
/* MaxLen: 18  Comment: */

/* *********** End Translatable Strings Definitions ********** */

&SCOPED-DEFINE BR-NAME xx789
&SCOPED-DEFINE Q-DRAG-BACK-COL 1

&SCOPED-DEFINE Q-FIRST-TABLE vp_mstr
&SCOPED-DEFINE Q-FIRST-FIELD-LIST (vp_vend_part vp_vend vp_part)
&SCOPED-DEFINE Q-NUM-TABLES 1

&SCOPED-DEFINE Q-BROWSE-DISP-EXPR-1 vp_vend_part
&SCOPED-DEFINE Q-BROWSE-DEF-EXPR-1 vp_mstr.vp_vend_part
&SCOPED-DEFINE TT-Q-BROWSE-DEF-EXPR-1 tt-vp_vend_part
&SCOPED-DEFINE BR-K-COL-LABEL-1 COLUMN-LABEL
&SCOPED-DEFINE BR-FIELD-TYPE-1 character
&SCOPED-DEFINE BR-FIELD-FRMT-1 FORMAT "x(30)"
&SCOPED-DEFINE BR-FIELD-WIDTH-1 31

&SCOPED-DEFINE Q-BROWSE-DISP-EXPR-2 vp_vend
&SCOPED-DEFINE Q-BROWSE-DEF-EXPR-2 vp_mstr.vp_vend
&SCOPED-DEFINE TT-Q-BROWSE-DEF-EXPR-2 tt-vp_vend
&SCOPED-DEFINE BR-K-COL-LABEL-2 COLUMN-LABEL
&SCOPED-DEFINE BR-FIELD-TYPE-2 character
&SCOPED-DEFINE BR-FIELD-FRMT-2 FORMAT "x(8)"
&SCOPED-DEFINE BR-FIELD-WIDTH-2 9

&SCOPED-DEFINE Q-BROWSE-DISP-EXPR-3 vp_part
&SCOPED-DEFINE Q-BROWSE-DEF-EXPR-3 vp_mstr.vp_part
&SCOPED-DEFINE TT-Q-BROWSE-DEF-EXPR-3 tt-vp_part
&SCOPED-DEFINE BR-K-COL-LABEL-3 COLUMN-LABEL
&SCOPED-DEFINE BR-FIELD-TYPE-3 character
&SCOPED-DEFINE BR-FIELD-FRMT-3 FORMAT "x(18)"
&SCOPED-DEFINE BR-FIELD-WIDTH-3 19

&SCOPED-DEFINE Q-NUM-FILT-VALS 3
&SCOPED-DEFINE BR-MAX-FIELD-WIDTH 31
&SCOPED-DEFINE BR-BROWSE-WIDTH 59
&SCOPED-DEFINE WHERE-CLAUSE vp_vend = global_addr and vp_part = global_part
&SCOPED-DEFINE BR-INDEXED-FIELDS 1,2,3

{wbbr01.i &string-4 = 'LOOKUP'}
if c-application-mode <> 'WEB' then do:
   {lookup.i}
end.


{crevlvl.i}
