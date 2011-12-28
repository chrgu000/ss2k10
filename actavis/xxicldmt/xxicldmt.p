/* xxicldmt.p - INVENTORY BALANCE DETAIL RECORD MAINT                         */

/*V8:ConvertMode=Maintenance                                                  */
/*Add user access control                                                     */
/*   code_mstr : code_fldname = "xxicldmt-accesslist"                         */
/*               code_value = user_id                                         */
/*           code_cmmt = separated With ";" , * can access all item       */


{mfdtitle.i "111130.1"}

{gldydef.i new}
{gldynrm.i new}

define new shared variable lddate like ld_date no-undo.

define variable site       like ld_site.
define variable loc        like ld_loc.
define variable lotser     like ld_lot.
define variable part       like ld_part.
define variable trqty      like ld_qty_oh.
define variable eff_date   as date.
define variable ref        as character.
define variable lotref     like ld_ref format "x(8)".
define variable lotrf      like ld_ref format "x(8)".
define variable old_stat   like ld_status.
define variable cnt_dt     like ld_cnt_date.
define variable wolot      like wo_lot.
define variable tmp_grade  like ld_grade.
define variable tmp_assay  like ld_assay.
define variable tmp_status like ld_status.
define variable tmp_expire like ld_expire.
define variable ldrecno    as recid no-undo.
define variable vaccess    as logical.
define variable vcmmt      like code_cmmt.
define variable vtxt       as character.
define variable l_yn       like mfc_logical    no-undo.

form
   ld_site      colon 18
   si_desc      at 41 no-label
   ld_loc       colon 18
   ld_part      colon 18
   pt_desc1     at 41 no-label
   ld_lot       colon 18
   ld_ref colon 18 format "x(8)"
   skip(1)
   ld_qty_oh    colon 18
   pt_shelflife colon 18
   skip(1)
   ld_expire    colon 18
   ld_grade     colon 18
   ld_assay     colon 18
   ld_status    colon 18
with frame a side-labels attr-space width 80.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

/* E-Sig support include file */
{icldmtes.i}
/* E-Signature Persitent Procedure initialization */
ll_isesig_on = isEsigConfigured("0006") or
               isEsigConfigured("0007").
if ll_isesig_on then run initESig.

/* CREATE SESSION TRIGGER FOR USLH_HIST */
if ll_isesig_on then
   run createUslhHistSessionTrigger.

