/* xxvnmt.p - SUPPLIER MAINTENANCE                                            */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.52 $                                                          */
/*V8:ConvertMode=Maintenance                                                  */
/* REVISION: 6.0      LAST MODIFIED: 10/09/90   BY: MLB *D083**/
/* REVISION: 6.0      LAST MODIFIED: 12/31/90   BY: MLB *D238**/
/* REVISION: 6.0      LAST MODIFIED: 04/19/91   BY: MLV *D549**/
/* REVISION: 6.0      LAST MODIFIED: 07/02/91   BY: MLV *D738**/
/* REVISION: 6.0      LAST MODIFIED: 08/09/91   BY: RAM *D820**/
/* REVISION: 7.0      LAST MODIFIED: 08/09/91   BY: MLV *F002**/
/* REVISION: 7.0      LAST MODIFIED: 11/15/91   BY: MLV *F037**/
/* REVISION: 7.0      LAST MODIFIED: 11/16/91   BY: pml *F048**/
/* REVISION: 6.0      LAST MODIFIED: 02/07/92   BY: MLV *F183**/
/* REVISION: 7.0      LAST MODIFIED: 03/02/92   BY: MLV *F238**/
/* REVISION: 7.0      LAST MODIFIED: 04/06/92   BY: tjs *F337**/
/* REVISION: 7.0      LAST MODIFIED: 04/15/92   BY: afs *F397**/
/* REVISION: 7.0      LAST MODIFIED: 06/29/92   BY: tjs *F698**/
/* REVISION: 7.0      LAST MODIFIED: 07/27/92   BY: mpp *G007**/
/* REVISION: 7.0      LAST MODIFIED: 08/11/92   BY: tjs *G027**/
/* REVISION: 7.3      LAST MODIFIED: 09/15/92   BY: MLV *G060**/
/* REVISION: 7.3      LAST MODIFIED: 09/17/92   BY: MPP *G069**/
/* REVISION: 7.3      LAST MODIFIED: 10/23/92   BY: jjs *G226**/
/* REVISION: 7.3      LAST MODIFIED: 10/30/92   BY: jcd *G256**/
/* REVISION: 7.3      LAST MODIFIED: 11/06/92   BY: mpp *G282**/
/* REVISION: 7.3      LAST MODIFIED: 12/14/92   BY: mpp *G441**/
/* REVISION: 7.3      LAST MODIFIED: 12/15/92   BY: bcm *G426**/
/* REVISION: 7.3      LAST MODIFIED: 01/12/93   BY: jms *G535**/
/* REVISION: 7.3      LAST MODIFIED: 02/22/93   by: jms *G724**/
/* REVISION: 7.3      LAST MODIFIED: 02/23/93   by: bcm *G726**/
/* REVISION: 7.4      LAST MODIFIED: 09/20/93   by: dpm *H075**/
/* REVISION: 7.4      LAST MODIFIED: 10/05/93   BY: tjs *H082**/
/* REVISION: 7.4      LAST MODIFIED: 10/15/93   BY: jjs *H181**/
/* REVISION: 7.4      LAST MODIFIED: 10/18/93   BY: cdt *H086**/
/* REVISION: 7.4      LAST MODIFIED: 09/11/94   BY: slm *GM11**/
/* REVISION: 7.4      LAST MODIFIED: 10/04/94   BY: rxm *GM87**/
/* REVISION: 7.4      LAST MODIFIED: 11/06/94   BY: ame *GO16**/
/* REVISION: 7.4      LAST MODIFIED: 02/23/95   BY: jzw *H0BM**/
/*                                   03/29/95   BY: dzn *F0PN**/
/* REVISION: 7.4      LAST MODIFIED: 05/26/95   BY: vrn *G0NJ**/
/* REVISION: 8.5      LAST MODIFIED: 03/15/96   BY: cdt *J0FK**/
/* REVISION: 8.5      LAST MODIFIED: 01/30/96   BY: *J0CV* Robert Wachowicz   */
/* REVISION: 8.5      LAST MODIFIED: 03/15/96   BY: cdt *J0KD**/
/* REVISION: 8.5      LAST MODIFIED: 08/15/96   BY: *H0MC* Aruna P. Patil     */
/* REVISION: 8.6      LAST MODIFIED: 09/03/96   BY: jzw *K008**/
/* REVISION: 8.6      LAST MODIFIED: 10/10/96   BY: svs *K007**/
/* REVISION: 8.6      LAST MODIFIED: 10/18/96   BY: jpm *K017**/
/* REVISION: 8.6      LAST MODIFIED: 10/31/96   BY: *H0N3* Suresh Nayak       */
/* REVISION: 8.6      LAST MODIFIED: 07/17/97   BY: *J1VT* Suresh Nayak       */
/* REVISION: 8.6      LAST MODIFIED: 06/24/97   BY: *K0DH* Arul Victoria      */
/* REVISION: 8.6      LAST MODIFIED: 12/26/97   BY: *J28R* Seema Varma        */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* Annasaheb Rahane   */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan         */
/* REVISION: 8.6E     LAST MODIFIED: 07/22/98   BY: *J2T2* Niranjan Ranka     */
/* REVISION: 8.6E     LAST MODIFIED: 08/12/98   BY: *J2W3* Surekha Joshi      */
/* REVISION: 8.6E     LAST MODIFIED: 08/19/98   BY: *L062* Steve Nugent       */
/* REVISION: 8.6E     LAST MODIFIED: 09/15/98   BY: *K1WX* Steve Nugent       */
/* REVISION: 9.0      LAST MODIFIED: 11/20/98   BY: *M002* Mayse Lai          */
/* REVISION: 9.0      LAST MODIFIED: 03/10/99   BY: *M0B3* Michael Amaladhas  */
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan         */
/* REVISION: 9.1      LAST MODIFIED: 10/01/99   BY: *N014* Brian Compton      */
/* REVISION: 9.1      LAST MODIFIED: 10/25/99   BY: *L0KQ* Michael Amaladhas  */
/* Revision: 1.28      BY: Jack Rief            DATE: 06/11/00  ECO: *N0B9*   */
/* Revision: 1.29      BY: Falguni Dalal        DATE: 07/21/00  ECO: *M0PQ*   */
/* Revision: 1.30      BY: Mudit Mehta          DATE: 09/22/00  ECO: *N0W2*   */
/* Revision: 1.30      BY: Katie Hilbert        DATE: 04/01/01  ECO: *P002*   */
/* Revision: 1.32      BY: Anitha Gopal         DATE: 20/11/01  ECO: *N168*   */
/* Revision: 1.33      BY: Anil Sudhakaran      DATE: 11/30/01  ECO: *M1F2*   */
/* Revision: 1.34      BY: Ed van de Gevel      DATE: 12/03/01  ECO: *N16R*   */
/* Revision: 1.35      BY: Ed van de Gevel      DATE: 04/16/02  ECO: *N1GP*   */
/* Revision: 1.36      BY: Luke Pokic           DATE: 05/24/02  ECO: *P03Z*   */
/* Revision: 1.37      BY: Jean Miller          DATE: 06/06/02  ECO: *P080*   */
/* Revision: 1.38      BY: Robin McCarthy       DATE: 07/15/02  ECO: *P0BJ*   */
/* Revision: 1.41      BY: Niall Shanahan       DATE: 10/22/02  ECO: *N15F*   */
/* Revision: 1.42      BY: Katie Hilbert        DATE: 01/06/03  ECO: *P0LN*   */
/* Revision: 1.44      BY: Paul Donnelly (SB)   DATE: 06/26/03  ECO: *Q00B*   */
/* Revision: 1.47      BY: Dorota Hohol         DATE: 08/27/03  ECO: *P11B*   */
/* Revision: 1.47      BY: Dorota Hohol         DATE: 09/01/03  ECO: *P0Z1*   */
/* Revision: 1.50      BY: Jyoti Thatte         DATE: 09/15/03  ECO: *P106*   */
/* Revision: 1.51      BY: Deepali Kotavadekar  DATE: 11/12/03  ECO: *P17S* */
/* $Revision: 1.52 $   BY: Geeta Kotian       DATE: 04/29/03 ECO: *P1ZN* */
/*111205.1 - add address columns to 66 character length.                     */
/*-Revision end---------------------------------------------------------------*/


