package com.recepinanc.sampleclient.sample;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/pingpong")
public class PingPongEndpoint {

    @Autowired
    private  GRPCClientService grpcClientService;

    @GetMapping("/ping")
    public String ping() {
        return grpcClientService.ping();
    }
}
