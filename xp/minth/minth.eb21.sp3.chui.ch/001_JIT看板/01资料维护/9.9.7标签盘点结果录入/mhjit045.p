/* /* pitcmt1.p - TAG COUNT ENTRY                                                */ */
/* /* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                        */ */
/* /* All rights reserved worldwide.  This is an unpublished work.               */ */
/* /* $Revision: 1.5.1.6 $                                                       */ */
/* /*V8:ConvertMode=Maintenance                                                  */ */
/* /* REVISION: 6.0      LAST MODIFIED: 03/06/90   BY: WUG *D015*                */ */
/* /* REVISION: 7.0      LAST MODIFIED: 09/25/91   BY: pma *F003*                */ */
/* /* REVISION: 7.0      LAST MODIFIED: 11/11/91   BY: WUG *D887*                */ */
/* /* REVISION: 6.0      LAST MODIFIED: 03/05/92   BY: WUG *F254*                */ */
/* /* REVISION: 7.3      LAST MODIFIED: 09/16/92   BY: WUG *F902*                */ */
/* /* REVISION: 7.3      LAST MODIFIED: 08/13/94   BY: pxd *FQ65*                */ */
/* /* REVISION: 7.5      LAST MODIFIED: 11/03/94   BY: mwd *J034*                */ */
/* /* REVISION: 7.5      LAST MODIFIED: 11/28/94   BY: taf *J038*                */ */
/* /* REVISION: 7.3      LAST MODIFIED: 02/17/95   BY: cpp *F0JK*                */ */
/* /* REVISION: 7.3      LAST MODIFIED: 03/07/95   BY: cpp *F0K1*                */ */
/* /* REVISION: 7.3      LAST MODIFIED: 01/30/96   BY: rvw *G1LQ*                */ */
/* /* REVISION: 8.5      LAST MODIFIED: 12/11/96   BY: *G2JF   Russ Witt         */ */
/* /* REVISION: 8.6      LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan         */ */
/* /* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */ */
/* /* REVISION: 9.1      LAST MODIFIED: 08/13/00   BY: *N0KQ* myb                */ */
/* /* REVISION: 9.1      LAST MODIFIED: 12/12/00   BY: *M0XQ* Mark Christian     */ */
/* /* Old ECO marker removed, but no ECO header exists *F0PN*                    */ */
/* /* Old ECO marker removed, but no ECO header exists *G2JF*                    */ */
/* /* Revision: 1.5.1.4  BY: Jean Miller DATE: 05/11/02 ECO: *P05V* */              */
/* /* $Revision: 1.5.1.6 $ BY: Paul Donnelly (SB) DATE: 06/28/03 ECO: *Q00J* */     */
/* /*-Revision end---------------------------------------------------------------*/ */
/*                                                                                  */
/* /******************************************************************************/ */
/* /* All patch markers and commented out code have been removed from the source */ */
/* /* code below. For all future modifications to this file, any code which is   */ */
/* /* no longer required should be deleted and no in-line patch markers should   */ */
/* /* be added.  The ECO marker should only be included in the Revision History. */ */
/* /******************************************************************************/ */
/*                                                                                  */
/* /********************************************************************/           */
/* /* NOTE:  GENERAL CODE CLEANUP PLUS ADDED SITE SECURITY CHECK       */           */
/* /* NOTE:  RE-INDENTED ENTIRE PROGRAM, ADDED MAINLOOP, TAGLOOP,      */           */
/* /*        AND SETCNT LABELS AND REFERENCES TO THOSE ON UNDO'S.      */           */
/* /********************************************************************/           */


/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                               */
/* All rights reserved worldwide.  This is an unpublished work.                      */
/*V8:ConvertMode=NoConvert                                                           */
/* REVISION: 1.0      LAST MODIFIED: 10/08/07   BY: Softspeed roger xiao   /*xp001*/ */
/*-Revision end------------------------------------------------------------          */




{mfdtitle.i "2+ "}

define variable new_count like mfc_logical.
define variable new_date  as date.
define variable new_name  as character.
define variable yn        like mfc_logical.
define variable trans-ok  like mfc_logical.

