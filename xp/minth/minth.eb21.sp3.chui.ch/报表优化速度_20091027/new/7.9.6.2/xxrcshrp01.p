/* rcshrp01.p - PRESHIPPER/SHIPPER REPORT                                     */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.8.1.11 $                                                         */
/*V8:ConvertMode=Report                                                       */
/* REVISION: 8.6      LAST MODIFIED: 10/17/96   BY: *K003* Kieu Nguyen        */
/* REVISION: 8.6      LAST MODIFIED: 12/26/96   BY: *K03R* Vinay Nayak-Sujir  */
/* REVISION: 8.6      LAST MODIFIED: 03/15/97   BY: *K04X* Steve Goeke        */
/* REVISION: 8.6      LAST MODIFIED: 04/25/97   BY: *K0CH* Taek-Soo Chang     */
/* REVISION: 8.6      LAST MODIFIED: 07/30/97   BY: *K0H7* Taek-Soo Chang     */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane          */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan         */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan         */
/* REVISION: 9.1      LAST MODIFIED: 09/20/99   BY: *K22Y* Satish Chavan      */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1      LAST MODIFIED: 06/26/00   BY: *M0NY* Falguni Dalal      */
/* REVISION: 9.1      LAST MODIFIED: 08/12/00   BY: *N0KP* myb                */
/* REVISION: 9.1      LAST MODIFIED: 09/06/00   BY: *N0RG* BalbeerS Rajput    */
/* REVISION: 9.1      LAST MODIFIED: 12/21/00   BY: *M0Y7* Satish Chavan      */
/* REVISION: 9.1      LAST MODIFIED: 01/25/01   BY: *M101* Rajesh Thomas      */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.8.1.8  BY: Katie Hilbert            DATE: 04/15/02 ECO: *P03J* */
/* Revision: 1.8.1.10 BY: Paul Donnelly (SB)       DATE: 06/28/03 ECO: *Q00K* */
/* $Revision: 1.8.1.11 $ BY: Dayanand Jethwa          DATE: 12/27/04 ECO: *P317* */
/*-Revision end---------------------------------------------------------------*/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/*SS - 091029.1 By ken */

/* DISPLAY TITLE */
{mfdtitle.i "091029.1"}

/* SHARED VARIABLES */
define new shared variable part   like pt_part   no-undo.
define new shared variable part1  like pt_part   no-undo.
define new shared variable sonbr  like so_nbr    no-undo.
define new shared variable sonbr1 like so_nbr    no-undo.
define new shared variable stype  as   character no-undo.

/* LOCAL VARIABLES */
define variable ship        like abs_id label "Number" no-undo.
define variable ship1       like abs_id no-undo.
define variable shipfrom    like abs_shipfrom
                            label "Ship-From" no-undo.
define variable shipfrom1   like abs_shipfrom no-undo.
define variable shipto      like abs_shipto
                            label "Ship-To/Dock" no-undo.
define variable shipto1     like abs_shipto no-undo.
define variable range       as character no-undo.
define variable range1      as character no-undo.
define variable invmov      like abs_inv_mov no-undo.
define variable invmov1     like abs_inv_mov no-undo.

define variable shp_stat    like mfc_logical
                            label "Confirmed" no-undo.
define variable shp_short   like mfc_logical
                            label "Include Shortages"
                            initial no no-undo.
define variable shp_cancel  like mfc_logical
                            label "Include Cancelled"
                            initial no no-undo.
define variable shp_partial as logical
                            label "Ship Partial"
                            initial no no-undo.
define variable pick_ship   as logical format "Pre-Shipper/Shipper"
                            label "Pre-Shippers/Shippers"
                            initial true no-undo.
define variable sched_date  as date format 99/99/99
                            label "Scheduled Order Report Date"
                            initial today no-undo.
define variable short_flg   like mfc_logical no-undo.
define variable yn          like mfc_logical no-undo.
define variable abs_recid   as recid no-undo.

define variable due_date    like sod_due_date.
define variable open_qty    like sod_qty_ord label "Open Qty".
define variable v_items     as logical no-undo.
define variable v_open      as logical no-undo.

define variable l_useidx    as character  no-undo.
define variable l_shpno     as character no-undo .
define variable l_parid     as character no-undo .

/* TEMP-TABLE */
define new shared temp-table tab_abs
   field tab_id              like abs_id
   field tab_item            like abs_item
   field tab_shipto          like abs_shipto
   field tab_shipfrom        like abs_shipfrom
   field tab_order           like abs_order
   field tab_line            like sod_line
   field tab_qty             like abs_qty
   field tab_recid           as recid.

