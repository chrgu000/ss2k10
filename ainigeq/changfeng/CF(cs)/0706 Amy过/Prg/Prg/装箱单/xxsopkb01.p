/* sopkb01.p - PACKING LIST  PRINT - LINE ITEMS AND UPDATE                    */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.10.1.6 $                                                      */
/*V8:ConvertMode=Report                                                       */
/* REVISION: 5.0      LAST MODIFIED: 07/14/89   BY: MLB *B130**/
/* REVISION: 6.0      LAST MODIFIED: 04/10/90   BY: ftb *D002**/
/* REVISION: 6.0      LAST MODIFIED: 04/23/90   BY: MLB *D021**/
/* REVISION: 6.0      LAST MODIFIED: 07/05/90   BY: WUG *D043**/
/* REVISION: 6.0      LAST MODIFIED: 07/30/90   BY: WUG *D051**/
/* REVISION: 6.0      LAST MODIFIED: 08/24/90   BY: WUG *D054**/
/* REVISION: 6.0      LAST MODIFIED: 01/30/91   BY: afs *D323**/
/* REVISION: 6.0      LAST MODIFIED: 03/12/91   BY: afs *D425**/
/* REVISION: 6.0      LAST MODIFIED: 04/29/91   BY: afs *D597**/
/* REVISION: 6.0      LAST MODIFIED: 07/13/91   BY: afs *D768**/
/* REVISION: 6.0      LAST MODIFIED: 09/19/91   BY: afs *F040**/
/* REVISION: 6.0      LAST MODIFIED: 11/13/91   BY: WUG *D887**/
/* REVISION: 7.0      LAST MODIFIED: 02/07/92   BY: afs *F180**/
/* REVISION: 7.0      LAST MODIFIED: 04/09/92   BY: emb *F369**/
/* REVISION: 7.0      LAST MODIFIED: 04/15/92   BY: afs *F398**/
/* REVISION: 7.0      LAST MODIFIED: 05/12/92   BY: tjs *F444**/
/* REVISION: 7.0      LAST MODIFIED: 06/15/92   BY: tjs *F504**/
/* REVISION: 7.3      LAST MODIFIED: 09/17/92   BY: pma *G068**/
/* REVISION: 7.3      LAST MODIFIED: 09/24/92   BY: tjs *G087**/
/* REVISION: 7.3      LAST MODIFIED: 11/12/92   BY: tjs *G191**/
/* REVISION: 7.3      LAST MODIFIED: 12/02/92   BY: WUG *G383**/
/* REVISION: 7.3      LAST MODIFIED: 01/06/92   BY: afs *G511**/
/* REVISION: 7.3      LAST MODIFIED: 09/09/93   BY: afs *GF01**/
/* REVISION: 7.3      LAST MODIFIED: 02/07/94   BY: afs *FL83**/
/* REVISION: 7.3      LAST MODIFIED: 03/16/94   BY: dpm *FM25**/
/* REVISION: 7.3      LAST MODIFIED: 06/22/94   BY: WUG *GK60**/
/* REVISION: 7.3      LAST MODIFIED: 11/02/94   BY: qzl *FT25**/
/* REVISION: 7.3      LAST MODIFIED: 04/19/95   BY: rxm *F0PD**/
/* REVISION: 7.3      LAST MODIFIED: 09/04/95   BY: dzn *G0W8**/
/* REVISION: 8.6      LAST MODIFIED: 10/22/96   BY: *K004* Stephane Collard   */
/* REVISION: 8.6      LAST MODIFIED: 12/23/96   BY: *K022* Kieu Nguyen        */
/* REVISION: 8.6      LAST MODIFIED: 08/23/97   BY: *J1ZD* Suresh Nayak       */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane          */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan         */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan         */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1      LAST MODIFIED: 08/11/00   BY: *N0JM* Mudit Mehta        */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Old ECO marker removed, but no ECO header exists *FI69*                    */
/* $Revision: 1.10.1.6 $   BY: Jean Miller       DATE: 04/24/02  ECO: *P05M*  */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* WARNING: THIS PROGRAM SHOULD NOT INCLUDE DIRECT DATABASE UPDATES.  */
/* This is done so users with query-level Progress can still make     */
/* changes to the Packing List output.  Database updates should be    */
/* put into separate routines.                                        */

