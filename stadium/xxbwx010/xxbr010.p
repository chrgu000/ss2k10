/************************************************************************
 * Copyright 1986-2001 QAD Inc., Carpinteria, CA, USA.
 * All rights reserved worldwide.  This is an unpublished work.
 * 
 *          File: xxbr010.p for xx010
 * 
 *   Description: SUPPLIER_ITEM_MASTER
 * 
 *   Object Type: Browse UI
 * 
 * Primary Table: N/A
 * 
 *   Input Parms: <none>
 * 
 *  Output Parms: <none>
 * 
 *  Browse Generator ID: 1.08
 * 
 ************************************************************************/

/******************************** Tokens ********************************/
/*V8:ConvertMode=NoConvert                                              */
/*V8:ClientServerMode=Client                                            */
/*V8:RunMode=Character,Windows                                          */
/************************************************************************/

/******************************** History *******************************
 *  Revision:   Created: 09/19/12 15:10  **  By: ADMIN
 ************************************************************************/

&SCOPED-DEFINE GENERATOR-ID 1.08
&SCOPED-DEFINE COMP_REV_LEVEL 

{mfdeclre.i}

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE BR-TITLE "SUPPLIER_ITEM_MASTER"
/* MaxLen:  Comment: */

&SCOPED-DEFINE BR-COLUMN-LABEL-1 "Item Number"
/* MaxLen: 18  Comment: */

&SCOPED-DEFINE BR-COLUMN-LABEL-2 "Manufacturer"
/* MaxLen: 12  Comment: */

&SCOPED-DEFINE BR-COLUMN-LABEL-3 ""
/* MaxLen: 8  Comment: */

&SCOPED-DEFINE BR-COLUMN-LABEL-4 "Manufacturer Item"
/* MaxLen: 18  Comment: */

&SCOPED-DEFINE BR-COLUMN-LABEL-5 "Supplier"
/* MaxLen: 8  Comment: */

&SCOPED-DEFINE BR-COLUMN-LABEL-6 "Supplier Item"
/* MaxLen: 30  Comment: */

/* *********** End Translatable Strings Definitions ********** */

&SCOPED-DEFINE BR-NAME xx010
&SCOPED-DEFINE Q-DRAG-BACK-COL 5

&SCOPED-DEFINE Q-FIRST-TABLE vp_mstr
&SCOPED-DEFINE Q-FIRST-FIELD-LIST (vp_part vp_mfgr vp__chr02 vp_mfgr_part vp_vend vp_vend_part)
&SCOPED-DEFINE Q-NUM-TABLES 1

&SCOPED-DEFINE Q-BROWSE-DISP-EXPR-1 vp_part
&SCOPED-DEFINE Q-BROWSE-DEF-EXPR-1 vp_mstr.vp_part
&SCOPED-DEFINE TT-Q-BROWSE-DEF-EXPR-1 tt-vp_part
&SCOPED-DEFINE BR-K-COL-LABEL-1 COLUMN-LABEL
&SCOPED-DEFINE BR-FIELD-TYPE-1 character
&SCOPED-DEFINE BR-FIELD-FRMT-1 FORMAT "x(18)"
&SCOPED-DEFINE BR-FIELD-WIDTH-1 19

&SCOPED-DEFINE Q-BROWSE-DISP-EXPR-2 vp_mfgr
&SCOPED-DEFINE Q-BROWSE-DEF-EXPR-2 vp_mstr.vp_mfgr
&SCOPED-DEFINE TT-Q-BROWSE-DEF-EXPR-2 tt-vp_mfgr
&SCOPED-DEFINE BR-K-COL-LABEL-2 COLUMN-LABEL
&SCOPED-DEFINE BR-FIELD-TYPE-2 character
&SCOPED-DEFINE BR-FIELD-FRMT-2 FORMAT "x(8)"
&SCOPED-DEFINE BR-FIELD-WIDTH-2 13

&SCOPED-DEFINE Q-BROWSE-DISP-EXPR-3 vp__chr02
&SCOPED-DEFINE Q-BROWSE-DEF-EXPR-3 vp_mstr.vp__chr02
&SCOPED-DEFINE TT-Q-BROWSE-DEF-EXPR-3 tt-vp__chr02
&SCOPED-DEFINE BR-K-COL-LABEL-3 COLUMN-LABEL
&SCOPED-DEFINE BR-FIELD-TYPE-3 character
&SCOPED-DEFINE BR-FIELD-FRMT-3 FORMAT "x(8)"
&SCOPED-DEFINE BR-FIELD-WIDTH-3 9

&SCOPED-DEFINE Q-BROWSE-DISP-EXPR-4 vp_mfgr_part
&SCOPED-DEFINE Q-BROWSE-DEF-EXPR-4 vp_mstr.vp_mfgr_part
&SCOPED-DEFINE TT-Q-BROWSE-DEF-EXPR-4 tt-vp_mfgr_part
&SCOPED-DEFINE BR-K-COL-LABEL-4 COLUMN-LABEL
&SCOPED-DEFINE BR-FIELD-TYPE-4 character
&SCOPED-DEFINE BR-FIELD-FRMT-4 FORMAT "x(18)"
&SCOPED-DEFINE BR-FIELD-WIDTH-4 19

&SCOPED-DEFINE Q-BROWSE-DISP-EXPR-5 vp_vend
&SCOPED-DEFINE Q-BROWSE-DEF-EXPR-5 vp_mstr.vp_vend
&SCOPED-DEFINE TT-Q-BROWSE-DEF-EXPR-5 tt-vp_vend
&SCOPED-DEFINE BR-K-COL-LABEL-5 COLUMN-LABEL
&SCOPED-DEFINE BR-FIELD-TYPE-5 character
&SCOPED-DEFINE BR-FIELD-FRMT-5 FORMAT "x(8)"
&SCOPED-DEFINE BR-FIELD-WIDTH-5 9

&SCOPED-DEFINE Q-BROWSE-DISP-EXPR-6 vp_vend_part
&SCOPED-DEFINE Q-BROWSE-DEF-EXPR-6 vp_mstr.vp_vend_part
&SCOPED-DEFINE TT-Q-BROWSE-DEF-EXPR-6 tt-vp_vend_part
&SCOPED-DEFINE BR-K-COL-LABEL-6 COLUMN-LABEL
&SCOPED-DEFINE BR-FIELD-TYPE-6 character
&SCOPED-DEFINE BR-FIELD-FRMT-6 FORMAT "x(30)"
&SCOPED-DEFINE BR-FIELD-WIDTH-6 31

&SCOPED-DEFINE Q-NUM-FILT-VALS 6
&SCOPED-DEFINE BR-MAX-FIELD-WIDTH 31
&SCOPED-DEFINE BR-BROWSE-WIDTH 100
&SCOPED-DEFINE WHERE-CLAUSE vp_part = global_part and vp_vend = global_addr
&SCOPED-DEFINE BR-INDEXED-FIELDS 1,5

{wbbr01.i}
if c-application-mode <> 'WEB' then do:
   {browse.i}
end.

{crevlvl.i}
