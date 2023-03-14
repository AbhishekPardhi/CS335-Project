%{
    /* Declaration */
    #include <bits/stdc++.h>
    #include "data.h"
	#include "symbol_table.cpp"
    // #include "data.cpp"
    using namespace std;
    int yylex();
    extern int yylineno;
    void yyerror(const char *s) {
        printf("\nError: %s at line %d\n", s, yylineno);
        exit(0);
        return;
    }
    NODE *start_node;
	fstream fout;
	extern FILE *yyin;
	// domain name of symbol table like function name , the correspinding symbol set and attributes
	vector<pair<string,st>> symbol_tables;
	stl* st_node= new stl;
	st global_st;
	symbol_tables.push_back(<"global",global_st>);
	st_node= make_st_node("global",&global_st,NULL);

%}

%union {
    NODE *elem;
}

%token <elem>  BITWISE_AND BITWISE_OR COMMA FINALLY LPAREN RPAREN IDENTIFIER EQUALS DOT CLASS PUBLIC PRIVATE SEMICOLON COLON OR RETURN TRY SYNCHRONIZED THROW BREAK CONTINUE CATCH FINAL IF ELSE WHILE FOR LSPAR RSPAR TIMES_EQUALS DIVIDE_EQUALS MOD_EQUALS PLUS_EQUALS MINUS_EQUALS LEFT_SHIFT_EQUALS RIGHT_SHIFT_EQUALS UNSIGNED_RIGHT_SHIFT_EQUALS AND_EQUALS XOR_EQUALS OR_EQUALS QUESTION NOT_EQUALS LT GT LE GE INSTANCEOF AND XOR PLUS MINUS TIMES DIVIDE MOD PLUS_PLUS MINUS_MINUS TILDE THIS SUPER INT LONG SHORT BYTE CHAR IMPLEMENTS FLOAT DOUBLE BOOLEAN VOID NOT EXTENDS RMPARA LMPARA STATIC LEFT_SHIFT RIGHT_SHIFT UNSIGNED_RIGHT_SHIFT LITERAL THROWS NEW IMPORT PACKAGE INTERFACE EQUALS_EQUALS 
%type <elem> Goal CompilationUnit Type PrimitiveType NumericType IntegralType FloatingPointType ReferenceType ClassOrInterfaceType ClassType InterfaceType ArrayType Name SimpleName QualifiedName ImportDeclarations TypeDeclarations PackageDeclaration ImportDeclaration TypeDeclaration Modifiers Modifier ClassDeclaration Super Interfaces ClassBody ClassBodyDeclarations ClassBodyDeclaration ClassMemberDeclaration FieldDeclaration VariableDeclarators VariableDeclarator VariableDeclaratorId VariableInitializer MethodDeclaration MethodHeader MethodDeclarator FormalParameterList Throws ClassTypeList MethodBody StaticInitializer ConstructorDeclaration ConstructorDeclarator ConstructorBody InterfaceDeclaration Expression ArrayInitializer FormalParameter Block SingleTypeImportDeclaration TypeImportOnDemandDeclaration AssignmentExpression ConditionalExpression Assignment ConditionalOrExpression LeftHandSide ConditionalAndExpression InclusiveOrExpression ExclusiveOrExpression AndExpression EqualityExpression RelationalExpression ShiftExpression AdditiveExpression MultiplicativeExpression UnaryExpression PreIncrementExpression PreDecrementExpression UnaryExpressionNotPlusMinus PostIncrementExpression PostDecrementExpression CastExpression Primary PrimaryNoNewArray ArrayCreationExpression ArrayAccess FieldAccess MethodInvocation ClassInstanceCreationExpression ArgumentList PostfixExpression InterfaceTypeList ExplicitConstructorInvocation InterfaceBody InterfaceMemberDeclarations InterfaceMemberDeclaration ConstantDeclaration AbstractMethodDeclaration ExtendsInterfaces AssignmentOperator Dims DimExprs DimExpr VariableInitializers BlockStatements BlockStatement LocalVariableDeclarationStatement Statement StatementNoShortIf StatementWithoutTrailingSubstatement IfThenStatement IfThenElseStatement IfThenElseStatementNoShortIf WhileStatement WhileStatementNoShortIf ForStatement ForStatementNoShortIf ForInit ForUpdate StatementExpression StatementExpressionList LocalVariableDeclaration EmptyStatement LabeledStatement ExpressionStatement BreakStatement ContinueStatement ReturnStatement ThrowStatement SynchronizedStatement TryStatement Catches CatchClause Finally LabeledStatementNoShortIf

%%
// Grammer
// Start
Goal:
	CompilationUnit	{ $$ = create_node ( 2 ,"Goal", $1); start_node=$$; } 
;

Type:
	PrimitiveType	{ $$ = $1; }
|	ReferenceType	{ $$ = $1; }
;

PrimitiveType:
	NumericType	{ $$ = $1; }
|	BOOLEAN	{ $$ = $1; }
;

NumericType:
	IntegralType	{ $$ = $1; }
|	FloatingPointType	{ $$ = $1; }
;

IntegralType:
	BYTE 	{ $$ = $1; }
|	SHORT 	{ $$ = $1; }
|	INT 	{ $$ = $1; }
|	LONG 	{ $$ = $1; }
|	CHAR	{ $$ = $1; }
;

FloatingPointType:
	FLOAT 	{ $$ = $1; }
|	DOUBLE	{ $$ = $1; }
;

ReferenceType:
	ClassOrInterfaceType	{ $$ = $1; }
|	ArrayType	{ $$ = $1; }
;

ClassOrInterfaceType:
	Name	{ $$ = $1; }
;

ClassType:
	ClassOrInterfaceType	{ $$ = $1; }
;

InterfaceType:
	ClassOrInterfaceType	{ $$ = $1; }
;

ArrayType:
	PrimitiveType LSPAR RSPAR 	{ $$ = create_node ( 4 ,"Array_Type", $1, $2, $3); } 
