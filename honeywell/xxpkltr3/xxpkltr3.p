/* xxpkltr3.p - Unplan issue from assembline                                 */
/* REVISION: 9.0 LAST MODIFIED: 05/14/14               BY: zy *SS-20140514.1 */
/*****************************************************************************
 * ת��,�˲�,���ϵ��������£�
 * 1.ת��(ֻ����״̬�ǿ�ʱ������,����ת�ֺ�״̬ΪI,ֻ�����˲�)
 * 2.�˲�(ֻ����ת��֮��״̬ΪIʱ������,�����˲ֺ�״̬ΪR,ֻ��������)
 * 3.����(ֻ�����˲�֮��״̬ΪRʱ������,���걨�Ϻ�,���ŵ���״̬��ΪC,
 *           ��������ת��;�˲�;�����е��κζ���.)
*****************************************************************************/
{mfdtitle.i "test.1"}

define variable site  like ld_site init "PRC".
define variable pklnbr like xxpkld_nbr.
define variable wkctr like xxpklm_wkctr.
define variable rknbr as char format "x(8)".
define variable vqty  like xxpkld_qty_req no-undo.
define variable i  as integer.
define variable fn as character.
define variable yn AS logical.
define variable sl as logical.
define variable trrecid as recid no-undo.
define stream bf.
{xxpkltr0.i "new"}

form
  pklnbr colon 8 label "���ϵ�" format "x(16)"
  wkctr  colon 34 label "������"
  rknbr  colon 54 label "���ϵ���"
  sl     colon 72 label "ȫѡ"
with frame a side-labels width 80 attr-space.


/* DISPLAY SELECTION FORM */
form
  tt1_sel          column-label "ѡ"
  tt1_seq          column-label "���"
  tt1_part         column-label "����"
  tt1_loc_to       column-label "��λ"
  tt1_qty1         column-label "������"
  tt1_qty_oh       column-label "�����"
  tt1_qty_iss      column-label "������"
with frame c width 80 no-attr-space 12 down scroll 1.
/* DISPLAY SELECTION FORM */
form
  tt1_seq      column-label "���"
  tt1_part     column-label "����"
  tt1_loc_to   column-label "��λ"
  tt1_qty1     column-label "������"
  tt1_qty_oh   column-label "�����"
  tt1_qty_iss  column-label "������"
  tt1_chk      column-label "���"
with frame d width 80 no-attr-space 12 down scroll 1.

view frame a.
display pklnbr wkctr rknbr sl with frame a.

find first icc_ctrl where no-lock no-error.
if avail icc_ctrl then site = icc_site.
/*��������*/
{xxcmfun.i}
run verfiydata(input today,input date(3,5,2014),input yes,input "softspeed201403",input vchk5,input 140.31).
find first icc_ctrl where no-lock no-error.
     if available icc_ctrl then assign site = icc_site.