define new shared temp-table ship_abs
   field ship_id              like abs_id
   field ship_shipto          like abs_shipto
   field ship_shipfrom        like abs_shipfrom
/*tx01*/ field ship_arr_date  like abs_arr_date
   field ship_recid           as recid.

form
   /* Changed each colon 20 to 25 and each colon 49 to 52 */
   shipfrom         colon 25
   shipfrom1        colon 52 label {t001.i}
   shipto           colon 25
   shipto1          colon 52 label {t001.i}
   ship             colon 25
   ship1            colon 52 label {t001.i}
   invmov           colon 25
   invmov1          colon 52 label {t001.i}
   part             colon 25
   part1            colon 52 label {t001.i}
   sonbr            colon 25
   sonbr1           colon 52 label {t001.i}
   skip (1)
   pick_ship        colon 43
   sched_date       colon 43
   shp_stat         colon 43
   shp_cancel       colon 43
   shp_short        colon 43
with frame a side-labels width 80.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

MAINLOOP:
repeat:

   /* RESET THE HIGH VALUES */
   if ship1     = hi_char then ship1     = "".
   if shipto1   = hi_char then shipto1   = "".
   if shipfrom1 = hi_char then shipfrom1 = "".
   if invmov1   = hi_char then invmov1   = "".
   if part1     = hi_char then part1     = "".
   if sonbr1    = hi_char then sonbr1    = "".
   shp_short = no.

   display shp_short with frame a.
   update
      shipfrom shipfrom1
      shipto shipto1
      ship ship1
      invmov invmov1
      part part1
      sonbr sonbr1
      pick_ship
      sched_date
      shp_stat
      shp_cancel
      shp_short   when ( batchrun and  not shp_stat )
   with frame a.

   update
      shp_short   when ( not shp_stat and not batchrun )
   with frame a.

   /* SETUP BATCH PARAMS */
   bcdparm = "".
   {mfquoter.i shipfrom}
   {mfquoter.i shipfrom1}
   {mfquoter.i shipto }
   {mfquoter.i shipto1}
   {mfquoter.i ship }
   {mfquoter.i ship1}
   {mfquoter.i invmov}
   {mfquoter.i invmov1}
   {mfquoter.i part }
   {mfquoter.i part1}
   {mfquoter.i sonbr }
   {mfquoter.i sonbr1}
   {mfquoter.i pick_ship}
   {mfquoter.i sched_date}
   {mfquoter.i shp_stat}
   {mfquoter.i shp_cancel}

   if not shp_stat then
      {mfquoter.i shp_short}

   l_useidx = "abs_shipto" .

   /*SS - 091029.1 B*/
   /*
   if  shipfrom  = ""
   and shipfrom1 = ""
   and shipto    = ""
   and shipto1   = ""
   and ship      = ""
   and ship1     = ""
   then do:
   */
   /*SS - 091029.1 E*/
      if sonbr <> ""
      or sonbr1 <> ""
      then
         l_useidx = "abs_order" .
      else if part <> ""
         or part1 <> ""
         then
            l_useidx = "abs_item" .
   /*SS - 091029.1 B*/
   /*
   end. /* IF shipfrom = "" */
   */
   /*SS - 091029.1 E*/

   /* SET THE HIGH VALUES */
   if shipfrom1 = "" then shipfrom1 = hi_char.
   if shipto1   = "" then shipto1   = hi_char.
   if ship1     = "" then ship1     = hi_char.
   if invmov1   = "" then invmov1   = hi_char.
   if part1     = "" then part1     = hi_char.
   if sonbr1    = "" then sonbr1    = hi_char.

   v_open = (part = "" and part1 = hi_char and
             sonbr = "" and sonbr1 = hi_char).

   /* OUTPUT DESTINATION SELECTION */
   {gpselout.i &printType = "printer"
               &printWidth = 132
               &pagedFlag = " "
               &stream = " "
               &appendToFile = " "
               &streamedOutputToTerminal = " "
               &withBatchOption = "yes"
               &displayStatementType = 1
               &withCancelMessage = "yes"
               &pageBottomMargin = 6
               &withEmail = "yes"
               &withWinprint = "yes"
               &defineVariables = "yes"}

   {mfphead.i}

   /* SET THE DOCUMENT ID SELECTION RANGES */
   if pick_ship then
      assign
         stype  = getTermLabel("PRE-SHIPPER",11)
         range  = "p" + ship
         range1 = "p" + ship1.

   else
      assign
         stype  = getTermLabel("SHIPPER",11)
         range  = "s" + ship
         range1 = "s" + ship1.

   /* DELETE OLD RECORDS IN TEMP-TABLE */
   for each ship_abs exclusive-lock:
      delete ship_abs.
   end.

   /* 3 LOOPS ARE USED TO ENHANCE THE PERFORMANCE AND USE THE RIGHT INDEX */
   CASE l_useidx :
      when "abs_order"
      then
         run p_abs_order .
      when "abs_item"
      then
         run p_abs_item .
      otherwise
         run p_abs_shipto .
   END CASE . /* l_useidx */

