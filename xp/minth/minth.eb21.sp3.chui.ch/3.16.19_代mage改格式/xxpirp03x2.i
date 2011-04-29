/* pirp03.i - TAG REPORT INCLUDE FILE                                         */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.6.1.5 $                                                       */
/*V8:ConvertMode=Report                                                       */
/* REVISION: 6.0      LAST MODIFIED: 03/06/90   BY: WUG *D015*/
/* REVISION: 6.0      LAST MODIFIED: 10/03/91   BY: alb *D887**/
/* REVISION: 6.0      LAST MODIFIED: 03/05/92   BY: WUG *F254*/
/* REVISION: 7.0      LAST MODIFIED: 04/16/92   BY: WUG *F404*/
/* REVISION: 7.0      LAST MODIFIED: 07/31/92   BY: WUG *F824*                */
/* Revision: 7.3      Last edit: 11/19/92       By: jcd *G349*                */
/* Revision: 8.6      Last edit: 11/28/97       By: GYK *K0ZS*                */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane          */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan         */
/* REVISION: 9.1      LAST MODIFIED: 08/13/00   BY: *N0KQ* myb                */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.6.1.2     BY: Katie Hilbert  DATE: 03/11/01 ECO: *N0XB*        */
/* Revision: 1.6.1.3  BY: Luke Pokic DATE: 07/11/01 ECO: *N103* */
/* $Revision: 1.6.1.5 $ BY: Paul Donnelly (SB) DATE: 06/28/03 ECO: *Q00J* */
/* $Revision: 1.6.1.5 $ BY: Mage CHen     (SB) DATE: 09/07/06 ECO: *Minth* */

/*-Revision end---------------------------------------------------------------*/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

{mfdeclre.i}
{gplabel.i}

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE pirp03_i_1 "Select Option"
/* MaxLen: Comment: */

&SCOPED-DEFINE pirp03_i_2 "Sort Option"
/* MaxLen: Comment: */

&SCOPED-DEFINE pirp03_i_3 "ReC"
/* MaxLen: Comment: */

&SCOPED-DEFINE pirp03_i_4 "Warnings*"
/* MaxLen: Comment: */

&SCOPED-DEFINE pirp03_i_5 "Lot/Serial!Ref"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

{wbrp02.i}

define shared variable tag             like tag_nbr.
define shared variable tag1            like tag_nbr label {t001.i}.
define shared variable site            like si_site.
define shared variable site1           like si_site label {t001.i}.
define shared variable loc             like loc_loc.
define shared variable loc1            like loc_loc label {t001.i}.
define shared variable part            like pt_part.
define shared variable part1           like pt_part label {t001.i}.
define shared variable lotser          like tag_serial.
define shared variable lotser1         like tag_serial label {t001.i}.
define shared variable seloption       as integer format "9" label {&pirp03_i_1}.
define shared variable sortoption      as integer label {&pirp03_i_2} format "9".
define shared variable sortextoption   as character extent 4 format "x(37)".
define shared variable earliest_crt_dt as date.
define shared variable latest_crt_dt   as date.
define shared variable earliest_frz_dt as date.
define shared variable latest_frz_dt   as date.
define shared variable frzdates        as character format "x(17)".

define variable recount                like mfc_logical label {&pirp03_i_3}.
define variable warn                   as character  label {&pirp03_i_4} format "x(6)".
/*minth*/ define   shared variable crtdate           as date label "标签产生日期".
/*minth*/ define   shared variable crtdate1          as date label "TO".
/*minth*/ define     variable tagresult              as character label "盘点结果" format "x(12)"  initial "____________" .
/*minth*/ define     variable percent                as decimal  label "差异百分比" format "->>>9.99%" .
/*minth*/ define     variable cnt_qty                as decimal format "->>>,>>>,>>9.<<<<<" .
/*minth*/ define     variable cnt_qty1               as decimal format "->>>,>>>,>>9.<<<<<"  label "盘点差异" .

