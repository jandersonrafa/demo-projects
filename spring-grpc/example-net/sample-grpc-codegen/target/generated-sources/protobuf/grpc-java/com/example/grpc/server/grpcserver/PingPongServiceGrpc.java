package com.example.grpc.server.grpcserver;

import static io.grpc.MethodDescriptor.generateFullMethodName;
import static io.grpc.stub.ClientCalls.asyncBidiStreamingCall;
import static io.grpc.stub.ClientCalls.asyncClientStreamingCall;
import static io.grpc.stub.ClientCalls.asyncServerStreamingCall;
import static io.grpc.stub.ClientCalls.asyncUnaryCall;
import static io.grpc.stub.ClientCalls.blockingServerStreamingCall;
import static io.grpc.stub.ClientCalls.blockingUnaryCall;
import static io.grpc.stub.ClientCalls.futureUnaryCall;
import static io.grpc.stub.ServerCalls.asyncBidiStreamingCall;
import static io.grpc.stub.ServerCalls.asyncClientStreamingCall;
import static io.grpc.stub.ServerCalls.asyncServerStreamingCall;
import static io.grpc.stub.ServerCalls.asyncUnaryCall;
import static io.grpc.stub.ServerCalls.asyncUnimplementedStreamingCall;
import static io.grpc.stub.ServerCalls.asyncUnimplementedUnaryCall;

/**
 * <pre>
 *message PingRequest {
 *  string ping = 1;
 *}
 *message PongResponse {
 *  string pong = 1;
 *  string descricao = 2;
 *  repeated string listTeste = 3;
 *  repeated Product listProduct = 4;
 *  message Product {
 *    string id = 1;
 *    string name = 2;
 *    int32 quantity = 3;
 *    double price = 4;
 *    bool status = 5;
 *  }
 *}
 * </pre>
 */
@javax.annotation.Generated(
    value = "by gRPC proto compiler (version 1.33.0)",
    comments = "Source: PingPongService.proto")
public final class PingPongServiceGrpc {

  private PingPongServiceGrpc() {}

  public static final String SERVICE_NAME = "com.example.grpc.server.grpcserver.PingPongService";

  // Static method descriptors that strictly reflect the proto.
  private static volatile io.grpc.MethodDescriptor<com.example.grpc.server.grpcserver.PingRequest,
      com.example.grpc.server.grpcserver.PongResponse> getPingMethod;

  @io.grpc.stub.annotations.RpcMethod(
      fullMethodName = SERVICE_NAME + '/' + "ping",
      requestType = com.example.grpc.server.grpcserver.PingRequest.class,
      responseType = com.example.grpc.server.grpcserver.PongResponse.class,
      methodType = io.grpc.MethodDescriptor.MethodType.UNARY)
  public static io.grpc.MethodDescriptor<com.example.grpc.server.grpcserver.PingRequest,
      com.example.grpc.server.grpcserver.PongResponse> getPingMethod() {
    io.grpc.MethodDescriptor<com.example.grpc.server.grpcserver.PingRequest, com.example.grpc.server.grpcserver.PongResponse> getPingMethod;
    if ((getPingMethod = PingPongServiceGrpc.getPingMethod) == null) {
      synchronized (PingPongServiceGrpc.class) {
        if ((getPingMethod = PingPongServiceGrpc.getPingMethod) == null) {
          PingPongServiceGrpc.getPingMethod = getPingMethod =
              io.grpc.MethodDescriptor.<com.example.grpc.server.grpcserver.PingRequest, com.example.grpc.server.grpcserver.PongResponse>newBuilder()
              .setType(io.grpc.MethodDescriptor.MethodType.UNARY)
              .setFullMethodName(generateFullMethodName(SERVICE_NAME, "ping"))
              .setSampledToLocalTracing(true)
              .setRequestMarshaller(io.grpc.protobuf.ProtoUtils.marshaller(
                  com.example.grpc.server.grpcserver.PingRequest.getDefaultInstance()))
              .setResponseMarshaller(io.grpc.protobuf.ProtoUtils.marshaller(
                  com.example.grpc.server.grpcserver.PongResponse.getDefaultInstance()))
              .setSchemaDescriptor(new PingPongServiceMethodDescriptorSupplier("ping"))
              .build();
        }
      }
    }
    return getPingMethod;
  }

  /**
   * Creates a new async stub that supports all call types for the service
   */
  public static PingPongServiceStub newStub(io.grpc.Channel channel) {
    io.grpc.stub.AbstractStub.StubFactory<PingPongServiceStub> factory =
      new io.grpc.stub.AbstractStub.StubFactory<PingPongServiceStub>() {
        @java.lang.Override
        public PingPongServiceStub newStub(io.grpc.Channel channel, io.grpc.CallOptions callOptions) {
          return new PingPongServiceStub(channel, callOptions);
        }
      };
    return PingPongServiceStub.newStub(factory, channel);
  }