/*tx01*   {gprun.i ""rcshrp1b.p"" "(sched_date)" } */
/*tx01*/  {gprun.i ""xxrcshrp1b.p"" "(sched_date)" } 

   /* REPORT TRAILER  */
   {mfrtrail.i}

end. /* MAINLOOP */

PROCEDURE p_abs_item :
   define buffer bf-absmstr for abs_mstr .
   for each bf-absmstr
      fields (abs_canceled abs_id     abs_inv_mov  abs_item
              abs_order    abs_par_id abs_shipfrom abs_shipto
              abs_status   abs_type   abs_domain )
      where bf-absmstr.abs_domain    = global_domain
      and   bf-absmstr.abs_item     >= part
      and   bf-absmstr.abs_item     <= part1
      and   bf-absmstr.abs_type      = "s"
      no-lock 
      use-index abs_item
      break by abs_id:

      if  bf-absmstr.abs_shipfrom >= shipfrom
      and bf-absmstr.abs_shipfrom <= shipfrom1
      and bf-absmstr.abs_shipto   >= shipto
      and bf-absmstr.abs_shipto   <= shipto1
      then do:
         assign
            l_parid = bf-absmstr.abs_par_id
            l_shpno = "" .

         do while l_shpno = "" :
            for first abs_mstr
               fields (abs_canceled abs_id     abs_inv_mov  abs_item
                       abs_order    abs_par_id abs_shipfrom abs_shipto
                       abs_status   abs_type   abs_domain )
               where abs_mstr.abs_domain    = global_domain
               and   abs_mstr.abs_shipfrom  = bf-absmstr.abs_shipfrom
               and   abs_mstr.abs_id        = l_parid
               no-lock use-index abs_id:

               if abs_mstr.abs_par_id = ""
               then do:
                  l_shpno = abs_mstr.abs_id .

                  if  l_shpno               >= range
                  and l_shpno               <= range1
                  and abs_mstr.abs_inv_mov  >= invmov
                  and abs_mstr.abs_inv_mov  <= invmov1
                  then
                     run crt_ship_abs .
               end. /* IF abs_mstr.abs_par_id = "" */

               l_parid = abs_mstr.abs_par_id .

            end. /* FOR FIRST abs_mstr */
         end. /* DO WHILE l_shpno = "" */
      end. /* IF  bf-absmstr.abs_shipfrom >= shipfrom */
   end. /* FOR EACH bf-absmstr */

END PROCEDURE . /* p_abs_item */

PROCEDURE p_abs_order :
   define buffer bf-absmstr for abs_mstr .
   for each bf-absmstr
      fields (abs_canceled abs_id     abs_inv_mov  abs_item
              abs_order    abs_par_id abs_shipfrom abs_shipto
              abs_status   abs_type   abs_domain )
      where bf-absmstr.abs_domain    = global_domain
      and   bf-absmstr.abs_order    >= sonbr
      and   bf-absmstr.abs_order    <= sonbr1
      and   bf-absmstr.abs_type      = "s"
      no-lock 

      use-index abs_order

      break by abs_id:

      if  bf-absmstr.abs_shipfrom >= shipfrom
      and bf-absmstr.abs_shipfrom <= shipfrom1
      and bf-absmstr.abs_shipto   >= shipto
      and bf-absmstr.abs_shipto   <= shipto1
      then do:
         assign
            l_parid = bf-absmstr.abs_par_id
            l_shpno = "" .

         do while l_shpno = "" :
            for first abs_mstr
               fields (abs_canceled abs_id     abs_inv_mov  abs_item
                       abs_order    abs_par_id abs_shipfrom abs_shipto
                       abs_status   abs_type   abs_domain )
               where abs_mstr.abs_domain    = global_domain
               and   abs_mstr.abs_shipfrom  = bf-absmstr.abs_shipfrom
               and   abs_mstr.abs_id        = l_parid
               no-lock use-index abs_id :

               if abs_mstr.abs_par_id = ""
               then do:
                  l_shpno = abs_mstr.abs_id .

                  if  l_shpno               >= range
                  and l_shpno               <= range1
                  and abs_mstr.abs_inv_mov  >= invmov
                  and abs_mstr.abs_inv_mov  <= invmov1
                  then
                     run crt_ship_abs .
               end. /* IF abs_mstr.abs_par_id = "" */

               l_parid = abs_mstr.abs_par_id .

            end. /* FOR FIRST abs_mstr */
         end. /* DO WHILE l_shpno = "" */
      end. /* IF  bf-absmstr.abs_shipfrom >= shipfrom */
   end. /* FOR EACH bf-absmstr */

