public class RICA_ClientesAuditores {
    
    
    public class clientesDeLevantamientos {
        @AuraEnabled
        public Id IdLevantamientoInventario { get; set; }
        @AuraEnabled
        public Id IdLevantamientoTickets { get; set; }
        @AuraEnabled
        public Id IdLevantamientoPerfilCategorias { get; set; }
        @AuraEnabled
        public Id IdCliente { get; set; }
        @AuraEnabled
        public String NombreCliente { get; set; }
        @AuraEnabled
        public String NombreEstablecimiento { get; set; }
        @AuraEnabled
        public Decimal Longitud { get; set; }
        @AuraEnabled
        public Decimal Latitud { get; set; }
        @AuraEnabled
        public String Calle { get; set; }
        @AuraEnabled
        public Decimal CodigoPostal { get; set; }
        @AuraEnabled
        public String Ciudad { get; set; }
        @AuraEnabled
        public String NoExterior { get; set; }
        @AuraEnabled
        public DateTime FinLevantamiento { get; set; }
        @AuraEnabled
        public String ColorEstatusInventario { get; set; }
        @AuraEnabled
        public String ColorEstatusTickets {get; set;}
        @AuraEnabled
        public String ColorEstatusPerfil {get; set;}
        @AuraEnabled
        public String NoCliente {get; set;}
    }
    
    @AuraEnabled
    public static List<clientesDeLevantamientos> obtenerClientes(Id idUsuarioAuditor) {
        Map<Id, clientesDeLevantamientos> mapaClientes = new Map<Id, clientesDeLevantamientos>();
        
        for (Levantamiento__c l : [
            SELECT Id, Cliente__c, Cliente__r.Name, Cliente__r.No_De_Cliente__c, Cliente__r.Nombre_del_Establecimiento__c,
                   Cliente__r.Dir_Entrega_Latitud__c, Cliente__r.Dir_Entrega_Longitud__c, Cliente__r.Calle__c,
                   Cliente__r.Codigo_Postal__c, Cliente__r.Cd_Pob__c, Cliente__r.No_Ext__c,RecordType.DeveloperName,Realizacion_del_Levantamiento__c
            FROM Levantamiento__c 
            WHERE Auditor_Asignado__c = :idUsuarioAuditor
        ]) {
            if (mapaClientes.containsKey(l.Cliente__c)) {
                // Si ya existe, actualizamos los colores
                clientesDeLevantamientos existente = mapaClientes.get(l.Cliente__c);
                /*existente.IdLevantamientoInventario = (l.RecordType.DeveloperName == 'Inventario') ? l.Id : existente.IdLevantamientoInventario;
                existente.IdLevantamientoTickets = (l.RecordType.DeveloperName == 'Tickets') ? l.Id : existente.IdLevantamientoTickets;
                existente.IdLevantamientoPerfilCategorias = (l.RecordType.DeveloperName == 'Perfil_Categorias') ? l.Id : existente.IdLevantamientoPerfilCategorias;*/
                switch on l.RecordType.DeveloperName {
                    when 'Inventario' {
                        existente.ColorEstatusInventario = (l.Realizacion_del_Levantamiento__c != True) ? 'amarillo' : 'verde';
                        existente.IdLevantamientoInventario =l.Id;
                    }	
                    when 'Tickets' {
                        existente.ColorEstatusTickets = (l.Realizacion_del_Levantamiento__c != True) ? 'azul' : 'verde';
                        existente.IdLevantamientoTickets =l.Id;
                    }
                    when 'Perfil_Categorias' {
                        existente.ColorEstatusPerfil = (l.Realizacion_del_Levantamiento__c != True) ? 'naranja' : 'verde';
                        existente.IdLevantamientoPerfilCategorias =l.Id;
                    }
                }
                /*existente.ColorEstatusInventario = (l.RecordType.DeveloperName == 'Inventario' && l.Realizacion_del_Levantamiento__c != True) ? 'amarillo' : 'verde';
                existente.ColorEstatusTickets = (l.RecordType.DeveloperName == 'Tickets' && l.Realizacion_del_Levantamiento__c != True) ? 'azul' : 'verde';
                existente.ColorEstatusPerfil = (l.RecordType.DeveloperName == 'Perfil_Categorias' && l.Realizacion_del_Levantamiento__c != True) ? 'naranja' : 'verde';*/
            } else {
                // Si no existe, creamos uno nuevo
                clientesDeLevantamientos levantamiento = new clientesDeLevantamientos();
                levantamiento.IdLevantamientoInventario = (l.RecordType.DeveloperName == 'Inventario') ? l.Id : null;
                levantamiento.IdLevantamientoTickets = (l.RecordType.DeveloperName == 'Tickets') ? l.Id : null;
                levantamiento.IdLevantamientoPerfilCategorias = (l.RecordType.DeveloperName == 'Perfil_Categorias') ? l.Id : null;
                levantamiento.IdCliente = l.Cliente__c;
                levantamiento.NombreCliente = l.Cliente__r.Name;
                levantamiento.NombreEstablecimiento = l.Cliente__r.Nombre_del_Establecimiento__c;
                levantamiento.Longitud = l.Cliente__r.Dir_Entrega_Longitud__c;
                levantamiento.Latitud = l.Cliente__r.Dir_Entrega_Latitud__c;
                levantamiento.Calle = l.Cliente__r.Calle__c;
                levantamiento.CodigoPostal = l.Cliente__r.Codigo_Postal__c;
                levantamiento.Ciudad = l.Cliente__r.Cd_Pob__c;
                levantamiento.NoExterior = l.Cliente__r.No_Ext__c;
                levantamiento.NoCliente = l.Cliente__r.No_De_Cliente__c;
                
                switch on l.RecordType.DeveloperName {
                    when 'Inventario' {
                        levantamiento.ColorEstatusInventario = (l.Realizacion_del_Levantamiento__c != True) ? 'amarillo' : 'verde';
                    }	
                    when 'Tickets' {
                        levantamiento.ColorEstatusTickets = (l.Realizacion_del_Levantamiento__c != True) ? 'azul' : 'verde';
                    }
                    when 'Perfil_Categorias' {
                        levantamiento.ColorEstatusPerfil = (l.Realizacion_del_Levantamiento__c != True) ? 'naranja' : 'verde';
                    }
                }
                mapaClientes.put(l.Cliente__c, levantamiento);
            }
        }
    
        return mapaClientes.values();
    }

