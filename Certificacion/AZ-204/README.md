# :computer:Certificación AZ-204

Este  documento consta comandos de **Azure CLI** principalmente para la gestión de recursos en Azure y otra información relevante que he registrado en este repositorio durante mi preparación para la certificación AZ-204.

## AZURE CLI - GENERAL

* Ayuda
  ```bash
  az --help
  ```

* Loguear
    ```bash
    az login
    ```

* Obtener información de la cuenta

    ```bash
    az account list -o table
    ```

* Obtener lista de regiones azure

    ```
    az account list-locations -o table
    ```

* Obtener lista de recursos

    ```
    az resource list -o table
    ```

* Obtener información de un recurso.

    ```
    az resource show --ids /subscriptions/c8eb5574-f147-4230-978a-06596636cfee/resourceGroups/rg-demo/providers/Microsoft.Sql/serv
    ers/srv-sql-demo
    ```
    >El valor del parámetro **ids** se puede obtener con el comando `az resource list -o json`

<br>

## AZURE CLI - ACTIVE DIRECTORY

* Crear service principal.

    ```
    az ad sp create-for-rbac -n "authapp" --role Contributor --scopes /subscriptions/c8eb5574-f147-4230-978a-06596636cfee/resourceGroups/rg-demo
    ```
    >En el parámetro **scopes** se completa con el **subscriptionid** y nombre de recurso/grupo de recursos

	*Resultado:*
    ```json
	{
	  "appId": "45311875-f708-44c4-944e-xxxxxxxxxxxx",
	  "displayName": "authapp",
	  "password": "A.t8Q~SvywgsMfP4o0p6xxxxxxxxxxxxxxU",
	  "tenant": "ee33e044-ed00-4025-bcad-xxxxxxxxxxxx"
	}
    ```
    >Custodiar las credenciales

* Obtener lista de apps registrados en AAD
    ```
    az ad sp list -o table
    ```

* Obtener lista de sp (apps) registrados en AAD filtrado por nombre
    ```
    az ad sp list --display-name "authapp" -o table
    ```

* Obtener lista de sp (apps) registrados en AAD filtrado por nombre y mostrar solo el campo **id**
    ```
    az ad sp list --display-name "authapp" --query [].appId -o table 
    ```

    >**Nota**: También se puede obtener lo mismo con el comando `az ad app list..`, dado que al crear un application también se crea un service principal.

* Resetear las credenciales de service principal por su **id**.
    ```
    az ad sp credential reset --id "45311875-f708-44c4-944e-3efdfb50179d"
    ```
    >El **id** se puede obtener con el comando `az ad app list -o table` campo **AppId**

	*Resultado:*
    ```json
	{
	  "appId": "45311875-f708-44c4-944e-xxxxxxxxxxxx",
	  "displayName": "authapp",
	  "password": "A.t8Q~SvywgsMfP4o0p6xxxxxxxxxxxxxxU",
	  "tenant": "ee33e044-ed00-4025-bcad-xxxxxxxxxxxx"
	}
	
* Obtener token
    ```
    az account get-access-token
    ```
    >Previamente haber hecho el `az login` con el service principal
