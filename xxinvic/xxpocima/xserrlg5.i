/*Define variable Eoutputstatment AS CHARACTER FORMAT "x(200)". 
Define variable Eonetime        AS CHARACTER FORMAT "x(1)" init "N".*/

ciminputfile = usection + ".bpi".
cimoutputfile = usection + ".bpo".
Eonetime        = "N".
Eoutputstatment = "".


run datain.

run dataout.