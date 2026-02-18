package com.benchmark.monolith.controller;

import com.benchmark.monolith.entity.Bonus;
import com.benchmark.monolith.service.BonusService;
import java.util.List;
import jakarta.inject.Inject;
import jakarta.ws.rs.*;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;

@Path("/bonus")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
public class BonusController {

    @Inject
    BonusService bonusService;

    @POST
    public Response createBonus(Bonus bonus) {
        Bonus createdBonus = bonusService.createBonus(bonus);
        return Response.ok(createdBonus).build();
    }

    @GET
    @Path("/recents")
    public Response getRecents() {
        List<Bonus> recents = bonusService.getRecents();
        return Response.ok(recents).build();
    }

    @GET
    @Path("/{id}")
    public Response getBonusById(@PathParam("id") Long id) {
        Bonus bonus = bonusService.getBonusById(id);
        if (bonus == null) {
            return Response.status(Response.Status.NOT_FOUND).build();
        }
        return Response.ok(bonus).build();
    }
}
