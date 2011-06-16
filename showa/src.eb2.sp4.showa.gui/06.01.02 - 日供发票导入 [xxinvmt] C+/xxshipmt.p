/* 程序说明： 自定义表格维护程序                                            */
/* 自定义表名称：xxinvomt                                                   */

/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

{mfdeclre.i}

/* EXTERNAL LABEL INCLUDE */
{gplabel.i}

{wbrp01.i}

define variable ppform as character no-undo.

ppform = "a".

{gprun.i ""xxship.p"" "(input ppform)"}
/*! gprun.i 引用语法
Runs a program from a 2-letter subdirectory, where the program MUST be.

{1} program name 程序名称
{2} parameters to pass the program
{3} optional [ PERSISTENT [set handle] ] parameter for Progress v7.

Sample: run value(global_user_lang_dir + substring({1},1,2) + '/' + {1}) {3} {2}.
*/


{wbrp04.i}
