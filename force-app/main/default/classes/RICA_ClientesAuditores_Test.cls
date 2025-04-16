@IsTest
public class RICA_ClientesAuditores_Test {
	@isTest
    static void test(){
        Id tipoPerfil = [SELECT Id FROM RecordType WHERE SObjectType = 'Levantamiento__c' AND DeveloperName = 'Perfil_Categorias'].Id;
        Id tipoInventario = [SELECT Id FROM RecordType WHERE SObjectType = 'Levantamiento__c' AND DeveloperName = 'Inventario'].Id;
        Id tipoTickets = [SELECT Id FROM RecordType WHERE SObjectType = 'Levantamiento__c' AND DeveloperName = 'Tickets'].Id;
        Account testCuenta = rca_DataTestSetup.crearCuenta();
        Contact testContacto = rca_DataTestSetup.crearContacto(testCuenta.Id);
        Profile perfil = [SELECT Id, Name FROM Profile WHERE Name = 'Customer Community Plus User' LIMIT 1];
        User testUsuario = rca_DataTestSetup.crearUsuario(perfil.Id, testContacto.Id);
        
        Levantamiento__c levantamiento = rca_DataTestSetup.crearLevantamiento (testUsuario.Id,testCuenta.Id,tipoPerfil);
        Levantamiento__c levantamiento2 = rca_DataTestSetup.crearLevantamiento (testUsuario.Id,testCuenta.Id,tipoInventario);
        Levantamiento__c levantamiento3 = rca_DataTestSetup.crearLevantamiento (testUsuario.Id,testCuenta.Id,tipoTickets);
        SKU_Ticket_Inventario__c sku = rca_DataTestSetup.crearSkuStoreCheck ();
        
        // Cadena base64 de un archivo simulado (representa texto plano "Hola Mundo")
        String texto = 'Hola Mundo';
        String base64Data = EncodingUtil.base64Encode(Blob.valueOf(texto));
        String nombreArchivo = 'TestArchivo.txt';
        
        List<RICA_ClientesAuditores.clientesDeLevantamientos> clientes = RICA_ClientesAuditores.obtenerClientes (testUsuario.Id);
        Map<String,Map<String,List<string>>> opciones = RICA_ClientesAuditores.obtenerOpcionesPorFabricante();
        SKU_Ticket_Inventario__c skuObtenido = RICA_ClientesAuditores.obtenerProducto('1111');
        Map<String,Map<String,String>> productos = RICA_ClientesAuditores.obtenerProductosConCodigoBarras();
        List<String> fabricantes = RICA_ClientesAuditores.obtenerFabricantes();
        RICA_ClientesAuditores.guardarImagenBase64(base64Data, nombreArchivo, levantamiento.Id);
        
        
    }
    
}