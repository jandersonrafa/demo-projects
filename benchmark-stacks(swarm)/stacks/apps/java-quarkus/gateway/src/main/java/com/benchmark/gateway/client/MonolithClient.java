package com.benchmark.gateway.client;

import com.benchmark.gateway.dto.BonusRequest;
import com.benchmark.gateway.dto.BonusResponse;
import java.util.List;
import jakarta.ws.rs.*;
import jakarta.ws.rs.core.MediaType;
import org.eclipse.microprofile.rest.client.inject.RegisterRestClient;

@Path("/bonus")
@RegisterRestClient(configKey = "com.benchmark.gateway.client.MonolithClient")
public interface MonolithClient {

    @POST
    @Produces(MediaType.APPLICATION_JSON)
    @Consumes(MediaType.APPLICATION_JSON)
    BonusResponse createBonus(BonusRequest request);

    @GET
    @Path("/{id}")
    @Produces(MediaType.APPLICATION_JSON)
    BonusResponse getBonusById(@PathParam("id") Long id);

    @GET
    @Path("/recents")
    @Produces(MediaType.APPLICATION_JSON)
    List<BonusResponse> getRecents();
}