|	Name LSPAR RSPAR	{ $$ = create_node ( 4 ,"Array_Type", $1, $2, $3); } 
|	ArrayType LSPAR RSPAR	{ $$ = create_node ( 4 ,"Array_Type", $1, $2, $3); } 
;


Name:
	SimpleName	{ $$ = $1; }
|	QualifiedName	{ $$ = $1; }
;

SimpleName:
	IDENTIFIER	{ $$ = $1; }
;

QualifiedName:
	Name DOT IDENTIFIER	{ $$ = create_node ( 4 ,"Qualified_Name", $1, $2, $3); } 
;

CompilationUnit:
	PackageDeclaration ImportDeclarations TypeDeclarations	{ $$ = create_node ( 4 ,"Compilation_Unit", $1, $2, $3); }
|	ImportDeclarations PackageDeclaration TypeDeclarations	{ $$ = create_node ( 4 ,"Compilation_Unit", $1, $2, $3); }
|	ImportDeclarations TypeDeclarations	{ $$ = create_node ( 3 ,"Compilation_Unit", $1, $2); } 
|	PackageDeclaration TypeDeclarations	{ $$ = create_node ( 3 ,"Compilation_Unit", $1, $2); } 
|	TypeDeclarations	{ $$ = $1; }
|	PackageDeclaration ImportDeclarations 	{ $$ = create_node ( 3 ,"Compilation_Unit", $1, $2); } 
|	ImportDeclarations PackageDeclaration 	{ $$ = create_node ( 3 ,"Compilation_Unit", $1, $2); }
|	ImportDeclarations 	{ $$ = $1; }
|	PackageDeclaration 	{ $$ = $1; }
|	{$$ = create_node(1,"EMPTY");}
;


ImportDeclarations:
	ImportDeclaration	{ $$ = create_node(2,"Import_Declarations",$1) ; }
|	ImportDeclarations ImportDeclaration	{ $1->children.push_back($2); $$ =$1 ;} 
;

TypeDeclarations:
	TypeDeclaration	{ $$ = create_node(2,"Type_Declarations",$1) ; }
|	TypeDeclarations TypeDeclaration	{ $1->children.push_back($2); $$ =$1 ; } 
;

PackageDeclaration:
	PACKAGE Name SEMICOLON	{ $$ = create_node ( 4 ,"Package_Declaration", $1, $2, $3); } 
;

ImportDeclaration:
	SingleTypeImportDeclaration	{ $$ = $1; }
|	TypeImportOnDemandDeclaration	{ $$ = $1; }
;

SingleTypeImportDeclaration:
	IMPORT Name SEMICOLON	{ $$ = create_node ( 4 ,"Single_Type_Import_Declaration", $1, $2, $3); } 
;

TypeImportOnDemandDeclaration:
	IMPORT Name DOT TIMES SEMICOLON	{ $$ = create_node ( 6 ,"Type_Import_On_Demand_Declaration", $1, $2, $3, $4, $5); } 
;


TypeDeclaration:
	ClassDeclaration	{ $$ = $1; }
|	InterfaceDeclaration	{ $$ = $1; }
|	SEMICOLON	{ $$ = $1; }
;

Modifiers:
	Modifier	{ $$ = create_node(2,"Modifiers",$1) ; }
|	Modifiers Modifier	{ $1->children.push_back($2); $$ =$1 ; } 
;

Modifier:
	PUBLIC	{ $$ = $1; }
|	PRIVATE	{ $$ = $1; }
|	STATIC	{ $$ = $1; }
|	FINAL	{ $$ = $1; }
;

ClassDeclaration:
	Modifiers CLASS IDENTIFIER Super Interfaces ClassBody	{ $$ = create_node ( 7 ,"Class_Declaration", $1, $2, $3, $4, $5, $6); } 
|	CLASS IDENTIFIER Interfaces ClassBody	{ $$ = create_node ( 5 ,"Class_Declaration", $1, $2, $3, $4); } 
|	Modifiers CLASS IDENTIFIER Super ClassBody	{ $$ = create_node ( 6 ,"Class_Declaration", $1, $2, $3, $4, $5); } 
|	Modifiers CLASS IDENTIFIER Interfaces ClassBody	{ $$ = create_node ( 6 ,"Class_Declaration", $1, $2, $3, $4, $5); } 
|	CLASS IDENTIFIER ClassBody	{ $$ = create_node ( 4 ,"Class_Declaration", $1, $2, $3); } 
|	Modifiers CLASS IDENTIFIER ClassBody	{ $$ = create_node ( 5 ,"Class_Declaration", $1, $2, $3, $4); } 
;

Super:
	EXTENDS ClassType	{ $$ = create_node ( 3 ,"Super", $1, $2); } 
;

Interfaces:
	IMPLEMENTS InterfaceTypeList	{ $$ = create_node ( 3 ,"Interfaces", $1, $2); } 
;

InterfaceTypeList:
	InterfaceType	{ $$ = create_node(2,"Interface_Type_List",$1) ; }
|	InterfaceTypeList COMMA InterfaceType	{ $1->children.push_back($2);$1->children.push_back($3); $$ =$1 ;} 
;

ClassBody:
	LMPARA ClassBodyDeclarations RMPARA	{ $$ = create_node ( 4 ,"ClassBody", $1, $2, $3); } 
|	LMPARA RMPARA	{ $$ = create_node ( 3 ,"ClassBody", $1, $2); } 
;

ClassBodyDeclarations:
	ClassBodyDeclaration	{$$ = create_node(2,"Class_Body_Declarations",$1) ; }
|	ClassBodyDeclarations ClassBodyDeclaration	{ $1->children.push_back($2); $$ =$1 ; } 
;

ClassBodyDeclaration:
	ClassMemberDeclaration	{ $$ = $1; }
|	StaticInitializer	{ $$ = $1; }
|	ConstructorDeclaration	{ $$ = $1; }
;

ClassMemberDeclaration:
	FieldDeclaration	{ $$ = $1; }
|	MethodDeclaration	{ $$ = $1; }
;

