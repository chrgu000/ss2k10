/* gpxpld.p - EXPLODE BILL OF MATERIAL                                        */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/*F0PN*/ /*V8:ConvertMode=Maintenance                                         */
/* REVISION: 7.0      LAST MODIFIED: 12/02/92   BY: pma *G382*                */
/* REVISION: 7.3      LAST MODIFIED: 02/08/93   BY: emb *G656*                */
/* REVISION: 7.3      LAST MODIFIED: 06/22/93   BY: qzl *GC35*                */
/* REVISION: 7.3      LAST MODIFIED: 10/10/94   BY: pxd *FR91*                */
/* REVISION: 7.3      LAST MODIFIED: 11/30/94   BY: emb *FU13*                */
/* REVISION: 7.3      LAST MODIFIED: 11/16/95   BY: rvw *G1DF*                */
/* REVISION: 7.3      LAST MODIFIED: 01/16/96   BY: jym *G1JF*                */
/* REVISION: 7.3      LAST MODIFIED: 12/17/96   BY: *G2J7* Murli Shastri      */
/* REVISION: 8.5      LAST MODIFIED: 10/09/98   BY: *J31Z* Felcy D'Souza      */
/* REVISION: 8.6E     LAST MODIFIED: 03/29/00   BY: *L0VK* Vandna Rohira      */
/* REVISION: 9.1      LAST MODIFIED: 04/25/00   BY: *N0CD* Santosh Rao        */
/* REVISION: 9.1      LAST MODIFIED: 08/13/00   BY: *N0KS* myb                */
/* REVISION: 9.1      LAST MODIFIED: 08/17/00   BY: *N0LT* Vandna Rohira      */
/* REVISION: 9.1      LAST MODIFIED: 01/17/00   BY: *M0Y8* Mark Christian     */

/*G382*******************************************************************/
/*G382                                                                  */
/*G382                      MODIFIED FROM GPOPEX.P                      */
/*G382                                                                  */
/*G382*******************************************************************/

/*FR91 ************************************************************************
**      gpxpld.p has ben modified with this change to multiply pk_qty
**      by tmprnd which has the following value:
**
**      define variable tmprnd as decimal initial 10000000000000000.
**
**      Programs that call gpxpld.p have to divide the pk_qty field by the
**      same value. This was done to fix the precision issue that was raised
**      by SR102072 on scrap percentage calculations.
**
**FR91 **********************************************************************/

/*FU13*/ /* Backs out FR91 */

     {mfdeclre.i}

     {gpxpld02.i}

     define variable qty as decimal initial 1 no-undo.
     define variable tempqty as decimal no-undo.
     define variable batchqty like bom_batch initial 1 no-undo.
     define variable level as integer initial 1 no-undo.
     define variable conv like um_conv initial 1 no-undo.
     define variable par_type like ps_qty_type initial "" no-undo.
     define variable phantom like mfc_logical no-undo.
     define variable maxlevel as integer initial 99 no-undo.
     define variable numrec as integer initial 0 no-undo.
     define variable i as integer no-undo.
     define variable iss_pol like mfc_logical no-undo.
     define variable effstart as date no-undo.
     define variable effend as date no-undo.
/*FU13* /*FR91*/ define variable tmprnd as decimal initial 10000000000000000.*/

     define variable record as integer extent 100 no-undo.
     define variable save_qty as decimal extent 100 no-undo.
     define variable save_batchqty as decimal extent 100 no-undo.
     define variable save_conv as decimal extent 100 no-undo.
     define variable save_par_type as character extent 100 no-undo.
     define variable save_start as date extent 100 no-undo.
     define variable save_end as date extent 100 no-undo.
/**************tfq added begin***************************************/
define shared temp-table xxpk_det 
        field xxpk_user like pk_user
        field xxpk_part like pk_part
        field xxpk_ref like pk_reference
        field xxpk_op like ps_op  .
               
