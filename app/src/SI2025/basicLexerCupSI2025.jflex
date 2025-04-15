/* JFlex example: partial Java language lexer specification */
package ParserLexer;
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
 
TraditionalComment   = "/" [^] ~"/" | "/" "*"+ "/"
// Comment can be the last line of the file, without line terminator.
EndOfLineComment     = "//" {InputCharacter}* {LineTerminator}?
DocumentationComment = "/" {CommentContent} "*"+ "/"
CommentContent       = ( [^*] | \*+ [^/*] )*
 
Identifier = [:jletter:] [:jletterdigit:]*
 
digito = [0-9]
digitoNocero = [1-9]
 
EnteroValido = "0" | "-"? {digito} {digitoNocero}*
FlotanteValido = ("0" \. {digito}+) | ("-"? {digitoNocero} {digito}* \. {digito}+) //3.14, -10.5, 123.456 y 0.124, 0.0, 0.1
 
%state STRING
 
%%
 
/* keywords */
//Tipos USAMOS T por Tokens
<YYINITIAL> "int"           { return symbol(sym.INTEGER_T); }
<YYINITIAL> "string"            { return symbol(sym.STRING_T); }
<YYINITIAL> "char"              { return symbol(sym.CHAR_T); }
<YYINITIAL> "float"            { return symbol(sym.FLOAT_T); }
<YYINITIAL> "sol"           { return symbol(sym.FALSE_T); }
<YYINITIAL> "luna"            { return symbol(sym.TRUE_T); }
//----------------------------------------------------------------
 
//Signos
<YYINITIAL> "+"              { return symbol(sym.SUMA_T); }
<YYINITIAL> "-"             { return symbol(sym.RESTA_T); }
<YYINITIAL> "*"             { return symbol(sym.MULTIPLICACION_T); }
<YYINITIAL> ""             { return symbol(sym.POTENCIA_T); }
<YYINITIAL> "//"             { return symbol(sym.DIVISION_T); }
 
//operadorRelacional
<YYINITIAL> "=="            { return symbol(sym.COMPARACION_T); }
<YYINITIAL> "!="            { return symbol(sym.DIFERENTE_T); }
<YYINITIAL> ">="            { return symbol(sym.MAYOR_IGUAL_T); }
<YYINITIAL> "<="            { return symbol(sym.MENOR_IGUAL_T); }
<YYINITIAL> ">"             { return symbol(sym.MAYOR_T); }
<YYINITIAL> "<"             { return symbol(sym.MENOR_T); }
//----------------------------------------------------------------
//signoComparacion
<YYINITIAL> "+="             { return symbol(sym.MAS_IGUAL_T); }
<YYINITIAL> "-="             { return symbol(sym.MENOS_IGUAL_T); }
<YYINITIAL> "="             { return symbol(sym.ASIGNA_T); }
<YYINITIAL> "//="             { return symbol(sym.DIV_IGUAL_T); }
<YYINITIAL> "~="             { return symbol(sym.NO_IGUAL_T); }
//----------------------------------------------------------------
//Incremento y decremento
<YYINITIAL> "++"            { return symbol(sym.INCREMENTO_T); }
<YYINITIAL> "--"            { return symbol(sym.DECREMENTO_T); }
//----------------------------------------------------------------
//Dyuscion, conjuncion y negacion
<YYINITIAL> "!"             { return symbol(sym.NEGACION_T); }
<YYINITIAL> "#"            { return symbol(sym.CONJUNCION_T); }
<YYINITIAL> "^"            { return symbol(sym.DISYUNCION_T); }
//----------------------------------------------------------------
//No se si esten bien
<YYINITIAL> "if"               { return symbol(sym.IF_T); }
<YYINITIAL> "else"             { return symbol(sym.ELSE_T); }
<YYINITIAL> "do"              { return symbol(sym.DO_T); }
<YYINITIAL> "elif"              { return symbol(sym.ELIF_T); }
<YYINITIAL> "while"           { return symbol(sym.WHILE_T); }
<YYINITIAL> "for"             { return symbol(sym.FOR_T); }
<YYINITIAL> "void"             { return symbol(sym.VOID_T); }
<YYINITIAL> "?"              { return symbol(sym.FINLINEA_T); }
<YYINITIAL> "return"          { return symbol(sym.RETURN_T); }
<YYINITIAL> "break"           { return symbol(sym.BREAK_T); }
<YYINITIAL> ","              { return symbol(sym.COMA_T); }
<YYINITIAL> "cin"              { return symbol(sym.CIN_T); }
<YYINITIAL> "cout"              { return symbol(sym.COUT_T); }
<YYINITIAL> ">>"              { return symbol(sym.COUT_COMENT_T); }
<YYINITIAL> "<<"              { return symbol(sym.CIN_COMENT_T); }
<YYINITIAL> "{"             { return symbol(sym.LLAVE_ABIERTO_T); }
<YYINITIAL> "}"              { return symbol(sym.LLAVE_CERRADO_T); }
<YYINITIAL> "&"              { return symbol(sym.PARENTESISAC_T); }
 
 
 
 
<YYINITIAL> {
    /* identifiers */  
    {Identifier}                    { return symbol(sym.IDENTIFICADOR, yytext()); }
   
                      //return symbol: Es el id con el cual se reconoce el token que genera: ejem 25 -> lo reconoce el programa como un token llamado l-integer
    /* literals */  
    {EnteroValido}    { return symbol(sym.L_INTEGER, new Integer(yytext())); }
    /* literals */  
    {FlotanteValido}  { return symbol(sym.L_FLOAT, new Float(yytext())); }
 
 
 
    \"                             { string.setLength(0); yybegin(STRING); }
 
    /* comments */
    {Comment}                      { /* ignore */ }
   
    /* whitespace */
    {WhiteSpace}                   { /* ignore */ }
}
 
<STRING> {
    \"                             { yybegin(YYINITIAL);
                                    return symbol(sym.L_STRING,
                                    string.toString()); }
    [^\n\r\"\\]+                   { string.append( yytext() ); }
    \\t                            { string.append('\t'); }
    \\n                            { string.append('\n'); }
 
    \\r                            { string.append('\r'); }
    \\\"                           { string.append('\"'); }
    \\                             { string.append('\\'); }
}
 
 
/* error fallback - manejo no intrusivo de errores */
[^] {
    System.err.println("Error léxico: Carácter ilegal '" + yytext() +
                      "' en línea " + yyline + ", columna " + yycolumn);
    // Continúa el análisis sin lanzar excepción
}
