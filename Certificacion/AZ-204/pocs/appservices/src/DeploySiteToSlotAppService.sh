
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

# Copy the result of the following command into a browser to see the web app in the production slot.
#site="https://$webapp.azurewebsites.net"
#echo $site
#curl "$site"