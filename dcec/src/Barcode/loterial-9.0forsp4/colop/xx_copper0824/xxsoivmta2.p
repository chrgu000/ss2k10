/* xxsoivmta2.p - PENDING INVOICE LINE MAINTENANCE                        */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/* $Revision: 1.24.1.25 $                                              */
/*V8:ConvertMode=Maintenance                                            */
/* REVISION: 7.3            CREATED: 04/07/93   BY: bcm *G889**/
/* REVISION: 7.3      LAST MODIFIED: 04/28/93   BY: tjs *G948**/
/* REVISION: 7.3      LAST MODIFIED: 05/14/93   BY: WUG *GB10**/
/* REVISION: 7.4      LAST MODIFIED: 06/16/93   BY: bcm *H002**/
/* REVISION: 7.4      LAST MODIFIED: 09/21/93   BY: afs *H134**/
/* REVISION: 7.4      LAST MODIFIED: 10/19/93   BY: cdt *H184**/
/* REVISION: 7.4      LAST MODIFIED: 02/17/94   BY: dpm *FM10**/
/* REVISION: 7.4      LAST MODIFIED: 09/02/94   BY: dpm *FQ53**/
/* REVISION: 7.4      LAST MODIFIED: 09/10/94   BY: dpm *FQ95**/
/* REVISION: 7.4      LAST MODIFIED: 09/11/94   BY: dpm *GM18**/
/* REVISION: 7.4      LAST MODIFIED: 10/31/94   BY: dpm *FR95**/
/* REVISION: 8.5      LAST MODIFIED: 11/22/94   BY: taf *J038**/
/* REVISION: 7.4      LAST MODIFIED: 12/12/94   BY: dpm *FT84**/
/* REVISION: 7.4      LAST MODIFIED: 01/13/95   BY: dpm *F0DR**/
/* REVISION: 7.4      LAST MODIFIED: 01/17/95   BY: srk *G0C1**/
/* REVISION: 7.4      LAST MODIFIED: 02/23/95   BY: jzw *H0BM**/
/* REVISION: 8.5      LAST MODIFIED: 04/19/95   BY: DAH *J042**/
/* REVISION: 7.4      LAST MODIFIED: 08/29/95   BY: jym *G0VQ**/
/* REVISION: 7.4      LAST MODIFIED: 09/29/95   BY: ais *F0VK**/
/* REVISION: 7.4      LAST MODIFIED: 12/11/95   BY: ais *G1FW**/
/* REVISION: 7.4      LAST MODIFIED: 12/19/95   BY: ais *G1H4**/
/* REVISION: 7.4      LAST MODIFIED: 01/24/96   BY: jzw *H0J6**/
/* REVISION: 8.5      LAST MODIFIED: 03/25/96   BY: *J04C* Sue Poland   */
/* REVISION: 8.6      LAST MODIFIED: 10/01/96   BY: svs *K007**/
/* REVISION: 8.6      LAST MODIFIED: 11/07/96   BY: *K01W* Ajit Deodhar   */
/* REVISION: 8.6      LAST MODIFIED: 11/08/96   BY: *G2HM* Ajit Deodhar   */
/* REVISION: 8.6      LAST MODIFIED: 11/12/96   BY: *J17Z* Suresh Nayak   */
/* REVISION: 8.6      LAST MODIFIED: 12/31/96   BY: *K03Y* Jean Miller    */
/* REVISION: 8.6      LAST MODIFIED: 02/20/97   BY: *H0SJ* Suresh Nayak   */
/* REVISION: 8.6      LAST MODIFIED: 05/15/97   BY: *G2MG* Ajit Deodhar   */
/* REVISION: 8.6      LAST MODIFIED: 09/05/97   BY: *G2PG* Niranjan Ranka */
/* REVISION: 8.6      LAST MODIFIED: 10/08/97   BY: *K0N5* Kieu Nguyen    */
/* REVISION: 8.6      LAST MODIFIED: 10/10/97   BY: *G2PV* Manish K.      */
/* REVISION: 8.6      LAST MODIFIED: 11/12/97   BY: *H1FB* Aruna Patil    */
/* REVISION: 8.6      LAST MODIFIED: 01/16/98   BY: *J25N* Aruna Patil    */
/* REVISION: 8.6      LAST MODIFIED: 01/23/98   BY: *J2BW* Nirav Parikh   */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane      */
/* REVISION: 8.6E     LAST MODIFIED: 05/09/98   BY: *L00Y* Jeff Wootton   */
/* Old ECO marker removed, but no ECO header exists *F739*                */
/* Old ECO marker removed, but no ECO header exists *F765*                */
/* Old ECO marker removed, but no ECO header exists *G035*                */
/* Old ECO marker removed, but no ECO header exists *G416*                */
/* Old ECO marker removed, but no ECO header exists *G429*                */
/* Old ECO marker removed, but no ECO header exists *G501*                */
/* Old ECO marker removed, but no ECO header exists *G530*                */
/* Old ECO marker removed, but no ECO header exists *H404*                */
/* REVISION: 8.6E     LAST MODIFIED: 07/06/98   BY: *L024* Sami Kureishy  */
/* REVISION: 8.6E     LAST MODIFIED: 08/20/98   BY: *L06M* Russ Witt      */
/* REVISION: 8.6E     LAST MODIFIED: 07/22/99   BY: *J3JM* Kedar Deherkar */
/* REVISION: 9.1      LAST MODIFIED: 10/01/99   BY: *N014* Patti Gaultney */
/* REVISION: 9.1      LAST MODIFIED: 09/08/99   BY: *N02P* Robert Jensen  */
/* REVISION: 9.1      LAST MODIFIED: 10/18/99   BY: *N049* Robert Jensen  */
/* REVISION: 9.1      LAST MODIFIED: 02/17/00   BY: *J3P9* Manish K.      */
/* REVISION: 9.1      LAST MODIFIED: 03/17/00   BY: *N08S* Robert Jensen  */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane */
/* REVISION: 9.1      LAST MODIFIED: 08/09/00   BY: *L12P* Rajesh Kini      */
/* REVISION: 9.1      LAST MODIFIED: 09/25/00   BY: *L121* Gurudev C        */
/* REVISION: 9.1      LAST MODIFIED: 10/10/00   BY: *N0W8* Mudit Mehta        */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.24.1.14.2.3 BY: Katie Hilbert    DATE: 04/01/01 ECO: *P002*    */
/* Revision: 1.24.1.17     BY: Russ Witt        DATE: 06/01/01 ECO: *P00J*    */
/* Revision: 1.24.1.18     BY: Steve Nugent     DATE: 07/09/01 ECO: *P007*    */
/* Revision: 1.24.1.19     BY: Hareesh V.       DATE: 07/18/01 ECO: *M1FD*    */
/* Revision: 1.24.1.20     BY: Jean Miller      DATE: 08/08/01 ECO: *M11Z*    */
/* Revision: 1.24.1.21     BY: Russ Witt        DATE: 09/21/01 ECO: *P01H*    */
/* Revision: 1.24.1.22     BY: Steve Nugent     DATE: 10/15/01 ECO: *P004*    */
/* Revision: 1.24.1.24     BY: Nikita Joshi     DATE: 01/07/01 ECO: *M1SQ*    */
/* $Revision: 1.24.1.25 $     BY: Ashish M.         DATE: 05/20/02 ECO: *P04J*   */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* CHANGES MADE TO THIS FILE COULD REQUIRE CHANGES TO RCRBRP1A.P WHICH BUILDS */
/* AN INTERNAL CIM FILE TO PENDING INVOICE MAINTENANCE.                       */

