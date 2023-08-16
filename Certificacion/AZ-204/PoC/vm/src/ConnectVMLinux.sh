#!/bin/bash
#Almacenar en la variable adminUser el username admin de la VM
adminUser="$(az vm show -g rg-demo -n vmdemoaz204linux --query osProfile.adminUsername -o tsv)"

#Tambien se puede almacenar el resultado en una variable con el backtick `

#adminUser=`az vm show -g rg-demo -n vmdemoaz204linux --query osProfile.adminUsername -o tsv`

#Almacenar en la variable publicIP la IP publica de la VM.
publicIp="$(az vm show -g rg-demo -n vmdemoaz204linux -d --query publicIps -o tsv)"


#Imprimir el valor en archivo de texto para validar caracteres extraños
#echo -n $adminUser > adminuser.log
#echo -n $publicIp > publicip.log

#Remover(con tr) salto de linea y retorno de carro para poder concatenar y ejecutar la conexión por SSH.
adminUser=$(echo $adminUser|tr -d '\n\r')
publicIp=$(echo $publicIp|tr -d '\n\r')

#Conectar por ssh
ssh $adminUser@$publicIp
