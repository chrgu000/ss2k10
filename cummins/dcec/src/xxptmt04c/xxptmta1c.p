/* ppptmta1.p - ITEM MAINTENANCE SUBROUTINE ENGINEERING DATA                  */
/* Copyright 1986-2009 QAD Inc., Santa Barbara, CA, USA.                      */
/* All rights reserved worldwide.  This is an unpublished work.               */
/*                                                                            */
/* LOGIC TO MAINTAIN ITEM ENGINEERING DATA.                                   */
/*                                                                            */
/* REVISION: 7.0      LAST MODIFIED: 06/22/92   BY: emb *F687*                */
/* REVISION: 7.0      LAST MODIFIED: 10/29/92   BY: pma *G249*                */
/* REVISION: 7.4      LAST MODIFIED: 08/05/93   BY: pma *H055*                */
/* REVISION: 7.4      LAST MODIFIED: 10/07/93   BY: pma *H165*                */
/* REVISION: 7.4      LAST MODIFIED: 02/16/94   BY: pxd *FL60*                */
/* REVISION: 7.2      LAST MODIFIED: 04/07/94   BY: pma *FN30*                */
/* REVISION: 7.4      LAST MODIFIED: 05/13/94   BY: qzl *H370* sr102019       */
/* REVISION: 7.2      LAST MODIFIED: 06/06/94   BY: ais *FO63*                */
/*           7.3                     09/03/94   BY: bcm *GL93*                */
/* REVISION: 8.5      LAST MODIFIED: 02/01/95   BY: tjm *J042*                */
/* REVISION: 8.5      LAST MODIFIED: 07/27/95   BY: kxn *J05Z*                */
/* REVISION: 8.5      LAST MODIFIED: 10/03/95   BY: tjs *J088*                */
/* REVISION: 7.4      LAST MODIFIED: 11/27/95   BY: bcm *F0WC*                */
/* REVISION: 7.4      LAST MODIFIED: 11/30/95   BY: bcm *H0HH*                */
/* REVISION: 8.5      LAST MODIFIED: 10/30/95   by: bholmes *J0FY*            */
/* REVISION: 8.5      LAST MODIFIED: 06/26/96   BY: RWitt   *F0XC*            */
/* REVISION: 8.6      LAST MODIFIED: 10/10/96   BY: svs *K007*                */
/* REVISION: 8.6      LAST MODIFIED: 10/18/96   BY: jpm *K017*                */
/* REVISION: 8.6      LAST MODIFIED: 12/09/96   BY: Joe Gawel *K00C*          */
/* REVISION: 8.6      LAST MODIFIED: 03/06/97   BY: Jack Rief *G2LB*          */
/* REVISION: 8.6      LAST MODIFIED: 06/24/97   BY: Murli Shastri  *G2NM*     */
/* REVISION: 8.6      LAST MODIFIED: 07/03/97   BY: Maryjeane Date *G2NS*     */
/* REVISION: 8.6      LAST MODIFIED: 08/02/97   BY: *J1PS*  Felcy D'Souza     */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahanei         */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan         */
/* REVISION: 8.6E     LAST MODIFIED: 05/28/98   BY: *K1QR* Dana Tunstall      */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan         */
/* REVISION: 9.0      LAST MODIFIED: 11/20/98   BY: *M002* Mayse Lai          */
/* REVISION: 9.0      LAST MODIFIED: 12/04/98   BY: *M01X* Luke Pokic         */
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan         */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.27     BY: G.Latha               DATE: 03/03/00   ECO: *N03T*  */
/* Revision: 1.29     BY: Annasaheb Rahane      DATE: 05/08/00   ECO: *N0B0*  */
/* Revision: 1.30     BY: G.Latha               DATE: 05/16/00   ECO: *N0B9*  */
/* Revision: 1.31     BY: zheng Huang           DATE: 07/16/00   ECO: *N0HD*  */
/* Revision: 1.32     BY: myb                   DATE: 08/13/00   ECO: *N0KQ*  */
/* Revision: 1.34     BY: Vandna Rohira         DATE: 07/02/02   ECO: *N1MT*  */
/* Revision: 1.36     BY: Paul Donnelly (SB)    DATE: 06/28/03   ECO: *Q00K*  */
/* Revision: 1.37     BY: Jyoti Thatte          DATE: 09/15/03   ECO: *P106*  */
/* Revision: 1.38     BY: Gaurav Kerkar         DATE: 05/09/05   ECO: *P3KS*  */
/* Revision: 1.38.2.1 BY: Archana Kirtane       DATE: 01/03/08   ECO: *Q1G5*  */
/* $Revision: 1.38.2.2 $       BY: Evan Todd             DATE: 02/19/09   ECO: *Q2D3*  */
/*-Revision end---------------------------------------------------------------*/