{mfdeclre.i}
{cxcustom.i "SOIVMTA2.P"}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE soivmta2_p_1 "Comments"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

define input parameter l_prev_um_conv like sod_um_conv no-undo.
define input parameter l_prev_um      like sod_um      no-undo.

define new shared variable ship_so like sod_nbr.
define new shared variable ship_line like sod_line.

define shared variable line like sod_line.
define shared variable mult_slspsn like mfc_logical no-undo.
define shared variable cmtindx like cmt_indx.
define shared variable sodcmmts like soc_lcmmts label {&soivmta2_p_1}.
define shared variable so_recno as recid.
define shared variable sod_recno as recid.
define shared variable clines as integer.
define shared variable ln_fmt like soc_ln_fmt.
define shared variable new_line like mfc_logical.
define shared variable tax_date like tax_effdate no-undo.
define shared variable old_site like sod_site.
define shared variable old_sod_site        like sod_site no-undo.
define shared variable undo_mta2 as logical.
define shared variable inv_data_changed like mfc_logical.
define shared variable soc_pc_line  like mfc_logical.
define shared variable so_db like dc_name.
define shared variable inv_db like dc_name.
define shared variable sonbr like sod_nbr.
define shared variable soline like sod_line.
define shared variable location like sod_loc.
define shared variable lotser like sod_serial.
define shared variable lotrf like sr_ref.
define shared variable prev_qty_chg like sod_qty_chg.
define shared variable prev_price like sod_price no-undo.
define shared variable prev_listpr like sod_list_pr no-undo.
define shared variable exch-rate like exr_rate.
define shared variable exch-rate2 like exr_rate2.
define shared variable discount as decimal.
define shared variable reprice_dtl like mfc_logical.
define shared variable trtotqty like tr_qty_chg no-undo.
define shared variable noentries as integer no-undo.
define shared variable new_order like mfc_logical.
define shared variable remote-base-curr like gl_base_curr.

define variable desc1 like pt_desc1.
define variable zone_to             like txz_tax_zone.
define variable zone_from           like txz_tax_zone.
define variable old_sod_loc as character.
define variable old_sod_serial as character.
define variable glvalid like mfc_logical.
define variable valid_acct like mfc_logical.
define variable err-flag as integer.
define variable upd_ok like mfc_logical.
define variable undo_taxpop like mfc_logical.
define variable l_changedb like mfc_logical no-undo.
define variable old_ref like tr_ref no-undo.
define variable prev_due like sod_due_date no-undo.
define variable prev_per like sod_per_date no-undo.
define variable sodstdcost like sod_std_cost no-undo.
define variable mc-error-number like msg_nbr no-undo.
define variable l_undotran      like mfc_logical no-undo.
define variable transtype as character initial "ISS-SO".
define variable edit_qty as decimal.
define variable ref as character.
define variable undotran as logical no-undo.
define variable ret-flag        as integer no-undo.
define variable pkg_code_alt like pt_part extent 7 no-undo.
define variable ord_mult_alt like sod_ord_mult extent 7 no-undo.
define variable charge_type_alt like cct_charge_type extent 7 no-undo.
define variable i as integer no-undo.
define variable old_pkg_code like sod_pkg_code no-undo.
define variable last-field as character no-undo.
define variable old_charge_type like cct_charge_type no-undo.
define variable v_charge_type like cct_charge_type no-undo.
define variable msgnbr as integer no-undo.
define variable chargeable like mfc_logical no-undo.
define variable c-alt-container as character format "x(20)" no-undo.
define variable c-std-pack as character format "x(12)" no-undo.
define variable c-charge-type as character format "x(12)" no-undo.
define variable this-is-so    as logical no-undo.
define variable l_old_fr_list like sod_fr_list no-undo.

define shared stream bi.
define shared frame bi.
/* FORM DEFINITION FOR HIDDEN FRAME BI */
{sobifrm.i}
FORM /*GUI*/  sod_det with frame bi width 80 THREE-D /*GUI*/.

/*IT WAS NECESSARY TO MOVE THIS DEFINITION OF SHARED FRAMES C AND */
/*D TO A LOCATION AFTER THE DEFS OF SHARED FRAME AND STREAM BI    */
/*BECAUSE IT DOES NOT BEHAVE CORRECTLY IN PROGRESS v7             */
define shared frame c.
define shared frame d.

define shared workfile wf-tr-hist
   field trsite like tr_site
   field trloc like tr_loc
   field trlotserial like tr_serial
   field trref like tr_ref
   field trqtychg like tr_qty_chg
   field trum like tr_um
   field trprice like tr_price.

/* VARIABLE DEFINITIONS FOR gpfile.i */
{gpfilev.i}

assign
   c-alt-container = getTermLabel("ALTERNATE_CONTAINER",20)
   c-std-pack      = getTermLabel("STD_PACK_QTY",12)
   c-charge-type   = getTermLabel("CHARGE_TYPE",12).


FORM /*GUI*/ 
   
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
sod_pkg_code    colon 20 label "Container Item"
   sod_ord_mult    colon 20
   sod_charge_type colon 20
   sod_alt_pkg     colon 20
 SKIP(.4)  /*GUI*/
with frame cont_pop overlay side-labels centered row 12 NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-cont_pop-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame cont_pop = F-cont_pop-title.
 RECT-FRAME-LABEL:HIDDEN in frame cont_pop = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame cont_pop =
  FRAME cont_pop:HEIGHT-PIXELS - RECT-FRAME:Y in frame cont_pop - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME cont_pop = FRAME cont_pop:WIDTH-CHARS - .5.  /*GUI*/


