# :computer:Desplegar site en slot app services 

Esta es un ejemplo de cómo desplegar una web en un slot de appservices. Las fuentes de origen se encuentran en un repositorio de github. El caso de uso es poder testear la aplicación antes de liberarla en producción, para lo cual es conveniente primero realizar un despliegue a un slot distinto al de producción.

## :bulb: Pasos

  :arrow_right: Crear un grupo de recursos
  > **Nota:** *Es válido cambiar los nombres de los recursos.*
  ```bash
  az group create --name rg-demo --location eastus2
  ```

  :arrow_right: Crear app service plan. 
  ```bash
  az appservice plan create --name asp-demo --resource-group rg-demo --location eastus2 --sku S1
  ```
  >El mínimo requerido para crear slot es la capa Standar **S1**

  :arrow_right: Crear web app
  ```
  az webapp create --name testazwebapp2 --plan asp-demo --resource-group rg-demo
  ```

  :arrow_right:  Crear slot con nombre "staging".
  ```
  az webapp deployment slot create --name testazwebapp2 --resource-group rg-demo --slot staging
  ```

  :arrow_right: Desplegar site a slot desde un repo github
  ```
  az webapp deployment source config --name testazwebapp2 --resource-group rg-demo --slot staging --repo-url https://github.com/Azure-Samples/php-docs-hello-world --branch master --manual-integration
  ```
  > El parámetro ***--manual-integration*** deshabilita la sincronización entre el origen (github repo) y la webapp

:arrow_right: Con esto ya se puede probar la aplicación desplegada en el slot. Para el ejemplo la url sería la siguiente: https://testazwebapp2-staging.azurewebsites.net/

  ![alt](https://github.com/jatuncarc/Azure/blob/master/Certificacion/AZ-204/img/DeployWebSiteToSlot.png?raw=true)

## :bulb: Automatizando el despliegue

:arrow_right: Para automatizar este caso se puede tomar como referencia el siguiente código. :link: [Descargar](https://github.com/jatuncarc/Azure/blob/master/Certificacion/AZ-204/PoC/appservices/src/DeploySiteToSlotAppService.sh)

```bash
let "randomIdentifier=$RANDOM*$RANDOM"
location="eastus2"
resourceGroup="rg-demo"
appServicePlan="aspdemo-$randomIdentifier"
webapp="wappdemo-$randomIdentifier"
gitrepo=https://github.com/Azure-Samples/php-docs-hello-world

# Crear grupo de recursos
echo "Creando $resourceGroup en "$location"..."
az group create --name $resourceGroup --location "$location"

# Crear app service plan. El mínimo requerido para crear slot es la capa Standar S1
echo "Creado app service plan $appServicePlan"
az appservice plan create --name $appServicePlan --resource-group $resourceGroup --location "$location" \
--sku S1

# Crear web app
echo "Creating $webapp"
az webapp create --name $webapp --plan $appServicePlan --resource-group $resourceGroup

# Crear slot con nombre "staging".
az webapp deployment slot create --name $webapp --resource-group $resourceGroup --slot staging

# Desplegar site a slot desde un repo github
az webapp deployment source config --name $webapp --resource-group $resourceGroup --slot staging --repo-url $gitrepo --branch master --manual-integration

# Mostrar la url del slot. El nombre es siempre la concatenación del nombre de la webapp + "-" + con el nombre del slot
site="https://$webapp-staging.azurewebsites.net"
echo $site
curl "$site"

# Intercambiar(swap) el espacio a producción luego de confirmar que el testeo en el slot staging esta ok.
#az webapp deployment slot swap --name $webapp --resource-group $resourceGroup \
#--slot staging

#site="https://$webapp.azurewebsites.net"
#echo $site
#curl "$site"
```

Al ejecutar el archivo en un terminal bash arroja como resultado lo siguiente:

![alt](https://github.com/jatuncarc/Azure/blob/master/Certificacion/AZ-204/img/DeployWebSiteToSlotScript.png?raw=true)

Se muestra resaltado la url para probar el website desplegado:

![alt](https://github.com/jatuncarc/Azure/blob/master/Certificacion/AZ-204/img/DeployWebSiteToSlotScriptSuccess.png?raw=true)

  Y listo.