FieldDeclaration:
	Modifiers Type VariableDeclarators SEMICOLON	{ $$ = create_node ( 5 ,"FieldDeclaration", $1, $2, $3, $4); } 
|	Type VariableDeclarator SEMICOLON	{ $$ = create_node ( 4 ,"FieldDeclaration", $1, $2, $3); } 
;

VariableDeclarators:
	VariableDeclarator	{ $$ = create_node(2,"Variable_declarators",$1) ; }
|	VariableDeclarators COMMA VariableDeclarator	{ $1->children.push_back($2);$1->children.push_back($3); $$ =$1 ;} 
;

VariableDeclarator:
	VariableDeclaratorId	{ $$ = $1; }
|	VariableDeclaratorId EQUALS VariableInitializer	{ $$ = create_node ( 3 ,$2->val, $1, $3); } 
;

VariableDeclaratorId:
	IDENTIFIER	{ $$ = create_node(2,"Varaible_Declarator_Id",$1) ; }
|	VariableDeclaratorId LSPAR RSPAR	{ $1->children.push_back($2);$1->children.push_back($3); $$ =$1 ;} 
;

VariableInitializer:
	Expression	{ $$ = $1; }
|	ArrayInitializer	{ $$ = $1; }
;

MethodDeclaration:
	MethodHeader MethodBody	{ $$ = create_node ( 3 ,"MethodDeclaration", $1, $2); } 
;

MethodHeader:
	Modifiers Type MethodDeclarator Throws	{ $$ = create_node ( 5 ,"MethodHeader", $1, $2, $3, $4); } 
|	Modifiers Type MethodDeclarator	{ $$ = create_node ( 4 ,"MethodHeader", $1, $2, $3); } 
|	Type MethodDeclarator Throws	{ $$ = create_node ( 4 ,"MethodHeader", $1, $2, $3); } 
|	Type MethodDeclarator	{ $$ = create_node ( 3 ,"MethodHeader", $1, $2); } 
|	Modifiers VOID MethodDeclarator Throws	{ $$ = create_node ( 5 ,"MethodHeader", $1, $2, $3, $4); } 
|	Modifiers VOID MethodDeclarator	{ $$ = create_node ( 4 ,"MethodHeader", $1, $2, $3); } 
|	VOID MethodDeclarator Throws	{ $$ = create_node ( 4 ,"MethodHeader", $1, $2, $3); } 
|	VOID MethodDeclarator	{ $$ = create_node ( 3 ,"MethodHeader", $1, $2); } 
;


MethodDeclarator:
	IDENTIFIER LPAREN FormalParameterList RPAREN	{ $$ = create_node ( 5 ,"MethodDeclarator", $1, $2, $3, $4);} 
|	MethodDeclarator LSPAR RSPAR	{ $$ = create_node ( 4 ,"MethodDeclarator", $1, $2, $3); } 
|	IDENTIFIER LPAREN RPAREN	{ $$ = create_node ( 4 ,"MethodDeclarator", $1, $2, $3); } 
;

FormalParameterList:
	FormalParameter	{ $$ = create_node(2,"Formal_Parameter_List",$1) ; }
|	FormalParameterList COMMA FormalParameter	{ $1->children.push_back($2);$1->children.push_back($3); $$ =$1 ;} 
;

FormalParameter:
	Type VariableDeclaratorId	{ $$ = create_node ( 3 ,"FormalParameter", $1, $2); } 
|	FINAL Type VariableDeclaratorId	{ $$ = create_node ( 4 ,"FormalParameter", $1, $2, $3); }
;

Throws:
	THROWS ClassTypeList	{ $$ = create_node ( 3 ,"Throws", $1, $2); } 
;

ClassTypeList:
	ClassType	{ $$ = create_node(2,"Class_Type_List",$1) ; }
|	ClassTypeList COMMA ClassType	{ $1->children.push_back($2);$1->children.push_back($3); $$ =$1 ;} 
;

MethodBody:
	Block 	{ $$ = $1; }
|	SEMICOLON	{ $$ = $1; }
;


StaticInitializer:
	STATIC Block	{ $$ = create_node ( 3 ,"StaticInitializer", $1, $2); } 
;

ConstructorDeclaration:
	Modifiers ConstructorDeclarator Throws ConstructorBody	{ $$ = create_node ( 5 ,"ConstructorDeclaration", $1, $2, $3, $4); } 
|	Modifiers ConstructorDeclarator ConstructorBody	{ $$ = create_node ( 4 ,"ConstructorDeclaration", $1, $2, $3); } 
|	ConstructorDeclarator Throws ConstructorBody	{ $$ = create_node ( 4 ,"ConstructorDeclaration", $1, $2, $3); } 
|	ConstructorDeclarator ConstructorBody		{ $$ = create_node ( 3 ,"ConstructorDeclaration", $1, $2); } 
;

ConstructorDeclarator:
	SimpleName LPAREN FormalParameterList RPAREN	{ $$ = create_node ( 5 ,"ConstructorDeclarator", $1, $2, $3, $4); } 
|	SimpleName LPAREN RPAREN	{ $$ = create_node ( 4 ,"ConstructorDeclarator", $1, $2, $3); } 
;

ConstructorBody:
	LMPARA ExplicitConstructorInvocation BlockStatements RMPARA	{ $$ = create_node ( 5 ,"ConstructorBody", $1, $2, $3, $4); } 
|	LMPARA ExplicitConstructorInvocation RMPARA	{ $$ = create_node ( 4 ,"ConstructorBody", $1, $2, $3); } 
|	LMPARA BlockStatements RMPARA	{ $$ = create_node ( 4 ,"ConstructorBody", $1, $2, $3); } 
|	LMPARA RMPARA	{ $$ = create_node ( 3 ,"ConstructorBody", $1, $2); } 
;


ExplicitConstructorInvocation:
	THIS LPAREN ArgumentList RPAREN SEMICOLON	{ $$ = create_node ( 6 ,"ExplicitConstructorInvocation", $1, $2, $3, $4, $5); } 
