# :computer:Certificación AZ-204

Este  documento consta comandos de **Azure CLI** principalmente para la gestión de recursos en Azure y otra información relevante que he registrado en este repositorio durante mi preparación para la certificación AZ-204.

## AZURE CLI - GENERAL

- Ayuda

```bash
az --help
```

- loguear

```bash
az login
```

Obtener información de la cuenta

```bash
az account list -o table
```

Obtener lista de regiones azure

```
az account list-locations -o table
```

Obtener lista de recursos

```
az resource list -o table
```

Obtener información de un recurso. El **ids** se puede obtener con el `az resource list -o json`:

```
az resource show --ids /subscriptions/c8eb5574-f147-4230-978a-06596636cfee/resourceGroups/rg-demo/providers/Microsoft.Sql/serv
ers/srv-sql-demo
```

## AZURE CLI - ACTIVE DIRECTORY

Crear service principal, en scopes se completa con el subscriptionid y nombre de recurso/grupo de recursos. Del resultado custodiar las credenciales.

```
az ad sp create-for-rbac -n "authapp" --role Contributor --scopes /subscriptions/c8eb5574-f147-4230-978a-06596636cfee/resourceGroups/rg-demo
```


	Resultado:
	{
	  "appId": "45311875-f708-44c4-944e-3efdfb50179d",
	  "displayName": "authapp",
	  "password": "A.t8Q~SvywgsMfP4o0p6zXENyBl8JooD9QjuBajU",
	  "tenant": "ee33e044-ed00-4025-bcad-634aa49588db"
	}

Obtener lista de apps registrados en ad
```
az ad sp list -o table
```

Obtener lista de sp (apps) registrados en ad filtrado por nombre
```
az ad sp list --display-name "authapp" -o table
```

Obtener lista de sp (apps) registrados en ad filtrado por nombre y mostrar solo el campo id
```
az ad sp list --display-name "authapp" --query [].appId -o table 
```

**Nota: Tambien se puede obtener lo mismo con "az ad app list..", dado que al crear un application tambien se crea un service principal.

Resetear las credeciales de sp por id de sp. El id se peude obtener con el comando "az ad app list -o table" campo AppId
```
az ad sp credential reset --id "45311875-f708-44c4-944e-3efdfb50179d"
```

	**Resultado:
	{
	  "appId": "45311875-f708-44c4-944e-3efdfb50179d",
	  "password": "ctz8Q~oIZ-k3sdk1UNo5ofmvUlm.WEnpaXTyrcJT",
	  "tenant": "ee33e044-ed00-4025-bcad-634aa49588db"
	}
	
Obtener token
```
az account get-access-token previamente haber hecho el az login con sp
```
