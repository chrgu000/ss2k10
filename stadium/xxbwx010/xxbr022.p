/************************************************************************
 * Copyright 1986-2001 QAD Inc., Carpinteria, CA, USA.
 * All rights reserved worldwide.  This is an unpublished work.
 * 
 *          File: xxbr022.p for xx022
 * 
 *   Description: Supplier Item Browse
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
 *  Revision:   Created: 09/19/12 15:41  **  By: ADMIN
 ************************************************************************/

&SCOPED-DEFINE GENERATOR-ID 1.08
&SCOPED-DEFINE COMP_REV_LEVEL 

{mfdeclre.i}

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE BR-TITLE "Supplier Item Browse"
/* MaxLen:  Comment: */

&SCOPED-DEFINE BR-COLUMN-LABEL-1 "Item Number"
/* MaxLen: 18  Comment: */

&SCOPED-DEFINE BR-COLUMN-LABEL-2 "Supplier"
/* MaxLen: 8  Comment: */

&SCOPED-DEFINE BR-COLUMN-LABEL-3 "Supplier Item"
/* MaxLen: 30  Comment: */

&SCOPED-DEFINE BR-COLUMN-LABEL-4 "UM"
/* MaxLen: 2  Comment: */

&SCOPED-DEFINE BR-COLUMN-LABEL-5 "Supplier Lead Time"
/* MaxLen: 18  Comment: */

&SCOPED-DEFINE BR-COLUMN-LABEL-6 "Quote Price"
/* MaxLen: 18  Comment: */

&SCOPED-DEFINE BR-COLUMN-LABEL-7 "Currency"
/* MaxLen: 8  Comment: */

&SCOPED-DEFINE BR-COLUMN-LABEL-8 "Price List"
/* MaxLen: 10  Comment: */

&SCOPED-DEFINE BR-COLUMN-LABEL-9 "Use SO Reduction Price"
/* MaxLen: 22  Comment: */

&SCOPED-DEFINE BR-COLUMN-LABEL-10 "SO Price Reduction"
/* MaxLen: 18  Comment: */

&SCOPED-DEFINE BR-COLUMN-LABEL-11 "Approve Date"
/* MaxLen: 12  Comment: */

&SCOPED-DEFINE BR-COLUMN-LABEL-12 "Manufacturer"
/* MaxLen: 12  Comment: */

&SCOPED-DEFINE BR-COLUMN-LABEL-13 "NAME"
/* MaxLen: 28  Comment: */

&SCOPED-DEFINE BR-COLUMN-LABEL-14 "Manufacturer Item"
/* MaxLen: 18  Comment: */

&SCOPED-DEFINE BR-COLUMN-LABEL-15 "Comment"
/* MaxLen: 40  Comment: */

/* *********** End Translatable Strings Definitions ********** */

&SCOPED-DEFINE BR-NAME xx022
&SCOPED-DEFINE Q-DRAG-BACK-COL 1

&SCOPED-DEFINE Q-FIRST-TABLE vp_mstr
&SCOPED-DEFINE Q-FIRST-FIELD-LIST (vp_part vp_vend vp_vend_part vp_um vp_vend_lead vp_q_price vp_curr vp_pr_list vp_tp_use_pct vp_tp_pct vp_appr_date vp_mfgr vp__chr02 vp_mfgr_part vp_comment)
&SCOPED-DEFINE Q-NUM-TABLES 1

&SCOPED-DEFINE Q-BROWSE-DISP-EXPR-1 vp_part
&SCOPED-DEFINE Q-BROWSE-DEF-EXPR-1 vp_mstr.vp_part
&SCOPED-DEFINE TT-Q-BROWSE-DEF-EXPR-1 tt-vp_part
&SCOPED-DEFINE BR-K-COL-LABEL-1 COLUMN-LABEL
&SCOPED-DEFINE BR-FIELD-TYPE-1 character
&SCOPED-DEFINE BR-FIELD-FRMT-1 FORMAT "x(18)"
&SCOPED-DEFINE BR-FIELD-WIDTH-1 19

&SCOPED-DEFINE Q-BROWSE-DISP-EXPR-2 vp_vend
&SCOPED-DEFINE Q-BROWSE-DEF-EXPR-2 vp_mstr.vp_vend
&SCOPED-DEFINE TT-Q-BROWSE-DEF-EXPR-2 tt-vp_vend
&SCOPED-DEFINE BR-K-COL-LABEL-2 COLUMN-LABEL
&SCOPED-DEFINE BR-FIELD-TYPE-2 character
&SCOPED-DEFINE BR-FIELD-FRMT-2 FORMAT "x(8)"
&SCOPED-DEFINE BR-FIELD-WIDTH-2 9

