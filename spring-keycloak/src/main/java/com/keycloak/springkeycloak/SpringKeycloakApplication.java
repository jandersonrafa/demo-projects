package com.keycloak.springkeycloak;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.ComponentScan;

@ComponentScan("com.keycloak.springkeycloak")
@SpringBootApplication
public class SpringKeycloakApplication {

	public static void main(String[] args) {
		// SpringApplication app = new SpringApplication(SpringKeycloakApplication.class);
        // app.setApplicationStartup(new BufferingApplicationStartup(2048));
        // app.run(args);


		SpringApplication.run(SpringKeycloakApplication.class, args);
	}

}
