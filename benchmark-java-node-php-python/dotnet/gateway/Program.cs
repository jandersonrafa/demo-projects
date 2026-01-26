using Prometheus;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.
builder.Services.AddHttpClient("Monolith", client =>
{
    var monolithUrl = Environment.GetEnvironmentVariable("MONOLITH_URL") ?? "http://localhost:3000";
    client.BaseAddress = new Uri(monolithUrl);
})
.ConfigurePrimaryHttpMessageHandler(() => new HttpClientHandler
{
    MaxConnectionsPerServer = 500
});

var app = builder.Build();

// Configure the HTTP request pipeline.
app.UseRouting();
app.UseHttpMetrics();
app.MapMetrics();

app.MapPost("/bonus", async (HttpContext context, IHttpClientFactory clientFactory) =>
{
    var client = clientFactory.CreateClient("Monolith");
    var content = new StreamContent(context.Request.Body);
    content.Headers.ContentType = new System.Net.Http.Headers.MediaTypeHeaderValue("application/json");

    var response = await client.PostAsync("/bonus", content);
    var responseBody = await response.Content.ReadAsByteArrayAsync();

    context.Response.StatusCode = (int)response.StatusCode;
    context.Response.ContentType = "application/json";
    await context.Response.Body.WriteAsync(responseBody);
});

app.MapGet("/bonus/{id}", async (string id, IHttpClientFactory clientFactory, HttpContext context) =>
{
    var client = clientFactory.CreateClient("Monolith");
    var response = await client.GetAsync($"/bonus/{id}");
    var responseBody = await response.Content.ReadAsByteArrayAsync();

    context.Response.StatusCode = (int)response.StatusCode;
    context.Response.ContentType = "application/json";
    await context.Response.Body.WriteAsync(responseBody);
});

var port = Environment.GetEnvironmentVariable("PORT") ?? "3000";
app.Run($"http://*:{port}");