/*************tfq added end******************************************/
/*G656*/ define variable assy_op like ps_op no-undo.

     if pkdel then do:
        {mfdel.i pk_det "where pk_domain = global_domain and pk_user = mfguser"}
      end.
        
     hide message no-pause.
/*************tfq added begin********************/
for each xxpk_det where xxpk_user = mfguser:
delete xxpk_det .
end.
/*************tfq added end***************/
/*N0CD**   find first ps_mstr use-index ps_parcomp where 
											ps_domain = global_domain and ps_par = xpldcomp */
/*N0CD**   no-lock no-error.                                               */

/*N0CD*/ for first ps_mstr
/*N0CD*/    fields(ps_domain ps_comp ps_end ps_group ps_lt_off ps_op ps_par ps_process
/*N0CD*/           ps_ps_code ps_qty_per ps_qty_per_b ps_qty_type ps_scrp_pct
/*N0LT** /*N0CD*/  ps_start) */
/*N0LT*/           ps_ref ps_start)
/*N0CD*/    where ps_domain = global_domain and ps_par = xpldcomp
/*N0CD*/    use-index ps_parcomp no-lock:
/*N0CD*/ end. /* FOR FIRST PS_MSTR */

     if available ps_mstr then do:
/*N0CD** find bom_mstr no-lock where bom_domain = global_domain and 
						  bom_parent = xpldcomp no-error.  */
/*N0CD*/ for first bom_mstr
/*N0CD*/    fields(bom_domain bom_batch bom_batch_um bom_parent)
/*N0CD*/    where bom_domain = global_domain and bom_parent = xpldcomp no-lock:
/*N0CD*/ end. /* FOR FIRST BOM_MSTR */

        if available bom_mstr and bom_batch <> 0 and bom_batch <> 1
        then do:
/*N0CD*/   assign
              batchqty = bom_batch
              par_type = "B".
        end.
     end.
     if batchqty <> 0 then bombatch = batchqty.
     else bombatch = 1.
     repeat:

        if not available ps_mstr then do:
           repeat:
          level = level - 1.
          if level < 1 then leave.
/*N0CD**  find ps_mstr where ps_domain = global_domain and recid(ps_mstr) = record[level]  */
/*N0CD**  no-lock no-error.                                  */
/*N0CD*/  for first ps_mstr
/*N0CD*/     fields(ps_domain ps_comp ps_end ps_group ps_lt_off ps_op ps_par ps_process
/*N0CD*/            ps_ps_code ps_qty_per ps_qty_per_b ps_qty_type ps_scrp_pct
/*N0CD*/            ps_start)
/*N0CD*/     where ps_domain = global_domain and recid(ps_mstr) = record[level] no-lock:
/*N0CD*/  end. /* FOR FIRST PS_MSTR */

/*N0CD*/  assign
             xpldcomp = ps_par
             qty      = save_qty[level]
             batchqty = save_batchqty[level]
             par_type = save_par_type[level]
             conv     = save_conv[level].

          if level = 1 then do:
/*N0CD*/     assign
                effstart = ?
                effend   = ?.
          end.
          else do:
/*N0CD*/     assign
                effstart = save_start[level - 1]
                effend   = save_end[level - 1].
          end.
          find next ps_mstr use-index ps_parcomp
          where ps_domain = global_domain and ps_par = xpldcomp no-lock no-error.
          if available ps_mstr then leave.
           end.
        end.

        if level < 1 then leave.

        if (level > 1
/*G656*     or ((ps_op = operation or operation = ?) */
/*G656*/    or ((can-do(op_list,string(ps_op))
/*G656*/         or ps_op = operation or operation = ?)
        and (ps_group = psgroup or psgroup = "")
        and (ps_process = psprocess or psprocess = "")))

        and (xplddate = ? or (xplddate <> ?
        and (ps_start = ? or ps_start <= xplddate)
        and (ps_end = ? or xplddate <= ps_end))) then do:

