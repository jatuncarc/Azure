# :computer:COMANDOS AZURE CLI AZ-204

Este  documento consta comandos de **Azure CLI** principalmente para la gestión de recursos en Azure y otra información relevante que he registrado en este repositorio durante mi preparación para la certificación AZ-204.

## :bulb: General

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

## :bulb: Azure Active Directory

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

<br>

## :bulb: Resources Group
* Crear grupo de recursos
    ```
    az group create --location eastus2 --name rg-demo
    ```

* Exportar plantilla del resource group
    ```
    az group export --name rg-demo
    ```


* Exportar plantilla del resource group a json file
    ```
    az group export --name rg-demo > exportedtemplate.json
    ```

* Listas grupo de recursos
    ```
    az group list
    ```


* Listar grupo de recursos en formato tabla
    ```
    az group list -o table
    ```

* Listar grupo de recursos personalizando campos a mostrar.
  
    ```
    az group list --query "[].{name:name, location:location}" -o table
    ```
    ```
    az group list --query "[].{name:name, location:location, provisioningStateAlias:properties.provisioningState}" -o table
    ```
    > El valor antes del **:** es el alias del campo de salida, y el valor despues del **:** es el nombre del atributo(que puede tener niveles) del json de donde se realiza la query.

* Listar grupo de recusos aplicando filtro. para ello se utiliza el ? dentro del []. El nombre de la propiedad puede tener niveles

    ```
    az group list --query "[?name=='MyApps'].{Nombre:name, Ubicacion:location}"
    ```

* Listar grupo de recursos ordenado utilizando la funcion sort_by. El ordenamiento se da por el nombre del alias antecedido del caracter **&**

    ```
    az group list --query "sort_by([].{Nombre:name, Ubicacion:location}, &Nombre)"
    ```

* Eliminar grupo de recursos junto a los recursos asociados al mismo. 

    ```
    az group delete --name rg-demo -y
    ```
    > El parámetro **-y** para evitar solicitar confirmación.

* Eliminar recursos sin eliminar el resource group:
	* Instalar bicep, sólo la primera vez
        ```
        az bicep install
        ```
	* Crear un archivo .bicep vacío en algún directorio
        ```bash
        $null > ResourceGroupCleanup.bicep
        ```
	* Crear un deployment del bicep vacio.
        ```
        az deployment group create -g rg-demo -f ResourceGroupCleanup.bicep --mode Complete
        ```
        >Es necesario estar ubicado en el directorio donde se encuentra el archivo .bicep
	* En caso se requiera, ejecutar lo siguiente
        ```
        az config set bicep.use_binary_from_path=false
        ```
<br>

## :bulb: Azure Virtual Machine
* Obtener lista de imagenes vm. Obtiene una lista offlines de images
    ```
    az vm image list -o table
    ```

* Obtener lista de imagenes completa y actualizada. Puede demorar algunos minutos.

    ```
    az vm image list --all -o table
    ```
    ```
    az vm image list --all --offer windows11
    ```
    ```
    az vm image list --query "[?contains(offer,'Windows')].{Offer:offer,publisher:publisher,sku:sku,urn:urn,urnAlias:urnAlias}" -o table
    ```

    Para que no demore mucho la consulta, incluir mas parametros de consulta, por ejemplo: pusblisher, offer, etc. Es válido una cadena corta para buscar las coincidencias(contains)

    ```
    az vm image list --all --publisher windowsdesktop --offer windows11 -o table
    ```
    ```
    az vm image list --all --publisher windowsserver --sku 2019 -o table
    ```
    ```
    az vm image list --all --publisher redhat --offer rhel --sku 86 --query "[?contains(version, '8.6')]" -o table
    ```

* Obtener lista completa de imagenes CentOS
    ```
    az vm image list -f CentOS --all
    ```
    ```
    az vm image list -f RHEL --all
    ```

