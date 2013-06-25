/* edbr900.p - 文件名称 Browse UI                                           */
/* Copyright 1986-2011 QAD Inc., Carpinteria, CA, USA.                      */
/* All rights reserved worldwide.  This is an unpublished work.             */
/* $Revision: 1.81.3.3 $    */
/*V8:ConvertMode=NoConvert                                                  */
/********************************** History *********************************
 * $Revision: 1.2 $    Default User             DATE: 07/13/11  ECO: *XXXX*
 ****************************************************************************/

{mfdeclre.i}

&SCOPED-DEFINE BR-TITLE "文件名称"

&SCOPED-DEFINE BR-NAME ed900
&SCOPED-DEFINE Q-DRAG-BACK-COL 1

&SCOPED-DEFINE Q-FIRST-TABLE qad_wkfl
&SCOPED-DEFINE Q-FIRST-FIELD-LIST (qad_key3)
&SCOPED-DEFINE Q-NUM-TABLES 1

&SCOPED-DEFINE Q-BROWSE-DISP-EXPR-1 b-1.qad_key3
&SCOPED-DEFINE Q-BROWSE-DEF-EXPR-1 qad_wkfl.qad_key3
&SCOPED-DEFINE TT-Q-BROWSE-DEF-EXPR-1 tt-qad_key3
&SCOPED-DEFINE BR-K-COL-LABEL-1 COLUMN-LABEL
&SCOPED-DEFINE BR-COLUMN-LABEL-1 "文件名称"
&SCOPED-DEFINE BR-FIELD-TYPE-1 character
&SCOPED-DEFINE BR-FIELD-FRMT-1 FORMAT "x(36)"
&SCOPED-DEFINE BR-FIELD-WIDTH-1 37

&SCOPED-DEFINE Q-NUM-FILT-VALS 1
&SCOPED-DEFINE BR-MAX-FIELD-WIDTH 37
&SCOPED-DEFINE BR-BROWSE-WIDTH 37
&SCOPED-DEFINE WHERE-CLAUSE qad_key1 = 'edvifile.p' and qad_key5 = global_userid and qad_key4 = 'F'
&SCOPED-DEFINE BR-INDEXED-FIELDS 1

{wbbr01.i}
if c-application-mode <> 'WEB' then do:
   {browse.i}
end.


