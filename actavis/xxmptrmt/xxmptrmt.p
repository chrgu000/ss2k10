/* xxmptrmt.p - RECORD TEST RESULTS MAINTENANCE                         */ 
/*V8:ConvertMode=Maintenance                                            */
{mfdtitle.i "111123.1"}

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE mptrmt_p_1 "Op Status"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

define new shared variable wrstatus like wr_status format "x(8)".
define new shared variable wr_recno as recid.
define new shared variable wo_recno as recid.
define variable wonbr like wo_nbr.
define variable wolot like wo_lot.
define variable nbr like wr_nbr.
define variable lot like wr_lot.
define variable op  like wr_op.

form
   nbr         colon 12
   lot         colon 65
   op          colon 12
   wr_desc     no-label
   wrstatus    colon 65 label {&mptrmt_p_1} skip(1)
   wo_status   colon 12
   wr_part     colon 12
   pt_desc1    no-label
   pt_desc2    at 34 no-label
with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

/* BEGIN E-SIGNATURES CODE */
{essinsup.i &CATEGORY="0002"
            &PROGRAM_TYPE="FUNCTION"
            &TOP_TABLE="wr_route"}

/* E-Signature Persistent Procedure initialization */
ll_isesig_on = isEsigConfigured("0002").
if ll_isesig_on then run initESig.

/* CREATE SESSION TRIGGER FOR USLH_HIST */
if ll_isesig_on then
   run createUslhHistSessionTrigger.
/* END E-SIGNATURES CODE */