/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/
/* ************************************************************************** */
/* Note: This code has been modified to run when called inside an MFG/PRO API */
/* method as well as from the MFG/PRO menu, using the global variable         */
/* c-application-mode to conditionally execute API- vs. UI-specific logic.    */
/* Before modifying the code, please review the MFG/PRO API Development Guide */
/* in the QAD Development Standards for specific API coding standards and     */
/* guidelines.                                                                */
/* ************************************************************************** */
/* DISPLAY TITLE */
{mfdtitle.i "111205.1"}

{mfaititl.i}

{cxcustom.i "ADVNMT.P"}
{pxmaint.i}

define new shared variable promo_old    like vd_promo.
define new shared variable tid_notice   as character format "x(1)"
                                        label "TID Notice".
define new shared variable ad_recno     as recid.
define new shared variable undo_adcsmtc as logical.
define new shared variable vd_recno     as recid.
define new shared variable errfree      like mfc_logical.

define new shared frame a.
define new shared frame b.

define variable del-yn     like mfc_logical.
define variable vdnbr      like vd_addr.
define variable apm-ex-prg as character format "x(10)"  no-undo.
define variable apm-ex-sub as character format "x(24)"  no-undo.
define variable emt-auto   like mfc_logical
                           label "Auto EMT Processing"  no-undo.