    @AuraEnabled
    public static List<String> obtenerFabricantes(){
        Set<String> fabricantes = new Set<String>();
        for(SKU_Ticket_Inventario__c t : [SELECT Compania__c
                                            FROM SKU_Ticket_Inventario__c]){

            fabricantes.add(t.Compania__c);
        }

        return new List<String>(fabricantes);

        }
        
    @AuraEnabled
    public static Map<String,Map<String,List<string>>> obtenerOpcionesPorFabricante(){
        Map<String,Map<String,List<string>>> opcionesPorFabricante = new Map<String,Map<String,List<string>>>();
        
        for(SKU_Ticket_Inventario__c t : [SELECT Id,Agrupador_RICA__c,Categoria_RICA__c,
                                            Codigo_de_barras__c,Compania__c,Presentacion_RICA__c,
                                            Empaque_RICA__c,Fondos__c,Litraje__c,Litros__c,	
                                            Marca_RICA__c,Name,Precio_Nielsen__c,Precio_consumidor__c,
                                            Submarca_RICA__c,Tamano_RICA__c 
                                            FROM SKU_Ticket_Inventario__c]){                                 
            if(opcionesPorFabricante.get(t.Compania__c) != null){
                Map<String,List<string>> opcionesDelFabricante = opcionesPorFabricante.get(t.Compania__c);
                List<String> opcionesEmpaquesDelFabricante = opcionesDelFabricante.get('Empaques');
                List<String> opcionesCategoriasDelFabricante = opcionesDelFabricante.get('Categorias');
                List<String> opcionesSubmarcasDelFabricante = opcionesDelFabricante.get('Submarcas');
                if(!opcionesEmpaquesDelFabricante.contains(t.Empaque_RICA__c)){
                    opcionesEmpaquesDelFabricante.add(t.Empaque_RICA__c);
                }
                if(!opcionesCategoriasDelFabricante.contains(t.Categoria_RICA__c)){
                    opcionesCategoriasDelFabricante.add(t.Categoria_RICA__c);
                }
                if(!opcionesSubmarcasDelFabricante.contains(t.Submarca_RICA__c)){
                    opcionesSubmarcasDelFabricante.add(t.Submarca_RICA__c);
                }
            }else{
                Map<String,List<string>> opcionesDelFabricante = new Map<String,List<string>>();
                opcionesDelFabricante.put('Empaques',new List<String>{t.Empaque_RICA__c});
                opcionesDelFabricante.put('Categorias',new List<String>{t.Categoria_RICA__c});
                opcionesDelFabricante.put('Submarcas',new List<String>{t.Submarca_RICA__c});
                opcionesPorFabricante.put(t.Compania__c,opcionesDelFabricante);
            }
        }
        
        return opcionesPorFabricante;
    }

