import io.grpc.Server;
import io.grpc.ServerBuilder;
import sample.PingPongServiceImpl;

public class Application
{
    public static void main(String[] args) throws Exception
    {
        Server server = ServerBuilder.forPort(9091)
                .addService(new PingPongServiceImpl())
                .build();

        server.start();

        System.out.println("gRPC Server started.");

        server.awaitTermination();
    }
}
