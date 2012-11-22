/* rcshrp1b.p - Shipper  Report - PRINT SHIPPER LINES                        */
/* Copyright 1986-2005 QAD Inc., Carpinteria, CA, USA.                       */
/* All rights reserved worldwide.  This is an unpublished work.              */
/* $Revision: 1.6.1.11 $                                                              */
/*V8:ConvertMode=Report                                                      */
/* REVISION: 8.6      LAST MODIFIED: 10/09/96   BY: *K003* Kieu Nguyen       */
/* REVISION: 8.6      LAST MODIFIED: 03/15/97   BY: *K04X* Steve Goeke       */
/* REVISION: 8.6      LAST MODIFIED: 04/25/97   BY: *K0CH* Taek-Soo Chang    */
/* REVISION: 8.6      LAST MODIFIED: 07/30/97   BY: *K0H7* Taek-Soo Chang    */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane         */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan        */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan        */
/* REVISION: 9.1      LAST MODIFIED: 09/23/99   BY: *K230* Santosh Rao       */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane  */
/* REVISION: 9.1      LAST MODIFIED: 08/12/00   BY: *N0KP* myb               */
/* REVISION: 9.1      LAST MODIFIED: 01/25/01   BY: *M101* Rajesh Thomas     */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.6.1.5  BY: Katie Hilbert            DATE: 04/15/02 ECO: *P03J* */
/* Revision: 1.6.1.7  BY: Paul Donnelly (SB)       DATE: 06/28/03 ECO: *Q00K* */
/* Revision: 1.6.1.9  BY: Dayanand Jethwa          DATE: 12/27/04 ECO: *P317* */
/* $Revision: 1.6.1.11 $       BY: Swati Sharma             DATE: 02/08/05 ECO: *P371* */
/*-Revision end---------------------------------------------------------------*/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

{mfdeclre.i}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */
{xxshrp.i}

define input parameter sched_date as date.

/* SHARED VARIABLE */
define shared variable part   like pt_part no-undo.
define shared variable part1  like pt_part no-undo.
define shared variable sonbr  like so_nbr no-undo.
define shared variable sonbr1 like so_nbr no-undo.
define shared variable stype  as character no-undo.

/* LOCAL VARIABLE */

define variable vindent_id as character format "x(12)" label "Type".
define variable vabs_shipfrom like abs_shipfrom              .
define variable vabs_shipto like abs_shipto.
define variable vabs_inv_mov like abs_inv_mov.
define variable vabs_id  like abs_id.

define variable indent_id     as character format "x(12)" label "Type".
define variable par_shipfrom  as character.
define variable par_id        as character.
define variable open_qty      like sod_qty_ord label "Open Qty".
define variable due_date      like sod_due_date.
define variable sched_netting as logical initial no.
define variable l_shipper_po  like sod_contr_id format "x(22)" no-undo.

define variable l_absitem     like abs_item      no-undo.
define variable l_abssite     like abs_site      no-undo.
define variable l_absorder    like abs_order     no-undo.
define variable l_abs_line    like abs_line      no-undo.
define variable ship-qty      like abs_qty       no-undo.
define variable l_shp_date    like abs_shp_date  no-undo.
define variable l_pt_um       like pt_um         no-undo.

define shared temp-table ship_abs
   field ship_id              like abs_id
   field ship_shipto          like abs_shipto
   field ship_shipfrom        like abs_shipfrom
   field ship_recid           as recid.

/* form                                                                */
/*    indent_id                                                        */
/*    l_absitem     column-label "Ship-To!Item Number!Model Year"      */
/*    scx_po        column-label "ID!PO Number!Customer Ref"           */
/*    l_abssite     column-label "Ship-From!Site"                      */
/*    l_absorder    column-label "Inv Mov!Order"                       */
/*    l_abs_line     column-label "Line"                               */
/*    l_pt_um                                                          */
/*    open_qty                                                         */
/*    due_date                                                         */
/*    ship-qty      format "->,>>>,>>9.9<<<"                           */
/*    l_shp_date                                                       */
/* with frame c down width 132 no-box.                                 */
/*                                                                     */
/* /* SET EXTERNAL LABELS */                                           */
/* setFrameLabels(frame c:handle).                                     */

