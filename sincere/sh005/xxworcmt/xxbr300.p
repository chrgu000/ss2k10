/* xxbr300.p - 单据类型 Browse UI                                           */
/* Copyright 1986-2010 QAD Inc., Carpinteria, CA, USA.                      */
/* All rights reserved worldwide.  This is an unpublished work.             */
/* $Revision: 1.81.3.3 $    */
/*V8:ConvertMode=NoConvert                                                  */
/********************************** History *********************************
 * $Revision: 1.2 $    Default User             DATE: 11/16/10  ECO: *XXXX*
 * $Revision: 1.2 $    Default User             DATE: 11/16/10  ECO: *XXXX*
 ****************************************************************************/

{mfdeclre.i}

&SCOPED-DEFINE BR-TITLE "单据类型"

&SCOPED-DEFINE BR-NAME xx300
&SCOPED-DEFINE Q-DRAG-BACK-COL 1

&SCOPED-DEFINE Q-FIRST-TABLE xdn_ctrl
&SCOPED-DEFINE Q-FIRST-FIELD-LIST (xdn_type xdn_name)
&SCOPED-DEFINE Q-NUM-TABLES 1

&SCOPED-DEFINE Q-BROWSE-DISP-EXPR-1 b-1.xdn_type
&SCOPED-DEFINE Q-BROWSE-DEF-EXPR-1 xdn_ctrl.xdn_type
&SCOPED-DEFINE TT-Q-BROWSE-DEF-EXPR-1 tt-xdn_type
&SCOPED-DEFINE BR-K-COL-LABEL-1 COLUMN-LABEL
&SCOPED-DEFINE BR-COLUMN-LABEL-1 "T"
&SCOPED-DEFINE BR-FIELD-TYPE-1 character
&SCOPED-DEFINE BR-FIELD-FRMT-1 FORMAT "x(2)"
&SCOPED-DEFINE BR-FIELD-WIDTH-1 3

&SCOPED-DEFINE Q-BROWSE-DISP-EXPR-2 b-1.xdn_name
&SCOPED-DEFINE Q-BROWSE-DEF-EXPR-2 xdn_ctrl.xdn_name
&SCOPED-DEFINE TT-Q-BROWSE-DEF-EXPR-2 tt-xdn_name
&SCOPED-DEFINE BR-K-COL-LABEL-2 COLUMN-LABEL
&SCOPED-DEFINE BR-COLUMN-LABEL-2 "描述 "
&SCOPED-DEFINE BR-FIELD-TYPE-2 character
&SCOPED-DEFINE BR-FIELD-FRMT-2 FORMAT "x(14)"
&SCOPED-DEFINE BR-FIELD-WIDTH-2 15

&SCOPED-DEFINE Q-NUM-FILT-VALS 2
&SCOPED-DEFINE BR-MAX-FIELD-WIDTH 15
&SCOPED-DEFINE BR-BROWSE-WIDTH 18
&SCOPED-DEFINE WHERE-CLAUSE      
&SCOPED-DEFINE BR-INDEXED-FIELDS 1

{wbbr01.i}
if c-application-mode <> 'WEB' then do:
   {browse.i}
end.


