/* apvomtb.p  - AP VOUCHER MAINTENANCE - Line Distribution              */
/* Copyright 1986-2010 QAD Inc., Santa Barbara, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/* REVISION: 4.0      LAST MODIFIED: 04/13/88            by: FLM *A108  */
/* REVISION: 6.0      LAST MODIFIED: 05/09/91            by: MLV *D630* */
/*                                   05/31/91            by: MLV *D667* */
/*                                   06/06/91            by: MLV *D674* */
/*                                   06/14/91            by: MLV *D689* */
/* REVISION: 7.0      LAST MODIFIED: 08/12/91            by: MLV *F001* */
/*                                   08/12/91            by: MLV *F002* */
/*                                   11/01/91            by: MLV *F031* */
/*                                   01/21/92            by: MLV *F090* */
/*                                   02/05/92            by: MLV *F164* */
/*                                   03/22/92            by: TMD *F303* */
/*                                   04/13/92            by: MLV *F365* */
/*                                   05/18/92            by: MLV *F510* */
/*                                   06/24/92            by: JJS *F681* */
/*                                   07/06/92            by: MLV *F725* */
/* REVISION: 7.3      Last Modified: 07/24/92            by: MPP *G004* */
/*                                   08/17/92            by: MLV *G031* */
/*                                   08/26/92            by: MLV *G042* */
/*                                   10/12/92            by: MLV *G053* */
/*                                   12/11/92            by: bcm *G418* */
/*                                   01/12/93            by: jms *G537* */
/*                                   04/05/93            by: bcm *G889* */
/*                                   04/15/93            by: bcm *G957* */
/*                                   04/19/93            by: bcm *G978* */
/*                                   04/30/93            by: bcm *GA58* */
/*                                   06/29/93            by: jms *GD32* */
/* REVISION: 7.4      LAST MODIFIED: 07/13/93            by: wep *H037* */
/*                                   08/08/93            by: bcm *H060* */
/*                                   08/23/93            by: jms *H080* */
/*                                   09/29/93            by: bcm *H143* */
/*                                   02/25/94            by: pcd *H199* */
/*                                   11/29/93            by: bcm *H244* */
/*                                   11/30/93            by: pcd *H249* */
/*                                   12/22/93            by: bcm *GI28* */
/*                                   01/24/94            by: wep *H077* */
/*                                   03/03/94            by: bcm *H290* */
/*                                   04/11/94            by: pmf *FM53* */
/*                                   05/10/94            by: pmf *FO06* */
/*                                   06/14/94            by: bcm *H383* */
/*                                   06/15/94            by: bcm *H387* */
/*                                   06/15/94            by: bcm *H389* */
/*                                   08/10/94            by: bcm *H478* */
/*                                   08/12/94            by: str *H479* */
/*                                   09/06/94            by: bcm *H505* */
/* REVISION: 7.4      LAST MODIFIED: 09/12/94            by: slm *GM17* */
/*                                   09/15/94            by: ljm *GM57* */
/*                                   10/06/94            by: str *FS09* */
/*                                   10/17/94            by: ljm *GN36* */
/*                                   10/27/94            by: ame *FS90* */
/*                                   11/07/94            by: str *FT44* */
/*                                   02/16/95            by: jzw *H0BF* */
/*                                   02/22/95            by: str *F0JB* */
/*                                   02/24/95            by: jzw *H0BM* */
/*                                   03/02/95            by: wjk *F0KL* */
/*                                   04/10/95            by: srk *H0CG* */
/*                                   04/24/95            by: wjk *H0CS* */
/* (Split out apvomtb1.p)            06/19/95            by: jzw *G0Q7* */
/*                                   07/06/95            by: jzw *H0F6* */
/*                                   11/06/95            by: jzw *G1C7* */
/*                                   11/09/95            by: mys *H0GT* */
/*                                   01/24/96            by: jzw *H0J6* */
/*                                   01/31/96            by: jzw *H0J7* */
/* REVISION: 8.5     LAST MODIFIED:  10/02/95            by: mwd *J053* */
/* REVISION: 8.5     LAST MODIFIED:  03/18/96   BY: *J0CV* Robert Wachowicz*/
/* REVISION: 8.5     LAST MODIFIED:  07/09/96            by: ame *H0M0*    */
/*                                   07/15/96   BY: *J0VY* Marianna Deleeuw*/
/* REVISION: 8.5     LAST MODIFIED:  10/25/96            by: rxm *H0NN*    */
/* REVISION: 8.6     LAST MODIFIED:  01/23/97   BY: *K01G* Barry Lass      */
/*                                   02/17/97   BY: *K01R* E. Hughart      */
/*                                   03/10/97   BY: *K084* Jeff Wootton    */
/* REVISION: 8.6     LAST MODIFIED:  08/14/97   BY: *J1Z2* Irine D'mello   */
/* REVISION: 8.6     LAST MODIFIED:  10/03/97   BY: *J22C* Irine D'mello   */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane       */
/* REVISION: 8.6E     LAST MODIFIED: 05/19/98   BY: *J2M1* Dana Tunstall   */
/* REVISION: 8.6E     LAST MODIFIED: 07/23/98   BY: *L03K* Jeff Wootton    */
/* REVISION: 9.0      LAST MODIFIED: 03/10/99   BY: *M0B3* Michael Amaladhas */
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan        */
/* Pre-86E commented code removed, view in archive revision 1.13             */
/* REVISION: 9.1      LAST MODIFIED: 10/01/99   BY: *N014* Murali Ayyagari   */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane  */
/* REVISION: 9.1      LAST MODIFIED: 08/11/00   BY: *N0KK* jyn               */
/* REVISION: 9.1      LAST MODIFIED: 11/22/00   BY: *L15T* Veena Lad         */
/* REVISION: 9.1      LAST MODIFIED: 10/19/00   BY: *N0W0* BalbeerS Rajput   */
/* Old ECO marker removed, but no ECO header exists *F0PN*                   */
/* Revision: 1.14.2.8     BY: Katie Hilbert        DATE: 04/01/01 ECO: *P002* */
/* Revision: 1.14.2.9     BY: Ed van de Gevel      DATE: 05/08/02 ECO: *P069* */
/* Revision: 1.14.2.10    BY: Rajesh Kini          DATE: 06/04/02 ECO: *N1KL* */
/* Revision: 1.14.2.11    BY: Mamata Samant        DATE: 06/19/02 ECO: *N1K9* */
/* Revision: 1.14.2.12    BY: Gnanasekar           DATE: 09/11/02 ECO: *N1PG* */
/* Revision: 1.14.2.13    BY: Seema Tyagi          DATE: 10/09/02 ECO: *N1TV* */
/* Revision: 1.14.2.14    BY: Jyoti Thatte         DATE: 02/21/03 ECO: *P0MX* */
/* Revision: 1.14.2.17    BY: Shoma Salgaonkar     DATE: 03/27/03 ECO: *N2BT* */
/* Revision: 1.14.2.18    BY: Orawan S.            DATE: 04/21/03 ECO: *P0Q8* */
/* Revision: 1.14.2.19    BY: Mercy Chittilapilly  DATE: 05/21/03 ECO: *P0RM* */
/* Revision: 1.14.2.21    BY: Paul Donnelly (SB)   DATE: 06/26/03 ECO: *Q00B* */
/* Revision: 1.14.2.22    BY: Ed van de Gevel      DATE: 08/05/03 ECO: *Q00R* */
/* Revision: 1.14.2.23    BY: Mercy Chittilapilly  DATE: 08/25/03 ECO: *N2K0* */
/* Revision: 1.14.2.24    BY: Deepali Kotavadekar  DATE: 09/30/03 ECO: *P13S* */
/* Revision: 1.14.2.27    BY: Vandna Rohira        DATE: 11/03/03 ECO: *P14V* */
/* Revision: 1.14.2.30    BY: Dayanand Jethwa      DATE: 01/27/04 ECO: *P1L7* */
/* Revision: 1.14.2.31    BY: Ken Casey            DATE: 02/19/04 ECO: *N2GM* */
/* Revision: 1.14.2.32    BY: Reena Ambavi         DATE: 03/03/04 ECO: *P1RT* */
/* Revision: 1.14.2.33    BY: Patrick Rowan        DATE: 10/11/04 ECO: *P2P5* */
/* Revision: 1.14.2.33.1.2 BY: Bhavik Rathod       DATE: 05/27/05 ECO: *P3MR* */
/* Revision: 1.14.2.33.1.3 BY: Sarita Gonsalves    DATE: 06/08/07 ECO: *P5X7* */
/* Revision: 1.14.2.33.1.4  BY: Ed van de Gevel    DATE: 03/20/08 ECO: *P6P9* */
/* Revision: 1.14.2.33.1.5  BY: Sundeep Kalla      DATE: 01/09/09 ECO: *Q272* */
/* $Revision: 1.14.2.33.1.15 $            BY: Antony LejoS       DATE: 10/25/10 ECO: *Q4FJ* */
/*-Revision end---------------------------------------------------------------*/
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/
/*!
    apvomtb.p - AP Voucher Maintenance - Line Distribution
*/

