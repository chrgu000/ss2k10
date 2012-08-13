DEF VAR bc_site1 AS CHAR.
 DEF VAR bc_loc1 AS CHAR.
 bc_site1 = 'wtd'.
 bc_loc1 = '100'.
FIND FIRST b_co_mstr WHERE b_co_code = '08031505278337001'.
 OUTPUT TO cim.
                
              put  "@@BATCHLOAD iclotr04.P" skip.
            PUT UNFORMAT '"' b_co_part '"' SKIP.
            PUT UNFORMAT STRING(3)  skip.
             PUT 'Y T Y - ' SKIP.
            PUT UNFORMAT '"' + b_co_site + '" "' + b_co_loc + '"' + ' "     "'  SKIP.
            PUT UNFORMAT '"' bc_site1 '" "' bc_loc1 '"' +  ' "     "' SKIP.
          PUT     SKIP(2)
                     "." SKIP
                     "@@END" SKIP.
          OUTPUT CLOSE.
             {bcrun.i ""bcmgbdpro.p"" "(INPUT ""cim"",INPUT ""out.txt"")"}
                 OS-DELETE VALUE('cim').
