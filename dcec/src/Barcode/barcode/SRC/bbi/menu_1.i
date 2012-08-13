
/*1*/ DEFINE SUB-MENU sm-database
MENU-ITEM mi-Cust LABEL "&Customer"
MENU-ITEM mi-Order LABEL "&Order".
MENU-ITEM mi-Exit LABEL "E&xit".

DEFINE SUB-MENU sm-open.

DEFINE SUB-MENU sm-import
/*2*/ SUB-MENU sm-Open LABEL "O&pen"
      MENU-ITEM mi-imimmt LABEL "maintain im"
      MENU-ITEM mi-imimld LABEL "load im"
      MENU-ITEM mi-imrsmt LABEL "maintain reason code"
      MENU-ITEM mi-immgmt LABEL "maintain merge"
      MENU-ITEM mi-imvamt LABEL "variance maintain"
      MENU-ITEM mi-imfrld  LABEL "load freight"
      MENU-ITEM mi-progress LABEL "P&progress".
/*3*/ 

DEFINE SUB-MENU sm-export
MENU-ITEM mi-Cust LABEL "&Monthly Summary"
MENU-ITEM mi-Labels LABEL "Mailing Labels"
/*4*/ RULE
/*5*/ MENU-ITEM mi-Balances LABEL "Order Tot&als" DISABLED
MENU-ITEM mi-Today LABEL "Order &Items" DISABLED
RULE
/*6*/ MENU-ITEM mi-Print LABEL "&Output to Printer" TOGGLE-BOX.

DEFINE SUB-MENU sm-internal.

DEFINE SUB-MENU sm-Help
MENU-ITEM mi-Help LABEL "H&elp".

/*7*/ DEFINE MENU mbar MENUBAR
SUB-MENU sm-database LABEL "&Database"
SUB-MENU sm-import LABEL "&Import"
SUB-MENU sm-export LABEL "&Export"
SUB-MENU sm-internal LABEL "&Internal"
SUB-MENU sm-Help LABEL "&Help".


/*8*/ ASSIGN DEFAULT-WINDOW:MENUBAR = MENU mbar:HANDLE.