>Link referencia: https://az-vm-image.info/

* Obtener lista de sizes de vm
    ```
    az vm list-sizes -l eastus2 -o table
    ```

    **Variantes:**
	* Obtener lista de sizes filtrando por nombre cuya serie sea Bs(B1 - más baratas) y número de cores igual a 4. Y ordenar por el campo name(el nombre exacto del campo se obtiene con la salida -o json)
        ```
        az vm list-sizes -l eastus2 --query "sort_by(@,&name)[?contains(name, `_B1`) && numberOfCores == `4`]" -o table
        ```
	
	* Obtener lista de sizes filtrando por serie B1 y ordenado por numero de cores
        ```
        az vm list-sizes -l eastus2 --query "sort_by(@,&numberOfCores )[?contains(name, `_B1`)]" -o table
        ```
	
	* Obtener lista de sizes filtrando por serie B1 y ordenado por numero de cores y luego por cantidad de memoria
        ```
        az vm list-sizes -l eastus2 --query "sort_by(sort_by(@,&numberOfCores),&memoryInMb)[?contains(name, `_B1`)]" -o table
        ```

* Crear vm Windows
  
    ```
    az vm create -n vmdemoaz204Win -g rg-demo --image Win2012R2Datacenter --public-ip-sku Basic --admin-username azureuser --admin-password xxxxxxxxx
    ```
    ```
    az vm create -n vmdemoaz204Win -g rg-demo --image MicrosoftWindowsDesktop:windows11preview:win11-22h2-avd:22621.382.220806 --public-ip-sku Basic --admin-username azureuser --admin-password xxxxxxxxx
    ```
    ```
    az vm create -n vmdemoaz204Win2 -g rg-demo --image MicrosoftWindowsServer:windowsserverdotnet:ws2019-dotnetcore-2-1:17763.1039.2002091844 --public-ip-sku Basic --admin-username azureuser --admin-password xxxxxxxxx
    ```

* Crear vm Linux RedHat. En el parametro imagen colocar el Urn o UrnAlias
    ```
    az vm create -g rg-demo -n vmdemoaz204linux --image RedHat:RHEL:8-lvm-gen2:latest -l eastus2 --size Standard_B1ls --public-ip-sku Basic --authentication-type password --admin-username azureuser --admin-password xxxxxxxxx
    ```


    **Variantes:**
	
    * Create a default RedHat VM with automatic SSH authentication using an image URN.

        ```
        az vm create -n MyVm -g MyResourceGroup --image RedHat:RHEL:7-RAW:7.4.2018010506
        ```

* listar vm y sus detalles
    ```
    az vm list -d -o table
    ```
    ```
    az vm list -d -o table --query "[?name=='vm-name']"
    ```

* Reinicar vm
    ```
    az vm restart -g rg-demo -n MyVm
    ```

* Mostrar informacion de vm
    ```
    az vm show -g rg-demo -n MyVm -d
    ```

* Iniciar vm
    ```
    az vm start -g rg-demo -n MyVm
    ```

* Detener la instancia de VM y apagar la VM
    ```
    az vm stop -g rg-demo -n MyVm
    ```

* Detener la instancia de VM sin apagar la VM
    ```
    az vm stop --resource-group rg-demo --name vmdemoaz204linux --skip-shutdown
    ```

* Apagar todas la VM de un grupo de recursos
    ```
    az vm stop --ids $(az vm list -g rg-demo --query "[].id" -o tsv)
    ```

* Eliminar vm sin pedir confirmacion
    ```
    az vm delete --name vmdemoaz204Win --resource-group rg-demo --yes
    ```

* Api consulta de precios azure
https://prices.azure.com/api/retail/prices
    > Link ref: https://learn.microsoft.com/en-us/rest/api/cost-management/retail-prices/azure-retail-prices

* Precios de máquinas virtuales:
https://azure.microsoft.com/es-es/pricing/details/virtual-machines/series/

