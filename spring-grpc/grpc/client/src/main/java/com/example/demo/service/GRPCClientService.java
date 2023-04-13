package com.example.demo.service;

import com.example.grpc.server.grpcserver.PingPongServiceGrpc;
import com.example.grpc.server.grpcserver.PingRequest;
import com.example.grpc.server.grpcserver.PongResponse;
import io.grpc.ManagedChannel;
import io.grpc.ManagedChannelBuilder;
import org.springframework.stereotype.Service;

import java.util.stream.Collectors;

@Service
public class GRPCClientService {
    public String ping() {
        ManagedChannel channel = ManagedChannelBuilder.forAddress("localhost", 9091)
                .usePlaintext()
                .build();
        PingPongServiceGrpc.PingPongServiceBlockingStub stub
                = PingPongServiceGrpc.newBlockingStub(channel);
        PongResponse helloResponse = stub.ping(PingRequest.newBuilder()
                .setPing("")
                .build());
        channel.shutdown();
        return helloResponse.getPong() + helloResponse.getDescricao() + helloResponse.getListTesteList().stream().collect(Collectors.joining(",")) + helloResponse.getListProductList().stream().map(PongResponse.Product::getName).collect(Collectors.joining(","));
    }
}