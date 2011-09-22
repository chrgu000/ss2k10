/* edsytcp.p - sync template Copy                                            */
/* revision: 110712.1   created on: 20110712   by: zhang yun                 */
/* revision: 110725.1   created on: 20110725   by: SamSong                  */

/*V8:ConvertMode=Maintenance                                                 */
/* Environment: Progress:10.1C04  QAD:eb21sp7    Interface:Character         */
/*-Revision end--------------------------------------------------------------*/

/* DISPLAY TITLE */
{mfdtitle.i "110725.1"}

define variable cp-yn like mfc_logical initial no.
define variable s_nbr     like syt_nbr.
define variable s_program like syt_program.
define variable s_Sdomain like syt_Sdomain.
define variable s_Tdomain like syt_Tdomain.

define variable d_nbr     like syt_nbr.
define variable d_program like syt_program.
define variable d_Sdomain like syt_Sdomain.
define variable d_Tdomain like syt_Tdomain.
define variable d_acceptdefault like sytd_acceptdefault.
define variable b-copy as logical.
define buffer sytm for syt_mstr.
define buffer sytd for sytd_det.

/* DISPLAY SELECTION FORM */

form
   s_nbr     colon 15
   d_nbr     colon 55
   s_program colon 15
   d_program colon 55
   s_Sdomain colon 15
   d_Sdomain colon 55
   s_Tdomain colon 15
   d_Tdomain colon 55
   d_acceptdefault colon 55 skip(1)
   b-copy    colon 55
with frame a side-labels width 80.
/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

form
   syt_desc       colon 15
/*   skip(1)  */
   syt_table      colon 15
   syt_tagfield   colon 45 format "X(12)"

   syt_fromval    colon 15
   syt_sucval     colon 45
   syt_failval    colon 68


   syt_condition1 colon 15 format "x(58)"
   syt_condition2 colon 15 format "x(58)"

   syt_errorfield colon 15 format "x(12)"
   syt_updname    colon 45 format "x(12)"
   syt_runseq     colon 68

   syt_lupddate   colon 15
   syt_lupdtime   colon 45 format "99999"
  /* syt_updtimereset colon 58  */
   syt_updint     colon 68 format "999999"

with frame b title color normal (getFrameTitle("DETAIL",24))
side-labels width 80 attr-space.
/* SET EXTERNAL LABELS */
setFrameLabels(frame b:handle).