for each tag_mstr no-lock
    where tag_mstr.tag_domain = global_domain and (  tag_nbr >= tag and tag_nbr
    <= tag1
     and tag_site >= site and tag_site <= site1
     and tag_loc >= loc and tag_loc <= loc1
     and tag_part >= part and tag_part <= part1
     and tag_serial >= lotser and tag_serial <= lotser1
     and tag_crt_dt >= crtdate and tag_crt_dt <= crtdate1  /*minth*/
) use-index {1} with frame b width 200:

   {mfrpchk.i}
/*minth**************************************************************
   warn = "".

   if tag_cnt_dt <> ? then do:

      find ld_det  where ld_det.ld_domain = global_domain and
           ld_site = tag_site  and
           ld_loc = tag_loc    and
           ld_part = tag_part  and
           ld_lot = tag_serial and
           ld_ref = tag_ref
      no-lock no-error.

      if not available ld_det or ld_date_frz = ? then
         warn = "N".

      else do:

         if ld_date_frz < earliest_frz_dt then
            earliest_frz_dt = ld_date_frz.
         if ld_date_frz > latest_frz_dt then
            latest_frz_dt = ld_date_frz.

         if earliest_frz_dt <> latest_frz_dt and
            earliest_frz_dt < hi_date and
            latest_frz_dt > low_date
         then
            assign
               warn = "V"
               frzdates = string(earliest_frz_dt) + " " + string(latest_frz_dt).

         if ld_date_frz > tag_cnt_dt or ld_date_frz > tag_rcnt_dt
         then do:
            if warn > "" then
               warn = warn + ",".
            warn = warn + "C".
         end.

      end.

   end.
*minth************************************************************************/
   setFrameLabels(frame b:handle).
   find first pt_mstr no-lock where pt_domain = global_domain and pt_part = tag_part no-error.

if tag_rcnt_dt  <> ?  then  cnt_qty =  tag_rcnt_qty .
    else if tag_cnt_dt <> ?  then cnt_qty = tag_cnt_qty . else cnt_qty =  tag__qad01.
   display
      tag_nbr
      tag_site
      tag_loc
      tag_part
      pt_desc1
      pt_desc2 
      tag_serial column-label {&pirp03_i_5}
      tag__qad01  label "冻结数量" with frame b.
      if tag_cnt_dt <> ? then
      display tag_cnt_qty label "初盘数量"  with frame b.
      if tag_rcnt_dt <> ? then display tag_rcnt_qty label "重盘数量"
       with frame b .
        if tag_rcnt_dt <> ? then
        display  tag_rcnt_qty - tag__qad01 @   cnt_qty1 label "盘点差异"  with frame b.
      else if tag_cnt_dt <> ? then
       display tag_cnt_qty - tag__qad01 @  cnt_qty1 label "盘点差异"  with frame b.

if tag__qad01 <> 0 then
	if (cnt_qty - tag__qad01) / tag__qad01 < 100   then  
		if (cnt_qty - tag__qad01) / tag__qad01 < - 100 then 
			  display "-9999.99%"   @ percent label "差异百分比" format "->>>9.99%" with frame b .
		else  display 100 *  (cnt_qty - tag__qad01) / tag__qad01  
									@ percent label "差异百分比" format "->>>9.99%" with frame b .
	else      display "9999.99%"    @ percent label "差异百分比" format "->>>9.99%"  with frame b .
else if (cnt_qty - tag__qad01) > 0 then   
              display "9999999.99%" @ percent label "差异百分比" format "9999999.99%"  with frame b .
	 else     display "0.00%"       @ percent label "差异百分比" format "->>>9.99%"  with frame b.

   if tag_ref <> " " then do:
       down 1.      
      display tag_ref format "x(8)" @ tag_serial with frame b . 
   end.
end.

{wbrp04.i}
