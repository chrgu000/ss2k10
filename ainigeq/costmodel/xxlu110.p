/* xxlu110.p - 分配因素 Lookup UI                                           */
/* Copyright 1986-2010 QAD Inc., Carpinteria, CA, USA.                      */
/* All rights reserved worldwide.  This is an unpublished work.             */
/* $Revision: 1.71.1.8 $    */
/*V8:ConvertMode=NoConvert                                                  */
/********************************** History *********************************
 * $Revision: 1.2 $    Default User             DATE: 09/07/10  ECO: *XXXX*
 ****************************************************************************/

{mfdeclre.i}

&SCOPED-DEFINE BR-TITLE "分配因素"

&SCOPED-DEFINE BR-NAME xx110
&SCOPED-DEFINE Q-DRAG-BACK-COL 1

&SCOPED-DEFINE Q-FIRST-TABLE code_mstr
&SCOPED-DEFINE Q-FIRST-FIELD-LIST (code_value code_cmmt code__qadc01)
&SCOPED-DEFINE Q-NUM-TABLES 1

&SCOPED-DEFINE Q-BROWSE-DISP-EXPR-1 b-1.code_value
&SCOPED-DEFINE Q-BROWSE-DEF-EXPR-1 code_mstr.code_value
&SCOPED-DEFINE TT-Q-BROWSE-DEF-EXPR-1 tt-code_value
&SCOPED-DEFINE BR-K-COL-LABEL-1 COLUMN-LABEL
&SCOPED-DEFINE BR-COLUMN-LABEL-1 "分配因素"
&SCOPED-DEFINE BR-FIELD-TYPE-1 character
&SCOPED-DEFINE BR-FIELD-FRMT-1 FORMAT "x(14)"
&SCOPED-DEFINE BR-FIELD-WIDTH-1 15

&SCOPED-DEFINE Q-BROWSE-DISP-EXPR-2 b-1.code_cmmt
&SCOPED-DEFINE Q-BROWSE-DEF-EXPR-2 code_mstr.code_cmmt
&SCOPED-DEFINE TT-Q-BROWSE-DEF-EXPR-2 tt-code_cmmt
&SCOPED-DEFINE BR-K-COL-LABEL-2 COLUMN-LABEL
&SCOPED-DEFINE BR-COLUMN-LABEL-2 "说明"
&SCOPED-DEFINE BR-FIELD-TYPE-2 character
&SCOPED-DEFINE BR-FIELD-FRMT-2 FORMAT "x(12)"
&SCOPED-DEFINE BR-FIELD-WIDTH-2 13

&SCOPED-DEFINE Q-BROWSE-DISP-EXPR-3 b-1.code__qadc01
&SCOPED-DEFINE Q-BROWSE-DEF-EXPR-3 code_mstr.code__qadc01
&SCOPED-DEFINE TT-Q-BROWSE-DEF-EXPR-3 tt-code__qadc01
&SCOPED-DEFINE BR-K-COL-LABEL-3 COLUMN-LABEL
&SCOPED-DEFINE BR-COLUMN-LABEL-3 "因"
&SCOPED-DEFINE BR-FIELD-TYPE-3 character
&SCOPED-DEFINE BR-FIELD-FRMT-3 FORMAT "X(3)"
&SCOPED-DEFINE BR-FIELD-WIDTH-3 4

&SCOPED-DEFINE Q-NUM-FILT-VALS 3
&SCOPED-DEFINE BR-MAX-FIELD-WIDTH 15
&SCOPED-DEFINE BR-BROWSE-WIDTH 32
&SCOPED-DEFINE WHERE-CLAUSE code_fldname = 'xxdcs_element' and code__qadc01 = ''
&SCOPED-DEFINE BR-INDEXED-FIELDS 1

{wbbr01.i &string-4 = 'LOOKUP'}
if c-application-mode <> 'WEB' then do:
   {lookup.i}
end.