|	THIS LPAREN RPAREN SEMICOLON	{ $$ = create_node ( 5 ,"ExplicitConstructorInvocation", $1, $2, $3, $4); } 
|	SUPER LPAREN ArgumentList RPAREN SEMICOLON	{ $$ = create_node ( 6 ,"ExplicitConstructorInvocation", $1, $2, $3, $4, $5); } 
|	SUPER LPAREN RPAREN SEMICOLON	{ $$ = create_node ( 5 ,"ExplicitConstructorInvocation", $1, $2, $3, $4); } 
;

InterfaceDeclaration:
	Modifiers INTERFACE IDENTIFIER ExtendsInterfaces InterfaceBody	{ $$ = create_node ( 6 ,"InterfaceDeclaration", $1, $2, $3, $4, $5); } 
|	Modifiers INTERFACE IDENTIFIER InterfaceBody	{ $$ = create_node ( 5 ,"InterfaceDeclaration", $1, $2, $3, $4); } 
|	INTERFACE IDENTIFIER ExtendsInterfaces InterfaceBody	{ $$ = create_node ( 5 ,"InterfaceDeclaration", $1, $2, $3, $4); } 
|	INTERFACE IDENTIFIER InterfaceBody	{ $$ = create_node ( 4 ,"InterfaceDeclaration", $1, $2, $3); } 
;

ExtendsInterfaces:
	EXTENDS InterfaceType	{ $$ = create_node(3,"Extends_Interfaces",$1,$2) ; } 
|	ExtendsInterfaces COMMA InterfaceType	{ $1->children.push_back($2);$1->children.push_back($3); $$ =$1 ; } 
;

InterfaceBody:
	LMPARA InterfaceMemberDeclarations RMPARA	{ $$ = create_node ( 4 ,"InterfaceBody", $1, $2, $3); } 
|	LMPARA RMPARA	{ $$ = create_node ( 3 ,"InterfaceBody", $1, $2); } 
;

InterfaceMemberDeclarations:
	InterfaceMemberDeclaration	{$$ = create_node(2,"Interface_Member_Decalarations",$1) ; }
|	InterfaceMemberDeclarations InterfaceMemberDeclaration	{ $1->children.push_back($2); $$ =$1 ; } 
;

InterfaceMemberDeclaration:
	ConstantDeclaration	{ $$ = $1; }
|	AbstractMethodDeclaration	{ $$ = $1; }
;

ConstantDeclaration:
	FieldDeclaration	{ $$ = $1; }
;

AbstractMethodDeclaration:
	MethodHeader SEMICOLON	{ $$ = create_node ( 3 ,"AbstractMethodDeclaration", $1, $2); } 
;


ArrayInitializer:
	LMPARA VariableInitializers COMMA RMPARA	{ $$ = create_node ( 5 ,"ArrayInitializer", $1, $2, $3, $4); } 
|	LMPARA VariableInitializers RMPARA	{ $$ = create_node ( 4 ,"ArrayInitializer", $1, $2, $3); } 
|	LMPARA COMMA RMPARA	{ $$ = create_node ( 4 ,"ArrayInitializer", $1, $2, $3); } 
|	LMPARA RMPARA	{ $$ = create_node ( 3 ,"ArrayInitializer", $1, $2); } 
;

VariableInitializers:
	VariableInitializer	{ $$ = create_node(2,"Variable_Initializers",$1) ; }
|	VariableInitializers COMMA VariableInitializer	{$1->children.push_back($2);$1->children.push_back($3); $$ =$1 ; } 
;


Block:
	LMPARA BlockStatements RMPARA	{ $$ = create_node ( 4 ,"Block", $1, $2, $3); } 
|	LMPARA RMPARA	{ $$ = create_node ( 3 ,"Block", $1, $2); } 
;

BlockStatements:
	BlockStatement	{ $$ = create_node(2,"Block_Statements",$1) ; }
|	BlockStatements BlockStatement	{$1->children.push_back($2); $$ =$1 ;} 
;

BlockStatement:
	LocalVariableDeclarationStatement	{ $$ = $1; }
|	Statement	{ $$ = $1; }
;

LocalVariableDeclarationStatement:
	LocalVariableDeclaration SEMICOLON	{ $$ = create_node ( 3 ,"LocalVariableDeclarationStatement", $1, $2); } 
;

LocalVariableDeclaration:
	Type VariableDeclarators	{ $$ = create_node ( 3 ,"LocalVariableDeclaration", $1, $2); } 
|	FINAL Type VariableDeclarators	{ $$ = create_node ( 4 ,"LocalVariableDeclaration", $1, $2, $3); }
;

Statement:
	StatementWithoutTrailingSubstatement	{ $$ = $1; }
|	LabeledStatement	{ $$ = $1; }
|	IfThenStatement	{ $$ = $1; }
|	IfThenElseStatement	{ $$ = $1; }
|	WhileStatement	{ $$ = $1; }
|	ForStatement	{ $$ = $1; }
;

StatementNoShortIf:
	StatementWithoutTrailingSubstatement	{ $$ = $1; }
|	LabeledStatementNoShortIf	{ $$ = $1; }
|	IfThenElseStatementNoShortIf	{ $$ = $1; }
|	WhileStatementNoShortIf	{ $$ = $1; }
|	ForStatementNoShortIf	{ $$ = $1; }
;

StatementWithoutTrailingSubstatement:
	Block	{ $$ = $1; }
|	EmptyStatement	{ $$ = $1; }
|	ExpressionStatement	{ $$ = $1; }
|	BreakStatement	{ $$ = $1; }
|	ContinueStatement	{ $$ = $1; }
|	ReturnStatement	{ $$ = $1; }
|	SynchronizedStatement	{ $$ = $1; }
|	ThrowStatement	{ $$ = $1; }
|	TryStatement	{ $$ = $1; }
;

EmptyStatement:
	SEMICOLON	{ $$ = $1; }
;

LabeledStatement:
	IDENTIFIER COLON Statement	{ $$ = create_node ( 4 ,"LabeledStatement", $1, $2, $3); } 
;

