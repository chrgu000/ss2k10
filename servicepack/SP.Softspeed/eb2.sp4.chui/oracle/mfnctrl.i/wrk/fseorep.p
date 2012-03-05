/* fseorep.p  - MATERIAL ORDER DIRECT/PENDING RETURNS subroutine              */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/*V8:ConvertMode=Maintenance                                                  */
/*V8:RunMode=Character,Windows                                                */
/* REVISION: 7.5      CREATED : 04/06/94    BY: cdt *J04C*                    */
/* REVISION: 8.5      LAST MODIFIED: 08/17/95   BY: *J04C*  Sue Poland        */
/* REVISION: 8.5      LAST MODIFIED: 02/06/96   BY: *J04C* Markus Barone      */
/* REVISION: 8.5      LAST MODIFIED: 05/09/96   BY: *J0LJ* Sue Poland         */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane          */
/* REVISION: 8.6E     LAST MODIFIED: 06/25/98   BY: *L034* Markus Barone      */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan         */
/* REVISION: 8.6E     LAST MODIFIED: 03/25/99   BY: *J3CV* Madhavi Pradhan    */
/* REVISION: 9.1      LAST MODIFIED: 10/27/99   BY: *N03P* Mayse Lai          */
/* REVISION: 9.1      LAST MODIFIED: 03/06/00   BY: *N05Q* David Morris       */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00 BY: *N08T* Annasaheb Rahane */
/* REVISION: 9.1      LAST MODIFIED: 08/14/00 BY: *N0L0* Jacolyn Neder        */

/******************************************************************************/
/* Due to the introduction of the module Project Realization Management (PRM) */
/* the term Material Order (MO) replaces all previous references to Service   */
/* Engineer Order (SEO) in the user interface. Material Order is a type of    */
/* Sales Order used by an engineer to obtain inventory needed for service     */
/* work. In PRM, a material order is used to obtain inventory for project     */
/* work.                                                                      */
/******************************************************************************/

/*!----------------------------------------------------------------------
  This program is called from fseore.p (MO Direct/Pending Returns)
  It will perform the following functions:
     MO Return Header data entry (except MO nbr)
     Call to Line Item Entry (fseorea.p)
     Inventory Movements (fseoivtr.p)
     MO detail updates (fseoqty.p)
 ----------------------------------------------------------------------*/

     {mfdeclre.i}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE fseorep_p_1 "Return All"
/* MaxLen: Comment: */

/*J3CV** &SCOPED-DEFINE fseorep_p_2 "SEO" */
/*J3CV** /* MaxLen: Comment: */           */

&SCOPED-DEFINE fseorep_p_3 "Site"
/* MaxLen: Comment: */

&SCOPED-DEFINE fseorep_p_4 "Status"
/* MaxLen: Comment: */

&SCOPED-DEFINE fseorep_p_5 "Comments"
/* MaxLen: Comment: */

&SCOPED-DEFINE fseorep_p_6 "Effective"
/* MaxLen: Comment: */

&SCOPED-DEFINE fseorep_p_7 "Loc"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */


     /*------------------------------------Define-shared-frames-----*/
     define     shared frame a.
     /*------------------------------------Define-shared-variables--*/
     define     shared variable so_recno        as recid.
     define new shared variable ship_db         like dc_name.
     define new shared variable so_db           like dc_name.
     define new shared variable ship_so         like so_nbr.
     define new shared variable return_all      like mfc_logical
                    label {&fseorep_p_1} initial no.
     define new shared variable return_status   like fpst_status
                    label {&fseorep_p_4}.
     define new shared variable undo-all        like mfc_logical no-undo.
     define     shared variable undo_ps         like mfc_logical no-undo.
     define new shared variable from_site       like sod_site
                    label {&fseorep_p_3}.
     define new shared variable from_loc        like sod_loc
                    label {&fseorep_p_7}.
     define new shared variable eff_date        like glt_effdate
                    label {&fseorep_p_6}.
     define new shared variable trlot           like tr_lot.
     /*------------------------------------Define-local-variables---*/
     define            variable sofsmtype       as character