    @AuraEnabled
    public static SKU_Ticket_Inventario__c obtenerProducto(String codigoBarras){
        return[SELECT Id,Agrupador_RICA__c,Categoria_RICA__c,
                Codigo_de_barras__c,Compania__c,Presentacion_RICA__c,
                Empaque_RICA__c,Fondos__c,Litraje__c,Litros__c,	
                Marca_RICA__c,Name,Precio_Nielsen__c,Precio_consumidor__c,
                Submarca_RICA__c,Tamano_RICA__c 
                FROM SKU_Ticket_Inventario__c WHERE Codigo_de_barras__c =:codigoBarras ];
    }
    
    @AuraEnabled
    public static void guardarImagenBase64(String base64Data, String nombreArchivo, Id levantamientoId) {
        if (String.isBlank(base64Data) || String.isBlank(nombreArchivo) || String.isBlank(levantamientoId)) {
            throw new AuraHandledException('Datos incompletos para guardar el archivo');
        }

        // Crear el archivo como ContentVersion
        ContentVersion contenido = new ContentVersion();
        contenido.Title = nombreArchivo;
        contenido.PathOnClient = '/' + nombreArchivo;
        contenido.VersionData = EncodingUtil.base64Decode(base64Data);
        insert contenido;

        // Obtener el ContentDocumentId para relacionarlo
        Id contentDocumentId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :contenido.Id].ContentDocumentId;

        // Crear el enlace con el objeto Levantamiento__c
        ContentDocumentLink link = new ContentDocumentLink();
        link.ContentDocumentId = contentDocumentId;
        link.LinkedEntityId = levantamientoId; // el Id del Levantamiento__c
        link.ShareType = 'V'; // V = Viewer, C = Collaborator, I = Inferred
        link.Visibility = 'AllUsers';
        insert link;
    }
    
    @AuraEnabled
    public static Map<String,Map<String,String>> obtenerProductosConCodigoBarras(){
        Map<String,Map<String,String>> resultado = new Map<String,Map<String,String>>();
        //Integer i = 0;
        for(SKU_Ticket_Inventario__c prod : [SELECT Compania__c,Empaque_RICA__c,Categoria_RICA__c,Submarca_RICA__c,Codigo_de_barras__c FROM SKU_Ticket_Inventario__c WHERE Codigo_de_barras__c != NULL]){
            Map<String,String>valores = new Map<String,String>();
            valores.put('Compania__c',prod.Compania__c);
            valores.put('Empaque_RICA__c',prod.Empaque_RICA__c);
            valores.put('Categoria_RICA__c',prod.Categoria_RICA__c);
            valores.put('Submarca_RICA__c',prod.Submarca_RICA__c);
            resultado.put(prod.Codigo_de_barras__c,valores);
            
        }
        
        return resultado;
    }

}