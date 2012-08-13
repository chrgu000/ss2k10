/* xxsoivmta3.p  -  PENDING INVOICE LINE ITEM MAINTENANCE                 */
/* Copyright 1986-2003 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/* $Revision: 1.15.3.3 $                                                */
/*V8:ConvertMode=Maintenance                                            */
/* REVISION: 7.4      LAST MODIFIED: 02/02/94   BY: dpm *GI46*          */
/* REVISION: 7.4      LAST MODIFIED: 04/20/94   BY: dpm *FN50*          */
/* REVISION: 7.5      LAST MODIFIED: 04/20/95   BY: DAH *J042*          */

/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane    */
/* REVISION: 8.6E     LAST MODIFIED: 03/24/98   BY: *J2FG* Niranjan R.  */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan   */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan   */
/* REVISION: 9.0      LAST MODIFIED: 11/24/98   BY: *M017* Sandy Brown  */
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan   */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00 BY: *N08T* Annasaheb Rahane */
/* REVISION: 9.1      LAST MODIFIED: 08/12/00 BY: *N0KN* myb              */
/* Old ECO marker removed, but no ECO header exists *F0PN*               */
/* Revision: 1.15     BY: Jeff Wootton    DATE: 09/21/01 ECO: *P01H*          */
/* $Revision: 1.15.3.3 $      BY: Jyoti Thatte    DATE: 08/28/03 ECO: *P106*          */

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

{mfdeclre.i}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE soivmta3_p_2 "Comments"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

define output parameter rtn_error as logical no-undo.
define shared variable line like sod_line.
define shared variable qty like sod_qty_ord.
define shared variable part as character format "x(18)".
define shared variable so_recno as recid.
define variable desc1 like pt_desc1.
define shared variable sod_recno as recid.
define shared variable sodcmmts like soc_lcmmts label {&soivmta3_p_2}.
define shared variable pl like pt_prod_line.
define shared frame c.
define shared frame d.
define shared variable clines as integer initial ?.
define shared variable mult_slspsn like mfc_logical no-undo.
define variable ptstatus like pt_status.
define shared variable discount as decimal.
define shared variable reprice_dtl like mfc_logical.

define        variable l_part like pt_part no-undo.
define variable apm-ex-sub  as character format "x(24)" no-undo.
define variable error_flag     like mfc_logical         no-undo.
define variable err_mess_no    like msg_nbr             no-undo.

/* Define shared line screens */
{xxsoivlnfm.i}

find so_mstr where recid(so_mstr) = so_recno no-lock no-error.
find sod_det where recid(sod_det) = sod_recno.
for first soc_ctrl no-lock:
end.

l_part = sod_part.

/* SEARCH CUSTOMER ITEM/ ITEM MASTER */
{gprun.i ""sopart.p"" "(input so_cust,
                 input so_ship,
                 input-output sod_part,
                 output sod_custpart)"}
/*GUI*/ if global-beam-me-up then undo, leave.

for first pt_mstr

      fields (pt_part pt_prod_line pt_pm_code)
      where pt_part = sod_part no-lock:
end. /* FOR FIRST PT_MSTR */

if l_part <> sod_part then do:
   display sod_part with frame c.
   /* CUSTOMER ITEM # REPLACED BY # */
   {pxmsg.i &MSGNUM=56 &ERRORLEVEL=1 &MSGARG1=l_part &MSGARG2=sod_part}
end. /* IF L_PART <> SOD_PART */

/* VERIFY THAT ITEM AND COMPONENTS BELONG TO THE APM DIVISION */
if available pt_mstr then do:
   for first cm_mstr fields(cm_addr cm_promo) no-lock
         where cm_addr = so_cust:
   end.

   if available cm_mstr then do:
      if soc_apm and cm_promo <> "" then do:
         /* CHECK IF PART BELONGS TO AN APM DIVISION */
         apm-ex-sub = "if/".
         {gprunex.i
            &module  = 'APM'
            &subdir  = apm-ex-sub
            &program = 'ifapm001.p'
            &params  = "(input sod_part,
                                  input so_div,
                                  output error_flag,
                                  output err_mess_no)"}

         if error_flag then do:
            {pxmsg.i &MSGNUM=err_mess_no &ERRORLEVEL=3
                     &MSGARG1=sod_part &MSGARG2=so_div}
            /* ITEM# LINE# DOES NOT BELONG TO APM DIVISION # */
            assign rtn_error = yes.
            return.
         end.

         /* CONFIGURED PART - CHECK COMPONENTS */
         if pt_pm_code = "C" then do:

            for each ps_mstr no-lock
                  where ps_par = sod_part:
/*GUI*/ if global-beam-me-up then undo, leave.

               assign apm-ex-sub = "if/".
               {gprunex.i
                  &module  = 'APM'
                  &subdir  = apm-ex-sub
                  &program = 'ifapm001.p'
                  &params  = "(input ps_comp,
                                        input so_div,
                                        output error_flag,
                                        output err_mess_no)"}

               if error_flag then do:
                  {pxmsg.i &MSGNUM=6352 &ERRORLEVEL=3
                           &MSGARG1=ps_comp &MSGARG2=so_div}
                  /* COMPONENT # DOES NOT BELONG TO APM DIVISION # */
                  assign rtn_error = yes.
                  return.
               end.
            end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* EACH PS_MSTR */
         end. /* PT_PM_CODE = "C" */

         assign sod_div = so_div.

      end. /* SOC_APM AND CM_PROMO <> "" */
   end.  /* AVAILABLE CM_MSTR */
end.  /* AVAILABLE PT_MSTR */

else do:
   /* SHIP TYPE SET TO (M)EMO */
   {pxmsg.i &MSGNUM=25 &ERRORLEVEL=2}
   sod_type = "M".
end. /* IF NOT AVAILABLE PT_MSTR */

/* MOVED THE LOGIC FOR PT_MSTR/CP_MSTR SEARCH TO SOPART.P */

/* Calculate SO line commission percentages */
pl = "".
find pt_mstr where pt_part = sod_part no-lock no-error.
if available pt_mstr then pl = pt_prod_line.
sod_recno = recid(sod_det).

{gprun.i ""sosocom.p""}
/*GUI*/ if global-beam-me-up then undo, leave.