/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/
/*V8:ConvertMode=Maintenance                                                  */
/* DEFINITION OF SHARED VARIABLES */
{mfdeclre.i}

/* INCLUDE FILE FOR TRANSLATION GPLABEL FUNCTION */
{gplabel.i}

/* STANDARD MAINTENANCE COMPONENT INCLUDE FILE */
{pxmaint.i}

/* INCLUDE FILE FOR RETRIEVING PROGRAM MANAGER */
{pxpgmmgr.i}

/* COMMON API CONSTANTS AND VARIABLES */
{mfaimfg.i}

/* DEFINITION OF SHARED VARIABLES */
define shared variable new_part  like mfc_logical.
define shared variable undo_all  like mfc_logical   no-undo.
define shared variable promo_old like pt_promo.
define shared variable inrecno   as   recid.
define shared variable sct1recno as   recid.
define shared variable sct2recno as   recid.

/* DEFINITION OF SHARED FRAME */
define shared frame a1.

/* DEFINITION OF LOCAL VARIABLES */
define variable apm-ex-prg     as   character   format "x(10)" no-undo.
define variable apm-ex-sub     as   character   format "x(24)" no-undo.
define variable error_flag     like mfc_logical                no-undo.
define variable err_mess_no    like msg_nbr                    no-undo.
define variable v_std_cost     like sct_cst_tot                no-undo.
define variable v_std_cost_set like sct_sim                    no-undo.

define variable l_pt_added     like pt_added                   no-undo.
define variable l_pt_dsgn_grp  like pt_dsgn_grp                no-undo.
define variable l_pt_status    like pt_status                  no-undo.
define variable l_pt_part_type like pt_part_type               no-undo.
define variable l_pt_group     like pt_group                   no-undo.
define variable l_pt_rev       like pt_rev                     no-undo.
define variable l_pt_drwg_loc  like pt_drwg_loc                no-undo.
define variable l_pt_drwg_size like pt_drwg_size               no-undo.
define variable l_pt_break_cat like pt_break_cat               no-undo.

/* DEFINE TEMP TABLE THAT STORES VALID APM PROD. GROUPS */
{ifttpgrp.i " "}

/* INCLUDE FILE TO DEFINE THE PERSISTENT HANDLE */
{pxphdef.i gpsecxr}

/* Item Master API dataset definition */
{pppdspt.i "reference-only"}

form
   {xxppptmta2c.i}
with frame a1 title color normal (getFrameTitle("ITEM_DATA",15))
side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
if c-application-mode <> "API" then
   setFrameLabels(frame a1:handle).

/* SEVERITY PREPROCESSOR CONSTANT DEFINITION INCLUDE FILE */
{pxsevcon.i}

if c-application-mode = "API" then do on error undo, return:

   /* Get handle of API Controller */
   {gprun.i ""gpaigach.p"" "(output ApiMethodHandle)"}

   if not valid-handle(ApiMethodHandle) then do:
      /* API Error */
      {pxmsg.i &MSGNUM=10461 &ERRORLEVEL=4}
      return.
   end.

   /* Get the Item API dataset from the controller */
   run getRequestDataset in ApiMethodHandle (output dataset dsItem bind).

end.  /* If c-application-mode = "API" */

