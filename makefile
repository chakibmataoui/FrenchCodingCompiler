all : bison flex
	gcc -o comp lex.yy.c compil.tab.c

bison :
	bison -d compil.y

flex :
	flex compil.l

flex-alone : flex
	gcc -o flex_comp lex.yy.c

clean :
	rm *~ flex_comp comp 
