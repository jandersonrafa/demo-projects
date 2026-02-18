package com.benchmark.gateway.controller;

import com.benchmark.gateway.client.MonolithClient;
import com.benchmark.gateway.dto.BonusRequest;
import com.benchmark.gateway.dto.BonusResponse;
import java.util.List;
import jakarta.inject.Inject;
import jakarta.ws.rs.*;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;
import org.eclipse.microprofile.rest.client.inject.RestClient;

@Path("/bonus")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
public class BonusController {

    @Inject
    @RestClient
    MonolithClient monolithClient;

    @POST
    public Response createBonus(BonusRequest request) {
        BonusResponse response = monolithClient.createBonus(request);
        return Response.ok(response).build();
    }

    @GET
    @Path("/recents")
    public Response getRecents() {
        List<BonusResponse> response = monolithClient.getRecents();
        return Response.ok(response).build();
    }

    @GET
    @Path("/{id}")
    public Response getBonusById(@PathParam("id") Long id) {
        BonusResponse response = monolithClient.getBonusById(id);
        return Response.ok(response).build();
    }
}