/*G656*/   if level = 1 then assy_op = ps_op.
/*N0CD*/   assign
              phantom = no
              iss_pol = yes.

/*N0CD**   find pt_mstr where pt_domain = global_domain and pt_part = ps_comp no-lock no-error.  */
/*N0CD*/   for first pt_mstr
/*N0CD*/      fields(pt_domain pt_bom_code pt_iss_pol pt_loc pt_part pt_phantom pt_um)
/*N0CD*/      where pt_domain = global_domain and pt_part = ps_comp no-lock:
/*N0CD*/   end. /* FOR FIRST PT_MSTR */

           if available pt_mstr then do:
/*N0CD**      find ptp_det no-lock where ptp_domain = global_domain and ptp_part = ps_comp  */
/*N0CD**      and ptp_site = xpldsite no-error.              */
/*N0CD*/      for first ptp_det
/*N0CD*/         fields(ptp_domain ptp_bom_code ptp_iss_pol ptp_part ptp_phantom
/*N0CD*/                ptp_site)
/*N0CD*/         where ptp_domain = global_domain and ptp_part = ps_comp and
/*N0CD*/               ptp_site = xpldsite no-lock:
/*N0CD*/      end. /* FOR FIRST PTP_DET */

          if available ptp_det then do:
/*N0CD*/     assign
                phantom = ptp_phantom
                iss_pol = ptp_iss_pol.
          end.
          else do:
/*N0CD*/     assign
                phantom = pt_phantom
                iss_pol = pt_iss_pol.
          end.
           end.

/*GC35*/   /* this patch number has no effect on this program */

           if ps_ps_code = "X"
           or (not available pt_mstr and ps_ps_code = "")
           or (incl_phtm = yes and phantom = yes and ps_ps_code = "" )
           then do:

/*N0CD*/      assign
                 record[level]        = recid(ps_mstr)
                 save_qty[level]      = qty
                 save_batchqty[level] = batchqty
                 save_par_type[level] = par_type
                 save_conv[level]     = conv
                 save_start[level]    = max(effstart,ps_start).

          if effstart = ? then save_start[level] = ps_start.
          if ps_start = ? then save_start[level] = effstart.
          save_end[level] = min(effend,ps_end).
          if effend = ? then save_end[level] = ps_end.
          if ps_end = ? then save_end[level] = effend.

          if level < maxlevel or maxlevel = 0 then do:
             xpldcomp = ps_comp.

             if available ptp_det and ptp_bom_code <> ""
            then xpldcomp = ptp_bom_code.
             else if available ptp_det and ptp_bom_code = ""
            then xpldcomp = ptp_part.
             else if not available ptp_det and available pt_mstr
            and pt_bom_code <> "" then xpldcomp = pt_bom_code.
             else if not available ptp_det and available pt_mstr
            and pt_bom_code = "" then xpldcomp = pt_part.

/*N0CD*/    assign
               conv     = 1
               batchqty = 1
               par_type = "".

/*G1JF*              if ps_qty_type <> "" then do: */
/*N0CD**    find bom_mstr no-lock where bom_domain = global_domain and bom_parent = xpldcomp  */
/*N0CD**    no-error.                                          */
/*N0CD*/    for first bom_mstr
/*N0CD*/       fields(bom_domain bom_batch bom_batch_um bom_parent)
/*N0CD*/       where bom_domain = global_domain and bom_parent = xpldcomp no-lock:
/*N0CD*/    end. /* FOR FIRST BOM_MSTR */

            if available bom_mstr and bom_batch <> 0
             and bom_batch <> 1  then do:
/*N0CD*/       assign
                  batchqty = bom_batch
                  par_type = ps_qty_type.

               if available pt_mstr and pt_um <> bom_batch_um
               then do:
                  {gprun.i ""gpumcnv.p""
                  "(bom_batch_um, pt_um, bom_parent, output conv)"}
                  if conv = ? then conv = 1.
               end.
            end.