END PROCEDURE . /* p_abs_order */

PROCEDURE p_abs_shipto :
   define buffer bf-absmstr for abs_mstr .
   for each bf-absmstr
      fields (abs_canceled abs_id     abs_inv_mov  abs_item
              abs_order    abs_par_id abs_shipfrom abs_shipto
              abs_status   abs_type   abs_domain )
      where bf-absmstr.abs_domain    = global_domain
      and   bf-absmstr.abs_shipfrom >= shipfrom
      and   bf-absmstr.abs_shipfrom <= shipfrom1
      and   bf-absmstr.abs_id       >= range
      and   bf-absmstr.abs_id       <= range1
      and   bf-absmstr.abs_type      = "s"
      no-lock 
      use-index abs_id
      break by abs_id:

      for each abs_mstr
         fields (abs_canceled abs_id     abs_inv_mov  abs_item
                 abs_order    abs_par_id abs_shipfrom abs_shipto
                 abs_status   abs_type   abs_domain )
         where abs_mstr.abs_domain    = global_domain
         and   abs_mstr.abs_shipfrom  = bf-absmstr.abs_shipfrom
         and   abs_mstr.abs_id        = bf-absmstr.abs_id
         and   abs_mstr.abs_shipto   >= shipto
         and   abs_mstr.abs_shipto   <= shipto1
         and   abs_mstr.abs_inv_mov  >= invmov
         and   abs_mstr.abs_inv_mov  <= invmov1
         and   abs_mstr.abs_type      = "s"
         no-lock 
         /*SS - 091029.1 B*/
         /*
         use-index abs_shipto
         */
         use-index abs_id
         /*SS - 091029.1 E*/
         break by abs_id:

         run crt_ship_abs .

      end.  /* FOR EACH abs_mstr */
   end. /* FOR EACH bf-absmstr */
END PROCEDURE . /* p_abs_shipto */

PROCEDURE crt_ship_abs :
   if available abs_mstr
   then .

   if (    abs_canceled
       and not shp_cancel)
   or (    substring(abs_status,2,1) = "Y"
       and not shp_stat)
   or (    substring(abs_status,2,1) = " "
       and shp_stat)
   then
      return.

   abs_recid = recid(abs_mstr).

   /*  STORE ALL ITEMS OF SHIPPER IN TEMP-TABLE */
   {gprun.i ""rcshrp1a.p""
      "(input recid(abs_mstr),
        input part,
        input part1,
        input sonbr,
        input sonbr1,
        output v_items)"}
   /* FOR UNCONFIRMED - GO THRU SELECTED ITEM CHECK FOR SHORTAGE */
   if not shp_stat
   then do:

      short_flg = no.

      /* ACCUMULATE QUANTITY IN MULTIPLE CONTAINERS PER LINE */
      /* FOR A ORDER TO CHECK SHORTAGES.                     */

      for each tab_abs
         break by tab_order by tab_line:

         accumulate tab_qty (total by tab_line).

         if last-of (tab_line)
         then do:
            for first sod_det
               fields (sod_domain sod_line sod_nbr sod_qty_ord sod_qty_ship)
               where sod_domain = global_domain
               and   sod_nbr    = tab_order
               and   sod_line   = tab_line
               no-lock :
            end. /* FOR FIRST sod_det */
            if available sod_det
            and (sod_qty_ord - sod_qty_ship > accum total by tab_line tab_qty)
            then do:
               short_flg = yes.
               leave.
            end. /* IF AVAILABLE sod_det  */
         end. /* IF LAST-OF (tab_line) */
      end. /* FOR EACH tab_abs  */
   end. /* NOT shp_stat - UNCONFIRMED */

   if (    not shp_short
       and short_flg
       and not shp_stat)
   or (    v_items = no
       and v_open = no )
   then
      return .

   /*  STORE THIS SHIPPER INTO TEMP TABLE ship_abs  */
   if not can-find(first ship_abs
                   where ship_recid = abs_recid)
   then do:
      create ship_abs.
      assign
         ship_id       = abs_id
         ship_shipfrom = abs_shipfrom
         ship_shipto   = abs_shipto
/*mage /*tx01*/ ship_arr_date = abs_arr_date */
/*mage /*tx01*/ */  ship_arr_date = abs_export_date 
         ship_recid    = abs_recid.
   end. /* IF NOT CAN-FIND(FIRST ship_abs.... */
END PROCEDURE . /* crt_ship_abs */