&SCOPED-DEFINE Q-BROWSE-DISP-EXPR-3 vp_vend_part
&SCOPED-DEFINE Q-BROWSE-DEF-EXPR-3 vp_mstr.vp_vend_part
&SCOPED-DEFINE TT-Q-BROWSE-DEF-EXPR-3 tt-vp_vend_part
&SCOPED-DEFINE BR-K-COL-LABEL-3 COLUMN-LABEL
&SCOPED-DEFINE BR-FIELD-TYPE-3 character
&SCOPED-DEFINE BR-FIELD-FRMT-3 FORMAT "x(30)"
&SCOPED-DEFINE BR-FIELD-WIDTH-3 31

&SCOPED-DEFINE Q-BROWSE-DISP-EXPR-4 vp_um
&SCOPED-DEFINE Q-BROWSE-DEF-EXPR-4 vp_mstr.vp_um
&SCOPED-DEFINE TT-Q-BROWSE-DEF-EXPR-4 tt-vp_um
&SCOPED-DEFINE BR-K-COL-LABEL-4 COLUMN-LABEL
&SCOPED-DEFINE BR-FIELD-TYPE-4 character
&SCOPED-DEFINE BR-FIELD-FRMT-4 FORMAT "x(2)"
&SCOPED-DEFINE BR-FIELD-WIDTH-4 3

&SCOPED-DEFINE Q-BROWSE-DISP-EXPR-5 vp_vend_lead
&SCOPED-DEFINE Q-BROWSE-DEF-EXPR-5 vp_mstr.vp_vend_lead
&SCOPED-DEFINE TT-Q-BROWSE-DEF-EXPR-5 tt-vp_vend_lead
&SCOPED-DEFINE BR-K-COL-LABEL-5 COLUMN-LABEL
&SCOPED-DEFINE BR-FIELD-TYPE-5 integer
&SCOPED-DEFINE BR-FIELD-FRMT-5 FORMAT ">>9"
&SCOPED-DEFINE BR-FIELD-WIDTH-5 19

&SCOPED-DEFINE Q-BROWSE-DISP-EXPR-6 vp_q_price
&SCOPED-DEFINE Q-BROWSE-DEF-EXPR-6 vp_mstr.vp_q_price
&SCOPED-DEFINE TT-Q-BROWSE-DEF-EXPR-6 tt-vp_q_price
&SCOPED-DEFINE BR-K-COL-LABEL-6 COLUMN-LABEL
&SCOPED-DEFINE BR-FIELD-TYPE-6 decimal
&SCOPED-DEFINE BR-FIELD-FRMT-6 FORMAT ">>>>,>>>,>>9.99<<<"
&SCOPED-DEFINE BR-FIELD-WIDTH-6 19

&SCOPED-DEFINE Q-BROWSE-DISP-EXPR-7 vp_curr
&SCOPED-DEFINE Q-BROWSE-DEF-EXPR-7 vp_mstr.vp_curr
&SCOPED-DEFINE TT-Q-BROWSE-DEF-EXPR-7 tt-vp_curr
&SCOPED-DEFINE BR-K-COL-LABEL-7 COLUMN-LABEL
&SCOPED-DEFINE BR-FIELD-TYPE-7 character
&SCOPED-DEFINE BR-FIELD-FRMT-7 FORMAT "x(3)"
&SCOPED-DEFINE BR-FIELD-WIDTH-7 9

&SCOPED-DEFINE Q-BROWSE-DISP-EXPR-8 vp_pr_list
&SCOPED-DEFINE Q-BROWSE-DEF-EXPR-8 vp_mstr.vp_pr_list
&SCOPED-DEFINE TT-Q-BROWSE-DEF-EXPR-8 tt-vp_pr_list
&SCOPED-DEFINE BR-K-COL-LABEL-8 COLUMN-LABEL
&SCOPED-DEFINE BR-FIELD-TYPE-8 character
&SCOPED-DEFINE BR-FIELD-FRMT-8 FORMAT "x(8)"
&SCOPED-DEFINE BR-FIELD-WIDTH-8 11

&SCOPED-DEFINE Q-BROWSE-DISP-EXPR-9 vp_tp_use_pct
&SCOPED-DEFINE Q-BROWSE-DEF-EXPR-9 MFC_LOGICAL
&SCOPED-DEFINE TT-Q-BROWSE-DEF-EXPR-9 tt-vp_tp_use_pct
&SCOPED-DEFINE BR-K-COL-LABEL-9 COLUMN-LABEL
&SCOPED-DEFINE BR-FIELD-TYPE-9 logical
&SCOPED-DEFINE BR-FIELD-WIDTH-9 23

