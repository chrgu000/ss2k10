/**
 @File: zycimload.p
 @Description: eb2-cimload
 @Version: 1.0
 @Author: Cai Jing
 @Created: 2005-8-26
 @BusinessLogic: eb2-cimload输出临时表
 @Todo: 
 @History: 
**/

DEFINE INPUT PARAMETER cimf AS CHARACTER .

{zycimload.i}

/*00-info*/
/*01-warning*/
/*02-Process any PROGRESS and validation errors (could not be re-directed)*/
/*03-not process_file*/
/*04-Write program errors and warnings to error log */
/*05-report error*/
/*06-procedure error*/
/*07-more than 999 cim sessions*/
/*08-cim processint session lost*/
/*09-source not available*/
/*10-no id*/


{mfdeclre.i}
xxxfid = 0.
xxxlid = 0.
FOR EACH xxerrtb.
    DELETE xxerrtb.
END.

{gprun.i ""zymgbdld.p"" "(input cimf)"
    }

IF xxxfid > 0 AND xxxlid > 0 THEN DO :
    {gprun.i ""zymgbdpro.p"" 
        }
END.
ELSE DO :
    CREATE xxerrtb .
    xxerr = "10" .
    xxmsg = "没有生成CIM组" .
END.
