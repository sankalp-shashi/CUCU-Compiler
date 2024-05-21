**COMPILING**
# 	lex cucu.l
#	yacc -d cucu.y
IF YOUR SYSTEM GENERATES cucu.tab.c AND cucu.tab.h, give the following command:
#	gcc lex.yy.c cucu.tab.c -o cucu
OTHERWISE IF YOUR SYSTEM GENERATED y.tab.c and y.tab.h give the following command:
#	gcc lex.yy.c y.tab.c -o cucu

*********************************************************************************************************************************************************************

**RUNNING**
#	./cucu Sample1.cu
#	./cucu Sample2.cu

*********************************************************************************************************************************************************************

**ASSUMPTIONS**
# 1. every if must also have a corresponding else.
# 2. braces are required for the body part following if, else, and while.
# 3. 