LabeledStatementNoShortIf:
	IDENTIFIER COLON StatementNoShortIf	{ $$ = create_node ( 4 ,"LabeledStatementNoShortIf", $1, $2, $3); } 
;

ExpressionStatement:
	StatementExpression SEMICOLON	{ $$ = create_node ( 3 ,"ExpressionStatement", $1, $2); } 
;

StatementExpression:
	Assignment	{ $$ = $1; }
|	PreIncrementExpression	{ $$ = $1; }
|	PreDecrementExpression	{ $$ = $1; }
|	PostIncrementExpression	{ $$ = $1; }
|	PostDecrementExpression	{ $$ = $1; }
|	MethodInvocation	{ $$ = $1; }
|	ClassInstanceCreationExpression	{ $$ = $1; }
;

IfThenStatement:
	IF LPAREN Expression RPAREN Statement	{ $$ = create_node ( 6 ,"IfThenStatement", $1, $2, $3, $4, $5); } 
;

IfThenElseStatement:
	IF LPAREN Expression RPAREN StatementNoShortIf ELSE Statement	{ $$ = create_node ( 8 ,"IfThenElseStatement", $1, $2, $3, $4, $5, $6, $7); } 
;

IfThenElseStatementNoShortIf:
	IF LPAREN Expression RPAREN StatementNoShortIf ELSE StatementNoShortIf	{ $$ = create_node ( 8 ,"IfThenElseStatementNoShortIf", $1, $2, $3, $4, $5, $6, $7); } 
;

WhileStatement:
	WHILE LPAREN Expression RPAREN Statement	{ $$ = create_node ( 6 ,"WhileStatement", $1, $2, $3, $4, $5); } 
;

WhileStatementNoShortIf:
	WHILE LPAREN Expression RPAREN StatementNoShortIf	{ $$ = create_node ( 6 ,"WhileStatementNoShortIf", $1, $2, $3, $4, $5); } 
;

ForStatement:
	FOR LPAREN ForInit SEMICOLON Expression SEMICOLON ForUpdate RPAREN Statement	{ $$ = create_node ( 10 ,"ForStatement", $1, $2, $3, $4, $5, $6, $7, $8, $9); } 
|	FOR LPAREN ForInit SEMICOLON SEMICOLON ForUpdate RPAREN Statement	{ $$ = create_node ( 9 ,"ForStatement", $1, $2, $3, $4, $5, $6, $7, $8); } 
|	FOR LPAREN SEMICOLON Expression SEMICOLON ForUpdate RPAREN Statement	{ $$ = create_node ( 9 ,"ForStatement", $1, $2, $3, $4, $5, $6, $7, $8); } 
|	FOR LPAREN SEMICOLON SEMICOLON ForUpdate RPAREN Statement	{ $$ = create_node ( 8 ,"ForStatement", $1, $2, $3, $4, $5, $6, $7); } 
|	FOR LPAREN ForInit SEMICOLON Expression SEMICOLON RPAREN Statement	{ $$ = create_node ( 9 ,"ForStatement", $1, $2, $3, $4, $5, $6, $7, $8); } 
|	FOR LPAREN ForInit SEMICOLON SEMICOLON RPAREN Statement	{ $$ = create_node ( 8 ,"ForStatement", $1, $2, $3, $4, $5, $6, $7); } 
|	FOR LPAREN SEMICOLON Expression SEMICOLON RPAREN Statement	{ $$ = create_node ( 8 ,"ForStatement", $1, $2, $3, $4, $5, $6, $7); } 
|	FOR LPAREN SEMICOLON SEMICOLON RPAREN Statement	{ $$ = create_node ( 7 ,"ForStatement", $1, $2, $3, $4, $5, $6); } 
;

ForStatementNoShortIf:
	FOR LPAREN ForInit SEMICOLON Expression SEMICOLON ForUpdate RPAREN StatementNoShortIf	{ $$ = create_node ( 10 ,"ForStatementNoShortIf", $1, $2, $3, $4, $5, $6, $7, $8, $9); } 
|	FOR LPAREN ForInit SEMICOLON SEMICOLON ForUpdate RPAREN StatementNoShortIf	{ $$ = create_node ( 9 ,"ForStatementNoShortIf", $1, $2, $3, $4, $5, $6, $7, $8); } 
|	FOR LPAREN SEMICOLON Expression SEMICOLON ForUpdate RPAREN StatementNoShortIf	{ $$ = create_node ( 9 ,"ForStatementNoShortIf", $1, $2, $3, $4, $5, $6, $7, $8); } 
|	FOR LPAREN SEMICOLON SEMICOLON ForUpdate RPAREN StatementNoShortIf	{ $$ = create_node ( 8 ,"ForStatementNoShortIf", $1, $2, $3, $4, $5, $6, $7); } 
|	FOR LPAREN ForInit SEMICOLON Expression SEMICOLON RPAREN StatementNoShortIf	{ $$ = create_node ( 9 ,"ForStatementNoShortIf", $1, $2, $3, $4, $5, $6, $7, $8); } 
|	FOR LPAREN ForInit SEMICOLON SEMICOLON RPAREN StatementNoShortIf	{ $$ = create_node ( 8 ,"ForStatementNoShortIf", $1, $2, $3, $4, $5, $6, $7); } 
|	FOR LPAREN SEMICOLON Expression SEMICOLON RPAREN StatementNoShortIf	{ $$ = create_node ( 8 ,"ForStatementNoShortIf", $1, $2, $3, $4, $5, $6, $7); } 
|	FOR LPAREN SEMICOLON SEMICOLON RPAREN StatementNoShortIf	{ $$ = create_node ( 7 ,"ForStatementNoShortIf", $1, $2, $3, $4, $5, $6); } 
;

ForInit:
	StatementExpressionList	{ $$ = $1; }
|	LocalVariableDeclaration	{ $$ = $1; }
;

ForUpdate:
	StatementExpressionList	{ $$ = $1; }
;

StatementExpressionList:
	StatementExpression	{ $$ = create_node(2,"Statement_Expression_List",$1) ; }
