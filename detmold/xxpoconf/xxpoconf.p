/*V8:ConvertMode=Maintenance                                                 */
/* REVISION END                                                              */

/* DISPLAY TITLE */
{mfdtitle.i "130720.1"}
define variable nbr like po_nbr.
define variable nbr1 like po_nbr.
define variable vend like po_vend.
define variable vend1 like po_vend.
define variable buyer like po_buyer.
define variable buyer1 like po_buyer.
define variable site   like po_site.
define variable site1  like po_site.
define variable v_sel like mfc_logical.
define variable sel-all like mfc_logical.

define temp-table tab_list
       fields tab_sel as character label "Se" format "x(2)"
       fields tab_nbr  like po_nbr
       fields tab_vend  like po_vend
       fields tab_buyer like po_buyer
       fields tab_site like po_site
       fields tab_due like po_due_date
       fields tab_rmks like po_rmks format "x(20)".
/* DISPLAY SELECTION FORM */
form
  nbr    colon 16  nbr1 colon 40 label {t001.i}
  vend   colon 16 vend1 colon 40 label {t001.i}
  site   colon 16 site1 colon 40 label {t001.i}
  buyer  colon 16 buyer1 colon 40 label {t001.i}
  sel-all colon 20
with frame a side-labels width 80 attr-space.
setFrameLabels(frame a:handle).

form  tab_sel   column-label "sel"
      tab_nbr   colon 5
      tab_vend  colon 15
      tab_buyer colon 25
      tab_site  colon 35
      tab_due   colon 45
With frame selfld no-validate with title color
normal(getFrameTitle("DETAIL",30)) 13 down width 80.
setFrameLabels(frame selfld:handle).

view frame a.
repeat with frame a:
   do on error undo,retry:
      update nbr nbr1 vend vend1 site site1 buyer buyer1 sel-all with frame a
          editing:
             if frame-field = "nbr" then do:
                {mfnp.i po_mstr nbr po_nbr nbr po_nbr po_nbr}
                if recno <> ? then do:
                   nbr = po_nbr.
                   display po_nbr @ nbr with frame a.
                end.
             end.
              if frame-field = "nbr1" then do:
                {mfnp.i po_mstr nbr1 po_nbr nbr1 po_nbr po_nbr}
                if recno <> ? then do:
                   nbr1 = po_nbr.
                   display po_nbr @ nbr1 with frame a.
                end.
             end.
             else do:
                status input.
                readkey.
                apply lastkey.
             end.
          end.
   end.

   ststatus = stline[2].
   status input ststatus.

   scroll_loopb:
   do on error undo,retry:
      empty temp-table tab_list no-error.
      for each po_mstr no-lock where po_nbr >= nbr and (po_nbr <= nbr1 or nbr1 = "")
           and po_vend >= vend and (po_vend <= vend1 or vend1 = "")
           and po_site >= site and (po_site <= site1 or site1 = "")
           and po_buyer >= buyer and (po_buyer <= buyer1 or buyer1 = "")
           and po_confirm = no:
           create tab_list.
           assign tab_sel = if sel-all then "*" else ""
                  tab_nbr = po_nbr
                  tab_vend = po_vend
                  tab_buyer = po_buyer
                  tab_site = po_site
                  tab_due = po_due_date
                  tab_rmks = po_rmks.
      end.
      {swselect.i
         &detfile      = tab_list
         &scroll-field = tab_nbr
         &framename    = "selfld"
         &framesize    = 13
         &selectd      = yes
         &sel_on       = ""*""
         &sel_off      = """"
         &display1     = tab_sel
         &display2     = tab_nbr
         &display3     = tab_vend
         &display4     = tab_buyer
         &display5     = tab_site
         &display6     = tab_due
         &display7     = tab_rmks
         &exitlabel    = scroll_loopb
         &exit-flag    = "true"
         &record-id    = recid(tab_list)
         }
         setFrameLabels(frame selfld:handle).
         if keyfunction(lastkey) = "END-ERROR" or keyfunction(lastkey) = "F4"  then do:
            hide frame selfld.
            undo scroll_loopb, retry scroll_loopb.
         end.
   end.
   for each tab_list no-lock where tab_sel = "*" with frame xx title color
         normal(getFrameTitle("CONFIRMED_ORDERS",30)):
       display yes @ tab_sel tab_nbr tab_vend tab_buyer tab_site tab_due tab_rmks format "x(24)".
       setFrameLabels(frame xx:handle).
   end.
   if not can-find(first tab_list where tab_sel = "*") then do:
      {mfmsg.i 1310 3}
      undo,retry.
   end.
     assign v_sel = no.
     {mfmsg01.i 12 2 v_sel}
     if v_sel then do:
        for each tab_list no-lock where tab_sel = "*":
            output to value(tab_nbr + ".bpi").
               put unformat '"' tab_nbr '"' skip '-' skip '-' skip.
               put unformat '- - - - - - - - - - - - - Y - - - - - - - - N' skip.
               put unformat '-' skip.
               put unformat '.' skip '.' skip '-' skip '.' skip.
            output close.

            batchrun = yes.
            input from value(tab_nbr + ".bpi").
            output to value(tab_nbr + ".bpo").
            {gprun.i ""popomt.p""}
            output close.
            input close.
            batchrun = no.
        end. /* for each tab_list no-lock:*/
     end. /*  if v_sel then do: */
     for each tab_list no-lock  where tab_sel = "*",
         each po_mstr no-lock where po_nbr = tab_nbr:
         display po_nbr po_vend po_buyer po_site po_due_date po_confirm.
         if po_confirm then do:
            os-delete value(tab_nbr + ".bpi").
            os-delete value(tab_nbr + ".bpo").
         end.
     end.
end.
