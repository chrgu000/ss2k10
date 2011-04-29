/* adcsmt.p - CUSTOMER MAINTENANCE                                            */
/* Copyright 1986-2006 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* REVISION: 1.0      LAST MODIFIED: 05/12/86   BY: PML      */
/* REVISION: 6.0      LAST MODIFIED: 03/07/90   BY: pml *D001**/
/* REVISION: 6.0      LAST MODIFIED: 10/09/90   BY: MLB *D083**/
/* REVISION: 6.0      LAST MODIFIED: 10/17/90   BY: pml *Dxxx**/
/* REVISION: 6.0      LAST MODIFIED: 12/05/90   BY: MLB *D238**/
/* REVISION: 6.0      LAST MODIFIED: 12/13/90   BY: dld *D257**/
/* REVISION: 6.0      LAST MODIFIED: 02/14/91   BY: MLB *D349**/
/* REVISION: 6.0      LAST MODIFIED: 05/09/91   BY: MLV *D631**/
/* REVISION: 6.0      LAST MODIFIED: 07/22/91   BY: afs *D784**/
/* REVISION: 6.0      LAST MODIFIED: 08/13/91   BY: MLV *D825**/
/* REVISION: 7.0      LAST MODIFIED: 08/26/91   BY: pml *F008**/
/* REVISION: 7.0      LAST MODIFIED: 11/16/91   BY: pml *F048**/
/* REVISION: 7.0      LAST MODIFIED: 11/22/91   BY: afs *F056**/
/* REVISION: 7.0      LAST MODIFIED: 12/02/91   BY: afs *F039**/
/* REVISION: 6.0      LAST MODIFIED: 02/07/92   BY: MLV *F183**/
/* REVISION: 7.0      LAST MODIFIED: 03/18/92   BY: dld *F297**/
/* REVISION: 7.0      LAST MODIFIED: 04/09/92   BY: tjs *F337**/
/* REVISION: 7.0      LAST MODIFIED: 06/03/92   BY: afs *F578**/
/* REVISION: 7.0      LAST MODIFIED: 06/18/92   BY: tmd *F458**/
/* REVISION: 7.0      LAST MODIFIED: 06/30/92   BY: tjs *F698**/
/* REVISION: 7.3      LAST MODIFIED: 07/27/92   BY: mpp *G007**/
/* REVISION: 7.0      LAST MODIFIED: 08/14/92   BY: afs *F849**/
/* REVISION: 7.3      LAST MODIFIED: 09/24/92   BY: tjs *G035**/
/* REVISION: 7.3      LAST MODIFIED: 09/17/92   BY: mpp *G069**/
/* REVISION: 7.3      LAST MODIFIED: 10/30/92   BY: jcd *G256**/
/* REVISION: 7.3      LAST MODIFIED: 11/05/92   BY: mpp *G282**/
/* REVISION: 7.3      LAST MODIFIED: 12/14/92   BY: mpp *G441**/
/* REVISION: 7.3      LAST MODIFIED: 12/15/92   BY: bcm *G426**/
/* REVISION: 7.3      LAST MODIFIED: 01/12/93   by: jms *G535**/
/* REVISION: 7.3      LAST MODIFIED: 01/26/93   BY: bcm *G429**/
/* REVISION: 7.3      LAST MODIFIED: 02/08/93   BY: bcm *G653**/
/* REVISION: 7.3      LAST MODIFIED: 02/08/93   BY: afs *G648**/
/* REVISION: 7.3      LAST MODIFIED: 02/22/93   by: jms *G724**/
/* REVISION: 7.3      LAST MODIFIED: 02/23/93   by: bcm *G726**/
/* REVISION: 7.3      LAST MODIFIED: 03/16/93   by: bcm *G823* (rev only) */
/* REVISION: 7.3      LAST MODIFIED: 04/06/93   by: afs *G914*/
/* REVISION: 7.3      LAST MODIFIED: 06/22/93   by: cdt *GC58* (rev only) */
/* REVISION: 7.4      LAST MODIFIED: 09/20/93   by: dpm *H075*            */
/* REVISION: 7.4      LAST MODIFIED: 08/25/93   BY: tjs *H082**/
/* REVISION: 7.4      LAST MODIFIED: 10/15/93   BY: jjs *H181**/
/* REVISION: 7.4      LAST MODIFIED: 10/16/93   BY: cdt *H086**/
/* REVISION: 7.4      LAST MODIFIED: 10/08/93   BY: tjs *H081* (rev only) */
/* REVISION: 7.4      LAST MODIFIED: 04/08/94   by: dpm *GJ30**/
/* REVISION: 7.4      LAST MODIFIED: 09/11/94   by: slm *GM11**/
/* REVISION: 7.3      LAST MODIFIED: 09/21/94   by: jzs *GM54**/
/* REVISION: 7.2      LAST MODIFIED: 11/20/94   by: qzl *FT98**/
/* REVISION: 7.2      LAST MODIFIED: 01/12/95   BY: ais *F0C7**/
/* REVISION: 7.4      LAST MODIFIED: 02/23/95   BY: jzw *H0BM**/
/* REVISION: 8.5      LAST MODIFIED: 02/02/95   BY: jlf *J042**/
/* REVISION: 7.4      LAST MODIFIED: 08/01/95   BY: kjm *G0T1**/
/* REVISION: 7.4      LAST MODIFIED: 01/09/96   BY: rxm *G0YC**/
/* REVISION: 8.5      LAST MODIFIED: 03/15/96   BY: cdt *J0FK**/
/* REVISION: 8.5      LAST MODIFIED: 04/10/96   BY: *J04C* Markus Barone      */
/* REVISION: 8.5      LAST MODIFIED: 02/25/96   BY: cdt *J0KD**/
/* REVISION: 7.3      LAST MODIFIED: 07/31/96   BY: *G1Z4* Aruna P. Patil     */
/* REVISION: 8.5      LAST MODIFIED: 08/15/96   BY: *H0MC* Aruna P. Patil     */
/* REVISION: 8.5      LAST MODIFIED: 09/05/96   BY: *G2DL* Aruna P. Patil     */
/* REVISION: 8.6      LAST MODIFIED: 10/10/96   BY: svs *K007**/
/* REVISION: 8.6      LAST MODIFIED: 10/18/96   BY: jpm *K017**/
/* REVISION: 8.6      LAST MODIFIED: 10/31/96   BY: *H0N3* Suresh Nayak       */
/* REVISION: 8.6      LAST MODIFIED: 07/17/97   BY: *J1VT* Suresh Nayak       */
/* REVISION: 8.6E     LAST MODIFIED: 04/18/98   BY: *L00R* Adam Harris        */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan         */
/* REVISION: 8.6E     LAST MODIFIED: 06/17/98   BY: *L01H* Adam Harris        */
/* REVISION: 8.6E     LAST MODIFIED: 06/23/98   BY: *L01G* Robin McCarthy     */
/* REVISION: 8.6E     LAST MODIFIED: 06/26/98   BY: *L01N* Robin McCarthy     */
/* REVISION: 8.6E     LAST MODIFIED: 07/21/98   BY: *L04G* Robin McCarthy     */
/* REVISION: 9.0      LAST MODIFIED: 10/30/98   BY: *M00F* Radha Shankar      */
/* REVISION: 9.0      LAST MODIFIED: 11/24/98   BY: *M002* David Morris       */
/* REVISION: 9.0      LAST MODIFIED: 03/10/99   BY: *M0B3* Michael Amaladhas  */
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan         */
/* REVISION: 9.0      LAST MODIFIED: 03/23/99   BY: *J3C4* Satish Chavan      */
/* REVISION: 9.1      LAST MODIFIED: 10/01/99   BY: *N014* Robin McCarthy     */
/* REVISION: 9.1      LAST MODIFIED: 02/07/00   BY: *N03S* Hemanth Ebenezer   */
/* REVISION: 9.1      LAST MODIFIED: 02/07/00   BY: *N03T* Hemanth Ebenezer   */
/* REVISION: 9.1      LAST MODIFIED: 05/12/00   BY: *N0B1* David Morris       */
/* REVISION: 9.1      LAST MODIFIED: 05/18/00   BY: *L0VB* Manish K.          */
/* Revision: 1.37     LAST MODIFIED: 06/12/00   BY: *N0B9* Jack Rief          */
/* Revision: 1.38     LAST MODIFIED: 06/29/00   BY: *N059* Mugdha  Tambe      */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.39       BY: Katie Hilbert       DATE: 04/01/01  ECO: *P002*   */
/* Revision: 1.40       BY: Anil Sudhakaran     DATE: 04/09/01  ECO: *M0P4*   */
/* Revision: 1.41       BY: Russ Witt           DATE: 06/04/01  ECO: *P00J*   */
/* Revision: 1.42       BY: Ed van de Gevel     DATE: 12/03/01  ECO: *N16R*   */
/* Revision: 1.43       BY: Jean Miller         DATE: 04/08/02  ECO: *P056*   */
/* Revision: 1.44       BY: Rajiv Ramaiah       DATE: 10/16/02  ECO: *N1X6*   */
/* Revision: 1.46       BY: Paul Donnelly (SB)  DATE: 06/26/03  ECO: *Q00B*   */
/* Revision: 1.47       BY: Dorota Hohol        DATE: 08/27/03  ECO: *P0Z1*   */
/* Revision: 1.50       BY: Jyoti Thatte        DATE: 09/15/03  ECO: *P106*   */
/* Revision: 1.51       BY: Rajiv Ramaiah       DATE: 11/05/03  ECO: *N2M0*   */
/* Revision: 1.52       BY: Deepali Kotavadekar DATE: 11/12/03  ECO: *P17S*   */
/* Revision: 1.53       BY: Preeti Sattur       DATE: 03/03/04  ECO: *P1RR*   */
/* Revision: 1.54       BY: Binoy John          DATE: 10/19/04  ECO: *P2PY*   */
/* Revision: 1.55       BY: Binoy John          DATE: 11/16/04  ECO: *P2V9*   */
/* Revision: 1.55.1.1   BY: Shivaraman V.       DATE: 12/29/05  ECO: *P4DT* */
/* $Revision: 1.55.1.2 $  BY: Munira Savai       DATE: 05/24/06  ECO: *P4S9* */