|	StatementExpressionList COMMA StatementExpression	{ $1->children.push_back($2);$1->children.push_back($3); $$ =$1 ; } 
;

BreakStatement:
	BREAK IDENTIFIER SEMICOLON	{ $$ = create_node ( 4 ,"BreakStatement", $1, $2, $3); } 
|	BREAK SEMICOLON	{ $$ = create_node ( 3 ,"BreakStatement", $1, $2); } 
;

ContinueStatement:
	CONTINUE IDENTIFIER SEMICOLON	{ $$ = create_node ( 4 ,"ContinueStatement", $1, $2, $3); } 
|	CONTINUE SEMICOLON	{ $$ = create_node ( 3 ,"ContinueStatement", $1, $2); } 
;

ReturnStatement:
	RETURN Expression SEMICOLON	{ $$ = create_node ( 4 ,"ReturnStatement", $1, $2, $3); } 
|	RETURN SEMICOLON	{ $$ = create_node ( 3 ,"ReturnStatement", $1, $2); } 
;

ThrowStatement:
	THROW Expression SEMICOLON	{ $$ = create_node ( 4 ,"ThrowStatement", $1, $2, $3); } 
;

SynchronizedStatement:
	SYNCHRONIZED LPAREN Expression RPAREN Block	{ $$ = create_node ( 6 ,"SynchronizedStatement", $1, $2, $3, $4, $5); } 
;

TryStatement:
	TRY Block Catches	{ $$ = create_node ( 4 ,"TryStatement", $1, $2, $3); } 
|	TRY Block Catches Finally	{ $$ = create_node ( 5 ,"TryStatement", $1, $2, $3, $4); } 
|	TRY Block Finally	{ $$ = create_node ( 4 ,"TryStatement", $1, $2, $3); } 
;


Catches:
	CatchClause{$$ = create_node(2,"Catches",$1) ; }
|	Catches CatchClause	{ $1->children.push_back($2); $$ =$1 ;} 
;

CatchClause:
	CATCH LPAREN FormalParameter RPAREN Block	{ $$ = create_node ( 6 ,"CatchClause", $1, $2, $3, $4, $5); } 
;

Finally:
	FINALLY Block	{ $$ = create_node ( 3 ,"Finally", $1, $2); } 
;

Primary:
	PrimaryNoNewArray	{ $$ = $1; }
|	ArrayCreationExpression	{ $$ = $1; }
;

PrimaryNoNewArray:
	LITERAL	{ $$ = $1; }
|	THIS	{ $$ = $1; }
|	LPAREN Expression RPAREN	{ $$ = create_node ( 4 ,"PrimaryNoNewArray", $1, $2, $3); } 
|	ClassInstanceCreationExpression	{ $$ = $1; }
|	FieldAccess	{ $$ = $1; }
|	MethodInvocation	{ $$ = $1; }
|	ArrayAccess	{ $$ = $1; }
;

ClassInstanceCreationExpression:
	NEW ClassType LPAREN ArgumentList RPAREN	{ $$ = create_node ( 6 ,"ClassInstanceCreationExpression", $1, $2, $3, $4, $5); } 
|	NEW ClassType LPAREN RPAREN	{ $$ = create_node ( 5 ,"ClassInstanceCreationExpression", $1, $2, $3, $4); } 
;

ArgumentList:
	Expression	{ $$ = create_node(2,"Argument_List",$1) ; }
|	ArgumentList COMMA Expression	{ $1->children.push_back($2);$1->children.push_back($3); $$ =$1 ;} 
;

ArrayCreationExpression:
	NEW PrimitiveType DimExprs Dims	{ $$ = create_node ( 5 ,"ArrayCreationExpression", $1, $2, $3, $4); } 
|	NEW PrimitiveType DimExprs	{ $$ = create_node ( 4 ,"ArrayCreationExpression", $1, $2, $3); } 
|	NEW ClassOrInterfaceType DimExprs Dims	{ $$ = create_node ( 5 ,"ArrayCreationExpression", $1, $2, $3, $4); } 
|	NEW ClassOrInterfaceType DimExprs	{ $$ = create_node ( 4 ,"ArrayCreationExpression", $1, $2, $3); } 
;

DimExprs:
	DimExpr	{ $$ = create_node(2,"Dim_Expers",$1) ; }
|	DimExprs DimExpr	{$1->children.push_back($2); $$ =$1 ; } 
;

DimExpr:
	LSPAR Expression RSPAR	{ $$ = create_node ( 4 ,"Dim_Expr", $1, $2, $3); } 
;

Dims:
	LSPAR RSPAR	{ $$ = create_node(3,"Dims",$1,$2) ; } 
|	Dims LSPAR RSPAR	{ $1->children.push_back($2);$1->children.push_back($3); $$ =$1 ; } 
;

FieldAccess:
	Primary DOT IDENTIFIER	{ $$ = create_node ( 4 ,"FieldAccess", $1, $2, $3); } 
|	SUPER DOT IDENTIFIER	{ $$ = create_node ( 4 ,"FieldAccess", $1, $2, $3); } 
;

MethodInvocation:
	Name LPAREN ArgumentList RPAREN	{ $$ = create_node ( 5 ,"MethodInvocation", $1, $2, $3, $4); } 
|	Name LPAREN RPAREN	{ $$ = create_node ( 4 ,"MethodInvocation", $1, $2, $3); } 
|	Primary DOT IDENTIFIER LPAREN ArgumentList RPAREN	{ $$ = create_node ( 7 ,"MethodInvocation", $1, $2, $3, $4, $5, $6); } 
|	Primary DOT IDENTIFIER LPAREN RPAREN	{ $$ = create_node ( 6 ,"MethodInvocation", $1, $2, $3, $4, $5); } 
|	SUPER DOT IDENTIFIER LPAREN ArgumentList RPAREN	{ $$ = create_node ( 7 ,"MethodInvocation", $1, $2, $3, $4, $5, $6); } 
|	SUPER DOT IDENTIFIER LPAREN RPAREN	{ $$ = create_node ( 6 ,"MethodInvocation", $1, $2, $3, $4, $5); } 
;


