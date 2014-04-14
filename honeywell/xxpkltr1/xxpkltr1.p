/* REVISION: 9.0       LAST MODIFIED: 11/14/13      BY: jordan Lin *SS-20131114.1 */

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

define var b_seq  like xxpkld_line.
define var v_seq  like xxpkld_line.
define var v_part    like pt_part.
define var v_desc1   like pt_desc1 format "x(10)".
define var v_loc_from  like ld_loc.
define var v_loc_to   like ld_loc.
define var v_qty_req like xxpkld_qty_req.
define var v_qty_iss like xxpkld_qty_req.

{xxpkltr1.i "new"}

form
  pklnbr colon 15 label " ���ϵ�" format "x(16)"
  rknbr colon 45 label "ת�ֵ���"
/*  yn-sel colon 15 label "ȫ������"  */
with frame a side-labels width 80 attr-space.

form
	b_seq colon 15 label "���"
with frame b side-labels width 80 attr-space.

/* DISPLAY SELECTION FORM */
form
  tt1_seq     column-label "���"
  tt1_part    column-label "����"
/*  tt1_desc1     column-label "����"  */
  tt1_loc_from    column-label "FORM��λ"
  tt1_loc_to    column-label "TO��λ"
  tt1_qty_req    column-label "��������"
  tt1_qty_iss    column-label "������"
with frame c width 80 no-attr-space 1 down scroll 1.


form
  tt2_site   column-label "�ص�"
  tt2_loc    column-label "��λ"
  tt2_lot    column-label "Lot/Se"
  tt2_ref    column-label "Ref"
  tt2_stat   column-label "Stat"
  tt2_qty_oh column-label "Qty OH"
with frame fld width 80 no-attr-space 4 down scroll 1.


   /* DISPLAY SELECTION FORM */
   form
     v_seq      no-label
     v_part     no-label
/*   v_desc1    no-label  */
     v_loc_from no-label
     v_loc_to   no-label
     v_qty_req  no-label
     v_qty_iss  no-label
   with frame d width 80  .

view frame a.
view frame b.
view frame c.
view frame d.

find first icc_ctrl where no-lock no-error.
if avail icc_ctrl then site = icc_site.
/*��������*/
 {xxcmfun.i}
run verfiydata(input today,input date(3,5,2014),input yes,input "softspeed201403",input vchk5,input 140.31).

mainloop:
repeat with frame a:
  /* clear frame a all no-pause. */
  hide frame b no-pause.
  hide frame c no-pause.
  hide frame d no-pause.
  for each tt1 exclusive-lock: delete tt1. end.
  prompt-for  pklnbr rknbr  editing:
      /* FIND NEXT/PREVIOUS RECORD */
      {mfnp05.i xxpklm_mstr xxpklm_index1 " yes " xxpklm_nbr "input pklnbr"}
    if recno <> ? then do:
         display  xxpklm_nbr @ pklnbr.
    end.
  end. /* editing: */
  find xxpklm_mstr where xxpklm_nbr = input pklnbr no-lock no-error.
  if not available xxpklm_mstr then do:
      message "���ϵ�������,����������!" .
      NEXT  mainloop.
  end.

  if trim(xxpklm_status) <> "" then do:
      message "���ϵ�״̬ " trim(xxpklm_status) ", ���ܷ���!" .
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
       message "���ϵ������!" .
       NEXT  mainloop.
   end.

    v_yn1 = no.

/***
   scroll_loopb:
   do on error undo,retry:
        {swview.i  &buffer       = tt1
                   &scroll-field = tt1_part
                   &searchkey    = " true "
                   &framename    = "c"
                   &framesize    = 4
                   &display1     = tt1_seq
                   &display2     = tt1_part
                   &display3     = tt1_loc_from
                   &display4     = tt1_loc_to
                   &display5     = tt1_qty_req
                   &display6     = tt1_qty_iss
                   &exitlabel    = scroll_loopb
                   &record-id    = recid(tt1)
                   &first-recid  = "?"
                   &exit-flag    = "true"
                   &logical1     = true
            }
         if keyfunction(lastkey) = "END-ERROR" then do:
            hide frame selny.
            undo scroll_loopb, retry scroll_loopb.
         end.
         repeat with frame d:
               assign v_seq = tt1_seq
                      v_part = tt1_part
                      v_qty_req = tt1_qty_req.
               display v_seq v_part v_qty_req .
         end.
    end.  /* scroll_loopb*/
******/
		repeat:
  	   do with frame b: 
		   	  prompt-for b_seq editing:
		   	      /* FIND NEXT/PREVIOUS RECORD */
		   	      {mfnp05.i tt1 tt1_index1 " yes " tt1_seq "input b_seq"}
		   	    if recno <> ? then do:
		   	    		 display tt1_seq @ b_seq with frame b.
		   	         display tt1_seq tt1_part tt1_loc_from tt1_loc_to tt1_qty_req tt1_qty_iss with frame c.
		   	         for each tt2 exclusive-lock: delete tt2. end.
		   	         for each ld_det no-lock use-index ld_part_loc where ld_part = tt1_part and ld_qty_oh <> 0:
		   	         		 create tt2.
		   	         		 assign tt2_part = ld_part
														tt2_site = ld_site
														tt2_loc = ld_loc 
														tt2_lot = ld_lot  
														tt2_ref = ld_ref 
														tt2_stat = ld_stat
														tt2_qty_oh = ld_qty_oh.
		   	         end.
		   	         for each tt2 no-lock:
		   	             display tt2_site   
														 tt2_loc    
														 tt2_lot    
														 tt2_ref    
														 tt2_stat   
														 tt2_qty_oh 
															with frame fld.
		   	         end.
		   	    end.
		   	  end. /* editing: */
	     end . /*do with frame */
	  end.
end. /* repeat with frame a: */

