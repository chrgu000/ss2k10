/* CHECK TO SEE IF IT IS OK TO TRANSFER */
/*-Revision end---------------------------------------------------------------*/

{mfdeclre.i}

define input parameter fromsite like ld_site no-undo.
define input parameter tosite like ld_site no-undo.
define input parameter fromloc like ld_site no-undo.
define input parameter toloc like ld_loc no-undo.
define input parameter part like ld_part no-undo.
define input parameter lot like ld_lot no-undo.
define input parameter ref like ld_ref no-undo.
define input parameter lotserial_qty like sr_qty no-undo.
define input parameter use-to-loc-status like mfc_logical no-undo.
define output parameter undo-update like mfc_logical no-undo.

define shared variable trans_um like pt_um.
define shared variable trans_conv like sod_um_conv.
define variable undo-input like mfc_logical no-undo.
define variable from_expire like ld_expire no-undo.
define variable from_assay like ld_assay no-undo.
define variable from_grade like ld_grade no-undo.
define variable from_status like ld_status no-undo.

define  shared TEMP-TABLE trhist1
        fields tr1_domain  like tr_domain
        fields tr1_site    like tr_site
        fields tr1_trnbr   like tr_trnbr
        fields tr1_part    like tr_part
        fields tr1_nbr     like tr_nbr
        fields tr1_line    like tr_line
        fields tr1_lot     like tr_lot
        fields tr1_serial  like tr_serial
        fields tr1_ref     like tr_ref
        fields tr1_loc     like tr_loc
        fields tr1_qty_loc like tr_qty_loc
        fields tr1__dec01  like tr__dec01
        fields tr1__log01  like tr__log01
        fields tr1_chg     like tr_qty_loc
        fields tr1_loc_to     like tr_loc
        INDEX tr1_nbr IS PRIMARY tr1_nbr tr1_line tr1_trnbr
        INDEX tr1_part  tr1_part tr1_nbr tr1_line.

         find pt_mstr  where pt_mstr.pt_domain = global_domain and  pt_part =
         part no-lock no-error.

         assign
           trans_um = if available pt_mstr then pt_um else ""
           trans_conv = 1
         undo-update = yes.

         {gprun.i ""icedit.p""
        "(""RCT-TR"",
           tosite,
           toloc,
           part,
           lot,
           ref,
           lotserial_qty,
           trans_um,
           """",
           """",
           output undo-input)"
          }
     if undo-input then return.

         /*GET THE FROM LOCATION EXPIRE ASSAY GRADE AND STATUS */
         find ld_det  where ld_det.ld_domain = global_domain
            and  ld_site = fromsite and
                      ld_loc = fromloc and
                      ld_part = part and
                      ld_lot = lot and
                      ld_ref = ref no-lock no-error.
         if available ld_det then do:
         assign
         from_expire = ld_expire
         from_assay = ld_assay
         from_grade = ld_grade
         from_status = ld_status.

         /*GET THE TO LOCATION */
         find ld_det no-lock  where ld_det.ld_domain = global_domain and
        ld_site = tosite and
        ld_loc = toloc and
        ld_part = part and
        ld_lot = lot and
        ld_ref = ref and
        ld_qty_oh <> 0
        no-error.
         /* IF INVENTORY ALREADY EXISTS THEN VALIDATE THAT THE GRADE */
         /* ASSAY AND EXPIRATION DATE ARE THE SAME.                  */

         if available ld_det then do:
          if (ld_assay <> from_assay) or
          (ld_grade <> from_grade) or
          (ld_expire <> from_expire)
          then do:
            {mfmsg.i 1918 3} /*GRADE ASSAY EXPIRE DIFFERENT */
            return.
          end.

           /*IF THE USER HAS SELECTED TO USE THE FROM INVENTORY STATUS    */
           /* INSTEAD OF THE TO INVENTORY STATUS (DEFAULT), THIS BECOMES  */
           /* AN ERROR WHEN INVENTORY FOR THAT ITEM ALREADY EXISTS IN THE */
           /* TO LOCATION WITH A DIFFERENT INVENTORY STATUS               */
          if not use-to-loc-status and ld_status <> from_status
          then do:
             {mfmsg.i 1391 3} /*UNABLE TO USE FROM INVENTORY STATUS */
             return.
          end.
         end. /* available ld_det TO LOCATION */
         end. /* available ld_det FROM LOCATION */

         else
     if not use-to-loc-status then do:
         /* GET THE FROM LOCATION */
         find loc_mstr  where loc_mstr.loc_domain = global_domain and
         loc_site = fromsite and loc_loc = fromloc no-lock no-error.
         if available loc_mstr then from_status = loc_status.
         else do:
           find si_mstr  where si_mstr.si_domain = global_domain
              and  si_site = fromsite no-lock.
           from_status = si_status.
         end.
         /* GET THE TO LOCATION STATUS */
         find ld_det no-lock  where ld_det.ld_domain = global_domain and
        ld_site = tosite and
        ld_loc = toloc and
        ld_part = part and
        ld_lot = lot and
        ld_ref = ref and
        ld_qty_oh <> 0
        no-error.
         if available ld_det and ld_status <> from_status then do:
           {mfmsg.i 1391 3} /*UNABLE TO USE FROM INVENTORY STATUS */
           return.
         end.
         end. /* not available ld_det FROM LOCATION and not use-to-loc-status*/

 undo-update = no.