

import java.io.File;

import java.io.FileInputStream;
import java.io.FileWriter;
import java.io.IOException;
import java.util.Random;
import java.util.Scanner;
import java.util.concurrent.locks.Condition;
import java.util.concurrent.locks.Lock;
import java.util.concurrent.locks.ReentrantLock;

public class ReaderWriterPriority 
{
    //intialize locks and set values to 0 for number of readers and writers. Declare 
    //external file and create a random number
    final Lock mutex = new ReentrantLock();
    final Condition readerQueue = mutex.newCondition(); 
    final Condition writerQueue = mutex.newCondition(); 
    int nReaders = 0; 
    int nWriters = 0; 
    int nActiveWriters = 0;  
    String file = "counter.txt";
    public static Random rand = new Random();

    //intialize the counter.txt file to 0
    public void init() 
    {
        FileWriter f;
        try 
        {
            f = new FileWriter(new File(file));
            f.write(new Integer(0).toString());
            f.close();
        } catch (IOException e) 
            {e.printStackTrace();}
    }

    //readers block. Set lock and wait in readerQueue if there are writers. Unlock after and read
    //from file. After Set lock to decrement readers and signal writers queue if there are 0
    //readers, then unlock after.
    void reader() throws InterruptedException 
    {
        mutex.lock(); 
        while (nWriters != 0) 
            readerQueue.await(); 
        nReaders++;  
        mutex.unlock();
        readToFile(file);
        mutex.lock();  
        if (--nReaders == 0)
            writerQueue.signal();
        mutex.unlock();

    }

    //writers block. Set lock and waits in queue if there are readers and writers. Increment 
    //active writers and unlock. Then write to file. lock again and decrement active writers.
    //if there are no more writers signal readers else signal next writer. then unlock
    void writer() throws InterruptedException 
    {
        mutex.lock();
        nWriters++; 
        while (!((nReaders == 0) && (nActiveWriters == 0))) 
            writerQueue.await();  
        nActiveWriters++; 
        mutex.unlock();
        writeToFile(file);
        mutex.lock();  
        nActiveWriters--;
        if (--nWriters == 0) 
            readerQueue.signalAll(); 
        else 
            writerQueue.signal();
        mutex.unlock();
    }

    //reads current value from counter.txt and prints value to console
    public void readToFile(String path) 
    {
        try 
        {
            Scanner reader = new Scanner(new FileInputStream(path));
            int x = reader.nextInt();
            System.out.printf("Reader: " + Thread.currentThread().getName() + " read from counter.txt: %d\n",x);
        } catch (IOException e) 
            {e.printStackTrace();}
    }

    //reads current value from counter.txt and increments value by 1. The value is then printed
    //to file. Output value that was written
    public void writeToFile(String path) 
    {
        int counterToWrite;

        try 
        {
            Scanner reader = new Scanner(new FileInputStream(path));
            counterToWrite = (int) reader.nextInt();
            counterToWrite++;
            FileWriter f = new FileWriter(new File(path));
            f.write(new Integer(counterToWrite).toString());
            f.close();
            System.out.printf("Writer: " + Thread.currentThread().getName() + " Writing to counter.txt: %d\n",counterToWrite);
        } catch (IOException e) 
            {e.printStackTrace();}
    }
}



