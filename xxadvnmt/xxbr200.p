/* xxbr200.p - �ͻ���ʽ Browse UI                                           */
/* Copyright 1986-2011 QAD Inc., Carpinteria, CA, USA.                      */
/* All rights reserved worldwide.  This is an unpublished work.             */
/* $Revision: 1.71.1.2 $    */
/*V8:ConvertMode=NoConvert                                                  */
/********************************** History *********************************
 * $Revision: 1.2 $    Default User             DATE: 11/09/07  ECO: *XXXX*
 ****************************************************************************/

{mfdeclre.i}

&SCOPED-DEFINE BR-TITLE "�ͻ���ʽ"

&SCOPED-DEFINE BR-NAME xx200
&SCOPED-DEFINE Q-DRAG-BACK-COL 1

&SCOPED-DEFINE Q-FIRST-TABLE code_mstr
&SCOPED-DEFINE Q-FIRST-FIELD-LIST (code_value code_cmmt)
&SCOPED-DEFINE Q-NUM-TABLES 1

&SCOPED-DEFINE Q-BROWSE-DISP-EXPR-1 b-1.code_value
&SCOPED-DEFINE Q-BROWSE-DEF-EXPR-1 code_mstr.code_value
&SCOPED-DEFINE TT-Q-BROWSE-DEF-EXPR-1 tt-code_value
&SCOPED-DEFINE BR-K-COL-LABEL-1 COLUMN-LABEL
&SCOPED-DEFINE BR-COLUMN-LABEL-1 "�ͻ���ʽ"
&SCOPED-DEFINE BR-FIELD-TYPE-1 character
&SCOPED-DEFINE BR-FIELD-FRMT-1 FORMAT "x(12)"
&SCOPED-DEFINE BR-FIELD-WIDTH-1 13

&SCOPED-DEFINE Q-BROWSE-DISP-EXPR-2 b-1.code_cmmt
&SCOPED-DEFINE Q-BROWSE-DEF-EXPR-2 code_mstr.code_cmmt
&SCOPED-DEFINE TT-Q-BROWSE-DEF-EXPR-2 tt-code_cmmt
&SCOPED-DEFINE BR-K-COL-LABEL-2 COLUMN-LABEL
&SCOPED-DEFINE BR-COLUMN-LABEL-2 "˵��"
&SCOPED-DEFINE BR-FIELD-TYPE-2 character
&SCOPED-DEFINE BR-FIELD-FRMT-2 FORMAT "x(40)"
&SCOPED-DEFINE BR-FIELD-WIDTH-2 41

&SCOPED-DEFINE Q-NUM-FILT-VALS 2
&SCOPED-DEFINE BR-MAX-FIELD-WIDTH 41
&SCOPED-DEFINE BR-BROWSE-WIDTH 54
&SCOPED-DEFINE WHERE-CLAUSE code_fldname = 'vd__chr03'
&SCOPED-DEFINE BR-INDEXED-FIELDS 1

{wbbr01.i}
if c-application-mode <> 'WEB' then do:
   {browse.i}
end.