/* DISPLAY */
repeat with frame a:
   prompt-for s_nbr s_program s_Sdomain s_Tdomain
             d_nbr d_program d_Sdomain d_Tdomain d_acceptdefault editing:
     /* FIND NEXT/PREVIOUS RECORD */
     if frame-field = "s_nbr" then do:
      {mfnp.i syt_mstr s_nbr syt_nbr s_nbr syt_nbr syt_nbr}
        if recno <> ? then do:
           display syt_nbr @ s_nbr
                   syt_program @ s_program
                   syt_SDomain @ s_Sdomain
                   syt_tDomain @ s_Tdomain
                   syt_nbr @ d_nbr
                   syt_program @ d_program
                   syt_SDomain @ d_Sdomain
                   syt_tDomain @ d_Tdomain with frame a.
            display syt_desc syt_table syt_tagfield syt_fromval
                    syt_sucval syt_failval syt_condition1 syt_condition2
                    syt_errorfield syt_updname syt_runseq  syt_lupddate
                    syt_lupdtime  syt_updint
             				with frame b.
        end.
     end.
     else if frame-field = "d_Sdomain" then do:
        {mfnp.i dom_mstr d_Sdomain dom_domain d_Sdomain
              dom_domain dom_domain}
         if recno <> ? then do:
            display dom_domain @ d_Sdomain.
         end.
     end.
     else if frame-field = "D_Tdomain" then do:
        {mfnp.i dom_mstr D_Tdomain dom_domain D_Tdomain
              dom_domain dom_domain}
         if recno <> ? then do:
            display dom_domain @ D_Tdomain.
         end.
     end.
     else do:
          readkey.
          apply lastkey.
     end.
   end.
  assign s_nbr s_program s_sdomain s_tdomain
         d_nbr d_program d_sdomain d_tdomain
         d_acceptdefault
         b-copy.
  if not can-find(first syt_mstr no-lock where
                  syt_nbr = s_nbr and syt_program = s_program and
                  syt_sdomain = s_Sdomain and syt_tdomain = s_tdomain) then do:
     /*源数据不存在*/
     {pxmsg.i &MSGNUM= 4482 &ERRORLEVEL=3
              &MSGARG1=s_nbr}
     undo, retry.
  end.
  if s_nbr = d_nbr and s_program = d_program and
     /*目标数据和源数据完全相同*/
     s_sdomain = d_sdomain and s_tdomain = d_tdomain then do:
     {pxmsg.i &MSGNUM= 8923 &ERRORLEVEL=3}
     undo, retry.
  end.
  if can-find(first syt_mstr no-lock where
              syt_nbr = d_nbr and syt_program = d_program and
              syt_sdomain = d_Sdomain and syt_tdomain = d_tdomain) then do:
     /*目标数据已存在*/
     {pxmsg.i &MSGNUM= 8922 &ERRORLEVEL=3
              &MSGARG1=s_nbr}
     undo, retry.
  end.

   if not can-find(first dom_mstr no-lock where
                         dom_domain = d_sdomain)
      then do:
      {pxmsg.i &MSGNUM=6135 &ERRORLEVEL=3}
      undo, retry.

   end.
   if not can-find(first dom_mstr no-lock where
                         dom_domain = d_tdomain)
      then do:
      {pxmsg.i &MSGNUM=6135 &ERRORLEVEL=3}
      undo, retry.
   end.

  do on error undo, retry:
     set b-copy.
  end.

  cp-yn = yes.

  /* Please confirm copy */
  {pxmsg.i &MSGNUM=7666 &ERRORLEVEL=1 &CONFIRM=cp-yn}

  if cp-yn then do:
     if b-copy then do:
        for each sytd no-lock where sytd.sytd_nbr = s_nbr and
                 sytd.sytd_program = s_program and
                 sytd.sytd_SDomain = s_Sdomain and
                 sytd.sytd_tDomain = s_Tdomain:
          create sytd_det.
          assign sytd_det.sytd_nbr         = d_nbr
                 sytd_det.sytd_program     = d_program
                 sytd_det.sytd_Sdomain     = d_Sdomain
                 sytd_det.sytd_Tdomain     = d_Tdomain
                 sytd_det.sytd_seq         = sytd.sytd_seq
                 sytd_det.sytd_Tdata       = sytd.sytd_Tdata
                 sytd_det.sytd_SData       = sytd.sytd_SData
                 sytd_det.sytd_condition1  = sytd.sytd_condition1
                 sytd_det.sytd__char01     = sytd.sytd__char01
                 sytd_det.sytd_action      = sytd.sytd_action
                 sytd_det.sytd_condition2  = sytd.sytd_condition2
                 sytd_det.sytd_ischar      = sytd.sytd_ischar
                 sytd_det.sytd_acceptdefault = d_acceptdefault.
        end.
     end.
     find first sytm no-lock where sytm.syt_nbr = s_nbr and
                 sytm.syt_program = s_program and
                 sytm.syt_SDomain = s_Sdomain and
                 sytm.syt_tDomain = s_Tdomain no-error.
     if available sytm then do:
        create syt_mstr.
        assign syt_mstr.syt_nbr        = d_nbr
               syt_mstr.syt_program    = d_program
               syt_mstr.syt_Sdomain    = d_Sdomain
               syt_mstr.syt_Tdomain    = d_Tdomain
               syt_mstr.syt_table      = sytm.syt_table
               syt_mstr.syt_condition1 = sytm.syt_condition1
               syt_mstr.syt_desc       = sytm.syt_desc
               syt_mstr.syt_active     = no
               syt_mstr.syt__chr01     = sytm.syt__chr01
               syt_mstr.syt_tagfield   = sytm.syt_tagfield
               syt_mstr.syt_condition2 = sytm.syt_condition2
               syt_mstr.syt_havedomain = sytm.syt_havedomain
               syt_mstr.syt_fromval    = sytm.syt_fromval
               syt_mstr.syt_sucval     = sytm.syt_sucval
               syt_mstr.syt_failval    = sytm.syt_failval
               syt_mstr.syt_ErrorField = sytm.syt_ErrorField
               syt_mstr.syt_updname    = sytm.syt_updname
               syt_mstr.syt_runseq     = sytm.syt_runseq
               syt_mstr.syt_lupddate   = today
               syt_mstr.syt_lupdtime   = 0
               syt_mstr.syt_updint     = sytm.syt_updint
/*             syt_mstr.syt_updtimereset = sytm.syt_updtimereset */
         .
     end.
     clear frame a.
     clear frame b.
     {pxmsg.i &MSGNUM=7 &ERRORLEVEL=1}
  end.
end.

status input.
