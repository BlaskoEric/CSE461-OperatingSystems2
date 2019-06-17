
import java.util.Random;

public class readerWriterMain {

    //initialize static variables and create instance of ReaderWriterPriority class
    public final static int NUMBER_READ_THREAD = 20;
    public final static int NUMBER_WRITE_THREAD = 3;
    public static ReaderWriterPriority readerWriterClass = new ReaderWriterPriority();
    public static Random rand = new Random();

    //Starts a new reader thread and runs it. After it reads, sleep for 3000ms
    //Runs endless loop
    static class readerThread extends Thread 
    {
        @Override
        public void run() 
        {
            System.out.print("Reader " + getName() + ": Initialized\n");
            while (true) 
            {
                try 
                {
                    readerWriterClass.reader();
                    int time = rand.nextInt(3000);
                    Thread.sleep(time);
                } catch (InterruptedException e) 
                    {e.printStackTrace();}
            }
        }
    }

    //Starts a new writer thread and runs it. After write, sleeps for 3000ms
    //Runs endless loop
    static class writerThread extends Thread 
    {
        @Override
        public void run() 
        {
            System.out.print("Writer " + getName() + ": Initialized\n");
            while (true) 
            {
                try     
                {
                    readerWriterClass.writer();
                    int time = rand.nextInt(3000);
                    Thread.sleep(time);
                } catch (InterruptedException e) 
                    {e.printStackTrace();}
            }
        }
    }

    //Main. Initialize counter.txt to 0, create 20 reader threads and 3 writer
    //threads and begin running them
    public static void main(String[] args) 
    {
        readerWriterClass.init();
        readerThread readerThreads[] = new readerThread[NUMBER_READ_THREAD];
        writerThread writerThreads[] = new writerThread[NUMBER_WRITE_THREAD];

        System.out.print("Create andstart the thread\n");

        for (int i = 0; i < NUMBER_WRITE_THREAD; ++i) 
        {
            writerThreads[i] = new writerThread();
            writerThreads[i].start();
        }

        for (int i = 0; i < NUMBER_READ_THREAD; ++i) 
        {
            readerThreads[i] = new readerThread();
            readerThreads[i].start();

        }
    }
}
