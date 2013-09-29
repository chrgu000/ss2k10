/* piptcr.p - CREATE PART TAG RECORDS                                         */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.8.1.8 $                                                       */
/*V8:ConvertMode=Maintenance                                                  */
/* REVISION: 6.0      LAST MODIFIED: 03/06/90   BY: WUG *D015*                */
/* REVISION: 6.0      LAST MODIFIED: 10/03/91   BY: alb *D887*(rev only)      */
/* REVISION: 6.0      LAST MODIFIED: 03/05/92   BY: WUG *F254*                */
/* REVISION: 7.5      LAST MODIFIED: 12/22/94   BY: mwd *J034*                */
/* REVISION: 7.2      LAST MODIFIED: 02/17/95   BY: cpp *F0JG*/
/* REVISION: 7.4      LAST MODIFIED: 10/25/96   BY: *H0N4* Murli Shastri      */
/* REVISION: 8.5      LAST MODIFIED: 01/10/97   BY: *H0QP* Julie Milligan     */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane          */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan         */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan         */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* REVISION: 9.1      LAST MODIFIED: 08/10/00   BY: *N0J4* Mudit Mehta        */
/* Revision: 1.8.1.6     BY: Patrick Rowan       DATE: 04/24/01  ECO: *P00G*  */
/* Revision: 1.8.1.7     BY: Patrick Rowan       DATE: 04/11/02  ECO: *P05G*  */
/* Revision: 1.8.1.8     BY: Jean Miller         DATE: 05/11/02  ECO: *P05V*  */
/* $Revision: eb2sp4	$BY: Cosesa Yang         DATE: 09/10/13  ECO: *SS - 20130910.1* */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/
/* ss - 130910.1 - b
{mfdtitle.i "2+ "} */
{mfdeclre.i}
{gplabel.i}

define input parameter i_site  like si_site.
define input parameter i_site1 like si_site.
define input parameter i_loc  like loc_loc.
define input parameter i_loc1 like loc_loc.
define input parameter i_line  like pl_prod_line.
define input parameter i_line1 like pl_prod_line.
define input parameter i_part  like pt_part.
define input parameter i_part1 like pt_part.
define input parameter i_abc  like pt_abc.
define input parameter i_abc1 like pt_abc.
define input parameter i_incl_zero  like mfc_logical .
define input parameter i_incl_negative   like mfc_logical .
define input parameter i_sortoption   as integer .
/* ss - 130910.1 - e */
define variable site           like si_site.
define variable site1          like si_site label "To".
define variable loc            like loc_loc.
define variable loc1           like loc_loc label "To".
define variable line           like pl_prod_line.
define variable line1          like pl_prod_line label "To".
define variable part           like pt_part.
define variable part1          like pt_part label "To".
define variable abc            like pt_abc.
define variable abc1           like pt_abc  label "To".
define variable start_tagnbr   like tag_nbr label "Starting Tag Number".
define variable last_tagnbr    as   integer.
define variable avail_tags     as   integer format "99999999".
define variable incl_zero      like mfc_logical label "Include Zero Quantity".
define variable incl_negative  like mfc_logical label "Include Negative Quantity".
define variable sortoption     as integer       label "Sort Option"
   format "9" initial 1.
define variable sortextoption   as character extent 3 format "x(46)".
define variable calculated_qty_oh as decimal no-undo.

define variable yn              like mfc_logical.
define variable tagnbr          like tag_nbr.
define variable tagcount        like tag_nbr.
define variable todays_date     as date.
define variable disp-tags-available as character no-undo format "x(26)".