/* $MODIFIED BY: softspeed Roger Xiao         DATE: 2007/11/26  ECO: *xp001*  */
/*-Revision end---------------------------------------------------------------*/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/
/*V8:ConvertMode=Maintenance                                                  */

/* DISPLAY TITLE */
{mfdtitle.i "1+ "}

{pxmaint.i}
{cxcustom.i "ADCSMT.P"}

{&ADCSMT-P-TAG2}
define new shared variable promo_old like cm_promo.
define new shared variable mult_slspsn like mfc_logical no-undo.
define new shared variable tax_recno as recid.
define new shared variable cm_recno as recid.
define new shared variable ad_recno as recid.
define new shared variable undo_adcsmtc as logical.
define new shared variable errfree like mfc_logical.
define new shared variable new_cmmstr   as logical no-undo.

define new shared frame a.
define new shared frame b.
define new shared frame b2.
define new shared frame f_apmcust.

define variable del-yn like mfc_logical.
define variable cmnbr like cm_addr.
define variable new_cust like mfc_logical no-undo.

define variable regen_add    like mfc_logical initial no.
define variable cust_node    like anx_node.
define variable yn like mfc_logical no-undo.

define variable reccm as recid.
define variable recad as recid.

define variable l_exit as logical.
define variable error_flag  like mfc_logical no-undo.
define variable err_mess_no like msg_nbr     no-undo.
define variable apm-ex-sub as character format "x(24)" no-undo.