&SCOPED-DEFINE Q-BROWSE-DISP-EXPR-10 vp_tp_pct
&SCOPED-DEFINE Q-BROWSE-DEF-EXPR-10 vp_mstr.vp_tp_pct
&SCOPED-DEFINE TT-Q-BROWSE-DEF-EXPR-10 tt-vp_tp_pct
&SCOPED-DEFINE BR-K-COL-LABEL-10 COLUMN-LABEL
&SCOPED-DEFINE BR-FIELD-TYPE-10 decimal
&SCOPED-DEFINE BR-FIELD-FRMT-10 FORMAT ">>9.99%"
&SCOPED-DEFINE BR-FIELD-WIDTH-10 19

&SCOPED-DEFINE Q-BROWSE-DISP-EXPR-11 vp_appr_date
&SCOPED-DEFINE Q-BROWSE-DEF-EXPR-11 vp_mstr.vp_appr_date
&SCOPED-DEFINE TT-Q-BROWSE-DEF-EXPR-11 tt-vp_appr_date
&SCOPED-DEFINE BR-K-COL-LABEL-11 COLUMN-LABEL
&SCOPED-DEFINE BR-FIELD-TYPE-11 date
&SCOPED-DEFINE BR-FIELD-FRMT-11 FORMAT "99/99/99"
&SCOPED-DEFINE BR-FIELD-WIDTH-11 13

&SCOPED-DEFINE Q-BROWSE-DISP-EXPR-12 vp_mfgr
&SCOPED-DEFINE Q-BROWSE-DEF-EXPR-12 vp_mstr.vp_mfgr
&SCOPED-DEFINE TT-Q-BROWSE-DEF-EXPR-12 tt-vp_mfgr
&SCOPED-DEFINE BR-K-COL-LABEL-12 COLUMN-LABEL
&SCOPED-DEFINE BR-FIELD-TYPE-12 character
&SCOPED-DEFINE BR-FIELD-FRMT-12 FORMAT "x(8)"
&SCOPED-DEFINE BR-FIELD-WIDTH-12 13

&SCOPED-DEFINE Q-BROWSE-DISP-EXPR-13 vp__chr02
&SCOPED-DEFINE Q-BROWSE-DEF-EXPR-13 vp_mstr.vp__chr02
&SCOPED-DEFINE TT-Q-BROWSE-DEF-EXPR-13 tt-vp__chr02
&SCOPED-DEFINE BR-K-COL-LABEL-13 COLUMN-LABEL
&SCOPED-DEFINE BR-FIELD-TYPE-13 character
&SCOPED-DEFINE BR-FIELD-FRMT-13 FORMAT "x(28)"
&SCOPED-DEFINE BR-FIELD-WIDTH-13 29

&SCOPED-DEFINE Q-BROWSE-DISP-EXPR-14 vp_mfgr_part
&SCOPED-DEFINE Q-BROWSE-DEF-EXPR-14 vp_mstr.vp_mfgr_part
&SCOPED-DEFINE TT-Q-BROWSE-DEF-EXPR-14 tt-vp_mfgr_part
&SCOPED-DEFINE BR-K-COL-LABEL-14 COLUMN-LABEL
&SCOPED-DEFINE BR-FIELD-TYPE-14 character
&SCOPED-DEFINE BR-FIELD-FRMT-14 FORMAT "x(18)"
&SCOPED-DEFINE BR-FIELD-WIDTH-14 19

&SCOPED-DEFINE Q-BROWSE-DISP-EXPR-15 vp_comment
&SCOPED-DEFINE Q-BROWSE-DEF-EXPR-15 vp_mstr.vp_comment
&SCOPED-DEFINE TT-Q-BROWSE-DEF-EXPR-15 tt-vp_comment
&SCOPED-DEFINE BR-K-COL-LABEL-15 COLUMN-LABEL
&SCOPED-DEFINE BR-FIELD-TYPE-15 character
&SCOPED-DEFINE BR-FIELD-FRMT-15 FORMAT "x(40)"
&SCOPED-DEFINE BR-FIELD-WIDTH-15 41

&SCOPED-DEFINE Q-NUM-FILT-VALS 15
&SCOPED-DEFINE BR-MAX-FIELD-WIDTH 41
&SCOPED-DEFINE BR-BROWSE-WIDTH 277
&SCOPED-DEFINE WHERE-CLAUSE 
&SCOPED-DEFINE BR-INDEXED-FIELDS 1,2

{wbbr01.i}
if c-application-mode <> 'WEB' then do:
   {browse.i}
end.

{crevlvl.i}