/* CONSIGNMENT VARIABLES */
{pocnvars.i}
{pocnvar2.i}
/* ss - 130910.1 - b
assign
   sortextoption[1] = "1 - "  +
   getTermLabel("ITEM",6) + ", " +
   getTermLabel("SITE",6) + ", " +
   getTermLabel("LOCATION",11) + ", " +
   getTermLabel("LOT/SERIAL",13)
   sortextoption[2] = "2 - " +
   getTermLabel("SITE",6) + ", " +
   getTermLabel("LOCATION",11) + ", " +
   getTermLabel("ITEM",6) + ", " +
   getTermLabel("LOT/SERIAL",13)
   sortextoption[3] = "3 - "  +
   getTermLabel("ITEM",6) + ", " +
   getTermLabel("LOT/SERIAL",13) + ", " +
   getTermLabel("SITE",6) + ", " +
   getTermLabel("LOCATION",11)
   disp-tags-available = getTermLabel("TAGS_AVAILABLE",24) + " )".
*/
form
   site                 colon 15
   site1                colon 49
   loc                  colon 15
   loc1                 colon 49
   line                 colon 15
   line1                colon 49
   part                 colon 15
   part1                colon 49
   abc                  colon 15
   abc1                 colon 49
   skip(1)
   start_tagnbr         colon 27
   "("                  at 39
   avail_tags           at 41 no-label
   disp-tags-available  at 51 no-label
   incl_zero            colon 27
   incl_negative        colon 27
   customer_consign     colon 27
   supplier_consign     colon 27
   sortoption           colon 27
   sortextoption[1]     at 32 no-label
   sortextoption[2]     at 32 no-label
   sortextoption[3]     at 32 no-label
with frame a side-labels attr-space width 80.

/* SET EXTERNAL LABELS */
/* ss - 130910.1 - b setFrameLabels(frame a:handle). */

/* DETERMINE IF CUSTOMER CONSIGNMENT IS ACTIVE */
{gprun.i ""gpmfc01.p""
   "(input ENABLE_CUSTOMER_CONSIGNMENT,
     input 10,
     input ADG,
     input CUST_CONSIGN_CTRL_TABLE,
     output using_cust_consignment)"}

/* DETERMINE IF SUPPLIER CONSIGNMENT IS ACTIVE */
{gprun.i ""gpmfc01.p""
   "(input ENABLE_SUPPLIER_CONSIGNMENT,
     input 11,
     input ADG,
     input SUPPLIER_CONSIGN_CTRL_TABLE,
     output using_supplier_consignment)"}

if using_cust_consignment then do:
   {gplngn2a.i
      &file = ""cncix_ref""
      &field = ""report""
      &code = customer_consign_code
      &mnemonic = "customer_consign"
      &label    = customer_consign_label}
end.  /* if using_cust_consignment */

if using_supplier_consignment then do:
   {gplngn2a.i
      &file = ""cnsix_ref""
      &field = ""report""
      &code = supplier_consign_code
      &mnemonic = "supplier_consign"
      &label    = supplier_consign_label}
end.  /* if using_supplier_consignment */
/* ss - 130910.1 - b 
mainloop:
repeat:
*/  
   site = i_site .
   site1 = i_site1 .
   loc  = i_loc.
   loc1 = i_loc1.
   line = i_line  .
   line1 = i_line1 .
   part = i_part  .
   part1 = i_part1 .
   abc = i_abc  .
   abc1 = i_abc1 . 
   incl_zero = i_incl_zero.
   incl_negative = i_incl_negative.
   sortoption  = i_sortoption  .

   /* ss - 130910.1 - e */

   find last tag_mstr where tag_nbr >= 0 no-lock no-error.

   assign avail_tags = 0.

   if available tag_mstr and tag_nbr < 99999999 then
      assign start_tagnbr = tag_nbr + 1.
   else
   if available tag_mstr then
      assign start_tagnbr = 99999999.
   else
      assign start_tagnbr = 1.

   if start_tagnbr = 99999999 then do:
      /* MAXIMUM TAG NUMBER HAS BEEN USED, */
      /* PLEASE DELETE/ARCHIVE TAG RECORDS */
      {pxmsg.i &MSGNUM=1571 &ERRORLEVEL=1}
   end.

   assign
      last_tagnbr = start_tagnbr
      avail_tags  = if available tag_mstr and tag_nbr = 99999999 then 0
                    else 99999999 - start_tagnbr + 1.

   if site1 = hi_char then site1 = "".
   if loc1 = hi_char then loc1 = "".
   if line1 = hi_char then line1 = "".
   if part1 = hi_char then part1 = "".
   if abc1 = hi_char then abc1 = "".
/* ss - 130910.1 - b */
/*
   display
      disp-tags-available
   with frame a.

   display
      sortextoption
      avail_tags
   with frame a.

   update
      site
      site1
      loc
      loc1
      line
      line1
      part
      part1
      abc
      abc1
      start_tagnbr
      incl_zero
      incl_negative
      customer_consign
      supplier_consign
      sortoption
   with frame a.
 */
   if sortoption < 1 or sortoption > 3 then do:
      /* Invalid Option */
      {pxmsg.i &MSGNUM=712 &ERRORLEVEL=3}
      next-prompt sortoption with frame a.
      undo, retry.
   end.

