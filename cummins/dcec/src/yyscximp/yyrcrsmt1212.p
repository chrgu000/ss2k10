/* GUI CONVERTED from yyrcrsmt1212.p (converter v1.78) Thu Dec  6 14:46:56 2012 */
/* rcrsmt.p - Release Management Customer Schedules                           */
/* Copyright 1986-2005 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* REVISION: 7.0    LAST MODIFIED: 01/29/92           BY: WUG *F110*          */
/* REVISION: 7.0    LAST MODIFIED: 03/17/92           BY: WUG *F312*          */
/* REVISION: 7.0    LAST MODIFIED: 03/26/92           BY: WUG *F323*          */
/* REVISION: 7.3    LAST MODIFIED: 10/12/92           BY: WUG *G462*          */
/* REVISION: 7.3    LAST MODIFIED: 12/23/92           BY: WUG *G471*          */
/* REVISION: 7.3    LAST MODIFIED: 03/17/93           BY: WUG *G833*          */
/* REVISION: 7.3    LAST MODIFIED: 08/13/93           BY: WUG *GE19*          */
/*                                 08/27/94           BY: BCM *GL61*          */
/*                                 09/20/94           BY: JPM *GM74*          */
/*                                 03/22/95           BY: aed *G0J0*          */
/* REVISION: 8.5    LAST MODIFIED: 04/24/95           BY: dpm *J044*          */
/* REVISION: 7.4    LAST MODIFIED: 09/14/95           BY: vrn *G0V2*          */
/* REVISION: 7.4    LAST MODIFIED: 08/29/95           BY: bcm *G0TB*          */
/* REVISION: 7.4    LAST MODIFIED: 09/16/95           BY: vrn *G0X9*          */
/* REVISION: 7.4    LAST MODIFIED: 11/02/95           BY: vrn *G0YL*          */
/* REVISION: 8.6    LAST MODIFIED: 09/20/96           BY: TSI *K005*          */
/* REVISION: 8.6    LAST MODIFIED: 08/08/97           BY: *J1YQ* Suresh Nayak */
/* REVISION: 8.6    LAST MODIFIED: 10/15/97           BY: *J232* Niranjan R.  */

/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane          */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan         */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan         */
/* REVISION: 9.1      LAST MODIFIED: 07/07/99   BY: *J3HR* Sachin Shinde      */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1      LAST MODIFIED: 08/12/00   BY: *N0KP* myb                */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.13.1.4    BY: Manisha Sawant      DATE: 02/13/02 ECO: *M1VJ*   */
/* Revision: 1.13.1.5    BY: Katie Hilbert       DATE: 04/15/02 ECO: *P03J*   */
/* Revision: 1.13.1.6    BY: Seema Tyagi         DATE: 05/13/02 ECO: *N1J7*   */
/* Revision: 1.13.1.10   BY: Subramanian Iyer    DATE: 02/24/03 ECO: *N265*   */
/* Revision: 1.13.1.12   BY: Paul Donnelly (SB)  DATE: 06/28/03 ECO: *Q00K*   */
/* Revision: 1.13.1.14   BY: Rajinder Kamra      DATE: 04/16/03 ECO: *Q003*   */
/* Revision: 1.13.1.15   BY: Deepali Kotavadekar DATE: 08/04/03 ECO: *N2GJ*   */
/* Revision: 1.13.1.16   BY: Mercy Chittilapilly DATE: 10/21/03 ECO: *N2KL*  */
/* Revision: 1.13.1.17   BY: Sukhad Kulkarni     DATE: 01/04/05 ECO: *P303*  */
/* Revision: 1.13.1.18   BY: Milind Shahane      DATE: 01/31/05 ECO: *P363*  */
/* Revision: 1.13.1.19   BY: Vinodkumar M.       DATE: 07/06/05 ECO: *P3S0*  */
/* $Revision: 1.13.1.20 $         BY: Deepali Shete       DATE: 12/20/05 ECO: *P4CR*  */
/*-Revision end---------------------------------------------------------------*/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/
/*V8:ConvertMode=Maintenance                                                  */
/* REQUIRED SHIP SCHEDULE MAINT */