define var v_qty_firm as logical init no .
define variable v_fqty    like xmpt_kb_fqty .
define variable v_qty_kb  like xmpt_kb_fqty .
define var qty_raim_old like xkb_kb_raim_qty .
define var v_type like xkb_type .
define var v_id like xkb_kb_id .
define var trnbr like tr_trnbr.
define var v_trnbr like tr_trnbr.
define buffer xkbhhist for xkbh_hist.

form  with frame c 8 down no-attr-space width 80.
form  v_type v_id xkb_kb_raim_qty  with frame d  width 80 attr-space .

form
   tag_nbr       colon 20
   skip(1)
   tag_site      colon 20
   si_desc       no-label
   tag_loc       colon 20
   loc_desc      no-label
   tag_part      colon 20
   pt_um
   in_abc
   pt_desc1      colon 20
   pt_desc2      at 22 no-label
   tag_serial    colon 20
   tag_ref
   skip(1)
   tag_cnt_qty   colon 20
   tag_rcnt_qty  colon 50
   tag_cnt_um    colon 20
   tag_rcnt_um   colon 50
   tag_cnt_cnv   colon 20
   tag_rcnt_cnv  colon 50
   tag_cnt_nam   colon 20
   tag_rcnt_nam  colon 50
   tag_cnt_dt    colon 20
   tag_rcnt_dt   colon 50
   skip(1)
   tag_rmks      colon 20
with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

