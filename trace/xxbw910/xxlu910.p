/* xxlu910.p - Æô¶¯¸ú×Ù Lookup UI                                           */
/* Copyright 1986-2012 QAD Inc., Carpinteria, CA, USA.                      */
/* All rights reserved worldwide.  This is an unpublished work.             */
/* $Revision: 1.81.3.3 $    */
/*V8:ConvertMode=NoConvert                                                  */
/********************************** History *********************************
 ****************************************************************************/

{mfdeclre.i}

&SCOPED-DEFINE BR-TITLE "Æô¶¯¸ú×Ù"

&SCOPED-DEFINE BR-NAME xx910
&SCOPED-DEFINE Q-DRAG-BACK-COL 1

&SCOPED-DEFINE Q-FIRST-TABLE qad_wkfl
&SCOPED-DEFINE Q-FIRST-FIELD-LIST (qad_key3)
&SCOPED-DEFINE Q-NUM-TABLES 1

&SCOPED-DEFINE Q-BROWSE-DISP-EXPR-1 b-1.qad_key3
&SCOPED-DEFINE Q-BROWSE-DEF-EXPR-1 qad_wkfl.qad_key3
&SCOPED-DEFINE TT-Q-BROWSE-DEF-EXPR-1 tt-qad_key3
&SCOPED-DEFINE BR-K-COL-LABEL-1 COLUMN-LABEL
&SCOPED-DEFINE BR-COLUMN-LABEL-1 "±í"
&SCOPED-DEFINE BR-FIELD-TYPE-1 character
&SCOPED-DEFINE BR-FIELD-FRMT-1 FORMAT "x(20)"
&SCOPED-DEFINE BR-FIELD-WIDTH-1 21

&SCOPED-DEFINE Q-NUM-FILT-VALS 1
&SCOPED-DEFINE BR-MAX-FIELD-WIDTH 21
&SCOPED-DEFINE BR-BROWSE-WIDTH 21
&SCOPED-DEFINE WHERE-CLAUSE qad_domain = 'xxtcgen.p-domain' and qad_key1 = 'xxtcgen.p-tracegenrecord'
&SCOPED-DEFINE BR-INDEXED-FIELDS 1

{wbbr01.i &string-4 = 'LOOKUP'}
if c-application-mode <> 'WEB' then do:
   {lookup.i}
end.