loopa1:
do transaction on endkey undo, leave:

   if c-application-mode = "API" and retry then
      return error.

   find pt_mstr
      where recid(pt_mstr) = pt_recno
      exclusive-lock no-error.

   if not available pt_mstr
   then
      leave.

   if c-application-mode <> "API" then do:
      ststatus = stline[3].

      status input ststatus.

      display
         pt_prod_line
         pt_added
         pt_rev
         pt_draw
         pt_dsgn_grp
         pt_drwg_loc
         pt_drwg_size
         pt_part_type
         pt_status
         pt_group
         pt_break_cat
         pt_promo
         pt__chr09
         pt__chr10
      with frame a1.
   end. /* c-application-mode <> "API" */

   assign
      l_pt_added      = pt_added
      l_pt_dsgn_grp   = pt_dsgn_grp
      l_pt_status     = pt_status
      l_pt_part_type  = pt_part_type
      l_pt_group      = pt_group
      l_pt_rev        = pt_rev
      l_pt_drwg_loc   = pt_drwg_loc
      l_pt_drwg_size  = pt_drwg_size
      l_pt_break_cat  = pt_break_cat.

   prodloop:
   do on error undo, retry:

      if c-application-mode = "API" and retry then
         return error.

      if c-application-mode <> "API" then do:
         /* BYPASS SCHEMA VALIDATIONS FOR THE FIELDS */
         set
            pt_prod_line
            pt_added
            pt_dsgn_grp
            pt_promo
            pt_part_type
            pt_status
            pt_group
            pt_draw
            pt_rev
            pt_drwg_loc
            pt_drwg_size
            pt_break_cat
            pt__chr09
            pt__chr10
         with frame a1 no-validate.
      end. /* c-application-mode <> "API" */
      else do:
         assign
            pt_prod_line = ttItem.ptProdLine
            pt_added     = ttItem.ptAdded
            pt_dsgn_grp  = ttItem.ptDsgnGrp
            pt_promo     = ttItem.ptPromo
            pt_part_type = ttItem.ptPartType
            pt_status    = ttItem.ptStatus
            pt_group     = ttItem.ptGroup
            pt_draw      = ttItem.ptDraw
            pt_rev       = ttItem.ptRev
            pt_drwg_loc  = ttItem.ptDrwgLoc
            pt_drwg_size = ttItem.ptDrwgSize
            pt_break_cat = ttItem.ptBreakCat.
      end. /* c-application-mode = "API" */

      if input pt_prod_line = "" then do:
      	 display "8888" @ pt_prod_line.
      	 assign pt_prod_line.
      end.
      /* VALIDATE PRODUCT LINE */
      {pxrun.i
          &PROC       = 'validateProductLine'
          &PROGRAM    = 'ppitxr.p'
          &PARAM      = "(input pt_prod_line)"
          &NOAPPERROR = true
          &CATCHERROR = true
      }

      if return-value <> {&SUCCESS-RESULT}
      then do:

         if batchrun
         then do:
            undo_all = yes.
            return.
         end. /* IF batchrun */
         else do:
            if c-application-mode <> "API" then
               next-prompt pt_prod_line with frame a1.
            undo prodloop, retry prodloop.
         end. /* IF NOT batchrun */

      end. /* IF return-value <> {&SUCCESS-RESULT} */

      if l_pt_added <> pt_added
      then do:

         /* VALIDATE FIELD SECURITY FOR FIELD pt_added */
         run validate-field-security
            (input "pt_added",
             input ph_gpsecxr).

         if return-value <> {&SUCCESS-RESULT}
         then do:

            if batchrun
            then do:
               undo_all = yes.
               return.
            end. /* IF batchrun */
            else do:
               if c-application-mode <> "API" then
                  next-prompt pt_added with frame a1.
               undo prodloop, retry prodloop.
            end. /* IF NOT batchrun */

         end. /*  IF return-value <> {&SUCCESS-RESULT} */

      end. /* IF l_pt_added <> pt_added */

      if l_pt_dsgn_grp <> pt_dsgn_grp
      then do:

         /* VALIDATE FIELD SECURITY FOR FIELD pt_dsgn_grp */
         run validate-field-security
            (input "pt_dsgn_grp",
             input ph_gpsecxr).

         if return-value <> {&SUCCESS-RESULT}
         then do:

            if batchrun
            then do:
               undo_all = yes.
               return.
            end. /* IF batchrun */
            else do:
               if c-application-mode <> "API" then
                  next-prompt pt_dsgn_grp with frame a1.
               undo prodloop, retry prodloop.
            end. /* IF NOT batchrun */

         end. /*  IF return-value <> {&SUCCESS-RESULT} */

      end. /* IF l_pt_dsgn_grp <> pt_dsgn_grp */

      if l_pt_part_type <> pt_part_type
      then do:

         /* VALIDATE FIELD SECURITY FOR FIELD pt_part_type */
         run validate-field-security
            (input "pt_part_type",
             input ph_gpsecxr).

         if return-value <> {&SUCCESS-RESULT}
         then do:

            if batchrun
            then do:
               undo_all = yes.
               return.
            end. /* IF batchrun */
            else do:
               if c-application-mode <> "API" then
                  next-prompt pt_part_type with frame a1.
               undo prodloop, retry prodloop.
            end. /* IF NOT batchrun */

         end. /*  IF return-value <> {&SUCCESS-RESULT} */

      end. /* IF l_pt_part_type <> pt_part_type */

      if l_pt_status <> pt_status
      then do:

         /* VALIDATE FIELD SECURITY FOR FIELD pt_status */
         run validate-field-security
            (input "pt_status",
             input ph_gpsecxr).

         if return-value <> {&SUCCESS-RESULT}
         then do:

            if batchrun
            then do:
               undo_all = yes.
               return.
            end. /* IF batchrun */
            else do:
               if c-application-mode <> "API" then
                  next-prompt pt_status with frame a1.
               undo prodloop, retry prodloop.
            end. /* IF NOT batchrun */

         end. /*  IF return-value <> {&SUCCESS-RESULT} */

      end. /* IF l_pt_status <> pt_status */

      if l_pt_group <> pt_group
      then do:

         /* VALIDATE FIELD SECURITY FOR FIELD pt_group */
         run validate-field-security
            (input "pt_group",
             input ph_gpsecxr).

         if return-value <> {&SUCCESS-RESULT}
         then do:

            if batchrun
            then do:
               undo_all = yes.
               return.
            end. /* IF batchrun */
            else do:
               if c-application-mode <> "API" then
                  next-prompt pt_group with frame a1.
               undo prodloop, retry prodloop.
            end. /* IF NOT batchrun */

         end. /*  IF return-value <> {&SUCCESS-RESULT} */

      end. /* IF l_pt_group <> pt_group */

      if l_pt_rev <> pt_rev
      then do:

         /* VALIDATE FIELD SECURITY FOR FIELD pt_rev */
         run validate-field-security
            (input "pt_rev",
             input ph_gpsecxr).

         if return-value <> {&SUCCESS-RESULT}
         then do:

            if batchrun
            then do:
               undo_all = yes.
               return.
            end. /* IF batchrun */
            else do:
               if c-application-mode <> "API" then
                  next-prompt pt_rev with frame a1.
               undo prodloop, retry prodloop.
            end. /* IF NOT batchrun */

         end. /*  IF return-value <> {&SUCCESS-RESULT} */

      end. /* IF l_pt_rev <> pt_rev */

      if l_pt_drwg_loc <> pt_drwg_loc
      then do:

         /* VALIDATE FIELD SECURITY FOR FIELD pt_drwg_loc */
         run validate-field-security
            (input "pt_drwg_loc",
             input ph_gpsecxr).

         if return-value <> {&SUCCESS-RESULT}
         then do:

            if batchrun
            then do:
               undo_all = yes.
               return.
            end. /* IF batchrun */
            else do:
               if c-application-mode <> "API" then
                  next-prompt pt_drwg_loc with frame a1.
               undo prodloop, retry prodloop.
            end. /* IF NOT batchrun */

         end. /*  IF return-value <> {&SUCCESS-RESULT} */

      end. /* IF l_pt_drwg_loc <> pt_drwg_loc */

      if l_pt_drwg_size <> pt_drwg_size
      then do:

         /* VALIDATE FIELD SECURITY FOR FIELD pt_drwg_size */
         run validate-field-security
            (input "pt_drwg_size",
             input ph_gpsecxr).

         if return-value <> {&SUCCESS-RESULT}
         then do:

            if batchrun
            then do:
               undo_all = yes.
               return.
            end. /* IF batchrun */
            else do:
               if c-application-mode <> "API" then
                  next-prompt pt_drwg_size with frame a1.
               undo prodloop, retry prodloop.
            end. /* IF NOT batchrun */

         end. /*  IF return-value <> {&SUCCESS-RESULT} */

      end. /* IF l_pt_drwg_size <> pt_drwg_size */

      if l_pt_break_cat <> pt_break_cat
      then do:

         /* VALIDATE FIELD SECURITY FOR FIELD pt_break_cat */
         run validate-field-security
            (input "pt_break_cat",
             input ph_gpsecxr).

         if return-value <> {&SUCCESS-RESULT}
         then do:

            if batchrun
            then do:
               undo_all = yes.
               return.
            end. /* IF batchrun */
            else do:
               if c-application-mode <> "API" then
                  next-prompt pt_break_cat with frame a1.
               undo prodloop, retry prodloop.
            end. /* IF NOT batchrun */

         end. /*  IF return-value <> {&SUCCESS-RESULT} */

      end. /* IF l_pt_break_cat <> pt_break_cat */

      /* VALIDATE FIELD pt_dsgn_grp */
      {pxrun.i
        &PROC       = 'validateDesignGroup'
        &PROGRAM    = 'ppitxr.p'
        &PARAM      = "(input pt_dsgn_grp)"
        &NOAPPERROR = true
        &CATCHERROR = true
      }

      if return-value <> {&SUCCESS-RESULT}
      then do:

         if batchrun
         then do:
            undo_all = yes.
            return.
         end. /* IF batchrun */
         else do:
            if c-application-mode <> "API" then
               next-prompt pt_dsgn_grp with frame a1.
            undo prodloop, retry prodloop.
         end. /* IF NOT batchrun */

      end. /* IF return-value <> {&SUCCESS-RESULT} */

      /* VALIDATE ITEM TYPE */
      {pxrun.i
         &PROC       = 'validateItemType'
         &PROGRAM    = 'ppitxr.p'
         &PARAM      = "(input pt_part_type)"
         &NOAPPERROR = true
         &CATCHERROR = true
      }

      if return-value <> {&SUCCESS-RESULT}
      then do:

         if batchrun
         then do:
            undo_all = yes.
            return.
         end. /* IF batchrun */
         else do:
            if c-application-mode <> "API" then
               next-prompt pt_part_type with frame a1.
            undo prodloop, retry prodloop.
         end. /* IF NOT batchrun */

      end. /* IF return-value <> {&SUCCESS-RESULT} */

      /* VALIDATE FIELD pt_status */
      {pxrun.i
         &PROC       = 'validateItemStatus'
         &PROGRAM    = 'ppitxr.p'
         &PARAM      = "(input pt_status)"
         &NOAPPERROR = true
         &CATCHERROR = true
      }

      if return-value <> {&SUCCESS-RESULT}
      then do:

         if batchrun
         then do:
            undo_all = yes.
            return.
         end. /* IF batchrun */
         else do:
            if c-application-mode <> "API" then
               next-prompt pt_status with frame a1.
            undo prodloop, retry prodloop.
         end. /* IF NOT batchrun */

      end. /* IF return-value <> {&SUCCESS-RESULT} */

      /* VALIDATE ITEM GROUP */
      {pxrun.i
         &PROC       = 'validateItemGroup'
         &PROGRAM    = 'ppitxr.p'
         &PARAM      = "(input pt_group)"
         &NOAPPERROR = true
         &CATCHERROR = true
      }

      if return-value <> {&SUCCESS-RESULT}
      then do:

         if batchrun
         then do:
            undo_all = yes.
            return.
         end. /* IF batchrun */
         else do:
            if c-application-mode <> "API" then
               next-prompt pt_group with frame a1.
            undo prodloop, retry prodloop.
         end. /* IF NOT batchrun */

      end. /* IF return-value <> {&SUCCESS-RESULT} */

      for first soc_ctrl
         fields (soc_domain soc_apm)
         where soc_domain = global_domain
      no-lock:

         /* BLANK IS VALID AND SHOULD BE VALIDATED */
         if soc_apm
         then do:

            if input pt_promo <> ""
            then do:

               for first tt-ptgrp
                  fields(tt-ptgrp_group)
                  where tt-ptgrp.tt-ptgrp_group = pt_promo
                  no-lock:
               end. /* FOR FIRST tt-ptgrp */

               if not available tt-ptgrp
               then do:

                  /* 6325 - INVALID TrM PRODUCT GROUP */
                  {pxmsg.i &MSGNUM     = 6325
                           &ERRORLEVEL = {&APP-ERROR-RESULT}
                           &FIELDNAME  = "pt_promo"}

                  if batchrun
                  then do:
                     undo_all = yes.
                     return.
                  end. /* IF batchrun */
                  else do:
                     if c-application-mode <> "API" then
                        next-prompt pt_promo with frame a1.
                     undo prodloop, retry prodloop.
                  end. /* IF NOT batchrun */

               end. /* IF NOT AVAILABLE tt-ptgrp */

            end. /* IF INPUT pt_promo <> "" */

         end. /* IF soc_apm */
         else do:

            /* VALIDATE FIELD pt_promo */
            {pxrun.i
               &PROC       = 'validatePromotionGroup'
               &PROGRAM    = 'ppitxr.p'
               &PARAM      = "(input pt_promo)"
               &NOAPPERROR = true
               &CATCHERROR = true
            }

            if return-value <> {&SUCCESS-RESULT}
            then do:

               if batchrun
               then do:
                  undo_all = yes.
                  return.
               end. /* IF batchrun */
               else do:
                  if c-application-mode <> "API" then
                     next-prompt pt_promo with frame a1.
                  undo prodloop, retry prodloop.
               end. /* IF NOT batchrun */

            end. /* if return-value <> {&SUCCESS-RESULT} */

         end. /* ELSE IF NOT soc_apm */

      end. /* FOR FIRST soc_ctrl */

      if  soc_apm
      and (promo_old <> ""
      or   pt_promo  <> "")
      then do:

         /* FUTURE LOGIC WILL GO HERE TO DETERMINE SUBDIRECTORY */

         apm-ex-sub = "if/".

         for first si_mstr
            fields (si_domain si_cur_set si_gl_set si_site)
            where si_domain = global_domain and si_site = pt_site
         no-lock:
         end. /* FOR FIRST si_mstr */

         /* RUN INTERNAL PROCEDURE TO OBTAIN COST SET AND COST */
         {pxrun.i &PROC       = 'get_std_cost'
                  &PARAM      = "(input  pt_part,
                                  input  si_site,
                                  output v_std_cost,
                                  output v_std_cost_set)"
                  &NOAPPERROR = true
                  &CATCHERROR = true
         }

         /* UPDATE GENERIC ITEM RECORD IN APM */
         {gprunex.i
            &module   = 'APM'
            &subdir   = apm-ex-sub
            &program  = 'ifapm054.p'
            &params   = "(input  pt_part,
                          input  pt_desc1,
                          input  pt_desc2,
                          input  pt_net_wt,
                          input  pt_net_wt_um,
                          input  pt_price,
                          input  pt_promo,
                          input  pt_site,
                          input  pt_taxc,
                          input  pt_um,
                          input  v_std_cost,
                          input  v_std_cost_set,
                          input  pt_pm_code,
                          output error_flag,
                          output err_mess_no)"}

         if error_flag
         then do:

            /* ERROR RETURNED BY ifapm054.p */
            {pxmsg.i &MSGNUM     = err_mess_no
                     &ERRORLEVEL = {&APP-ERROR-RESULT}}

            if batchrun
            then do:
               undo_all = yes.
               return.
            end. /* IF batchrun */
            else
               undo prodloop, return.

         end. /* if error_flag then do: */

      end. /* (promo_old <> "" or pt_promo <> "") then do: */

      /* VALIDATE ITEM REVISION */
      {pxrun.i
         &PROC       = 'validateRevision'
         &PROGRAM    = 'ppitxr.p'
         &PARAM      = "(input pt_rev)"
         &NOAPPERROR = true
         &CATCHERROR = true
      }

      if return-value <> {&SUCCESS-RESULT}
      then do:

         if batchrun
         then do:
            undo_all = yes.
            return.
         end. /* IF batchrun */
         else do:
            if c-application-mode <> "API" then
               next-prompt pt_rev with frame a1.
            undo prodloop, retry prodloop.
         end. /* IF NOT batchrun */

      end. /* IF  return-value <> {&SUCCESS-RESULT} */

      /* VALIDATE DRAWING LOCATION */
      {pxrun.i
         &PROC       = 'validateDrawingLocation'
         &PROGRAM    = 'ppitxr.p'
         &PARAM      = "(input pt_drwg_loc)"
         &NOAPPERROR = true
         &CATCHERROR = true
      }

      if return-value <> {&SUCCESS-RESULT}
      then do:

         if batchrun
         then do:
            undo_all = yes.
            return.
         end. /* IF batchrun */
         else do:
            if c-application-mode <> "API" then
               next-prompt pt_drwg_loc with frame a1.
            undo prodloop, retry prodloop.
         end. /* IF NOT batchrun */

      end. /* IF  return-value <> {&SUCCESS-RESULT} */

      /* VALIDATE DRAWING SIZE */
      {pxrun.i
         &PROC       = 'validateDrawingSize'
         &PROGRAM    = 'ppitxr.p'
         &PARAM      = "(input pt_drwg_size)"
         &NOAPPERROR = true
         &CATCHERROR = true
      }

      if return-value <> {&SUCCESS-RESULT}
      then do:

         if batchrun
         then do:
            undo_all = yes.
            return.
         end. /* IF batchrun */
         else do:
            if c-application-mode <> "API" then
               next-prompt pt_drwg_size with frame a1.
            undo prodloop, retry prodloop.
         end. /* IF NOT batchrun */

      end.  /* IF  return-value <> {&SUCCESS-RESULT} */

   end. /* DO ON ERROR UNDO, RETRY WITH FRAME a1 */

   if new_part
   then do:

      /* ASSIGNS DEFAULTS FOR NEW ITEM */
      {pxrun.i
         &PROC       = 'assignDefaultsForNewItem'
         &PROGRAM    = 'ppitxr.p'
         &PARAM      = "(buffer pt_mstr)"
         &NOAPPERROR = true
         &CATCHERROR = true
      }

      /* FOR NEWLY CREATED PART PO SITE SHOULD BE BLANK */
      pt_po_site = "".

      /* CREATE INVENTORY RECORD FOR ITEM */
      {pxrun.i
         &PROC       = 'createInventory'
         &PROGRAM    = 'ppitxr.p'
         &PARAM      = "(buffer pt_mstr,
                         buffer in_mstr)"
         &NOAPPERROR = true
         &CATCHERROR = true
      }

      /* CREATE ITEM COST FOR THE DEFAULT SITE */
      {pxrun.i
         &PROC       = 'createItemCost'
         &PROGRAM    = 'ppicxr.p'
         &PARAM      = "(buffer in_mstr,
                         buffer sct_det,
                         input  'GL')"
         &NOAPPERROR = true
         &CATCHERROR = true
      }

      sct1recno = recid(sct_det).

      /* CREATE ITEM COST FOR THE DEFAULT SITE */
      {pxrun.i
         &PROC       = 'createItemCost'
         &PROGRAM    = 'ppicxr.p'
         &PARAM      = "(buffer in_mstr,
                         buffer sct_det,
                         input  'CUR')"
         &NOAPPERROR = true
         &CATCHERROR = true
      }

      sct2recno = recid(sct_det).

   end. /* IF new_part */

   undo_all = no.

end. /* DO TRANSACTION ON ENDKEY UNDO, LEAVE */


/* INTERNAL PROCEDURE TO OBTAIN COST SET AND COST */
{pppstdcs.i}


PROCEDURE validate-field-security:

   /* VALIDATES FOR USER ACCESS TO A PASSWORD PROTECTED FIELD */

   /* INPUT PARAMETER DEFINITION */
   define input parameter p-fld-name like flh_field  no-undo.
   define input parameter p-handle   like ph_gpsecxr no-undo.

   /* STANDARD VALIDATION FOR USER PASSWORD FOR FIELD PROTECTION */
   {pxrun.i
      &PROC       = 'validateFieldAccess'
      &PROGRAM    = 'gpsecxr.p'
      &HANDLE     = p-handle
      &PARAM      = "(input p-fld-name,
                      input ' ')"
      &FIELD-LIST = p-fld-name
      &NOAPPERROR = true
      &CATCHERROR = true
   }

END PROCEDURE. /* PROCEDURE validate-field-security */
