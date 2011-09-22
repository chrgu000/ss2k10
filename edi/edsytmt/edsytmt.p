/* edsytmt.p -  sync template MAINTENANCE                                    */
/* revision: 110712.1   created on: 20110712   by: zhang yun                 */
/* revision: 110725.1   modify  on: 20110725   by: SamSong                   */
/* revision: 20110726     Add Schedule By SamSong                            */
/* revision: 20110728     Add delete data from master form                   */

/*V8:ConvertMode=Maintenance                                                 */
/* Environment: Progress:10.1C04  QAD:eb21sp7    Interface:Character         */
/*-Revision end--------------------------------------------------------------*/

/* DISPLAY TITLE */
{mfdtitle.i "110728.1"}
{gplabel.i}
define variable del-yn like mfc_logical initial no.
/* DISPLAY SELECTION FORM */

form
   syt_nbr        colon 15
   syt_program    colon 45  format "x(12)"
   syt_havedomain colon 72

   syt_Sdomain    colon 15
   syt_Tdomain    colon 45
   syt_active     colon 72
   syt_desc       colon 15
/*   skip(1)  */
   syt_table      colon 15
   syt_tagfield   colon 45 format "X(12)"

   syt_fromval    colon 15
   syt_sucval     colon 45
   syt_failval    colon 72


   syt_condition1 colon 15 format "x(58)"
   syt_condition2 colon 15 format "x(58)"

   syt_errorfield colon 15 format "x(12)"
   syt_updname    colon 45 format "x(12)"
   syt_runseq     colon 72

   syt_lupddate   colon 15
   syt_lupdtime   colon 45 format "99999"
  /* syt_updtimereset colon 58  */
   syt_updint     colon 72 format "999999"

with frame a side-labels width 80 attr-space.
/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

form
   sytd_seq        colon 15 format "999999"
   "Àý:120130(12=»»ÆÁ,0=Ô¤Áô,13=×Ö¶Î,0=Ô¤Áô)" view-as text
   sytd_Tdata      colon 15
   sytd_Sdata      colon 15
   sytd_acceptDefault colon 72
   sytd_condition1 colon 15 format "x(58)"
   sytd_condition2 colon 15 format "x(58)"
   sytd_action     colon 15
   sytd_ischar     colon 35
   "ÈÕÆÚ,Âß¼­,Êý×Ö¾ùÎªNo,½ö×Ö·ûÎªYes." view-as text
with frame b side-labels width 80 attr-space.
setFrameLabels(frame b:handle).


repeat with frame a:

   prompt-for syt_nbr syt_program syt_Sdomain syt_Tdomain editing:

      /* FIND NEXT/PREVIOUS RECORD   */
      if frame-field = "syt_Sdomain" then do:
        {mfnp.i dom_mstr syt_Sdomain dom_domain syt_Sdomain
              dom_domain dom_domain}
         if recno <> ? then do:
            display dom_domain @ syt_Sdomain.
         end.
      end.
      else if frame-field = "syt_Tdomain" then do:
        {mfnp.i dom_mstr syt_Tdomain dom_domain syt_Tdomain
              dom_domain dom_domain}
         if recno <> ? then do:
            display dom_domain @ syt_Tdomain.
         end.
      end.
      else do:
          {mfnp07.i syt_mstr syt_nbr syt_nbr syt_program syt_program
                    syt_sdomain syt_sdomain syt_tdomain syt_tdomain syt_nbr}
          if recno <> ? then do:
                display syt_nbr syt_program syt_Sdomain syt_Tdomain
                        syt_desc syt_table syt_tagfield syt_active
                        syt_condition1 syt_condition2
                        syt_havedomain syt_fromval syt_sucval
                        syt_failval syt_ErrorField
                        syt_runseq syt_updname
                        syt_lupddate
                        syt_lupdtime
/*      syt_updtimereset   */
     									  syt_updint.
     						clear frame b.
     		  end.
       end.
   end.

   if input syt_nbr = "" then do:
      {pxmsg.i &MSGNUM=8875 &ERRORLEVEL=3}
      undo, retry.
   end.

   if input syt_program = "" then do:
      {pxmsg.i &MSGNUM=4452 &ERRORLEVEL=3 &MSGARG1=""program""}
      undo, retry.
   end.
