define temp-table tablst no-undo
    fields tab_sel  as character format "x(1)"
    fields tab_name as character format "x(16)"
    fields tab_desc as character format "x(54)".

form tab_sel      column-label "sel"
     tab_name     colon 3
     tab_desc     colon 20
With frame selfld no-validate with title color
normal("File") 8 down width 80.
/* setFrameLabels(frame selfld:handle).     */