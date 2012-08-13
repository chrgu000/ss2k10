/* ptw.t   ITEM MASTER WRITE TRIGGER                                  */
/*Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                 */
/*All rights reserved worldwide.  This is an unpublished work.        */
/*V8:ConvertMode=NoConvert*/
/*********************************************************************/
/*  Program :ptw.t                                                   */
/*  Author  :Ben Holmes                                              */
/*  Date    :03/19/95                                                */
/*  !Description : pt_mstr WRITE trigger program                     */
/*          : In order to enhance this trigger to support additional */
/*          : interfaces, add a DO-END block similar to the one      */
/*          : used for the Warehousing Interface to (1) check for the*/
/*          : need to continue processing; (2) move the relevant     */
/*          : fields to an appropriate work area; and (3) call       */
/*          : one or more subprograms to continue processing.        */
/*          : This .t program should remain short, relying on        */
/*          : subprograms to perform most of the work.               */
/*********************************************************************/
/*                             MODIFY LOG                            */
/*********************************************************************/
/*Revision 8.5          Last Modified:  03/19/95 BY: BHolmes *J0FY*  */
/*Revision 8.5          Last Modified:  07/22/96 BY: GWM     *J10D*  */
/*Revision 8.5          Last Modified:  07/27/96 BY: fwy     *J12B*  */
/*Revision 8.6          Last Modified:  11/20/96 BY: cjv     *K01B*  */
/*Revision 8.6          Last Modified:  01/07/97 BY: jpm     *J1DM*  */
/*Revision 9.0          Last Modified:  11/15/98 BY: *M00M* Robert Jensen */
/*Revision 9.0          Last Modified:  03/13/99 BY: *M0BD* Alfred Tan    */
/*Revision 9.1          Last Modified:  08/13/00 BY: *N0KQ* myb           */
/*                                                                   */
/*********************************************************************/

TRIGGER PROCEDURE FOR WRITE OF PT_MSTR OLD BUFFER OLD_PT_MSTR.

/*J12B  if not can-find(first whl_mstr where whl_mstr.whl_act no-lock) */
/*J12B  then leave. */

        {mfdeclre.i }
        define new shared work-table wf_old_pt_mstr like pt_mstr.
        define new shared variable w-recid as recid.
/*J12B*/define new shared variable w-site-loc-id like whl_mstr.whl_src_dest_id.
        define variable w-file as character format "x(24)".

/*cj*add audit part*/
        DEF VAR keyval AS CHAR .

        Aud:
        DO:

            keyval = pt_mstr.pt_part .
            
            IF old_pt_mstr.pt_status <> pt_mstr.pt_status THEN DO :
                {gprun.i ""yyaud.p"" "(input 'pt_mstr' ,
                    INPUT 'pt_status' ,
                    INPUT keyval ,
                    INPUT old_pt_mstr.pt_status ,
                    INPUT pt_mstr.pt_status)"
                 }
            END.
            
            IF old_pt_mstr.pt_prod_line <> pt_mstr.pt_prod_line THEN DO :
                {gprun.i ""yyaud.p"" "(input 'pt_mstr' ,
                    INPUT 'pt_prod_line' ,
                    INPUT keyval ,
                    INPUT old_pt_mstr.pt_prod_line ,
                    INPUT pt_mstr.pt_prod_line)"
                 }
            END.

        END.


        /* Warehousing Interface processing */

        WI:
        do:

        /* If there is no active external warehouse, then do not process */
/*K01B     If the item extract flag is not set, then do not process */
/*J12B*/    if not can-find(first whl_mstr no-lock
/*K01B  /*J12B*/          where whl_mstr.whl_act) */
/*K01B*/        where whl_mstr.whl_act
/*K01B*/        and whl_mstr.whl_pt_exp)
/*J12B*/    then leave WI.

        /* If no pertinent fields have been changed, then do not process */