/* SET EXTERNAL LABELS */
setFrameLabels(frame cont_pop:handle).

FORM /*GUI*/ 
   
 RECT-FRAME       AT ROW 1.4 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
 SKIP(.1)  /*GUI*/
pkg_code_alt[1]
   pkg_code_alt[2]
   pkg_code_alt[3]
   pkg_code_alt[4]
   pkg_code_alt[5]
   pkg_code_alt[6]
   pkg_code_alt[7]
 SKIP(.4)  /*GUI*/
with frame alt overlay centered side-labels attr-space
 NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-alt-title AS CHARACTER.
 F-alt-title = (getFrameTitle("ALTERNATE_CONTAINERS",29)).
 RECT-FRAME-LABEL:SCREEN-VALUE in frame alt = F-alt-title.
 RECT-FRAME-LABEL:WIDTH-PIXELS in frame alt =
  FONT-TABLE:GET-TEXT-WIDTH-PIXELS(
  RECT-FRAME-LABEL:SCREEN-VALUE in frame alt + " ", RECT-FRAME-LABEL:FONT).
 RECT-FRAME:HEIGHT-PIXELS in frame alt =
  FRAME alt:HEIGHT-PIXELS - RECT-FRAME:Y in frame alt - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME alt = FRAME alt:WIDTH-CHARS - .5. /*GUI*/


/* SET EXTERNAL LABELS */
setFrameLabels(frame alt:handle).


FORM /*GUI*/ 
   
 RECT-FRAME       AT ROW 1.4 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
 SKIP(.1)  /*GUI*/
c-alt-container   at 8
   c-std-pack        at 28
   c-charge-type     at 42 skip(1)

   " 01."             at 3
   pkg_code_alt[1]    at 8
   ord_mult_alt[1]    at 30
   charge_type_alt[1] at 44 skip

   " 02."             at 3
   pkg_code_alt[2]    at 8
   ord_mult_alt[2]    at 30
   charge_type_alt[2] at 44 skip

   " 03."             at 3
   pkg_code_alt[3]    at 8
   ord_mult_alt[3]    at 30
   charge_type_alt[3] at 44 skip

   " 04."             at 3
   pkg_code_alt[4]    at 8
   ord_mult_alt[4]    at 30
   charge_type_alt[4] at 44 skip

   " 05."             at 3
   pkg_code_alt[5]    at 8
   ord_mult_alt[5]    at 30
   charge_type_alt[5] at 44 skip

   " 06."             at 3
   pkg_code_alt[6]    at 8
   ord_mult_alt[6]    at 30
   charge_type_alt[6] at 44 skip

   " 07."             at 3
   pkg_code_alt[7]    at 8
   ord_mult_alt[7]    at 30
   charge_type_alt[7] at 44 skip
 SKIP(.4)  /*GUI*/
with frame alt-clc overlay centered no-labels width 60
 NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-alt-clc-title AS CHARACTER.
 F-alt-clc-title = (getFrameTitle("ALTERNATE_CONTAINERS",29)).
 RECT-FRAME-LABEL:SCREEN-VALUE in frame alt-clc = F-alt-clc-title.
 RECT-FRAME-LABEL:WIDTH-PIXELS in frame alt-clc =
  FONT-TABLE:GET-TEXT-WIDTH-PIXELS(
  RECT-FRAME-LABEL:SCREEN-VALUE in frame alt-clc + " ", RECT-FRAME-LABEL:FONT).
 RECT-FRAME:HEIGHT-PIXELS in frame alt-clc =
  FRAME alt-clc:HEIGHT-PIXELS - RECT-FRAME:Y in frame alt-clc - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME alt-clc = FRAME alt-clc:WIDTH-CHARS - .5. /*GUI*/


/* SET EXTERNAL LABELS */
setFrameLabels(frame alt-clc:handle).

/* DETERMINE IF CONTAINER AND LINE CHARGES ARE ENABLED */
{cclc.i}

{gptxcdec.i}    /* DECLARATIONS FOR gptxcval.i */

/* Logistics Data Tables */
{lgivdefs.i &type="lg"}

loopa2:
do on error undo, leave:
/*GUI*/ if global-beam-me-up then undo, leave.


   /*DEFINE FORMS C AND D*/
   {xxsoivlnfm.i}
   
   view frame c.
   if ln_fmt then
      view frame d.

   find so_mstr where recid(so_mstr) = so_recno.
   find sod_det where recid(sod_det) = sod_recno.
   find first soc_ctrl no-lock.
   find pt_mstr where pt_part = sod_part no-lock no-error.

   this-is-so =  if so_fsm_type = "" then yes else no.

   if noentries = 1 then do:
      find first wf-tr-hist no-lock no-error.
      if available wf-tr-hist then
      assign
         sod_loc = trloc
         sod_serial =  trlotserial.

   end. /* noentries = 1 */

   assign
      prev_due = sod_due_date
      prev_per = sod_per_date
      old_sod_loc = sod_loc
      old_sod_serial = sod_serial.

   old_site = input frame bi sod_site.
   if sod_site <> old_site and  new_line = no
   then do:
      find si_mstr where si_site = old_site no-lock.
      if si_db <> so_db then do:
         {gprun.i ""gpalias3.p"" "(si_db, output err-flag)" }
/*GUI*/ if global-beam-me-up then undo, leave.

         assign
            sonbr  = sod_nbr
            soline = sod_line .

         /* ADDED INPUT PARAMETER no TO NOT EXECUTE MFSOFC01.I   */
         /* AND MFSOFC02.I WHEN CALLED FROM DETAIL LINE          */
         {gprun.i ""solndel.p"" "(input no)"}
/*GUI*/ if global-beam-me-up then undo, leave.


         /* Reset the db alias to the sales order database */
         {gprun.i ""gpalias3.p"" "(so_db, output err-flag)" }
/*GUI*/ if global-beam-me-up then undo, leave.

         sod_recno = recid(sod_det).
      end.
      else do:
         assign
            sonbr  = sod_nbr
            soline = sod_line.
         {gprun.i ""solndel1.p""}
