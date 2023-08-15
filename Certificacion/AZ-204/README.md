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

<br>

## AZURE CLI - RESOURCES GROUP
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

## AZURE CLI - VIRTUAL MACHINE
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