<br>

## :bulb: Azure App Services
* Lista de runtimes 
    ```
    az webapp list-runtimes --os-type linux
    ```

* Crear AppService Plan(asp) con SKU F1(Free) y B1(Básico)
    ```
    az appservice plan create --name asp-demo --resource-group rg-demo --sku F1 
    ```
    ```
    az appservice plan create --name asp-demo --resource-group rg-demo --sku B1 
    ```
    > Si no se incluye el parámetro **sku** por defecto se creará con sku Basic Small(B1)

    >Capa de precios:, e.g., F1(Free), D1(Shared), B1(Basic Small), B2(Basic Medium), B3(Basic Large), S1(Standard Small), P1V2(Premium V2 Small), P2V2(Premium V2 Medium), P3V2(Premium V2 Large), P0V3(Premium V3 Extra Small), P1V3(Premium V3  Small), P2V3(Premium V3 Medium), P3V3(Premium V3 Large), P1MV3(Premium Memory Optimized V3 Small), P2MV3(Premium Memory Optimized V3 Medium), P3MV3(Premium Memory Optimized V3 Large), P4MV3(Premium Memory Optimized V3 Extra Large), P5MV3(Premium Memory Optimized V3 Extra Extra Large), I1 (Isolated Small), I2 (Isolated Medium), I3 (Isolated Large), I1v2 (Isolated V2 Small), I2v2 (Isolated V2 Medium), I3v2 (Isolated V2 Large), I4v2 (Isolated V2 I4v2), I5v2 (Isolated V2 I5v2), I6v2 (Isolated V2 I6v2), WS1 (Logic Apps Workflow Standard 1), WS2 (Logic Apps Workflow Standard 2), WS3 (Logic Apps Workflow Standard 3).  

    > Valores Permitidos para el párametro **sku**: B1, B2, B3, D1, F1, FREE, I1,                                     I1v2, I2, I2v2, I3, I3v2, I4v2, I5v2, I6v2, P0V3, P1MV3, P1V2,
                                     P1V3, P2MV3, P2V2, P2V3, P3MV3, P3V2, P3V3, P4MV3, P5MV3, S1,
                                     S2, S3, SHARED, WS1, WS2, WS3.  Default: B1.

    **Variantes:**
	* Crea asp en location eastus2
  
        ```
        az appservice plan create --name asp-demo2 --resource-group rg-demo --sku F1 -l eastus2 --no-wait
        ```
        > Si no se incluye el **location** toma la region del resource group y **--no-wait** es para no esperar a que termine la ejecución del comando en el terminal.


* Lista de precios de app service:
https://azure.microsoft.com/es-es/pricing/details/app-service/windows/

