/* reworlc.p - EXPLODE REPETITIVE SCHEDULE copy ro_det to wr_route            */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.6.1.2 $                                                       */
/*V8:ConvertMode=Maintenance                                                  */
/* REVISION: 5.0       LAST EDIT: 06/01/89      MODIFIED BY: emb              */
/* REVISION: 7.0       LAST EDIT: 05/22/92      MODIFIED BY: emb *F521*       */
/* REVISION: 7.3       LAST EDIT: 01/13/93      MODIFIED BY: emb *G689*       */
/* REVISION: 7.3       LAST EDIT: 09/05/95      MODIFIED BY: str *G0WB*       */
/* REVISION: 8.6   LAST MODIFIED: 02/27/98      BY: *J23R* Santhosh Nair      */
/* REVISION: 9.1   LAST MODIFIED: 08/12/00      BY: *N0KP* Mark Brown         */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* $Revision: 1.6.1.2 $   BY: Jean Miller        DATE: 04/16/02  ECO: *P05H*  */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

{mfdeclre.i}

define shared variable wo_recno as recid.
define shared variable eff_date as date.
define variable yield as decimal no-undo initial 100.
define variable oldop like wod_op .   /*tfq*/
define variable oldwk like wr_wkctr .  /*tfq*/

 DEFINE VARIABLE part LIKE ps_par INITIAL "so20443" .
  define  variable site1 like in_site .
   define new shared variable transtype as character format "x(4)".
 define new shared variable errmsg as integer .

        define NEW shared workfile pkdet no-undo
        field pkpart like ps_comp
        field pkop as integer
                          format ">>>>>9"
        field pkstart like pk_start
        field pkend like pk_end
        field pkqty like pk_qty
       field pkbombatch like bom_batch
        field pkltoff like ps_lt_off. 

for first wo_mstr
fields(wo_lot wo_nbr wo_part wo_qty_comp wo_qty_ord wo_rel_date wo_routing)
   where recid(wo_mstr) = wo_recno
no-lock: end.

if available wo_mstr then do:

   /* Copy routing to operations (wr_route) */
   {rescttdf.i "shared"}

   for each wr_route exclusive-lock where wr_lot = wo_lot:

      for first ro_det
      fields(ro_desc ro_end ro_mch ro_mch_op ro_men_mch ro_milestone ro_move
             ro_op ro_po_line ro_po_nbr ro_queue ro_routing ro_run ro_setup
             ro_setup_men ro_start ro_std_op ro_sub_cost ro_sub_lead ro_tool
             ro_tran_qty ro_vend ro_wait ro_wkctr ro_yield_pct)
         where ro_routing = (if wo_routing > """" then wo_routing else wo_part)
           and ro_op = wr_op
           and (ro_start = ? or ro_start <= wo_rel_date)
           and (ro_end = ? or ro_end >= wo_rel_date)
      no-lock: end.

      if available ro_det then next.

      find qad_wkfl where
           qad_key1 = "wr_route" and
           qad_key2 = wo_lot + string(wr_op)
      exclusive-lock no-error.

      if not available qad_wkfl then
         find qad_wkfl where
              qad_key1 = "wr_route" and
              qad_key2 = wo_lot + "@" + string(wr_op)
         exclusive-lock no-error.

      if available qad_wkfl then delete qad_wkfl.

      delete wr_route.

   end.

   for each ro_det
   fields(ro_desc ro_end ro_mch ro_mch_op ro_men_mch ro_milestone ro_move
          ro_op ro_po_line ro_po_nbr ro_queue ro_routing ro_run ro_setup
          ro_setup_men ro_start ro_std_op ro_sub_cost ro_sub_lead ro_tool
          ro_tran_qty ro_vend ro_wait ro_wkctr ro_yield_pct)
      where ro_routing = (if wo_routing > """" then wo_routing else wo_part)
   no-lock:

      if (ro_start = ? or ro_start <= wo_rel_date) and
         (ro_end = ? or ro_end >= wo_rel_date)
      then do:

         for first wr_route where
            wr_lot = wo_lot and
            wr_op = ro_op:
         end.

         if not available wr_route then do:
            create wr_route.
            assign
               wr_nbr = wo_nbr
               wr_lot = wo_lot
               wr_part = wo_part
               wr_op = ro_op.
         end.

         find first t_wr_route
              where t_wr_lot    = wr_lot
              and   t_wr_op     = wr_op
         no-lock no-error.

         assign
            wr_std_op = ro_std_op
            wr_desc = ro_desc
            wr_wkctr = ro_wkctr
            wr_mch = ro_mch
            wr_milestone = ro_milestone
            wr_setup = ro_setup
            wr_run = ro_run
            wr_move = ro_move
            wr_qty_ord = min(max(wo_qty_ord - (if available(t_wr_route) then
                                           (t_wr_scrap)
                                        else 0), 0), wo_qty_ord)
            wr_qty_comp = max(wr_qty_comp,wo_qty_comp)
            wr_tool = ro_tool
            wr_mch_op = ro_mch_op
            wr_vend = ro_vend.

         assign
            wr_yield_pct = ro_yield
            wr_setup_men = ro_setup_men
            wr_men_mch   = ro_men_mch
            wr_tran_qty  = ro_tran_qty
            wr_queue     = ro_queue
            wr_wait      = ro_wait
            wr_sub_cost  = ro_sub_cost
            wr_sub_lead  = ro_sub_lead.

         yield = yield * ro_yield * .01.

         wr_po_nbr   = ro_po_nbr.
         wr_po_line  = ro_po_line.

      end.

   end.
/***********tfq added begin*********************************/
            {gprun.i ""yybmpkiqa.p"" "(input wo_part,
                               INPUT wo_site,
                               INPUT wo_rel_date)"}
   FOR EACH pkdet break by pkop  :
   find first wod_det where wod_part = pkpart and wod_nbr = wo_nbr and wod_lot = wo_lot 
   no-error .
   if available wod_det then
   do:  
   if wod_op <> pkop then 
   do:
   oldop = wod_op .
   find first  wr_route where wr_nbr = wo_nbr
                   and            wr_lot = wo_lot
                   and            wr_part = wo_part 
                   and            wr_op = oldop no-lock no-error .
   if available wr_route then  oldwk = wr_wkctr .               
   wod_op = pkop .
   end.
   if first-of(pkop) then do:
 
        find first wr_route where wr_nbr = wo_nbr
                   and            wr_lot = wo_lot
                   and            wr_part = wo_part 
                   and            wr_op = pkop no-error .
          if not available wr_route then
            do:
            create wr_route .
            assign wr_nbr = wo_nbr
                   wr_lot = wo_lot
                   wr_part = wo_part 
                   wr_op = pkop 
                   wr_wkctr = oldwk .
                   
            end.  /*not available wr_route*/
          
          end.   /*first-of pkop*/
       end.     /*available wod_det*/       
     delete pkdet .
    END.  /*for each pkdet*/
                            

/***********tfq added end***********************************/
end.