ArrayAccess:
	Name LSPAR Expression RSPAR	{ $$ = create_node ( 5 ,"ArrayAccess", $1, $2, $3, $4); } 
|	PrimaryNoNewArray LSPAR Expression RSPAR	{ $$ = create_node ( 5 ,"ArrayAccess", $1, $2, $3, $4); } 
;

PostfixExpression:
	Primary	{ $$ = $1; }
|	Name	{ $$ = $1; }
|	PostIncrementExpression	{ $$ = $1; }
|	PostDecrementExpression	{ $$ = $1; }
;

PostIncrementExpression:
	PostfixExpression PLUS_PLUS	{ $$ = create_node ( 2 ,$2->val, $1); } 
;

PostDecrementExpression:
	PostfixExpression MINUS_MINUS	{ $$ = create_node ( 2 ,$2->val, $1); } 
;

UnaryExpression:
	PreIncrementExpression	{ $$ = $1; }
|	PreDecrementExpression	{ $$ = $1; }
|	PLUS UnaryExpression	{ $$ = create_node ( 2 ,$1->val, $2); } 
|	MINUS UnaryExpression	{ $$ = create_node ( 2 ,$1->val, $2); } 
|	UnaryExpressionNotPlusMinus	{ $$ = $1; }
;

PreIncrementExpression:
	PLUS_PLUS UnaryExpression	{ $$ = create_node ( 2 ,$1->val, $2); } 
;

PreDecrementExpression:
	MINUS_MINUS UnaryExpression	{ $$ = create_node ( 2 ,$1->val, $2); } 
;

UnaryExpressionNotPlusMinus:
	PostfixExpression	{ $$ = $1; }
|	TILDE UnaryExpression	{ $$ = create_node ( 2 ,$1->val, $2); } 
|	NOT UnaryExpression	{ $$ = create_node ( 2 ,$1->val , $2); } 
|	CastExpression	{ $$ = $1; }
;

CastExpression:
	LPAREN PrimitiveType Dims RPAREN UnaryExpression	{ $$ = create_node ( 6 ,"CastExpression", $1, $2, $3, $4, $5); } 
|	LPAREN PrimitiveType RPAREN UnaryExpression	{ $$ = create_node ( 5 ,"CastExpression", $1, $2, $3, $4); } 
|	LPAREN Expression RPAREN UnaryExpressionNotPlusMinus	{ $$ = create_node ( 5 ,"CastExpression", $1, $2, $3, $4); } 
|	LPAREN Name Dims RPAREN UnaryExpressionNotPlusMinus	{ $$ = create_node ( 6 ,"CastExpression", $1, $2, $3, $4, $5); } 
;

MultiplicativeExpression:
	UnaryExpression	{ $$ = $1; }
|	MultiplicativeExpression TIMES UnaryExpression	{ $$ = create_node ( 3 ,$2->val, $1, $3); } 
|	MultiplicativeExpression DIVIDE UnaryExpression	{ $$ = create_node ( 3 ,$2->val, $1, $3); } 
|	MultiplicativeExpression MOD UnaryExpression	{ $$ = create_node ( 3 ,$2->val, $1, $3); } 
;

AdditiveExpression:
	MultiplicativeExpression	{ $$ = $1; }
|	AdditiveExpression PLUS MultiplicativeExpression	{ $$ = create_node ( 3 ,$2->val, $1, $3); } 
|	AdditiveExpression MINUS MultiplicativeExpression	{ $$ = create_node ( 3 ,$2->val, $1, $3); } 
;

ShiftExpression:
	AdditiveExpression	{ $$ = $1; }
|	ShiftExpression LEFT_SHIFT AdditiveExpression	{ $$ = create_node ( 3 ,$2->val, $1, $3); } 
|	ShiftExpression RIGHT_SHIFT AdditiveExpression	{ $$ = create_node ( 3 ,$2->val, $1, $3); } 
|	ShiftExpression UNSIGNED_RIGHT_SHIFT AdditiveExpression	{ $$ = create_node ( 3 ,$2->val, $1, $3); } 
;

RelationalExpression:
	ShiftExpression	{ $$ = $1; }
|	RelationalExpression LT ShiftExpression	{ $$ = create_node ( 3 ,$2->val, $1, $3); } 
|	RelationalExpression GT ShiftExpression	{ $$ = create_node ( 3 ,$2->val, $1, $3); } 
|	RelationalExpression LE ShiftExpression	{ $$ = create_node ( 3 ,$2->val, $1, $3); } 
|	RelationalExpression GE ShiftExpression	{ $$ = create_node ( 3 ,$2->val, $1, $3); } 
|	RelationalExpression INSTANCEOF ReferenceType	{ $$ = create_node ( 3 ,$2->val, $1, $3); } 
;

EqualityExpression:
	RelationalExpression	{ $$ = $1; }
|	EqualityExpression EQUALS_EQUALS RelationalExpression	{ $$ = create_node ( 3 ,$2->val, $1, $3); } 
|	EqualityExpression NOT_EQUALS RelationalExpression	{ $$ = create_node ( 3 ,$2->val, $1, $3); } 
;
AndExpression:
	EqualityExpression	{ $$ = $1; }
|	AndExpression BITWISE_AND EqualityExpression	{ $$ = create_node ( 3 ,$2->val, $1, $3); } 
;

ExclusiveOrExpression:
	AndExpression	{ $$ = $1; }
|	ExclusiveOrExpression XOR AndExpression	{ $$ = create_node ( 3 ,$2->val, $1, $3); } 
;

InclusiveOrExpression:
	ExclusiveOrExpression	{ $$ = $1; }
|	InclusiveOrExpression BITWISE_OR ExclusiveOrExpression	{ $$ = create_node ( 3 ,$2->val, $1, $3); } 
;

ConditionalAndExpression:
	InclusiveOrExpression	{ $$ = $1; }
|	ConditionalAndExpression AND InclusiveOrExpression	{ $$ = create_node ( 3 ,$2->val, $1, $3); } 
;

