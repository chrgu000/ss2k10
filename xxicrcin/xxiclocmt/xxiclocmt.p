/* xxiclomt.p - LOCATION Recive Level MAINTENANCE                            */
/* revision: 110715.1    created on: 20110715   by: zhang yun                */
/*V8:ConvertMode=Maintenance                                                 */
/* Environment: Progress:10.1C04  QAD:eb21sp7    Interface:Character         */
/*-Revision end--------------------------------------------------------------*/

/* DISPLAY TITLE */
{mfdtitle.i "110715.1"}
{cxcustom.i "ICLOMT.P"}

define variable del-yn  like mfc_logical initial no.
define variable locstatus like loc_status.
define variable locdesc like loc_desc.
define variable reserved_cust like mfc_logical initial no no-undo.
define variable v-project like loc_project no-undo.

/* CONSIGNMENT INVENTORY VARIABLES */
{pocnvars.i}

/* DISPLAY SELECTION FORM */
form
   loc_site   colon 30 si_desc no-label
   loc_loc    colon 30 skip(1)
   loc_desc   colon 30
   loc_status colon 30 skip(2)
   loc_user2  colon 30
with frame a side-labels width 80.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

/* DETERMINE IF SUPPLIER CONSIGNMENT IS ACTIVE */
{gprun.i ""gpmfc01.p""
         "(input ENABLE_SUPPLIER_CONSIGNMENT,
           input 11,
           input ADG,
           input SUPPLIER_CONSIGN_CTRL_TABLE,
           output using_supplier_consignment)"}