/*G1JF*              end. */


/*G2J7*              ** BEGIN DELETE SECTION **
./*G1JF*                     if par_type <> "" and batchqty <> 0 */
./*G1JF*/             if (par_type <> "" and batchqty <> 0) or
./*G1JF*/                (available bom_mstr and bom_parent = xpldcomp
./*G1JF*/                 and batchqty <> 0)
**G2J7*              ** END DELETE SECTION **/

/*J31Z*/             /* WHEN ps_qty_type = "", COMPONENT REQUIREMENT SHOULD */
/*J31Z*/             /* BE FOR WHOLE BATCH OF THE PARENT RATHER THAN FOR    */
/*J31Z*/             /* SINGLE PARENT.                                      */

/*M0Y8*/             /* IF batchqty IS EQUAL TO EITHER 0 OR 1 THEN qty WILL */
/*M0Y8*/             /* BE CALCULATED EVEN THOUGH ps_qty_type = "B"         */

/*M0Y8** BEGIN DELETE
 *
 * /*J31Z*/          if (ps_qty_type          = ""  and
 * /*J31Z*/              save_batchqty[level] <> 1  and
 * /*J31Z*/              save_batchqty[level] <> 0) then
 * /*J31Z*/              assign qty = qty * save_batchqty[level].
 *
 *M0Y8** END DELETE */

/*M0Y8*/             if (ps_qty_type          =  ""  or
/*M0Y8*/                 batchqty             =  0   or
/*M0Y8*/                 batchqty             =  1)  and
/*M0Y8*/                 save_batchqty[level] <> 0   and
/*M0Y8*/                 save_batchqty[level] <> 1
/*M0Y8*/             then
/*M0Y8*/                qty = qty * save_batchqty[level].

/*J31Z** BEGIN DELETE **
 * /*G2J7*/          if (par_type <> "" and batchqty <> 0 and batchqty <> 1)
 * /*G2J7*/             or (available bom_mstr and bom_parent = xpldcomp
 * /*G2J7*/             and batchqty <> 0  and batchqty <> 1 )
 *J31Z** END DELETE **/

/*J31Z*/              if (batchqty <> 1 and
/*J31Z*/                  batchqty <> 0)
                          then qty = qty * (ps_qty_per_b / (batchqty * conv))
                                         * (100 / ( 100 - ps_scrp_pct)).
                      else qty = qty * ps_qty_per
                                     * (100 / ( 100 - ps_scrp_pct)).

/*G2J7*              ** BEGIN DELETE SECTION **
./*G1JF*/             if ps_qty_type = "" then
./*G1JF*/               assign qty = qty * save_batchqty[level]
./*G1JF*/                      par_type = "B".
**G2J7*              ** END DELETE SECTION **/

             effstart = max(save_start[level],ps_start).
             if save_start[level] = ? then effstart = ps_start.
             if ps_start = ? then effstart = save_start[level].
             effend = min(save_end[level],ps_end).
             if save_end[level] = ? then effend = ps_end.
             if ps_end = ? then effend = save_end[level].

             level = level + 1.
/*N0CD**     find first ps_mstr use-index ps_parcomp   */
/*N0CD**     where ps_domain = global_domain and ps_par = xpldcomp no-lock no-error. */
/*N0CD*/     for first ps_mstr
/*N0CD*/        fields(ps_domain ps_comp ps_end ps_group ps_lt_off ps_op ps_par
/*N0CD*/               ps_process ps_ps_code ps_qty_per ps_qty_per_b
/*N0LT** /*N0CD*/      ps_qty_type ps_scrp_pct ps_start) */
/*N0LT*/               ps_qty_type ps_ref ps_scrp_pct ps_start)

