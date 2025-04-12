/* JFlex example: partial Java language lexer specification */
package PaserLexer;
import java_cup.runtime.*;

/**
    * This class is a simple example lexer. este es nuestro lexer, hay que agregar más cosas
    */
%%

%class BasicLexerCup
%public
%unicode
%cup
%line
%column

%{
    StringBuffer string = new StringBuffer();

    private Symbol symbol(int type) {
    return new Symbol(type, yyline, yycolumn);
    }
    private Symbol symbol(int type, Object value) {
    return new Symbol(type, yyline, yycolumn, value);
    }
%}

LineTerminator = \r|\n|\r\n
InputCharacter = [^\r\n]
WhiteSpace     = {LineTerminator} | [ \t\f]

/* comments */
Comment = {TraditionalComment} | {EndOfLineComment} | {DocumentationComment}

TraditionalComment   = "/*" [^*] ~"*/" | "/*" "*"+ "/"
// Comment can be the last line of the file, without line terminator.
EndOfLineComment     = "//" {InputCharacter}* {LineTerminator}?
DocumentationComment = "/**" {CommentContent} "*"+ "/"
CommentContent       = ( [^*] | \*+ [^/*] )*

Identifier = [:jletter:] [:jletterdigit:]*

//DecIntegerLiteral = 0 | [1-9][0-9]* /*ojo no permite negativos*/
digito = [0-9]
digitoNocero = [1-9]
DecIntegerLiteral = ({digitoNocero} {digito}*)

%state STRING

%%

/* keywords */
<YYINITIAL> "int"           { return symbol(sym.INTEGER_T); }
<YYINITIAL> "string"            { return symbol(sym.STRING_T); }
<YYINITIAL> "char"              { return symbol(sym.CHAR_T); }
<YYINITIAL> "="           { return symbol(sym.ASIGNA); }
<YYINITIAL> "=="            { return symbol(sym.COMPARACION); }
<YYINITIAL> "+"              { return symbol(sym.SUMA); }
<YYINITIAL> "?"              { return symbol(sym.FINLINEA); }

<YYINITIAL> {
    /* identifiers */ 
    {Identifier}                   { return symbol(sym.IDENTIFICADOR, yytext()); }
    
    /* literals */
    {DecIntegerLiteral}            { return symbol(sym.L_INTEGER, yytext()); }

    \"                             { string.setLength(0); yybegin(STRING); }

    /* comments */
    {Comment}                      { /* ignore */ }
    
    /* whitespace */
    {WhiteSpace}                   { /* ignore */ }
}

<STRING> {
    \"                             { yybegin(YYINITIAL); 
                                    return symbol(sym.STRING_LITERAL, 
                                    string.toString()); }
    [^\n\r\"\\]+                   { string.append( yytext() ); }
    \\t                            { string.append('\t'); }
    \\n                            { string.append('\n'); }

    \\r                            { string.append('\r'); }
    \\\"                           { string.append('\"'); }
    \\                             { string.append('\\'); }
}

/* error fallback (cambiar esto, aqui el manejo de errores creo)*/
[^]                              { throw new Error("Illegal character <"+
                                                    yytext()+">"); }