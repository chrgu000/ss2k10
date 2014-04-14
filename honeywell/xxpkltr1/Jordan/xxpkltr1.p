/*REVISION: 9.0       LAST MODIFIED: 11/14/13      BY: jordan Lin *SS-20131114.1*/

 {mfdtitle.i "test.1"}

define var site  like ld_site init "10000".
define var pklnbr like xxpkld_nbr.
define var xxtrlot as char format "x(16)".
define  new shared var rknbr as char format "x(8)".
define var desc1 like pt_desc1.
define var desc2 like pt_desc2.
define var xxqty1  like tr_qty_loc.
define var xxqty2  like tr_qty_loc.
define var xxqty3  like tr_qty_loc.
define var xxqty4  like tr_qty_loc.
define var xxloc1  like tr_loc.
define var xxloc2  like tr_loc.
define var xxloc3  like tr_loc.
define var xxloc4  like tr_loc.
define var xxreas1 as logical.
define var xxreas2 like prh_reason.
define var xxreas3 like prh_reason.
define var xxreas4 like prh_reason.
define var xxrecid as recid.
define var effdate like tr_effdate init today.
define var vendname as char format "x(20)".
define var undo-input as logical no-undo.
define var tt_recid as recid.
define var first-recid as recid.
define var sw_reset like mfc_logical.
define var xxi as int.
define var errorst   as logical no-undo.
define var errornum  as integer no-undo.
define var yn-sel as logical init no.
define new shared  variable errstr as char no-undo  .
           define var vv_recid as recid .
           define var vv_first_recid as recid .
           define var v_framesize as integer .
     DEFINE VAR v_counter AS INT .
     DEFINE VAR choice AS LOGICAL .
           DEFINE VAR choice2 AS LOGICAL .
     DEFINE VAR v_yn1 AS LOGICAL .
     DEFINE VAR yn AS LOGICAL .

define var v_seq  like xxpkld_line.
define var v_part    like pt_part.
define var v_desc1   like pt_desc1 format "x(10)".
define var v_loc_from  like ld_loc.
define var v_loc_to   like ld_loc.
define var v_qty_req like xxpkld_qty_req.
define var v_qty_iss like xxpkld_qty_req.

define new shared temp-table tt1
  field tt1_seq like xxpkld_line
  field tt1_pkl like xxpkld_nbr
  field tt1_part like pt_part
  field tt1_desc1 like pt_desc1 format "x(10)"
  field tt1_loc_from like ld_loc
  field tt1_qty_req like xxpkld_qty_req
  field tt1_loc_to like ld_loc
  field tt1_qty_iss like xxpkld_qty_req
  field tt1_site like si_site
  field tt1_qty2 like ld_qty_oh
  field tt1_xx like pt_desc2
  index  tt1_index is primary
         tt1_pkl tt1_seq  .

form
  pklnbr colon 15 label " 领料单" format "x(16)"
  rknbr colon 45 label "转仓单号"
/*  yn-sel colon 15 label "全部发料"  */
with frame a side-labels width 80 attr-space.


/* DISPLAY SELECTION FORM */
form
  tt1_seq     column-label "项次"
  tt1_part    column-label "物料"
/*  tt1_desc1     column-label "描述"  */
  tt1_loc_from    column-label "FORM库位"
  tt1_loc_to    column-label "TO库位"
  tt1_qty_req    column-label "需求数量"
  tt1_qty_iss    column-label "发料量"

with frame c width 80 no-attr-space 8 down scroll 1.



/* DISPLAY SELECTION FORM */
form
        v_seq      no-label
  v_part    no-label
/*  v_desc1     no-label  */
  v_loc_from     no-label
  v_loc_to    no-label
  v_qty_req    no-label
  v_qty_iss   no-label
with frame d width 80  .

view frame a.
view frame c.
view frame d.

find first icc_ctrl where no-lock no-error.
if avail icc_ctrl then site = icc_site.
/*日期限制*/
 {xxcmfun.i 11/01/2013 12/10/2013} 
mainloop:
repeat with frame a:

for each tt1:
delete tt1.
end.

  /* clear frame a all no-pause. */
  hide frame c no-pause.
  hide frame d no-pause.
  prompt-for  pklnbr rknbr  editing:

      /* FIND NEXT/PREVIOUS RECORD */
      {mfnp05.i xxpklm_mstr xxpklm_index1 " xxpklm_nbr <>  ''  "
       xxpklm_nbr
      "input pklnbr"
       }

    if recno <> ? then do:
         display  xxpklm_nbr @ pklnbr.
         end.
  end. /* editing: */
  find xxpklm_mstr where xxpklm_nbr = input pklnbr no-lock no-error.
  if not available xxpklm_mstr then do:
      message "领料单不存在,请重新输入!" .
      NEXT  mainloop.
  end.

  if trim(xxpklm_status) <> "" then do:
      message "领料单状态 " trim(xxpklm_status) ", 不能发料!" .
      NEXT  mainloop.
  end.
   assign rknbr  .
   yn-sel = no .
   for each xxpkld_det where xxpkld_nbr = xxpklm_nbr no-lock by xxpkld_line :
       create tt1 .
       tt1_seq  = xxpkld_line.
       tt1_pkl = xxpkld_nbr.
       tt1_part = xxpkld_part.
       tt1_desc1 = xxpkld_desc.
       tt1_loc_from = xxpkld_loc_from.
       tt1_qty_req  = xxpkld_qty_req.
       tt1_loc_to = xxpkld_loc_to .
       tt1_qty_iss = if xxpkld_qty_tmp = 0 then xxpkld_qty_req - xxpkld_qty_iss else xxpkld_qty_tmp.
       tt1_site = xxpkld__chr01.
       yn-sel = yes.
   end. /* for each xxpkld_det */

   if yn-sel = no then do :
       message "领料单无项次!" .
       NEXT  mainloop.
   end.


    v_yn1 = no.



    {xxglline.i}
    errstr =  "".
    if v_yn1 = yes then do:
     {gprun.i ""xxpkltr1a.p"" }
    end.
   if trim(errstr) = "" then do:
       for each  xxpkld_det where xxpkld_nbr = xxpklm_nbr :
           find tt1 where tt1_pkl = xxpkld_nbr and tt1_seq = xxpkld_line no-lock no-error.
     if avail tt1 then do:
               xxpkld_qty_iss = xxpkld_qty_iss + tt1_qty_iss .
         xxpkld_qty_tmp = 0 .

     end.  /* if avail tt1 then do: */


       end. /*  for each  xxpkld_det */

   end.  /*  if trim(errstr) = "" then do: */


end. /* repeat with frame a: */