/*! parameters:
    called_by   integer         0 - apvomt.p
                                1 - aprvmt.p
*/

/*V8:ConvertMode=Maintenance                                                 */
{mfdeclre.i}
{cxcustom.i "APVOMTB.P"}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */

/* GET AUTHORIZED ENTITIES FOR THE USER */
{glsec.i}

{gldydef.i}
{gldynrm.i}
{&APVOMTB-P-TAG1}

define input parameter called_by as integer.

define new shared variable base_det_amt like glt_amt.
define new shared variable undo_all     like mfc_logical.
define new shared variable tax_flag     like mfc_logical.
define new shared variable recalc_tax   like mfc_logical.
define new shared variable vod_amt_old  as character.
define new shared variable vod_amt_fmt  as character.

define shared variable base_amt like ap_amt.
define shared variable jrnl like glt_ref.
define shared variable old_amt like ap_amt.
define shared variable aptotal like ap_amt.
define shared variable fill-all like mfc_logical label "Vchr All".
define shared variable new_vchr like mfc_logical.
define shared variable ap_recno as recid.
define shared variable vo_recno as recid.
define shared variable vd_recno as recid.
define shared variable old_vend like ap_vend.
define shared variable vod_recno as recid.
define shared variable curr_amt like glt_curr_amt.
define shared variable ba_recno as recid.
define shared variable totinvdiff like ap_amt.
define shared variable yes_char   as character format "x(1)".
define shared variable no_char    as character format "x(1)".
define shared variable old_vo_amt like ap_amt.
define shared variable zone_to    like txe_zone_to.
define shared variable zone_from  like txe_zone_from.
define shared variable tax_class  like ad_taxc no-undo.
define shared variable tax_usage     like tx2_tax_usage no-undo.
define shared variable tax_taxable like ad_taxable no-undo.
define shared variable tax_in      like ad_tax_in no-undo.
define shared variable process_tax like mfc_logical.
define shared variable tax_tr_type like tx2d_tr_type.
define shared variable pmt_exists  like mfc_logical.
define shared variable taxchanged  as logical no-undo.
define shared variable rndmthd     like rnd_rnd_mthd.
define shared variable l_flag      like mfc_logical no-undo.