define variable l_cm_addr    like cm_addr     no-undo.
define variable l_cm_bill    like cm_bill     no-undo.
define variable l_cm_class   like cm_class    no-undo.
define variable l_cm_region  like cm_region   no-undo.
define variable l_cm_site    like cm_site     no-undo.
define variable l_cm_slspsn  like cm_slspsn   extent 2    no-undo.
define variable l_cm_sort    like cm_sort     no-undo.
define variable l_cm_type    like cm_type     no-undo.
define variable l_cm_user1   like cm_user1    no-undo.
define variable l_cm_user2   like cm_user2    no-undo.
define variable l_ana_build  like mfc_logical initial no  no-undo.
define variable l_check      like mfc_logical initial no  no-undo.
define variable l_yn         like mfc_logical initial no  no-undo.
{&ADCSMT-P-TAG3}
{ppacdef.i &type="new shared"}

/* APM/API TEMP TABLE DEFINITIONS */
{ifttcmtp.i "new"}
{ifttdiv.i  "new"}
{ifttcmrf.i "new"}
{ifttcmdv.i "new"}
{ifttdvrl.i "new"}
{ifttcmdr.i "new"}
{ifttcmpf.i "new"}
{ifttcust.i "new"}

/* FRAME F_APMCUST DEFINITION*/
{adcsapm1.i}

{etvar.i &new="new"}

/* DECLARATIONS FOR gptxcval.i */
{gptxcdec.i}

{gpaud.i &uniq_num1 = 01  &uniq_num2 = 02
   &db_field = cm_mstr &db_field = cm_addr}
{gpaud.i &uniq_num1 = 03  &uniq_num2 = 04
   &db_field = ad_mstr &db_field = ad_addr}

/* DISPLAY SELECTION FORM */
{xxadcsmt02.i}

find first gl_ctrl where gl_domain = global_domain no-lock.

do transaction on error undo, retry:
   {pxrun.i &PROC = 'getAddressControl' &PROGRAM = 'adadxr.p'
      &PARAM   = "(buffer adc_ctrl)"
      &NOAPPERROR=true
      &CATCHERROR=true}
   recno = recid(adc_ctrl).
end. /* do transaction on error undo, retry: */

find first soc_ctrl where soc_domain = global_domain no-lock no-error.