/*N0CD*/        where ps_domain = global_domain and ps_par = xpldcomp
/*N0CD*/        use-index ps_parcomp no-lock:
/*N0CD*/     end. /* FOR FIRST PS_MSTR */

          end.  /*if level < maxlevel*/
          else do:
             find next ps_mstr use-index ps_parcomp
             where ps_domain = global_domain and ps_par = xpldcomp no-lock no-error.
          end.
           end. /*if ps_ps_code = "X"*/

           else do:
          if ps_ps_code = ""
/*G1DF*              and ps_qty_per <> 0                               */
             and can-find (pt_mstr where pt_domain = global_domain and pt_part = ps_comp)
             and (iss_pol or incl_nopk)
          then do:
             find first pk_det exclusive-lock
                where pk_det.pk_domain = global_domain 
                and   pk_user      = mfguser
                and   pk_part      = ps_comp
/*G656*/        and   pk_reference = string(assy_op)
                and   pk_start     = max(if effstart <> ? then effstart
                                         else ps_start,
                                         if ps_start <> ? then ps_start
                                         else effstart)
                and   pk_end       = min(if effend <> ? then effend
                                         else ps_end,
                                         if ps_end <> ? then ps_end
                                         else effend)
                no-error.

             if available pk_det then do:
                find first pkwkfl where pkrecid = recid(pk_det)
                no-lock no-error.
                if ltoff <> ps_lt_off then repeat:
                   find next pk_det exclusive-lock
                      where pk_domain = global_domain 
                      and   pk_user      = mfguser
                      and   pk_part      = ps_comp
/*G656*/              and   pk_reference = string(assy_op)
                      and   pk_start     = max(if effstart <> ? then effstart
                                               else ps_start,
                                               if ps_start <> ? then ps_start
                                               else effstart)
                      and   pk_end       = min(if effend <> ? then effend
                                               else ps_end,
                                               if ps_end <> ? then ps_end
                                               else effend)
                      no-error.

                   if available pk_det then do:
                      find first pkwkfl where pkrecid = recid(pk_det)
                      no-lock no-error.
                      if ltoff = ps_lt_off then leave.
                   end.
                   else leave.
                end. /* IF LTOFF <> PS_LT_OFF */
             end. /* IF AVAILABLE PK_DET */

             if not available pk_det then do:
/*L0VK*/        /* BEGIN ADD SECTION */
                if can-find(first pk_det
                               where pk_domain = global_domain 
                               and   pk_user      = mfguser
                               and   pk_part      = ps_comp
                               and   pk_reference = string(assy_op)
                               and   pk_start     = max(if effstart <> ?
                                                        then effstart
                                                        else ps_start,
                                                        if ps_start <> ?
                                                        then ps_start
                                                        else effstart)
                               and   pk_end       = min(if effend <> ?
                                                        then effend
                                                        else ps_end,
                                                        if ps_end <> ?
                                                        then ps_end
                                                        else effend) ) then
                   find first pk_det exclusive-lock
                      where pk_domain = global_domain
                      and   pk_user      = mfguser
                      and   pk_part      = ps_comp
                      and   pk_reference = string(assy_op)
                      and   pk_start     = max(if effstart <> ? then effstart
                                               else ps_start,
                                               if ps_start <> ? then ps_start
                                               else effstart)
                      and   pk_end       = min(if effend <> ? then effend
                                               else ps_end,
                                               if ps_end <> ? then ps_end
                                               else effend)
                      no-error.
                else do:
/*L0VK*/        /* END ADD SECTION */

                   create pk_det.
                   assign pk_user      = mfguser
                          pk_part      = ps_comp