/*J3CV**                                        initial {&fseorep_p_2}. */
/*J3CV*/                                        initial "SEO":U.
     define            variable part            like pt_part.
     define            variable lotserial       like tr_serial.
     define            variable lotref          like tr_ref.
     define            variable um              like tr_um.
     define            variable err-flag        as integer.
     define            variable line            like sod_line.
     define            variable desc1           like pt_desc1.
     define            variable fseomode        as character initial "RETURN".
     define            variable upd_comp        like mfc_logical
                            initial no.
     define            variable sodcmmts        like soc_lcmmts
                            label {&fseorep_p_5}.
/*J04C*/ define            variable yn              like mfc_logical.
/*J04C*/ define            variable trans-ok        like mfc_logical no-undo.
/*J0LJ*/ define            variable return-qty      like sr_qty.
     /* FORM */
     {fseofrm7.i}
/*J04C*/ /*V8:DontRefreshTitle=c */

     find first svc_ctrl  no-lock.

     assign
        so_db         = global_db
        eff_date      = today
/*N05Q* return_status = svc_return_sts */
/*N05Q*/ return_status = if available svc_ctrl
                         then svc_return_sts
                         else "".

     do transaction:

/*N05Q*/ /* CHECK IF PRM MODULE IS INSTALLED */
/*N05Q*/ {pjchkprm.i}

/*N05Q*/ for first pjc_ctrl fields(pjc_par_return) no-lock:
/*N05Q*/ end.

/*N05Q*/ if prm-enabled
/*N05Q*/ and not available svc_ctrl
/*N05Q*/ and available pjc_ctrl then do:
/*N05Q*/    /* DEFAULT THE RETURN STATUS FROM PRM SINCE SSM ISN'T AVAILABLE */
/*N05Q*/    return_status = pjc_par_return.
/*N05Q*/ end.

        find so_mstr where recid(so_mstr) = so_recno.
        display so_nbr
            so_eng_code
            so_ca_nbr
            return_all
            return_status
        with frame a.

        /*FIND DEFAULT ENGINEER LOCATION*/
        assign
           from_loc    = ""
           from_site   = "".

        find eng_mstr where eng_code = so_eng_code no-lock no-error.
        if not available eng_mstr then do: /* Just in case ! */
          {mfmsg.i 7404 3} /* engineer must exist */
          undo, retry.
        end.
        else do:
           find loc_mstr where loc_loc  = eng_loc
                   and loc_site = eng_site     no-lock no-error.
           if available loc_mstr and eng_loc <> " "
           then assign from_loc  = eng_loc
               from_site = eng_site.
           else do:
          find reg_mstr where reg_code = eng_area no-lock no-error.
          if available reg_mstr
          then assign from_loc  = reg_loc
                  from_site = reg_site.
           end.
        end.

/*N05Q*/ /* ***** BEGIN NEW CODE ***** */
         if prm-enabled
         and can-find(first ca_mstr where ca_category = "PRM"
            and ca_nbr = so_ca_nbr)
         then do:
            if available pjc_ctrl then do:
               /* DEFAULT THE RETURN STATUS FROM PRM SINCE */
               /* THE MO HAS AN ATTACHED PAO               */
               return_status = pjc_par_return.
               display
                  return_status
               with frame a.
            end.

            for first prj_mstr
               fields(prj_loc prj_nbr prj_site) no-lock
               where prj_nbr = so_project:

               assign
                  from_site = prj_site
                  from_loc  = prj_loc.
            end. /* FOR FIRST PRJ_MSTR */
         end. /* IF PRM-ENABLED */
/*N05Q*/ /* ***** END NEW CODE ***** */

        display
           from_loc
           from_site
        with frame a.

        seta: do on error undo, retry:
           set return_all
           return_status
           from_site
           from_loc
/*J04C*        with frame a.    */
/*J04C*/       with frame a editing:
/*J04C*             ADDED THE FOLLOWING FOR NEXT/PREV PROCESSING */
                    if frame-field = "return_status" then do:
               {mfnp01.i fpst_mstr
                     sr_status fpst_status
                     "yes"      fpst_return
                     fpst_status}
               if recno <> ?
               then display fpst_status @ return_status with frame a.
                end.
                else do:
                       /* gplu169.p NEEDS GLOBAL_SITE */