{mfdeclre.i}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */

define new shared variable addr         as character format "x(38)" extent 6.
define new shared variable alc_sod_nbr  like sod_nbr.
define new shared variable alc_sod_line like sod_line.
define new shared variable tot_qty_all  like lad_qty_all.

define shared variable due_date      like sod_due_date.
define shared variable due_date1     like sod_due_date.
define shared variable site          like sod_site.
define shared variable site1         like sod_site.
define shared variable pages         as integer.
define shared variable old_sod_nbr   like sod_nbr.
define shared variable sod_recno     as recid.
define shared variable so_recno      as recid.
define shared variable first_line    as logical.
define shared variable print_neg     like mfc_logical.
define shared variable all_only      as logical initial yes
   label "Print Only Lines to Pick".
define shared variable print_options as logical initial no
   label "Print Features and Options".

define variable desc1      like pt_desc1.
define variable location   like pt_loc.
define variable i          as integer.
define variable descount   as integer.
define variable rev        like pt_rev.
define variable det_lines  as integer.
define variable desc2      like desc1.
define variable cspart-lbl as character format "x(15)".
define variable cont_lbl   as character format "x(9)" no-undo.
define variable so_db      like si_db.
define variable err-flag   as integer.
define variable rev-lbl    as character format "x(10)".

define variable qtyshipped as character format "x(8)" label " Shipped"
   initial "(      )".
define variable qty_all like lad_qty_all format "->>>>>9.9<<<<<"
   label "Qty to Ship".
define variable qty_open   like sod_qty_ord column-label "Qty Open!Qty to Ship"
   format "->>>>>9.9<<<<<".
define variable ext_price  like sod_price label "Ext Price"
   format "->>,>>>,>>9.99".

define new shared frame d.

DEFINE NEW SHARED VAR v_lad_loc LIKE lad_loc.

assign
   cont_lbl = dynamic-function('getTermLabelFillCentered' in h-label,
   input "CONTINUE", input 9, input '*').

find so_mstr where recid(so_mstr) = so_recno no-lock.

{xxsopkf01.i}  /* Define shared frame d for sales order lines */

so_db = global_db.

for each sod_det where
   (sod_nbr = so_nbr) and
   (sod_due_date >= due_date and sod_due_date <= due_date1) and
   (sod_site >= site and sod_site <= site1) and
   not sod_sched and
   ((sod_qty_all > 0 or (print_neg and sod_qty_all < 0)) or
    (not all_only and ((sod_qty_ord - sod_qty_pick - sod_qty_ship > 0) or
     (print_neg and sod_qty_ord - sod_qty_pick - sod_qty_ship < 0)) )) and
   sod_pickdate = ? and
   sod_confirm exclusive-lock
by sod_line with frame d width 80 down no-box:

   if page-size - line-counter < 3 then page.

   find si_mstr where si_site = sod_site no-lock.
   if si_db <> so_db then do:
      {gprun.i ""gpalias3.p"" "(si_db, output err-flag)" }
   end.

   /*CREATE HARD ALLOCATIONS IN THE INVENTORY SITE*/
   if sod_type = "" then do:
      assign
         alc_sod_nbr = sod_nbr
         alc_sod_line = sod_line.
      {gprun.i ""xxsopkall.p""}
   end.

   /*PRINT HEADER COMMENTS*/
   if old_sod_nbr <> sod_nbr then do:
      {gpcmtprt.i &type=PA &id=so_cmtindx &pos=3}
   end.

   old_sod_nbr = sod_nbr.

   /* PRINT ORDER DETAIL */
   assign
      qty_open = sod_qty_ord - sod_qty_ship - sod_qty_pick
      ext_price = sod_qty_all * sod_price
      desc1 = sod_desc
      desc2 = ""
      location = ""
      rev = "".

   find pt_mstr where pt_part = sod_part no-lock no-wait no-error.
   if available pt_mstr then do:
      if desc1 = "" then desc1 = pt_desc1.
      desc2 = pt_desc2.
      rev = pt_rev.
   end.

   location = "".

