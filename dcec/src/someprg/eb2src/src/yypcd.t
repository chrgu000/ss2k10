TRIGGER PROCEDURE FOR DELETE OF pc_mstr .

{mfdeclre.i}
DEF VAR keyval AS CHAR .
DEF VAR startdate AS CHAR .

IF pc_mstr.pc_start <> ? THEN startdate = STRING(pc_mstr.pc_start) .
ELSE startdate = "" .

keyval = pc_mstr.pc_list + "." + pc_mstr.pc_curr + "." + pc_mstr.pc_prod_line + "." + pc_mstr.pc_part + "." + pc_mstr.pc_um + "." + startdate .

{gprun.i ""yyaud.p"" "(input 'pc_mstr' ,
    INPUT 'DELETED' ,
    INPUT keyval ,
    INPUT '' ,
    INPUT '')"
 }