/*  For eb2.1 pre version
   if not can-find(first dom_mstr no-lock where
                         dom_domain = input syt_sdomain)
      then do:
      {pxmsg.i &MSGNUM=6135 &ERRORLEVEL=3}
      undo, retry.
   end.

   if not can-find(first dom_mstr no-lock where
                         dom_domain = input syt_tdomain)
      then do:
      {pxmsg.i &MSGNUM=6135 &ERRORLEVEL=3}
      undo, retry.
   end.

   if input syt_sdomain = input syt_tdomain then do:
       {pxmsg.i &MSGNUM=6135 &ERRORLEVEL=3}
      undo, retry.
   end.
*/

   /* ADD/MOD/DELETE  */
   find syt_mstr where syt_nbr = input syt_nbr and
                       syt_program = input syt_program and
                       syt_sdomain = input syt_sdomain and
                       syt_tdomain = input syt_tdomain
                       no-error.
   if not available syt_mstr then do:
      {mfmsg.i 1 1}
      create syt_mstr.
      assign syt_nbr syt_program syt_sdomain syt_tdomain.
   end.
   recno = recid(syt_mstr).

   display syt_nbr syt_program syt_sdomain syt_tdomain.

   ststatus = stline[2].
   status input ststatus.
   del-yn = no.

   do on error undo, retry:
      set syt_havedomain syt_active syt_desc
          syt_table syt_tagfield
          syt_fromval syt_sucval syt_failval
          syt_condition1 syt_condition2
          syt_ErrorField
          syt_updname syt_runseq
          syt_lupddate
          syt_lupdtime
          /*    syt_updtimereset   */
          syt_updint go-on(F5 CTRL-D).

          /* DELETE */
          if lastkey = keycode("F5") or lastkey = keycode("CTRL-D")
          then do:
             del-yn = yes.
             {mfmsg01.i 11 1 del-yn}
             if not del-yn then undo, retry.
             /* delete sytd_det*/
             for each sytd_det exclusive-lock where
                      sytd_nbr = syt_nbr and
                      sytd_program = syt_program and
                      sytd_sdomain = syt_sdomain and
                      sytd_tdomain = syt_tdomain :
                  delete sytd_det.
             end.
             delete syt_mstr.
             clear frame a.
             clear frame b.
             del-yn = no.
          end.

   end.

   loopdet:
   repeat:
   do with frame b on error undo, retry:
       prompt-for sytd_seq editing:
         {mfnp.i sytd_det sytd_seq " sytd_nbr = input syt_nbr and
                 sytd_program = input syt_program and
                 sytd_sdomain = input syt_sdomain and
                 sytd_tdomain = input syt_tdomain and input sytd_seq "
                 sytd_seq sytd_seq sytd_nbr}
          if recno <> ? then do:
             display sytd_seq sytd_Tdata sytd_Sdata
               sytd_acceptDefault
                     sytd_condition1 sytd_condition2
                     sytd_action sytd_ischar with frame b.
          end.
/*          else do:                                                    */
/*             if input sytd_seq = 0 then do:                           */
/*                for last sytd_det no-lock where                       */
/*                         sytd_nbr = input syt_nbr and                 */
/*                         sytd_program = input syt_program and         */
/*                         sytd_sdomain = input syt_sdomain and         */
/*                         sytd_tdomain = input syt_tdomain             */
/*                         break by sytd_seq:                           */
/*                 end.                                                 */
/*                 if available sytd_det then do:                       */
/*                    display sytd_seq + 100 @ sytd_seq.                */
/*                 end.                                                 */
/*             end.                                                     */
/*          end.                                                        */
       end.
      if input sytd_seq < 100000 or input sytd_seq > 999999 then do:
         {pxmsg.i &MSGNUM=8910 &ERRORLEVEL=3 &MSGARG1=100000 &MSGARG2=999999}
         undo, retry .
      end.
       /* ADD/MOD/DELETE  */
       find sytd_det where sytd_nbr = input syt_nbr and
                           sytd_program = input syt_program and
                           sytd_sdomain = input syt_sdomain and
                           sytd_tdomain = input syt_tdomain and
                           sytd_seq = input sytd_seq
                           no-error.
       if not available sytd_det then do:
          {mfmsg.i 1 1}
          create sytd_det.
          assign sytd_nbr = input syt_nbr
                 sytd_program = input syt_program
                 sytd_sdomain = input syt_sdomain
                 sytd_tdomain = input syt_tdomain
                 sytd_seq.
       end.
       recno = recid(sytd_det).

       display sytd_seq sytd_Tdata sytd_Sdata
               sytd_acceptDefault
               sytd_condition1 sytd_condition2 sytd_action sytd_ischar.
       ststatus = stline[2].
       status input ststatus.
       del-yn = no.

       do on error undo, retry:
          set sytd_Tdata sytd_Sdata sytd_acceptDefault
              sytd_condition1 sytd_condition2
              sytd_action sytd_ischar go-on(F5 CTRL-D).

          /* DELETE */
          if lastkey = keycode("F5") or lastkey = keycode("CTRL-D")
          then do:
             del-yn = yes.
             {mfmsg01.i 11 1 del-yn}
             if not del-yn then undo, retry.
             delete sytd_det.
             clear frame b.
             del-yn = no.
          end.
       end.
   end. /**do with frame b on error undo, retry:*/
   end.  /*   loopdet: */
end. /*do with frame a on error undo, retry: */
status input.