/******************* SS - Micho 20060320 B **************************/
   /*DISPLAY ALLOCATION DETAIL*/
   /* Done in a subroutine because the allocations are in the inventory db*/
   tot_qty_all = 0.
   if sod_type = "" then do:
      {gprun.i ""xxsopke01.p""}
   end.
   
/******************* SS - Micho 20060320 B **************************/

   /*DISPLAY LINES*/
   {xxsopkb01.i}

   down 1 with frame d.

   if rev <> "" then do:
      if page-size - line-counter < 1 then do:
         page.
         /*DISPLAY CONTINUED*/
         {xxsopkd01.i}
         down 1 with frame d.
      end.
      put rev-lbl at 5 rev skip.
   end.

   if desc1 <> "" then do:
      if page-size - line-counter < 1 then do:
         page.
         /*DISPLAY CONTINUED*/
         {xxsopkd01.i}
         down 1 with frame d.
      end.
      put desc1 at 5.
   end.

   if desc2 <> "" then do:
      if page-size - line-counter < 1 then do:
         page.
         /*DISPLAY CONTINUED*/
         {xxsopkd01.i}
         down 1 with frame d.
      end.
      put desc2 at 5.
   end.

   if sod_type <> "" and sod_qty_all > 0 then do:
      display
         /* sod_qty_all @ qty_open */
         qtyshipped @ sod_due_date
      with frame d.
      down 2 with frame d.
   end.

   /*
   if sod_custpart <> "" then do:
      if page-size - line-counter < 1 then do:
         page.
         /*DISPLAY CONTINUED*/
         {sopkd01.i}
         down 1 with frame d.
      end.
      put cspart-lbl at 7 sod_custpart at 23.
   end.
   */

   /*PRINT OPTIONS */
   /********************************************
    sob_serial subfield positions:
    1-4     operation number (old - now 0's)
    5-10    scrap percent
    11-14   id number of this record
    15-15   structure code
    16-16   "y" (indicates "new" format sob_det record)
    17-34   original qty per parent
    35-35   original mandatory indicator (y/n)
    36-36   original default indicator (y/n)
    37-39   leadtime offset
    40-40   price manually updated (y/n)
    41-46   operation number (new - 6 digits)
   *******************************************/
   if print_options and
      can-find(first sob_det where sob_nbr = so_nbr and sob_line = sod_line)
   then do:

      find first sob_det where sob_nbr = sod_nbr
                           and sob_line = sod_line
      no-lock no-error.

      /* NEW STYLE sob_det RECORDS CONTAIN A
         SYMBOLIC REFERENCE IDENTIFIED BY BYTES 11-14 IN sob_serial
      */
      {gprun.i ""sopkg01.p""
         "(input """", input 0,
           input sod_nbr, input sod_line)"}

   end.

   /*
   /* PRINT LINE ITEM COMMENTS */
   {gpcmtprt.i &type=PA &id=sod_cmtindx &pos=5
      &command="~{sopkd01.i~} down 1 with frame d."}
   */

/******************* SS - Micho 20060320 B **************************/
      /*
   /*DISPLAY ALLOCATION DETAIL*/
   /* Done in a subroutine because the allocations are in the inventory db*/
   tot_qty_all = 0.
   if sod_type = "" then do:
      {gprun.i ""xxsopke01.p""}
   end.
   */
/******************* SS - Micho 20060320 B **************************/
   
   first_line = no.

   /* UPDATE QTY SALES ORDER QTY PICK */
   if si_db <> so_db then do:
      /* Update sod in remote database */
      {gprun.i  ""sosopkb.p"" "(sod_nbr, sod_line, tot_qty_all)"}
      /* Switch back to the sales order database */
      {gprun.i ""gpalias3.p"" "(so_db, output err-flag)" }
   end.

   /* Update sod in SO database */
   {gprun.i  ""sosopkb.p"" "(sod_nbr, sod_line, tot_qty_all)"}

   {mfrpchk.i}

end.  /* For sod_... */
