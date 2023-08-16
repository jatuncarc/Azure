# AzureFunctions

  

  

### **1. Crear credencial azure para deploy con GitHub Actions**

```

az ad sp create-for-rbac --name "MyApplication" --role contributor --scopes /subscriptions/SubscriptionId/resourceGroups/MyApps --sdk-auth

```

```

az ad sp create-for-rbac --name "MyFunctions" --role contributor --scopes /subscriptions/c8eb5574-f147-4230-978a-06596636cfee/resourceGroups/MyApps --sdk-auth

```

  

> **MyApplication** es el nombre de la aplicación a crear en Azure Active Directory

>

> **SuscriptionId** es Id de la suscripción de Azure. Este valor se puede obtener con el comando az cli `az account list -o table`

>

> **MyApps** es el nombre del resource group.

  
  

El resultado del comando anterior, arroja(si todo sale bien) un resultado similar a la siguiente imagen:

  

![dddd](https://github.com/jatuncarc/AzureFunctions/blob/master/img/azure-rbac.png?raw=true)

  

Luego en el repositorio GitHub, ingresar a la opción **Settings** , luego a **Secrets and variables**, finalmente a **Actions** y agregar un nuevo secreto mediante el botón **New Repository secret**

  

![text](https://github.com/jatuncarc/AzureFunctions/blob/master/img/Github-Actions-Azure-Credentials.png?raw=true)

  

>**NOTA**: Este tipo de autenticación a Azure es la más común y está catalogada como Legacy. GitHub recomienda usar el método Open Id Connect (OIDC). Para más detalles revisar los siguientes enlaces:

  
[GitHub Actions authentication methods for Azure](https://dev.to/pwd9000/bk-1iij)
[GitHub Action for Azure Login](https://github.com/marketplace/actions/azure-login)