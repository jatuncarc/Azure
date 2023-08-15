# :computer:Certificación AZ-204

Este  documento consta comandos de **Azure CLI** principalmente para la gestión de recursos en Azure y otra información relevante que he registrado en este repositorio durante mi preparación para la certificación AZ-204.

## GENERAL

Ayuda

```az --help```

loguear

`az login`

Obtener información de la cuenta

`az account list -o table`

Obtener lista de regiones azure

`az account list-locations -o table`

Obtener lista de recursos

`az resource list -o table`

Obtener información de un recurso. El **ids** se puede obtener con el `az resource list -o json`:

`az resource show --ids /subscriptions/c8eb5574-f147-4230-978a-06596636cfee/resourceGroups/rg-demo/providers/Microsoft.Sql/serv
ers/srv-sql-demo`


The editor-produced Markdown output supports most essential features, like [links](https://ckeditor.com/), **different** kinds of _emphasis_, `inline code formatting`, or code blocks:

```
p {
    text-align: center;
    color: red;
}
```