/*G656*/                  /* pk_reference = string(assy_op) */
/*tfq*/                   pk_reference = string(ps_op) 
                          pk_loc       = pt_loc
                          pk_start     = max(effstart,ps_start)
                          pk_end       = min(effend,ps_end).
                   if effstart = ? then pk_start = ps_start.
                   if ps_start = ? then pk_start = effstart.
                   if effend = ? then pk_end = ps_end.
                   if ps_end = ? then pk_end = effend.
                    /**************************tfq added begin************/
                            find first xxpk_det where xxpk_user = mfguser
                                and xxpk_part = ps_comp and xxpk_ref = string(assy_op) no-error .
                                if not available xxpk_det then
                                do:
                                create xxpk_det .
                                assign xxpk_user = mfguser
                                       xxpk_part      = ps_comp
                                       xxpk_ref = string(assy_op)
                                       xxpk_op = ps_op .
                                end.
                          /*tfq      if ps_comp = "10z66-01013" then do: 
                                message xxpk_op .
                                pause .
                                end.  */
                    /*************tfq added end*********************/
                   create pkwkfl.
                   assign pkrecid = recid(pk_det)
                          ltoff   = ps_lt_off
                          isspol  = iss_pol.
/*L0VK*/        end. /* ELSE DO */
             end. /* IF NOT AVAILABLE PK_DET THEN DO */

             tempqty = 0.

/*J31Z**     if ps_qty_type = "" or par_type = "" */

/*FR91      then tempqty = ps_qty_per * qty
**                * (batchqty / if conv <> 0 then conv else 1)
**                * (100 / (100 - ps_scrp_pct)).
**          else tempqty = ps_qty_per_b * qty
**                * (100 / (100 - ps_scrp_pct)).                   */

/*FU13*
/*FR91*/      then tempqty = ps_qty_per * qty * tmprnd
/*FR91*/                          * (batchqty / if conv <> 0 then conv else 1)
/*FR91*/                          * 100 / (100 - ps_scrp_pct).
/*FR91*/             else tempqty = ps_qty_per_b * qty * tmprnd
/*FR91*/                          * 100 / (100 - ps_scrp_pct).
**FU13*/

/*J31Z*/    if ps_qty_type = ""
/*FU13*/    /* Added section */
               then tempqty = ps_qty_per * qty
                              * (batchqty / if conv <> 0 then conv else 1)
                              * 100 / (100 - ps_scrp_pct).
            else tempqty = ps_qty_per_b * qty
                           * 100 / (100 - ps_scrp_pct).
/*FU13*/    /* End of added section */

/*J31Z** BEGIN DELETE SECTION
 *          if par_type = "" then
 *          temploop:
 *          do i = (level - 1) to 1 BY -1:
 *          tempqty = tempqty
 *              * (save_batchqty[i] / if save_conv[i] <> 0
 *                            then save_conv[i]
 *                            else 1).
 *          if save_par_type[i] <> "" then leave temploop.
 *           end.
 *J31Z** END DELETE SECTION **/

             pk_qty = pk_qty + tempqty.

          end.
          find next ps_mstr use-index ps_parcomp
          where ps_domain = global_domain and
          		  ps_par = xpldcomp no-lock no-error.
           end. /*else do (ps_ps_code <> "X")*/
        end. /*if level > 1*/

        else do:
           find next ps_mstr use-index ps_parcomp where ps_domain = global_domain 
           			 and ps_par = xpldcomp
           no-lock no-error.
        end.
     end. /*repeat*/
/********tfq added begin********************
for each pk_det where pk_domain = global_domain and pk_user = mfguser :
find first xxpk_det where xxpk_user = mfguser and xxpk_part = pk_part 
and xxpk_ref = pk_reference  and string(xxpk_op) <> pk_reference no-error .  /*judy*/
if available xxpk_det then do:
                            pk_reference = string(xxpk_op) .
                            end.
  /*TFQ  if pk_part = "10z66-01013" then do: 
                                message "pk_reference= " pk_reference .
                                pause .
                                end.    */
                        
end.
for each  xxpk_det where xxpk_user = mfguser :
delete xxpk_det .
end.

**********tfq added end***************/