/*@MODULE APM BEGIN */
if soc_apm then do:

   /* ENSURE TrM IS CONNECTED */
   /* TrM DATABASE IS NOT CONNECTED */
   {ifapmcon.i "6316" "return"}

   for first apm_ctrl where apm_domain = global_domain no-lock: end.

   if not available apm_ctrl then do:
      /* TrM CONTROL FILE NOT FOUND.  PLEASE CREATE USING APM */
      {pxmsg.i &MSGNUM=6323 &ERRORLEVEL={&APP-ERROR-RESULT}}
      pause.
      return.
   end. /* if not available apm_ctrl then do: */

   apm-ex-sub = "if/".
   /* LOAD VALID APM CUSTOMER TYPE RECORDS INTO TEMP TABLE TT_CMTP */
   {gprunex.i
      &module  = 'APM'
      &subdir  = apm-ex-sub
      &program = 'ifapm003.p'
      &params  = "(output error_flag,
                   output err_mess_no)"}
   if error_flag then do:
      {pxmsg.i &MSGNUM=err_mess_no &ERRORLEVEL={&APP-ERROR-RESULT}}
      pause.
      return.
   end. /* if error_flag then do: */

   /* LOAD APM DIVISION RECORDS INTO TEMP TABLE TT_DV */
   {gprunex.i
      &module  = 'APM'
      &subdir  = apm-ex-sub
      &program = 'ifapm004.p'
      &params  = "(output error_flag,
                   output err_mess_no)"}
   if error_flag then do:
      {pxmsg.i &MSGNUM=err_mess_no &ERRORLEVEL={&APP-ERROR-RESULT}}
      pause.
      return.
   end. /* if error_flag then do: */

   /* LOAD APM CUSTOMER REFERENCE VALIDATION RULES INTO TT_CMRF */
   {gprunex.i
      &module  = 'APM'
      &subdir  = apm-ex-sub
      &program = 'ifapm005.p'
      &params  = "(input 1,
                   input """",
                   input """",
                   input """",
                   output error_flag,
                   output err_mess_no)"}
   if error_flag then do:
      {pxmsg.i &MSGNUM=err_mess_no &ERRORLEVEL={&APP-ERROR-RESULT}}
      pause.
      return.
   end. /* if error_flag then do: */

   /* LOAD APM DIVISION RELATIONSHIP RECORDS INTO TT_DVRL */
   {gprunex.i
      &module  = 'APM'
      &subdir  = apm-ex-sub
      &program = 'ifapm010.p'
      &params  = "(output error_flag,
                   output err_mess_no)"}
   if error_flag then do:
      {pxmsg.i &MSGNUM=err_mess_no &ERRORLEVEL={&APP-ERROR-RESULT}}
      pause.
      return.
   end. /* if error_flag then do: */

   /* LOAD APM CUSTOMER PROFILE DETAILS INTO TEMP TABLE TT_CMPF */
   {gprunex.i
      &module  = 'APM'
      &subdir  = apm-ex-sub
      &program = 'ifapm013.p'
      &params  = "(output error_flag,
                   output err_mess_no)"}
   if error_flag then do:
      {pxmsg.i &MSGNUM=err_mess_no &ERRORLEVEL={&APP-ERROR-RESULT}}
      pause.
      return.
   end. /* if error_flag then do: */
end. /* if soc_apm then do: */

for each temp_inactive
   exclusive-lock:
   delete temp_inactive.
end. /* FOR EACH temp_inactive */

/* DISPLAY */
mainloop:
repeat on stop undo mainloop, leave mainloop:

   on window-close of current-window
      stop.

   innerloop:
   repeat:

      assign
        l_yn     = no
        new_cust = false.

      /* IF WE'VE ADDED A NEW CUSTOMER & AUTOGEN IS ON, ADD IT TO ANX */
      find first pic_ctrl where pic_domain = global_domain no-lock
      no-error.

      if available pic_ctrl then do:

         if pic_cust_regen and regen_add then do:
            {gprun.i ""adcsgen.p"" "(input ""9"", input cust_node)"}
            regen_add = no.
         end. /* if pic_cust_regen and regen_add then do: */

         if substring(pic__qadc01,1,1) = "Y" and l_ana_build then do:

            for each anx_det
               where anx_domain = global_domain
               and   anx_node = cust_node
               and   anx_type = "9"
            exclusive-lock:

               /* CREATING TEMP TABLE FOR INACTIVE NODES */
               if not anx_active
               then do:
                  create temp_inactive.
                  assign
                     temp_inactive_node = cust_node
                     temp_inactive_code = anx_code.
               end. /* IF not anx_active */

               delete anx_det.
            end. /* FOR EACH ANX_DET */

            {gprun.i ""adcsgen.p"" "(input ""9"", input cust_node)"}

            l_ana_build = no.

         end.

      end. /* IF AVAILABLE PIC_CTRL */

      assign
         reccm = recid(cm_mstr)
         recad = recid(ad_mstr).

      run p-upd-frameb
         (input-output reccm,
          input-output recad,
          output l_exit).

      find cm_mstr where recid(cm_mstr) = reccm no-lock no-error.

      find ad_mstr where recid(ad_mstr) = recad no-lock no-error.

      if l_exit
      then
         leave mainloop.

      do transaction:  /* Oracle lock problem */
         loopa:
         do with frame a on endkey undo, leave loopa:
            /* ADD/MOD/DELETE  */

            find ad_mstr
               where ad_domain = global_domain
                and  ad_addr = cmnbr
            exclusive-lock no-error.

            if not available ad_mstr then do:
               {pxrun.i &PROC = 'createAddress' &PROGRAM = 'adadxr.p'
                  &PARAM   = "(buffer ad_mstr,
                                  input cmnbr,
                                  input 'customer',
                                  input today)"
                  &NOAPPERROR=true
                  &CATCHERROR=true}
               new_cust = true.
               recno = recid(ad_mstr).
            end. /* if not available ad_mstr then do: */

            {pxrun.i &PROC = 'setModificationInfo' &PROGRAM = 'adadxr.p'
               &PARAM = "(buffer ad_mstr)"
               &NOAPPERROR=true
               &CATCHERROR=true}

            new_cmmstr = no.

            {pxrun.i &PROC = 'processRead' &PROGRAM = 'adcuxr.p'
               &PARAM = "(input ad_addr,
                             buffer cm_mstr,
                             input {&LOCK_FLAG},
                             input {&WAIT_FLAG} )"
               &NOAPPERROR=true
               &CATCHERROR=true}

            if return-value <> {&SUCCESS-RESULT} then do:
               /* ADDING NEW RECORD */
               {pxmsg.i &MSGNUM=1 &ERRORLEVEL={&INFORMATION-RESULT}}

               {pxrun.i &PROC = 'createCustomer' &PROGRAM = 'adcuxr.p'
                  &PARAM = "(buffer cm_mstr,
                                input cmnbr,
                                input ad_name)"
                  &NOAPPERROR=true
                  &CATCHERROR=true}

               new_cmmstr = yes.
               recno = recid(cm_mstr).

               {pxrun.i &PROC = 'createRole' &PROGRAM = 'adarxr.p'
                  &PARAM = "(buffer ls_mstr,
                                input cm_addr,
                                input 'customer')"
                  &NOAPPERROR=true
                  &CATCHERROR=true}

               recno = recid(ls_mstr).

               /* USED FOR LOGISTICS OWNED DATA ONLY.
                  DATA COMES IN THROUGH Q/LINQ, CIM.
                  LS_MSTR will be updated with the value of the owner */
               {mgqqapp.i "ls_app_owner"}

               if available gl_ctrl then do:
                  {pxrun.i &PROC = 'setGLDefaults' &PROGRAM = 'adcuxr.p'
                     &PARAM = "(buffer cm_mstr)"
                     &NOAPPERROR=true
                     &CATCHERROR=true}
               end. /* if available gl_ctrl then do: */

               regen_add = yes.     /* we have a record so we can add  */
               cust_node = cm_addr. /* this customer (node) to anx_det. */

            end. /* if not available cm_mstr then do: */

            if not regen_add then
            assign
               l_cm_addr      = cm_addr
               l_cm_bill      = cm_bill
               l_cm_class     = cm_class
               l_cm_region    = cm_region
               l_cm_site      = cm_site
               l_cm_slspsn[1] = cm_slspsn[1]
               l_cm_slspsn[2] = cm_slspsn[2]
               l_cm_sort      = cm_sort
               l_cm_type      = cm_type
               l_cm_user1     = cm_user1
               l_cm_user2     = cm_user2.

            promo_old = cm_promo.

            {pxrun.i &PROC = 'setModificationInfo' &PROGRAM = 'adcuxr.p'
               &PARAM = "(buffer cm_mstr)"
               &NOAPPERROR=true
               &CATCHERROR=true}

            {gpaud1.i &uniq_num1 = 01  &uniq_num2 = 02
               &db_file = cm_mstr &db_field = cm_addr}
            {gpaud1.i &uniq_num1 = 03  &uniq_num2 = 04
               &db_file = ad_mstr &db_field = ad_addr}

            /* DEFAULT MULTIPLE SALESPERSON FLAG FROM EXISTING RECORD */
            if cm_slspsn[2] <> "" or cm_slspsn[3] <> ""
            or cm_slspsn[4] <> "" then
               mult_slspsn = true.
            else if new_cust then
               mult_slspsn = true.
            else
               mult_slspsn = false.

            display
               cm_sort
               cm_type
               cm_region
               cm_slspsn[1]
               mult_slspsn
               cm_shipvia
               cm_resale
               cm_rmks
               cm_ar_acct
               cm_ar_sub
               cm_ar_cc
               cm_curr
               cm_lang
               cm_site
               cm_scurr when (et_print_dc)
            with frame b.

            del-yn = no.
            recno = recid(ad_mstr).

            ststatus = stline[2].
            status input ststatus.

            display
               cm_addr
               ad_name
               ad_line1 ad_line2 ad_line3
               ad_city ad_state ad_zip ad_format ad_country
               ad_ctry ad_date
               ad_attn ad_phone ad_ext ad_attn2 ad_phone2 ad_ext2 ad_fax
               ad_fax2 ad_county.

            set1:
            do on error undo, retry:

               set
                  ad_name
                  ad_line1 ad_line2 ad_line3
                  ad_city ad_state ad_zip ad_format
                  ad_ctry ad_county
                  ad_attn ad_phone ad_ext ad_fax
                  ad_attn2 ad_phone2 ad_ext2 ad_fax2 ad_date
               go-on (F5 CTRL-D).

               {pxrun.i &PROC = 'validateAddressFormat' &PROGRAM = 'adadxr.p'
                  &PARAM = "(input ad_format)"
                  &NOAPPERROR=true
                  &CATCHERROR=true}
               if return-value <> {&SUCCESS-RESULT} then do:
                  next-prompt ad_format.
                  undo.
               end. /* if return-value <> {&SUCCESS-RESULT} then do: */

               {pxrun.i &PROC = 'validateCountryCode' &PROGRAM = 'adadxr.p'
                  &PARAM = "(input ad_ctry)"
                  &NOAPPERROR=true
                  &CATCHERROR=true}
               if return-value <> {&SUCCESS-RESULT} then do:
                  next-prompt ad_ctry with frame a.
                  undo set1, retry.
               end. /* if return-value <> {&SUCCESS-RESULT} then do: */
               else do:

                  {pxrun.i &PROC='getCountryDescription' &PROGRAM='adctxr.p'
                     &PARAM = "(input ad_ctry,
                                output ad_country)"
                     &NOAPPERROR=true
                     &CATCHERROR=true}
                  if return-value = {&SUCCESS-RESULT} then do:
                     display ad_country with frame a.
                  end. /* if return-value = {&SUCCESS-RESULT} then do: */
               end. /* else do: */

               /* DELETE */
               if lastkey = keycode("F5") or
                  lastkey = keycode("CTRL-D")
                  /* Execute delete if "x" has been assigned to
                   * Batchdelete variable */
                  or input batchdelete = "x"
               then do:
                  del-yn = yes.
                  /* PLEASE CONFIRM DELETE */
                  {pxmsg.i &MSGNUM=11 &ERRORLEVEL={&INFORMATION-RESULT}
                     &CONFIRM=del-yn}
                  if del-yn = no then undo set1.
               end. /* then do: */
            end. /* do on error undo, retry: */

            if soc_apm
               and not del-yn
            then do:

               for first tt-cm where tt-cm_addr = cm_addr
               exclusive-lock: end.

               if not available tt-cm then do:
                  create tt-cm.
               end.

               /* UPDATE THE NEW/EXISTING RECORD WITH UPDATED DATA  */
               /* NOTE THAT THIS MUST BE MAINTAINED HERE DUE TO APM */
               /* ROUTINE (P-CALL-APM) BEING NEEDED FOR DELETION.   */
               assign
                  tt-cm_addr     = cm_addr
                  tt-cm_bill     = cm_bill
                  tt-cm_disc_pct = cm_disc_pct
                  tt-cm_promo    = cm_promo
                  tt-cm_sort     = cm_sort
                  tt-cm_attn     = ad_attn
                  tt-cm_city     = ad_city
                  tt-cm_country  = ad_country
                  tt-cm_ext      = ad_ext
                  tt-cm_fax      = ad_fax
                  tt-cm_line1    = ad_line1
                  tt-cm_line2    = ad_line2
                  tt-cm_line3    = ad_line3
                  tt-cm_name     = ad_name
                  tt-cm_phone    = ad_phone
                  tt-cm_state    = ad_state
                  tt-cm_zip      = ad_zip.
            end. /* if soc_apm */

            if del-yn then do:

               {pxrun.i &PROC = 'validateOpenSO' &PROGRAM = 'adcuxr.p'
                  &PARAM = "(input cm_addr)"
                  &NOAPPERROR=true
                  &CATCHERROR=true}
               if return-value <> {&SUCCESS-RESULT} then do:
                  next mainloop.
               end. /* if return-value <> {&SUCCESS-RESULT} then do: */

               {pxrun.i &PROC = 'validateOpenQuotes' &PROGRAM = 'adcuxr.p'
                  &PARAM = "(input cm_addr)"
                  &NOAPPERROR=true
                  &CATCHERROR=true}
               if return-value <> {&SUCCESS-RESULT} then do:
                  next mainloop.
               end. /* if return-value <> {&SUCCESS-RESULT} then do: */

               {pxrun.i &PROC = 'validateOpenAR' &PROGRAM = 'adcuxr.p'
                  &PARAM = "(input cm_addr)"
                  &NOAPPERROR=true
                  &CATCHERROR=true}
               if return-value <> {&SUCCESS-RESULT} then do:
                  next mainloop.
               end. /* if return-value <> {&SUCCESS-RESULT} then do: */

               {pxrun.i &PROC = 'validateSvcContracts' &PROGRAM = 'adcuxr.p'
                  &PARAM = "(input cm_addr)"
                  &NOAPPERROR=true
                  &CATCHERROR=true}
               if return-value <> {&SUCCESS-RESULT} then do:
                  next mainloop.
               end. /* if return-value <> {&SUCCESS-RESULT} then do: */

               {pxrun.i &PROC = 'validateSvcData' &PROGRAM = 'adcuxr.p'
                  &PARAM = "(input cm_addr)"
                  &NOAPPERROR=true
                  &CATCHERROR=true}
               if return-value <> {&SUCCESS-RESULT} then do:
                  next mainloop.
               end. /* if return-value <> {&SUCCESS-RESULT} then do: */

               {pxrun.i &PROC = 'validateEndUserData' &PROGRAM = 'adcuxr.p'
                  &PARAM = "(input cm_addr)"
                  &NOAPPERROR=true
                  &CATCHERROR=true}
               if return-value <> {&SUCCESS-RESULT} then do:
                  next mainloop.
               end. /* if return-value <> {&SUCCESS-RESULT} then do: */

               {pxrun.i &PROC = 'validateSRO' &PROGRAM = 'adcuxr.p'
                  &PARAM = "(input cm_addr)"
                  &NOAPPERROR=true
                  &CATCHERROR=true}
               if return-value <> {&SUCCESS-RESULT} then do:
                  next mainloop.
               end. /* if return-value <> {&SUCCESS-RESULT} then do: */

               {pxrun.i &PROC = 'validateInvoiceHistory' &PROGRAM = 'adcuxr.p'
                  &PARAM = "(input cm_addr,
                             output l_yn)"
                  &NOAPPERROR=true
                  &CATCHERROR=true}

               if not l_yn
               then
                  next mainloop.

               /* CHECK FOR PRM PROJECTS WITH THIS CUSTOMER */
               {pxrun.i &PROC = 'validateOpenPRJ' &PROGRAM = 'adcuxr.p'
                  &PARAM = "(input cm_addr)"
                  &NOAPPERROR=true
                  &CATCHERROR=true}
               if return-value <> {&SUCCESS-RESULT} then do:
                  next mainloop.
               end. /* if return-value <> {&SUCCESS-RESULT} then do: */

               /* CHECK FOR PRM INVOICE SCHEDULES FOR THIS CUSTOMER */
               {pxrun.i &PROC = 'validateInvSchedules' &PROGRAM = 'adcuxr.p'
                  &PARAM = "(input cm_addr)"
                  &NOAPPERROR=true
                  &CATCHERROR=true}
               if return-value <> {&SUCCESS-RESULT} then do:
                  next mainloop.
               end. /* if return-value <> {&SUCCESS-RESULT} then do: */

               /* DELETE USER MAINTAINED ls_mstr */

               {pxrun.i &PROC = 'deleteUserRoles' &PROGRAM = 'adarxr.p'
                  &PARAM = "(input ad_addr,
                                input 'customer')"
                  &NOAPPERROR=true
                  &CATCHERROR=true}

               {pxrun.i &PROC = 'deleteRole' &PROGRAM = 'adarxr.p'
                  &PARAM = "(input cm_addr,
                                input 'customer')"
                  &NOAPPERROR=true
                  &CATCHERROR=true}

               if not
                  {pxfunct.i
                     &FUNCTION = 'existAddressRole' &PROGRAM = 'adarxr.p'
                     &PARAM = " input cm_addr"}
               then do:

                  {pxrun.i &PROC = 'deleteAddress' &PROGRAM = 'adadxr.p'
                     &PARAM = "(buffer ad_mstr)"
                     &NOAPPERROR=true
                     &CATCHERROR=true}

               end. /* if not available ls_mstr then do: */

               {pxrun.i &PROC = 'deleteEndUserAndMore' &PROGRAM = 'adcuxr.p'
                  &PARAM = "(input cm_addr)"
                  &NOAPPERROR=true
                  &CATCHERROR=true}

               {pxrun.i &PROC = 'deleteShiptoReference' &PROGRAM = 'adstxr.p'
                  &PARAM = "(input cm_addr,
                             input 'customer')"
                  &NOAPPERROR=true
                  &CATCHERROR=true}

               {pxrun.i &PROC = 'deleteAnalysisCodes' &PROGRAM = 'gpacxr.p'
                  &PARAM = "(input cm_addr,
                             input '9')"
                  &NOAPPERROR=true
                  &CATCHERROR=true}

               /* DELETE BANK DETAIL RECORDS(csbd_det) IF THEY  */
               /* AREN'T BEING UTILIZED BY ANOTHER ADDRESS TYPE */
               /* OF THIS ADDRESS.                              */
               {gprun.i 'adcsbdd.p'
                  "(input cm_mstr.cm_addr,
                    input 'CUSTOMER')"}

               run p-call-apm
                  (input cm_promo,
                   input cm_addr,
                   input promo_old,
                   input del-yn).

               /* Delete any Reserved Locations */
               {pxrun.i &PROC='deleteReservedLocationsForCustomer'
                  &PROGRAM='adcuxr.p'
                  &PARAM="(input cm_mstr.cm_addr)"
                  &NOAPPERROR=true
                  &CATCHERROR=true}

               {pxrun.i &PROC = 'deleteCustomer' &PROGRAM = 'adcuxr.p'
                  &PARAM = "(buffer cm_mstr)"
                  &NOAPPERROR=true
                  &CATCHERROR=true}

               clear frame a.
               clear frame b.

               assign
                  l_check = yes
                  del-yn  = no.

               /* MESSAGE #22 - RECORD DELETED */
               {pxmsg.i &MSGNUM=22 &ERRORLEVEL={&INFORMATION-RESULT}}
               leave innerloop.

            end. /* if del-yn then do: */

            /* UPDATION OF END USER DETAILS WITH CORRESPONDING */
            /* ADDRESS MASTER DETAILS.                         */

            find first eu_mstr
               where eu_domain = global_domain
               and   eu_addr   = ad_addr
            exclusive-lock no-error.
            if available eu_mstr
            then do:
               assign
                  eu_name  = ad_name
                  eu_phone = ad_phone
                  eu_zip   = ad_zip.
               for each eud_det
                  where eud_domain = global_domain
                  and   eud_addr   = eu_addr
               exclusive-lock:
                  assign
                     eud_name  = ad_name
                     eud_phone = ad_phone.
               end. /* FOR EACH eud_det */
               release eud_det.
            end. /* IF AVAILABLE eu_mstr */
            release eu_mstr.

            status input.

            if cm_sort = "" then cm_sort = ad_mstr.ad_name.
            if ad_sort = "" then ad_sort = ad_mstr.ad_name.

            run p-call-apm
               (input cm_promo,
                input cm_addr,
                input promo_old,
                input del-yn).

         end. /*transaction*/
         /* END LOOP A  */

         if keyfunction(lastkey) = "END-ERROR" then
            next mainloop.

         /* Get Tax data */
         ad_recno = recid(ad_mstr).

         /* Updates to frame b moved to adcsmtp.p */
         assign
            cm_recno = recid (cm_mstr)
            ad_recno = recid (ad_mstr)
            errfree  = false.

         loopc:
         do on error undo, leave:
            {gprun.i ""xxadcsmtp.p""  }  /*xp001*/
            if not errfree then do:
               undo loopc, leave innerloop.
            end. /* if not errfree then do: */
         end. /* do on error undo, leave: */

         run p-call-apm
            (input cm_promo,
             input cm_addr,
             input promo_old,
             input del-yn).

         /* Input Customer Credit and Freight Data */
         assign
            cm_recno = recid(cm_mstr)
            ad_recno = recid(ad_mstr).

         {gprun.i ""adcsmtb.p""}

         /* MAINTAIN BANK ACCOUNTS; WITH 3 FRAME ROWS AND NO VALIDATION */
         {gprun.i ""adcsbdmt.p""
            "(input ad_recno,
              input 3,
              input false)"}

         if soc_apm then do:
            hide frame a no-pause.
            {gprun.i  ""adcsapm1.p"" "(input ad_addr)" }
            hide frame f_apmcust.
         end. /* if soc_apm then do: */

         {&ADCSMT-P-TAG1}
         leave innerloop.

      end. /* transaction */

   end. /*innerloop*/

   if (not regen_add
      and not l_check
      and (l_cm_addr      <> cm_addr
      or   l_cm_bill      <> cm_bill
      or   l_cm_class     <> cm_class
      or   l_cm_region    <> cm_region
      or   l_cm_site      <> cm_site
      or   l_cm_slspsn[1] <> cm_slspsn[1]
      or   l_cm_slspsn[2] <> cm_slspsn[2]
      or   l_cm_sort      <> cm_sort
      or   l_cm_type      <> cm_type
      or   l_cm_user1     <> cm_user1
      or   l_cm_user2     <> cm_user2))
   then
      assign
         l_ana_build = yes
         cust_node   = cm_addr.

   /* AUDIT TRAIL SECTION */
   {gpaud2.i &uniq_num1 = 01  &uniq_num2 = 02
      &db_file = cm_mstr &db_field = cm_addr &db_field1 = """"}
   {gpaud2.i &uniq_num1 = 03  &uniq_num2 = 04
      &db_file = ad_mstr &db_field = ad_addr &db_field1 = """"}

end. /*mainloop*/

{gpaud3.i &uniq_num1 = 01  &uniq_num2 = 02
   &db_file = cm_mstr &db_field = cm_addr}
{gpaud3.i &uniq_num1 = 03  &uniq_num2 = 04
   &db_file = ad_mstr &db_field = ad_addr}

status input.

/* ========================================================================== */
/* *************************** INTERNAL PROCEDURES ************************** */
/* ========================================================================== */

/*============================================================================*/
PROCEDURE p-call-apm:
/*------------------------------------------------------------------------------
 Purpose:     Call the appropriate external APM program to handle the condition.
 Parameters:
   input:  promo_flag  Promotion Flag
   input:  address     Customer Address
   input:  promo_old
   input:  del-yn      Delete Flag
 Notes: Oracle compile size we have to use this internal procedure to call APM
------------------------------------------------------------------------------*/

   define input parameter promo_flag like cm_promo.
   define input parameter address like cm_addr.
   define input parameter promo_old like cm_promo.
   define input parameter del-yn like mfc_logical.
   define variable apm-ex-prg as character format "x(10)" no-undo.
   define variable apm-ex-sub as character format "x(24)" no-undo.
   define variable error_flag  like mfc_logical no-undo.
   define variable err_mess_no like msg_nbr     no-undo.

   find first soc_ctrl where soc_domain = global_domain
   no-lock no-error.
   if del-yn then do:
      if soc_apm and (promo_old <> "" or promo_flag <> "") then do:
         /* Future logic will go here to determine subdirectory*/
         /* IFCUSTD.P REPLACED BY IFAPM052.P */

         apm-ex-prg = "ifapm052.p".
         apm-ex-sub = "if/".

         {gprunex.i
            &module   = 'APM'
            &subdir   = apm-ex-sub
            &program  = 'ifapm052.p'
            &params   = "(input address,
                                    output error_flag,
                                    output err_mess_no)"}
         if error_flag then do:
            {pxmsg.i &MSGNUM=err_mess_no &ERRORLEVEL={&APP-ERROR-RESULT}}
         end. /* if error_flag then do: */

      end. /* if soc_apm and (promo_old <> "" or promo_flag <> "") then do: */
   end. /* if del-yn then do: */
   else do:
      if soc_apm and (promo_old <> "" or promo_flag <> "") then do:
         for first tt-cm
            where tt-cm_addr = cm_mstr.cm_addr
         exclusive-lock:
            assign
               tt-cm_bill     = cm_mstr.cm_bill
               tt-cm_disc_pct = cm_mstr.cm_disc_pct
               tt-cm_promo    = cm_mstr.cm_promo
               tt-cm_sort     = cm_mstr.cm_sort.
         end. /* for first tt-cm exclusive-lock */

         /* Future logic will go here to determine subdirectory*/
         /* IFCUST.P REPLACED BY IFAPM051.P */

         apm-ex-prg = "ifapm051.p".
         apm-ex-sub = "if/".

         {gprunex.i
            &module   = 'APM'
            &subdir   = apm-ex-sub
            &program  = 'ifapm051.p'
            &params   = "(input address,
                                    output error_flag,
                                    output err_mess_no)"}
         if error_flag then do:
            {pxmsg.i &MSGNUM=err_mess_no &ERRORLEVEL={&APP-ERROR-RESULT}}
         end. /* if error_flag then do: */
      end. /* if soc_apm and (promo_old <> "" or promo_flag <> "") then do: */
   end. /* else do: */

END PROCEDURE. /* p-call-apm */

/*============================================================================*/
PROCEDURE p-upd-frameb:
/*------------------------------------------------------------------------------
 Purpose:     Logic to update frame b.
 Exceptions:  NONE
 Notes:
 History:
------------------------------------------------------------------------------*/

   define input-output parameter reccm as recid.
   define input-output parameter recad as recid.

   define output parameter l_exit as logical.

   find cm_mstr where recid(cm_mstr) = reccm no-lock no-error.

   find ad_mstr where recid(ad_mstr) = recad no-lock no-error.

   for first et_ctrl where et_domain = global_domain no-lock: end.

   assign l_exit = true.

   /* INITIALIZED recno FOR CORRECT SCROLLING BEHAVIOUR OF mfnp.i */
   recno = ?.

   do transaction with frame a on endkey undo, leave /*mainloop*/:

      view frame a.
      view frame b.

      /*Initialize batchdelete flag */
      batchdelete = "".

      prompt-for
         cm_mstr.cm_addr
         /* Prompt for batchdelete only during CIM */
         batchdelete no-label when (batchrun)
      editing:

         /* FIND NEXT/PREVIOUS RECORD */
         {mfnp.i cm_mstr cm_addr  " cm_mstr.cm_domain = global_domain and
         cm_addr "  cm_addr cm_addr cm_addr}

         if recno <> ? then do:

            find ad_mstr
               where ad_domain = global_domain
                and  ad_addr = cm_addr
            no-lock no-error.

            display
               cm_addr ad_name ad_line1 ad_line2 ad_line3
               ad_city ad_state ad_zip ad_format ad_country
               ad_ctry
               ad_attn ad_phone ad_ext ad_attn2 ad_phone2 ad_ext2
               ad_fax ad_fax2 ad_date
               ad_county.

            /* DEFAULT MULTIPLE SALESPERSON FLAG FROM EXISTING RECORD */
            if cm_slspsn[2] <> "" or cm_slspsn[3] <> ""
            or cm_slspsn[4] <> ""
            then
               mult_slspsn = true.
            else
               mult_slspsn = false.

            display
               cm_sort
               cm_type
               cm_region
               cm_slspsn[1]
               mult_slspsn
               cm_shipvia
               cm_resale
               cm_rmks
               cm_ar_acct
               cm_ar_sub
               cm_ar_cc
               cm_curr
               cm_lang
               cm_site
               cm_scurr when (et_print_dc)
            with frame b.

         end. /* if recno <> ? then do: */
      end. /* editing: */

      if input cm_addr = " " then do:
         {&ADCSMT-P-TAG4}
         {mfactrl.i "cmc_ctrl.cmc_domain = global_domain" "cmc_ctrl.cmc_domain"
         "ad_mstr.ad_domain = global_domain" cmc_ctrl cmc_nbr ad_mstr ad_addr
         cmnbr}
         {&ADCSMT-P-TAG5}
      end. /* if input cm_addr = " " then do: */

      if input cm_addr <> ""
      then
         if can-find(first ad_mstr
                        where ad_domain = global_domain
                        and   ad_addr   = input cm_addr
                        and   ad_type   = "c/s_bank")
         then do:

            /* ADDRESS ALREADY EXISTS WITH TYPE C/S_BANK. */
            {pxmsg.i &MSGNUM=6401 &ERRORLEVEL=3}

            next-prompt cm_addr.
            undo, retry.

         end. /* IF CAN-FIND(FIRST ad_mstr... */
         else
            cmnbr = input cm_addr.

      l_exit = false.

   end. /*transaction*/

   assign
      reccm = recid(cm_mstr)
      recad = recid(ad_mstr).

END PROCEDURE. /* p-upd-frameb */
