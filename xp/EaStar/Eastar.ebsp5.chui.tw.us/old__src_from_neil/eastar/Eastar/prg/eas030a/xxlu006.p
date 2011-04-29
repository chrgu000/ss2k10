/************************************************************************
 * Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.
 * All rights reserved worldwide.  This is an unpublished work.
 * 
 *          File: xxlu006.p for xx006
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
* */ define shared var routseq2 as character. /*
 *    Revision: X.X     Modified: 09/19/03    By: us              *XXXX*
 *    Revision: X.X     Modified: 09/19/03    By: us              *XXXX*
 ************************************************************************/

&SCOPED-DEFINE GENERATOR-ID 1.08
&SCOPED-DEFINE COMP_REV_LEVEL XXXX

{mfdeclre.i}

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE BR-TITLE ""
/* MaxLen:  Comment: */

&SCOPED-DEFINE BR-COLUMN-LABEL-1 "庫位"
/* MaxLen: 8  Comment: */

&SCOPED-DEFINE BR-COLUMN-LABEL-2 "說明"
/* MaxLen: 24  Comment: */

&SCOPED-DEFINE BR-COLUMN-LABEL-3 "廠別"
/* MaxLen: 8  Comment: */

&SCOPED-DEFINE BR-COLUMN-LABEL-4 "類型"
/* MaxLen: 8  Comment: */

/* *********** End Translatable Strings Definitions ********** */

&SCOPED-DEFINE BR-NAME xx006
&SCOPED-DEFINE Q-DRAG-BACK-COL 1

&SCOPED-DEFINE Q-FIRST-TABLE loc_mstr
&SCOPED-DEFINE Q-FIRST-FIELD-LIST (loc_loc loc_desc loc_site loc_type)
&SCOPED-DEFINE Q-NUM-TABLES 1

&SCOPED-DEFINE Q-BROWSE-DISP-EXPR-1 loc_loc
&SCOPED-DEFINE Q-BROWSE-DEF-EXPR-1 loc_mstr.loc_loc
&SCOPED-DEFINE TT-Q-BROWSE-DEF-EXPR-1 tt-loc_loc
&SCOPED-DEFINE BR-K-COL-LABEL-1 COLUMN-LABEL
&SCOPED-DEFINE BR-FIELD-TYPE-1 character
&SCOPED-DEFINE BR-FIELD-FRMT-1 FORMAT "x(8)"
&SCOPED-DEFINE BR-FIELD-WIDTH-1 9

&SCOPED-DEFINE Q-BROWSE-DISP-EXPR-2 loc_desc
&SCOPED-DEFINE Q-BROWSE-DEF-EXPR-2 loc_mstr.loc_desc
&SCOPED-DEFINE TT-Q-BROWSE-DEF-EXPR-2 tt-loc_desc
&SCOPED-DEFINE BR-K-COL-LABEL-2 COLUMN-LABEL
&SCOPED-DEFINE BR-FIELD-TYPE-2 character
&SCOPED-DEFINE BR-FIELD-FRMT-2 FORMAT "x(24)"
&SCOPED-DEFINE BR-FIELD-WIDTH-2 25

&SCOPED-DEFINE Q-BROWSE-DISP-EXPR-3 loc_site
&SCOPED-DEFINE Q-BROWSE-DEF-EXPR-3 loc_mstr.loc_site
&SCOPED-DEFINE TT-Q-BROWSE-DEF-EXPR-3 tt-loc_site
&SCOPED-DEFINE BR-K-COL-LABEL-3 COLUMN-LABEL
&SCOPED-DEFINE BR-FIELD-TYPE-3 character
&SCOPED-DEFINE BR-FIELD-FRMT-3 FORMAT "x(8)"
&SCOPED-DEFINE BR-FIELD-WIDTH-3 9

&SCOPED-DEFINE Q-BROWSE-DISP-EXPR-4 loc_type
&SCOPED-DEFINE Q-BROWSE-DEF-EXPR-4 loc_mstr.loc_type
&SCOPED-DEFINE TT-Q-BROWSE-DEF-EXPR-4 tt-loc_type
&SCOPED-DEFINE BR-K-COL-LABEL-4 COLUMN-LABEL
&SCOPED-DEFINE BR-FIELD-TYPE-4 character
&SCOPED-DEFINE BR-FIELD-FRMT-4 FORMAT "x(8)"
&SCOPED-DEFINE BR-FIELD-WIDTH-4 9

&SCOPED-DEFINE Q-NUM-FILT-VALS 4
&SCOPED-DEFINE BR-MAX-FIELD-WIDTH 25
&SCOPED-DEFINE BR-BROWSE-WIDTH 52
&SCOPED-DEFINE WHERE-CLAUSE loc_type = routseq2
&SCOPED-DEFINE BR-INDEXED-FIELDS 1,3

{wbbr01.i &string-4 = 'LOOKUP'}
if c-application-mode <> 'WEB' then do:
   {lookup.i}
end.


{crevlvl.i}
