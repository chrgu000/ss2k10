/* xxporp01.p   *********** PURCHASE ORDER PRINT                      */
/* Copyright 2004-2004 PegSoft GZ                                     */
/* All rights reserved worldwide.  This is an unpublished work.       */
/* create by Kaine Zhang      08/09/04                                */
/* zy change sort integer(usrw_key2)                                  */

    {mfdtitle.i "120727.1"}
    DEFINE VARIABLE part like pt_part.
    DEFINE VARIABLE part1 like pt_part .
    DEFINE VARIABLE vvend like po_vend .
    DEFINE VARIABLE eff like tr_effdate .
    DEFINE VARIABLE num as char .
    DEFINE VARIABLE V1500 AS CHAR FORMAT "x(25)" INIT "".  /*  LOT */
    DEFINE VARIABLE V1300 LIKE pt_part .
    DEFINE VARIABLE V1002 LIKE ld_site . /*  PART */
    DEFINE VARIABLE site like in_site.
    DEFINE VARIABLE loc like in_site.
    DEFINE VARIABLE tdate1 as char.
    DEF TEMP-TABLE tmp0
        field tmp0_loc like loc_loc.

    DEF TEMP-TABLE tmp1
        field tmp_loc like loc_loc
        FIELD tmp_part  LIKE pt_part
        FIELD tmp_desc as char format "x(48)"
        FIELD tmp_lot   as char format "x(18)"
        FIELD tmp_lot_qty as char format "x(12)"
        FIELD tmp_um  like pt_um
        FIELD tmp_vend  LIKE po_vend
        FIELD tmp_life  as char
        FIELD tmp_create  as char format "x(8)"
        FIELD tmp_enter as char format "x(8)"
        FIELD tmp_eff as char format "x(8)"
        FIELD tmp_num as char
        field tmp_status as char format "x(20)"
        FIELD tmp_result  as char format "x(10)"
        FIELD tmp_rmk as char format "x(20)".
        .

FORM
    SKIP(1)
          site  COLON 15
          loc   COLON 15
          part  COLON 15 part1   COLON 49

  WITH FRAME a SIDE-LABELS WIDTH 80 attr-space.
  setFrameLabels(FRAME a:HANDLE).
       view frame a.


  {wbrp01.i}
REPEAT ON ENDKEY UNDO, LEAVE:
    hide all no-pause .
    view frame dtitle .

   if part1 = hi_char then part1 = "".

   do on error undo, retry with frame a:
    update site
      with frame a .

      if site="" then do:
/*        message "Error: You Must Enter Site ,Please re-enter".             */
/*        {mfmsg.i 709 3 3}                                                  */
         {mfmsg.i 941 3}
         next-prompt site with frame a.
         undo, retry.
      end.
      if not can-find(first si_mstr no-lock where si_site = site) then do:
        {mfmsg.i 708 3}
         next-prompt site with frame a.
         undo, retry.
      end.

    end. /* do on error u */
   do on error undo, retry with frame a:
      update loc
      with frame a .

      if loc<>"" then do:
            find first loc_mstr where loc_loc = loc and loc_site= input site
            no-lock no-error.
        if not available loc_mstr then do:
           {mfmsg.i 709 3 3}
           next-prompt loc with frame a.
           undo, retry.
        end.
        else do:
           if lookup(global_userid, loc_user1) = 0 then do:
/*message "錯誤: 用戶 " + global_userid + " 無權限訪問此庫位，請重新輸入!".*/
           {pxmsg.i &MSGNUM=7765
                    &MSGARG1=global_userid
                    &ERRORLEVEL=3}
        next-prompt loc with frame a.

        undo, retry.
           end.
           /* else leave. */
        end.
    end.

    end. /* do on error u */


    IF c-application-mode <> 'web':u THEN
        UPDATE part part1 WITH FRAME a.

    {wbrp06.i &command = UPDATE
        &fields = "     part part1 "
        &frm = "a"}

    IF (c-application-mode <> 'web':u) OR
        (c-application-mode = 'web':u AND
        (c-web-request begins 'data':u)) THEN DO:

         /*if site ="" then do:
          bell.
          message "Error: You Must Enter Location Code ,Please re-enter".
          undo,retry.
       end. */
    bcdparm = "".
   {mfquoter.i part}
   {mfquoter.i part1}
   {mfquoter.i loc}
   {mfquoter.i site}

   if part1 = "" then part1 = hi_char.

   END.

        {mfselprt.i "printer" 132}

        {mfphead.i}

  if loc="" then do:
      for each loc_mstr where loc_site=site and loc_type<>"" no-lock:
          if lookup(global_userid, loc_user1) <> 0 then do:
             create tmp0.
             assign tmp0_loc=loc_loc.
          end.
      end.
  end.
  else do:
       create tmp0.
       assign tmp0_loc=loc.
  end.

  /* for each tmp0:
   disp tmp0_loc loc site part part1.
  end. */
 for each pt_mstr no-lock where pt_part>=part and pt_part<=part1
                            and pt_lot_ser='L',
     each ld_det no-lock where ld_site=site /*  and ld_loc=loc and */
                           and ld_part=pt_part and ld_qty_oh<>0,
     each tmp0 no-lock where tmp0_loc=ld_loc break by ld_loc by  pt_part:
         find first tr_hist  use-index tr_part_eff where tr_part=pt_part
                and tr_effdate>= 01/01/2000
                and tr_type='rct-po' and ld_lot=tr_serial no-lock no-error.
         if avail tr_hist then do:
              vvend=tr_addr.
              eff=tr_effdate.
         end.
         else do:
              vvend="".
              eff=?.
         end.
         num="".
         tdate1="".
         for each usrw_wkfl where usrw_key1 = pt_part + "@" + ld_lot and
/*       pt_part=ENTRY(1,usrw_key1,"@") and ld_lot=ENTRY(2,usrw_key1,"@") and */
                  usrw_key4='yb' no-lock break by integer(usrw_key2):
             if last-of(integer(usrw_key2)) then do:
                assign  num=usrw_key2
                        tdate1=usrw_key3.
             end.
         end.
         V1500 = ld_lot .
         V1300 = ld_part.
         V1002=ld_site.
        {xsinex01.i}
           /*  column-label "保質期(M)"
              column-label "LOT到期日" */
             if tdate1="" then do:
           if expireinv<>? then tdate1=string(expireinv).
       end.
          CREATE tmp1.
          ASSIGN tmp_loc=ld_loc
                 tmp_part  = pt_part
                 tmp_desc=pt_desc1 + pt_desc2
                 tmp_lot   = ld_lot /* ENTRY(2,usrw_key1,"@") */
                 tmp_lot_qty = string(ld_qty_oh) /* usrw_key5 */
                 tmp_um = pt_um
                 tmp_vend = vvend
                 tmp_life = string(wptavgint)  /* pt_avg_int */
                 tmp_enter = if eff=? then "" else string(eff)
/*               tmp_eff  = if expireinv=? then "" else string(expireinv)*/
                 tmp_eff =  tdate1
                 tmp_num  =num  /* string(usrw_key2) */ .
                 if date(tmp_eff) < today then
                         tmp_result  = getTermLabel("PAST_DUE",12) .
                 if date(tmp_eff) > today + 30 then
                         tmp_result  = "OK" .
                 if date(tmp_eff) >= today and date(tmp_eff) <= today + 30 then
                         tmp_result  = gettermLabel("CLOSED_TO_PAST_DUE",14).
                 if substring(ld_lot,1,1)='c' and length(ld_lot)>=14 then do:
                         tmp_create = string(substring(ld_lot,11,2)  + '/'
                                    + substring(ld_lot,13,2) + '/'
                                    +  substring(ld_lot,9,2)).
                 end.
                 else do:
                     if ld_lot="" or substring(ld_lot,1,6)="000000"
                                  or length(trim(ld_lot))<7  then do:
                        tmp_create ="".
                     end.
                     else do:
                        tmp_create = string(substring(ld_lot,3,2)  + '/'
                                   +  substring(ld_lot,5,2) + '/'
                                   +  substring(ld_lot,1,2)).
                     end.
                 end.
  END.

     for each tmp1 where dec(tmp_lot_qty)<>0 by tmp_loc by tmp_part
              with frame x1 WIDTH 300 :
         Display tmp_loc
                 tmp_part
                 tmp_desc
                 tmp_lot
                 tmp_lot_qty
                 tmp_um
                 tmp_vend
                 tmp_life
                 tmp_create
                 tmp_enter
                 tmp_eff
                 tmp_num
                 tmp_status
                 tmp_result
                 tmp_rmk  .
         setFrameLabels(FRAME x1:HANDLE).
     end.
     FOR EACH tmp1.
              DELETE tmp1 .
     END.
     for each tmp0.
              delete tmp0.
     end.
    {mfreset.i}
    {mfgrptrm.i}

END.

  {wbrp04.i &frame-spec = a}