* Obtener lista de sku por api :
    >Link Ref: https://learn.microsoft.com/en-us/rest/api/appservice/app-service-plans/get-server-farm-skus#code-try-0

    >Link Ref: https://blog.jongallant.com/2017/11/azure-rest-apis-postman/

    * Crear un service principal
        ```
        az ad sp create-for-rbac -n "authapp" --role Contributor --scopes /subscriptions/c8eb5574-f147-4230-978a-06596636cfee/resourceGroups/rg-demo
        ```
        > En el parámetro **scopes** se completa con el **subscriptionid** y nombre de recurso/grupo de recursos (rg-demo en este caso)

        El resultado del comando anterior será similar a:
        ```json
        {
        "appId": "45311875-f708-44c4-944e-xxxxxxxxxxxx",
        "displayName": "authapp",
        "password": "A.t8Q~SvywgsMfP4o0p6xxxxxxxxxxxxxxU",
        "tenant": "ee33e044-ed00-4025-bcad-xxxxxxxxxxxx"
        }
        ```


    * En Postman generar un request **POST** para obtener el token de autorización para la consulta a la API correspondiente.
   
        ![alt](https://github.com/jatuncarc/Azure/blob/master/Certificacion/AZ-204/img/GetTokenAuthAzure.png?raw=true)
        
        >**Url Request**: `https://login.microsoftonline.com/ee33e044-ed00-4025-bcad-634aa49588db/oauth2/token`. Como parte de la url colocar el **tenantId**
        
        > **Parámetros Body:**
            > * **grant_type**: *client_credentials*
            > * **client_id**: clientid(o appId) del service principal
            > * **client_secret**: password del service principal
            > * **resource**: *https://management.azure.com*

    &nbsp;
    * En Postman realizar un request **GET** a la API de consulta de sku:
  
        ![alt](https://github.com/jatuncarc/Azure/blob/master/Certificacion/AZ-204/img/SetQueryGetRequestSKU.png?raw=true)

        > **Url Request**: `https://management.azure.com/subscriptions/c8eb5574-f147-4230-978a-06596636cfee/resourceGroups/rg-demo/providers/Microsoft.Web/serverfarms/asp-demo2/skus?api-version=2022-09-01`. Como parte de la url colocar el **subscriptionId**. El Parámetro **api-version** es un valor que microsoft proporciona.

        > Configurar el **token** antes de realizar la consulta. ![](https://github.com/jatuncarc/Azure/blob/master/Certificacion/AZ-204/img/SetTokenAuthGetSKU.png?raw=true)

* Listar app service plan
    ```
    az appservice plan list -o table
    ```

* Crear web app
    ```
    az webapp create --name wapp-demo --resource-group rg-demo --plan asp-demo
    ```

* Crear slot.
    ```
    az webapp deployment slot create --name wapp-demo --resource-group rg-demo --slot staging
    ```
    > Para crear un slot adicional al de por defecto. Es necesario que el app service plan tenga un sku Standar(S1) como mínimo.

* Desplegar una aplicación desde un repositorio GitHub a un slot
    ```
    az webapp deployment source config --name wapp-demo --resource-group rg-demo --slot staging --repo-url https://github.com/adamajammary/simple-web-app-mvc-dotnet --branch master --manual-integration

    ```

* Listar webapps
    ```
    az webapp list -o table
    ```

* Agregar appSettings
    ```
    az webapp config appsettings set --name wapp-demo --resource-group rg-demo --settings test="algo"
    ```

* Para transmitir logs en directo
    ```
    az webapp log tail --name wapp-demo --resource-group rg-demo
    ```

<br>

## :bulb: Azure SQL
* Crear servidor de base de datos
    ```
    az sql server create --name srv-sql-demo --location eastus2 --resource-group rg-demo --admin-user admindemo --admin-password Demo12345678.
    ```

* Listar servidor sql 
    ```
    az sql server list -o table
    ```

* Configuracion firewall
    ```
    az sql server firewall-rule create --resource-group rg-demo --server srv-sql-demo -n AllowYourIp --start-ip-address 38.25.18.127 --end-ip-address 38.25.18.127
    ```

* Obtener listado de Objective service para el servidor de bd
    ```powershell
    Get-AzSqlServerServiceObjective -ResourceGroupName "rg-demo" -ServerName "srv-sql-demo"
    ```
    > Link Ref: https://learn.microsoft.com/es-es/powershell/module/az.sql/get-azsqlserverserviceobjective?view=azps-10.1.0

* Crear base de datos
    ```
    az sql db create --resource-group rg-demo --server srv-sql-demo --name db-demo --edition Free --service-objective Free
    ```

* Listar base de datos del servidor
    ```
    az sql db list --server srv-sql-demo --resource-group rg-demo -o table
    ```

<br>

## :bulb: Azure Storage Account


* Lista de sku para storage account

    | Nombre | Tipos de cuenta admitidos | Descripción|
    |--|--|--|
    | Standard_LRS |Storage, BlobStorage, StorageV2|Almacenamiento con redundancia local estándar|
    | Standard_GRS |Storage, BlobStorage, StorageV2|Almacenamiento con replicación geográfica estándar|
    | Standard_RAGRS |Storage, BlobStorage, StorageV2|Almacenamiento replicado geográfica Read-Access estándar|
    | Standard_ZRS |Storage, StorageV2|Almacenamiento con redundancia de zona estándar|
    | Premium_LRS |	Storage, StorageV2, FileStorage, BlockBlobStorage|Almacenamiento con redundancia local de E/S aprovisionada|
    | Premium_ZRS |Storage, StorageV2|Almacenamiento con redundancia local de E/S aprovisionada|
    | Standard_GZRS |Storage, StorageV2|	Almacenamiento con redundancia local de E/S aprovisionada|
    | Standard_RAGZRS |Storage, StorageV2|	Almacenamiento con redundancia local de E/S aprovisionada|

    >Link Ref: https://learn.microsoft.com/es-es/rest/api/storagerp/srp_sku_types




* Crear storage account para function. Para el nombre del storage solo usar letras minusculas y numeros

    ```
    az storage account create --name sacdemoaz204 --location eastus2 --resource-group rg-demo --sku Standard_LRS
    ```

* Levantar el proyecto functions en local desde termianl vscode
    ```
    func start
    ```

<br>

## :bulb: Azure Functions
* Obtener la lista de runtimes
    ```
    az functionapp list-runtimes
    ```
* Crear function app
    ```
    az functionapp create --name myfunctiondemoaz204 --storage-account sacdemoaz204 --consumption-plan-location eastus2 --resource-group rg-demo --functions-version 4 --os-type Windows --runtime dotnet --runtime-version 6
    ```

<br>

## :bulb: Azure Container Registry(ACR)

* Crear de ACR
    ```
    az acr create --resource-group rg-demo --name myacrdemoaz204 --sku Basic
    ```

    **Variantes:**
	* Habilitar el usuario admin y crear el recurso en una región específica:
        ```
        az acr create --resource-group rg-demo --name myacrdemoaz204 --sku Basic --admin-enabled true --location eastus2
        ```

* Crear token de acceso al registry

    ```
    az acr login --name myacrdemoaz204.azurecr.io --expose-token --output tsv --query accessToken
    ```

    **Variantes:** 
    * Para loguear mediante token desde docker:
		* Con POWERSHELL
		```powershell
        $TOKENACR="$(az acr login --name myacrdemoaz204 --expose-token --output tsv --query accessToken)"
        ```
		```powershell
		docker login myacrdemoaz204.azurecr.io -u 00000000-0000-0000-0000-000000000000 -p $TOKENACR
        ```
	
		* Con CMD
		```bat
		for /f "delims=" %C in ('az acr login --name myacrdemoaz204 --expose-token --output tsv --query accessToken') do set "TOKENACR=%C"
        ```
		>Para verificar el resultado ejecutar: `echo %TOKENACR%`
		
        ```cmd
		docker login myacrdemoaz204.azurecr.io -u 00000000-0000-0000-0000-000000000000 -p %TOKENACR%
		```
		* Con BASH
		```bash
		TOKENACR=$(az acr login --name myacrdemoaz204 --expose-token --output tsv --query accessToken)
		```
        ```bash
		docker login myacrdemoaz204.azurecr.io -u 00000000-0000-0000-0000-000000000000 -p $TOKENACR
        ```

* Loguear al acr
    ```
    az acr login --name myacrdemoaz204 
    ```

	>Tambien se puede usar: `docker login myacrdemoaz204.azurecr.io`

    >**Nota**: Ambos comandos requieren tener el usuario admin habilitado para el registry. Y las credencias se encuentran en la opción "**claves de acceso**" del ACR visto desde el portal.

* Tagear imagen docker con el nombre de inicio de sesion del acr.
    ```
    docker tag aspnetapp:latest myacrdemoaz204.azurecr.io/aspnetapp:latest
    ```

* Subir imagen a acr
    ```
    docker push myacrdemoaz204.azurecr.io/aspnetapp:latest
    ```

* Listar imagenes del acr
    ```
    az acr repository list --name myacrdemoaz204 --output table
    ```

* Habilitar el usuario administrador del registry
    ```
    az acr update -n myacrdemoaz204 --admin-enabled true
    ```

* Compilar,subir y ejecutar imagen al acr sin tener docker en local
	* Crear dockerfile en local
        ```powershell
        echo "FROM mcr.microsoft.com/hello-world" > Dockerfile
        ```
	* Compilar y subir imagen al acr. Se tiene que estar situado en el directorio donde se encuentra el dockerfile
        ```
        az acr build --image sample/hello-world:v1 --registry myacrdemoaz204 --file Dockerfile .
        ```
	* Ejecutar contenedor
        ```
        az acr run --registry myacrdemoaz204 --cmd '$Registry/sample/hello-world:v1' /dev/null
        ```

* Importar y publicar la ultima imagen de Windows Core en el acr. 
    ```
    az acr import --name myacrdemoaz204 --source mcr.microsoft.com/windows/servercore:1607 --image windows/servercore:1607
    ```
    ```
    az acr import --name myacrdemoaz204 --source mcr.microsoft.com/windows/servercore:1607 --image mirepo:1
    ```
    >El tag **latest** no se encuentra en el registry publico de microsoft. 

    >El parámetro **image** es el nombre del repositorio y tag que se crea en el acr,se puede omitir y mantener el mismo nombre que el source o colocar un nombre y tag personalizado

* Eliminar acr
    ```
    az acr delete -n myacrdemoaz204 -y
    ```
<br>

## :bulb: Azure Container Instance(ACI)
* Listar contenedores
    ```
    az container list --resource-group rg-demo --output table
    ```

* Crear contenedor 
    ```
    az container create --resource-group rg-demo --name mycontainerdemoaz204 --image myacrdemoaz204.azurecr.io/aspnetapp:latest --dns-name-label mycontainerdemoaz204 --ports 80
    ```

    **Variantes:**
    * Agregar parámetros de recursos como cpu y memoria
        ```
        az container create -g rg-demo –name mycontainerdemoaz204 –image myacrdemoaz204.azurecr.io/aspnetapp:latest —ip-address public –cpu 2 –memory 5
        ```

* Consultar contenedor aprovisionado
    ```
    az container show --resource-group rg-demo --name mycontainerdemoaz204 --query "{FQDN:ipAddress.fqdn,ProvisioningState:provisioningState}" --out table
    ```

* Consultar logs del contenedor
    ```
    az container logs --resource-group rg-demo --name mycontainerdemoaz204
    ```

* Eliminar el contenedor
    ```
    az container delete --resource-group rg-demo --name mycontainerdemoaz204
    ```

* Corre en local el contenedor del acr.

    ```
    docker run myacrdemoaz204.azurecr.io/aspnetapp:latest
    ```
    > Si no existe la imagen en local, la descarga, crea el contenedor y lo corre.

## :bulb: Azure Service Bus
* Crear un namespace de mensajeria service bus
  
    ```
    az servicebus namespace create --resource-group rg-demo --name MyDemoServiceBusNS --location eastus2
    ```
    > Tambien se puede incluir el parámetro **sku** y sus valores permitidos son **Basic, Premium, Standard**. Por defecto es **Standard** si no se incluye este parámetro
    
    ```
    az servicebus namespace create --resource-group rg-demo --name MyDemoServiceBusNS --location eastus2 --sku Basic
    ```

* Crear una cola en el namespace del service bus
    ```
    az servicebus queue create --resource-group rg-demo --namespace-name MyDemoServiceBusNS --name MyDemoServiceBusQueue
    ```

* 