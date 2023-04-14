package com.example.demo.client;

import com.example.demo.shared.PingRequest;
import com.example.demo.shared.PongResponse;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

@FeignClient(value = "jplaceholder", url = "http://localhost:8081/api/pingpong")
public interface PongClient {

    @RequestMapping(method = RequestMethod.GET, value = "/ping")
    PongResponse pingPong();

}
