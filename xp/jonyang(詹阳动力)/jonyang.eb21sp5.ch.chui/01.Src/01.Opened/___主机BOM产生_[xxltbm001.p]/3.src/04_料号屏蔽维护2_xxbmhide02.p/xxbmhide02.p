/*xxbmhide02.p 主机BOM配套程式: 屏蔽料号*/
/*----rev history-------------------------------------------------------------------------------------*/
/* SS - 100907.1  By: Roger Xiao */

/*-Revision end---------------------------------------------------------------*/
{mfdtitle.i "100907.1"}

define new shared variable desc1 like pt_desc1.
define new shared variable desc2 like pt_desc1.
define new shared variable wodesc1 like pt_desc1.
define new shared variable wodesc2 like pt_desc1.
define new shared variable part like wo_part.
define new shared variable nbr like wod_nbr.
define new shared variable lot like wod_lot.
define new shared variable status_name like wo_status format "x(12)".
define new shared variable wod_recno as recid.
define new shared variable undo_all like  mfc_logical initial no no-undo.

define new shared variable v_yn as logical format "Yes/No".

define new shared frame a.
   
form
   wo_nbr         colon 25
   wo_lot         colon 50
   part           colon 25
   wodesc1        no-label at 47 no-attr-space
   status_name    colon 25
   wodesc2        no-label at 47 no-attr-space
                  skip(1)
   wod_part       colon 25 label "Component Item"
   desc1          no-label at 47 no-attr-space
   wod_op         colon 25
   desc2          no-label at 47 no-attr-space
                  skip(1)
   wod_qty_req    colon 25
   wod_bom_qty    colon 55 label "Qty Per Unit"
   wod_qty_iss    colon 25
                  skip(1)
   v_yn           colon 25    label "主机BOM不显示"
                  skip(1)

with frame a side-labels width 80 attr-space.

view frame a.

mainloop:
repeat with frame a:

   ststatus = stline[1].
   status input ststatus.

   undo_all = no.
   {gprun.i ""xxbmhide02a.p""}
   if keyfunction(lastkey) = "END-ERROR" then leave.
   if keyfunction(lastkey) = "." then leave.
   if undo_all then do:
      undo mainloop, retry.
   end.

   find wo_mstr
      where wo_mstr.wo_domain = global_domain
      and   wo_nbr            = nbr
      and   wo_lot            = lot
   no-lock no-error.


   comp-loop:
   repeat with frame a:

      prompt-for
         wod_part validate (true,"")
         wod_op
      editing:

         /* FIND NEXT/PREVIOUS RECORD */
         {mfnp01.i wod_det wod_part wod_part lot  " wod_det.wod_domain =
         global_domain and wod_lot "  wod_det}

         if recno <> ? then do:

            assign
               desc1 = ""
               desc2 = "".

            find pt_mstr  
                where pt_mstr.pt_domain = global_domain 
                and  pt_part = wod_part 
            no-lock no-error.
            if available pt_mstr then
            assign
               desc1 = pt_desc1
               desc2 = pt_desc2.
            
            v_yn =  if wod__chr02 = "Y" then yes else no.
            display
               wod_part
               wod_op
               desc1 desc2 
               wod_qty_req
               wod_bom_qty 
               wod_qty_iss
               v_yn
               with frame a.
         end.
      end.

      if lookup(wo_status,"P,F,B,C,") <> 0
      then do:
         {pxmsg.i &MSGNUM=523 &ERRORLEVEL=3}
         /* MODIFICATION TO PLANNED AND FIRM PLANNED COMPONENTS NOT ALLOWED */
         undo, retry.
      end.


      find wod_det  
            where wod_det.wod_domain = global_domain 
            and wod_nbr = wo_nbr
            and wod_lot = wo_lot
            and wod_part = input wod_part
            and wod_op = input wod_op
      no-error.

      if not available wod_det then do:
          message "错误:加工单物料清单无此料号或OP".
          undo,retry.
      end.

      ststatus = stline[2].
      status input ststatus.

      assign
         desc1 = ""
         desc2 = "".

      find pt_mstr  
            where pt_mstr.pt_domain = global_domain 
            and  pt_part =  wod_part 
      no-lock no-error.
      if available pt_mstr then
      assign
         desc1 = pt_desc1
         desc2 = pt_desc2.

      v_yn =  if wod__chr02 = "Y" then yes else no.
      display
         wod_part
         wod_op
         desc1 desc2 
         wod_qty_req
         wod_bom_qty 
         wod_qty_iss 
         v_yn.



       ststatus = stline[2].
       status input ststatus.

       do on error undo,retry :
           v_yn =  if wod__chr02 = "Y" then yes else no.
           update v_yn.
           assign wod__chr02 = if v_yn = yes then "Y" else "". 
       end.

      release wod_det.

   end. /*comp-loop:*/






















end. /* mainloop */

status input.
