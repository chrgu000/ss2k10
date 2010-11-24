/* xxcalmt.p - auto create gl period data                                     */
/* REVISION:AB$1     LAST MODIFIED: 11/03/10 BY: zy                           */
/*-Revision end---------------------------------------------------------------*/
/* Environment: Progress:10.1B   QAD:qad2008    Interface:character           */

/* DISPLAY TITLE */
{mfdtitle.i "AB$1"}

define variable yr like glc_year no-undo.
define variable make-yn like mfc_logical initial no.
define variable i    as integer.
define variable vRec as logical.
define variable vdte as date.
define variable filename as character.

/* DISPLAY SELECTION FORM */
form
   yr      colon 25
   make-yn colon 25 label "Create"
with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).
assign yr = year(today).
/* DISPLAY */
view frame a.

mainloop:
repeat with frame a:

   update yr.

   /* ADD/MOD/DELETE  */
   ststatus = stline[2].
   status input ststatus.

   update make-yn go-on(F5 CTRL-D).

   hide frame b.

   assign vrec = no.
   assign filename = "xxcalmt.p.cim".
   if make-yn then do:
   output to value(filename).
      do i = 1 to 12:
         if not can-find(first glc_cal no-lock where glc_domain = global_domain
            and glc_year = yr and glc_per = i) then do:
            assign vrec = yes when vrec = no.
            assign vdte = (date(i,1,yr) + 33) - day(date(i,1,yr) + 33).
            put unformat yr " " i skip.
            put unformat date(i,1,yr) " " vdte skip.
            put unformat "-" skip.
            put unformat "-" skip.
            put unformat "." skip.
         end.
      end.
   output close.
   if vrec then do:
       batchrun  = yes.
       input from value(filename).
       output to value(filename + ".out") keep-messages.
       hide message no-pause.
       {gprun.i ""glcalmt.p""}
       hide message no-pause.
       output close.
       input close.
       batchrun  = no.
       os-delete value(filename).
       os-delete value(filename + ".out").
   end.
   end.

   for each glc_cal no-lock where glc_domain = global_domain and
            glc_year = yr with frame b width 80 no-attr-space down:
                   display glc_year glc_per glc_start glc_end.
       for each glcd_det no-lock where glcd_domain = global_domain and
                glcd_year = glc_year and glcd_per = glc_per
                with frame b width 80 no-attr-space down:
                display glcd_entity glcd_gl_clsd glcd_closed glcd_yr_clsd.
                down.
       end.
       setFrameLabels(frame b:handle).
   end.

end. /* repeat with frame a: */

status input.
