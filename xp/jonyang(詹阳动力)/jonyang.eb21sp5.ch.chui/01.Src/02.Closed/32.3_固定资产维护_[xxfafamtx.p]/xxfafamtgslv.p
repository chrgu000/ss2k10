/* xxfafamtgslv.p 残值调整子程式                                                        */
/* REVISION: 110319.1   Created On: 20110319   By: Softspeed Roger Xiao                               */
/*----rev history-------------------------------------------------------------------------------------*/
/* SS - 110319.1  By: Roger Xiao */
/*-Revision end---------------------------------------------------------------*/

{mfdeclre.i}
{gplabel.i} 


define parameter buffer fa_mstr for fa_mstr.
define parameter buffer fab-det for fab_det.
define input  parameter l-adj-amt       like fab_amt.
define output parameter l-delta-salvamt like fab_salvamt    no-undo.

define var l-salvamt        like fab_salvamt      no-undo.
define var l-salvamt2       like fab_salvamt      no-undo.

define var v_yn_salv        as logical            no-undo.
define var l-err-nbr        as integer            no-undo.

l-err-nbr = 1 .


form 
   "    是否修改残值?" v_yn_salv "   "
   skip(1)
   "          现残值:" l-salvamt               skip
   "按原比例的新残值:" l-salvamt2              skip
   skip(1)
   "          新残值:" l-delta-salvamt         skip
with frame f-salv 
row 5 
center
overlay 
no-label.
setFrameLabels(frame f-salv:handle).



{gprunp.i "fapl" "p" "fa-get-salvage"
            "(input  fab-det.fab_fa_id,
              input  fab-det.fab_fabk_id,
              output l-salvamt)"}
l-salvamt2 = round(l-adj-amt * l-salvamt / fab-det.fab_amt,2) .
l-delta-salvamt = l-salvamt .

salvloop:
repeat:
    
    disp l-salvamt l-salvamt2 l-delta-salvamt with frame f-salv.

    update
        v_yn_salv
    with frame f-salv.

    if keyfunction(lastkey) = "end-error" then undo salvloop, leave salvloop.

    if v_yn_salv then do on error undo,retry:
        update
            l-delta-salvamt
        with frame f-salv.

        if l-delta-salvamt < 0 then do:
            message "错误:残值输入有误,请重新输入.".
            undo,retry.
        end.

        l-err-nbr = 0 .
    end. /*if v_yn_salv then */


leave .
end. /*salvloop:*/
hide frame f-salv no-pause .


/*有错则不调整残值*/
if l-err-nbr <> 0 then do:
    l-err-nbr = 0 .
    l-delta-salvamt = l-salvamt .
end.