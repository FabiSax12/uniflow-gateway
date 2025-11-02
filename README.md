# Simulacion de Azure APIM

## Clonar los tres microservicios

```bash
git clone https://github.com/FabiSax12/uniflow-academic-service.git
git clone https://github.com/seph-25/uniflow-tasks-api.git
git clone https://github.com/FabiSax12/uniflow-notification-service.git
```

## Levantar Gateway

> [!IMPORTANT]
> Asegurarse de tener libres los siguientes puertos: 27017, 5432, 8000.

```bash
docker compose -f ./gateway/docker-compose.yml up -d
```

## Frontend

```bash
git clone https://github.com/FabiSax12/UniFlow-Frontend.git
```

Seguir instrucciones del repositorio ./UniFlow-Frontend/README.md y usar como urls del backend el gateway creado anteriormente `http://localhost:8000`

