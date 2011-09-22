/* xxlu002.p - ���˼ƻ� Lookup UI                                           */
/* Copyright 1986-2008 QAD Inc., Carpinteria, CA, USA.                      */
/* All rights reserved worldwide.  This is an unpublished work.             */
/* $Revision: 1.81 $    */
/*V8:ConvertMode=NoConvert                                                  */
/********************************** History *********************************
 ****************************************************************************/

{mfdeclre.i}

&SCOPED-DEFINE BR-TITLE "���˼ƻ�"

&SCOPED-DEFINE BR-NAME xx002
&SCOPED-DEFINE Q-DRAG-BACK-COL 1

&SCOPED-DEFINE Q-FIRST-TABLE xxspl_mstr
&SCOPED-DEFINE Q-FIRST-FIELD-LIST (xxspl_id xxspl_cust xxspl_ship xxspl_status xxspl_shp_date)
&SCOPED-DEFINE Q-NUM-TABLES 1

&SCOPED-DEFINE Q-BROWSE-DISP-EXPR-1 b-1.xxspl_id
&SCOPED-DEFINE Q-BROWSE-DEF-EXPR-1 xxspl_mstr.xxspl_id
&SCOPED-DEFINE TT-Q-BROWSE-DEF-EXPR-1 tt-xxspl_id
&SCOPED-DEFINE BR-K-COL-LABEL-1 COLUMN-LABEL
&SCOPED-DEFINE BR-COLUMN-LABEL-1 "�ƻ���"
&SCOPED-DEFINE BR-FIELD-TYPE-1 character
&SCOPED-DEFINE BR-FIELD-FRMT-1 FORMAT "x(18)"
&SCOPED-DEFINE BR-FIELD-WIDTH-1 19

&SCOPED-DEFINE Q-BROWSE-DISP-EXPR-2 b-1.xxspl_cust
&SCOPED-DEFINE Q-BROWSE-DEF-EXPR-2 xxspl_mstr.xxspl_cust
&SCOPED-DEFINE TT-Q-BROWSE-DEF-EXPR-2 tt-xxspl_cust
&SCOPED-DEFINE BR-K-COL-LABEL-2 COLUMN-LABEL
&SCOPED-DEFINE BR-COLUMN-LABEL-2 "�ͻ�"
&SCOPED-DEFINE BR-FIELD-TYPE-2 character
&SCOPED-DEFINE BR-FIELD-FRMT-2 FORMAT "x(8)"
&SCOPED-DEFINE BR-FIELD-WIDTH-2 9

&SCOPED-DEFINE Q-BROWSE-DISP-EXPR-3 b-1.xxspl_ship
&SCOPED-DEFINE Q-BROWSE-DEF-EXPR-3 xxspl_mstr.xxspl_ship
&SCOPED-DEFINE TT-Q-BROWSE-DEF-EXPR-3 tt-xxspl_ship
&SCOPED-DEFINE BR-K-COL-LABEL-3 COLUMN-LABEL
&SCOPED-DEFINE BR-COLUMN-LABEL-3 "������"
&SCOPED-DEFINE BR-FIELD-TYPE-3 character
&SCOPED-DEFINE BR-FIELD-FRMT-3 FORMAT "x(8)"
&SCOPED-DEFINE BR-FIELD-WIDTH-3 9

&SCOPED-DEFINE Q-BROWSE-DISP-EXPR-4 b-1.xxspl_status
&SCOPED-DEFINE Q-BROWSE-DEF-EXPR-4 xxspl_mstr.xxspl_status
&SCOPED-DEFINE TT-Q-BROWSE-DEF-EXPR-4 tt-xxspl_status
&SCOPED-DEFINE BR-K-COL-LABEL-4 COLUMN-LABEL
&SCOPED-DEFINE BR-COLUMN-LABEL-4 "״̬"
&SCOPED-DEFINE BR-FIELD-TYPE-4 character
&SCOPED-DEFINE BR-FIELD-FRMT-4 FORMAT "x(1)"
&SCOPED-DEFINE BR-FIELD-WIDTH-4 5

&SCOPED-DEFINE Q-BROWSE-DISP-EXPR-5 b-1.xxspl_shp_date
&SCOPED-DEFINE Q-BROWSE-DEF-EXPR-5 xxspl_mstr.xxspl_shp_date
&SCOPED-DEFINE TT-Q-BROWSE-DEF-EXPR-5 tt-xxspl_shp_date
&SCOPED-DEFINE BR-K-COL-LABEL-5 COLUMN-LABEL
&SCOPED-DEFINE BR-COLUMN-LABEL-5 "��������"
&SCOPED-DEFINE BR-FIELD-TYPE-5 date
&SCOPED-DEFINE BR-FIELD-FRMT-5 FORMAT "99/99/99"
&SCOPED-DEFINE BR-FIELD-WIDTH-5 9

&SCOPED-DEFINE Q-NUM-FILT-VALS 5
&SCOPED-DEFINE BR-MAX-FIELD-WIDTH 19
&SCOPED-DEFINE BR-BROWSE-WIDTH 51
&SCOPED-DEFINE WHERE-CLAUSE xxspl_domain = global_domain
&SCOPED-DEFINE BR-INDEXED-FIELDS 1

{wbbr01.i &string-4 = 'LOOKUP'}
if c-application-mode <> 'WEB' then do:
   {lookup.i}
end.

