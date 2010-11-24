/* xxlu001.p - 评审流程 Lookup UI                                           */
/* Copyright 1986-2008 QAD Inc., Carpinteria, CA, USA.                      */
/* All rights reserved worldwide.  This is an unpublished work.             */
/* $Revision: 1.81 $    */
/*V8:ConvertMode=NoConvert                                                  */
/********************************** History *********************************
 ****************************************************************************/

{mfdeclre.i}

&SCOPED-DEFINE BR-TITLE "评审流程"

&SCOPED-DEFINE BR-NAME xx001
&SCOPED-DEFINE Q-DRAG-BACK-COL 1

&SCOPED-DEFINE Q-FIRST-TABLE xxcf_mstr
&SCOPED-DEFINE Q-FIRST-FIELD-LIST (xxcf_nbr xxcf_desc)
&SCOPED-DEFINE Q-NUM-TABLES 1

&SCOPED-DEFINE Q-BROWSE-DISP-EXPR-1 b-1.xxcf_nbr
&SCOPED-DEFINE Q-BROWSE-DEF-EXPR-1 xxcf_mstr.xxcf_nbr
&SCOPED-DEFINE TT-Q-BROWSE-DEF-EXPR-1 tt-xxcf_nbr
&SCOPED-DEFINE BR-K-COL-LABEL-1 COLUMN-LABEL
&SCOPED-DEFINE BR-COLUMN-LABEL-1 "xxcf_nbr"
&SCOPED-DEFINE BR-FIELD-TYPE-1 character
&SCOPED-DEFINE BR-FIELD-FRMT-1 FORMAT "x(8)"
&SCOPED-DEFINE BR-FIELD-WIDTH-1 9

&SCOPED-DEFINE Q-BROWSE-DISP-EXPR-2 b-1.xxcf_desc
&SCOPED-DEFINE Q-BROWSE-DEF-EXPR-2 xxcf_mstr.xxcf_desc
&SCOPED-DEFINE TT-Q-BROWSE-DEF-EXPR-2 tt-xxcf_desc
&SCOPED-DEFINE BR-K-COL-LABEL-2 COLUMN-LABEL
&SCOPED-DEFINE BR-COLUMN-LABEL-2 "xxcf_desc"
&SCOPED-DEFINE BR-FIELD-TYPE-2 character
&SCOPED-DEFINE BR-FIELD-FRMT-2 FORMAT "x(40)"
&SCOPED-DEFINE BR-FIELD-WIDTH-2 41

&SCOPED-DEFINE Q-NUM-FILT-VALS 2
&SCOPED-DEFINE BR-MAX-FIELD-WIDTH 41
&SCOPED-DEFINE BR-BROWSE-WIDTH 50
&SCOPED-DEFINE WHERE-CLAUSE xxcf_nbr <> '90'
&SCOPED-DEFINE BR-INDEXED-FIELDS 1

{wbbr01.i &string-4 = 'LOOKUP'}
if c-application-mode <> 'WEB' then do:
   {lookup.i}
end.


