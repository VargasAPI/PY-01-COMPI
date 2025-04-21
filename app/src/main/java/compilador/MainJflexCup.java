package compilador;

 
import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
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
        // Ruta del archivo de salida
        String rutaSalida = ".\\app\\src\\generation\\resultado.txt";

        // Elimina archivo anterior si existe
        File archivo = new File(rutaSalida);
        if (archivo.exists()) {
            archivo.delete();
        }

        try (
                Reader reader = new BufferedReader(new FileReader(rutaScanner));
                BufferedWriter writer = new BufferedWriter(new FileWriter(rutaSalida))) {
            System.out.println("Bienvenido al analizador lexico de CUP");
            writer.write("Bienvenido al analizador lexico de CUP");
            writer.newLine();

            BasicLexerCup lex = new BasicLexerCup(reader);
            int i = 0;
            Symbol token;

            while (true) {
                token = lex.next_token();
                if (token.sym != 0) {
                    String linea = "Token: " + token.sym + ", Valor: " +
                            (token.value == null ? lex.yytext() : token.value.toString());

                    System.out.println(linea);
                    writer.write(linea);
                    writer.newLine();
                } else {
                    String fin = "Cantidad de lexemas encontrados: " + i;
                    System.out.println(fin);
                    writer.write(fin);
                    writer.newLine();

                    System.out.println("Gracias por usar el analizador lexico de CUP");
                    writer.write("Gracias por usar el analizador lexico de CUP");
                    writer.newLine();

                    return;
                }
                i++;
            }
        }
    }
 
    
 
 
    //Uso del parser y de parser_extended
    public void ejercicioParser(String rutaparsear) throws Exception {
        Reader reader = new BufferedReader(new FileReader(rutaparsear));
        reader.read();
        BasicLexerCup myLexer = new BasicLexerCup(reader);
 
        ParserLexer.parser myParser = new ParserLexer.parser(myLexer);
        myParser.parse();
    }
 
}