/* yybr901.p - 供应商 Browse UI                                             */
/* Copyright 1986-2005 QAD Inc., Carpinteria, CA, USA.                      */
/* All rights reserved worldwide.  This is an unpublished work.             */
/* $Revision: 1.71.1.5 $    */
/*V8:ConvertMode=NoConvert                                                  */
/********************************** History *********************************
 * $Revision: 1.2 $    huang jie7                  DATE: 10/10/05  ECO: *XXXX*
 ****************************************************************************/

{mfdeclre.i}

&SCOPED-DEFINE BR-TITLE "供应商"

&SCOPED-DEFINE BR-NAME yy901
&SCOPED-DEFINE Q-DRAG-BACK-COL 1

&SCOPED-DEFINE Q-FIRST-TABLE xxvp_mstr
&SCOPED-DEFINE Q-FIRST-FIELD-LIST (xxvp_vend xxvp_part xxvp_rmks)
&SCOPED-DEFINE Q-NUM-TABLES 1

&SCOPED-DEFINE Q-BROWSE-DISP-EXPR-1 b-1.xxvp_vend
&SCOPED-DEFINE Q-BROWSE-DEF-EXPR-1 xxvp_mstr.xxvp_vend
&SCOPED-DEFINE TT-Q-BROWSE-DEF-EXPR-1 tt-xxvp_vend
&SCOPED-DEFINE BR-K-COL-LABEL-1 COLUMN-LABEL
&SCOPED-DEFINE BR-COLUMN-LABEL-1 "供应商"
&SCOPED-DEFINE BR-FIELD-TYPE-1 character
&SCOPED-DEFINE BR-FIELD-FRMT-1 FORMAT "X(8)"
&SCOPED-DEFINE BR-FIELD-WIDTH-1 9

&SCOPED-DEFINE Q-BROWSE-DISP-EXPR-2 b-1.xxvp_part
&SCOPED-DEFINE Q-BROWSE-DEF-EXPR-2 xxvp_mstr.xxvp_part
&SCOPED-DEFINE TT-Q-BROWSE-DEF-EXPR-2 tt-xxvp_part
&SCOPED-DEFINE BR-K-COL-LABEL-2 COLUMN-LABEL
&SCOPED-DEFINE BR-COLUMN-LABEL-2 "零件"
&SCOPED-DEFINE BR-FIELD-TYPE-2 character
&SCOPED-DEFINE BR-FIELD-FRMT-2 FORMAT "X(18)"
&SCOPED-DEFINE BR-FIELD-WIDTH-2 19

&SCOPED-DEFINE Q-BROWSE-DISP-EXPR-3 b-1.xxvp_rmks
&SCOPED-DEFINE Q-BROWSE-DEF-EXPR-3 xxvp_mstr.xxvp_rmks
&SCOPED-DEFINE TT-Q-BROWSE-DEF-EXPR-3 tt-xxvp_rmks
&SCOPED-DEFINE BR-K-COL-LABEL-3 COLUMN-LABEL
&SCOPED-DEFINE BR-COLUMN-LABEL-3 "备注"
&SCOPED-DEFINE BR-FIELD-TYPE-3 character
&SCOPED-DEFINE BR-FIELD-FRMT-3 FORMAT "X(40)"
&SCOPED-DEFINE BR-FIELD-WIDTH-3 41

&SCOPED-DEFINE Q-NUM-FILT-VALS 3
&SCOPED-DEFINE BR-MAX-FIELD-WIDTH 41
&SCOPED-DEFINE BR-BROWSE-WIDTH 69
&SCOPED-DEFINE WHERE-CLAUSE global_part  = xxvp_part
&SCOPED-DEFINE BR-INDEXED-FIELDS 1,2

{wbbr01.i}
if c-application-mode <> 'WEB' then do:
   {browse.i}
end.


