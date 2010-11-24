/* xxbr130.p - 货物发自 Browse UI                                           */
/* Copyright 1986-2010 QAD Inc., Carpinteria, CA, USA.                      */
/* All rights reserved worldwide.  This is an unpublished work.             */
/* $Revision: 1.81 $                                                        */
/*V8:ConvertMode=NoConvert                                                  */
/********************************** History *********************************
 * $Revision: 1.2 $    Default User             DATE: 09/14/10  ECO: *XXXX*
 * $Revision: 1.2 $    Default User             DATE: 09/14/10  ECO: *XXXX*
 ****************************************************************************/

{mfdeclre.i}

&SCOPED-DEFINE BR-TITLE "货物发自"

&SCOPED-DEFINE BR-NAME xx130
&SCOPED-DEFINE Q-DRAG-BACK-COL 1

&SCOPED-DEFINE Q-FIRST-TABLE ad_mstr
&SCOPED-DEFINE Q-FIRST-FIELD-LIST (ad_addr ad_sort)
&SCOPED-DEFINE Q-NUM-TABLES 1

&SCOPED-DEFINE Q-BROWSE-DISP-EXPR-1 b-1.ad_addr
&SCOPED-DEFINE Q-BROWSE-DEF-EXPR-1 ad_mstr.ad_addr
&SCOPED-DEFINE TT-Q-BROWSE-DEF-EXPR-1 tt-ad_addr
&SCOPED-DEFINE BR-K-COL-LABEL-1 COLUMN-LABEL
&SCOPED-DEFINE BR-COLUMN-LABEL-1 "地址代码"
&SCOPED-DEFINE BR-FIELD-TYPE-1 character
&SCOPED-DEFINE BR-FIELD-FRMT-1 FORMAT "x(12)"
&SCOPED-DEFINE BR-FIELD-WIDTH-1 13

&SCOPED-DEFINE Q-BROWSE-DISP-EXPR-2 b-1.ad_sort
&SCOPED-DEFINE Q-BROWSE-DEF-EXPR-2 ad_mstr.ad_sort
&SCOPED-DEFINE TT-Q-BROWSE-DEF-EXPR-2 tt-ad_sort
&SCOPED-DEFINE BR-K-COL-LABEL-2 COLUMN-LABEL
&SCOPED-DEFINE BR-COLUMN-LABEL-2 "说明"
&SCOPED-DEFINE BR-FIELD-TYPE-2 character
&SCOPED-DEFINE BR-FIELD-FRMT-2 FORMAT "x(12)"
&SCOPED-DEFINE BR-FIELD-WIDTH-2 13

&SCOPED-DEFINE Q-NUM-FILT-VALS 2
&SCOPED-DEFINE BR-MAX-FIELD-WIDTH 13
&SCOPED-DEFINE BR-BROWSE-WIDTH 26
&SCOPED-DEFINE WHERE-CLAUSE ad_domain = global_domain and (ad_addr = global_addr or ad_ref = global_addr)
&SCOPED-DEFINE BR-INDEXED-FIELDS 1

{wbbr01.i}
if c-application-mode <> 'WEB' then do:
   {browse.i}
end.