mainloop:
repeat transaction:

   if ll_quitmfgpro then undo, leave mainloop.

   update nbr lot op with frame a
   editing:

      if frame-field = "nbr" then do:

         /* FIND NEXT/PREVIOUS */
         {mfnp.i wr_route nbr  " wr_route.wr_domain = global_domain and wr_nbr
         "  nbr wr_nbr wr_nbr}

         if recno <> ? then do:
            {mfwrstat.i wrstatus}
            display
               wr_nbr @ nbr
               wr_lot @ lot
               wr_op  @ op
               wr_part
               wr_desc
               wrstatus
            with frame a.
            find pt_mstr  where pt_mstr.pt_domain = global_domain and  pt_part
            = wr_part no-lock no-error.
            if available pt_mstr then
               display
                  pt_desc1
                  pt_desc2
               with frame a.
            find wo_mstr  where wo_mstr.wo_domain = global_domain and  wo_lot =
            wr_lot no-lock no-error.
            if available wo_mstr then display wo_status with frame a.
         end.
         recno = ?.
         wonbr = input nbr.
      end.

      else if frame-field = "lot" then do:

         if input nbr = "" then do:
            /* FIND NEXT/PREVIOUS */
            {mfnp.i wr_route lot  " wr_route.wr_domain = global_domain and
            wr_lot "  lot wr_lot wr_lot}
         end.
         else do:
            /* FIND NEXT/PREVIOUS FOR THE WORK ORDER NUMBER */
            {mfnp01.i wr_route lot wr_lot "input nbr"
                " wr_route.wr_domain = global_domain and wr_nbr "  wr_nbrop}
         end.

         if recno <> ? then do:
            {mfwrstat.i wrstatus}
            display
               wr_nbr  @ nbr
               wr_lot  @ lot
               wr_op   @ op
               wr_desc
               wrstatus
               wr_part
            with frame a.
            find pt_mstr  where pt_mstr.pt_domain = global_domain and  pt_part
            = wr_part no-lock no-error.
            if available pt_mstr then
               display
                  pt_desc1
                  pt_desc2
               with frame a.
            find wo_mstr  where wo_mstr.wo_domain = global_domain and  wo_lot =
            wr_lot no-lock no-error.
            if available wo_mstr then display wo_status with frame a.
         end.
         recno = ?.
         wolot = input lot.
      end.

      else if frame-field = "op" then do:

         if input nbr <> ""
            and wolot = "" then do:
            /* FIND NEXT/PREVIOUS */
            {mfnp01.i wr_route op wr_op "input nbr"
                " wr_route.wr_domain = global_domain and wr_nbr "  wr_nbrop}
         end.
         else do:
            /* FIND NEXT/PREVIOUS */
            {mfnp01.i wr_route op wr_op "input lot"  " wr_route.wr_domain =
            global_domain and wr_lot "  wr_lot}
         end.

         if recno <> ? then do:
            {mfwrstat.i wrstatus}
            display
               wr_nbr @ nbr
               wr_lot @ lot
               wr_op  @ op
               wr_part
               wr_desc
               wrstatus
            with frame a.
            find pt_mstr  where pt_mstr.pt_domain = global_domain and  pt_part
            = wr_part no-lock no-error.
            if available pt_mstr then
               display
                  pt_desc1
                  pt_desc2
               with frame a.
            find wo_mstr  where wo_mstr.wo_domain = global_domain and  wo_lot =
            wr_lot no-lock no-error.
            if available wo_mstr then display wo_status with frame a.
         end.
      end.

      else do:
         status input.
         readkey.
         apply lastkey.
      end.

   end.  /* EDITING */

   find wo_mstr  where wo_mstr.wo_domain = global_domain and  wo_lot = lot
   no-lock no-error.
   if not available wo_mstr then do:
      find first wo_mstr  where wo_mstr.wo_domain = global_domain and  wo_nbr =
      nbr no-lock no-error.
      if not available wo_mstr then do:
         {pxmsg.i &MSGNUM=510 &ERRORLEVEL=3}
         /* WORK ORDER/LOT DOES NOT EXIST */
         next-prompt nbr with frame a.
         undo, retry.
      end.
   end.

   {gprun.i ""gpsiver.p""
      "(input wo_site, input ?, output return_int)"}
   if return_int = 0 then do:
      {pxmsg.i &MSGNUM=2710 &ERRORLEVEL=3 &MSGARG1=wo_site}
      /* USER DOES NOT HAVE ACCESS TO SITE xxxx */
      next-prompt nbr with frame a.
      undo, retry.
   end.
   find wr_route  where wr_route.wr_domain = global_domain and  wr_lot = lot
   and wr_op = op
      use-index wr_lot no-error.
   if not available wr_route and op <> 0 then do:
      find first wr_route  where wr_route.wr_domain = global_domain and  wr_nbr
      = nbr and wr_op = op
         use-index wr_lot no-error.
      if not available wr_route then do:
         {pxmsg.i &MSGNUM=511 &ERRORLEVEL=3}
         next-prompt nbr with frame a.
         undo, retry.
      end.
   end.

   display
      wo_lot @ lot
      wo_nbr @ nbr
      wo_status
      wo_part @ wr_part
   with frame a.

   if available wr_route then do:
      display wr_op @ op wr_desc with frame a.
      {mfwrstat.i wrstatus}
      display wrstatus with frame a.
   end.

   find pt_mstr  where pt_mstr.pt_domain = global_domain and  pt_part = wo_part
   no-lock no-error.
   if available pt_mstr then
      display
         pt_desc1
         pt_desc2
      with frame a.

   if index("PF",wo_status) <> 0 then do:
      {pxmsg.i &MSGNUM=19 &ERRORLEVEL=3
               &MSGARG1="""'"" + wo_status + ""'"""}
      undo, retry.
   end.

/* 
   if available wr_route and wr_status = "C" then do:
      {pxmsg.i &MSGNUM=524 &ERRORLEVEL=3}
      /* OPERATION CLOSED */
      next-prompt wr_op.
      undo, retry.
   end.
*/

   if available wo_mstr then do:
      wo_recno = recid(wo_mstr).
      if available wr_route then wr_recno = recid(wr_route).

      /* BEGIN E-SIGNATURES CODE */
      /* Display the latest E-Signature */
      if ll_isesig_on then
      do:
         run displayLatestESig( buffer wr_route, true ).
         view frame a.
      end.
      /* END E-SIGNATURES CODE */

      {mpwindow.i
         wo_part
         op
         "if wo_routing = """" then wo_part else wo_routing"
         today}

      if not available ip_mstr then do:
         {pxmsg.i &MSGNUM=7009 &ERRORLEVEL=3}
         /* NO MASTER SPEC DEFINED */
      end.
   end.

   /* BEGIN E-SIGNATURES CODE */
   if ll_isesig_on then
   do:
      /* E-Signature Signing */
      run signESigData( buffer wr_route ).
      view frame a.
      if not ll_success then undo mainloop, next mainloop.
   end.
   /* END E-SIGNATURES CODE */

end.  /* repeat */

/* BEGIN E-SIGNATURES CODE */
/* DUE TO THE TRANSACTION SCOPING AND THE USLH_HIST RECORDS */
/* CREATED IN CREATELOGONHISTORY WHICH GETS UNDONE WHEN THE */
/* USER IS DEACTIVATED, WE NOW NEED TO CREATE THEM AGAIN.   */
if ll_isesig_on and ll_quitmfgpro then
   run revertUslhHistSessionTrigger.

/* E-Sig cleaning */
if ll_isesig_on then run cleanupEsig.
/* END E-SIGNATURES CODE */
