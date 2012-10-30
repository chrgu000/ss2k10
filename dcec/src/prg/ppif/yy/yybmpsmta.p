/* bmpsmta.p - ADD / MODIFY PRODUCT STRUCTURE Cyclical Check (where-used)    */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.5.1.4 $                                                             */
/*V8:ConvertMode=NoConvert                                                   */
/*V8:RunMode=Character,Windows                                               */
/* REVISION: 1.0    LAST EDIT: 03/13/86      MODIFIED BY: EMB                */
/* REVISION: 1.0    LAST EDIT: 09/18/86      MODIFIED BY: EMB                */
/* REVISION: 5.0    LAST EDIT: 09/26/89               BY: MLB *B316*         */
/* REVISION: 7.3    LAST EDIT: 01/26/93      MODIFIED BY: emb *G950*         */
/* REVISION: 7.3    LAST EDIT: 07/29/93      MODIFIED BY: emb *GD82*         */
/* REVISION: 7.3    LAST EDIT: 02/14/94      MODIFIED BY: pxd *FM16*         */
/* REVISION: 8.5    LAST MODIFIED: 03/09/98  MODIFIED BY: *J29L* Kawal Batra */
/* REVISION: 8.6    LAST MODIFIED: 05/20/98  BY: *K1Q4* Alfred Tan           */
/* REVISION: 9.1    LAST MODIFIED: 12/07/99  BY: *N08X* Brian Wintz          */
/* REVISION: 9.1    LAST MODIFIED: 08/17/00  BY: *N0LJ* Mark Brown                  */
/* Old ECO marker removed, but no ECO header exists *F0PN*                   */

{pxgblmgr.i}

define shared variable ps_recno             as   recid.
define shared variable global_user_lang     like cmt_lang.
define shared variable global_user_lang_nbr like lng_nbr.
define shared variable global_user_lang_dir like lng_dir.

define variable part     like pt_part     no-undo.
define variable part1    like pt_part     no-undo.
define variable par      like ps_par      no-undo.
define variable level    as   integer     initial 1     no-undo.
define variable maxlevel as   integer     initial 999   no-undo.
define variable record   as   recid       extent 1000   no-undo.
define variable site     like si_site     no-undo.
define variable ckrecsz  as   integer     initial 10000 no-undo.
define variable skip_par like mfc_logical no-undo.
define variable ckrecs   as   character   no-undo.

for first mfc_ctrl
   field (mfc_field mfc_integer)
   where mfc_field = "num_ckrecs" no-lock:
end. /* for first mfc_ctrl */

if available mfc_ctrl then ckrecsz = mfc_integer.

for first ps_mstr
   fields (ps_comp ps_par)
   where recid(ps_mstr) = ps_recno no-lock:
end. /* for first ps_mstr */

if available ps_mstr
then do:
   assign
      part1 = ps_comp
      part  = ps_par
      par   = ps_par.

   hide message no-pause.
   /* CHECKING FOR CYCLIC STRUCTURES */
 /*tfq  {mfmsg.i 5004 1}    */

   if can-find(first ps_mstr where ps_par = part1 and ps_comp = part)
   then do:
      ps_recno = 0.
      leave.
   end. /* then do: */

   for first ps_mstr
      fields (ps_comp ps_par)
      use-index ps_comp where ps_comp = part no-lock:
   end. /* for first ps_mstr */

   if ps_recno <> 0 then
   repeat:
      if not available ps_mstr
      then do:
         for each ptp_det
            fields (ptp_bom_code ptp_part ptp_site)
            no-lock where ptp_bom_code = par:
            if ptp_part = part1
            then do:
               ps_recno = 0.
               leave.
            end. /* if ptp_part = part1 then do: */

            {gprun.i ""bmpsmta1.p""
               "(ptp_part,ptp_site,part1,input-output ps_recno)"}
            if ps_recno = 0 then leave.
         end. /* for each ptp_det */

         if ps_recno = 0 then leave.

         for each pt_mstr
            fields (pt_bom_code pt_part)
            no-lock where pt_bom_code = par:
            if pt_part = part1
            then do:
               ps_recno = 0.
               leave.
            end. /* if pt_part = part1 then do: */

            {gprun.i ""bmpsmta1.p""
               "(pt_part,site,part1,input-output ps_recno)"}
            if ps_recno = 0 then leave.
         end. /* for each pt_mstr */

         if ps_recno = 0 then leave.

         repeat:
            level = level - 1.
            if level < 1 then leave.

            for first ps_mstr
               fields (ps_comp ps_par)
               no-lock where recid(ps_mstr) = record[level]:
            end. /* for first ps_mstr */

            do while available ps_mstr:
               part = ps_comp.
               find next ps_mstr no-lock use-index ps_comp
                  where ps_comp = part no-error.

               if not available ps_mstr then leave.

               if can-do(ckrecs,string(recid(ps_mstr))) then next.
               leave.
            end. /* do while available ps_mstr: */
            if available ps_mstr then leave.
         end. /* repeat: */
      end. /* if not available ps_mstr then do: */

      if level < 1 then leave.

      if ps_par = part1 then ps_recno = 0.

      if ps_recno = 0 then leave.

      skip_par = no.
      if can-do(ckrecs,string(recid(ps_mstr))) then skip_par = yes.

      if skip_par = no
         and level > 1
      then do:

         if length(ckrecs) < ckrecsz then
            ckrecs = ckrecs + "," + string(recid(ps_mstr)).
      end. /* then do: */

      record[level] = recid(ps_mstr).

      if level < maxlevel
         and skip_par = no
      then do:

         assign
            par   = ps_par
            level = level + 1.

         for first ps_mstr
               fields (ps_comp ps_par)
               no-lock use-index ps_comp where ps_comp = par:
         end. /* for first ps_mstr */
      end. /* then do: */
      else do:
         find next ps_mstr no-lock use-index ps_comp
            where ps_comp = par no-error.
      end. /* else do: */
   end. /* repeat: */
end. /* if available ps_mstr then do: */

hide message no-pause.