/*J12B*/    if (old_pt_mstr.pt_part           = pt_mstr.pt_part
/*J12B*/      and old_pt_mstr.pt_desc1        = pt_mstr.pt_desc1
/*J12B*/      and old_pt_mstr.pt_desc2        = pt_mstr.pt_desc2
/*J12B*/      and old_pt_mstr.pt_fr_class     = pt_mstr.pt_fr_class
/*J12B*/      and old_pt_mstr.pt_height       = pt_mstr.pt_height
/*J12B*/      and old_pt_mstr.pt_insp_rqd     = pt_mstr.pt_insp_rqd
/*J12B*/      and old_pt_mstr.pt_length       = pt_mstr.pt_length
/*J12B*/      and old_pt_mstr.pt_lot_ser      = pt_mstr.pt_lot_ser
/*J12B*/      and old_pt_mstr.pt_net_wt       = pt_mstr.pt_net_wt
/*J12B*/      and old_pt_mstr.pt_net_wt_um    = pt_mstr.pt_net_wt_um
/*J12B*/      and old_pt_mstr.pt_rctpo_status = pt_mstr.pt_rctpo_status
/*J12B*/      and old_pt_mstr.pt_rev          = pt_mstr.pt_rev
/*J12B*/      and old_pt_mstr.pt_rop          = pt_mstr.pt_rop
/*J12B*/      and old_pt_mstr.pt_sfty_stk     = pt_mstr.pt_sfty_stk
/*J12B*/      and old_pt_mstr.pt_shelflife    = pt_mstr.pt_shelflife
/*J12B*/      and old_pt_mstr.pt_ship_wt      = pt_mstr.pt_ship_wt
/*J12B*/      and old_pt_mstr.pt_ship_wt_um   = pt_mstr.pt_ship_wt_um
/*J12B*/      and old_pt_mstr.pt_size         = pt_mstr.pt_size
/*J12B*/      and old_pt_mstr.pt_status       = pt_mstr.pt_status
/*J12B*/      and old_pt_mstr.pt_cyc_int      = pt_mstr.pt_cyc_int
/*J12B*/      and old_pt_mstr.pt_loc_type     = pt_mstr.pt_loc_type
/*J12B*/      and old_pt_mstr.pt_article      = pt_mstr.pt_article
/*J12B*/      and old_pt_mstr.pt_um           = pt_mstr.pt_um
/*J12B*/      and old_pt_mstr.pt_user1        = pt_mstr.pt_user1
/*J12B*/      and old_pt_mstr.pt_user2        = pt_mstr.pt_user2
/*J12B*/      and old_pt_mstr.pt_width        = pt_mstr.pt_width
/*J12B*/      and old_pt_mstr.pt_vend         = pt_mstr.pt_vend)
/*J12B*/    then leave WI.

        /* Move old pt_mstr values to work table for subsequent processing */
            assign w-recid = recid(pt_mstr).
            create wf_old_pt_mstr.
            if recid(wf_old_pt_mstr)= -1 then .
            assign
                wf_old_pt_mstr.pt_part         = old_pt_mstr.pt_part
                wf_old_pt_mstr.pt_desc1        = old_pt_mstr.pt_desc1
                wf_old_pt_mstr.pt_desc2        = old_pt_mstr.pt_desc2
                wf_old_pt_mstr.pt_fr_class     = old_pt_mstr.pt_fr_class
                wf_old_pt_mstr.pt_height       = old_pt_mstr.pt_height
                wf_old_pt_mstr.pt_insp_rqd     = old_pt_mstr.pt_insp_rqd
                wf_old_pt_mstr.pt_length       = old_pt_mstr.pt_length
                wf_old_pt_mstr.pt_lot_ser      = old_pt_mstr.pt_lot_ser
                wf_old_pt_mstr.pt_net_wt       = old_pt_mstr.pt_net_wt
                wf_old_pt_mstr.pt_net_wt_um    = old_pt_mstr.pt_net_wt_um
                wf_old_pt_mstr.pt_rctpo_status = old_pt_mstr.pt_rctpo_status
                wf_old_pt_mstr.pt_rev          = old_pt_mstr.pt_rev
                wf_old_pt_mstr.pt_rop          = old_pt_mstr.pt_rop
                wf_old_pt_mstr.pt_sfty_stk     = old_pt_mstr.pt_sfty_stk
                wf_old_pt_mstr.pt_shelflife    = old_pt_mstr.pt_shelflife
                wf_old_pt_mstr.pt_ship_wt      = old_pt_mstr.pt_ship_wt
                wf_old_pt_mstr.pt_ship_wt_um   = old_pt_mstr.pt_ship_wt_um
                wf_old_pt_mstr.pt_size         = old_pt_mstr.pt_size
                wf_old_pt_mstr.pt_status       = old_pt_mstr.pt_status
                wf_old_pt_mstr.pt_cyc_int      = old_pt_mstr.pt_cyc_int
                wf_old_pt_mstr.pt_loc_type     = old_pt_mstr.pt_loc_type
                wf_old_pt_mstr.pt_article      = old_pt_mstr.pt_article
                wf_old_pt_mstr.pt_um           = old_pt_mstr.pt_um
                wf_old_pt_mstr.pt_user1        = old_pt_mstr.pt_user1
                wf_old_pt_mstr.pt_user2        = old_pt_mstr.pt_user2
                wf_old_pt_mstr.pt_width        = old_pt_mstr.pt_width
/*J10D*/        wf_old_pt_mstr.pt_vend         = old_pt_mstr.pt_vend
            .

        /* Call subprogram to create export transactions for warehouses */
            w-file = "wiptw.p".
/*J1DM*/ /* {gprun.i ""wiptw.p""} */
/*J1DM*/    {gprunmo.i &module="WI"
                       &program="wiptw.p"}

/*J12B*/end. /* WI */
/*M00M*//* Logistics Interface processing */
/*M00M*/LG:
/*M00M*/do:
/*M00M*//* If there is no logistics application ID, then do not process */
/*M00M*/         if not can-find(first lgs_mstr no-lock
/*M00M*/           where lgs_app_id <> "")
/*M00M*/           then leave LG.
/*M00M*//* If pt_status has changed, then do process */
/*M00M*/   if (old_pt_mstr.pt_status <> pt_mstr.pt_status) then do:
/*M00M*//* Move old pt_mstr values to work table for subsequent processing */
/*M00M*/      if not can-find ( first wf_old_pt_mstr ) then do:
/*M00M*/         create wf_old_pt_mstr.
/*M00M*/         if recid(wf_old_pt_mstr)= -1 then .
/*M00M*/      end.
/*M00M*/      buffer-copy old_pt_mstr to wf_old_pt_mstr no-error.
/*M00M*//* Call subprogram to publish changed status for Logistics */
/*M00M*/      {gprunmo.i &module="LG"
/*M00M*/      &program="lgckist.p"
/*M00M*/      &param="""(input recid(pt_mstr))"""}
/*M00M*/   end.
/*M00M*/end. /* LG */
/*M00M* *End of Added Section */
