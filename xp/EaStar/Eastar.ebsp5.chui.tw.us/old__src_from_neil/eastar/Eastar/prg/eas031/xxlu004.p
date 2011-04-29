/************************************************************************
 * Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.
 * All rights reserved worldwide.  This is an unpublished work.
 * 
 *          File: xxlu004.p for xx004
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
 *  Revision:   Created: 09/16/03 15:02  **  By: APPLE
 ************************************************************************/

&SCOPED-DEFINE GENERATOR-ID 1.08
&SCOPED-DEFINE COMP_REV_LEVEL 

{mfdeclre.i}

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE BR-TITLE ""
/* MaxLen:  Comment: */

&SCOPED-DEFINE BR-COLUMN-LABEL-1 "Method code"
/* MaxLen: 11  Comment: */

/* *********** End Translatable Strings Definitions ********** */

&SCOPED-DEFINE BR-NAME xx004
&SCOPED-DEFINE Q-DRAG-BACK-COL 1

&SCOPED-DEFINE Q-FIRST-TABLE ship_mt_mstr
&SCOPED-DEFINE Q-FIRST-FIELD-LIST (ship_mt_code)
&SCOPED-DEFINE Q-NUM-TABLES 1

&SCOPED-DEFINE Q-BROWSE-DISP-EXPR-1 ship_mt_code
&SCOPED-DEFINE Q-BROWSE-DEF-EXPR-1 ship_mt_mstr.ship_mt_code
&SCOPED-DEFINE TT-Q-BROWSE-DEF-EXPR-1 tt-ship_mt_code
&SCOPED-DEFINE BR-K-COL-LABEL-1 COLUMN-LABEL
&SCOPED-DEFINE BR-FIELD-TYPE-1 character
&SCOPED-DEFINE BR-FIELD-FRMT-1 FORMAT "x(8)"
&SCOPED-DEFINE BR-FIELD-WIDTH-1 12

&SCOPED-DEFINE Q-NUM-FILT-VALS 1
&SCOPED-DEFINE BR-MAX-FIELD-WIDTH 12
&SCOPED-DEFINE BR-BROWSE-WIDTH 12
&SCOPED-DEFINE WHERE-CLAUSE 
&SCOPED-DEFINE BR-INDEXED-FIELDS 1

{wbbr01.i &string-4 = 'LOOKUP'}
if c-application-mode <> 'WEB' then do:
   {lookup.i}
end.


{crevlvl.i}