mainloop:
repeat with frame a:

   if ll_quitmfgpro then undo, leave mainloop.

   prompt-for ld_site ld_loc ld_part ld_lot ld_ref
   with frame a  editing:

      global_part = input ld_part.
      global_site = input ld_site.
      global_loc  = input ld_loc.
      global_lot  = input ld_lot.

      if frame-field = "ld_site" then do:
         {mfnp05.i ld_det ld_loc_p_lot  " ld_det.ld_domain = global_domain and
         yes "  ld_site "input ld_site"}
         if recno <> ? then do:
            find si_mstr  where si_mstr.si_domain = global_domain and  si_site
            = ld_site no-lock.
            for first loc_mstr
               fields(loc_site loc_loc loc_domain)
               where loc_mstr.loc_domain = global_domain
               and   loc_site            = ld_site
               and   loc_loc             = ld_loc
               no-lock:
            end. /* FOR FIRST loc_mstr */
            find pt_mstr  where pt_mstr.pt_domain = global_domain and  pt_part
            = ld_part no-lock.
            display ld_site si_desc ld_loc ld_part pt_desc1
               pt_shelflife
               ld_lot
               ld_ref
               ld_qty_oh ld_expire ld_grade ld_assay ld_status.
         end.
      end.
      else
      if frame-field = "ld_loc" then do:
         {mfnp05.i ld_det ld_loc_p_lot " ld_det.ld_domain = global_domain and
         ld_site  = input ld_site"
            ld_loc "input ld_loc"}
         if recno <> ? then do:
            find si_mstr  where si_mstr.si_domain = global_domain and  si_site
            = ld_site no-lock.
            for first loc_mstr
               fields(loc_site loc_loc loc_domain)
               where loc_mstr.loc_domain = global_domain
               and   loc_site            = ld_site
               and   loc_loc             = ld_loc
               no-lock:
            end. /* FOR FIRST loc_mstr */
            find pt_mstr  where pt_mstr.pt_domain = global_domain and  pt_part
            = ld_part no-lock.
            display ld_site si_desc ld_loc ld_part pt_desc1
               pt_shelflife
               ld_lot
               ld_ref
               ld_qty_oh ld_expire ld_grade ld_assay ld_status.
         end.
      end.

      else
      if frame-field = "ld_part" then do:
         {mfnp05.i ld_det ld_loc_p_lot
            " ld_det.ld_domain = global_domain and ld_site = input ld_site and
            ld_loc = input ld_loc"
            ld_part "input ld_part"}
         if recno <> ? then do:
            find si_mstr  where si_mstr.si_domain = global_domain and  si_site
            = ld_site no-lock.
            for first loc_mstr
               fields(loc_site loc_loc loc_domain)
               where loc_mstr.loc_domain = global_domain
               and   loc_site            = ld_site
               and   loc_loc             = ld_loc
               no-lock:
            end. /* FOR FIRST loc_mstr */
            find pt_mstr  where pt_mstr.pt_domain = global_domain and  pt_part
            = ld_part no-lock.
            display ld_site si_desc ld_loc ld_part pt_desc1
               pt_shelflife
               ld_lot
               ld_ref
               ld_qty_oh ld_expire ld_grade ld_assay ld_status.
         end.
      end.

      else
      if frame-field = "ld_lot" then do:
         {mfnp05.i ld_det ld_loc_p_lot
            " ld_det.ld_domain = global_domain and ld_site  = input ld_site and
            ld_loc = input ld_loc
              and ld_part = input ld_part"
            ld_lot "input ld_lot"}
         if recno <> ? then do:
            find si_mstr  where si_mstr.si_domain = global_domain and  si_site
            = ld_site no-lock.
            for first loc_mstr
               fields(loc_site loc_loc loc_domain)
               where loc_mstr.loc_domain = global_domain
               and   loc_site            = ld_site
               and   loc_loc             = ld_loc
               no-lock:
            end. /* FOR FIRST loc_mstr */
            find pt_mstr  where pt_mstr.pt_domain = global_domain and  pt_part
            = ld_part no-lock.
            display ld_site si_desc ld_loc ld_part pt_desc1
               pt_shelflife
               ld_lot
               ld_ref
               ld_qty_oh ld_expire ld_grade ld_assay ld_status.
         end.
      end.

      else do:
         readkey.
         apply lastkey.
      end.

   end.  /* EDITING */

find ld_det using  ld_site and ld_loc and ld_part and ld_lot and ld_ref where
ld_det.ld_domain = global_domain  no-lock no-error.
   if not available ld_det then do:
      {pxmsg.i &MSGNUM=305 &ERRORLEVEL=3} /* LD_DET DOES NOT EXIST */
      undo, retry.
   end.

   assign vaccess = no.
   find first code_mstr where code_domain = global_domain and
              code_fldname = "xxicldmt-accesslist" and
              code_value = global_userid no-error.
   if available code_mstr then do:
    if index(code_cmmt,'*') > 0 then do:
       assign vaccess = yes.
    end.
    else do:
         assign vcmmt = code_cmmt.
         repeat while length(vcmmt) > 0 :
            if index(vcmmt,";") > 0 and vcmmt <> "" then do:
               assign vtxt = substring(vcmmt,1,index(vcmmt,";") - 1).
            end.
            else do:
               assign vtxt = vcmmt.
            end.
             if ld_part begins vtxt  then do:
                 assign vaccess = yes.
                 leave.
             end.
             if index(vcmmt,";") > 0 then do:
                assign vcmmt = substring(vcmmt,index(vcmmt,";") + 1).
             end.
             else do:
                assign vcmmt = "".
             end.
         end.
      end.
   end.
   
   if NOT vaccess then do:
      {mfmsg.i 9010 3}
      undo,retry.
   end.

   /* TO RETAIN THE VALUE OF CREATE DATE SO THAT CREATE DATE */
   /* DOES NOT GET RE-ASSIGNED TO TODAY'S DATE               */
   lddate = ld_date.

   if not can-find(is_mstr  where is_mstr.is_domain = global_domain and
   is_status = ld_status) then do:
      display ld_expire ld_grade ld_assay ld_status.
      {pxmsg.i &MSGNUM=379 &ERRORLEVEL=4}
      /* STATUS HAS BEEN DELETED.  RE-ADDED*/
      undo, retry.
   end.

   find si_mstr  where si_mstr.si_domain = global_domain and  si_site = ld_site
   no-lock no-error.

   if not available si_mstr then do:
      {pxmsg.i &MSGNUM=708 &ERRORLEVEL=3}  /* SITE DOES NOT EXIST */
      undo mainloop, retry.
   end.

   {gprun.i ""gpsiver.p""
      "(input si_site,
        input recid(si_mstr),
        output return_int)"}

   if return_int = 0 then do:
      {pxmsg.i &MSGNUM=725 &ERRORLEVEL=3}
      /*USER DOES NOT HAVE ACCESS TO THIS SITE */
      undo mainloop, retry.
   end.

   if can-find (first lotw_wkfl  where lotw_wkfl.lotw_domain = global_domain
   and  lotw_part = ld_part and
      lotw_lotser = ld_lot) then do:
      {pxmsg.i &MSGNUM=2743 &ERRORLEVEL=4} /*RECEIPT TRANACTION IN PROCESS*/
      undo mainloop, retry.
   end.

   for first loc_mstr
      fields(loc_site loc_loc loc_domain)
      where loc_mstr.loc_domain = global_domain
      and   loc_site            = ld_site
      and   loc_loc             = ld_loc
      no-lock:
   end. /* FOR FIRST loc_mstr */

   find pt_mstr  where pt_mstr.pt_domain = global_domain and  pt_part = ld_part
   no-lock.

   display
      ld_site
      si_desc
      ld_loc
      ld_part
      pt_desc1
      pt_shelflife
      ld_lot
      ld_ref
      ld_qty_oh
      ld_expire
      ld_grade
      ld_assay
      ld_status.

   if batchrun = no then
   for first isd_det
   fields( isd_domain isd_status isd_tr_type)
       where isd_det.isd_domain = global_domain and (  isd_status = ld_status
       and
      (isd_tr_type = "ISS-CHL" or isd_tr_type = "RCT-CHL")
   ) no-lock: end.

   else
   for first isd_det
   fields( isd_domain isd_status isd_tr_type isd_bdl_allowed)
       where isd_det.isd_domain = global_domain and (  isd_status = ld_status
       and
      (isd_tr_type = "ISS-CHL" or isd_tr_type = "RCT-CHL") and
      isd_bdl_allowed = no
   ) no-lock: end.

   if available isd_det
   then do:
      release isd_det.
      {pxmsg.i &MSGNUM=373 &ERRORLEVEL=3 &MSGARG1=ld_status}
      undo, retry.
   end.

   old_stat = ld_status.

   /* Display the latest E-Signature */
   if ll_isesig_on then run displayLatestESig( buffer ld_det ).

   do on error undo, retry:

      prompt-for
         ld_expire
         ld_grade
         ld_assay
         ld_status.

      for first is_mstr
         fields (is_domain is_status is_over)
         where is_mstr.is_domain = global_domain
         and   is_status         = input ld_status
      no-lock:
      end. /* FOR FIRST is_mstr */

      if available is_mstr
      then do:
         if not is_over
            and ld_qty_oh < 0
         then do:
            l_yn = no.
            {pxmsg.i &MSGNUM=6999 &ERRORLEVEL=1 &CONFIRM=l_yn}
            if not l_yn
            then
               undo, retry.
         end. /* IF NOT is_over ... */
      end. /* IF AVAILABLE is_mstr */
      else do:
         {pxmsg.i &MSGNUM=362 &ERRORLEVEL=3}
         undo, retry.
      end. /* IF NOT AVAILABLE is_mstr */

   end.

   if  ld_grade  = input ld_grade
   and ld_status = input ld_status
   and ld_assay  = input ld_assay
   and ld_expire = input ld_expire
   then do:
      undo, retry.
   end. /* IF ld_grade = input ld_grade .. */

   assign
      site = ld_site
      loc = ld_loc
      part = ld_part
      lotser = ld_lot
      lotrf = ld_ref
      trqty = ld_qty_oh
      cnt_dt =ld_cnt_date.

   assign
      tmp_grade  = input ld_grade
      tmp_status = input ld_status
      tmp_assay  = input ld_assay
      tmp_expire = input ld_expire.

   /* CREATE INVENTORY TRANSACTION (TR_HIST) RECORDS */
   /* CHANGED INPUT TO TMP VARIABLES FOR  GRADE, STATUS, ASSAY AND */
   /* EXPIRE.*/

   esigblock:
   do transaction:
      if ll_isesig_on then
      do:
         /* E-Signature Signing */
         run preSignESigData(buffer ld_det).
         if not ll_success then undo esigblock, next mainloop.
         on write of tr_hist
         do:
            find first tt_log no-lock
               where tt_rec = recid(tr_hist) no-error.
            if not available tt_log then
            do:
               create tt_log.
               tt_rec = recid(tr_hist).
            end.
         end.
      end.

      {gprun.i ""icldmta.p""
         "(input site,
           input loc,
           input part,
           input lotser,
           input lotrf,
           input trqty,
           input eff_date,
           input ref,
           input old_stat,
           input cnt_dt,
           input tmp_grade,
           input tmp_assay,
           input tmp_status,
           input tmp_expire,
           output ldrecno,
           input wolot)"}

      /* E-Signature Signing */
      if ll_isesig_on then
      do:
         release tr_hist no-error.
         on write of tr_hist revert.
         find ld_det using ld_site
            and ld_loc
            and ld_part
            and ld_lot
            and ld_ref
            where ld_det.ld_domain = global_domain
         no-lock no-error.
         run signESigData(buffer ld_det).
         if not ll_success then undo esigblock, next mainloop.
      end.
   end. /* esig block transaction */
end. /* MAINLOOP */

/* DUE TO THE TRANSACTION SCOPING AND THE USLH_HIST RECORDS */
/* CREATED IN CREATELOGONHISTORY WHICH GETS UNDONE WHEN THE */
/* USER IS DEACTIVATED, WE NOW NEED TO CREATE THEM AGAIN.   */
if ll_isesig_on and ll_quitmfgpro then
   run revertUslhHistSessionTrigger.

/* E-Sig cleaning */
if ll_isesig_on then run cleanupEsig.