mainloop:
repeat with frame a:

   prompt-for tag_nbr
   editing:

      /* FIND NEXT/PREVIOUS RECORD */
      {mfnp.i tag_mstr tag_nbr  " tag_mstr.tag_domain = global_domain and
      tag_nbr "  tag_nbr tag_nbr tag_nbr}

      if recno <> ? then do:
         find pt_mstr  where pt_mstr.pt_domain = global_domain and  pt_part =
         tag_part no-lock no-error.
         find in_mstr  where in_mstr.in_domain = global_domain and  in_part =
         tag_part and in_site = tag_site
         no-lock no-error.

         find si_mstr   where si_mstr.si_domain = global_domain and  si_site =
         tag_site no-lock no-error.
         find loc_mstr  where loc_mstr.loc_domain = global_domain and  loc_site
         = tag_site
                         and loc_loc = tag_loc no-lock no-error.

         display
            tag_nbr
            tag_site
            tag_loc
            tag_part.

         if available pt_mstr then
         display
            pt_um
            pt_desc1
            pt_desc2.

         else
         display
            "" @ pt_um
            "" @ pt_desc1
            "" @ pt_desc2.

         if available in_mstr then
            display in_abc.
         else
            display "" @ in_abc.

         if available si_mstr then
            display si_desc.
         else
            display "" @ si_desc.

         if available loc_mstr then
            display loc_desc.
         else
            display "" @ loc_desc.

         display
            tag_serial
            tag_ref
            tag_cnt_qty
            tag_cnt_um
            tag_cnt_cnv
            tag_cnt_nam
            tag_cnt_dt
            tag_rmks.

      end.  /* IF RECNO <> ? */

   end. /* PROMPT-FOR... EDITING */

find tag_mstr using  tag_nbr where tag_mstr.tag_domain = global_domain
exclusive-lock no-error.
   if not available tag_mstr then do:
      {pxmsg.i &MSGNUM=281 &ERRORLEVEL=3} /* TAG RECORD DOES NOT EXIST */
      undo mainloop, retry.
   end.

   if tag_void then do:
      {pxmsg.i &MSGNUM=710 &ERRORLEVEL=3} /* TAG RECORD HAS BEEN VOIDED */
      undo mainloop, retry.
   end.

/*    if tag_posted then do:                                            */
/*       {pxmsg.i &MSGNUM=4100 &ERRORLEVEL=3} /* TAG HAS BEEN POSTED */ */
/*       undo mainloop, retry.                                          */
/*    end.                                                              */

   find pt_mstr  where pt_mstr.pt_domain = global_domain and  pt_part =
   tag_part no-lock no-error.
   find in_mstr  where in_mstr.in_domain = global_domain and  in_part =
   tag_part and in_site = tag_site
   no-lock no-error.
   find si_mstr   where si_mstr.si_domain = global_domain and  si_site =
   tag_site no-lock no-error.
   find loc_mstr  where loc_mstr.loc_domain = global_domain and  loc_site =
   tag_site and loc_loc = tag_loc
   no-lock no-error.

   display
      tag_nbr
      tag_site
      tag_loc
      tag_part.

   {gprun.i ""gpsiver.p""
      "(input tag_site, input ?, output return_int)"}
   if return_int = 0 then do:
      {pxmsg.i &MSGNUM=725 &ERRORLEVEL=3}
      /* USER DOES NOT HAVE ACCESS TO SITE */
      undo mainloop, retry.
   end.

   if available pt_mstr then
      display
         pt_um
         pt_desc1
         pt_desc2.
   else
      display
         "" @ pt_um
         "" @ pt_desc1
         "" @ pt_desc2.

   if available in_mstr then
      display in_abc.
   else
      display "" @ in_abc.
   if available si_mstr then
      display si_desc.
   else
      display "" @ si_desc.
   if available loc_mstr then
      display loc_desc.
   else
      display "" @ loc_desc.

   display
      tag_serial
      tag_ref
      tag_cnt_qty
      tag_cnt_um
      tag_cnt_cnv
      tag_cnt_nam
      tag_cnt_dt
      tag_rmks.

   if tag_type = "B" then do:
      tagloop:
      do on error undo, retry:

         /* BEGIN OF NEW CODE FOR NEXT PREVIOUS CAPABILITY     */
         prompt-for tag_site
         editing:
            /* FIND NEXT/ PREVIOUS USING SITE MASTER        */
            {mfnp.i si_mstr tag_site  " si_mstr.si_domain = global_domain and
            si_site "  tag_site si_site
               si_site}
            if recno <> ? then do:
               tag_site = si_site.
               display tag_site si_desc.
            end.   /* END IF RECNO <> ?  */
         end.      /* END TAG_SITE EDITING           */

         tag_site = input tag_site.
         find si_mstr  where si_mstr.si_domain = global_domain and  si_site =
         tag_site  no-lock no-error.
         if available si_mstr then
            display si_desc.
         else
            display "" @ si_desc.
         global_site = tag_site.

         prompt-for tag_loc
         editing:
            /* FIND NEXT/ PREVIOUS USING LOCATION MASTER    */
            {mfnp01.i loc_mstr tag_loc loc_loc
               "input tag_site"  " loc_mstr.loc_domain = global_domain and
               loc_site "  loc_loc}
            if recno <> ? then do:
               tag_loc = loc_loc.
               display tag_loc loc_desc.
            end.
         end.

         tag_loc = input tag_loc.
         find first loc_mstr  where loc_mstr.loc_domain = global_domain and
         loc_site = tag_site
                               and loc_loc = tag_loc
         no-lock no-error.

         if available loc_mstr then
            display loc_desc.
         else
            display "" @ loc_desc.


         {gprun.i ""gpsiver.p""
            "(input tag_site, input ?, output return_int)"}
         if return_int = 0 then do:
            /* USER DOES NOT HAVE ACCESS TO SITE */
            {pxmsg.i &MSGNUM=725 &ERRORLEVEL=3}
            next-prompt tag_site.
            undo tagloop, retry.
         end.

         /* IF SITE MASTER AUTO LOCATIONS IS YES, THEN LOCATION IS OPTIONAL */
         /* OTHERWISE LOCATION MUST BE IN LOCATION MASTER                   */
         if not available loc_mstr then do:
            if available si_mstr and si_auto_loc then do:
               {pxmsg.i &MSGNUM=709 &ERRORLEVEL=2}
               /* WARNING: LOCATION DOES NOT EXIST */
            end.
            else do:
               {pxmsg.i &MSGNUM=709 &ERRORLEVEL=3}
               /* ERROR: LOCATION DOES NOT EXIST */
               next-prompt tag_loc.

               undo tagloop, retry.
            end.
         end.  /* IF NOT CAN-FIND LOC_MSTR */

         /* NEW CODE FOR PART NEXT/PREVIOUS PROCESSING     */
         prompt-for
            tag_part tag_serial tag_ref
         editing:
            {mfnp.i pt_mstr tag_part  " pt_mstr.pt_domain = global_domain and
            pt_part "  tag_part pt_part
               pt_part}
            if recno <> ? then do:
               tag_part = pt_part.
               display tag_part pt_um pt_desc1 pt_desc2.
               find in_mstr  where in_mstr.in_domain = global_domain and
               in_part = tag_part
                              and in_site = tag_site
               no-lock no-error.
               if available in_mstr then
                  display in_abc.
               else
                  display "" @ in_abc.
            end.
            else tag_part = input tag_part.
         end.

         if batchrun then tag_part = input tag_part.

         assign
            global_part = input tag_part
            tag_serial  = input tag_serial
            tag_ref     = input tag_ref.

         find pt_mstr  where pt_mstr.pt_domain = global_domain and  pt_part =
         tag_part no-lock no-error.
         if not available pt_mstr then do:
            {pxmsg.i &MSGNUM=16 &ERRORLEVEL=3}  /* ITEM NUMBER DOES NOT EXIST */
            next-prompt tag_part.

            undo tagloop, retry.
         end.

         if index("LS",pt_lot_ser) > 0 and tag_serial = "" then do:
            {pxmsg.i &MSGNUM=1119 &ERRORLEVEL=3}
            /* LOT SERIAL NUMBER REQUIRED */
            next-prompt tag_serial.
            undo tagloop, retry.
         end.

         if (tag_serial <> "") then do:
            {gprun.i ""gpltfnd.p""
               "(tag_part,
                 tag_serial,
                 """",
                 """",
                 """",
                 output trans-ok)"}
            if not trans-ok then do:
               next-prompt tag_serial.
               undo tagloop, retry.
            end. /* IF NOT TRANS-OK */
         end. /* IF TAG_SERIAL <> "" */

         /* CHECK FOR INV MASTER. IF NO INV MASTER THEN PROGRAM CAN SET ONE UP */
         find in_mstr  where in_mstr.in_domain = global_domain and  in_part =
         tag_part and
                            in_site = tag_site
         no-lock no-error.

         if not available in_mstr then do:

            if not batchrun then do:
               /*ITEM NOT FOUND AT SITE. OK TO ADD */
               {pxmsg.i &MSGNUM=810 &ERRORLEVEL=2 &CONFIRM=yn}
               if not yn then undo, retry.
            end.

            /* USE CSINCR.P TO CREATE A NEW IN_MSTR RECORD */
            {gprun.i ""csincr.p"" "(tag_part, tag_site)"}

            find in_mstr  where in_mstr.in_domain = global_domain and  in_site
            = tag_site and
                               in_part = tag_part no-lock.

            /*INV MSTR CREATED AT SITE*/
            {pxmsg.i &MSGNUM=811 &ERRORLEVEL=1 &MSGARG1=tag_site}

         end.  /* NOT AVAIL IN_MSTR DO */

         display
            pt_um
            in_abc when (available in_mstr)
            pt_desc1
            pt_desc2.

      end.  /* TAGLOOP: */

   end.  /* IF TAG_TYPE = "B" */

   else do:
      {gprun.i ""gpsiver.p""
         "(input tag_site, input ?, output return_int)"}
      if return_int = 0 then do:
         /* USER DOES NOT HAVE ACCESS TO SITE */
         {pxmsg.i &MSGNUM=725 &ERRORLEVEL=3}
         undo mainloop, retry.
      end.
   end.

   ststatus = stline[3].
   status input ststatus.

   new_count = no.

   if tag_cnt_dt = ? then
      assign
         tag_cnt_um  = pt_um
         tag_cnt_cnv = 1
         tag_cnt_dt  = new_date
         tag_cnt_nam = new_name
         new_count   = yes.

   /* THE FOLLOWING CODE ENSURES THAT FOR SERIAL CONTROLLED ITEMS */
   /* THE QUANTITY COUNTED IS NOT LESSER THAN -1 AND NOT GREATER  */
   /* THAN 1 AND THE COUNT UM IS THE SAME AS THAT ENTERED IN THE  */
   /* ITEM MASTER                                                 */
   if available pt_mstr and
      pt_lot_ser = "S"
   then do on error undo, retry:

      update
         tag_cnt_qty
         tag_cnt_um.

      /* QUANTITY COUNTED VALIDATION */
      if (tag_cnt_qty < -1)
      or (tag_cnt_qty >  1)
      then do:
         /* QUANTITY MUST BE -1, 0 OR 1 */
         {pxmsg.i &MSGNUM=4562 &ERRORLEVEL=3}
         undo, retry.
      end. /* IF tag_cnt_qty < -1 */

      /* COUNT UM VALIDATION */
      if tag_cnt_um <> pt_um
      then do:
         /* UM MUST BE EQUAL TO STOCKING   */
         /* UM FOR SERIAL-CONTROLLED ITEMS */
         {pxmsg.i &MSGNUM=367 &ERRORLEVEL=3}
         undo, retry.
      end. /* IF tag_cnt_um <> pt_um */

   end. /* IF AVAILABLE pt_mstr */

   else
      update
         tag_cnt_qty
         tag_cnt_um.

   {mfumcnv.i tag_cnt_um tag_part tag_cnt_cnv}

   /*xp001*/
   clear frame c all no-pause .
   clear frame d all no-pause .
   
   kbloop:
   do on error undo, retry:
       find first wc_mstr where wc_domain = global_domain and wc_wkctr = tag_loc no-lock no-error .
       if not avail wc_mstr then do: /*非车间库位*/
           v_qty_kb = 0 .
           find first xmpt_mstr where xmpt_domain =global_domain and xmpt_site = tag_site and xmpt_part = tag_part no-lock no-error .
           find first xppt_mstr where xppt_domain =global_domain and xppt_site = tag_site and xppt_part = tag_part no-lock no-error .
           if ( avail xmpt_mstr ) or  ( avail xppt_mstr ) then do:

               view frame c .
               view frame d .


               for each xkb_mstr where xkb_domain =global_domain and xkb_site = tag_site and xkb_loc = tag_loc 
                   and xkb_lot = tag_serial and xkb_ref = tag_ref and xkb_status = "U" and xkb_part = tag_part  no-lock :
                   disp xkb_type xkb_kb_id  xkb_kb_raim_qty  with frame c .
                   down 1 with frame c .
                   v_qty_kb = v_qty_kb  + xkb_kb_raim_qty  .
               end.
    
               if v_qty_kb = tag_cnt_qty then do:
                   message "看板信息全部正确?" view-as alert-box
                           question buttons yes-no title "" update choice AS logical.
                   if choice then do:
                       for each xkb_mstr where xkb_domain =global_domain and xkb_site = tag_site and xkb_loc = tag_loc
                           and xkb_lot = tag_serial and xkb_ref = tag_ref  and xkb_status = "U" and xkb_part = tag_part  exclusive-lock:
                           assign xkb_qty_cnt = xkb_kb_raim_qty xkb_cnt_date = today .
                       end.
                   end.
                   else do:
                       setline:
                       repeat:
                           
                           clear frame d all no-pause .
                    
                           assign  v_type = "" v_id  = 0 qty_raim_old = 0 .
                           update v_type v_id with frame d  .
                    
                    
                           find xkb_mstr where xkb_domain =global_domain and xkb_site = tag_site and xkb_loc = tag_loc
                               and xkb_lot = tag_serial and xkb_ref = tag_ref  and xkb_status = "U"
                               and xkb_type = v_type and xkb_kb_id = v_id and xkb_part = tag_part exclusive-lock no-error .
                           if avail xkb_mstr then do:
                               disp xkb_type @ v_type
                                    xkb_kb_id @ v_id
                                    xkb_kb_raim_qty with frame d.
                               assign qty_raim_old = xkb_kb_raim_qty .
                    
                               update xkb_kb_raim_qty with frame d .

                                if xkb_kb_id <> 000  and xkb_kb_id <> 999  then do:                                    
                                    if v_type = "M" then do:
                                        find xmpt_mstr where xmpt_domain = global_domain and xmpt_site = xkb_site and xmpt_part = xkb_part no-lock no-error .
                                        v_fqty = if avail xmpt_mstr then xmpt_kb_fqty else 0  .
                                        v_qty_firm = if avail xmpt_mstr then xmpt_qty_firm else no .

                                    end.
                                    if v_type = "P" then do:
                                        find xppt_mstr where xppt_domain = global_domain and xppt_site = xkb_site and xppt_part = xkb_part no-lock no-error .
                                        v_fqty = if avail xppt_mstr then xppt_kb_fqty else 0  .
                                        v_qty_firm = if avail xppt_mstr then xppt_qty_firm else no .
                                    end.
    
                                    if (xkb_kb_raim_qty ) > xkb_kb_qty then do:
                                        message "超过看板容量"  .
                                        if v_qty_firm = yes then undo , retry.
                                    end.
                                end.  
                    
                               if qty_raim_old <> xkb_kb_raim_qty  then do:
                                   assign xkb_qty_cnt = xkb_kb_raim_qty xkb_cnt_date = today .
                    
                                   v_trnbr = 0 .
                                   {xxkbhist.i  &type="xkb_type"      &part="xkb_part"      &site="xkb_site"
                                                &kb_id="xkb_kb_id"    &effdate=today        &program="'mhjit045.p'"
                                                &qty="xkb_kb_qty"     &ori_qty="qty_raim_old" &tr_trnbr="v_trnbr"
                                                &b_status="xkb_status"       &c_status="xkb_status"
                                                &rain_qty="xkb_kb_raim_qty"}
                                    if xkb_kb_raim_qty = 0 then do:
                                         {xxkbhist.i &type="xkb_type"      &part="xkb_part"      &site="xkb_site"
                                                &kb_id="xkb_kb_id"    &effdate=today        &program="'mhjit045.p'"
                                                &qty="xkb_kb_qty"     &ori_qty="qty_raim_old" &tr_trnbr="v_trnbr"
                                                &b_status="'U'"       &c_status="'A'"
                                                &rain_qty="xkb_kb_raim_qty"}  
                                    end.                                                 
                               end.                                   
                           end.
                           else do :
                                 message "无对应记录,请重新输入.".
                           end.
                    
                           clear frame c all no-pause .
                           v_qty_kb = 0  .
                           for each xkb_mstr where xkb_domain =global_domain and xkb_site = tag_site and xkb_loc = tag_loc
                               and xkb_lot = tag_serial and xkb_ref = tag_ref and xkb_status = "U" and xkb_part = tag_part no-lock :
                               disp xkb_type xkb_kb_id xkb_kb_raim_qty skip with frame c .
                               down 1 with frame c .
                               v_qty_kb = v_qty_kb  + xkb_kb_raim_qty  .
                           end.
                           if v_qty_kb = tag_cnt_qty  then do:
                               message "确认保存?" update choice2 as logical.
                               if choice2 then leave .
                           end.
                           else do:
                               message "看板库存与盘点信息不一致,请修改对应记录" .
                           end.
                       end. /* SETLINE:*/
                   end.
               end.    /* if v_qty_kb = tag_cnt_qty */
               else do:
                   message "看板库存与盘点信息不一致,请修改对应记录" .
                  
                   setline: 
                   repeat:
                       clear frame d all no-pause .

                
                       assign  v_type = "" v_id  = 0 qty_raim_old = 0  .
                       update v_type v_id with frame d  .
                
                       find xkb_mstr where xkb_domain =global_domain and xkb_site = tag_site and xkb_loc = tag_loc
                           and xkb_lot = tag_serial and xkb_ref = tag_ref  and xkb_status = "U"
                           and xkb_type = v_type and xkb_kb_id = v_id and xkb_part = tag_part exclusive-lock no-error .
                       if avail xkb_mstr then do:
                           disp xkb_type @ v_type
                                xkb_kb_id @ v_id
                                xkb_kb_raim_qty with frame d.
                           assign qty_raim_old = xkb_kb_raim_qty .
                
                           update xkb_kb_raim_qty with frame d .

                                if xkb_kb_id <> 000  and xkb_kb_id <> 999  then do:                                    
                                    if v_type = "M" then do:
                                        find xmpt_mstr where xmpt_domain = global_domain and xmpt_site = xkb_site and xmpt_part = xkb_part no-lock no-error .
                                        v_fqty = if avail xmpt_mstr then xmpt_kb_fqty else 0  .
                                        v_qty_firm = if avail xmpt_mstr then xmpt_qty_firm else no .

                                    end.
                                    if v_type = "P" then do:
                                        find xppt_mstr where xppt_domain = global_domain and xppt_site = xkb_site and xppt_part = xkb_part no-lock no-error .
                                        v_fqty = if avail xppt_mstr then xppt_kb_fqty else 0  .
                                        v_qty_firm = if avail xppt_mstr then xppt_qty_firm else no .
                                    end.
    
                                    if (xkb_kb_raim_qty ) > xkb_kb_qty then do:
                                        message "超过看板容量"  .
                                        if v_qty_firm = yes then undo , retry.
                                    end.
                                end.                           
                
                           if qty_raim_old <> xkb_kb_raim_qty  then do:
                               assign xkb_qty_cnt = xkb_kb_raim_qty xkb_cnt_date = today .
                
                               
                               v_trnbr = 0 .
                               {xxkbhist.i  &type="xkb_type"      &part="xkb_part"      &site="xkb_site"
                                            &kb_id="xkb_kb_id"    &effdate=today        &program="'mhjit045.p'"
                                            &qty="xkb_kb_qty"     &ori_qty="qty_raim_old" &tr_trnbr="v_trnbr"
                                            &b_status="xkb_status"       &c_status="xkb_status"
                                            &rain_qty="xkb_kb_raim_qty"}
                                            
                                if xkb_kb_raim_qty = 0 then do:
                                     {xxkbhist.i &type="xkb_type"      &part="xkb_part"      &site="xkb_site"
                                            &kb_id="xkb_kb_id"    &effdate=today        &program="'mhjit045.p'"
                                            &qty="xkb_kb_qty"     &ori_qty="qty_raim_old" &tr_trnbr="v_trnbr"
                                            &b_status="'U'"       &c_status="'A'"
                                            &rain_qty="xkb_kb_raim_qty"}  
                                end.  
                           end.                                   
                       end.
                       else do:
                                message "无对应记录,请重新输入.".
                       end.
                
                       clear frame c all no-pause .
                       v_qty_kb = 0  .
                       for each xkb_mstr where xkb_domain =global_domain and xkb_site = tag_site and xkb_loc = tag_loc
                           and xkb_lot = tag_serial and xkb_ref = tag_ref and xkb_status = "U" and xkb_part = tag_part no-lock :
                           disp xkb_type xkb_kb_id xkb_kb_raim_qty skip with frame c .
                           down 1 with frame c .
                           v_qty_kb = v_qty_kb  + xkb_kb_raim_qty  .
                       end.
                       if v_qty_kb = tag_cnt_qty  then do:
                           message "确认保存?" update choice3 as logical.
                           if choice3 then leave .
                       end.
                       else do:
                           message "看板库存与盘点信息不一致,请修改对应记录" .
                       end.
                   end. /* SETLINE:  */
               end.

           end.  /* if ( avail */
           else do:
               hide frame c no-pause.
               hide frame d no-pause .
               view frame a .
               leave kbloop .
           end.
       end.   /*非车间库位*/
   end. /*kbloop*/

   clear frame c all no-pause .
   clear frame d all no-pause .
   message "" .
   message "" .

   /*xp001*/

   setcnt:
   do on error undo, retry:

      update
         tag_cnt_cnv
         tag_cnt_nam
         tag_cnt_dt
         tag_rmks.

      if tag_cnt_dt = ? then do:
         /* Date Required */
         {pxmsg.i &MSGNUM=711 &ERRORLEVEL=3}
         next-prompt tag_cnt_dt.
         undo setcnt, retry.
      end.

      if new_count then
         assign
            new_name = tag_cnt_nam
            new_date = tag_cnt_dt.

   end. /* SETCNT */

end. /* MAINLOOP */

