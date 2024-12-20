package com.example.demo.controller;

import lombok.extern.slf4j.Slf4j;
import org.springframework.util.StopWatch;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.io.*;
import java.util.concurrent.CountDownLatch;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

@RestController
@RequestMapping("/csv")
@Slf4j
public class CsvController {


    @GetMapping
    public void csv() throws InterruptedException {
        String outputFile = "C:\\Users\\9003923\\Downloads\\output.csv";
        int totalTasks = 100000;
        StopWatch stopWatch = new StopWatch();
        stopWatch.start();
        log.info("#### start");

//        ExecutorService executor = Executors.newVirtualThreadPerTaskExecutor();
        ExecutorService executor = Executors.newFixedThreadPool(100);
//        ExecutorService executor = Executors.newFixedThreadPool(Runtime.getRuntime().availableProcessors());
        CountDownLatch latch = new CountDownLatch(totalTasks);

        try (
            PrintWriter writer = new PrintWriter(new FileWriter(outputFile))) {

            String line;
            for (int i = 0; i < totalTasks; i++) {
                int lineNumber = i;

                executor.submit(new ProcessLineTask(writer, lineNumber, latch));
            }
            latch.await(); // Aguarda a finalização de todas as tarefas


        } catch (Exception e) {
            e.printStackTrace();
        }
        stopWatch.stop();
        log.info("#### end in millis " + stopWatch.getTotalTimeMillis());
        executor.shutdown();
    }

    static class ProcessLineTask implements Runnable {
        private final PrintWriter writer;
        private final int lineNumber;
        private final CountDownLatch latch;


        public ProcessLineTask(PrintWriter writer, int lineNumber, CountDownLatch latch) {
            this.writer = writer;
            this.lineNumber = lineNumber;
            this.latch = latch;
        }

        @Override
        public void run() {
            try {
                String processedLine = String.format("Nova linha sendo escrita. Nova linha sendo escrita. Nova linha sendo escrita. Nova linha sendo escrita. Nova linha sendo escrita. Nova linha sendo escrita. Nova linha sendo escrita. Nova linha sendo escrita. Nova linha sendo escrita. Nova linha sendo escrita. Nova linha sendo escrita. Nova linha sendo escrita. Nova linha sendo escrita. Nova linha sendo escrita. Nova linha sendo escrita. Nova linha sendo escrita. Nova linha sendo escrita. Nova linha sendo escrita. Nova linha sendo escrita. Nova linha sendo escrita. Nova linha sendo escrita. Coluna a%s,Coluna b%s,Coluna c%s,Coluna d%s,Coluna e%s,Coluna f%s", lineNumber, lineNumber, lineNumber, lineNumber, lineNumber, lineNumber);
                synchronized (writer) {
                    writer.println(processedLine);
                    log.info("## escrito linha " + lineNumber);
                }
                Thread.sleep(3000);
            } catch (Exception e) {
                e.printStackTrace();
            } finally {
                latch.countDown(); // Sinaliza que a tarefa foi concluída
            }
        }
    }

}
