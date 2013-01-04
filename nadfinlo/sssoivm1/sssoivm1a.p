/* xxsoivm1.p - INVOICE MAINTENANCE                                             */
/* Copyright 1996-2006 Softspeed, China.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.95.1.6 $                                                      */
/* REVISION: 1.0      LAST MODIFIED: 02/21/06   BY: Apple Tam *SS - 20060221*                  */
/* $Revision: 1.95.1.6 $    BY: Bill Jiang        DATE: 02/25/06  ECO: *SS - 20060225* */
/* $Revision: 1.95.1.6 $    BY: Micho Yang        DATE: 03/07/06  ECO: *SS - 20060307* */
/* $Revision: 1.95.1.6 $    BY: Bill Jiang        DATE: 03/11/06  ECO: *SS - 20060311* */
/* By: Neil Gao Date: 20070102 ECO: * ss 20070102.1 * */

define shared variable global_user_lang_dir like lng_mstr.lng_dir.
DEFINE SHARED FRAME match_maintenance .
DEFINE SHARED FRAME w.

/* SHIPPER_MATCHING_MAINTENANCE */
DEFINE SHARED TEMP-TABLE tt1
   FIELD tt1_stat     as character format "x(1)"
   FIELD tt1_shipfrom LIKE ABS_shipfrom
   FIELD tt1_id LIKE ABS_id FORMAT "x(58)"
/* ss 20070102.1 */   FIELD tt1_disp_id like abs_id label "»õÔËµ¥ºÅ" FORMAT "x(58)"
   FIELD tt1_par_id LIKE ABS_par_id
   FIELD tt1_shipto         LIKE ABS_shipto 
   FIELD tt1_order        AS CHAR FORMAT "x(8)"
   FIELD tt1_po           LIKE so_po
   FIELD tt1_line     LIKE ABS_line FORMAT "x(3)"
   FIELD tt1_item     AS CHAR FORMAT "x(18)"
   FIELD tt1_cust_part LIKE cp_cust_part
   FIELD tt1_desc1        like pt_desc1
   FIELD tt1_desc2        like pt_desc2
   FIELD tt1_um           AS CHAR FORMAT "x(2)"
   FIELD tt1_ship_qty AS DECIMAL FORMAT "->,>>>,>>9.99"
   FIELD tt1_qty_inv AS DECIMAL FORMAT "->,>>>,>>9.9<<<<<<<"
   FIELD tt1_price LIKE sod_price
   FIELD tt1_close_abs AS LOGICAL
   FIELD tt1_type LIKE sod_type
   /* SS - 20060401 - B */
   FIELD tt1_new  AS LOGICAL INITIAL YES
   FIELD tt1_ord_date LIKE so_ord_date
   FIELD tt1__qad02 LIKE ABS__qad02
   FIELD tt1_conv AS DECIMAL INITIAL 1
   /* SS - 20060401 - E */
/* ss 20070102.1 */ INDEX tt1_disp_id tt1_disp_id
   INDEX tt1_id tt1_id
   INDEX tt1_stat tt1_stat
   INDEX tt1_par_id_line tt1_par_id tt1_line
   INDEX tt1_shipfrom_id tt1_shipfrom tt1_id
   .

{gplabel.i}

/* SS - 20060311 - B */
form
/* ss 20070102.1 -b */
/*
   tt1_id
 */
   tt1_disp_id
/* ss 20070102.1 - e */
   tt1_qty_inv
   with frame w scroll 1 4 down NO-VALIDATE ATTR-SPACE TITLE COLOR normal (getFrameTitle("SHIPPER_MATCHING_DETAIL",34))  WIDTH 80 .

/* SET EXTERNAL LABELS */
setFrameLabels(frame w:handle).

FORM
/*
   tt1_id
 */
   tt1_disp_id
/* ss 20070102.1 - e */
    COLON 18
   /* SS - 20060331 - B */
   pt_desc1 COLON 18
   pt_desc2 NO-LABEL
   tt1_po COLON 18
   /* SS - 20060331 - E */
   tt1_ship_qty COLON 18
   tt1_cust_part COLON 60 FORMAT "x(18)"
   tt1_qty_inv COLON 18 FORMAT "->,>>>,>>9.99999"
   tt1_close_abs COLON 48 LABEL "Closed"
   tt1_type COLON 72
   with frame match_maintenance side-labels title color normal (getFrameTitle("SHIPPER_MATCHING_MAINTENANCE",41)) width 80 no-attr-space.
/* SS - 20060311 - E */

/* SET EXTERNAL LABELS */
setFrameLabels(frame match_maintenance:handle).

VIEW FRAME w.
VIEW FRAME match_maintenance .

DO:
   {windo1u.i
      tt1 
      "
      tt1_disp_id
      tt1_qty_inv
      "
      "tt1_disp_id"
      "use-index tt1_disp_id"     
      yes
      " "
      " "
      } 

   if keyfunction(lastkey) = "GO" then do:
      leave.
      ststatus = stline[2].
      status input ststatus.
   end.

/* ss 20070102.1 - b */
/*   
   {windo1u1.i tt1_id}
 */
   {windo1u1.i tt1_disp_id}
/* ss 20070102.1 - e */
END.
