package compilador;

 
import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.io.Reader;
 
import java_cup.internal_error;
import java_cup.parser;
import java_cup.runtime.Symbol;
import jflex.exceptions.SilentExit;
 
import ParserLexer.*; 

public class MainJflexCup {
    public void iniLexerParser(String rutaLexer, String rutaParser) throws internal_error ,Exception {
     
      GenerateLexer(rutaLexer);
      GenerateParser(rutaParser);
    }
 
    //Genera el archivo lexer
    public void GenerateLexer(String ruta) throws IOException, SilentExit {
        String[] strArr = {ruta};
        jflex.Main.generate(strArr);
    }
 
    //Genera los archivos del parser
    public void GenerateParser(String ruta) throws internal_error, IOException, Exception {
        String[] strArr = {ruta};
        java_cup.Main.main(strArr);
    }
 
    //Esta usa el lexer modificado el de ParserLexer de verano 2024
    //Usa simbol de cup
    public void ejercicioLexer(String rutaScanner) throws IOException {
        /*Reader reader = new BufferedReader(new FileReader(rutaScanner));
        reader.read();
        BasicLexerCup lex = new BasicLexerCup(reader);
        int i = 0;
        Symbol token;
        while(true)
        {
            token = lex.next_token();
            if(token.sym != 0){
                System.out.println("Token: " + token.sym+", Valor: "+(token.value==null?lex.yytext(): token.value.toString()));
            }else{
                System.out.println("Cantidad de lexemas encontrados: " +i);
                return;
            }
            i++;
        }*/
 
    }
 
 
 
 
    //Uso del parser y de parser_extended
    public void ejercicioParser(String rutaparsear) throws Exception {
        /*Reader reader = new BufferedReader(new FileReader(rutaparsear));
        reader.read();
        BasicLexerCup myLexer = new BasicLexerCup(reader);
 
        ParsearLexer.parser myParser = new ParsearLexer.parser(myLexer);
        myParser.parse();*/
    }
 
}