/* xxfct817.p - EDI EC Function to Retrieve any Table.Field                   */
/* Copyright 1986-2006 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/*V8:ConvertMode=NoConvert                                                    */
/* ORIGINATED BY: QAD EDI Global Services, Chris Theisen                      */
/*                                                                            */
/* REVISION:                CREATED: 03/03/05  BY: Chris Theisen       *    * */
/* REVISION:          LAST MODIFIED: 03/25/05  BY: Chris Theisen       *0001* */
/* REVISION:          LAST MODIFIED: 06/30/05  BY: Chris Theisen       *    * */
/*                       Add field list param capability, rewrite.            */
/* REVISION:          LAST MODIFIED: 06/15/06  BY: Chris Theisen       *0002* */
/******************************************************************************/

         /*
            Function parameters are:
               bh             Table handle
               ip_cFieldLst   Field to retrieve
               op_cResult     Return value
         */

         {mfdeclre.i}


         /* PARAMETERS */
         define input parameter bh           as handle.
         define input parameter ip_cFieldLst as character               no-undo.
         define output parameter op_cResult  as character               no-undo.


         /* LOCAL VARIABLES */
         define variable fh            as handle.

         define variable lv_cTable     as character                     no-undo.
         define variable lv_cField     as character                     no-undo.
         define variable lv_lFound     as logical                       no-undo.
         define variable lv_cLabel     as character                     no-undo.
         define variable lv_cCol-Label as character                     no-undo.
         define variable lv_cDataType  as character                     no-undo.
         define variable lv_cFormat    as character                     no-undo.
         define variable lv_cDesc      as character                     no-undo.
         define variable lv_cValExp    as character                     no-undo.
         define variable lv_cValMsg    as character                     no-undo.
         define variable lv_iExtent    as integer                       no-undo.

         define variable lv_iElement   as integer                       no-undo.
         define variable lv_iI         as integer                       no-undo.
         define variable lv_iJ         as integer                       no-undo.
         define variable lv_cOrgDB     as character                     no-undo.
         define variable lv_cValue     as character                     no-undo.


         /* Include the string conversion routines. */
         {pxstring.i}


         assign
            lv_cTable   = bh:name
            .

         do lv_iJ = 1 to num-entries(ip_cFieldLst):

            assign
               lv_cField   = entry(lv_iJ,ip_cFieldLst)
               lv_iElement = if num-entries(lv_cField,"[") = 2 then
                                integer(trim(entry(2,lv_cField,"["),"]")) else 0
               lv_iI       = index(lv_cField,"[")
               lv_iI       = if lv_iI = 0 then 30 else lv_iI - 1
               lv_cField   = substring(lv_cField,1,lv_iI)
/*0002*        fh = bh:buffer-field(lv_cField) */
               lv_cOrgDB   = ldbname("DICTDB")
               .

            do lv_iI = 1 to num-dbs:

               if dbtype(lv_iI) <> "PROGRESS" then
                  next.

               delete alias dictdb.
               create alias dictdb for database value(ldbname(lv_iI)).

               {gprun.i ""gpfield.p"" "(input lv_cField,
                                        input-output lv_cTable,
                                        output lv_lFound,
                                        output lv_cLabel,
                                        output lv_cCol-Label,
                                        output lv_cDataType,
                                        output lv_cFormat,
                                        output lv_cDesc,
                                        output lv_cValExp,
                                        output lv_cValMsg,
                                        output lv_iExtent)" }

               if lv_lFound then
                  leave.

            end. /* do lv_iI = 1 to num-dbs */

            delete alias dictdb.
            create alias dictdb for database value(lv_cOrgDB).

            if not lv_lFound then
               return.


/*0002*/    fh = bh:buffer-field(lv_cField).

            case fh:data-type:

               when "character" then
                   if(fh:extent > 1) then
                       lv_cValue = fh:buffer-value(lv_iElement).
                   else
                       lv_cValue = fh:buffer-value.

               when "logical" then
/*0001*/       do:
                   if(fh:extent > 1) then
                       lv_cValue = boolToChar(fh:buffer-value(lv_iElement)).
                   else
                       lv_cValue = boolToChar(fh:buffer-value).

/*0001*/          lv_cValue = string(lv_cValue = "true",fh:format).

/*0001*/       end. /* when "logical" */

               when "integer" then
                   if(fh:extent > 1) then
                       lv_cValue = intToChar(fh:buffer-value(lv_iElement)).
                   else
                       lv_cValue = intToChar(fh:buffer-value).

               when "decimal" then
                   if(fh:extent > 1) then
                       lv_cValue = decimalToChar(fh:buffer-value(lv_iElement)).
                   else
                       lv_cValue = decimalToChar(fh:buffer-value).

               when "date" then
                   if(fh:extent > 1) then
/*0002*                lv_cValue = dateToChar(fh:buffer-value(lv_iElement)). */
/*0002*/               lv_cValue = string(fh:buffer-value(lv_iElement)).
                   else
/*0002*                lv_cValue = dateToChar(fh:buffer-value). */
/*0002*/               lv_cValue = string(fh:buffer-value).

            end case. /* case fh:data-type */

            assign
               op_cResult  = op_cResult + lv_cValue
               op_cResult  = if lv_iJ <> num-entries(ip_cFieldLst) then
                                op_cResult + "^" else op_cResult
               .

         end. /* do lv_iJ = 1 to num-entries(ip_cFieldLst) */   