/*GUI*/ if global-beam-me-up then undo, leave.

      end.
   end.
   find si_mstr where si_site = sod_site no-lock .

   /* REMEMBER, RMA RECEIPT LINES NEED SOME SIGNS SWITCHED */
   if ln_fmt then
   do:
      /* CONVERT CURRENCY FROM REMOTE BASE CURRENCY TO LOCAL BASE CURRENCY */
      {gprunp.i "mcpl" "p" "mc-curr-conv"
         "(input remote-base-curr,
           input base_curr,
           input exch-rate,
           input exch-rate2,
           input sod_std_cost,
           input false,
           output sodstdcost,
           output mc-error-number)"}

      if mc-error-number <> 0 then do:
         {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
      end.

      display
         sod_loc
         sod_serial
         sod_bo_chg        when (sod_fsm_type <> "RMA-RCT")
         (sod_bo_chg * -1) when (sod_fsm_type = "RMA-RCT")@ sod_bo_chg
         sodstdcost @ sod_std_cost
         sod_comm_pct[1]   when (sod_slspsn[1] <> "")
         sod_req_date
         sod_per_date
         sod_due_date
         sod_acct
         sod_sub
         sod_cc
         sod_project
         sod_dsc_acct
         sod_dsc_sub
         sod_dsc_cc
         sod_dsc_project
         sod_type          when (sod_qty_inv = 0 and sod_qty_ship = 0)
         sod_um_conv
         sod_fr_list
         sod_taxable
         sod_taxc
         sodcmmts
         sod_fix_pr
         sod_crt_int
         sod_pricing_dt
         sod_order_category
      with frame d.
   end.

   setc:
   do on error undo setc, retry setc:
/*GUI*/ if global-beam-me-up then undo, leave.


      undotran = no.

      /* LINE DETAIL */
      setb:
      do on error undo, retry on endkey undo , leave loopa2:
/*GUI*/ if global-beam-me-up then undo, leave.

         if ln_fmt then do:
            sodcmmts = sod_cmtindx <> 0 or (new_line and soc_lcmmts).

            display
               sodcmmts
            with frame d.

            l_old_fr_list = sod_fr_list.

            if not lgData then do:

               /* FOR RMA'S, PREVENT THE USER FROM UPDATING QTYS */
               if noentries > 1 then
               set
                  sod_comm_pct[1]   when (sod_slspsn[1] <> "")
                  sod_acct
                  sod_sub
                  sod_cc
                  sod_dsc_acct      when (new_line or reprice_dtl)
                  sod_dsc_sub       when (new_line or reprice_dtl)
                  sod_dsc_cc        when (new_line or reprice_dtl)
                  sod_order_category
                  sod_taxable
                  sod_taxc
                  sodcmmts
               with frame d.

               else
               set
                  sod_loc sod_serial
                  sod_std_cost    when (not available pt_mstr)
                  sod_comm_pct[1] when (sod_slspsn[1] <> "")
                  sod_acct
                  sod_sub
                  sod_cc
                  sod_project
                  sod_dsc_acct    when (new_line or reprice_dtl)
                  sod_dsc_sub     when (new_line or reprice_dtl)
                  sod_dsc_cc      when (new_line or reprice_dtl)
                  sod_dsc_project when (new_line or reprice_dtl)
                  sod_req_date
                  sod_due_date
                  sod_per_date
                  sod_fix_pr
                  sod_type        when (sod_qty_inv = 0 and sod_qty_ship = 0
                                        and sod_type = "")
                  sod_um_conv
                  sod_order_category
                  sod_fr_list
                  sod_taxable
                  sod_taxc
                  sodcmmts
               with frame d
               editing:
                  if frame-field = "sod_serial" and
                     input sod_loc <> global_loc then
                        global_loc = input sod_loc.
                  readkey.
                  apply lastkey.
               end.  /* END EDITING */

            end.
            else
               /* Update per the Logistics Data Inputs */
               run setLogLine.

           /* VALIDATE sod_order_category AGAINST GENERALIZED CODES */
            if sod_order_category <> "" then do:
               if not ({gpcode.v sod_order_category "line_category"})
               then do:
                  {pxmsg.i &MSGNUM=716 &ERRORLEVEL=3} /* VALUE MUST EXIST IN GENERALIZED CODES */
                  next-prompt sod_order_category with frame d.
                  undo, retry.
               end. /* IF NOT sod_order_category */
            end. /* IF sod_order_category <> "" */

            if so_secondary and not new_line
               and sod_per_date <> prev_per
               and (sod_btb_type = "03" or sod_btb_type = "02")
            then do:
               {pxmsg.i &MSGNUM=2825 &ERRORLEVEL=3}
               /* NO CHANGE IS ALLOWED ON EMT SO */
               if batchrun then undo, leave.
               next-prompt sod_per_date with frame d.
               undo, retry.
            end.

            if so_secondary and not new_line
               and sod_due_date <> prev_due
               and (sod_btb_type = "03" or sod_btb_type = "02")
            then do:
               {pxmsg.i &MSGNUM=2825 &ERRORLEVEL=3}
               /* NO CHANGE IS ALLOWED ON EMT SO */
               if batchrun then undo, leave.
               next-prompt sod_due_date with frame d.
               undo, retry.
            end.

            /* INITIALIZE SETTINGS */
            {gprunp.i "gpglvpl" "p" "initialize"}

            /* ACCT/SUB/CC/PROJ VALIDATION */
            {gprunp.i "gpglvpl" "p" "validate_fullcode"
               "(input  sod_acct,
                 input  sod_sub,
                 input  sod_cc,
                 input  sod_project,
                 output valid_acct)"}

            if valid_acct = no then do:
               if batchrun then undo, leave.
               next-prompt sod_acct with frame d.
               undo, retry.
            end.

            /* INITIALIZE SETTINGS */
            {gprunp.i "gpglvpl" "p" "initialize"}

            /* ACCT/SUB/CC/PROJ VALIDATION */
            {gprunp.i "gpglvpl" "p" "validate_fullcode"
               "(input  sod_dsc_acct,
                 input  sod_dsc_sub,
                 input  sod_dsc_cc,
                 input  sod_dsc_project,
                 output valid_acct)"}

            if valid_acct = no then do:
               if batchrun then undo, leave.
               next-prompt sod_dsc_acct with frame d.
               undo, retry.
            end.

            if so_curr <> base_curr then do:

               find ac_mstr where
                  ac_code = sod_acct
                  no-lock no-error.
               if available ac_mstr and ac_curr <> so_curr
                  and ac_curr <> base_curr then do:
                  {pxmsg.i &MSGNUM=134 &ERRORLEVEL=3}
                  /*ACCT CURR MUST BE TRANS OR BASE CURR*/
                  if batchrun then undo, leave.
                  next-prompt sod_acct with frame d.
                  undo, retry.
               end. /* end of if available ac_mstr and ac_curr <> so_curr */

               find ac_mstr where
                  ac_code = sod_dsc_acct
                  no-lock no-error.
               if available ac_mstr and ac_curr <> so_curr
                  and ac_curr <> base_curr then do:
                  {pxmsg.i &MSGNUM=134 &ERRORLEVEL=3}
                  /*ACCT CURR MUST BE TRANS OR BASE CURR*/
                  if batchrun then undo, leave.
                  next-prompt sod_dsc_acct with frame d.
                  undo, retry.
               end. /* end of if available ac_mstr and ac_curr <> so_curr */

            end. /* end of if so_curr <> base_curr                        */

            {gptxcval.i &code=sod_taxc &frame="d" &undo_label="setb"}

            /* VALIDATE FREIGHT LIST */
            if sod_fr_list <> "" then do:
               find fr_mstr where fr_list = sod_fr_list and
                  fr_site = sod_site and fr_curr = so_curr
                  no-lock no-error.
               if not available fr_mstr then
               find fr_mstr where fr_list = sod_fr_list and
                  fr_site = sod_site and fr_curr = base_curr no-lock
                  no-error.
               if not available fr_mstr then do:
                  /* FREIGHT LIST # NOT FOUND FOR SITE # CURRENCY */
                  {mfmsg03.i 670 4 sod_fr_list sod_site so_curr}
                  if batchrun then undo, leave.
                  next-prompt sod_fr_list with frame d.
                  undo, retry.
               end.
            end.

           if sod_fr_list <> l_old_fr_list
           then
              sod_manual_fr_list = yes.

            /* GET TAX MANAGEMENT DATA */
            if sod_taxable then do:      /* tax92 */

               if old_sod_site <> sod_site then do:
                  /* NEW SITE SPECIFIED; CHECK TAX ENVIRONMENT */
                  {pxmsg.i &MSGNUM=955 &ERRORLEVEL=2}
                  sod_tax_env = "".
               end.

               taxloop:
               do on error undo, retry:
/*GUI*/ if global-beam-me-up then undo, leave.


                  /* SUGGEST TAX ENVIRONMENT */
                  if sod_tax_env = "" then do:

                     /* LOAD DEFAULTS */
                     find ad_mstr where ad_addr = so_ship
                        no-lock no-error.
                     if available ad_mstr then
                        zone_to = ad_tax_zone.
                     else do:
                        find ad_mstr where ad_addr = so_cust
                           no-lock no-error.
                        if available(ad_mstr) then
                           zone_to = ad_tax_zone.
                     end.

                     /* CHECK FOR SITE ADDRESS */
                     find ad_mstr where ad_addr = sod_site no-lock
                        no-error.
                     if available(ad_mstr) then
                        zone_from = ad_tax_zone.
                     else do:
                        {pxmsg.i &MSGNUM=864 &ERRORLEVEL=2}
                        /* SITE ADDRESS DOES NOT EXIST */
                        zone_from = "".
                     end.

                     {gprun.i ""txtxeget.p"" "(input  zone_to,
                            input  zone_from,
                            input  so_taxc,
                            output sod_tax_env)"}
/*GUI*/ if global-beam-me-up then undo, leave.

                  end.  /* sod_tax_env */

                  /* No Pop Up Windows in batch processing */
                  if not lgData then do:
                     /* TAX MANAGEMENT TRANSACTION POP-UP. */
                     /* PARAMETERS ARE 5 FIELDS */
                     /* AND UPDATEABLE FLAGS, */
                     /* STARTING ROW, AND UNDO FLAG. */
                     /* CHANGED SIXTH AND EIGHTH INPUT PARAMETERS */
                     /* TO TRUE FROM FALSE                        */
                     {gprun.i ""txtrnpop.p""
                        "(input-output sod_tax_usage, input true,
                          input-output sod_tax_env,   input true,
                          input-output sod_taxc,      input true,
                          input-output sod_taxable,   input true,
                          input-output sod_tax_in,    input true,
                          input 13,
                          output undo_taxpop)"}
/*GUI*/ if global-beam-me-up then undo, leave.


                     if undo_taxpop then undo setb, retry.
                  end.
               end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* taxloop */
            end.   /* sod_taxable */
            
            /* Set the tax environment per the Logistics Data */
            if lgData then run ExtTax.

         end. /* if single line format */
         else do: /* multi line */
            /* VALIDATE TAXABLE AND TAXCODE */
            {gptxcval.i &code=sod_taxc
                        &frame="NO-FRAME" &undo_label="loopa2"}

            /* VALIDATE ACCOUNTS AND CC AS THEY DON'T GET */
            /* VALIDATED IN MULTI LINE FORMAT             */

            /* INITIALIZE SETTINGS */
            {gprunp.i "gpglvpl" "p" "initialize"}

            /* ACCT/SUB/CC/PROJ VALIDATION */
            {gprunp.i "gpglvpl" "p" "validate_fullcode"
               "(input  sod_acct,
                 input  sod_sub,
                 input  sod_cc,
                 input  sod_project,
                 output glvalid)"}
            if glvalid = no then  undo loopa2 , leave.

            /* ACCT/SUB/CC/PROJ VALIDATION */
            {gprunp.i "gpglvpl" "p" "validate_fullcode"
               "(input  sod_dsc_acct,
                 input  sod_dsc_sub,
                 input  sod_dsc_cc,
                 input  sod_dsc_project,
                 output glvalid)"}
            if glvalid = no then  undo loopa2 , leave.

            if so_curr <> base_curr then do:

               find ac_mstr where
                  ac_code = sod_acct
                  no-lock no-error.
               if available ac_mstr and ac_curr <> so_curr
                  and ac_curr <> base_curr then do:
                  {pxmsg.i &MSGNUM=134 &ERRORLEVEL=3}
                  /*ACCT CURR MUST BE TRANS OR BASE CURR*/
                  undo loopa2, leave.
               end. /* end of if available ac_mstr and ac_curr <> so_curr */

               find ac_mstr where
                  ac_code = sod_dsc_acct
                  no-lock no-error.
               if available ac_mstr and ac_curr <> so_curr
                  and ac_curr <> base_curr then do:
                  {pxmsg.i &MSGNUM=134 &ERRORLEVEL=3}
                  /*ACCT CURR MUST BE TRANS OR BASE CURR*/
                  undo loopa2, leave.
               end. /* end of if available ac_mstr and ac_curr <> so_curr */

            end. /* end of if so_curr <> base_curr                        */

         end.

         undo_mta2 = false.
      end.
/*GUI*/ if global-beam-me-up then undo, leave.
  /* setb */

      assign edit_qty = 0.
      if so_fsm_type = "RMA" then transtype = "ISS-RMA".

      if noentries = 0 then edit_qty = sod_qty_chg.

      /* WHILE MODIFYING AN EXISTING INVOICE  (noentries = 1)
      EDIT THE QUANTITY DEPENDING ON THE FOLLOWING CONDITIONS
      if any of Site/Location/Lotserial is changed then
      edit the full quantitiy.
      end.
      else
      if Quantity is changed then edit the difference.
      else do edit 0 quantity.
      end.
      */

      else if noentries = 1 then do:
         if sod_site <> old_site or
            sod_loc  <> old_sod_loc  or
            sod_serial <> old_sod_serial then
               edit_qty = sod_qty_chg.
         else do:
            if sod_qty_chg <> sod_qty_inv then
               edit_qty = sod_qty_chg - sod_qty_inv.
            else
               edit_qty = 0.
         end. /* else do: */
      end. /* if noentries = 1 */

      if sod_type = "" and can-find(pt_mstr where pt_part = sod_part)
      then do:

         ship_so   = sod_nbr.
         ship_line = sod_line.

         if noentries < 2 then do:
            find si_mstr where si_site = sod_site no-lock no-error.
            l_changedb = (si_db <> so_db).
            if l_changedb then
            do:
               {gprun.i ""gpalias2.p"" "(sod_site,output err-flag)" }
/*GUI*/ if global-beam-me-up then undo, leave.

            end.

            /* Logistics processing isn't shipping anything */
            if not lgData then do:
               if not new_line then
               do:

                   if (    (old_site       <> sod_site)
                        or (old_sod_loc    <> sod_loc)
                        or (old_sod_serial <> sod_serial)
                        or (old_ref        <> ref))
                       and sod_qty_inv <> 0
                  then do:

                     {gprun.i ""icedit.p"" "(input transtype,
                                             input old_site,
                                             input old_sod_loc,
                                             input sod_part,
                                             input old_sod_serial,
                                             input old_ref,
                                             input (-1 * prev_qty_chg *
                                                    l_prev_um_conv),
                                             input l_prev_um,
                                             """",
                                             """",
                                             output l_undotran)"}
/*GUI*/ if global-beam-me-up then undo, leave.

                  end. /* IF old_site <> sod_site ... */
                  else
                  if l_prev_um <> sod_um then
                  do:
                     {gprun.i ""icedit.p"" "(input transtype,
                                             input sod_site,
                                             input sod_loc,
                                             input sod_part,
                                             input sod_serial,
                                             input ref,
                                             input (sod_qty_chg *
                                                    sod_um_conv -
                                                    prev_qty_chg *
                                                    l_prev_um_conv),
                                             input sod_um,
                                             """",
                                             """",
                                             output l_undotran)"}
/*GUI*/ if global-beam-me-up then undo, leave.

                  end. /* ELSE IF L_PREV_UM <> SOD_UM */
               end. /* IF NOT NEW_LINE */

               /* CHECK TO SEE IF RESERVED LOCATION EXISTS */
               /* FOR OTHER CUSTOMERS--                    */
               run check-reserved-location.

               if ret-flag = 0 then do:
                  {pxmsg.i &MSGNUM=3346 &ERRORLEVEL=3}
                  /* THIS LOCATION RESERVED FOR ANOTHER CUSTOMER */
                  next-prompt sod_loc.
                  undotran = yes.
               end.
               else do:

                  if edit_qty <> 0
                  then do:

                     {gprun.i ""icedit.p""
                        "(input transtype,
                          input sod_site,
                          input sod_loc,
                          input sod_part,
                          input sod_serial,
                          input ref,
                          input edit_qty *  sod_um_conv,
                          input sod_um,
                          """",
                          """",
                          output undotran)"}
/*GUI*/ if global-beam-me-up then undo, leave.


                  end. /* IF edit_qty <> 0 */
               end.  /* ret-flag <> 0 */

            end. /* if not lgData */
            undotran = undotran or l_undotran.

            if l_changedb then
            do:
               {gprun.i ""gpalias3.p"" "(so_db,output err-flag)" }
/*GUI*/ if global-beam-me-up then undo, leave.

            end.
         end.

         do on error undo, leave on endkey undo, leave:
            if not lgData then do:
               message.
               message.
            end.
         end.

         undo_mta2 = undotran.

      end.

      if sod_type = "" and undotran and batchrun then undo, leave.
      if sod_type = "" and undotran then undo setc, retry setc.
      if sod_type <> "" then
      assign
         undo_mta2 = false
         undotran  = false.

      if using_container_charges and this-is-so then do:
         setcontainer:
       /* Prompt for rest of line information on single line screen */
         do on error undo, retry on endkey undo, leave setcontainer:
/*GUI*/ if global-beam-me-up then undo, leave.

            display
               sod_pkg_code
               sod_ord_mult
               sod_charge_type
               sod_alt_pkg
            with frame cont_pop.

            assign
               v_charge_type = ""
               last-field = ""
               old_pkg_code = sod_pkg_code
               old_charge_type = sod_charge_type.

            set
               sod_pkg_code
               sod_ord_mult
               sod_charge_type
               sod_alt_pkg
            with frame cont_pop editblk: editing:
               if frame-field <> "" then last-field = frame-field.
               readkey.
               apply lastkey.
               hide message.
               if (go-pending or (last-field <> frame-field))
               then do:
                  if go-pending then do:
                     if last-field = "sod_pkg_code" and
                        frame-field = "sod_pkg_code" then do:

                        if input sod_pkg_code = "" then
                           sod_charge_type = "".
                        else
                           if old_pkg_code <> input sod_pkg_code
                           then do:

                           run ValidateContainer (input (input sod_pkg_code),
                                                  output chargeable,
                                                  output v_charge_type,
                                                  output msgnbr).

                           if msgnbr > 0 then do:
                              run DisplayMessage (input msgnbr,
                                                  input 4).
                              /* ITEM HASN'T BEEN DEFINED AS A CONTAINER */
                              next-prompt sod_pkg_code
                              with frame cont_pop.
                              next editblk.
                           end. /*IF MSGNBR > 0*/

                           if chargeable then
                              run getChargeType
                                     (input (input sod_pkg_code),
                                      input (if sod_dock > "" then
                                                sod_dock else
                                             if sod_ship > "" then
                                                sod_ship else so_ship),
                                      input so_curr,
                                      input-output v_charge_type).
                              display v_charge_type @ sod_charge_type
                                 with frame cont_pop.
                        end. /* else if old_pkg_code */
                     end. /*IF LAST-FIELD = "SOD_PKG_CODE"*/

                     else if last-field = "sod_charge_type" and
                          frame-field = "sod_charge_type" and
                          old_charge_type <> input sod_charge_type
                          and input sod_charge_type > ""
                        then do:
                        run ValidateChargeType
                              (input (input sod_charge_type),
                               input yes,
                               output msgnbr).

                        if msgnbr > 0 then do:
                           run DisplayMessage (input msgnbr,
                                               input 4).
                                  /* NOT A VALID CHARGE TYPE */
                           next-prompt sod_charge_type
                           with frame cont_pop.
                           next editblk.
                        end.
                     end. /*ELSE IF*/
                  end. /* IF go-pending then do*/

                  else
                      if last-field = "sod_pkg_code" and
                      frame-field <> "sod_pkg_code" and
                      input sod_pkg_code > "" and
                      input sod_pkg_code <> old_pkg_code
                      then do:

                      run ValidateContainer
                             (input (input sod_pkg_code),
                              output chargeable,
                              output v_charge_type,
                              output msgnbr).

                      if msgnbr > 0 then do:
                         run DisplayMessage (input msgnbr,
                                             input 4).
                         /* ITEM HAS NOT BEEN DEFINED AS A CONTAINER */
                         next-prompt sod_pkg_code with frame cont_pop.
                         next editblk.
                      end. /*IF MSGNBR > 0*/

                      if chargeable then
                         run getChargeType
                                (input (input sod_pkg_code),
                                 input (if sod_dock > "" then
                                           sod_dock else
                                        if sod_ship > "" then
                                           sod_ship else so_ship),
                                 input so_curr,
                                 input-output v_charge_type).
                      display v_charge_type @ sod_charge_type
                         with frame cont_pop.
                      old_pkg_code = input sod_pkg_code.
                  end. /*if last-field = "sod_pkg_code"*/

                  else
                      if last-field = "sod_charge_type" and
                      frame-field <> "sod_charge_type" and
                      input sod_charge_type > "" and
                      input sod_charge_type <> old_charge_type
                     then do:
                     run ValidateChargeType
                            (input (input sod_charge_type),
                             input yes,
                             output msgnbr).

                     if msgnbr > 0 then do:
                        run DisplayMessage (input msgnbr,
                                            input 4).
                          /* NOT A VALID CHARGE TYPE */
                        next-prompt sod_charge_type
                           with frame cont_pop.
                        next editblk.
                     end.
                     old_charge_type = input sod_charge_type.
                  end.  /*if last-field = "sod_charge_type" */
               end. /*go-pending or (last-field <> frame-field))*/
            end. /*EDITBLK*/

            hide frame cont_pop no-pause.

            if sod_alt_pkg then do:
               {rcsomtac.i}
            end.
         end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /*Setcontainer*/
      end. /* IF USING_CONT_CHARGES */

      if using_line_charges and
         this-is-so then do:
         {gprunmo.i
             &program = ""rcsolcmt.p""
             &module = "ACL"
             &param = """(INPUT recid(so_mstr),
                          INPUT recid(sod_det))"""}
      end. /*IF USING_LINE_CHARGES */

   end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /*setc*/

   hide frame cont_pop no-pause.

   assign
      location = sod_loc
      lotser = sod_serial.
   /* DO NOT RUN SOSOMULS.P IF MULTI LOCATIONS WHERE USED */

   if noentries = 1 then
   do:
      if (available pt_mstr and pt_lot_ser = "L" and not new_line)
         and sod_type = ""
         and ((sod_qty_chg < prev_qty_chg) or
              (sod_list_pr <> prev_listpr))
         and not lgData
      then do:
         upd_ok = no.

         {gprun.i ""gpalias2.p"" "(sod_site,output err-flag)" }
/*GUI*/ if global-beam-me-up then undo, leave.


         {gprun.i ""sosomuls.p"" "(input sod_nbr,
                                   input sod_line,
                                   output old_sod_loc,
                                   output old_sod_serial,
                                   output old_ref,
                                   output upd_ok )" }
/*GUI*/ if global-beam-me-up then undo, leave.

         {gprun.i ""gpalias3.p"" "(so_db,output err-flag)" }
/*GUI*/ if global-beam-me-up then undo, leave.


         if not upd_ok and batchrun then undo, leave.
         if not upd_ok then undo, retry.

         /* WORKFILE FIELDS trloc, trlotserial, trref ASSIGNED WITH VALUES */
         /* ENTERED IN QUANTITY RETURN TO POP-UP                           */
         assign
            wf-tr-hist.trloc       = old_sod_loc
            wf-tr-hist.trlotserial = old_sod_serial
            wf-tr-hist.trref       = old_ref.

      end.
   end. /* noentries = 1 */
   {&SOIVMTA2-P-TAG1}

end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /*loopa2*/


/* New procedures for Logistics */
PROCEDURE ExtTax:
   define variable taxableamt as decimal no-undo initial 0.
   define variable l_taxenv like sod_tax_env no-undo.
   define variable l_taxc like sod_taxc no-undo.
   define variable ext_tax as logical no-undo.
   define variable hasTax as logical initial no no-undo.
   define variable err_status as integer no-undo.
   /* sod_taxable no longer set.  It is only used. */
   /* IF EXT TAX REQUIRED AND TAX DATA NOT PRESENT, OR */
   /* IF EXT TAX NOT REQUIRED AND TAX DATA PRESENT THEN LOG ERROR. */
   /* Setup the sod_det tax details to match the imported tax type */
   /* Make assignement based on log application -- add to header */
   {gprunmo.i &module = "LG"
      &program = "lgtaxenv.p"
      &param = """(input so_mstr.so_app_owner, output ext_tax,
                   output l_taxenv, output l_taxc)"""}


   /* If external taxes are enabled for this application, */
   /* Set the taxes up. */

   if ext_tax = yes then do:
      assign
         sod_det.sod_tax_env = l_taxenv
         sod_taxc = l_taxc
         sod_taxable = so_mstr.so_taxable
         sod_tax_in = no
         .
      if available(pt_mstr) then
         sod_taxable = sod_taxable and pt_mstr.pt_taxable.
      /* Get the total taxable amount for this line */
      for first lgil_lgdet where lgil_sod_line = sod_line no-lock:
         sod_tax_usage = lgil_sod_tax_usage.
      end.

      /* Delete any existing Invoice tx2d_dets for this line. */
      for each tx2d_det where tx2d_ref = sod_nbr and
            tx2d_nbr = "" and tx2d_line = sod_line and
            tx2d_tr_type = "13" exclusive-lock:
         delete tx2d_det.
      end.

      /* If qty changed, update the tax records */
      if sod_qty_chg > 0 then do:
         /* Delete any existing Sales Order tx2d_dets for this line. */
         for each tx2d_det where tx2d_ref = sod_nbr and
               tx2d_nbr = "" and tx2d_line = sod_line and
               tx2d_tr_type = "11" exclusive-lock:
            delete tx2d_det.
         end.
         
         /* For each tax line in the import, have logistics prepare */
         /* a tx2d_det record.  These records will be used as a */
         /* basis for the final tx2d_det tax records by txmeth03.p. */
         for each lgilx_lgdet where lgilx_tx2d_line = sod_line no-lock:
/*GUI*/ if global-beam-me-up then undo, leave.

            hasTax = yes.
            if sod_taxable then do:
               /* Note, price here is not per item, but for the line.*/
               {gprunmo.i &module ="LG"
                  &program="lgwrtx2d.p"
                  &param="""(
                       input '13',
                       input sod_nbr,
                       input '',
                       input sod_line,
                       input '',
                       input lgil_sod_price,
                       input lgilx_tx2d_cur_tax_amt,
                       input lgilx_tx2d_tax_type,
                       input sod_tax_usage,
                       input lgi_app_id,
                       input sod_due_date,
                       output err_status
                       )"""}

            end.
            else do:
               /* Tax entered for non-taxable item */
               {pxmsg.i &MSGNUM=3376 &ERRORLEVEL=4}
               leave.
            end.
         end.
/*GUI*/ if global-beam-me-up then undo, leave.

         if not hasTax and sod_taxable then do:
            /* No tax data for a taxable item */
            {pxmsg.i &MSGNUM=3377 &ERRORLEVEL=4}
         end.
      end.

   end.
END PROCEDURE.

PROCEDURE setLogLine:
   /* Set up the header data */
   for first lgi_lgmstr no-lock:
      if lgi_so_due_date <> date("") then
         sod_det.sod_due_date = lgi_so_due_date.
      if lgi_so_pricing_dt <> date("") then
         sod_pricing_dt = lgi_so_pricing_dt.
   end.
   /* Set up the line data */
   for first lgil_lgdet where lgil_sod_line = sod_line no-lock:
      if lgil_sod_project <> "" then sod_project = lgil_sod_project.
      if lgil_sod_cc <> "" then sod_cc = lgil_sod_cc.
      if lgil_sod_comm_pct[1] >= 0 or lgil_sod_comm_pct[2] >= 0 or
         lgil_sod_comm_pct[3] >= 0 or lgil_sod_comm_pct[4] >= 0
      then do:
         assign
            sod_comm_pct[1] =
            if lgil_sod_comm_pct[1] >= 0 then lgil_sod_comm_pct[1] else 0
            sod_comm_pct[2] =
            if lgil_sod_comm_pct[2] >= 0 then lgil_sod_comm_pct[2] else 0
            sod_comm_pct[3] =
            if lgil_sod_comm_pct[3] >= 0 then lgil_sod_comm_pct[3] else 0
            sod_comm_pct[4] =
            if lgil_sod_comm_pct[4] >= 0 then lgil_sod_comm_pct[4] else 0
            .
      end.
   end.
END PROCEDURE.


/*  DETERMINE IF LOC TO BE USED IS VALID        */
PROCEDURE check-reserved-location:

   ret-flag = 2.

   /* bypass checking SSM orders */
   if so_mstr.so_fsm_type = "" then do:
     {gprun.i ""sorlchk.p""
              "(input so_ship,
                input so_bill,
                input so_cust,
                input sod_det.sod_site,
                input sod_loc,
                output ret-flag)"}
/*GUI*/ if global-beam-me-up then undo, leave.

   end.

END PROCEDURE.

PROCEDURE DisplayMessage:
   define input parameter ip_msg_nbr as integer no-undo.
   define input parameter ip_error_level as integer no-undo.

   {pxmsg.i &MSGNUM=ip_msg_nbr &ERRORLEVEL=ip_error_level}

END PROCEDURE. /*DisplayMessage*/


PROCEDURE ValidateContainer:
   define input parameter ipContainer like ptc_part no-undo.
   define output parameter opChargable like mfc_logical no-undo.
   define output parameter opChargeType like cct_charge_type no-undo.
   define output parameter opMessageNumber as integer no-undo.

   assign
      opChargable = false
      opChargeType = ""
      opMessageNumber = 4447.
      /* ITEM HAS NOT BEEN DEFINED AS A CONTAINER*/

   for first ptc_det no-lock
      where
         ptc_part = ipContainer:
      assign
         opChargable = ptc_charge
         opMessageNumber = 0.
      if ptc_charge then opChargeType = ptc_charge_type.
   end.

END PROCEDURE. /* ValidateContainer*/

PROCEDURE getChargeType:
   define input parameter ipContainer like ptc_part no-undo.
   define input parameter ipShipTo like so_ship no-undo.
   define input parameter ipCurrency like so_curr no-undo.
   define input-output parameter ioChargeType like cct_charge_type.

   for first cclsc_mstr no-lock
      where
         cclsc_shipto = ipShipTo
      and cclsc_part = ipContainer
      and cclsc_curr = ipCurrency:
   end.
   if not available cclsc_mstr then
      for first cclsc_mstr no-lock
         where
            cclsc_shipto = ""
         and cclsc_part = ipContainer
         and cclsc_curr = ipCurrency:
   end.
   if available cclsc_mstr then
      ioChargeType = cclsc_charge_type.

END PROCEDURE. /*getChargeType*/

PROCEDURE ValidateChargeType:
   define input parameter ipContainer like ptc_part no-undo.
   define input parameter ipContainerType like mfc_logical no-undo.
   define output parameter opMessageNumber as integer no-undo.

   opMessageNumber = 4396. /* NOT A VALID CHARGE TYPE */

   for first cct_mstr no-lock
      where
         cct_charge_type = ipContainer
      and cct_container_type = ipContainerType:
      opMessageNumber = 0.
   end.

END PROCEDURE. /*ValidateChargeType*/