/* DISPLAY */
view frame a.
global_site = "".
mainloop:
repeat with frame a:

   prompt-for loc_site loc_loc
   editing:
      if frame-field = "loc_site" then do:
         /* FIND NEXT/PREVIOUS RECORD */
         {mfnp.i si_mstr
                 loc_site
                 si_site
                 loc_site
                 si_site
                 si_site}
         if recno <> ?
         then display si_site @ loc_site
                      si_desc
         with frame a.
         global_site = input loc_site.
      end.   /* if frame-field = "loc_site" */
      else if frame-field = "loc_loc" then do:
         /* FIND NEXT/PREVIOUS RECORD */
         {mfnp05.i loc_mstr
                   loc_loc
                   "(loc_site = input loc_site)"
                   loc_loc
                   "input loc_loc"}
         if recno <> ? then do:
            /* FIND NEXT/PREVIOUS RECORD */

            for first si_mstr fields (si_site si_desc)
               where si_site = loc_site
               no-lock:
            end.

            if can-find (first locc_det where locc_site = loc_site
                         and   locc_loc  = loc_loc) then
            reserved_cust = yes.
            else reserved_cust = no.

            display
               loc_site
               si_desc   when(available si_mstr)
               loc_loc
               loc_desc
               loc_status
               loc_user2
            with frame a
            .
         end.  /* if recno <> ? */
      end.  /* if frame-field = "loc_loc" */
   end.  /* editing */

   if can-find (first locc_det where locc_site = input loc_site
                and   locc_loc  = input loc_loc) then
   reserved_cust = yes.
   else reserved_cust = no.

   for first whl_mstr fields (whl_site whl_loc)
         where whl_mstr.whl_site = input loc_site
         and whl_mstr.whl_loc = input loc_loc
         exclusive-lock:
   end.
   if available whl_mstr
   then do:
      {pxmsg.i &MSGNUM=1813 &ERRORLEVEL=3}
      undo, retry.
   end.

   for first si_mstr fields (si_site si_desc)
         where si_site = input loc_site
         no-lock:
   end.

   if available si_mstr then do:
      {gprun.i ""gpsiver.p""
         "(input si_site, input recid(si_mstr), output return_int)"}
      if return_int = 0 then do:
         {pxmsg.i &MSGNUM=725 &ERRORLEVEL=3}
         /* USER DOES NOT HAVE */
         /* ACCESS TO THIS SITE*/
         undo, retry.
      end.
   end.

   /* ADD/MOD/DELETE  */

   assign
      recno = recid(loc_mstr)
      global_site = loc_site.


   display
      loc_site si_desc when(available si_mstr)
      " " when (not available si_mstr) @ si_desc
      loc_loc
      locdesc @ loc_desc
      loc_user2.

   ststatus = stline[2].
   status input ststatus.
   del-yn = no.

   locstatus = loc_status.
  find loc_mstr exclusive-lock where recid(loc_mstr) = recno no-error.
   set1:
   do on error undo, retry:

      set
         loc_user2
         go-on (F5 CTRL-D).

        if index("FPX",substring(loc_user2 ,1 ,1) ) = 0 and loc_user2 <> ""
        then do:
            {pxmsg.i &MSGNUM=2479 &ERRORLEVEL=3}
            undo set1.
        end.

      /* DELETE */
      if lastkey = keycode("F5") or
         lastkey = keycode("CTRL-D") then do:
         del-yn = no.
         {pxmsg.i &MSGNUM=1021 &ERRORLEVEL=3}
         if del-yn = no then undo set1.
      end.
      if del-yn then do:
         /* DELETE LOCATION DETAIL IF QTY NOT OUTSTANDING */
         {pxmsg.i &MSGNUM=1021 &ERRORLEVEL=3}

         clear frame a.
         del-yn = no.
         hide message no-pause.
         next mainloop.
      end.

      /* WARNING IF PROJECT IS CHANGED IN A NON-EMPTY LOCATION*/
      if v-project <> loc_project and
         can-find(first ld_det where ld_site = loc_site
         and ld_loc  = loc_loc
         and ld_qty_oh <> 0)
      then do:
         {pxmsg.i &MSGNUM=8609 &ERRORLEVEL=2}
         /* PROJECT CHANGED, BUT MATERIAL FOUND IN LOCATION */
      end.

      if loc__qad01 and not loc_single then do:
         {pxmsg.i &MSGNUM=230 &ERRORLEVEL=2}
         /* Single Lot/Serial is only enforced for single item locations */
      end.
      {&ICLOMT-P-TAG1}

      if loc_status <> locstatus then do:

         for first ld_det fields(ld_loc ld_lot ld_qty_oh ld_site)
               where ld_site = loc_site
               and ld_loc = loc_loc and ld_lot = "" no-lock:
         end.
         if available ld_det then do:
            /* Status of existing non-lot/serial control  */
            /* inventory not changed*/
            {pxmsg.i &MSGNUM=1452 &ERRORLEVEL=2}
         end.
      end.

      /* if reserved_cust is yes, call program iclomta.p   */
      /* to update reserved cust data                      */
      if reserved_cust = yes then do:
         /* Issue warning first if available status = yes */
         for first is_mstr fields(is_status is_avail)
            where is_status = loc_status
            no-lock:
               if batchrun = no and is_avail = yes then do:
               {pxmsg.i &MSGNUM=4611 &ERRORLEVEL=2}
               /* Reserved locations not advised when Inv Status */
               /*  is "avail = yes"                              */
               del-yn = no.
               {pxmsg.i &MSGNUM=2316 &ERRORLEVEL=1 &CONFIRM=del-yn}
               /* OK to continue? */
 /*              if del-yn = no then do:                               */
 /*                 next-prompt reserved_cust with frame a.            */
 /*                 undo set1, retry set1.                             */
 /*             end.                                                   */
            end.  /* is_avail = yes */
         end.   /* for first is_mstr */

         hide frame a no-pause.
         {gprun.i ""iclomta.p""
         "(input loc_site, input loc_loc)"}
         view frame a.
      end.   /* reserved_cust = yes */

   end.  /*** (set1:) ***/
end.  /*** (mainloop:) ***/
status input.