/*J0LJ*/                   global_site = input from_site.
               readkey.
               apply lastkey.
                end.
               end.    /* editing */
/*J04C*        END ADDED CODE */

           /* VALIDATE THE RETURN STATUS */
           if return_status <> "" then do:
          find first fpst_mstr where fpst_status = return_status
           no-lock no-error.
          if not available fpst_mstr then do:
             {mfmsg.i 7323 3}
             /* Item status does not exist */
             next-prompt return_status with frame a.
             undo, retry seta.
          end.
          else do:
             if not fpst_return then do:
            {mfmsg.i 7322 3}
            /* RETURN STATUS DOES NOT ALLOW RETURNS */
            next-prompt return_status with frame a.
            undo, retry seta.
             end.
/*J04C*/             if fpst_exchange then do:
/*J04C*/                {mfmsg.i 805 3}
                        /* RETURN STATUS CANNOT INCLUDE EXCHANGE */
/*J04C*/                next-prompt return_status with frame a.
/*J04C*/                undo, retry seta.
/*J04C*/             end.
          end.
           end.

           /* DETERMINE THE SHIP-FROM DATABASE */
           if from_site = "" then do:
          /* If this is the only database, use it */
          if not can-find(first dc_mstr)
          or not can-find(first sod_det where sod_nbr = so_nbr)
          then do:
             ship_db = global_db.
          end.
          else do:
             /* Take the database from the first line */
             find first sod_det where sod_nbr = so_nbr no-lock.
             find si_mstr where si_site = sod_site no-lock.
             ship_db = si_db.
             /* Check to see if SO affects other databases */
             /* (If so, the user must pick one)            */
             for each sod_det where sod_nbr  =  so_nbr
                    and sod_site <> si_site
                    and sod_confirm
                      no-lock:
            find si_mstr where si_site = sod_site no-lock.
            if si_db <> ship_db then do:
/*N03P*        {mfmsg.i 7313 4} */
/*N03P*/       {mfmsg.i 3365 4}
               /* MO spans databases, site must be specified */
               display si_site @ from_site with frame a.
               undo seta, retry seta.
            end.
             end.
          end.
           end.
           else do:
          find si_mstr where si_site = from_site no-lock no-error.
          if not available si_mstr then do:
             {mfmsg.i 708 3}  /* Site does not exist */
             next-prompt from_site with frame a.
             undo, retry.
          end.
          ship_db = si_db.
           end.

           /* Make sure ship-from database is connected */
           if global_db <> "" and not connected(ship_db) then do:
          {mfmsg03.i 2510 3 ship_db """" """"}
          /* Database not available */
          undo, retry.
           end.

           /*VALIDATE FROM SITE/LOCATION*/
           assign
         part      = " "
         lotserial = " "
         lotref    = " "
         um        = " ".

/*J04C*/       next-prompt from_site with frame a.

/*J04C*/       /* ADDED BLANKS FOR TRNBR & TRLINE BELOW */
           {icedit.i
        &transtype=""ISS-TR""
        &site=from_site
        &location=from_loc
        &part=part
        &lotserial=lotserial
        &lotref=lotref
        &quantity=0
        &um=um
            &trnbr  = """"
            &trline = """"
           }

        end. /* seta */
     end.  /* MO number input transaction */

/*J0LJ*  hide frame a.  */

     /* Get trlot for inventory receipts */
     do transaction:
/*J04C*/    /* get next lot number */
/*J04C*/    {mfnxtsq.i wo_mstr wo_lot woc_sq01 trlot}
/*J04C*     {mfnctrl.i woc_ctrl woc_lot wo_mstr wo_lot trlot}  */
     end.

/*J04C*/ loop0:
     do transaction:
        ship_so  = so_nbr.
        undo_ps  = yes.

        /* Set up line item returns */
        {gprun.i ""fseorea.p""}

/*J04C*     ADDED THE FOLLOWING */
            /* ENSURE STATUS AND TO SITE/LOCATION SET ON ALL SR_WKFL'S */
            for each sod_det where sod_nbr = so_nbr
                no-lock:
                {gprun.i ""fseoline.p""
                    "(input string(sod_line))"}
            end.
/*J04C*     END ADDED CODE */

/*J04C*/    /* Fill sr_wkfl for selected kits */
/*J04C*/    {gprun.i ""fseoktsr.p""
             "(INPUT ship_so)"}

/*N05Q*/    /* ***** BEGIN NEW CODE ***** */
            if prm-enabled
            and can-find(first ca_mstr where ca_category = "PRM"
               and ca_nbr = so_ca_nbr)
            then do:
               /* UPDATE PROJECT LINE DETAILS */
               {gprunmo.i
                  &program = ""pjchkup1.p""
                  &module = "PRM"
                  &param = """(input ship_so,
                               input return_status)"""}
            end.
/*N05Q*/    /* ***** END NEW CODE ***** */

/*J04C*     ADDED THE FOLLOWING */
        /* DISPLAY SHIPMENT INFORMATION FOR USER REVIEW */
/*GC96*/    do on endkey undo loop0,leave loop0:
           yn = yes.

/*J04C*/       /*V8-*/
/*N03P*    {mfmsg01.i 781 1 yn} */
/*N03P*/   {mfmsg01.i 3353 1 yn}
           /* DISPLAY MATERIAL ORDER LINES BEING SHIPPED */
/*J04C*/       /*V8+*/
/*J04C*/       /*V8!
/*N03P* /*J04C*/  {mfgmsg10.i 781 1 yn} */
/*N03P*/          {mfgmsg10.i 3353 1 yn}
/*J04C*/       /* DISPLAY MATERIAL ORDER LINES BEING SHIPPED */
/*J04C*/       if yn = ? then
/*J04C*/          undo loop0, leave loop0.
/*J04C*/        */

           if yn = yes then do:

          /* Switch to the shipping db to display the shipment file */
          if ship_db <> global_db then do:
             {gprun.i ""gpalias3.p"" "(ship_db, output err-flag)" }
          end.

          {gprun.i ""sosoiss1.p""}

          {gprun.i ""gpalias3.p"" "(so_db, output err-flag)" }

           end.
        end. /* DO ON ENDKEY */

            do on endkey undo loop0, leave loop0:
           yn = yes.

/*J04C*/       /*V8-*/
           {mfmsg01.i 12 1 yn} /* Is all info correct? */
/*J04C*/       /*V8+*/
/*J04C*/       /*V8!
/*J04C*/       {mfgmsg10.i 12 1 yn} /* Is all info correct? */
/*J04C*/       if yn = ? then
/*J04C*/          undo loop0, leave loop0.
/*J04C*/        */

           if not yn then do:
                    undo loop0, retry loop0.
               end.
        end.

/*J04C*     END ADDED CODE */

        /* Process returns and update sod quantities */
        for each sr_wkfl where sr_userid = mfguser
                   and sr_qty    > 0:

               /* DON'T PROCESS THE 'TOTAL' RECORD */
/*J04C*/       if sr_rev = "SEO-DEL" then next.

           /* Process returns */
/*L034*/   /* REMOVED EXCHANGE RATE PARAM */
           {gprun.i ""fseoivtr.p""
            "(INPUT ship_so,
              INPUT integer(sr_lineid),
              INPUT trlot,
              INPUT eff_date,
              INPUT fseomode)"
        }

           /* Update sod qunatities */
           {gprun.i ""fseoqty.p""
            "(INPUT  ship_so,
              INPUT  integer(sr_lineid),
              INPUT  sr_qty,
              INPUT  sr_status,
              INPUT  no)"}

           upd_comp = yes.
        end. /* for each sr_wkfl */

        /* Delete sr_wkfl in the shipping database */

        {gprun.i ""gpalias3.p"" "(ship_db, output err-flag)" }
        {gprun.i ""sosoiss3.p""}
        /* Make sure the alias is pointed back to the central db */
        {gprun.i ""gpalias3.p"" "(so_db, output err-flag)" }

        if upd_comp then do:
           {mfmsg.i 1300 1} /* Update complete */
           pause.
        end.

        undo_ps  = no.

     end. /*transaction*/
