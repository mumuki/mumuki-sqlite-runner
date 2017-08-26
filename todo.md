
## TOFIX Labo Vagrant

 - Vagrant no tiene instalado las aplicaciones de dev: bundle, postgres, etc...,
   con lo cual hay que realizar la instalación de las aplicaciones tal como está en el README del laboratory.
   - **Opción 1**: generar un box propio que venga con todo instalador: `vagrant box add mumuki/development`
   - **Opción 2**: instalar mediante un script de provisioning

 - Quitar del readme del labo el seteo de `MUMUKI_LOGIN_PROVIDER` para
   development y aclarar que es la opción por defecto.

 - Forwardear el port del postgres para evitar conflicto con conexiones propias.
   Actualmente hay que usar 127.0.0.1:5432 para conectar desde el guest al vagrant.
   Si alguien tiene un motor corriendo en el guest no va a poder conectar contra la base del vagrant.
   Además, configurar postgres para que pueda ser accedido desde fuera de vagrant.
   - **Opción 1**: 5432 (guest) => 54322 (host)
   - **Opción 2**: Definirle una IP propia al vagrant en vez de que use localhost
   
 - Instalar docker environment en vagrant
