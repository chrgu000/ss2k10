/* gplu952.p - 项目 Lookup UI                                               */
/* Copyright 1986-2008 QAD Inc., Carpinteria, CA, USA.                      */
/* All rights reserved worldwide.  This is an unpublished work.             */
/* $Revision: 1.71.1.2 $    */
/*V8:ConvertMode=NoConvert                                                  */
/********************************** History *********************************
 ****************************************************************************/

{mfdeclre.i}

&SCOPED-DEFINE BR-TITLE "项目"

&SCOPED-DEFINE BR-NAME gp952
&SCOPED-DEFINE Q-DRAG-BACK-COL 1

&SCOPED-DEFINE Q-FIRST-TABLE usrw_wkfl
&SCOPED-DEFINE Q-FIRST-FIELD-LIST (usrw_key2 usrw_charfld[01])
&SCOPED-DEFINE Q-NUM-TABLES 1

&SCOPED-DEFINE Q-BROWSE-DISP-EXPR-1 b-1.usrw_key2
&SCOPED-DEFINE Q-BROWSE-DEF-EXPR-1 usrw_wkfl.usrw_key2
&SCOPED-DEFINE TT-Q-BROWSE-DEF-EXPR-1 tt-usrw_key2
&SCOPED-DEFINE BR-K-COL-LABEL-1 COLUMN-LABEL
&SCOPED-DEFINE BR-COLUMN-LABEL-1 "usrw_key2"
&SCOPED-DEFINE BR-FIELD-TYPE-1 character
&SCOPED-DEFINE BR-FIELD-FRMT-1 FORMAT "x(8)"
&SCOPED-DEFINE BR-FIELD-WIDTH-1 9

&SCOPED-DEFINE Q-BROWSE-DISP-EXPR-2 b-1.usrw_charfld[01]
&SCOPED-DEFINE Q-BROWSE-DEF-EXPR-2 usrw_wkfl.usrw_charfld[01]
&SCOPED-DEFINE TT-Q-BROWSE-DEF-EXPR-2 tt-usrw_charfld_01 
&SCOPED-DEFINE BR-K-COL-LABEL-2 COLUMN-LABEL
&SCOPED-DEFINE BR-COLUMN-LABEL-2 "usrw_charfld_01 "
&SCOPED-DEFINE BR-FIELD-TYPE-2 character
&SCOPED-DEFINE BR-FIELD-FRMT-2 FORMAT "x(24)"
&SCOPED-DEFINE BR-FIELD-WIDTH-2 25

&SCOPED-DEFINE Q-NUM-FILT-VALS 2
&SCOPED-DEFINE BR-MAX-FIELD-WIDTH 25
&SCOPED-DEFINE BR-BROWSE-WIDTH 34
&SCOPED-DEFINE WHERE-CLAUSE usrw_key1 = 'glsum' and usrw_key4 = 'D'
&SCOPED-DEFINE BR-INDEXED-FIELDS 1

{wbbr01.i &string-4 = 'LOOKUP'}
if c-application-mode <> 'WEB' then do:
   {lookup.i}
end.