define variable del-yn        like mfc_logical initial no.
define variable vchr_ln       like vod_ln.
define variable l_cntln     like vod_ln no-undo .
define variable vchr_type     like vod_type label "".
define variable glvalid       like mfc_logical.
define variable tax_nbr       like tx2d_nbr.

define variable undo_taxpop   like mfc_logical initial false.
define variable retval        as integer.
define variable edit_flag     like mfc_logical initial yes no-undo.
define variable mc-error-number like msg_nbr no-undo.
define variable l_entity_ok   like mfc_logical no-undo.
define variable l_count       as   integer     no-undo.

{&APVOMTB-P-TAG44}

/* DEFINE SHARED CURRENCY DEPENDENT FORMATTING VARIABLES */
{apcurvar.i}

define new shared frame c.

/* DEFINE VARIABLES FOR GPGLEF.P (GL CALENDAR VALIDATION) */
{gpglefdf.i}

/*V8! pause 0 before-hide. */

form
   vod_det.vod_acct
   vod_det.vod_sub                      /*V8! space(.2) */
   vod_det.vod_cc                       /*V8! space(.2) */
   vod_det.vod_project                  /*V8! space(.2) */
   vod_det.vod_entity                   /*V8! space(.2) */
   vod_det.vod_desc    format "x(14)"   /*V8! space(.2) */
   vod_det.vod_amt
with frame v down width 80
   title color normal (getFrameTitle("TAX_DISTRIBUTION",24)).

/* SET EXTERNAL LABELS */
setFrameLabels(frame v:handle).

form
   ba_batch       colon 10
   ba_ctrl        colon 31 format "->>>>>>>,>>>,>>9.999"
   label "Batch Ctrl"
   ba_total       colon 57 format "->>>>>>>,>>>,>>9.999"
   label "Tot"
   ap_ref         colon 10 format "x(8)" label "Voucher"
   ap_curr        no-label
   aptotal        colon 31 label "Ctrl"
   ap_amt         colon 57 label "Tot"
with side-labels frame c
   title color normal (getFrameTitle("BATCH_/_VOUCHER",23)) width 80.

/* SET EXTERNAL LABELS */
setFrameLabels(frame c:handle).

