import java.io.IOException;
import java.net.ServerSocket;
import java.net.Socket;
import java.util.Scanner;
import java.lang.*;
import java.io.*;

public class calcServer {
    public static void main(String[] args) {
        
        try{
            ServerSocket serverSocket = new ServerSocket(1989);
            System.out.println("Server Started...");
            while(true) {
                new Thread(new ClientConnectionThread(serverSocket.accept())).start();
            }
        } catch(IOException e) {e.printStackTrace();}
    }
}

class ClientConnectionThread implements Runnable{
    private Socket socket;
    public ClientConnectionThread(Socket socket) {
        this.socket = socket;
    }
    @Override
    public void run(){
        try{
            DataInputStream dIn = new DataInputStream(socket.getInputStream());
            DataOutputStream dOut = new DataOutputStream(socket.getOutputStream());
            String message = dIn.readUTF();
            System.out.println("Client Request : " + message);
            String[] input = message.split(" ");
            String result = input[0] + " " + input[2] + " " + input[1] 
                + " = " + calculate(Integer.parseInt(input[0]), Integer.parseInt(input[1]), input[2]);
            System.out.println("Server Response : " + result);

            dOut.writeUTF(result);
            dOut.flush();
            dOut.close();
            socket.close();
        }catch(IOException e) {e.printStackTrace();}
    }

    public static String calculate(int num1, int num2, String operator) {
        Integer result = 0;
        switch(operator.charAt(0)) {
            case '+':
                result = num1 + num2;
                break;
            case '-':
                result = num1 - num2;
                break;
            case '/':
                if(num2 == 0)
                    result = 0;
                else
                    result = num1 / num2;
                break;
            case '*':
                result = num1 * num2;
                break;
            default:
                break;
        }
        return Integer.toString(result);
    }
}