define variable db_nbr     as character format "x(16)"
                           label "DB Number"            no-undo.
{&ADVNMT-P-TAG1}
{&ADVNMT-P-TAG4}
define variable error_flag like mfc_logical             no-undo.
define variable error_nbr  like msg_nbr                 no-undo.
define variable use-log-acctg as logical                no-undo.

/* COMMON API CONSTANTS AND VARIABLES */
{mfaimfg.i}
define variable failureMessage as character no-undo.

/* SUPPLIER API TEMP-TABLES */
{advnit01.i}

if c-application-mode = "API" then do on error undo, return error:

   /* GET HANDLE OF API CONTROLLER */
   {gprun.i ""gpaigh.p""
      "(output ApiMethodHandle,
        output ApiProgramName,
        output ApiMethodName,
        output apiContextString)"}

   /* GET LOCAL VENDOR MASTER BUFFER */
   create ttSupplier.
   run getSupplierRecord in ApiMethodHandle
      (buffer ttSupplier).

   /* GET LOCAL ADDRESS MASTER TEMP-TABLE */
   run getAddress in ApiMethodHandle
      (output table ttAddress).
   /* GET THE ADDRESS MASTER FOR THE apiExternalKey */
   for first ttAddress
      where ttAddress.apiExternalKey = ttSupplier.apiExternalKey
        and ttAddress.type = "SUPPLIER":
   end.
   if not available ttAddress
   then do:
      /* DATA MISSING */
      {pxmsg.i &MSGNUM=4698 &ERRORLEVEL=4}
      return error.
   end.

   /* Set the Failure Message */
   {pxmsg.i
      &MSGNUM = 4699
      &ERRORLEVEL = 1
      &MSGBUFFER = failureMessage}

end.  /* If c-application-mode = "API" */
{gpaud.i &uniq_num1 = 01 &uniq_num2 = 02 }
{gpaud.i &uniq_num1 = 03 &uniq_num2 = 04 }

/* GET GL CONTROL FILE */
{gpvtegl.i}

/* Form definitions. */
{xxvnmt02.i}

find first soc_ctrl where soc_domain = global_domain no-lock no-error.
if soc_apm and c-application-mode <> "API" then do:
   /* CHECK IF TrM DB IS CONNECTED */
   {ifapmcon.i "6316" "pause. return"}
end. /* if soc_apm then do: */

/* VALIDATE IF LOGISTICS ACCOUNTING IS TURNED ON */
{gprun.i ""lactrl.p"" "(output use-log-acctg)"}