  /**
   * Creates a new blocking-style stub that supports unary and streaming output calls on the service
   */
  public static PingPongServiceBlockingStub newBlockingStub(
      io.grpc.Channel channel) {
    io.grpc.stub.AbstractStub.StubFactory<PingPongServiceBlockingStub> factory =
      new io.grpc.stub.AbstractStub.StubFactory<PingPongServiceBlockingStub>() {
        @java.lang.Override
        public PingPongServiceBlockingStub newStub(io.grpc.Channel channel, io.grpc.CallOptions callOptions) {
          return new PingPongServiceBlockingStub(channel, callOptions);
        }
      };
    return PingPongServiceBlockingStub.newStub(factory, channel);
  }

  /**
   * Creates a new ListenableFuture-style stub that supports unary calls on the service
   */
  public static PingPongServiceFutureStub newFutureStub(
      io.grpc.Channel channel) {
    io.grpc.stub.AbstractStub.StubFactory<PingPongServiceFutureStub> factory =
      new io.grpc.stub.AbstractStub.StubFactory<PingPongServiceFutureStub>() {
        @java.lang.Override
        public PingPongServiceFutureStub newStub(io.grpc.Channel channel, io.grpc.CallOptions callOptions) {
          return new PingPongServiceFutureStub(channel, callOptions);
        }
      };
    return PingPongServiceFutureStub.newStub(factory, channel);
  }

  /**
   * <pre>
   *message PingRequest {
   *  string ping = 1;
   *}
   *message PongResponse {
   *  string pong = 1;
   *  string descricao = 2;
   *  repeated string listTeste = 3;
   *  repeated Product listProduct = 4;
   *  message Product {
   *    string id = 1;
   *    string name = 2;
   *    int32 quantity = 3;
   *    double price = 4;
   *    bool status = 5;
   *  }
   *}
   * </pre>
   */
  public static abstract class PingPongServiceImplBase implements io.grpc.BindableService {

    /**
     * <pre>
     *  rpc ping(PingRequest) returns (PongResponse);
     * </pre>
     */
    public void ping(com.example.grpc.server.grpcserver.PingRequest request,
        io.grpc.stub.StreamObserver<com.example.grpc.server.grpcserver.PongResponse> responseObserver) {
      asyncUnimplementedUnaryCall(getPingMethod(), responseObserver);
    }

    @java.lang.Override public final io.grpc.ServerServiceDefinition bindService() {
      return io.grpc.ServerServiceDefinition.builder(getServiceDescriptor())
          .addMethod(
            getPingMethod(),
            asyncUnaryCall(
              new MethodHandlers<
                com.example.grpc.server.grpcserver.PingRequest,
                com.example.grpc.server.grpcserver.PongResponse>(
                  this, METHODID_PING)))
          .build();
    }
  }

  /**
   * <pre>
   *message PingRequest {
   *  string ping = 1;
   *}
   *message PongResponse {
   *  string pong = 1;
   *  string descricao = 2;
   *  repeated string listTeste = 3;
   *  repeated Product listProduct = 4;
   *  message Product {
   *    string id = 1;
   *    string name = 2;
   *    int32 quantity = 3;
   *    double price = 4;
   *    bool status = 5;
   *  }
   *}
   * </pre>
   */
  public static final class PingPongServiceStub extends io.grpc.stub.AbstractAsyncStub<PingPongServiceStub> {
    private PingPongServiceStub(
        io.grpc.Channel channel, io.grpc.CallOptions callOptions) {
      super(channel, callOptions);
    }

    @java.lang.Override
    protected PingPongServiceStub build(
        io.grpc.Channel channel, io.grpc.CallOptions callOptions) {
      return new PingPongServiceStub(channel, callOptions);
    }

    /**
     * <pre>
     *  rpc ping(PingRequest) returns (PongResponse);
     * </pre>
     */
    public void ping(com.example.grpc.server.grpcserver.PingRequest request,
        io.grpc.stub.StreamObserver<com.example.grpc.server.grpcserver.PongResponse> responseObserver) {
      asyncUnaryCall(
          getChannel().newCall(getPingMethod(), getCallOptions()), request, responseObserver);
    }
  }

  /**
   * <pre>
   *message PingRequest {
   *  string ping = 1;
   *}
   *message PongResponse {
   *  string pong = 1;
   *  string descricao = 2;
   *  repeated string listTeste = 3;
   *  repeated Product listProduct = 4;
   *  message Product {
   *    string id = 1;
   *    string name = 2;
   *    int32 quantity = 3;
   *    double price = 4;
   *    bool status = 5;
   *  }
   *}
   * </pre>
   */
  public static final class PingPongServiceBlockingStub extends io.grpc.stub.AbstractBlockingStub<PingPongServiceBlockingStub> {
    private PingPongServiceBlockingStub(
        io.grpc.Channel channel, io.grpc.CallOptions callOptions) {
      super(channel, callOptions);
    }

    @java.lang.Override
    protected PingPongServiceBlockingStub build(
        io.grpc.Channel channel, io.grpc.CallOptions callOptions) {
      return new PingPongServiceBlockingStub(channel, callOptions);
    }

    /**
     * <pre>
     *  rpc ping(PingRequest) returns (PongResponse);
     * </pre>
     */
    public com.example.grpc.server.grpcserver.PongResponse ping(com.example.grpc.server.grpcserver.PingRequest request) {
      return blockingUnaryCall(
          getChannel(), getPingMethod(), getCallOptions(), request);
    }
  }