{mfdtitle.i "121205.1"}

/* DEFAULTING THE ACTIVE RELEASE ID AS THE LOOKUP ON RELEASE ID             */
/* FIELD WAS NOT FUNCTIONING CORRECTLY IN DESKTOP 2 WITH THE LOGIC          */
/* OF PATCH N2DB. ALSO, REMOVED THE LOGIC PERTAINING TO GLOBAL              */
/* VARIABLES (global_site, global_loc, global_lot) INTRODUCED BY PATCH N2GJ */

define new shared variable cmtindx        like cmt_indx.
define new shared variable impexp         like mfc_logical no-undo.
define new shared variable impexp_label   as   character
   format "x(8)" no-undo.
define new shared variable global_schtype as integer.

define new shared frame a.

define variable schtype           as   integer initial 3.
define variable i                 as   integer.
define variable del-yn            like mfc_logical.
define variable yn                like mfc_logical.
define variable cmmts             like soc_hcmmts label "Comments".
define variable this_eff_start    as   date.
define variable sch_recid         as   recid.
define variable errlevel          as   integer no-undo.
define variable l_sch_pcr_qty     like sch_pcr_qty no-undo.
define variable l_undo_status     like mfc_logical no-undo.
define variable l_copy            like mfc_logical no-undo.
define variable lv_error_num      as integer       no-undo.
define variable lv_name           as character     no-undo.
define variable l_adj_qty         like schd_discr_qty no-undo.

define buffer prev_sch_mstr for sch_mstr.
define buffer prev_schd_det for schd_det.

{rcordfrm.i}


/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
   
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
{rcordfma.i}
   sch_rlse_id colon 14
 SKIP(.4)  /*GUI*/
with frame a side-labels width 80 attr-space NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-a-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
 RECT-FRAME-LABEL:HIDDEN in frame a = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame a =
  FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5.  /*GUI*/

/*GUI preprocessor Frame A undefine */
&UNDEFINE PP_FRAME_NAME



/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

find first soc_ctrl  where soc_ctrl.soc_domain = global_domain no-lock.

repeat transaction:
/*GUI*/ if global-beam-me-up then undo, leave.


   /* GET SCHEDULED ORDER */
   /* ADDED PARAMETER THREE TO THE CALL: ANY NON-BLANK */
   /* VALUE ENABLES SITE SECURITY CHECK                */
   {rcgetord.i "old" " " "validate"}

   if global_db <> si_db then do:
      {gprunp.i "mgdompl" "p" "ppDomainConnect"
                             "(input  si_db,
                               output lv_error_num,
                               output lv_name)"}

      /* IF NOT CONNECTED, ISSUE ERROR AND UNDO */
      if lv_error_num <> 0
      then do:
         /* DOMAIN # IS NOT AVAILABLE  */
         {pxmsg.i &MSGNUM=lv_error_num &ERRORLEVEL=4 &MSGARG1="si_db"}
         undo, retry.
      end.
   end. /* if global_db <> si_db then do: */

   /* GET SCHEDULE RECORD */
   {yyrcgetrel.i}

   if yn
   then
      l_copy = yes.

   assign
      l_adj_qty = 0
      cmmts     = soc_hcmmts.

   if sch_cmtindx > 0
   then
      cmmts = yes.

   FORM /*GUI*/ 
      
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
      cmmts          colon 20
      sch_cr_date    colon 55
      sch_cr_time    no-label
      sch_cumulative colon 55
      sch_pcr_qty    colon 20
      sch_eff_start  colon 55 label "Active Start"
      sch_pcs_date   colon 20
      sch_eff_end    colon 55 label "Active End"
    SKIP(.4)  /*GUI*/
