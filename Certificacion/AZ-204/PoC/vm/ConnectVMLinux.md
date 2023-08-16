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

  :arrow_right: Obtener mediante az cli el username del usuario admin de la VM, y ese valor almacenarlo en la variable **adminUser**
  ```bash
  adminUser="$(az vm show -g rg-demo -n vmdemoaz204linux --query osProfile.adminUsername -o tsv)"
  ```
> **Nota:** También se puede almacenar el resultado en una variable con el caracter backtick `
    
  ```
      adminUser=`az vm show -g rg-demo -n vmdemoaz204linux --query osProfile.adminUsername -o tsv`
  ```

  :arrow_right: Obtener mediante az cli la ip pública de la VM, y ese valor almacenarlo en la variable **publicIp**
  ```bash
  publicIp="$(az vm show -g rg-demo -n vmdemoaz204linux -d --query publicIps -o tsv)"
  ```

  :arrow_right: Remover(con tr) salto de linea y retorno de carro para poder concatenar y ejecutar la conexión por SSH.
  ```bash
  adminUser=$(echo $adminUser|tr -d '\n\r')
  ```
  ```bash
  publicIp=$(echo $publicIp|tr -d '\n\r')
  ```

  :arrow_right: Conectar por ssh
   ```bash
  ssh $adminUser@$publicIp
  ```

   :arrow_right: Bien, ahora este código lo puedes colocar en un archivo .sh en la ubicación que desees. El archivo se encuentra :link: [aquí](https://github.com/jatuncarc/Azure/blob/master/Certificacion/AZ-204/PoC/vm/src/ConnectVMLinux.sh) para que lo descargues.

   :arrow_right: Para probar basta con abrir el terminal y ejecutar el script, previamente situándose en la ruta actual donde se encuentra el script.

  ```
  ./ConnectVMLinux.sh
  ```

  ![alt](https://github.com/jatuncarc/Azure/blob/master/Certificacion/AZ-204/img/ConnectVMLinux.png?raw=true)


  :arrow_right: Se solicitará ingresar el password del usuario administrador, que es el mismo con el que aprovisionó en este ejemplo líneas arriba.

  ![alt](https://github.com/jatuncarc/Azure/blob/master/Certificacion/AZ-204/img/ConnectVMLinuxSuccess.png?raw=true)

  Y listo.