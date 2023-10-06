using AIInterviewPrep.DAOs;
using AIInterviewPrep.DAOs.Interfaces;
using AIInterviewPrep.Hubs;
using Microsoft.Extensions.Configuration;

internal class Program
{
    private static void Main(string[] args)
    {
        string MyAllowSpecificOrigins = "_myAllowSpecificOrigins";

        WebApplicationBuilder builder = WebApplication.CreateBuilder(args);

        builder.Services.AddCors(options =>
        {
            options.AddPolicy(MyAllowSpecificOrigins,
                policy =>
                {
                    policy.WithOrigins("http://localhost:5173")
                    .AllowAnyHeader()
                    .AllowAnyMethod()
                    .AllowCredentials();
                });
        });

        IConfiguration configuration = new ConfigurationBuilder()
         .SetBasePath(Directory.GetCurrentDirectory()) // Set the base path where your appsettings.json is located
         .AddJsonFile("appsettings.json") // Load the appsettings.json file
         .Build();

        string connectionString = configuration.GetConnectionString("Project") ?? string.Empty;

        // Add services to the container.
        builder.Services.AddControllers();
        // Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
        builder.Services.AddEndpointsApiExplorer();
        builder.Services.AddSwaggerGen();
        builder.Services.AddSignalR();

        builder.Services.AddTransient<IDeckDao>(m => new DeckSqlDao(connectionString));

        WebApplication app = builder.Build();

        // Configure the HTTP request pipeline.
        if (app.Environment.IsDevelopment())
        {
            app.UseSwagger();
            app.UseSwaggerUI();
        }

        app.UseHttpsRedirection();
        app.UseCors(MyAllowSpecificOrigins);
        app.UseAuthorization();
        app.MapControllers();
        app.MapHub<OpenAIHub>("/openAIHub");

        app.Run();
    }
}