mainloop:
repeat with frame a:
  /* clear frame a all no-pause. */
    do on error undo,retry:
       prompt-for pklnbr editing:
           /* FIND NEXT/PREVIOUS RECORD */
         if frame-field = "pklnbr" then do:
            {mfnp05.i xxpklm_mstr xxpklm_index1 " yes " xxpklm_nbr "input pklnbr"}
            clear frame c.
            hide frame c.
            if recno <> ? then do:
                 assign wkctr = xxpklm_wkctr.
                 display xxpklm_nbr @ pklnbr wkctr.
            end.
         end.
         else do:
              readkey.
              apply lastkey.
         end.
       end. /* editing: */
    end.
  assign pklnbr .
  for each tt1 exclusive-lock where tt1_pkl <> pklnbr:  delete tt1. end.
  find xxpklm_mstr where xxpklm_nbr = pklnbr no-lock no-error.
  if available xxpklm_mstr then do:
     display xxpklm_nbr @ pklnbr xxpklm_wkctr @ wkctr.
     assign pklnbr wkctr.
  end.
  else do:
      message "���ϵ�������,����������!" .
      undo,retry  mainloop.
  end.
  if trim(xxpklm_status) <> "R" then do:
      message "���ϵ�״̬ " trim(xxpklm_status) ", ���ܱ���!" .
      undo,retry  mainloop.
  end.
   clear frame c.
   hide frame c.

   ststatus = stline[2].
   status input ststatus.
   do on error undo,retry:
      update rknbr sl.
      if rknbr = "" then do:
         message "���ϵ��Ų�����Ϊ��".
         next-prompt rknbr.
         undo,retry.
      end.
   end.
    for each xxpkld_det where xxpkld_nbr = pklnbr and xxpkld__chr01 = "R" no-lock by xxpkld_line:
       assign vqty = xxpkld_qty_iss.
       if vqty = 0 then next.
       lddetlabel:
       for each ld_det no-lock use-index ld_part_lot where
                ld_part = xxpkld_part and ld_site = site and
                ld_loc = wkctr and ld_qty_oh > 0:
              create tt1.
              assign tt1_sel = "*" when sl
                     tt1_seq = xxpkld_line
                     tt1_pkl = xxpkld_nbr
                     tt1_rknbr = rknbr
                     tt1_part = xxpkld_part
                     tt1_desc1 = xxpkld_desc
                     tt1_qty1 = 0 /* min(vqty,ld_qty_oh,xxpkld_qty_iss - xxpkld_qty_rej) */ /*Ĭ�����ϲ���*/
                     tt1_qty_oh = ld_qty_oh
                     tt1_qty_req = vqty /*���������*/
                     tt1_loc_to = xxpkld_loc_from
                     tt1_qty_iss = xxpkld_qty_iss
                     tt1_loc_from = ld_loc
                     tt1_site = ld_site
                     tt1_lot = ld_lot
                     tt1_ref = ld_ref
                     tt1_stat = ld_stat
                     tt1_recid =  recid(xxpkld_det).
            if vqty >= min(vqty,ld_qty_oh,xxpkld_qty_iss - xxpkld_qty_rej)
                   then assign vqty = vqty - min(vqty,ld_qty_oh,xxpkld_qty_iss - xxpkld_qty_rej).
                   else assign vqty = 0.
       end. /* for each ld_det */
   end. /* for each xxpkld_det */
   view frame c.
    scroll_loopb:
    do on error undo,retry:
        {xxswosel.i
         &detfile      = tt1
         &scroll-field = tt1_sel
         &framename = "c"
         &framesize = 12
         &selectd   = yes
         &sel_on    = ""*""
         &sel_off   = """"
         &display1  = tt1_sel
         &display2  = tt1_seq
         &display3  = tt1_part
         &display4  = tt1_loc_to
         &display5  = tt1_qty1
         &display6  = tt1_qty_oh
         &display7  = tt1_qty_iss
         &include2  = "{xxpkltr20.i}"
         &exitlabel = scroll_loopb
         &exit-flag = "true"
         &record-id = recid(tt1)
         }
         if keyfunction(lastkey) = "END-ERROR" then do:
            hide frame c.
            undo scroll_loopb, retry scroll_loopb.
         end.
   end.
   yn = yes.
   if not can-find(first tt1 where tt1_sel = "*") then do:
      {mfmsg.i 1310 3}
      undo,retry.
   end.
   assign yn = yes.
   {mfmsg01.i 12 2 yn}
   if yn then do:
      {xxpkltr3t.i}
   end. /* IF YN */
      for each tt1 no-lock where tt1_sel = "*" and tt1_chk = "ok"
                        break by tt1_recid:
          if first-of(tt1_recid) then do:
             assign vqty = 0.
          end.
          assign vqty = tt1_qty1.
          if last-of(tt1_recid) then do:
             find first xxpkld_det exclusive-lock where
                  recid(xxpkld_det) = tt1_recid no-error.
             if available xxpkld_det then do:
                assign xxpkld_qty_rej = xxpkld_qty_rej + vqty
                       xxpkld__chr01 = "C".
                find first xxpklm_mstr exclusive-lock
                     where xxpklm_nbr = xxpkld_nbr no-error.
                if available xxpklm_mstr then do:
                       assign xxpklm_stat = "C".
                end.
             end.
          end.
      end.
      for each tt1 no-lock where tt1_sel = "*" and tt1_qty1 > 0 with frame d:
          display tt1_seq
                  tt1_part
                  tt1_loc_to
                  tt1_qty1
                  tt1_qty_oh
                  tt1_qty_iss
                  tt1_chk.
                  down.
      end.
end. /* repeat with frame a: */
