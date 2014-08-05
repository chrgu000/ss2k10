define variable eoutputstatment as character format "x(200)".
define variable eonetime        as character format "x(1)" init "n".
define variable v_cimload_ok    as logical . 
eonetime        = "n".
eoutputstatment = "".




procedure datain.  /*<---***************************************/

    define variable outputstatment as character format "x(200)".

    input from value ( ciminputfile) .
    output to  value ( "log.bc") append.
        put  unformatted skip(1) .
        put  unformatted today " " string (time,"hh:mm:ss") " " userid(sdbname('qaddb')) " " ciminputfile " ".

            do while true:
                  import unformatted outputstatment.
                    put unformatted outputstatment "@" .
                eoutputstatment =  eoutputstatment + "@"  +  trim ( outputstatment ).

            end.
                    put unformatted skip .
    input close.
    output close.

end procedure. /*datain*/




procedure dataout.  /*<---***************************************/
        define output parameter vv_cimload_ok as logical .
        define variable woutputstatment as character .

        vv_cimload_ok = yes.
        
        input from value ( cimoutputfile) .
            do while true:
                import unformatted woutputstatment.


                if      index (woutputstatment,"error:")   <> 0 or    /* for us langx */
                        index (woutputstatment,"´íÎó:")	<> 0 or    /* for ch langx */        
                        index (woutputstatment,"¿ù»~:")	<> 0 or    /* for tw langx */
                        /*  
                        index (woutputstatment,"warning:") <> 0 or 
                        index (woutputstatment,"¾¯¸æ:")    <> 0 or 
                        index (woutputstatment,"Äµ§i")	    <> 0 or 
                        */           
                        index (woutputstatment,"(87)")	    <> 0 or      
                        index (woutputstatment,"(557)")	<> 0 or      
                        index (woutputstatment,"(143)")	<> 0       
                then do:
                    if eonetime = "n" then do :
                        output to  value ( "log.err") append.
                            put  unformatted today " " string (time,"hh:mm:ss") " " userid(sdbname('qaddb')) " " ciminputfile " " eoutputstatment  skip.
                            eonetime = "y".
                        output close.
                    end.

                    output to  value ( "log.bc") append.
                        put  unformatted today " " string (time,"hh:mm:ss") " " userid(sdbname('qaddb')) " " cimoutputfile " " woutputstatment  skip.
                    output close.

                    output to  value ( "log.err") append.
                        put  unformatted today " " string (time,"hh:mm:ss") " " userid(sdbname('qaddb')) " " cimoutputfile " " woutputstatment  skip.
                    output close.
                    vv_cimload_ok = no .
                end.
            end. /*do while true*/
        input close.
end procedure. /*dataout*/


/*<---***************************************/


run datain.  
run dataout(output v_cimload_ok) . 



