/************************************************************************
 * Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.
 * All rights reserved worldwide.  This is an unpublished work.
 * 
 *          File: xxlu678.p for xx678
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
 *    Revision: X.X     Modified: 05/28/03    By: apple              *XXXX*
*/ define shared variable vppart like vp_part. /*
 *    Revision: X.X     Modified: 05/28/03    By: apple              *XXXX*
 ************************************************************************/

&SCOPED-DEFINE GENERATOR-ID 1.08
&SCOPED-DEFINE COMP_REV_LEVEL XXXX

{mfdeclre.i}

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE BR-TITLE ""
/* MaxLen:  Comment: */

&SCOPED-DEFINE BR-COLUMN-LABEL-1 "Supplier Item"
/* MaxLen: 40  Comment: */

&SCOPED-DEFINE BR-COLUMN-LABEL-2 "Item Number"
/* MaxLen: 18  Comment: */

/* *********** End Translatable Strings Definitions ********** */

&SCOPED-DEFINE BR-NAME xx678
&SCOPED-DEFINE Q-DRAG-BACK-COL 1

&SCOPED-DEFINE Q-FIRST-TABLE xxvend_det
&SCOPED-DEFINE Q-FIRST-FIELD-LIST (xxvend_vd_part xxvend_pt_part)
&SCOPED-DEFINE Q-NUM-TABLES 1

&SCOPED-DEFINE Q-BROWSE-DISP-EXPR-1 xxvend_vd_part
&SCOPED-DEFINE Q-BROWSE-DEF-EXPR-1 xxvend_det.xxvend_vd_part
&SCOPED-DEFINE TT-Q-BROWSE-DEF-EXPR-1 tt-xxvend_vd_part
&SCOPED-DEFINE BR-K-COL-LABEL-1 COLUMN-LABEL
&SCOPED-DEFINE BR-FIELD-TYPE-1 character
&SCOPED-DEFINE BR-FIELD-FRMT-1 FORMAT "x(40)"
&SCOPED-DEFINE BR-FIELD-WIDTH-1 41

&SCOPED-DEFINE Q-BROWSE-DISP-EXPR-2 xxvend_pt_part
&SCOPED-DEFINE Q-BROWSE-DEF-EXPR-2 xxvend_det.xxvend_pt_part
&SCOPED-DEFINE TT-Q-BROWSE-DEF-EXPR-2 tt-xxvend_pt_part
&SCOPED-DEFINE BR-K-COL-LABEL-2 COLUMN-LABEL
&SCOPED-DEFINE BR-FIELD-TYPE-2 character
&SCOPED-DEFINE BR-FIELD-FRMT-2 FORMAT "x(18)"
&SCOPED-DEFINE BR-FIELD-WIDTH-2 19

&SCOPED-DEFINE Q-NUM-FILT-VALS 2
&SCOPED-DEFINE BR-MAX-FIELD-WIDTH 41
&SCOPED-DEFINE BR-BROWSE-WIDTH 60
&SCOPED-DEFINE WHERE-CLAUSE xxvend_pt_part = vppart
&SCOPED-DEFINE BR-INDEXED-FIELDS 1,2

{wbbr01.i &string-4 = 'LOOKUP'}
if c-application-mode <> 'WEB' then do:
   {lookup.i}
end.


{crevlvl.i}
