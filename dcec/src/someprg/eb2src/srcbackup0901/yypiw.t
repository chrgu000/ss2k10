TRIGGER PROCEDURE FOR WRITE OF pi_mstr OLD BUFFER oldpi .

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

IF oldpi.pi_list_price <> pi_mstr.pi_list_price THEN DO :
    {gprun.i ""yyaud.p"" "(input 'pi_mstr' ,
        INPUT 'pi_list_price' ,
        INPUT keyval ,
        INPUT STRING(oldpi.pi_list_price) ,
        INPUT STRING(pi_mstr.pi_list_price))"
     }
END.



