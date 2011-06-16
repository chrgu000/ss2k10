/* 程序说明： 自定义表格维护程序                                            */
/* 自定义表名称：xx_ptdet                                                   */
/* 表格说明：  由于我们的很多管理内容在原 pt_det 均没有字段可以使用，在原表 */
/* 格添加字段将是程序要全部重新编译，因此另外做了一个pt表的自定义扩充表格。 */
/* 表格内容：  发料单位数量，发料员，每箱数量，每托箱数                     */

/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

{mfdeclre.i }

/* EXTERNAL LABEL INCLUDE */
{gplabel.i}

{wbrp01.i}

define variable ppform as character no-undo.

ppform = "a".

{gprun.i ""xxinv.p"" "(input ppform)"}
/*! gprun.i 引用语法
Runs a program from a 2-letter subdirectory, where the program MUST be.

{1} program name 程序名称
{2} parameters to pass the program
{3} optional [ PERSISTENT [set handle] ] parameter for Progress v7.

Sample: run value(global_user_lang_dir + substring({1},1,2) + '/' + {1}) {3} {2}.
*/


{wbrp04.i}