with frame sched_data attr-space side-labels width 80 NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-sched_data-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame sched_data = F-sched_data-title.
 RECT-FRAME-LABEL:HIDDEN in frame sched_data = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame sched_data =
  FRAME sched_data:HEIGHT-PIXELS - RECT-FRAME:Y in frame sched_data - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME sched_data = FRAME sched_data:WIDTH-CHARS - .5.  /*GUI*/


   /* SET EXTERNAL LABELS */
   setFrameLabels(frame sched_data:handle).

   display
      sch_cr_date
      string(sch_cr_time,"HH:MM:SS") format "x(8)" @ sch_cr_time
   with frame sched_data.

   ststatus = stline[2].
   status input ststatus.

   display
      cmmts
      sch_pcr_qty
      sch_pcs_date
      sch_cumulative
      sch_eff_start
      sch_eff_end
   with frame sched_data.

   l_sch_pcr_qty = sch_pcr_qty.

   do on error undo , retry:
/*GUI*/ if global-beam-me-up then undo, leave.

      set
         cmmts
         sch_pcr_qty
         sch_pcs_date
         sch_cumulative
         sch_eff_start
         sch_eff_end
         go-on(F5 CTRL-D) with frame sched_data.

      if lastkey = keycode("F5")
      or lastkey = keycode("CTRL-D")
      then do:
         /* WARN THE USER WHEN A CONTAINER/SHIPPER IS */
         /* FOUND FOR THE SALES ORDER.                */
         find  scx_ref
             where scx_ref.scx_domain = global_domain and  scx_type  = 1
            and   scx_order = sch_nbr
            and   scx_line  = sch_line
            no-lock.

         for first abs_mstr
            fields(abs_mstr.abs_domain abs_shipfrom
        abs_dataset abs_order abs_line)
            where abs_mstr.abs_domain  = global_domain
        and   abs_shipfrom         = scx_shipfrom
            and   abs_dataset          = "sod_det"
            and   abs_order            = sch_nbr
            and   abs_line             = string(sch_line)
        use-index abs_order
         no-lock:
            /* SHIPPER OR CONTAINER EXISTS FOR SCHEDULE LINE */
            {pxmsg.i &MSGNUM=8304 &ERRORLEVEL=2}
         end. /* FOR FIRST abs_mstr */

         del-yn = yes.
         /* PLEASE CONFIRM DELETE */
         {pxmsg.i &MSGNUM=11 &ERRORLEVEL=1 &CONFIRM=del-yn}
         if del-yn = no
         then
            undo, retry.

         if sod_curr_rlse_id[schtype] = sch_rlse_id
         then do:

            /* BACK OUT OF FORECAST THE OLD ACTIVE SCHEDULE      */
            /* DATA ON OR AFTER TODAY                            */
            {gprun.i ""rcrsfc.p""
                     "(input recid(sod_det),
                       input ""remove"")"}
/*GUI*/ if global-beam-me-up then undo, leave.


            /* DELETE THE SCHEDULE */

            {gprun.i ""rcschdel.p""
                     "(input recid(sch_mstr),
                       input no)"}
/*GUI*/ if global-beam-me-up then undo, leave.


            /* RETURN TO PROMPT IF SCHEDULE WAS NOT DELETED */
            if available sch_mstr
            then do:
               hide frame sched_data no-pause.
               next.
            end.

            /* UPDATE MRP */
            {gprun.i ""rcmrw.p""
                     "(input sod_nbr,
                       input sod_line,
                       input yes)"}
/*GUI*/ if global-beam-me-up then undo, leave.


            sod_curr_rlse_id[schtype] = "".

            /* UPDATE REMOTE DOMAIN SO DETAIL */
            {gprun.i ""rcrsdup.p""
                     "(input recid(sod_det))"}
/*GUI*/ if global-beam-me-up then undo, leave.

         end.
         else do:
            {gprun.i ""rcschdel.p""
                     "(input recid(sch_mstr),
                       input no)"}
/*GUI*/ if global-beam-me-up then undo, leave.


            /* RETURN TO PROMPT IF SCHEDULE WAS NOT DELETED */
            if available sch_mstr
            then do:
               hide frame sched_data no-pause.
               next.
            end.

         end.

         clear frame sched_data.
