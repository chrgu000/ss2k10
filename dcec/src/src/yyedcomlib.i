/**
**/

DEFINE VARIABLE hf-xxedcomlib AS HANDLE .
run value(lc(global_user_lang) + "\yy\yyedcomlib.p") PERSISTENT SET hf-xxedcomlib.
/*run value(lc(xxedcomlib.p")) PERSISTENT SET hf-xxedcomlib.*/


/*-------------------------------------------------------**
 *get po price
**-------------------------------------------------------*/
function f-getpoprice returns DECIMAL
    (input v_inp_ponbr as CHARACTER,
     INPUT v_inp_poln  AS INTEGER,
     INPUT v_inp_effdt AS DATE,
     INPUT v_inp_qty   AS DECIMAL)
    IN hf-xxedcomlib.



/*-------------------------------------------------------**
 *get item additional data
**-------------------------------------------------------*/
function f-getpartdata returns CHARACTER
    (input v_inp_part as CHARACTER,
     INPUT v_inp_fld  AS CHARACTER)
    IN hf-xxedcomlib.


/*-------------------------------------------------------**
 *get address additional data
**-------------------------------------------------------*/
function f-getaddata returns CHARACTER
    (input v_inp_addr as CHARACTER,
     INPUT v_inp_fld  AS CHARACTER)
    IN hf-xxedcomlib.

/*-------------------------------------------------------**
 *conv string for date
**-------------------------------------------------------*/
function f-conv-date-c2d returns DATE
    (input v_inp_date as CHARACTER)
    IN hf-xxedcomlib.


/*-------------------------------------------------------**
 *get so price
**-------------------------------------------------------*/
function f-getsoprice returns DECIMAL
    (input v_inp_sonbr as CHARACTER,
     INPUT v_inp_soln  AS INTEGER,
     INPUT v_inp_effdt AS DATE,
     INPUT v_inp_qty   AS DECIMAL)
    IN hf-xxedcomlib.


/*-------------------------------------------------------**
 *haha
**-------------------------------------------------------*/
function f-howareyou returns LOGICAL
    (input v_welcome as CHARACTER)
    IN hf-xxedcomlib.