do on endkey undo, leave:
   find ap_mstr where recid(ap_mstr) = ap_recno no-lock no-error.
   find vo_mstr where recid(vo_mstr) = vo_recno no-lock no-error.
   find vd_mstr where recid(vd_mstr) = vd_recno no-lock no-error.
   find ba_mstr where recid(ba_mstr) = ba_recno
      exclusive-lock
      no-error.

   find first gl_ctrl  where gl_ctrl.gl_domain = global_domain no-lock.
   find first icc_ctrl  where icc_ctrl.icc_domain = global_domain no-lock
   no-error.
   if not available icc_ctrl then do:  create icc_ctrl. icc_ctrl.icc_domain =
   global_domain. end.
   if recid(icc_ctrl) = -1 then .
   find first apc_ctrl  where apc_ctrl.apc_domain = global_domain no-lock.

   {&APVOMTB-P-TAG2}
   assign
      vod_amt_old = vod_amt:format in frame v
      /* SET FORMAT FOR VOUCHER DETAIL AMT */
      vod_amt_fmt = vod_amt_old.
   {gprun.i ""gpcurfmt.p"" "(input-output vod_amt_fmt,
                             input rndmthd)"}

   assign
      ap_amt:format  in frame c = ap_amt_fmt
      aptotal:format in frame c = ap_amt_fmt.

   {&APVOMTB-P-TAG3}
   display
      ba_batch
      ba_ctrl
      ba_total + ap_amt @ ba_total
      ap_ref
      aptotal
      ap_amt
      ap_curr
   with frame c.

   /* DISPLAY SELECTION FORM */
   form
      vchr_ln       label "Ln"
      /*V8! space(.2) */
      vod_acct
      /*V8! view-as fill-in size 8.5 by 1 */
      /*V8! space(.2) */
      vod_sub                          /*V8! space(.2) */
      vod_cc                           /*V8! space(.2) */
      vod_project                      /*V8! space(.2) */
      vod_entity                       /*V8! space(.2) */
      vod_taxable    column-label "Tax"
      /*V8! space(.2) */
      vod_desc
      format "x(8)"
      /*V8! space(.2) */
      vod_amt
      /*V8! view-as fill-in size 16 by 1 space(.2) */
      vod_type
      /*V8! view-as fill-in size 3 by 1 */
   with frame g
      width 80
      down title color normal (getFrameTitle("DISTRIBUTION",19))
      no-attr-space.

   /* SET EXTERNAL LABELS */
   setFrameLabels(frame g:handle).

   /* FOR BOOLEAN VALUE IN DOWN FRAME,    */
   /* ENSURE TRANSLATION TO USER LANGUAGE */
   {gpfrmdis.i &fname = "g"}

   if not pmt_exists then
      {&APVOMTB-P-TAG4}
      mainloop:
   repeat:
      /* INPUT DISTRIBUTION ENTRIES */

      loopg:
      repeat with frame g width 80:

         clear frame g no-pause.

         aptotal:format in frame c = ap_amt_fmt.

         display aptotal with frame c.

         /* SEE IF ANY DETAIL RECORDS EXIST */
         find last vod_det  where vod_det.vod_domain = global_domain and
         vod_ref = vo_ref no-lock no-error.
         if not available vod_det then do:
            vchr_ln = 1.
            vchr_type = "".
            {&APVOMTB-P-TAG5}
            display
               vchr_ln
               vd_pur_acct @ vod_acct
               vd_pur_sub @ vod_sub
               vd_pur_cc @ vod_cc
               vchr_type @ vod_type
            with frame g.
            {&APVOMTB-P-TAG6}

            display tax_taxable @ vod_taxable with frame g.
            {&APVOMTB-P-TAG7}

            find ac_mstr  where ac_mstr.ac_domain = global_domain and
               ac_code = vd_pur_acct
               no-lock no-error.

            if available ac_mstr then do:
               display ac_desc @ vod_desc with frame g.
            end.
         end. /* IF NOT AVAILABLE VOD_DET */
         if available vod_det then do:

            /*DISPLAY EXISTING DETAIL RECORDS*/
            vchr_ln = vod_ln + 1.
            vchr_type = "".
            /* REFRESH SCREEN FIRST TIME AND AFTER EDIT */

            if edit_flag then do:
               clear frame g all no-pause.

               /* LOCAL VARIABLE TO TRACK THE LINES PER FRAME PAGE IN GUI.*/
               /* THE pause IS DONE AFTER EVERY 15 LINES IN GUI .         */

               l_cntln = 0 .
               for each vod_det  where vod_det.vod_domain = global_domain and
               vod_ref = vo_ref:
                  accumulate l_count (count).
               end. /*FOR EACH vod_det  WHERE*/
               l_count = accum count l_count.
               for each vod_det  where vod_det.vod_domain = global_domain and
               vod_ref = vo_ref:

                  assign
                     vod_amt:format in frame g = vod_amt_fmt
                     l_cntln = l_cntln + 1 .
                  {&APVOMTB-P-TAG8}
                  /*DISPLAY ONLY LAST 12 LINES IN .NET UI, TO OVERCOME PERFORMANCE PROBLEM WHEN DISPLAYING AND HIDING
                    ALL INES*/
                  if (truncate(l_count / 12, 0) = truncate((l_cntln  - 1)/ 12, 0) and (l_count mod 12) <> 0 and {gpiswrap.i}) or
                     (not {gpiswrap.i})
                  then do:
                     display
                        vod_ln @ vchr_ln
                        vod_acct
                        vod_sub
                        vod_cc
                        vod_project
                        vod_entity
                        vod_taxable
                        vod_desc
                        vod_amt
                        vod_type
                     with frame g.
                     {&APVOMTB-P-TAG9}

                     /*V8! if not batchrun
                        and (l_cntln mod 15 = 0)
                     then
                        pause . */

                     down 1 with frame g.
                  end. /*IF (TRUNCATE(l_count / 12, 0) = TRUNCATE(l_cntln / 12, 0) AND {gpiswrap.i}) OR */
               end.
            end.
         end. /* IF AVAILABLE VOD_DET */

         if apc_confirm = no and vo_confirm = yes and not new_vchr
         then do:
            {pxmsg.i &MSGNUM=2214 &ERRORLEVEL=2}
            /* VOUCHER CONFIRMED.                      */
            /* NO MODIFICATIONS WITH GL IMPACT ALLOWED */
            if not batchrun then pause.
            leave mainloop.
         end.

         display vchr_ln with frame g.
         setg-1:
         do on error undo, retry:
            set vchr_ln with frame g
            editing:

               if {gpiswrap.i}
               then
                  recno = ?.

               /*NEXT/PREVIOUS*/
               {mfnp01.i vod_det vchr_ln vod_ln vo_ref  " vod_det.vod_domain =
               global_domain and vod_ref "  vod_ref}
               if recno <> ? then do:
                  {&APVOMTB-P-TAG10}
                  assign vod_amt:format in frame g = vod_amt_fmt.
                  display
                     vod_ln @ vchr_ln
                     vod_acct
                     vod_sub
                     vod_cc
                     vod_project
                     vod_entity
                     vod_desc
                     vod_amt
                     vod_type
                     {&APVOMTB-P-TAG11}
                     vod_taxable
                     {&APVOMTB-P-TAG12}
                  with frame g.
               end.
               else  /* NEW (EMPTY) RECORD*/
                  display tax_taxable @ vod_taxable with frame g.

            end.

            if not can-find(vod_det
                                where vod_det.vod_domain = global_domain and
                                vod_ref = vo_ref
                               and   vod_ln  = vchr_ln)
            then do:

               if vchr_ln = 0
               then do:

                  /* VALUE MUST BE GREATER THAN ZERO */
                  {pxmsg.i
                      &MSGNUM     = 3953
                      &ERRORLEVEL = 3}

                  /* IF AN ERROR IS ENCOUNTERED IN BATCH */
                  /* MODE l_flag IS SET TO true          */
                  if batchrun
                  then
                     l_flag = true.

                  undo setg-1, retry setg-1.

               end. /* IF vchr_ln = 0 */

               {pxmsg.i &MSGNUM=1 &ERRORLEVEL=1} /* ADDING NEW RECORD */
               edit_flag = no.

            end. /* IF NOT can-find(vod_det ... */

            else
               edit_flag = yes.

         end. /* SETG-1 */

         /* IF l_flag IS true THEN RETURN TO THE CALLING */
         /* PROGRAM WITHOUT PROCEEDING FURTHER           */
         if l_flag = true
         then
            return.

         ststatus = stline[3].
         status input ststatus.
         apply lastkey.

         find first vod_det
             where vod_det.vod_domain = global_domain and  vod_ref = vo_ref
            and vod_ln = vchr_ln
            exclusive-lock no-error.
         if not available vod_det then do:
            create vod_det. vod_det.vod_domain = global_domain.
            vod_entity = ap_entity.
            {&APVOMTB-P-TAG13}
            display vod_entity with frame g.

            setg-2:
            do on error undo, retry:

               {&APVOMTB-P-TAG14}
               prompt-for
                  vod_det.vod_acct
                  vod_sub
                  vod_cc
                  vod_project
                  vod_entity
                  vod_taxable
               with frame g.
               {&APVOMTB-P-TAG15}

               assign
                  vod_ref = vo_ref
                  vod_dy_code = dft-daybook
                  vod_ln = vchr_ln
                  vod_acct
                  vod_sub
                  vod_cc
                  vod_project
                  vod_taxable
                  vod_entity
                  vod_type = "".
               if recid(vod_det) = -1 then .

               {&APVOMTB-P-TAG16}

               {&APVOMTB-P-TAG41}
               assign
                  vod_tax_usage = tax_usage
                  vod_taxc      = tax_class
                  /* DEFAULT TO TAX INCLUDED STATUS OF THE HEADER */
                  vod_tax_in    = tax_in
                  vod_tax_env   = vo_tax_env
                  recalc_tax    = true.
                  /* SET WHEN ADDING NEW DETAIL*/

               if vo_curr <> base_curr then do:
                  find ac_mstr  where ac_mstr.ac_domain = global_domain and
                     ac_code = vod_acct
                     no-lock no-error.
                  if available ac_mstr

                  then do:
                     /* CHECK ACCOUNT CURRENCY AGAINST VOUCHER, */
                     /* WITH UNION TRANSPARENCY ALLOWED         */
                     {&APVOMTB-P-TAG47}
                     {gprunp.i "mcpl" "p" "mc-chk-transaction-curr"
                        "(input ac_curr,
                          input vo_curr,
                          input ap_effdate,
                          input true,
                          output mc-error-number)"}
                     {&APVOMTB-P-TAG48}
                     if mc-error-number <> 0 then do:
                        {pxmsg.i &MSGNUM=134 &ERRORLEVEL=3}
                        /*ACCT CURR MUST BE EITHER TRANS OR BASE CURR*/

                        if batchrun
                        then
                           l_flag = true.

                        next-prompt vod_det.vod_acct with frame g.
                        undo setg-2, retry.
                     end.
                  end.
               end.

               /* TRY THE WHOLE ACCOUNT FIELD FIRST */
               find al_mstr  where al_mstr.al_domain = global_domain and
               al_code = vod_acct no-lock no-error.

               if available al_mstr then
                  vod_desc = al_desc.
               else do:
                  find ac_mstr  where ac_mstr.ac_domain = global_domain and
                     ac_code = vod_acct
                     no-lock no-error.
                  if available ac_mstr then do:
                     vod_desc = ac_desc.
                  end.
               end.

               /* INITIALIZE SETTINGS */
               {gprunp.i "gpglvpl" "p" "initialize"}

               /* ACCT/SUB/CC/PROJECT VALIDATION */
               {gprunp.i "gpglvpl" "p" "validate_fullcode"
                  "(input vod_acct,
                    input vod_sub,
                    input vod_cc,
                    input vod_project,
                    output glvalid)"}

               if glvalid = no then do:

                  if batchrun
                  then
                     l_flag = true.

                  next-prompt vod_acct with frame g.
                  undo, retry.
               end.

               /* VERIFY ENTITY*/
               find en_mstr  where en_mstr.en_domain = global_domain and
                  en_entity = vod_entity no-lock
                  no-error.
               if not available en_mstr then do:
                  {pxmsg.i &MSGNUM=3061 &ERRORLEVEL=3}
                  /*INVALID ENTITY*/

                  if batchrun
                  then
                     l_flag = true.

                  next-prompt vod_entity with frame g.
                  undo, retry.
               end.
               else if en_consolidation then do:
                  /* CONSOLIDATION ENTITY */
                  {pxmsg.i &MSGNUM=6183 &ERRORLEVEL=3}
                  if batchrun then l_flag = true.
                  next-prompt vod_entity with frame g.
                  undo, retry.
               end.
               release en_mstr.

               /* CHECK IF USER IS AUTHORIZED FOR THE ENTITY ENTERED */
               {glenchk.i &entity=vod_entity &entity_ok=l_entity_ok}

               if not l_entity_ok
               then do:

                  if batchrun
                  then
                     l_flag = true.
                  else
                     next-prompt vod_entity with frame g.

                  undo,retry.

               end. /* IF NOT l_entity_ok */

               /* VALIDATE ENTITY FOR DAYBOOKS */
               if daybooks-in-use then do:
                  {gprun.i ""gldyver.p"" "(input ""AP"",
                                           input ""VO"",
                                           input ap_dy_code,
                                           input vod_entity,
                                           output daybook-error)"}
                  if daybook-error then do:
                     {pxmsg.i &MSGNUM=1674 &ERRORLEVEL=2}
                     /* WARNING: DAYBOOK DOES NOT MATCH ANY DEFAULT */
                     if not batchrun then pause.
                  end.
               end.

               /* VERIFY GL CALENDAR FOR SPECIFIED ENTITY */
               /* (SKIP VALIDATION IF RECURRING VOUCHER)  */
               if vo_confirmed
                  and called_by <> 1 then do:
                  {&APVOMTB-P-TAG49}
                  {gpglef02.i &module = ""AP""
                     &entity = vod_entity
                     &date   = ap_effdate
                     &prompt = "vod_entity"
                     &frame  = "g"
                     &loop   = "setg-2"}
                  {&APVOMTB-P-TAG50}
               end.

               {&APVOMTB-P-TAG17}
            end.

            if l_flag = true
            then
               return.

         end. /* IF NOT AVAILABLE VOD_DET */
         else /* VOD_DET AVAILABLE */
         do:
            {&APVOMTB-P-TAG18}
            /* IF VOUCHER CREATED BY EARLIER VERSION OF */
            /* APVOMTB.P, IT WILL NOT HAVE VOD_TAX_ENV. */
            vod_tax_env = vo_tax_env.
            /* AND WILL NOT HAVE VOD_TAXABLE */
            vod_taxable = (vod_tax_at = "yes").
            /* AND WILL NOT HAVE VOD_TAX_IN, WHICH THE  */
            /* SCHEMA UPDATE WILL HAVE SET TO FALSE.    */

            assign vod_amt:format in frame g = vod_amt_fmt.
            display vod_acct
               vod_sub
               vod_cc
               vod_project
               vod_entity
               vod_desc
               vod_amt with frame g.
            /* VERIFY GL CALENDAR FOR SPECIFIED ENTITY */
            /* (SKIP VALIDATION IF RECURRING VOUCHER)  */
            if vo_confirmed
               and called_by <> 1 then do:
               {&APVOMTB-P-TAG51}
               {gpglef02.i &module = ""AP""
                  &entity = vod_entity
                  &date   = ap_effdate
                  &prompt = "vod_entity"
                  &frame  = "g"}
               {&APVOMTB-P-TAG52}
            end.
            {&APVOMTB-P-TAG19}
            display vod_taxable
            with frame g.
            {&APVOMTB-P-TAG20}
            /* GTM IS ABLE TO CHANGE TAX DATA AND RECALCULATE */
            if vod_tax = "" /* NOT TAX DETAIL LINE */
               and vod_type <> "R" /* NOT A RECEIVER LINE */
               then
            set
               vod_taxable
            with frame g.

            /* BACK OUT MEMO TOTAL */
            ap_amt = ap_amt - vod_amt.
            ap_base_amt = ap_base_amt - vod_base_amt.

         end. /* IF AVAILABLE VOD_DET */

         /* WHETHER VOD-DET IS NEW OR OLD -- */

         if vod_tax = ""
            and vod_type <> "R" /* R = RECEIVER DETAIL */
            and vod_taxable
            {&APVOMTB-P-TAG42}
         then do:

            taxloop:
            do on error undo, retry:

               if vod_taxable
               then
                  vod_tax_at = "yes".
               else
                  assign
                     vod_tax_at = "no"
                     vod_tax_in = false.

               /* TAX MANAGEMENT TRANSACTION POP-UP. */
               /* PARAMETERS ARE 5 FIELDS AND UPDATEABLE FLAGS, */
               /* STARTING ROW, AND UNDO FLAG. */

               /* Identify context for QXtend */
               {gpcontxt.i
                  &STACKFRAG = 'txtrnpop,apvomtb,apvomt'
                  &FRAME = 'set_tax' &CONTEXT = 'DIST'}

               {&APVOMTB-P-TAG45}
               {gprun.i ""txtrnpop.p""
                  "(input-output vod_tax_usage, input true,
                   input-output vod_tax_env,   input false,
                   input-output vod_taxc,      input true,
                   input-output vod_taxable,   input true,
                   input-output vod_tax_in,    input true,
                   input 2,
                   output undo_taxpop)"}
               {&APVOMTB-P-TAG46}

               /* Clear context for QXtend */
               {gpcontxt.i
                  &STACKFRAG = 'txtrnpop,apvomtb,apvomt'
                  &FRAME = 'set_tax'}

               /* l_flag IS SET TO true IN BATCH MODE. */
               if undo_taxpop
               then
                  if not batchrun
                  then
                     undo loopg, retry.
                  else do:
                     l_flag = true.
                     return.
                  end. /* ELSE batchrun */

               if vod_taxable
               then
                  vod_tax_at = "yes".
               else
                  vod_tax_at = "no".

               display vod_taxable with frame g.

               {&APVOMTB-P-TAG21}

               recalc_tax = true.  /* SET WHEN UPDATING TAX DATA */

            end. /* TAXLOOP */
            {&APVOMTB-P-TAG22}

            display vod_taxable
            with frame g.

            if vod_taxable
            then
               vod_tax_at = "yes".
            {&APVOMTB-P-TAG23}

         end. /* IF VOD_TAX = "" ... */
         /* SET VOD_TAX_AT for NON TAXABLE*/

         else if not vod_taxable
         then
            assign
               vod_tax_at = "no"
               vod_tax_in = false.
         {&APVOMTB-P-TAG43}
         assign
            recno = recid(vod_det)
            del-yn = no.

         setloopg:
         do on error undo, retry:

            assign vod_amt:format in frame g = vod_amt_fmt.

            display vod_desc
               vod_type
            with frame g.

            if not (vod_tax <> "") then do:
               {gprun.i ""gpdesc.p""
                  "(input        frame-row(g) + 3,
                    input-output vod_desc)"}

               if keyfunction(lastkey) = "end-error" or
                  keyfunction(lastkey) = "." then
                     undo loopg, retry.
               display vod_desc with frame g.
            end.

            if batchrun
            then
               l_flag = true.

            {&APVOMTB-P-TAG24}
            update
               vod_amt when (icc_gl_tran  = no or vod_type <> "R")
                       and  (not (vod_tax <> ""))
               with frame g
            editing:
               {&APVOMTB-P-TAG25}
               if vod_type = "R" then
                     ststatus = stline[3].
               else
                     ststatus = stline[2].
               status input ststatus.
               readkey.
               /* DELETE */
               if (lastkey   = keycode("F5")
                  or lastkey = keycode("CTRL-D"))
                  and vod_type <> "R"
               then do:
                  del-yn = yes.
                  {mfmsg01.i 11 1 del-yn} /*CONFIRM DELETE*/
                  if del-yn then leave.
               end.
               else apply lastkey.
            end.  /* DISPLAY... EDITING */

            /* IF NO ERROR IS ENCOUNTERED SET */
            /* l_flag TO false IN BATCH MODE  */
            if batchrun
            then
               l_flag = false.

            /* CONVERT FROM FOREIGN TO BASE CURRENCY */
            {gprunp.i "mcpl" "p" "mc-curr-conv"
               "(input vo_curr,
                 input base_curr,
                 input vo_ex_rate,
                 input vo_ex_rate2,
                 input vod_amt,
                 input true, /* ROUND */
                 output vod_base_amt,
                 output mc-error-number)"}.
            if mc-error-number <> 0 then do:
               {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
            end.

            {&APVOMTB-P-TAG26}
            /* CHECK FOR NON ZERO AMOUNT */
            if vod_amt = 0 then do:
               {&APVOMTB-P-TAG27}
               {pxmsg.i &MSGNUM=1161 &ERRORLEVEL=2}
               {&APVOMTB-P-TAG28}
            end.
            if vod_amt <> 0 then do:
               {gprun.i ""gpcurval.p"" "(input vod_amt, input rndmthd,
                                         output retval)"}
               if retval <> 0 then do:

                  if batchrun
                  then
                     l_flag = true.

                  next-prompt vod_amt with frame g.
                  undo setloopg, retry setloopg.
               end.
            end.
            {&APVOMTB-P-TAG29}
            if del-yn or vod_amt = 0 then do:
               {&APVOMTB-P-TAG30}
               delete vod_det.
               clear frame g.
               del-yn = no.

               /* DELETE TAX DISTRIBUTION RECORDS IF ALL */
               /* TAXABLE LINES HAVE BEEN DELETED */
               if not can-find(first vod_det  where vod_det.vod_domain =
               global_domain and
                  vod_ref = vo_ref and vod_tax_at = "yes")
               then do:
                  find first vod_det  where vod_det.vod_domain = global_domain
                  and  vod_ref = vo_ref
                     and vod_tax > "" no-lock no-error.
                  if available vod_det then do:
                     /*DELETE tx2d_det AND VOD_DET RECORDS, WRITE */
                     /*REVERSING GL'S                             */
                     {apdeltx.i &looplabel = "deltax"}

                     /* DELETE tx2d_det RECORDS */
                     tax_nbr     = "*".    /* FOR ALL RECEIVERS */
                     {gprun.i ""txdelete.p"" "(input tax_tr_type,
                                               input vo_ref,
                                               input tax_nbr)"}
                  end.
               end. /* IF not can-find... */

               ap_amt:format in frame c = ap_amt_fmt.

               display
                  ba_total + ap_amt @ ba_total
                  ap_amt with frame c.
               next loopg.
            end.  /* IF DEL-YN OR... */

            /* IF TAX DISTRIBUTION RECORD, GIVE ERROR THAT THE */
            /* RECORD CANNOT BE UPDATED                          */
            if vod_tax <> "" then do:
               {pxmsg.i &MSGNUM=931 &ERRORLEVEL=4}
            end.

            /* UPDATE MEMO TOTAL */
            assign
               ap_amt:format in frame c = ap_amt_fmt
               ap_amt = ap_amt + vod_amt
               ap_base_amt = ap_base_amt + vod_base_amt.

            down 1 with frame g.

            display ap_amt
               ba_total + ap_amt @ ba_total with frame c.
         end.  /* SETLOOPG */

         if l_flag = true
         then
            return.

         {&APVOMTB-P-TAG31}
      end. /* LOOPG */

      /* CHECK FOR EXISTING TAX LINES IN VOD */
      {&APVOMTB-P-TAG32}
      {&APVOMTB-P-TAG33}

      /* RESTRICT TAX RECALCULATION WHEN:                          */
      /* 1) apc_confirm = NO, vo_confirm = YES AND NOT new_vchr    */
      /* 2) apc_confirm = YES AND GL CALENDAR IS CLOSED FOR AP     */

      if can-find(first vod_det  where vod_det.vod_domain = global_domain and (
       vod_ref = vo_ref))
         and (not (apc_confirm     = no
                   and vo_confirm  = yes
                   and not new_vchr)
              or new_vchr)
      then do:

         /* VERIFY GL CALENDAR FOR EFFECTIVE DATE   */
         /* (SKIP VALIDATION IF RECURRING VOUCHER)  */
         if called_by <> 1
         then do:
            {gpglef01.i ""AP"" ap_entity ap_effdate}
         end. /* IF called_by <> 1 */
         if (gpglef = 0
             or not vo_confirmed)
         then do:
            recalc_tax = true.
            {gprun.i ""xxapvomth.p""}
            if undo_all then
               undo mainloop, leave.
         end. /* IF gpglef = 0 OR... */

         {&APVOMTB-P-TAG34}
         leave mainloop.
         {&APVOMTB-P-TAG35}
      end. /* IF CAN-FIND... */
      else
         leave mainloop.

   end. /*mainloop*/

   if l_flag = true
   then
      return.

   {&APVOMTB-P-TAG36}

   repeat:
      if ap_amt < 0 and vo_cr_terms <> "" then do:
         find ct_mstr  where ct_mstr.ct_domain = global_domain and  ct_code =
         vo_cr_terms no-lock no-error.
         if available ct_mstr and ct_dating = yes then do:
            /*Invalid terms code - terms deleted*/
            {pxmsg.i &MSGNUM=2200 &ERRORLEVEL=2}
            vo_cr_terms = "".
            if not batchrun then pause.
         end.
      end.
      leave.
   end.

   if (vo_ndisc_amt > ap_amt and ap_amt > 0) or
      (vo_ndisc_amt < ap_amt and ap_amt < 0)
   then
   assign
      vo_ndisc_amt = ap_amt
      vo_base_ndisc = ap_base_amt.

   if vo_separate and ap_amt < 0 then do:
      {pxmsg.i &MSGNUM=4050 &ERRORLEVEL=2}
      /*VOUCHER AMOUNT NEGATIVE, SETTING SEPARATE CHECK TO NO*/
      vo_separate = no.
   end.

   ba_total = ba_total + ap_amt.

end. /* DO ON ENDKEY UNDO, LEAVE */

/* DELETING THE vod_det RECORD WITH vod_type  = "X" WHEN NO OTHER */
/* RECORD EXISTS FOR THE SAME VOUCHER REFERENCE                   */
if not can-find (first vod_det
                  where vod_det.vod_domain = global_domain and  vod_ref   =
                  ap_ref
                   and vod_type <> "x")
then do:

   find first vod_det
       where vod_det.vod_domain = global_domain and  vod_ref  = ap_ref
        and vod_type = "x"
   exclusive-lock no-error.
   if available vod_det
   then
      delete vod_det.

end. /* IF NOT CAN-FIND (FIRST vod_det ... */

/* EXECUTE VOUCHER TRAILER FRAME IF VOUCHER IS NOT EMPTY */
/* OR IF THE VOUCHER IS EMPTY AND NOT A NEW VOUCHER          */
{&APVOMTB-P-TAG37}
if (can-find (first vod_det
                 where vod_det.vod_domain = global_domain
                 and  (vod_ref            = vo_ref))
   or can-find (first vph_hist
                   where vph_hist.vph_domain = global_domain
                   and  (vph_hist.vph_ref    = vo_ref)))
   or (not ((can-find (first vod_det
                          where vod_det.vod_domain = global_domain
                          and   vod_ref            = vo_ref) or
             can-find (first vph_hist
                          where vph_hist.vph_domain = global_domain
                          and   vph_hist.vph_ref    = vo_ref)))
       and   new_vchr = no)
   and called_by = 0
then do:
   {&APVOMTB-P-TAG38}
   hide frame g no-pause.
   /* VOUCHER TRAILER FRAME (HOLD/CONFIRM) */
   {gprun.i ""xxapvomtb1.p""}
end.

do on error undo, retry:
   hide frame c no-pause.
   hide frame g no-pause.
end.
{&APVOMTB-P-TAG39}