mainloop:
repeat:
   {&ADVNMT-P-TAG7}
   /* DO NOT RETRY WHEN PROCESSING API REQUEST */
   if retry and c-application-mode = "API" then
      return error.

   innerloop:
   repeat:
      /* DO NOT RETRY WHEN PROCESSING API REQUEST */
      if retry and c-application-mode = "API" then
         return error.

      if c-application-mode <> "API" then do:
         /* Initialize delete flag before each display of frame */
         batchdelete = "".

         view frame a.
         view frame b.

         newloop:
         do transaction with frame a on endkey undo, leave mainloop:

            view frame a.
            view frame b.

            prompt-for vd_mstr.vd_addr
               /* Prompt for the delete variable in the key frame at the
                * End of the key field/s only when batchrun is set to yes */
               batchdelete no-label when (batchrun)
               editing:

               /* FIND NEXT/PREVIOUS RECORD */
               {mfnp.i vd_mstr vd_addr  " vd_mstr.vd_domain = global_domain and
               vd_addr "  vd_addr vd_addr vd_addr}

               if recno <> ? then do:
                  find ad_mstr
                     where ad_domain = global_domain and
                           ad_addr = vd_addr
                  no-lock no-error.
                  display
                     vd_addr
                     ad_name
                     ad_line1
                     ad_line2
                     ad_line3
                     ad_city
                     ad_state
                     ad_zip
                     ad_format
                     ad_attn
                     ad_phone
                     ad_ext
                     ad_date
                     ad_country
                     ad_ctry
                     ad_county
                     ad_temp
                     ad_attn2
                     ad_phone2
                     ad_ext2
                     ad_fax
                     ad_fax2.

                  display
                     vd_sort
                     vd_ap_acct
                     vd_ap_sub
                     vd_ap_cc
                     vd_pur_acct
                     vd_pur_sub
                     vd_pur_cc
                     vd_shipvia
                     vd_rmks
                     vd_type
                  with frame b.

               end. /* if recno <> ? then do: */
            end. /* prompt-for */

            /* This needs to be duplicated to get a new #
               from a fresh appserver connection */
            if input vd_addr = "" then do:
               {&ADVNMT-P-TAG5}
               {mfactrl.i "vdc_ctrl.vdc_domain = global_domain"
               "vdc_ctrl.vdc_domain" "ad_mstr.ad_domain = global_domain"
               vdc_ctrl vdc_nbr ad_mstr ad_addr vdnbr}
               {&ADVNMT-P-TAG6}
               vdnbr = string(integer(vdnbr),"99999999").
            end. /* if input vd_addr = "" then do: */

            if input vd_addr <> ""
            then
               if can-find(first ad_mstr
                        where ad_domain = global_domain
                        and   ad_addr   = input vd_addr
                        and   ad_type   = "c/s_bank")
               then do:

                  /* ADDRESS ALREADY EXISTS WITH TYPE C/S_BANK. */
                  {pxmsg.i &MSGNUM=6401 &ERRORLEVEL=3}

                  next-prompt vd_addr.
                  undo, retry.

               end. /* IF CAN-FIND(FIRST ad_mstr... */
               else
                  vdnbr = input vd_addr.

         end. /*newloop */
      end.  /* If c-application-mode <> "API" */
      else do:  /* C-application-mode = "API" */

         if ttSupplier.addr = '' or
            ttSupplier.addr = ?
         then do transaction:
            {mfactrl.i "vdc_ctrl.vdc_domain = global_domain"
            "vdc_ctrl.vdc_domain" "ad_mstr.ad_domain = global_domain" vdc_ctrl
            vdc_nbr ad_mstr ad_addr vdnbr}
            vdnbr = string(integer(vdnbr),"99999999").
            /* store the new supplier number in the Temp Tables */
            assign
               ttSupplier.addr = vdnbr
               ttAddress.addr = vdnbr.
            /* Write the new supplier number to the controller tt */
            run setSupplierRecord in apiMethodHandle
               (buffer ttSupplier).
         end. /* transaction */
         assign
            {mfaiset.i vdnbr ttSupplier.addr}
            .
      end.  /* else c-application-mode = "API" */

      do transaction:  /* Oracle lock problem */
         loopa:
         do with frame a on endkey undo, leave loopa:

            /* ADD/MOD/DELETE  */
            {pxrun.i &PROC='processRead' &PROGRAM='adadxr.p'
                     &PARAM="(input vdnbr,
                              buffer ad_mstr,
                              input {&LOCK_FLAG},
                              input {&WAIT_FLAG})"
                     &NOAPPERROR=true
                     &CATCHERROR=true}

            if not available ad_mstr then do:
               {pxrun.i &PROC='createAddress' &PROGRAM='adadxr.p'
                  &PARAM="(buffer ad_mstr,
                           input vdnbr,
                           input 'supplier',
                           input today)"
                  &NOAPPERROR=true
                  &CATCHERROR=true}
            end.

           {pxrun.i &PROC = 'setModificationInfo' &PROGRAM = 'adadxr.p'
               &PARAM = "(buffer ad_mstr)"
               &NOAPPERROR=true
               &CATCHERROR=true}

           {pxrun.i &PROC='processRead' &PROGRAM='adsuxr.p'
              &PARAM="(input ad_addr,
                       buffer vd_mstr,
                       input {&LOCK_FLAG},
                       input {&WAIT_FLAG})"
              &NOAPPERROR=true
              &CATCHERROR=true}

            if return-value <> {&SUCCESS-RESULT} then do:
               /* ADDING NEW RECORD */
               {pxmsg.i &MSGNUM=1 &ERRORLEVEL={&INFORMATION-RESULT}}
               {&ADVNMT-P-TAG8}
               {pxrun.i &PROC='createSupplier' &PROGRAM='adsuxr.p'
                        &PARAM="(input vdnbr,
                                 buffer vd_mstr)"
                        &NOAPPERROR=true
                        &CATCHERROR=true}

               /*CHECK IF ERS IS ENABLED, IF SO CREATE RECORD FOR SUPPLIER */
               if {pxfunct.i &FUNCTION='isERSEnabled' &PROGRAM='aperxr.p'
                             &PARAM="(input vd_addr)"}
               then do:

                  {pxrun.i &PROC='createERSSupplier' &PROGRAM='aperxr.p'
                     &PARAM="(buffer ers_mstr,
                              input vd_addr)"
                     &NOAPPERROR=true
                     &CATCHERROR=true}
               end.

               {pxrun.i &PROC='setDefaultAccountFields' &PROGRAM='adsuxr.p'
                  &PARAM="(buffer vd_mstr)"
                  &NOAPPERROR=true
                  &CATCHERROR=true}

               {pxrun.i &PROC='setDefaultAccountsPayableFields'
                  &PROGRAM='adsuxr.p'
                  &PARAM="(buffer vd_mstr)"
                  &NOAPPERROR=true
                  &CATCHERROR=true}

               {pxrun.i &PROC='createRole' &PROGRAM='adarxr.p'
                  &PARAM="(buffer ls_mstr,
                              input vd_addr,
                              input 'supplier')"
                  &NOAPPERROR=true
                  &CATCHERROR=true}

            end. /* if not available vd_mstr then do: */

            promo_old = vd_promo.

            /* STORE MODIFY DATE AND USERID */
            {pxrun.i &PROC='setModificationInfo' &PROGRAM='adsuxr.p'
               &PARAM="(buffer vd_mstr)"
               &NOAPPERROR=true
               &CATCHERROR=true}

            {gpaud1.i &uniq_num1 = 01 &uniq_num2 = 02  &db_file=vd_mstr}
            {gpaud1.i &uniq_num1 = 03 &uniq_num2 = 04  &db_file=ad_mstr}

            if c-application-mode <> "API" then
               display
                  vd_sort
                  vd_ap_acct
                  vd_ap_sub
                  vd_ap_cc
                  vd_pur_acct
                  vd_pur_sub
                  vd_pur_cc
                  vd_shipvia
                  vd_rmks
                  vd_type
               with frame b.

            assign
               del-yn   = no
               recno    = recid(vd_mstr)
               ststatus = stline[2].

            status input ststatus.

            if c-application-mode <> "API" then
               display
                  vd_addr
                  ad_temp
                  ad_name
                  ad_line1
                  ad_line2
                  ad_line3
                  ad_city
                  ad_state
                  ad_zip
                  ad_format
                  ad_date
                  ad_country
                  ad_ctry
                  ad_county
                  ad_attn
                  ad_phone
                  ad_ext
                  ad_fax
                  ad_attn2
                  ad_phone2
                  ad_ext2
                  ad_fax2.

            set1:
            do on error undo, retry:
               if c-application-mode <> "API" then
                  set
                     ad_temp
                     ad_name
                     ad_line1
                     ad_line2
                     ad_line3
                     ad_city
                     ad_state
                     ad_zip
                     ad_format
                     ad_ctry
                     ad_county
                     ad_attn
                     ad_phone
                     ad_ext
                     ad_fax
                     ad_attn2
                     ad_phone2
                     ad_ext2
                     ad_fax2
                     ad_date
                     go-on (F5 CTRL-D).
               else do:  /* If c-application-mode = "API" */
                  /* Assign the standard Address Details*/
                  {advnadvl.i &TABLE = ad_mstr}
               end. /* c-application-mode = 'API' */

               {pxrun.i &PROC='validateAddressFormat' &PROGRAM='adadxr.p'
                  &PARAM="(input ad_format)"
                  &NOAPPERROR=true
                  &CATCHERROR=true}

               if return-value <> {&SUCCESS-RESULT} then do:
                  if c-application-mode = "API" then
                     undo mainloop, return error.
                  else do:
                     next-prompt ad_format.
                     undo.
                  end. /* if c-appl...*/
               end. /* if return-value <> {&SUCCESS-RESULT} */

               {pxrun.i &PROC='validateCountryCode' &PROGRAM='adadxr.p'
                  &PARAM="(input ad_ctry)"
                  &NOAPPERROR=true
                  &CATCHERROR=true}

               if return-value <> {&SUCCESS-RESULT} then do:
                  if c-application-mode = "API" then do:
                     undo mainloop, return error.
                  end.
                  else do:
                     next-prompt ad_ctry with frame a.
                     undo set1, retry.
                  end. /* if c-appl...*/
               end. /* if return-value <> {&SUCCESS-RESULT} */
               else do:
                  {pxrun.i &PROC='getCountryDescription' &PROGRAM='adctxr.p'
                     &PARAM="(input ad_ctry,
                              output ad_country)"
                     &NOAPPERROR=true
                     &CATCHERROR=true}

                  if return-value = {&SUCCESS-RESULT}
                     and c-application-mode <> "API"
                  then do:
                     display ad_country with frame a.
                  end. /* if available ctry_mstr then do: */
               end. /* else do: */

               /* DELETE */
               if lastkey = keycode("F5") or lastkey = keycode("CTRL-D")
               /* Delete to be executed if batchdelete is set to "x" */
               or input batchdelete = "x"
               then do:
                  del-yn = yes.
                  /* PLEASE CONFIRM DELETE */
                  {pxmsg.i &MSGNUM=11 &ERRORLEVEL={&INFORMATION-RESULT}
                           &CONFIRM=del-yn}
                  if del-yn = no then undo set1.

               end. /* then do: */
            end. /* set1 */

            if del-yn then do:

               /* CHECK FOR OPEN PURCHASE ORDERS */
               {pxrun.i &PROC='checkForOpenSupplierPO' &PROGRAM='popoxr.p'
                  &PARAM="(input vd_addr)"
                  &NOAPPERROR=true
                  &CATCHERROR=true}
               if return-value <> {&SUCCESS-RESULT} then do:
                  if c-application-mode = "API" then
                     undo mainloop, return error.
                  else do:
                     bell.
                     next mainloop.
                  end.  /* if c-app.. */
               end.  /* if return-value.. */

               /* CHECK FOR OPEN INVOICES/CHECKS */
               {pxrun.i &PROC='checkForOpenSupplierRecords' &PROGRAM='apapxr.p'
                  &PARAM="(input vd_mstr.vd_addr)"
                  &NOAPPERROR=true
                  &CATCHERROR=true}

               if return-value <> {&SUCCESS-RESULT} then do:
                  if c-application-mode = "API" then
                     undo mainloop, return error.
                  else
                     next mainloop.
               end.

               if use-log-acctg then do:

                  /* VALIDATE IF THIS SUPPLIER CAN BE DELETED */
                  {gprunmo.i &module = "LA" &program = "lavndel.p"
                             &param  = """(input vd_mstr.vd_addr,
                                          output del-yn)"""}

                  if del-yn = no then next mainloop.

               end.

               /* DELETE USER MAINTAINED ls_mstr */
               /* DELETE LIST MASTER */
               {pxrun.i &PROC='deleteUserRoles' &PROGRAM='adarxr.p'
                  &PARAM="(input vd_addr,
                           input 'supplier')"
                  &NOAPPERROR=true
                  &CATCHERROR=true}

               {&ADVNMT-P-TAG3}
               /* DELETE LIST MASTER */
               {pxrun.i &PROC='deleteRole' &PROGRAM='adarxr.p'
                  &PARAM="(input vd_addr,
                           input 'supplier')"
                  &NOAPPERROR=true
                  &CATCHERROR=true}

               /* Moved csbd_det deletion to subroutine adcsbdd.p */

               /* DELETE BANK DETAIL RECORDS(csbd_det) IF THEY  */
               /* AREN'T BEING UTILIZED BY ANOTHER ADDRESS TYPE */
               /* OF THIS ADDRESS.                              */

               {gprun.i 'adcsbdd.p' "(input vd_mstr.vd_addr, input 'SUPPLIER')"}

               /* DELETE ADDRESS MASTER */
               if not {pxfunct.i &FUNCTION='existAddressRole' &PROGRAM='adarxr.p'
                  &PARAM="input vd_addr" } then do:

                  /* DELETE EDI SHIP IDs FOR THIS ADDRESS */
                  {pxrun.i &PROC='deleteAddress' &PROGRAM='adadxr.p'
                     &PARAM="(buffer ad_mstr)"
                     &NOAPPERROR=true
                     &CATCHERROR=true}

               end. /* existAddressRole */

               /*DELETE ERS MASTER*/
               {pxrun.i &PROC='deleteERSSupplier' &PROGRAM='aperxr.p'
                  &PARAM="(input vd_addr)"
                  &NOAPPERROR=true
                  &CATCHERROR=true}

               if soc_apm and
                  (promo_old <> "" or vd_promo <> "") then do:
                  /* Future logic will go here to determine subdirectory*/
                  assign
                     apm-ex-prg = "ifvendd.p".
                  apm-ex-sub = "if/".
                  {gprunex.i
                     &module   = 'APM'
                     &subdir   = apm-ex-sub
                     &program  = 'ifapm058.p'
                     &params   = "(input vd_mstr.vd_addr,
                                   output error_flag,
                                   output error_nbr)" }
                  if error_flag then do:
                     /* ERROR OCCURRED UPDATING APM */
                     {pxmsg.i &MSGNUM=error_nbr
                              &ERRORLEVEL={&APP-ERROR-NO-REENTER-RESULT}}
                     undo.
                  end. /* if error_flag then do: */
               end. /* (promo_old <> "" or vd_promo <> "") then do: */

               /* DELETE SUPPLIER PERFORMANCE E-MAIL/DB NUMBER QAD_WKFL */
               /* IF IN EXISTENCE                                       */
               {pxrun.i &PROC='deleteWorkFiles' &PROGRAM='adsuxr.p'
                        &PARAM="(input vd_addr)"
                        &NOAPPERROR=true
                        &CATCHERROR=true}

               if vd_remit <> ""
               then do:

                  /* CHECK IF THIS REMIT TO BELONGS TO ANY OTHER SUPPLIER*/
                  {pxrun.i &PROC='checkForMultipleSupplier'
                           &PROGRAM='adrtxr.p'
                           &PARAM="(vd_remit,
                                    vd_mstr.vd_addr)"
                           &NOAPPERROR=True
                           &CATCHERROR=True}

                  if return-value <> {&SUCCESS-RESULT}
                  then
                     pause.

                  /* DELETE Remit To */
                  {pxrun.i &PROC='processDelete'
                           &PROGRAM='adrtxr.p'
                           &PARAM="(vd_remit,
                                    vd_mstr.vd_addr )"
                           &NOAPPERROR=True
                           &CATCHERROR=True}

               end. /* IF vd_remit <> "" */


               /* DELETE VENDOR MASTER */
               {pxrun.i &PROC='deleteSupplier' &PROGRAM='adsuxr.p'
                  &PARAM="(buffer vd_mstr)"
                  &NOAPPERROR=true
                  &CATCHERROR=true}

               if c-application-mode <> "API" then do:
                  clear frame a.
                  clear frame b.
               end.  /* If c-application-mode <> "API" */
               del-yn = no.

               /* RECORD DELETED  */
               {pxmsg.i &MSGNUM=22 &ERRORLEVEL={&INFORMATION-RESULT}}
               leave innerloop.
            end. /*if del-yn*/

            /* CHECK IF SUPPLIER PERFORMANCE DATA SHOULD BE GATHERED */
            if {pxfunct.i &FUNCTION='isSupplierPerformanceEnabled'
               &PROGRAM='adsuxr.p'} and
               c-application-mode <> "API" then do:

               {gprunmo.i &program = ""advnve.p""
                  &module = "ASP"
                  &param="""(input recid(vd_mstr))"""}
            end. /* if enable supplier performance */

            status input.
            if vd_sort = "" then vd_sort = ad_name.
            if ad_sort = "" then ad_sort = ad_name.

            if soc_apm and
               c-application-mode <> "API" and
               (promo_old <> "" or vd_promo <> "")
            then do:
               /* Future logic will go here to determine subdirectory*/
               apm-ex-prg = "ifvend.p".
               apm-ex-sub = "if/".
               {gprunex.i
                  &module   = 'APM'
                  &subdir   = apm-ex-sub
                  &program  = 'ifapm057.p'
                  &params   = "(input vd_mstr.vd_addr,
                             input vd_mstr.vd_sort,
                             input ad_mstr.ad_attn,
                             input ad_mstr.ad_city,
                             input ad_mstr.ad_country,
                             input ad_mstr.ad_ext,
                             input ad_mstr.ad_fax,
                             input ad_mstr.ad_line1,
                             input ad_mstr.ad_line2,
                             input ad_mstr.ad_line3,
                             input ad_mstr.ad_name,
                             input ad_mstr.ad_phone,
                             input ad_mstr.ad_state,
                             input ad_mstr.ad_zip,
                             output error_flag,
                             output error_nbr)" }
               if error_flag then do:
                  /* ERROR OCCURRED UPDATING APM */
                  {pxmsg.i &MSGNUM=error_nbr
                           &ERRORLEVEL={&APP-ERROR-NO-REENTER-RESULT}}
                  undo.
               end. /* if error_flag then do: */
            end. /* (promo_old <> "" or vd_promo <> "") then do: */

         end. /* LOOP A  */

         if keyfunction(lastkey) = "END-ERROR" then
            next mainloop.

         /* MOVED UPDATES TO FRAME B AND FRAME C TO advnmtp.p */
         assign
            vd_recno = recid (vd_mstr)
            ad_recno = recid (ad_mstr)
            errfree  = false.

         if c-application-mode <> "API" then
            loopc:
            do on error undo, leave:
               {gprun.i ""xxvnmtp.p""  }
               if not errfree then do:
                  undo loopc, leave innerloop.
               end. /* if not errfree then do: */
            end. /* do on error undo, leave: */
         /* API MODE EXCEPTION HANDLING */
         else do:
            loopc_api:
            do on error undo loopc_api, return error:
               /* SET CURRENT ROW IN ADDRESS MASTER TEMP TABLE */
               run setAddressRow in ApiMethodHandle
                  (ttAddress.apiSequence).

               {gprun.i ""advnmtp.p""  }
               if not errfree then
                  undo loopc_api, return error.
            end. /* do on error */
         end.  /* C-application-mode = "API" */

         if soc_apm and
            c-application-mode <> "API" and
            (promo_old <> "" or vd_promo <> "") then do:
            /* Future logic will go here to determine subdirectory*/
            apm-ex-prg = "ifvend.p".
            apm-ex-sub = "if/".
            {gprunex.i
               &module   = 'APM'
               &subdir   = apm-ex-sub
               &program  = 'ifapm057.p'
               &params   = "(input vd_mstr.vd_addr,
                          input vd_mstr.vd_sort,
                          input ad_mstr.ad_attn,
                          input ad_mstr.ad_city,
                          input ad_mstr.ad_country,
                          input ad_mstr.ad_ext,
                          input ad_mstr.ad_fax,
                          input ad_mstr.ad_line1,
                          input ad_mstr.ad_line2,
                          input ad_mstr.ad_line3,
                          input ad_mstr.ad_name,
                          input ad_mstr.ad_phone,
                          input ad_mstr.ad_state,
                          input ad_mstr.ad_zip,
                          output error_flag,
                          output error_nbr)" }
            if error_flag then do:
               /* ERROR OCCURRED UPDATING APM */
               {pxmsg.i &MSGNUM=error_nbr
                        &ERRORLEVEL={&APP-ERROR-NO-REENTER-RESULT}}
            end. /* if error_flag then do: */
         end. /* (promo_old <> "" or vd_promo <> "") then do: */

         if c-application-mode <> "API" then do:
            do on endkey undo, leave innerloop:

            end. /* do on endkey undo, leave innerloop: */

            if use-log-acctg then do:
                /* UPDATE LOGISTICS ACCOUNTING TERMS OF TRADE FIELD */
                {gprunmo.i &module ="LA" &program = "lavdmt.p"
                       &param  = """(input vd_recno)"""}
            end.

            /* UPDATE BANK ACCOUNTS, WITH 3 FRAME ROWS AND VALIDATION */
            {gprun.i ""adcsbdmt.p""
               "(input ad_recno,
                 input 3,
                 input true)"}
         end.  /* If c-application-mode <> "API" */
         {&ADVNMT-P-TAG2}
         leave innerloop.
      end. /* transaction */
   end. /*innerloop*/

   {gpaud2.i &uniq_num1 = 01
      &uniq_num2 = 02
      &db_file = vd_mstr
      &db_field = vd_addr
      &db_field1 = """"}

   {gpaud2.i &uniq_num1 = 03
      &uniq_num2 = 04
      &db_file = ad_mstr
      &db_field = ad_addr
      &db_field1 = """"}

   /*   IF IN API MODE LEAVE MAINLOOP, ONLY PROCESS ONE ITERATION */
   /*   AT A TIME.                                                */
   if c-application-mode = "API" then
      leave mainloop.

end. /* MAIN LOOP */
{gpaud3.i &uniq_num1 = 01
   &uniq_num2 = 02
   &db_file = vd_mstr
   &db_field = vd_addr}
{gpaud3.i &uniq_num1 = 03
   &uniq_num2 = 04
   &db_file = ad_mstr
   &db_field = ad_addr}
status input.

/* RETURN SUCCESS STATUS TO API CALLER */
if c-application-mode = "API" then
   return {&SUCCESS-RESULT}.
