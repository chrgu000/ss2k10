/* gpbr159.p - 零件批/序号的当前库存量 Browse UI                            */
/* Copyright 1986-2009 QAD Inc., Carpinteria, CA, USA.                      */
/* All rights reserved worldwide.  This is an unpublished work.             */
/* $Revision: 1.71.1.9 $    */
/*V8:ConvertMode=NoConvert                                                  */
/********************************** History *********************************
 *    Revision: 8.5      Created: 06/19/97    By: B. Pedersen    *J1TF*
 *    Revision: 8.5     Modified: 09/26/97    By: B. Pedersen    *J20C*
 *    Revision: 9.0     Modified: 01/08/99    By: Jean Miller    *M04S*
 *    Revision: 8.5     Modified: 01/31/99    By: Doug Norton    *M071*
 *    Revision: 9.0     Modified: 03/15/99    By: Mark Smith     *M0BF*
 *    Revision: 9.1     Modified: 08/15/00    By: Mark Brown     *N0KS*
 *    Revision: 9.1     Modified: 08/16/00    By: Mark Brown     *N0L1*
 * Revision: 1.10  BY: Jean Miller          DATE: 05/06/02  ECO: *P064*
 ****************************************************************************/

{mfdeclre.i}

&SCOPED-DEFINE BR-TITLE "零件批/序号的当前库存量"

&SCOPED-DEFINE BR-NAME gp159
&SCOPED-DEFINE Q-DRAG-BACK-COL 1

&SCOPED-DEFINE Q-FIRST-TABLE ld_det
&SCOPED-DEFINE Q-FIRST-FIELD-LIST (ld_lot ld_loc ld_ref ld_qty_oh ld_status)
&SCOPED-DEFINE Q-NUM-TABLES 1

&SCOPED-DEFINE Q-BROWSE-DISP-EXPR-1 b-1.ld_lot
&SCOPED-DEFINE Q-BROWSE-DEF-EXPR-1 ld_det.ld_lot
&SCOPED-DEFINE TT-Q-BROWSE-DEF-EXPR-1 tt-ld_lot
&SCOPED-DEFINE BR-K-COL-LABEL-1 COLUMN-LABEL
&SCOPED-DEFINE BR-COLUMN-LABEL-1 "批/序"
&SCOPED-DEFINE BR-FIELD-TYPE-1 character
&SCOPED-DEFINE BR-FIELD-FRMT-1 FORMAT "x(18)"
&SCOPED-DEFINE BR-FIELD-WIDTH-1 19

&SCOPED-DEFINE Q-BROWSE-DISP-EXPR-2 b-1.ld_loc
&SCOPED-DEFINE Q-BROWSE-DEF-EXPR-2 ld_det.ld_loc
&SCOPED-DEFINE TT-Q-BROWSE-DEF-EXPR-2 tt-ld_loc
&SCOPED-DEFINE BR-K-COL-LABEL-2 COLUMN-LABEL
&SCOPED-DEFINE BR-COLUMN-LABEL-2 "库位"
&SCOPED-DEFINE BR-FIELD-TYPE-2 character
&SCOPED-DEFINE BR-FIELD-FRMT-2 FORMAT "x(8)"
&SCOPED-DEFINE BR-FIELD-WIDTH-2 9

&SCOPED-DEFINE Q-BROWSE-DISP-EXPR-3 b-1.ld_ref
&SCOPED-DEFINE Q-BROWSE-DEF-EXPR-3 ld_det.ld_ref
&SCOPED-DEFINE TT-Q-BROWSE-DEF-EXPR-3 tt-ld_ref
&SCOPED-DEFINE BR-K-COL-LABEL-3 COLUMN-LABEL
&SCOPED-DEFINE BR-COLUMN-LABEL-3 "参考"
&SCOPED-DEFINE BR-FIELD-TYPE-3 character
&SCOPED-DEFINE BR-FIELD-FRMT-3 FORMAT "x(8)"
&SCOPED-DEFINE BR-FIELD-WIDTH-3 9

&SCOPED-DEFINE Q-BROWSE-DISP-EXPR-4 b-1.ld_qty_oh
&SCOPED-DEFINE Q-BROWSE-DEF-EXPR-4 ld_det.ld_qty_oh
&SCOPED-DEFINE TT-Q-BROWSE-DEF-EXPR-4 tt-ld_qty_oh
&SCOPED-DEFINE BR-K-COL-LABEL-4 COLUMN-LABEL
&SCOPED-DEFINE BR-COLUMN-LABEL-4 "库存量"
&SCOPED-DEFINE BR-FIELD-TYPE-4 decimal
&SCOPED-DEFINE BR-FIELD-FRMT-4 FORMAT "->,>>>,>>9.9<<<<<<<<"
&SCOPED-DEFINE BR-FIELD-WIDTH-4 21

&SCOPED-DEFINE Q-BROWSE-DISP-EXPR-5 b-1.ld_status
&SCOPED-DEFINE Q-BROWSE-DEF-EXPR-5 ld_det.ld_status
&SCOPED-DEFINE TT-Q-BROWSE-DEF-EXPR-5 tt-ld_status
&SCOPED-DEFINE BR-K-COL-LABEL-5 COLUMN-LABEL
&SCOPED-DEFINE BR-COLUMN-LABEL-5 "状态"
&SCOPED-DEFINE BR-FIELD-TYPE-5 character
&SCOPED-DEFINE BR-FIELD-FRMT-5 FORMAT "x(8)"
&SCOPED-DEFINE BR-FIELD-WIDTH-5 9

&SCOPED-DEFINE Q-NUM-FILT-VALS 5
&SCOPED-DEFINE BR-MAX-FIELD-WIDTH 21
&SCOPED-DEFINE BR-BROWSE-WIDTH 67
&SCOPED-DEFINE WHERE-CLAUSE ld_part = global_part and ld_site = global_site and ld_loc = global_loc and ld_qty_oh <> 0
&SCOPED-DEFINE BR-INDEXED-FIELDS 1,3,5

{wbbr01.i}
if c-application-mode <> 'WEB' then do:
   {browse.i}
end.


