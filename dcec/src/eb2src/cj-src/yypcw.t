TRIGGER PROCEDURE FOR WRITE OF pc_mstr OLD BUFFER oldpc .

{mfdeclre.i}
DEF VAR keyval AS CHAR .
DEF VAR startdate AS CHAR .

IF pc_mstr.pc_start <> ? THEN startdate = STRING(pc_mstr.pc_start) .
ELSE startdate = "" .

keyval = pc_mstr.pc_list + "." + pc_mstr.pc_curr + "." + pc_mstr.pc_prod_line + "." + pc_mstr.pc_part + "." + pc_mstr.pc_um + "." + startdate .

IF oldpc.pc_amt[1] <> pc_mstr.pc_amt[1] THEN DO :
    {gprun.i ""yyaud.p"" "(input 'pc_mstr' ,
        INPUT 'pc_amt' ,
        INPUT keyval ,
        INPUT STRING(oldpc.pc_amt[1]) ,
        INPUT STRING(pc_mstr.pc_amt[1]))"
     }
END.



