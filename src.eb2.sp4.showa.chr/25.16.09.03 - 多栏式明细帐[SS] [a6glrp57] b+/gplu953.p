/* gplu953.p - 名称 Lookup UI                                               */
/* Copyright 1986-2008 QAD Inc., Carpinteria, CA, USA.                      */
/* All rights reserved worldwide.  This is an unpublished work.             */
/* $Revision: 1.71.1.2 $    */
/*V8:ConvertMode=NoConvert                                                  */
/********************************** History *********************************
 ****************************************************************************/

{mfdeclre.i}

&SCOPED-DEFINE BR-TITLE "名称"

&SCOPED-DEFINE BR-NAME gp953
&SCOPED-DEFINE Q-DRAG-BACK-COL 1

&SCOPED-DEFINE Q-FIRST-TABLE xxac_det
&SCOPED-DEFINE Q-FIRST-FIELD-LIST (xxac_code xxac_code_desc xxac_name xxac_name_desc)
&SCOPED-DEFINE Q-NUM-TABLES 1

&SCOPED-DEFINE Q-BROWSE-DISP-EXPR-1 b-1.xxac_code
&SCOPED-DEFINE Q-BROWSE-DEF-EXPR-1 xxac_det.xxac_code
&SCOPED-DEFINE TT-Q-BROWSE-DEF-EXPR-1 tt-xxac_code
&SCOPED-DEFINE BR-K-COL-LABEL-1 COLUMN-LABEL
&SCOPED-DEFINE BR-COLUMN-LABEL-1 "代码"
&SCOPED-DEFINE BR-FIELD-TYPE-1 character
&SCOPED-DEFINE BR-FIELD-FRMT-1 FORMAT "x(4)"
&SCOPED-DEFINE BR-FIELD-WIDTH-1 5

&SCOPED-DEFINE Q-BROWSE-DISP-EXPR-2 b-1.xxac_code_desc
&SCOPED-DEFINE Q-BROWSE-DEF-EXPR-2 xxac_det.xxac_code_desc
&SCOPED-DEFINE TT-Q-BROWSE-DEF-EXPR-2 tt-xxac_code_desc
&SCOPED-DEFINE BR-K-COL-LABEL-2 COLUMN-LABEL
&SCOPED-DEFINE BR-COLUMN-LABEL-2 "名称"
&SCOPED-DEFINE BR-FIELD-TYPE-2 character
&SCOPED-DEFINE BR-FIELD-FRMT-2 FORMAT "x(16)"
&SCOPED-DEFINE BR-FIELD-WIDTH-2 17

&SCOPED-DEFINE Q-BROWSE-DISP-EXPR-3 b-1.xxac_name
&SCOPED-DEFINE Q-BROWSE-DEF-EXPR-3 xxac_det.xxac_name
&SCOPED-DEFINE TT-Q-BROWSE-DEF-EXPR-3 tt-xxac_name
&SCOPED-DEFINE BR-K-COL-LABEL-3 COLUMN-LABEL
&SCOPED-DEFINE BR-COLUMN-LABEL-3 "名称"
&SCOPED-DEFINE BR-FIELD-TYPE-3 character
&SCOPED-DEFINE BR-FIELD-FRMT-3 FORMAT "x(8)"
&SCOPED-DEFINE BR-FIELD-WIDTH-3 9

&SCOPED-DEFINE Q-BROWSE-DISP-EXPR-4 b-1.xxac_name_desc
&SCOPED-DEFINE Q-BROWSE-DEF-EXPR-4 xxac_det.xxac_name_desc
&SCOPED-DEFINE TT-Q-BROWSE-DEF-EXPR-4 tt-xxac_name_desc
&SCOPED-DEFINE BR-K-COL-LABEL-4 COLUMN-LABEL
&SCOPED-DEFINE BR-COLUMN-LABEL-4 "描述"
&SCOPED-DEFINE BR-FIELD-TYPE-4 character
&SCOPED-DEFINE BR-FIELD-FRMT-4 FORMAT "x(24)"
&SCOPED-DEFINE BR-FIELD-WIDTH-4 25

&SCOPED-DEFINE Q-NUM-FILT-VALS 4
&SCOPED-DEFINE BR-MAX-FIELD-WIDTH 25
&SCOPED-DEFINE BR-BROWSE-WIDTH 56
&SCOPED-DEFINE WHERE-CLAUSE 
&SCOPED-DEFINE BR-INDEXED-FIELDS 1

{wbbr01.i &string-4 = 'LOOKUP'}
if c-application-mode <> 'WEB' then do:
   {lookup.i}
end.


