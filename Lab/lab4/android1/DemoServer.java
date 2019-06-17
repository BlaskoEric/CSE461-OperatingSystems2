// A simple TCP server for Demo
// @Author: T.L. Yu

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.ServerSocket;
import java.net.Socket;

public class DemoServer {
  public static void main(String[] args) throws IOException {
         
    if (args.length != 1) {
      System.err.println("Usage: java Server <port number>");
      System.exit(1);
    }
 
    int portNumber = Integer.parseInt(args[0]);
    try {
      ServerSocket serverSocket =  new ServerSocket(portNumber);
      Socket clientSocket = serverSocket.accept();
      BufferedReader input = new BufferedReader (
           new InputStreamReader(clientSocket.getInputStream()));
   
       String inputLine = null;
       while ( ( inputLine = input.readLine() )  != null ) {
         System.out.println ( inputLine );
       }
    }  catch (IOException e) {
            System.out.println("Exception caught when trying to listen on port "
                + portNumber + " or listening for a connection");
            System.out.println(e.getMessage());
    }
  }
}