/* ss - 130910.1 - e */

   if site1 = "" then site1 = hi_char.
   if loc1 = "" then loc1 = hi_char.
   if line1 = "" then line1 = hi_char.
   if part1 = "" then part1 = hi_char.
   if abc1 = "" then abc1 = hi_char.

   {gprun.i ""gpsirvr.p""
      "(input site, input site1, output return_int)"}
   if return_int = 0 then do:
      next-prompt site with frame a.
      undo , retry .
   end.

   if using_cust_consignment then do:
      {gplngv.i
         &file = ""cncix_ref""
         &field = ""report""
         &mnemonic = "customer_consign"
         &isvalid  = mnemonic_valid}

      if not mnemonic_valid then do:
         {pxmsg.i &MSGNUM=712 &ERRORLEVEL=3} /*INVALID OPTION*/
         next-prompt customer_consign with frame a.
         undo, retry.
      end.

      {gplnga2n.i
         &file = ""cncix_ref""
         &field = ""report""
         &code = customer_consign_code
         &mnemonic = "customer_consign"
         &label    = customer_consign_label}
   end.  /* if using_cust_consignment */

   if using_supplier_consignment then do:

      {gplngv.i
         &file = ""cnsix_ref""
         &field = ""report""
         &mnemonic = "supplier_consign"
         &isvalid  = mnemonic_valid}

      if not mnemonic_valid then do:
         /* Invalid Option */
         {pxmsg.i &MSGNUM=712 &ERRORLEVEL=3}
         next-prompt supplier_consign with frame a.
         undo, retry.
      end.

      {gplnga2n.i
         &file = ""cnsix_ref""
         &field = ""report""
         &code = supplier_consign_code
         &mnemonic = "supplier_consign"
         &label    = supplier_consign_label}

   end.  /* if using_supplier_consignment */

   if not using_cust_consignment then
      customer_consign = "1".           /* EXCLUDE */
   if not using_supplier_consignment then
      supplier_consign = "1".           /* EXCLUDE */

   todays_date = today.
   tagnbr = start_tagnbr.
   tagcount = 0.

   find tag_mstr where tag_nbr = tagnbr no-error.
   if available tag_mstr then do:
      /* Tag number already exists within the range to be created */
      {pxmsg.i &MSGNUM=2401 &ERRORLEVEL=1}
      undo, retry.
   end.

   else if (tagnbr < last_tagnbr) then do:
      find first tag_mstr where tag_nbr > start_tagnbr
      no-lock no-error.

      if available tag_mstr then
            assign avail_tags    = tag_nbr - start_tagnbr.

      display avail_tags with frame a.

      /* SEQUENTIAL TAG NUMBERS AVAILABLE FROM  STARING TAG NUMBER = */
      {pxmsg.i &MSGNUM=1572 &ERRORLEVEL=2 &MSGARG1=avail_tags}
   end.
   else if tagnbr > last_tagnbr then
      display
         (99999999 - tagnbr + 1) @ avail_tags
      with frame a.

/* ss - 130910.1 - b */
/*
   yn = yes.
   /* Please confirm update */
   {pxmsg.i &MSGNUM=32 &ERRORLEVEL=1 &CONFIRM=yn}
   if not yn then undo, retry.

   if sortoption = 1 then do:
      {piptcr.i ld_part_loc}
   end.
   else
   if sortoption = 2 then do:
      {piptcr.i ld_loc_p_lot}
   end.
   else
   if sortoption = 3 then do:
      {piptcr.i ld_part_lot}
   end.
*/
   if sortoption = 1 then do:
      {xxpiptcr.i ld_part_loc}
   end.
   else
   if sortoption = 2 then do:
      {xxpiptcr.i ld_loc_p_lot}
   end.
   else
   if sortoption = 3 then do:
      {xxpiptcr.i ld_part_lot}
   end.
/* ss - 130910.1 - e */
   /* Update Complete */
/* ss - 130916.1 -  {pxmsg.i &MSGNUM=1300 &ERRORLEVEL=1} 

end.
*/