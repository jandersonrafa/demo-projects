docker build -t benchmark-stacks/java-mvc-vt-gateway:1.0 ../apps/java-mvc-vt/gateway
docker build -t benchmark-stacks/java-mvc-vt-monolith:1.0 ../apps/java-mvc-vt/monolith
docker build -t benchmark-stacks/java-mvc-gateway:1.0 ../apps/java-mvc/gateway
docker build -t benchmark-stacks/java-mvc-monolith:1.0 ../apps/java-mvc/monolith
docker build -t benchmark-stacks/java-webflux-gateway:1.0 ../apps/java-webflux/gateway
docker build -t benchmark-stacks/java-webflux-monolith:1.0 ../apps/java-webflux/monolith