for each ship_abs
   no-lock :
   run rptprint (ship_recid , 0 , sched_date) .
end . /* FOR EACH ship_abs */

PROCEDURE rptprint :
   define input parameter abs_recid  as recid.
   define input parameter indent_ct  as integer.
   define input parameter sched_date as date.

   due_date = ? .

   for first abs_mstr
      fields(abs_id     abs_inv_mov  abs_item abs_line
             abs_order  abs_par_id   abs_qty  abs_shipfrom
             abs_shipto abs_shp_date abs_site abs_domain)
      where recid(abs_mstr) = abs_recid
      no-lock :
   end. /* FOR FIRST abs_mstr */

   if indent_ct = 0
   or abs_id begins "c"
   or (    (    abs_item >= part
            and abs_item <= part1)
       and (    abs_order >= sonbr
            and abs_order <= sonbr1)
      )
   then do:
      l_pt_um = abs__qad02.

      if l_pt_um = ""
      then do:
         for first idh_hist
            fields (idh_domain idh_inv_nbr idh_nbr idh_line idh_um)
            where idh_domain = global_domain
            and   idh_nbr    = abs_order
            and   idh_line   = integer(abs_line)
            and   idh_part   = abs_item
         no-lock:
         end. /* FOR FIRST idh_hist */
         if available idh_hist
         then
            l_pt_um = idh_um.
         else do:
            for first sod_det
               fields (sod_domain sod_nbr sod_line sod_um)
               where sod_domain = global_domain
               and   sod_nbr    = abs_order
               and   sod_line   = integer(abs_line)
            no-lock:
            end. /* FOR FIRST sod_det */
           if available sod_det
           then
              l_pt_um = sod_um.
           else
              for first pt_mstr
                 fields (pt_part pt_um pt_domain)
                 where pt_domain = global_domain
                 and   pt_part   = abs_item
              no-lock :
                 l_pt_um = pt_um.
              end. /* FOR FIRST pt_mstr */
         end. /* ELSE DO */
      end. /* IF l_pt_um = "" */

      if indent_ct = 0
      then
         indent_id = stype.
      else
         indent_id = substring("...........",1,indent_ct) +
                     if abs_id begins "i" then "I" else abs_id.

      indent_id = caps(indent_id).

      for first so_mstr
         fields (so_nbr so_ship_po so_domain )
         where so_domain = global_domain
         and   so_nbr    = abs_order
         no-lock :
      end. /* FOR FIRST so_mstr */

      for first sod_det
         fields (sod_contr_id sod_custref  sod_due_date
                 sod_line     sod_modelyr  sod_nbr
                 sod_qty_ord  sod_qty_ship sod_sched
                 sod_domain)
         where sod_domain = global_domain
         and   sod_nbr    = abs_order
         and   sod_line   = integer(abs_line)
         no-lock :
      end. /* FOR FIRST sod_det */

      if available sod_det
      then do:
         if sod_sched
         then do:
            {gprun.i ""rcoqty.p""
               "(input recid(sod_det),
                 input sched_date,
                 input sched_netting,
                 output open_qty)"}.
            due_date = sched_date.
         end. /* IF sod_sched */
         else
            assign
               due_date = sod_due_date
               open_qty = sod_qty_ord - sod_qty_ship.
      end.  /* IF AVAILABLE sod_det */
      else
         open_qty = 0.

      if available sod_det
      then do:
         if sod_sched then
            l_shipper_po = sod_contr_id.
         else
         if available so_mstr then
            l_shipper_po = so_ship_po.
      end. /* IF AVAILABLE SOD_DET */
      else do:
         l_shipper_po = "".
         for each ih_hist
            fields (ih_nbr ih_inv_nbr ih_ship_po ih_domain)
            where ih_domain = global_domain
            and   ih_nbr    = abs_order
            no-lock,
            first idh_hist
            fields (idh_inv_nbr idh_nbr      idh_line idh_part
                    idh_sched   idh_contr_id idh_domain)
            where idh_domain  = global_domain
            and   idh_nbr     = ih_nbr
            and   idh_line    = integer(abs_line)
            and   idh_part    = abs_item
            no-lock :
            l_shipper_po = if idh_sched
                           then
                              idh_contr_id
                           else
                              ih_ship_po .
            leave .
         end. /* FOR EACH  idh_hist */
      end. /* IF NOT AVAILABLE SOD_DET */

      if indent_ct = 0
      then do:                                                            
         assign vindent_id = indent_id                             
                vabs_shipfrom = abs_shipfrom                                             
                vabs_shipto = abs_shipto                                             
                vabs_inv_mov  = abs_inv_mov                                             
                vabs_id = abs_id.                                              
 /*        display                                          */
 /*           indent_id                                     */
 /*           abs_shipfrom        @ l_abssite               */
 /*           abs_shipto          @ l_absitem               */
 /*           abs_inv_mov         @ l_absorder              */
 /*           substring(abs_id,2) @ scx_po                  */
 /*        with frame c.                                    */
      end.
      else do:
/*         display                                                            */
/*            indent_id                                                       */
/*            abs_item     @ l_absitem                                        */
/*            l_shipper_po @ scx_po                                           */
/*            abs_site     @ l_abssite                                        */
/*            abs_order    @ l_absorder                                       */
/*            string(integer(abs_line),">>>9") format "x(4)" @ l_abs_line     */
/*            abs_qty      @ ship-qty                                         */
/*            l_pt_um                                                         */
/*            open_qty                                                        */
/*            due_date                                                        */
/*            abs_shp_date @ l_shp_date                                       */
/*         with frame c.                                                      */
/*         down 1 with frame c.                                               */
/*         display                                                            */
/*            sod_modelyr when (available sod_det) @ l_absitem                */
/*            sod_custref when (available sod_det) @ scx_po                   */
/*         with frame c.                                                      */

                                                                                  
   			 for each xxsh_mst no-lock where xxsh_domain = global_domain and          
   			 					xxsh_site = vabs_shipfrom and xxsh_abs_id = vabs_id:            
				 		 create xsh_det.                                                      
				 		 assign xsh_indent_id = indent_id
				 		 			  xsh_site = vabs_shipfrom
				 		 			  xsh_abs_id = vabs_id
				 		 			  xsh_nbr = xxsh_nbr
				 		 			  xsh_abs_item = abs_item
				 		 			  xsh_shipper_po = l_shipper_po 
				 		 			  xsh_abs_site = abs_site
				 		 			  xsh_abs_order = abs_order
				 		 			  xsh_abs_line = abs_line
				 		 			  xsh_abs_qty = abs_qty
				 		 			  xsh_um = l_pt_um
				 		 			  xsh_open_qty = open_qty
				 		 			  xsh_due_date = due_date
				 		 			  xsh_abs_shp_date = abs_shp_date
				 		 			  xsh_sod_modelyr = sod_modelyr when (available sod_det)
				 		 			  xsh_sod_custref = sod_custref when (available sod_det).
 		     end.   
         
         
      end. /* IF indent_ct <> 0 */

/*      down 1 with frame c. */

   end. /* IF indent_ct = 0 ..... */

   if abs_id begins "i"
   then
      return.

   assign
      par_shipfrom = abs_shipfrom
      par_id       = abs_id.

   for each abs_mstr
      fields(abs_id     abs_inv_mov  abs_item abs_line
             abs_order  abs_par_id   abs_qty  abs_shipfrom
             abs_shipto abs_shp_date abs_site abs_domain)
      where abs_domain   = global_domain
      and   abs_shipfrom = par_shipfrom
      and   abs_par_id   = par_id
      no-lock :

      if (    abs_order >= sonbr
          and abs_order <= sonbr1
          and abs_item  >= part
          and abs_item  <= part1
         )
      or abs_id begins "c"
      then do:
         run rptprint
            (input recid(abs_mstr),
              input (indent_ct + 1),
              input sched_date) .
      end. /*  IF (    abs_order >= sonbr ...... */
   end.  /* FOR EACH abs_mstr  */
END PROCEDURE . /* rptprint */
