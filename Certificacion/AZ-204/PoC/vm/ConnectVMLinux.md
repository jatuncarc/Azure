# :computer:Conectar a VM mediante script bash

Esta es un ejemplo de como obtener datos de una VM Linux para generar una conexión por ssh y conectarse a la VM.

## :bulb: Requisitos

  :arrow_right: Tener aprovisionada una máquina virtual Linux(cualquier distribución) y tamaño.

  ```bash
  az vm create -g rg-demo -n vmdemoaz204linux --image RedHat:RHEL:8-lvm-gen2:latest -l eastus2 --size Standard_B1ls --public-ip-sku Basic --authentication-type password --admin-username azureuser --admin-password xxxxxxxxx
  ```
   > Para el ejemplo, el código anterior está compuesto por lo siguiente:
   >* **rg-demo** es el nombre del grupo de recursos
   >* **vmdemoaz204linux** es el nombre que se le dará a la VM
   >* **RedHat:RHEL:8-lvm-gen2:latest** es el nombre de la imagen de VM de la cual se creará la VM
   >* **eastus2** es la región donde se ubicará la VM. 
   >* **Standard_B1ls** es el tamaño de la VM
   >* La autenticación a la VM es con usuario **azureuser** y password (reemplazar el xxxxx por un valor correcto para el password)
   

## :bulb: Script

  :arrow_right: Tener aprovisionada una máquina virtual Linux(cualquier distribución) y tamaño.
  ```bash
  adminUser="$(az vm show -g rg-demo -n vmdemoaz204linux --query osProfile.adminUsername -o tsv)"
  ```
