/*Define variable Eoutputstatment AS CHARACTER FORMAT "x(200)". 
Define variable Eonetime        AS CHARACTER FORMAT "x(1)" init "N".*/

ciminputfile = usection + ".i".
cimoutputfile = usection + ".o".
Eonetime        = "N".
Eoutputstatment = "".


run datain.

run dataout.