/*GUI*/ RECT-FRAME-LABEL:SCREEN-VALUE in frame sched_data = F-sched_data-title.
         clear frame a.
/*GUI*/ RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
         next.
      end.
/*GUI*/ if global-beam-me-up then undo, leave.


      if  sch_pcs_date = ?
      and so_cum_acct
      then do:
         /* INVALID PRIOR CUM START DATE */
         {pxmsg.i &MSGNUM=8240 &ERRORLEVEL=3}
         next-prompt sch_pcs_date with frame sched_data.
         undo, retry.
      end.

      if sch_cumulative
      then do:
         find first schd_det
             where schd_det.schd_domain = global_domain and  schd_type    =
             sch_type
            and   schd_nbr     = sch_nbr
            and   schd_line    = sch_line
            and   schd_rlse_id = sch_rlse_id
            and   schd_cum_qty < sch_pcr_qty
         no-lock no-error.
         if available schd_det
         then do:
            /* PRIOR CUM REQUIRED IS GREATER THAN A DETAIL CUM QUANTITY */
            {pxmsg.i &MSGNUM=6021 &ERRORLEVEL=3}
            undo , retry.
         end.
      end.

      if  new sch_mstr
      and sch_eff_start < today
      then do:
         /* INVALID DATE */
         {pxmsg.i &MSGNUM=27 &ERRORLEVEL=3}
         next-prompt sch_eff_start with frame sched_data.
         undo , retry.
      end.

      if sch_eff_end < sch_eff_start
      then do:
         /* START DATE MUST BE PRIOR TO END DATE */
         {pxmsg.i &MSGNUM=4 &ERRORLEVEL=3}
         next-prompt sch_eff_start with frame sched_data.
         undo, retry.
      end.
   end.
/*GUI*/ if global-beam-me-up then undo, leave.


   /* UPDATING THE CUMULATIVE QUANTITY AND DISCRETE QUANTITY   */
   /* FOR SCHEDULE DETAIL RECORDS, RESULTING IN CORRECT GROSS  */
   /* REQUIREMENTS CALCULATED BY MRP                           */

   if l_sch_pcr_qty <> sch_pcr_qty
   then do:
      if sch_cumulative
      then
         for first schd_det
            where schd_det.schd_domain = global_domain
            and   schd_type            = sch_type
            and   schd_nbr             = sch_nbr
            and   schd_line            = sch_line
            and   schd_rlse_id         = sch_rlse_id
         exclusive-lock:
            schd_discr_qty = schd_discr_qty + l_sch_pcr_qty - sch_pcr_qty.
         end. /* FOR FIRST schd_det */
      else
         for each schd_det
            where schd_det.schd_domain = global_domain
            and   schd_type            = sch_type
            and   schd_nbr             = sch_nbr
            and   schd_line            = sch_line
            and   schd_rlse_id         = sch_rlse_id
         exclusive-lock:
            schd_cum_qty = schd_cum_qty - l_sch_pcr_qty + sch_pcr_qty.
         end. /* FOR EACH schd_det */
   end. /* IF l_sch_pcr_qty <> sch_pcr_qty */

   if cmmts
   then do:
      assign
         cmtindx    = sch_cmtindx
         global_ref = scx_shipto.

      {gprun.i ""gpcmmt01.p""
               "(input ""cs"")"}
/*GUI*/ if global-beam-me-up then undo, leave.

      sch_cmtindx = cmtindx.

      view frame a.
   end.

   hide frame sched_data.

   /* BACK OUT OF FORECAST THE OLD ACTIVE SCHEDULE              */
   /* DATA ON OR AFTER TODAY                                    */
   {gprun.i ""rcrsfc.p""
            "(input recid(sod_det),
              input ""remove"")"}
/*GUI*/ if global-beam-me-up then undo, leave.


   /* DO DETAIL MAINTENANCE */

   {gprun.i ""rcscmtb.p""
            "(input recid(sch_mstr))"}