  /**
   * <pre>
   *message PingRequest {
   *  string ping = 1;
   *}
   *message PongResponse {
   *  string pong = 1;
   *  string descricao = 2;
   *  repeated string listTeste = 3;
   *  repeated Product listProduct = 4;
   *  message Product {
   *    string id = 1;
   *    string name = 2;
   *    int32 quantity = 3;
   *    double price = 4;
   *    bool status = 5;
   *  }
   *}
   * </pre>
   */
  public static final class PingPongServiceFutureStub extends io.grpc.stub.AbstractFutureStub<PingPongServiceFutureStub> {
    private PingPongServiceFutureStub(
        io.grpc.Channel channel, io.grpc.CallOptions callOptions) {
      super(channel, callOptions);
    }

    @java.lang.Override
    protected PingPongServiceFutureStub build(
        io.grpc.Channel channel, io.grpc.CallOptions callOptions) {
      return new PingPongServiceFutureStub(channel, callOptions);
    }

    /**
     * <pre>
     *  rpc ping(PingRequest) returns (PongResponse);
     * </pre>
     */
    public com.google.common.util.concurrent.ListenableFuture<com.example.grpc.server.grpcserver.PongResponse> ping(
        com.example.grpc.server.grpcserver.PingRequest request) {
      return futureUnaryCall(
          getChannel().newCall(getPingMethod(), getCallOptions()), request);
    }
  }

  private static final int METHODID_PING = 0;

  private static final class MethodHandlers<Req, Resp> implements
      io.grpc.stub.ServerCalls.UnaryMethod<Req, Resp>,
      io.grpc.stub.ServerCalls.ServerStreamingMethod<Req, Resp>,
      io.grpc.stub.ServerCalls.ClientStreamingMethod<Req, Resp>,
      io.grpc.stub.ServerCalls.BidiStreamingMethod<Req, Resp> {
    private final PingPongServiceImplBase serviceImpl;
    private final int methodId;

    MethodHandlers(PingPongServiceImplBase serviceImpl, int methodId) {
      this.serviceImpl = serviceImpl;
      this.methodId = methodId;
    }

    @java.lang.Override
    @java.lang.SuppressWarnings("unchecked")
    public void invoke(Req request, io.grpc.stub.StreamObserver<Resp> responseObserver) {
      switch (methodId) {
        case METHODID_PING:
          serviceImpl.ping((com.example.grpc.server.grpcserver.PingRequest) request,
              (io.grpc.stub.StreamObserver<com.example.grpc.server.grpcserver.PongResponse>) responseObserver);
          break;
        default:
          throw new AssertionError();
      }
    }

    @java.lang.Override
    @java.lang.SuppressWarnings("unchecked")
    public io.grpc.stub.StreamObserver<Req> invoke(
        io.grpc.stub.StreamObserver<Resp> responseObserver) {
      switch (methodId) {
        default:
          throw new AssertionError();
      }
    }
  }

  private static abstract class PingPongServiceBaseDescriptorSupplier
      implements io.grpc.protobuf.ProtoFileDescriptorSupplier, io.grpc.protobuf.ProtoServiceDescriptorSupplier {
    PingPongServiceBaseDescriptorSupplier() {}

    @java.lang.Override
    public com.google.protobuf.Descriptors.FileDescriptor getFileDescriptor() {
      return com.example.grpc.server.grpcserver.PingPongServiceOuterClass.getDescriptor();
    }

    @java.lang.Override
    public com.google.protobuf.Descriptors.ServiceDescriptor getServiceDescriptor() {
      return getFileDescriptor().findServiceByName("PingPongService");
    }
  }

  private static final class PingPongServiceFileDescriptorSupplier
      extends PingPongServiceBaseDescriptorSupplier {
    PingPongServiceFileDescriptorSupplier() {}
  }

  private static final class PingPongServiceMethodDescriptorSupplier
      extends PingPongServiceBaseDescriptorSupplier
      implements io.grpc.protobuf.ProtoMethodDescriptorSupplier {
    private final String methodName;

    PingPongServiceMethodDescriptorSupplier(String methodName) {
      this.methodName = methodName;
    }

    @java.lang.Override
    public com.google.protobuf.Descriptors.MethodDescriptor getMethodDescriptor() {
      return getServiceDescriptor().findMethodByName(methodName);
    }
  }

  private static volatile io.grpc.ServiceDescriptor serviceDescriptor;

  public static io.grpc.ServiceDescriptor getServiceDescriptor() {
    io.grpc.ServiceDescriptor result = serviceDescriptor;
    if (result == null) {
      synchronized (PingPongServiceGrpc.class) {
        result = serviceDescriptor;
        if (result == null) {
          serviceDescriptor = result = io.grpc.ServiceDescriptor.newBuilder(SERVICE_NAME)
              .setSchemaDescriptor(new PingPongServiceFileDescriptorSupplier())
              .addMethod(getPingMethod())
              .build();
        }
      }
    }
    return result;
  }
}