ConditionalOrExpression:
	ConditionalAndExpression	{ $$ = $1; }
|	ConditionalOrExpression OR ConditionalAndExpression	{ $$ = create_node ( 3 ,$2->val, $1, $3); } 
;

ConditionalExpression:
	ConditionalOrExpression	{ $$ = $1; }
|	ConditionalOrExpression QUESTION Expression COLON ConditionalExpression	{ $$ = create_node ( 6 ,"ConditionalExpression", $1, $2, $3, $4, $5); } 
;

AssignmentExpression:
	ConditionalExpression	{ $$ = $1; }
|	Assignment	{ $$ = $1; }
;

Assignment:
	LeftHandSide AssignmentOperator AssignmentExpression	{ $$ = create_node ( 3 ,$2->val, $1, $3); } 
;

LeftHandSide:
	Name	{ $$ = $1; }
|	FieldAccess	{ $$ = $1; }
|	ArrayAccess	{ $$ = $1; }
;

AssignmentOperator: 
	EQUALS 	{ $$ = $1; }
|	TIMES_EQUALS 	{ $$ = $1; }
|	DIVIDE_EQUALS	{ $$ = $1; }
|	MOD_EQUALS 	{ $$ = $1; }
|	PLUS_EQUALS 	{ $$ = $1; }
|	MINUS_EQUALS 	{ $$ = $1; }
|	LEFT_SHIFT_EQUALS	{ $$ = $1; }
|	RIGHT_SHIFT_EQUALS	{ $$ = $1; }
|	UNSIGNED_RIGHT_SHIFT_EQUALS 	{ $$ = $1; }
|	AND_EQUALS 	{ $$ = $1; }
|	XOR_EQUALS 	{ $$ = $1; }
|	OR_EQUALS	{ $$ = $1; }
;

Expression:
	AssignmentExpression	{ $$ = $1; }
;

%%

void make_st_method(NODE* node)
{
	st table;
	/* make_st_body(node->children[3], table); */

}

void make_st(NODE* node)
{
	if (node == NULL)
		return;
	else if (node->val=="MethodDeclaration")
	{
		make_st_method(node);
	}
	/* for (int i = 0; i < node->children.size(); i++)
	{
		make_st(node->children[i]);
	} */
	return;
}

void MakeDOTFile(NODE*cell)
{
    if(!cell)
        return;
    string value = string(cell->val);
    if(value.length()>2 && value[0]=='"' && value[value.length()-1]=='"')
    {
        value = value.substr(1,value.length()-2);
        value="\\\""+value+"\\\"";
    }
    fout << "\t" << cell->id << "\t\t[ style = solid label = \"" + value + "\"  ];" << endl;
    for(int i=0;i<cell->children.size();i++)
    {
        if(!cell->children[i])
            continue;
        fout << "\t" << cell->id << " -> " << cell->children[i]->id << endl;
        MakeDOTFile(cell->children[i]);
    }
}

//print out the table 
void printTable()
{
	for (auto table: symbol_tables)
	{
		cout << "Symbol Table :\t" << table.first << endl;
		print_symbol_table(table.ssecond);
		cout << endl;
	}
}

int main(int argc, char* argv[]){

	if(argc < 2 || argc > 4) {
		cout << "Usage: ./main <input file> <output file> <debug>" << endl;
		cout << "Example: ./main --input=input.java --output=output.dot --verbose" << endl;
		cout<<endl;
		cout << "For more help, run ./main --help" << endl;
		return 0;
	}

	string input_file = "";
	string output_file = "";

	yydebug = 0;
	bool debug = false;
	bool noInputFile = true;

	for(int i=1;i<argc;i++){
		string arg = argv[i];
		if(arg == "--help"){
			cout << "--input : Add this flag for specifying a input file to the parser. This is a required flag." << endl;
			cout << "Example: ./main --input=input.java" << endl;
			cout<<endl;
			cout << "--output Add this flag for specifying a output file to the parser which would contain the output i.e a AST in graphical form. This flag is optional. Default value is output.dot" << endl;
			cout << "Example: ./main --input=input.java --output=result.dot" << endl;
			cout<<endl;
			cout << "--verbose Add this flag for switching on the debug mode in the parser. This flag is optional." << endl;
			cout << "Example: ./main --input=input.java --output=result.dot --verbose" << endl;
			return 0;
		}
		else if(arg.substr(0,8) == "--input="){
			input_file = arg.substr(8);
			noInputFile = false;
		}
		else if(arg.substr(0,9) == "--output="){
			output_file = arg.substr(9);
		}
		else if(arg == "--verbose"){
			debug = true;
		}

		else{
			cout << "Invalid argument: " << arg << endl;
			return 0;
		}
	}

	if(input_file == "" || noInputFile){
		cout << "Please specify an input file." << endl;
		return 0;
	}
	if(output_file == ""){
		output_file = "output.dot";
	}
	if(debug){
		cout << "Input file: " << input_file << endl;
		cout << "Output file: " << output_file << endl;
		cout << "Debug: " << debug << endl;
		yydebug = 1;
	}

	/*--------------------------------------------------------------*/

	// Open the output file
	fout.open(output_file.c_str(),ios::out);
	// Get the DOT file template from the file
    ifstream infile("./DOT_Template.txt");
    string line;
    while (getline(infile, line))
        fout << line << endl;

	/*--------------------------------------------------------------*/

	//  Open the input file
	FILE* fp = fopen(("../tests/"+input_file).c_str(), "r");

	if(!fp){
		cout << "Error opening file: " << input_file << endl;
		return 0;
	}
	yyin = fp;

	yyparse();

	// Close the input file
	fclose(fp);

	/*--------------------------------------------------------------*/

	// Create DOT file
    MakeDOTFile(start_node);
    fout << "}";

	// Close the output file
    fout.close();

	/*--------------------------------------------------------------*/
	// make the symbol table from start node
	make_st(start_node);
	// Printing the symbol table
	fout.open("symbol_table.txt",ios::out);
	printTable();
	fout.close();
	
    return 0;
}