/*GUI*/ if global-beam-me-up then undo, leave.


   yn = no.
   if sch_rlse_id <> sod_curr_rlse_id[schtype]
   then do:

      /* WARN USER OF UNCONFIRMED SHIPPER LINKS */
      errlevel = 0.

      if can-find(first schd_det
                   where schd_det.schd_domain = global_domain and  schd_type
                   = sch_type
                  and   schd_nbr     = sch_nbr
                  and   schd_line    = sch_line
                  and   schd_rlse_id = sod_curr_rlse_id[schtype]
                  and   schd_all_qty > 0)
      then do:
         find so_mstr
             where so_mstr.so_domain = global_domain and  so_nbr = sch_nbr
         no-lock.

         {gprun.i ""gpcfmsg.p""
                  "(input 1519,
                    input 0,
                    input program-name(1),
                    input so_site,
                    input so_ship,
                    input '',
                    input false,
                    output errlevel)"}
/*GUI*/ if global-beam-me-up then undo, leave.


         if errlevel = 1
         or errlevel = 2
         then do:
            /* ACTIVE SCHEDULE IS LINKED TO AN UN-ISSUED SHIPPER */
            {pxmsg.i &MSGNUM=1519 &ERRORLEVEL=errlevel}
         end.

      end.

      /* MAKE THIS SCHEDULE ACTIVE */
      if not batchrun then do:
      {pxmsg.i &MSGNUM=6001 &ERRORLEVEL=1
               &CONFIRM=yn
               &CONFIRM-TYPE='LOGICAL'}
			end.
			else do:
		  		 assign yn = yes.
		  end.

      if  errlevel > 2
      and yn
      then do:
         /* ACTIVE SCHEDULE IS LINKED TO AN UN-ISSUED SHIPPER */
         {pxmsg.i &MSGNUM=1519 &ERRORLEVEL=errlevel}
         yn = no.
      end.

      if l_copy
      then do:
         /* MERGE ACTIVE SCHEDULE WITH NEW ACTIVE SCHEDULE */
         {gprun.i ""rcrsupc.p"" "(input recid(sod_det),
                                  input sch_rlse_id,
                                  output l_undo_status,
                                  output l_adj_qty)"}
/*GUI*/ if global-beam-me-up then undo, leave.

         if l_undo_status
         then
            undo, return.

      end. /* IF l_copy */


      if yn
      then do:
         assign
            this_eff_start = sch_eff_start
            sch_recid = recid(sch_mstr).

         find sch_mstr
             where sch_mstr.sch_domain = global_domain and  sch_type    =
             schtype
            and   sch_nbr     = sod_nbr
            and   sch_line    = sod_line
            and   sch_rlse_id = sod_curr_rlse_id[schtype]
            exclusive-lock
            no-error.

         if available sch_mstr
         then
            sch_eff_end = this_eff_start.

         find sch_mstr
            where recid(sch_mstr) = sch_recid
            exclusive-lock.

         assign
            sch_eff_end = ?
            sod_curr_rlse_id[schtype] = sch_rlse_id.

      end.
   end.

   sod_sched_chgd = yes.

   /* UPDATE REMOTE DOMAIN SCHEDULE */
   {gprun.i ""rcrshup.p""
            "(input recid(sch_mstr))"}
/*GUI*/ if global-beam-me-up then undo, leave.


   /*  UPDATE REMOTE DOMAIN SO DETAIL */
   {gprun.i ""rcrsdup.p""
            "(input recid(sod_det))"}
/*GUI*/ if global-beam-me-up then undo, leave.


   /* UPDATE FORECAST WITH NEW ACTIVE SCHEDULE DATA             */
   /* ON OR AFTER TODAY                                         */

   {gprun.i ""rcrsfc.p""
            "(input recid(sod_det),
              input ""add"")"}
/*GUI*/ if global-beam-me-up then undo, leave.


   /* UPDATE MRP */
   {gprun.i ""rcmrw.p""
            "(input sod_nbr,
              input sod_line,
              input yes)"}
/*GUI*/ if global-beam-me-up then undo, leave.


   release sod_det.

end.
