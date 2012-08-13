TRIGGER PROCEDURE FOR DELETE OF pi_mstr .

{mfdeclre.i}
DEF VAR keyval AS CHAR .
DEF VAR startdate AS CHAR .
DEF VAR pics AS CHAR .
DEF VAR part AS CHAR .

IF pi_mstr.pi_start <> ? THEN startdate = STRING(pi_mstr.pi_start) .
ELSE startdate = "" .

IF pi_mstr.pi_cs_code BEGINS "qadall" THEN pics = "" .
ELSE pics = pi_mstr.pi_cs_code .
IF pi_mstr.pi_part_code BEGINS "qadall" THEN part = "" .
ELSE part = pi_mstr.pi_part_code .

keyval = pi_mstr.pi_list + "." + pi_mstr.pi_cs_type + "." + pics + "." + pi_mstr.pi_part_type + "." + part + "." + pi_mstr.pi_curr + "." + pi_mstr.pi_um + "." + startdate .

{gprun.i ""yyaud.p"" "(input 'pi_mstr' ,
    INPUT 'DELETED' ,
    INPUT keyval ,
    INPUT '' ,
    INPUT '')"
 }




