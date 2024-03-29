package sample;

import com.example.grpc.server.grpcserver.PingPongServiceGrpc;
import com.example.grpc.server.grpcserver.PingRequest;
import com.example.grpc.server.grpcserver.PongResponse;
import io.grpc.stub.StreamObserver;

import java.util.List;

public class PingPongServiceImpl extends PingPongServiceGrpc.PingPongServiceImplBase {
    @Override
        public void ping(PingRequest request, StreamObserver<PongResponse> responseObserver) {
        responseObserver.onNext(PongResponse.newBuilder().build());
        responseObserver.onCompleted();
    }
}
//    @Override
//    public void ping(PingRequest request, StreamObserver<PongResponse> responseObserver) {
//        PongResponse response = PongResponse.newBuilder()
//                .setPong("pong")
//                .setDescricao("teste")
////                .addListTeste("teste1")
////                .addListTeste("teste2")
////                .addListTeste("teste3")
////                .addListProduct(PongResponse.Product.newBuilder().setName("product1").setPrice(2).setQuantity(2).build())
////                .addListProduct(PongResponse.Product.newBuilder().setName("product2").setPrice(2).setQuantity(2).build())
//                .build();
//        responseObserver.onNext(response);
//        responseObserver.onCompleted();
//    }
//}
