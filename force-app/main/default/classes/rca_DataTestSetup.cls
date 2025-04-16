/*
&---------------------------------------------------------------------
Autor           : ISC. Belém Briones Martpinez
Fecha           : 20.05.2024
Motivo          : Clase setup para creacion de objetos para clases test
Módulo SAP      : SD
Funcional       : Ana Laura Santillan Padilla
Proyecto        : RICApp
*¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬
Cada vez que se realice una modificación a este programa, debe ser
documentada en la siguiente sección.
*¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬
Control de Modificaciones
*¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬
* Autor           : 
* Fecha           : 
* Objetivo        : 
* N° Requerimiento: 
* Id Mod.         : 
*¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬
*/
@IsTest(SeeAllData=false)
public class rca_DataTestSetup {
    
    public static PRV_Pedido_RICA__c pedPrev (Id cnx, Id rutC){
        PRV_Pedido_RICA__c ped = new PRV_Pedido_RICA__c(

            Visita_M__c = cnx,
            Fecha_Preventa_SAP__c = Date.Today(),
            Tipo_de_Pedido_PList__c = 'ZTA1',
            Estatus_de_Pedido__c = 'Creado',
            Clase_de_Pedido__c = 'SF11',
            Pendiente_a_SAP_chk__c = True,
            Id_App__c = '123456000'
            
        );
        INSERT ped;
        return ped;
    }
    
    public static PRV_Pedido_RICA__c pedMaggy (Id cnx, Id rutC){
        PRV_Pedido_RICA__c ped = new PRV_Pedido_RICA__c(
            Ruta_Cliente_lk__c = rutC,
            Visita_M__c = cnx,
            Fecha_Preventa_SAP__c = Date.Today(),
            Tipo_de_Pedido_PList__c = 'ZTA1',
            Estatus_de_Pedido__c = 'Creado',
            Clase_de_Pedido__c = 'YALO',
            Pendiente_a_SAP_chk__c = True,
            Id_App__c = 'M1-1234560001'
            
        );
        INSERT ped;
        return ped;
    }
    
    public static PRV_Pedido_RICA__c pedRicapp (Id cnx, Id rutC){
        PRV_Pedido_RICA__c ped = new PRV_Pedido_RICA__c(
            Ruta_Cliente_lk__c = rutC,
            Visita_M__c = cnx,
            Fecha_Preventa_SAP__c = Date.Today(),
            Tipo_de_Pedido_PList__c = 'ZTA1',
            Estatus_de_Pedido__c = 'Creado',
            //Clase_de_Pedido__c = 'RICApp',
            Pendiente_a_SAP_chk__c = True,
            Id_App__c = 'R1-1234560002'
            
        );
        INSERT ped;
        return ped;
    }
    
    public static BuyerGroup creaBuyerGroup() {
        BuyerGroup buyer = new BuyerGroup(
            Name = 'CSDS PRUEBA POR'
        );
        INSERT buyer;
        return buyer;
    }
    
    public static WebStoreBuyerGroup creaBuyerGroupWebStore(Id web, Id buyer) {
        WebStoreBuyerGroup wsbuyer = new WebStoreBuyerGroup(
            WebStoreId = web,
            BuyerGroupId = buyer
        );
        INSERT wsbuyer;
        return wsbuyer;
    }
    
    
    
    
	public static Account crearCta(Id recorId) {
        Account cuenta = new Account(
            LastName = 'NAME NOMBRE COMPLETO',
            BillingCity = 'BillingCity',
            BillingCountry = 'Mexico',
            BillingState = 'Jalisco',
            BillingStreet = 'BillingStreet',
            BillingPostalCode  = 'BillingPostalCode',
            No_De_Cliente__c = '111000',
            RecordTypeId = recorId,
            Nombre_R_Social__c = 'PRUEBA ESTABLECIMIENTO',
            CorreoElectronico__c = 'pruebacorreo23155@gmail.com'
        );
        INSERT cuenta;
        return cuenta;
    }
    
    public static Account crearCta4(Id recorId) {
        Account cuenta = new Account(
            LastName = 'NAME NOMBRE COMPLETOee',
            BillingCity = 'BillingCity',
            BillingCountry = 'Mexico',
            BillingState = 'Jalisco',
            BillingStreet = 'BillingStreet',
            BillingPostalCode  = 'BillingPostalCode',
            No_De_Cliente__c = '999999',
            Programas_Manejantes__c = '04',
            RecordTypeId = recorId,
            BuyerGroup__c = True, 
            Nombre_R_Social__c = 'PRUEBA ESTABLECIMIENTO cdeed',
            CorreoElectronico__c = 'pruebacorreosse223f155@gmail.com',
            Celular__c='7714567643',
            PersonMobilePhone='7714567643',
            Phone = '7714567643'
        );
        INSERT cuenta;
        return cuenta;
    }
        
    public static Account crearCta3(Id recorId) {
        Account cuenta = new Account(
            LastName = 'NAME NOMBRE COMPLETO',
            BillingCity = 'BillingCity',
            BillingCountry = 'Mexico',
            BillingState = 'Jalisco',
            BillingStreet = 'BillingStreet',
            BillingPostalCode  = 'BillingPostalCode',
            No_De_Cliente__c = '111002',
            Programas_Manejantes__c = '01',
            RecordTypeId = recorId,
            Nombre_R_Social__c = 'PRUEBA ESTABLECIMIENTO c',
            CorreoElectronico__c = 'pruebacorreo23f155@gmail.com'
        );
        INSERT cuenta;
        return cuenta;
    }
    
    public static Account crearCtaPedMaggy(Id recorId) {
        Account cuenta = new Account(
            LastName = 'NOMBRE NOMBRE COMPLETO',
            BillingCity = 'BillingCity',
            BillingCountry = 'Mexico',
            BillingState = 'Jalisco',
            BillingStreet = 'BillingStreet',
            BillingPostalCode  = 'BillingPostalCode',
            No_De_Cliente__c = '1115199',
            RecordTypeId = recorId,
            Nombre_R_Social__c = 'PRUEBA ESTABLECIMIENTO CHUC',
            CorreoElectronico__c = 'pruebacorreo231555@gmail.com'
        );
        INSERT cuenta;
        return cuenta;
    }
    
    public static Account crearCta2(Id recorId) {
        Account cuenta = new Account(
            LastName = 'NOMBRE NOMBRE COMPLETO',
            BillingCity = 'BillingCity',
            BillingCountry = 'Mexico',
            BillingState = 'Jalisco',
            BillingStreet = 'BillingStreet',
            BillingPostalCode  = 'BillingPostalCode',
            No_De_Cliente__c = '1110001',
            RecordTypeId = recorId,
            Programas_Manejantes__c = '04',
            Nombre_R_Social__c = 'PRUEBA ESTABLECIMIENTO CHUC',
            CorreoElectronico__c = 'pruebacorreo231555@gmail.com'
        );
        INSERT cuenta;
        return cuenta;
    }

    public static Product2 createProduct(String name, String sku){
        Id recordTypeIdRegular = Schema.SObjectType.Product2.getRecordTypeInfosByName().get('Regular').getRecordTypeId();
        Product2 productTest = new Product2(
            Name = name,
            ProductCode = sku, 
            StockKeepingUnit = sku,
            RecordTypeId=recordTypeIdRegular,
            IsActive = TRUE
        );
        INSERT productTest;
        return productTest;
    }

    public static Region__c crearRegion(String zdedis){
        Region__c region = new Region__c(
            Name = 'NORTE',
            Zona_de_Distribucion__c = zdedis
        );
        INSERT region;
        return region;
    }

    public static Zona_de_Distribucion__c crearZdeD(){
        Zona_de_Distribucion__c zdedis = new Zona_de_Distribucion__c(
            Name = 'NORTE'
        );
        INSERT zdedis;
        return zdedis;
    }

    public static Sucursal__c crearSucursal(String region){
        Sucursal__c sucursal = new Sucursal__c(
            Name = 'C.D.TEST',
            Region_M__c = region,
            Estado_Sucursal__c = 'Hidalgo'
        );
        INSERT sucursal;
        return sucursal;
    }
    
    public static Canal__c crearCanal(){
        Canal__c canal = new Canal__c(
            Name = 'Rutas Canal Tradicional y Moderno (Preventa y Reparto)',
            Clave__c = '01'
        );
        INSERT canal;
        return canal;
    }
    
    public static Canal__c crearCanal18(){
        Canal__c canal = new Canal__c(
            Name = 'Televenta y Rutas Consumo Directo',
            Clave__c = '18'
        );
        INSERT canal;
        return canal;
    }
    
    public static Canal__c crearCanal20(){
        Canal__c canal = new Canal__c(
            Name = 'Rutas Garrafón',
            Clave__c = '20'
        );
        INSERT canal;
        return canal;
    }
    
    public static Ruta_Tipo__c crearRutaTipo(){
        Ruta_Tipo__c rutaTipo = new Ruta_Tipo__c(
            Name = 'REPARTO'
        );
        INSERT rutaTipo;
        return rutaTipo;
    }

    public static Ruta_Tipo__c crearRutaTipoPREVENTA(){
        Ruta_Tipo__c rutaTipo = new Ruta_Tipo__c(
            Name = 'PREVENTA'
        );
        INSERT rutaTipo;
        return rutaTipo;
    }

    public static Ruta_Tipo__c crearRutaTipoREPARTO(){
        Ruta_Tipo__c rutaTipo = new Ruta_Tipo__c(
            Name = 'REPARTO'
        );
        INSERT rutaTipo;
        return rutaTipo;
    }
    
    public static Ruta_de_Sucursal__c crearRutaSuc(Id sucursal, Id canal, Id rutaTipo){
        Ruta_de_Sucursal__c rut = new Ruta_de_Sucursal__c(
            Name = '1111-502',
            Sucursal_M__c = sucursal,
            Canal_Dist_Lk__c = canal,
            Ruta_Tipo__c = rutaTipo
            
        );
        INSERT rut;
        return rut;
    }

    public static Ruta__c crearRuta(Id sucursal, Id canal, Id rutaTipo, Id rutSuc){
        Ruta__c ruta = new Ruta__c(
            Name = '1111-502',
            Canal_distribucion__c = canal,
            Sucursal_Lk__c = sucursal,
            Tipo_de_Ruta_Lk__c = rutaTipo,
            Ruta_de_Sucursal__c = rutSuc
        );
        INSERT ruta;
        return ruta;
    } 
        
    public static Account crearCuenta() {
        Account cuenta = new Account(
            Name = 'GG-Name',
            BillingCity = 'BillingCity',
            BillingCountry = 'Mexico',
            BillingState = 'Jalisco',
            BillingStreet = 'BillingStreet',
            BillingPostalCode  = 'BillingPostalCode',
            No_De_Cliente__c = '1115198',
            CorreoElectronico__c = 'pruebadataset@gmail.com',
            Calle__c = 'A',
            Colonia__c = 'A',
            Cd_Pob__c = 'A',
            Mun_Del__c = 'A',
            Ent_Fed__c = 'A',
            Codigo_Postal__c = 42084,
            Phone = '7713810229',
            Nombre_R_Social__c = 'A',
            Calle_Fis__c = 'A',
            Colonia_Fiscal__c = 'A',
            Mun_Del_Fis__c = 'A',
            RFC__c = 'A',
            Cd_Pob_Fis__c = 'A',
            Nombre_del_Establecimiento__c = 'A',
            Programas_Manejantes__c = '04'
        );
        INSERT cuenta;
        return cuenta;
    }

    public static Producto_RICA__c createProductoRica(String codigo_producto,String product_id){
        Producto_RICA__c productoRica= new Producto_RICA__c();
        productoRica.Codigo_de_Producto__c=codigo_producto;
       	productoRica.Descripcion_de_Producto__c='test';
         if(product_id!=null){
        	productoRica.Producto_RICA_Embalaje_Lk__c=product_id; 
            productoRica.Envase__c=product_id;
        }
 
        productoRica.Retornabilidad__c='Retornable';
       
        
        insert productoRica;
        return productoRica;
    }
    
    public static Producto_RICA__c crearProductoRICAEnvase(){
        Producto_RICA__c productoRica= new Producto_RICA__c(
        	Name = '899993',
            Codigo_de_Producto__c = '899993',
            Tipificacion__c = 'ENRE'
        );
        insert productoRica;
        return productoRica;
    }
    
    public static PRV_Promocion__c  createPromotion(){
        PRV_Promocion__c  promotion= new PRV_Promocion__c();
        promotion.Folio_RICA__c='123456';
        promotion.Clave_SAP__c='123456';
       promotion.Tipo__c='Bonificación';
       promotion.Nombre_de_Promocion__c='test';
        promotion.Fecha_fin__c = Date.today();
       promotion.Aplicaciones_Maximas__c=5;
        insert promotion;
        
        return promotion;
    }
    
    public static PRV_SKU_Promocion__c createSkuPromotion(String promtionId,String product1Id,String product2Id){
        List<PRV_SKU_Promocion__c> skusPromtion= new List<PRV_SKU_Promocion__c>();
        PRV_SKU_Promocion__c sku= new PRV_SKU_Promocion__c();
        sku.Promocion_M__c=promtionId;
		sku.Producto_RICA_Lk__c=product1Id;
        skusPromtion.add(sku);
          sku= new PRV_SKU_Promocion__c();
        sku.Promocion_M__c=promtionId;
		sku.Producto_RICA_Lk__c=product2Id;
		 skusPromtion.add(sku);        
        insert skusPromtion;
        return sku;
        
    }
    
    public static PRV_SKU_Sustitucion__c createSkuSustitucion (String promocion_id,String sku_sutitucion_id,String sku_promotion_id){
        PRV_SKU_Sustitucion__c sustitucion= new PRV_SKU_Sustitucion__c();
        sustitucion.Promocion_M__c=promocion_id;
        sustitucion.SKU_Promocion__c=sku_sutitucion_id;
        sustitucion.SKU_Sustituto_Promo_Lk__c=sku_promotion_id;
       insert sustitucion;
       return sustitucion;
    }
        
    public static Ruta_de_Cliente__c crearRutaClientePrev(Id cuentaId, Id rutaId) {
        Ruta_de_Cliente__c rutaCliente = new Ruta_de_Cliente__c(
            Name = '1111-02-1115199',
            Cuenta_Lk__c = cuentaId,
            Ruta_M__c = rutaId,
            Fecha_Inicio__c = Date.newInstance(2024, 01, 01),
            Fecha_Fin__c = Date.newInstance(2099, 01, 01),
            Condicion_de_Pago__c = 'D001',
            Venta_Nueva_a_Credito__c=true,
            Lunes__c=true,
            Miercoles__c=true
        );
        INSERT rutaCliente;	
        return rutaCliente;
    }
    
    public static Ruta_de_Cliente__c crearRutaCliente(Id cuentaId, Id rutaId) {
        Ruta_de_Cliente__c rutaCliente = new Ruta_de_Cliente__c(
            Name = '1111-02-1115199',
            Cuenta_Lk__c = cuentaId,
            Ruta_M__c = rutaId,
            Fecha_Inicio__c = Date.newInstance(2024, 01, 01),
            Fecha_Fin__c = Date.newInstance(2099, 01, 01),
            Condicion_de_Pago__c = 'D001',
            Venta_Nueva_a_Credito__c=true,
            Lunes__c=true,
            Miercoles__c=true,
            TELE_Ruta_de_Reparto_Lk__c = rutaId,
            TELE_Nombre_del_Vendedor__c = 'ABC',
            Metodo_de_Pago_Principal__c = 'E'
        );
        INSERT rutaCliente;	
        return rutaCliente;
    }

    public static WebStore createStore (String name){
        WebStore store = new WebStore (
            Name = name,
            Type = 'B2B'
        );
        INSERT store;
        return store;
    }
    
    public static WebCart crearCarrito(String idTienda, String idCliente){
        WebCart carrito = new WebCart(
        	Name = 'Carrito Prueba',
            WebStoreId = idTienda,
            AccountId = idCliente
        );
        INSERT carrito;
        return carrito;
    }

    public static Contact createContact (String name, Id idAccount){
        Contact contact = new Contact(
            AccountId=idAccount,
            LastName = 'LastNameTest'
        );
        Insert contact;
        return contact;
    }


    public static User createUser(String username, String profileId, Id contactId) {
        User user = new User(
            ContactId=contactId,
            Username = username+'@rica.com.mx',     
            FirstName='NameTest',
            LastName= 'lastNameTest', 
            Alias = 'tuser',
            CommunityNickname = 'tuser',
            Email = username+'@ricapp.com.mx',
            EmailEncodingKey = 'UTF-8',
            LocaleSidKey = 'es_MX',
            ProfileId = profileId,
            TimeZoneSidKey = 'America/Mexico_City',
            LanguageLocaleKey = 'es_MX',
            DigestFrequency = 'D',
            DefaultGroupNotificationFrequency = 'P',
            UserRoleId = null
        );
        INSERT user;
        return user;
    }

    public static Contact crearContacto(Id cuenta) {
        Contact nuevoContacto = new Contact(
            FirstName = 'Nombre',
            LastName = 'Apellido',
            Email = 'correo@example.com',
            Phone = '1234567890',
            AccountId = cuenta // Si deseas asociar este contacto a una cuenta, proporciona el Id de la cuenta aquí
        );
        INSERT nuevoContacto;
        return nuevoContacto;
        
    }
    
    public static User crearUsuario(String profileId, Id contactId) {
        User user = new User(
            ContactId=contactId,
            Username = 'name@rica.com.mx',
            FirstName='NameTest',
            LastName= 'lastNameTest', 
            Alias = '1115198',
            CommunityNickname = 'tuser',
            Email = 'name@ricapp.com.mx',
            EmailEncodingKey = 'UTF-8',
            LocaleSidKey = 'es_MX',
            ProfileId = profileId,
            TimeZoneSidKey = 'America/Mexico_City',
            LanguageLocaleKey = 'es_MX',
            DigestFrequency = 'D',
            DefaultGroupNotificationFrequency = 'P',
            UserRoleId = null
        );
        INSERT user;
        return user;
    }

    public static REP_Entrega_de_Pedido__c crearEntrgPedido(String rutaCliente){
    	REP_Entrega_de_Pedido__c entrgPedido = new REP_Entrega_de_Pedido__c(
    		Folio_Factura_SAP__c = '6020748147',
    		Fecha_de_Entrega__c = Date.newInstance(2024, 10, 30),
    		Total_a_Pagar__c = 385,
    		Ruta_Cliente_Lk__c = rutaCliente
    	);
        INSERT entrgPedido;
        return entrgPedido;
	}
    
    public static REP_Pago__c crearPago(String entrgPedido){
    	REP_Pago__c pago = new REP_Pago__c(
    		Monto_a_Pagar__c = 385,
    		Entrega_de_Pedido_Lk__c = entrgPedido
    	);
        INSERT pago;
        return pago;
	}

    
    public static PRV_Portafolio__c crearPortafolio() {
        PRV_Portafolio__c portafolio = new PRV_Portafolio__c(
            ID_Portafolio__c = '502-1115198',
            Name = 'CSDS PRUEBA POR',
            Activo__c = TRUE
        );
        INSERT portafolio;	
        return portafolio;
    }
    
    public static PRV_Portafolio__c crearPortafolioPrev() {
        PRV_Portafolio__c portafolio = new PRV_Portafolio__c(
            ID_Portafolio__c = '002-1115199',
            Name = 'CSDS PRUEBA POR',
            Activo__c = TRUE
        );
        INSERT portafolio;	
        return portafolio;
    }

    public static PRV_Portafolio_de_Cliente__c crearPortafolioCliente(Id portafolioId, Id rutaclienteId) {
        PRV_Portafolio_de_Cliente__c portafolioCliente = new PRV_Portafolio_de_Cliente__c(
            ID_Portafolio_de_Cliente__c = '502-1115198',
            Portafolio_M__c = portafolioId,
            Ruta_de_Cliente_M__c = rutaclienteId,
            Name = 'CSDS PRUEBA POR'
        );
        INSERT portafolioCliente;	
        return portafolioCliente;
    }
    
    public static PRV_Portafolio_de_Cliente__c crearPortafolioClientePrev(Id portafolioId, Id rutaclienteId) {
        PRV_Portafolio_de_Cliente__c portafolioCliente = new PRV_Portafolio_de_Cliente__c(
            ID_Portafolio_de_Cliente__c = '002-1115199',
            Portafolio_M__c = portafolioId,
            Ruta_de_Cliente_M__c = rutaclienteId,
            Name = 'CSDS PRUEBA POR',
            Clave_de_Portafolio_SAP__c = 'CSDS PRUEBA POR'
        );
        INSERT portafolioCliente;	
        return portafolioCliente;
    }

    public static PRV_Prod_de_Portafolio__c crearProdPortafolioPrevCustom(Id portafolioId, String productoRICA, String Sku) {
        PRV_Prod_de_Portafolio__c prodPortafolio = new PRV_Prod_de_Portafolio__c(
            ID_Portafolio__c = portafolioId,
            Name_Unico__c = '502-1115198-'+Sku,
            Name = Sku,
            Precio_de_Venta__c = 252.00,
            Fecha_de_Fin__c = Date.newInstance(2024, 01, 01),
            Precio_de_Venta_2__c = 252.00,
            Fecha_de_Fin_2__c = Date.newInstance(4000, 01, 01),
            Monto_Iva__c = 34.76,
            IEPS__c = 13.41,
            Monto_Iva_2__c = 34.76,
            IEPS_2__c = 13.41,
            Producto_RICA_M__c = productoRICA,
            Activo__c = TRUE,
            UM__c = 'BOT',
            IVA_2__c = 34.76, 
            IVA__c = 34.76,
            Clave_Portafolio_SAP__c ='055-'+Sku
        );
        INSERT prodPortafolio;	
        return prodPortafolio;
    }
     
    public static PRV_Prod_de_Portafolio__c crearProdPortafolio(Id portafolioId, String productoRICA) {
        PRV_Prod_de_Portafolio__c prodPortafolio = new PRV_Prod_de_Portafolio__c(
            ID_Portafolio__c = portafolioId,
            Name_Unico__c = '502-1115198-899999',
            Name = '899999',
            Precio_de_Venta__c = 252.00,
            Fecha_de_Fin__c = Date.newInstance(2024, 01, 01),
            Precio_de_Venta_2__c = 252.00,
            Fecha_de_Fin_2__c = Date.newInstance(4000, 01, 01),
            Monto_Iva__c = 34.76,
            IEPS__c = 13.41,
            Monto_Iva_2__c = 34.76,
            IEPS_2__c = 13.41,
            Producto_RICA_M__c = productoRICA,
            Activo__c = TRUE,
            NoVentaIndividual__c = FALSE,
            Inicio_Vigencia__c = Date.newInstance(2024, 01, 01),
            Fin_Vigencia__c = Date.newInstance(4000, 01, 01)
        );
        INSERT prodPortafolio;	
        return prodPortafolio;
    }

    public static PRV_Promocion__c crearPromocion(String canal) {
        PRV_Promocion__c promocion = new PRV_Promocion__c(
            Folio_RICA__c = '9999',
            Clave_SAP__c = '9999-48087',
            Canal_de_Distribucion_Lk__c = canal,
            Gr_Clientes_Maggy__c = '04',
            Fecha_Inicio__c = Date.newInstance(2024, 01, 01),
            Fecha_fin__c = Date.newInstance(4000, 01, 01),
            Tipo__c = 'Descuento',
            Maximo_por_Cliente__c = 10
        );
        INSERT promocion;	
        return promocion;
    }
    
    public static PRV_Promocion__c crearPromocionPrev(String canal) {
        PRV_Promocion__c promocion = new PRV_Promocion__c(
            Folio_RICA__c = '9999',
            Clave_SAP__c = '9999-48087',
            Canal_de_Distribucion_Lk__c = canal,
            Gr_Clientes_Maggy__c = '04',
            Fecha_Inicio__c = Date.newInstance(2024, 01, 01),
            Fecha_fin__c = Date.newInstance(4000, 01, 01),
            Fecha_Fin_de_Liquidacion__c = Date.newInstance(4000, 01, 02),
            Tipo__c = 'Bonificación',
            Maximo_por_Cliente__c = 10
        );
        INSERT promocion;	
        return promocion;
    }

    public static Promociones_Cliente__c crearPromocionCliente(String promocion, String rutaCliente) {
        Promociones_Cliente__c promocionCliente = new Promociones_Cliente__c(
            Name = '1111-502-1115198-PRM-0000013999',
            Promocion_lk__c = promocion,
            Ruta_Cliente_lk__c = rutaCliente
        );
        INSERT promocionCliente;	
        return promocionCliente;
    }

    public static Mezcla_Cliente__c crearMezclaCliente(String mezcla, String rutaCliente) {
        Mezcla_Cliente__c mezclaCte = new Mezcla_Cliente__c(
            Name = '1111-002-1115198-MEZ-0000013999',
            Mezcla_Lk__c = mezcla,
            Ruta_de_Cliente_Lk__c = rutaCliente
        );
        INSERT mezclaCte;	
        return mezclaCte;
    }
    
    
    public static Producto_RICA__c crearProductoRICA() {
        Producto_RICA__c productoRICA = new Producto_RICA__c(
            Name = '899999',
            Codigo_de_Producto__c = '899999',
            Nombre_Largo__c = 'A'
        );
        INSERT productoRICA;	
        return productoRICA;
    }
    
    public static Producto_RICA__c crearProductoRICACustom(String sku) {
        Producto_RICA__c productoRICA = new Producto_RICA__c(
            Name = sku,
            Codigo_de_Producto__c = sku,
            Factor_de_Conversion_Botella__c = 2,
            Factor_de_conversion_CFE__c = 2,
            Factor_de_Conversion_CU__c = 2
        );
        INSERT productoRICA;	
        return productoRICA;
    }
    
    public static Product2 crearProduct2(String canal) {
        
        Id recordTypeIdRegular = Schema.SObjectType.Product2.getRecordTypeInfosByName().get('Regular').getRecordTypeId();
        
        Product2 productoRICApp = new Product2(
            StockKeepingUnit = '899999',
            ProductCode = '899999',
            Name = 'Coca-Cola 600 ML',
            rca_Canal_de_Distribuci_n__c = canal,
            RecordTypeId = recordTypeIdRegular,
            IsActive = TRUE
        );
        INSERT productoRICApp;	
        return productoRICApp;
    }

    public static Product2 crearProduct2Promo(String canal) {
        
        Id recordTypeIdPromocion = Schema.SObjectType.Product2.getRecordTypeInfosByName().get('Promoción').getRecordTypeId();
        
        Product2 productoRICApp = new Product2(
            StockKeepingUnit = '9999-48087',
            ProductCode = '9999-48087',
            Name = 'Promo Prueba',
            rca_Canal_de_Distribuci_n__c = canal,
            RecordTypeId = recordTypeIdPromocion,
            IsActive = TRUE
        );
        INSERT productoRICApp;	
        return productoRICApp;
    }
    
    public static Product2 crearProduct2PromoConEnvaseYEmbalaje(String canal, String idEmbalajeEnvase) {
        
        Id recordTypeIdPromocion = Schema.SObjectType.Product2.getRecordTypeInfosByName().get('Regular').getRecordTypeId();
        
        Product2 productoRICApp = new Product2(
            StockKeepingUnit = '48089',
            ProductCode = '48087',
            Name = 'Promo Prueba',
            rca_Canal_de_Distribuci_n__c = canal,
            RecordTypeId = recordTypeIdPromocion,
            rca_Embalaje__c = idEmbalajeEnvase,
			rca_EnvaseRetornable__c = idEmbalajeEnvase  
        );
        INSERT productoRICApp;	
        return productoRICApp;
    }

    public static PRV_SKU_Promocion__c crearSKUPromo(String promocion, String productoRICA) {
        PRV_SKU_Promocion__c skuPromo = new PRV_SKU_Promocion__c(
            Name = 'Coca-Cola 600 ML PNR 12 B',
            Promocion_M__c = promocion,
            Producto_RICA_Lk__c = productoRICA,
            Cantidad_SKU_Pro__c = 1,
            Descuento_Pro__c = 14.46,
            UM_Descuento_Pro__c = '%'
        );
        INSERT skuPromo;	
        return skuPromo;
    }
    
    public static PRV_SKU_Promocion__c crearSKUPromoBonificado(String promocion, String productoRICA, String sku) {
        PRV_SKU_Promocion__c skuPromo = new PRV_SKU_Promocion__c(
            Name = 'Coca-Cola 600 ML PNR 12 B',
            Promocion_M__c = promocion,
            Producto_RICA_Lk__c = productoRICA,
            Cantidad_SKU_Pro__c = 1,
            Descuento_Pro__c = 14.46,
            SKU_Bonificacion_Lk__c = sku,
            Cantidad_Bonificada_Pro__c = 2,
            UM_Descuento_Pro__c = '%'
        );
        INSERT skuPromo;	
        return skuPromo;
    }
    

    public static ProductCatalog createCatalog(String name) {
        ProductCatalog catalogo = new ProductCatalog(
            Name = name
        );
        INSERT catalogo;
        return catalogo;
    }

    public static ProductCategory createCategory(String name , Id idCatalogo) {
        ProductCategory category = new ProductCategory(
            Name = name,
            CatalogId = idCatalogo
        );
        INSERT category;
        return category;
    }

    public static BuyerGroupMember crearMiembroBuyerGroup(Id buyerGroup , Id accountId) {
        BuyerGroupMember bgMember = new BuyerGroupMember(
            BuyerGroupId = buyerGroup,
            BuyerId = accountId
        );
        INSERT bgMember;
        return bgMember;
    }

    public static CommerceEntitlementBuyerGroup crearCommEntBuyGrp(Id buyerGroup , Id politica) {
        CommerceEntitlementBuyerGroup cebg = new CommerceEntitlementBuyerGroup(
            BuyerGroupId = buyerGroup,
            PolicyId = politica
        );
        INSERT cebg;
        return cebg;
    }

    public static ProductCategoryProduct crearProdCatProd(Id producto , Id categoria) {
        ProductCategoryProduct prodCatProd = new ProductCategoryProduct(
            ProductId = producto,
            ProductCategoryId = categoria,
            IsPrimaryCategory = true
        );
        INSERT prodCatProd;
        return prodCatProd;
    }

    public static CommerceEntitlementProduct crearCEProd(Id producto , Id politica) {
        CommerceEntitlementProduct ceProd = new CommerceEntitlementProduct(
            ProductId = producto,
            PolicyId = politica
        );
        INSERT ceProd;
        return ceProd;
    }

    public static WebStore creaEstablecimiento(){
        WebStore est = new WebStore (
            Name = 'RICApp'
        );
        INSERT est;
        return est;
    }

    public static WebCart creaCarrito(String Account, String Store){
        WebCart cart = new WebCart (
            Name = 'Test Cart', 
            AccountId = Account, 
            WebStoreId = Store, 
            Status = 'Active'
        );
        INSERT cart;
        return cart;
    }

    public static WebCart actualizaCarritoCheckout(WebCart cart) {
        cart.Status = 'Checkout';
        UPDATE cart;
        return cart;
    }

    public static CartDeliveryGroup creaDgroup(String Cart){
        CartDeliveryGroup dg = new CartDeliveryGroup (
            Name = 'Cart Delivery Group',
            CartId = Cart,
            DesiredDeliveryDate = Datetime.valueOf('2024-06-27 00:33:45')
        );
        INSERT dg;
        return dg;
    }
    
    public static CartItem creaArtCarrito(String Carrito, String CartDG, String Producto2){
        CartItem artCarrito = new CartItem (
            Name = 'Coca-Cola 600 ML',
            CartId = Carrito,
            CartDeliveryGroupId = CartDG,
            Product2Id = Producto2,
            totalListPrice = 1085,
            totalAdjustmentAmount = 0
        );
        INSERT artCarrito;
        return artCarrito;
    }
    
    public static ElectronicMediaGroup createElectronicMediaGroup(String name) {
        ElectronicMediaGroup electronicMedia = new ElectronicMediaGroup(
            Name = name,
            DeveloperName = 'Desarrollador_Test',
            UsageType = 'Banner'
        );
        INSERT electronicMedia;
        return electronicMedia;
    }

    public static ProductCategoryMedia createProductCategoryMedia(Id categoryId,Id electronicMediaGroupId) {
        ProductCategoryMedia pcm = new ProductCategoryMedia(
            ProductCategoryId = categoryId,
            ElectronicMediaId = '20Y8D00000014i4UAA',
            ElectronicMediaGroupId = electronicMediaGroupId
        );
        INSERT pcm;
        return pcm;
    }
    
    public static PRV_Promocion__c creaPromocion(Id canal, Id zona, Id suc) {
        Date fin = Date.Today();
        fin = fin.addDays(10);
        PRV_Promocion__c prom = new PRV_Promocion__c(
            Nombre_de_Promocion__c = 'Paquete 6106 MAX 1 (15/04/2024-01/06/2024)',
            Maximo_por_Cliente__c = 10,
            Clave_SAP__c = '6106-48231',
            Canal_de_Distribucion_Lk__c = canal,
            Zona_de_Distribucion__c = zona,
            Sucursal_Lk__c = suc,
            Folio_RICA__c = '6106',
            Fecha_Inicio__c = Date.Today(),
            Fecha_fin__c = fin,
            Gr_Clientes_Maggy__c = '04'
        );
        INSERT prom;
        return prom;
    }
    
    public static Promociones_Cliente__c creaPromocionCte(Id promo, Id rutaC) {
        Promociones_Cliente__c promCte = new Promociones_Cliente__c(
            Name = '1111-003-1086514-PRM-0000013654',
            Promocion_lk__c = promo,
            Ruta_Cliente_lk__c	 = rutaC
        );
        INSERT promCte;
        return promCte;
    }
    
    public static Conexion__c creaConex (Id rutC){
        Conexion__c conex = new Conexion__c(
            Ruta_de_Cliente_Lk__c = rutC
        );
        INSERT conex;
        return conex;
    }
    
    public static Conexion__c creaConexRICAapp (Id rutC){
        Conexion__c conex = new Conexion__c(
            Ruta_de_Cliente_Lk__c = rutC,
            Fecha__c = Date.today(),
            Tipo_Conexion__c = '01'
        );
        INSERT conex;
        return conex;
    }

    public static REP_Operacion_de_Reparto__c creaOpDelDia (){
        REP_Operacion_de_Reparto__c opDia = new REP_Operacion_de_Reparto__c(
            Fecha_de_Operacion__c = Date.today()
        );
        INSERT opDia;
        return opDia;
    }

    public static Conexion__c creaConexTicket (Id rutC, Id opDia, Id suc){
        Conexion__c conex = new Conexion__c(
            Ruta_de_Cliente_Lk__c = rutC,
            Fecha__c = Date.today(),
            Tipo_Conexion__c = '01',
            Fecha_de_Entrega__c = Date.newInstance(2024, 12, 12),
            TELE_OperacionDia__c = opDia,
            TELE_SucursalReparto_lk__c  = suc

        );
        INSERT conex;
        return conex;
    }
    
    public static PRV_Pedido_RICA__c creaPed (Id cnx, Id rutC, Id promo){
        PRV_Pedido_RICA__c ped = new PRV_Pedido_RICA__c(
            Promocion_lk__c = promo,
            Ruta_Cliente_lk__c = rutC,
            Visita_M__c = cnx,
            Fecha_Preventa_SAP__c = Date.Today(),
            Tipo_de_Pedido_PList__c = 'ZTA3',
            Estatus_de_Pedido__c = 'Creado',
            Promociones_aplicadas__c = 3,
            Monto_Tot_Pedido__c = 500,
            Clase_de_Pedido__c = 'RAPP' 
            
        );
        INSERT ped;
        return ped;
    }

    public static PRV_Pedido_RICA__c creaPedPromo (Id cnx, Id rutC, Id promo){
        PRV_Pedido_RICA__c ped = new PRV_Pedido_RICA__c(
            Promocion_lk__c = promo,
            Ruta_Cliente_lk__c = rutC,
            Visita_M__c = cnx,
            Fecha_Preventa_SAP__c = Date.Today(),
            Tipo_de_Pedido_PList__c = 'ZTA3',
            Estatus_de_Pedido__c = 'Creado',
            Promociones_aplicadas__c = 3,
            Monto_Tot_Pedido__c = 500
            
        );
        INSERT ped;
        return ped;
    }

    public static PRV_Mezcla__c crearMezcla (Id canal){
        PRV_Mezcla__c mezcla = new PRV_Mezcla__c(
            //Name = '',
            Nombre_de_Mezcla__c = 'Mezcla TEST',
            //RecordTypeId = '',
            Canal_de_Distribucion_Lk__c = canal,
            Clave_SAP__c = '9999-9999',
            Folio_RICA__c = '9999',
            Descripcion_de_la_Mezcla__c = 'Sabores 1.5 Retornable BU',
            Fecha_Inicio__c = Date.newInstance(2024, 01, 01),
            Fecha_Fin__c = Date.newInstance(4000, 01, 01),
            Fecha_fin_de_Liquidacion__c = Date.newInstance(4000, 01, 02),
            Maximo_por_Cliente__c = 8,
            Maximo_por_Mezcla__c = 12,
            Programas_manejantes__c = '04'
        );
        INSERT mezcla;
        return mezcla;
    }

    public static PRV_Mezcla__c crearMezclaBatch (Id canal, String claveSap, String folio, Date fechaInicio, Date fechaFin){
        PRV_Mezcla__c mezcla = new PRV_Mezcla__c(
            Nombre_de_Mezcla__c = 'Mezcla TEST',
            Canal_de_Distribucion_Lk__c = canal,
            Clave_SAP__c = claveSap,
            Folio_RICA__c = folio,
            Descripcion_de_la_Mezcla__c = 'Sabores 1.5 Retornable BU',
            Fecha_Inicio__c = fechaInicio,
            Fecha_Fin__c = fechaFin,
            Fecha_fin_de_Liquidacion__c = Date.newInstance(4000, 01, 02),
            Maximo_por_Cliente__c = 8,
            Maximo_por_Mezcla__c = 12,
            Programas_manejantes__c = '04'
        );
        INSERT mezcla;
        return mezcla;
    }

    public static PRV_Mezcla__c crearMezclaPrev (Id canal){
        PRV_Mezcla__c mezcla = new PRV_Mezcla__c(
            //Name = '',
            Nombre_de_Mezcla__c = 'Mezcla TEST',
            //RecordTypeId = '',
            Canal_de_Distribucion_Lk__c = canal,
            Clave_SAP__c = '0001-0001',
            Folio_RICA__c = '9999',
            Descripcion_de_la_Mezcla__c = 'Sabores 1.5 Retornable BU',
            Fecha_Inicio__c = Date.newInstance(2024, 01, 01),
            Fecha_Fin__c = Date.newInstance(4000, 01, 01),
            Fecha_fin_de_Liquidacion__c = Date.newInstance(4000, 01, 02),
            Maximo_por_Cliente__c = 8,
            Maximo_por_Mezcla__c = 12,
            Programas_manejantes__c = '04'
        );
        INSERT mezcla;
        return mezcla;
    }
    
    public static Product2 crearProduct2Mezcla(String canal) {
        
        Id recordTypeIdMezcla = Schema.SObjectType.Product2.getRecordTypeInfosByName().get('Mezcla').getRecordTypeId();
        System.debug('recordTypeIdMezcla' + recordTypeIdMezcla);
        
        Product2 productoRICApp = new Product2(
            StockKeepingUnit = '9999-9999',
            ProductCode = '9999-9999',
            Name = 'Mezcla Prueba',
            rca_Canal_de_Distribuci_n__c = canal,
            RecordTypeId = recordTypeIdMezcla,
            IsActive = TRUE
        );
        INSERT productoRICApp;	
        return productoRICApp;
    }

    public static SKU_Mezcla__c crearSKUMezcla(String mezcla, String productoRICA) {
        SKU_Mezcla__c skuMezcla = new SKU_Mezcla__c(
            Name = 'Coca-Cola 600 ML PNR 12 B',
            Mezcla_Lk__c = mezcla,
            Producto_RICA_Lk__c = productoRICA,
            Minimo__c = 1,
            Maximo__c = 5
        );
        INSERT skuMezcla;	
        return skuMezcla;
    }
    

    public static ConnectApi.ManagedContentChannelCollection getTestManagedContentChannelCollection() {
        ConnectApi.ManagedContentChannelCollection testChannelCollection = new ConnectApi.ManagedContentChannelCollection();
        testChannelCollection.channels = new List<ConnectApi.ManagedContentChannel>();
    
        ConnectApi.ManagedContentChannel channel1 = new ConnectApi.ManagedContentChannel();
        channel1.cacheControlMaxAge = 3600;
        channel1.channelId = '0ap740000004CEcAAM';
        channel1.channelName = 'RICApp';
        channel1.isChannelSearchable = true;
        channel1.isDomainLocked = true;
        channel1.mediaCacheControlMaxAge = 2592000;
    
        ConnectApi.ManagedContentChannel channel2 = new ConnectApi.ManagedContentChannel();
        channel2.cacheControlMaxAge = 3600;
        channel2.channelId = '0ap740000004CEdAAM';
        channel2.channelName = 'RICApp Channel';
        channel2.domain = 'CMS';
        channel2.domainName = 'rica--DEVPROCC05.sandbox.cdn.salesforce-experience.com';
        channel2.isChannelSearchable = false;
        channel2.isDomainLocked = false;
        channel2.mediaCacheControlMaxAge = 2592000;
    
        testChannelCollection.channels.add(channel1);
        testChannelCollection.channels.add(channel2);
    
        testChannelCollection.currentPageUrl = '/services/data/v59.0/connect/cms/delivery/channels?page=0&pageSize=2';
        testChannelCollection.totalChannels = 2;

    
        return testChannelCollection;
    }

    public static ConnectApi.ManagedContentCollectionItems getCollectionBanners() {
        ConnectApi.ManagedContentCollectionItems collection = new ConnectApi.ManagedContentCollectionItems();
        collection.items = new List<ConnectApi.ManagedContentCollectionItem>();
        
        for (Integer i = 1; i <= 5; i++) {
            ConnectApi.ManagedContentCollectionItem item = new ConnectApi.ManagedContentCollectionItem();
            item.id = '20Y8D00000014egUA' + i;
            item.name = 'banner_' + i + ' - 2024/05/31';
            
            Map<String, Object> bodyMap = new Map<String, Object>();
            bodyMap.put('contentKey', 'MCKey_' + i);
            
            Map<String, Object> contentBodyMap = new Map<String, Object>();
            contentBodyMap.put('altText', 'Alt text for banner ' + i);
            
            bodyMap.put('contentBody', contentBodyMap);
            
            item.body = bodyMap;
            
            ConnectApi.ManagedContentCollectionItemTypeSummary contentType = new ConnectApi.ManagedContentCollectionItemTypeSummary();
            contentType.fullyQualifiedName = 'sfdc_cms__image';
            contentType.name = 'sfdc_cms__image';
            
            item.contentType = contentType;
            
            collection.items.add(item);
        }
        
        return collection;
    }

    public static ConnectApi.ProductSearchResults getTestProductSearchResults() {
        // Crear los objetos de ProductCategoryData
        ConnectApi.ProductCategoryData categoryDataMarcas = new ConnectApi.ProductCategoryData();
        categoryDataMarcas.id = '0ZG8D000000CqWoWAK';
        categoryDataMarcas.name = 'Marcas';

        ConnectApi.ProductCategoryData categoryDataCocaCola = new ConnectApi.ProductCategoryData();
        categoryDataCocaCola.id = '0ZG8D000000CqWtWAK';
        categoryDataCocaCola.name = 'Coca Cola';

        ConnectApi.ProductCategoryData categoryDataFanta = new ConnectApi.ProductCategoryData();
        categoryDataFanta.id = '0ZG8D000000CqWuWAK';
        categoryDataFanta.name = 'Fanta';

        ConnectApi.ProductCategoryData categoryDataSprite = new ConnectApi.ProductCategoryData();
        categoryDataSprite.id = '0ZG8D000000CqWzWAK';
        categoryDataSprite.name = 'Sprite';

        // Crear los objetos de SearchCategory
        ConnectApi.SearchCategory searchCategoryCocaCola = new ConnectApi.SearchCategory();
        searchCategoryCocaCola.category = categoryDataCocaCola;
        searchCategoryCocaCola.children = new List<ConnectApi.SearchCategory>();
        searchCategoryCocaCola.productCount = 1;

        ConnectApi.SearchCategory searchCategoryFanta = new ConnectApi.SearchCategory();
        searchCategoryFanta.category = categoryDataFanta;
        searchCategoryFanta.children = new List<ConnectApi.SearchCategory>();
        searchCategoryFanta.productCount = 1;

        ConnectApi.SearchCategory searchCategorySprite = new ConnectApi.SearchCategory();
        searchCategorySprite.category = categoryDataSprite;
        searchCategorySprite.children = new List<ConnectApi.SearchCategory>();
        searchCategorySprite.productCount = 1;

        List<ConnectApi.SearchCategory> childrenCategories = new List<ConnectApi.SearchCategory>{searchCategoryCocaCola, searchCategoryFanta, searchCategorySprite};

        ConnectApi.SearchCategory searchCategoryMarcas = new ConnectApi.SearchCategory();
        searchCategoryMarcas.category = categoryDataMarcas;
        searchCategoryMarcas.children = childrenCategories;
        searchCategoryMarcas.productCount = 3;

        // Crear el objeto ProductSummary
        ConnectApi.ProductMedia productMedia = new ConnectApi.ProductMedia();
        productMedia.alternateText = '';
        productMedia.sortOrder = 0;
        productMedia.title = 'image';
        productMedia.url = '/img/b2b/default-product-image.svg';

        ConnectApi.ProductSummary productSummarySprite = new ConnectApi.ProductSummary();
        productSummarySprite.defaultImage = productMedia;
        productSummarySprite.fields = new Map<String, ConnectApi.FieldValue>{};
        productSummarySprite.id = '01t8D000004qkJGQAY';
        productSummarySprite.name = 'Sprite 500 ML VR 24 B';

        ConnectApi.ProductSummary productSummaryCocaCola = new ConnectApi.ProductSummary();
        productSummaryCocaCola.defaultImage = productMedia;
        productSummaryCocaCola.fields = new Map<String, ConnectApi.FieldValue>{};
        productSummaryCocaCola.id = '01t8D000004qkJLQAY';
        productSummaryCocaCola.name = 'Coca-Cola 355 ML VR 24 B';

        ConnectApi.ProductSummary productSummaryFanta = new ConnectApi.ProductSummary();
        productSummaryFanta.defaultImage = productMedia;
        productSummaryFanta.fields = new Map<String, ConnectApi.FieldValue>{};
        productSummaryFanta.id = '01t8D000004qkHpQAI';
        productSummaryFanta.name = 'Fanta Naranja 500 ML VR 24 B';

        List<ConnectApi.ProductSummary> productSummaries = new List<ConnectApi.ProductSummary>{productSummarySprite, productSummaryCocaCola, productSummaryFanta};

        ConnectApi.ProductSummaryPage productSummaryPage = new ConnectApi.ProductSummaryPage();
        productSummaryPage.pageSize = 20;
        productSummaryPage.products = productSummaries;
        productSummaryPage.total = 3;

        // Crear el objeto final de ProductSearchResults
        ConnectApi.ProductSearchResults productSearchResults = new ConnectApi.ProductSearchResults();
        productSearchResults.categories = searchCategoryMarcas;
        productSearchResults.correlationId = 'cf1a392fe987df0b';
        productSearchResults.facets = new List<ConnectApi.SearchFacet>();
        productSearchResults.locale = 'es_MX';
        productSearchResults.productsPage = productSummaryPage;

        // Devuelve el objeto
        return productSearchResults;
    }

    public static ConnectApi.ManagedContentDeliveryDocumentCollection getTestCollection(){
        ConnectApi.ManagedContentChannelSummary channelInfo = new ConnectApi.ManagedContentChannelSummary();
        channelInfo.domainUrl = 'https://rica--devprocc05.sandbox.my.site.com/RICAppvforcesite';
        channelInfo.name = 'RICApp';
        channelInfo.resourceUrl = '/services/data/v59.0/connect/cms/delivery/channels/0ap740000004CEcAAM';
        channelInfo.target = null;

        List<ConnectApi.ManagedContentDeliveryDocument> contents = new List<ConnectApi.ManagedContentDeliveryDocument>();

        ConnectApi.ManagedContentDeliveryDocument content1 = new ConnectApi.ManagedContentDeliveryDocument();
        content1.channelInfo = null;
        content1.contentBody = new Map<String, Object>{ 'altText' => 'https://es.wikipedia.org/wiki/Coca-Cola', 'sfdc_cms:media' => 'core.connect.apex.ApexMapWrapper@6a19097' };
        content1.contentKey = 'MCEQJAJHCCVFHTBHY565MNWDEZKI';
        content1.language = 'es_MX';
        content1.managedContentId = '20Y8D00000014i4UAA';
        content1.resourceUrl = '/services/data/v59.0/connect/cms/delivery/channels/0ap740000004CEcAAM/contents/MCEQJAJHCCVFHTBHY565MNWDEZKI';
        content1.title = 'Coca Cola';
        content1.unauthenticatedUrl = null;
        content1.urlName = 'coca-cola';

        contents.add(content1);

        // Repite el proceso para content2 y content3

        ConnectApi.ManagedContentDeliveryDocument content2 = new ConnectApi.ManagedContentDeliveryDocument();
        content2.channelInfo = null;
        content2.contentBody = new Map<String, Object>{ 'sfdc_cms:media' => 'core.connect.apex.ApexMapWrapper@5e0b2b49' };
        content2.contentKey = 'MCDEYOLTJDRVFCDGFBLMCUCPCXEU';
        content2.language = 'es_MX';
        content2.managedContentId = '20Y8D00000014hWUAQ';
        content2.resourceUrl = '/services/data/v59.0/connect/cms/delivery/channels/0ap740000004CEcAAM/contents/MCDEYOLTJDRVFCDGFBLMCUCPCXEU';
        content2.title = 'Fanta';
        content2.unauthenticatedUrl = null;
        content2.urlName = 'fanta';

        contents.add(content2);

        ConnectApi.ManagedContentDeliveryDocument content3 = new ConnectApi.ManagedContentDeliveryDocument();
        content3.channelInfo = null;
        content3.contentBody = new Map<String, Object>{ 'sfdc_cms:media' => 'core.connect.apex.ApexMapWrapper@154e6bc0' };
        content3.contentKey = 'MCOJOZRX4HYRDI3ICVOVBK2P7LGA';
        content3.language = 'es_MX';
        content3.managedContentId = '20Y8D00000014iUUAQ';
        content3.resourceUrl = '/services/data/v59.0/connect/cms/delivery/channels/0ap740000004CEcAAM/contents/MCOJOZRX4HYRDI3ICVOVBK2P7LGA';
        content3.title = 'Sprite';
        content3.unauthenticatedUrl = null;
        content3.urlName = 'sprite';

        contents.add(content3);

        ConnectApi.ManagedContentDeliveryDocumentCollection collection = new ConnectApi.ManagedContentDeliveryDocumentCollection();
        collection.channelInfo = channelInfo;
        collection.contents = contents;
        collection.currentPageUrl = '/services/data/v59.0/connect/cms/delivery/channels/0ap740000004CEcAAM/contents?managedContentIds=20Y8D00000014i4%2C20Y8D00000014hW%2C20Y8D00000014iU&contentTypeFQN=sfdc_cms__image&referenceDepth=3&expandReferences=true&includeContentBody=true&page=0&pageSize=3';
        collection.nextPageUrl = '/services/data/v59.0/connect/cms/delivery/channels/0ap740000004CEcAAM/contents?managedContentIds=20Y8D00000014i4%2C20Y8D00000014hW%2C20Y8D00000014iU&contentTypeFQN=sfdc_cms__image&referenceDepth=3&expandReferences=true&includeContentBody=true&page=1&pageSize=3';
        collection.previousPageUrl = null;

        return collection;
    }

    public static ConnectApi.ProductDetail getTestProductDetail() {
        ConnectApi.ProductDetail productDetail = new ConnectApi.ProductDetail();
    
        // Definir defaultImage
        ConnectApi.ProductMedia defaultImage = new ConnectApi.ProductMedia();
        defaultImage.id = '2pm8C0000008fceQAA';
        defaultImage.title = 'Fanta 600ml';
        defaultImage.url = '/cms/delivery/media/MCGRBOIO2WJZBILBTX626U6QH4YE?version=1.1&channelId=0ap740000004CEd&oid=00D8C0000000Mmd';
    
        // Definir fields
        Map<String, String> fields = new Map<String, String>{
            'Description' => 'Prueba',
            'Name' => 'Fanta prueba',
            'StockKeepingUnit' => '899999'
        };
    
        // Definir mediaGroups
        List<ConnectApi.ProductMedia> mediaItems = new List<ConnectApi.ProductMedia>{
            defaultImage
        };
    
        ConnectApi.ProductMediaGroup productListImage = new ConnectApi.ProductMediaGroup();
        productListImage.developerName = 'productListImage';
        productListImage.id = '2mg8Y000000awQVQAY';
        productListImage.mediaItems = mediaItems;
        productListImage.name = 'Imagen de lista del producto';
    
        ConnectApi.ProductMediaGroup productDetailImage = new ConnectApi.ProductMediaGroup();
        productDetailImage.developerName = 'productDetailImage';
        productDetailImage.id = '2mg8Y000000awQUQAY';
        productDetailImage.mediaItems = mediaItems;
        productDetailImage.name = 'Imágenes de detalles del producto';
    
        // Asignar valores a productDetail
        productDetail.defaultImage = defaultImage;
        productDetail.fields = fields;
        productDetail.id = '01t8C000002Ey3SQAS';
        productDetail.mediaGroups = new List<ConnectApi.ProductMediaGroup>{
            productListImage,
            productDetailImage
        };

    	return productDetail;
	}
    
	public static ConnectApi.PricingResult getTestPricingResult() {
        ConnectApi.PricingResult pricingResult = new ConnectApi.PricingResult();
    
        // Definir error
        ConnectApi.ErrorResponse errorResponse = new ConnectApi.ErrorResponse();
        errorResponse.errorCode = null;
        errorResponse.message = null;
    
        // Definir pricingLineItemResults
        ConnectApi.PricingResultLineItem lineItem1 = new ConnectApi.PricingResultLineItem();
        lineItem1.error = errorResponse;
        lineItem1.listPrice = '120';
        lineItem1.lowestUnitPrice = null;
        lineItem1.pricebookEntryId = '01u8C0000090OfhQAE';
        lineItem1.productId = '01t8C000002Ey3SQAS';
        lineItem1.success = true;
        lineItem1.unitPrice = '100';
    
        ConnectApi.PricingResultLineItem lineItem2 = new ConnectApi.PricingResultLineItem();
        lineItem2.error = errorResponse;
        lineItem2.listPrice = '90';
        lineItem2.lowestUnitPrice = null;
        lineItem2.pricebookEntryId = '01u8C0000090OfdQAE';
        lineItem2.productId = '01t8C000002Ey3NQAS';
        lineItem2.success = true;
        lineItem2.unitPrice = '70';
    
        // Asignar valores a pricingResult
        pricingResult.currencyIsoCode = 'MXN';
        pricingResult.error = errorResponse;
        pricingResult.pricingLineItemResults = new List<ConnectApi.PricingResultLineItem>{
            lineItem1,
            lineItem2
        };
        pricingResult.success = true;
        return pricingResult;
    }
    
    public static rca_ProductoPromocionCarrito__c crearProductoPromocionCarrito (String productoCarritoId, String productoRicaId ){
        rca_ProductoPromocionCarrito__c productoPromocionCarrito = new rca_ProductoPromocionCarrito__c(
            rca_ProductoCarrito__c = productoCarritoId ,
			rca_ProductoRica__c = productoRicaId ,
            rca_TipoProducto__c = 'Estandar',
			rca_Cantidad__c = 3 
        );
        Insert productoPromocionCarrito;
        return productoPromocionCarrito;
    }
    
    public static rca_ProductoPromocionCarrito__c crearProductoPromocionCarritoBonificacion (String productoCarritoId, String productoRicaId ){
        rca_ProductoPromocionCarrito__c productoPromocionCarrito = new rca_ProductoPromocionCarrito__c(
            rca_ProductoCarrito__c = productoCarritoId ,
			rca_ProductoRica__c = productoRicaId ,
            rca_TipoProducto__c = 'Bonificacion',
			rca_Cantidad__c = 3 
        );
        Insert productoPromocionCarrito;
        return productoPromocionCarrito;
    }
    
    public static ConnectApi.ProductOverviewCollection getMockProductOverviewCollection() {
        ConnectApi.ProductOverviewCollection productOverviewCollection = new ConnectApi.ProductOverviewCollection();
        
        // Lista de productos
        List<ConnectApi.ProductOverview> productList = new List<ConnectApi.ProductOverview>();
        
        // Primer producto
        ConnectApi.ProductOverview product1 = new ConnectApi.ProductOverview();
        product1.id = '01t8C000002EzAaQAK';
        product1.sku = '9999-48087';
        product1.success = true;
        
        ConnectApi.ProductMedia media1 = new ConnectApi.ProductMedia();
        media1.id = '2pm8C0000008fe6QAA';
        media1.mediaType = ConnectApi.ProductMediaType.Image;
        media1.title = 'Delaware';
        media1.url = '/cms/delivery/media/MC2UQS5L5WDRFBBM5GXF7I74GT2I?version=1.1&channelId=0ap740000004CEd&oid=00D8C0000000Mmd';
        product1.defaultImage = media1;
        
        Map<String, String> fields1 = new Map<String, String>();
        fields1.put('Description', '1 TRIPLE CHOCO+ 1 UHT SAB OBS 2 CP 600');
        fields1.put('StockKeepingUnit', '9999-48087');
        product1.fields = fields1;
        
        productList.add(product1);
        
        // Segundo producto
        ConnectApi.ProductOverview product2 = new ConnectApi.ProductOverview();
        product2.id = '01t8C000002F5ZrQAK';
        product2.sku = '9999-48087';
        product2.success = true;
        
        ConnectApi.ProductMedia media2 = new ConnectApi.ProductMedia();
        media2.id = '2pm8C0000008fdrQAA';
        media2.mediaType = ConnectApi.ProductMediaType.Image;
        media2.title = 'CocaCola600ML';
        media2.url = '/cms/delivery/media/MCXTTFTYU6PNB53FNANOU2Z5EVQE?version=1.1&channelId=0ap740000004CEd&oid=00D8C0000000Mmd';
        product2.defaultImage = media2;
        
        Map<String, String> fields2 = new Map<String, String>();
        fields2.put('Description', 'MIS ANTOJOS');
        fields2.put('StockKeepingUnit', '6107-48235');
        product2.fields = fields2;
        
        productList.add(product2);

        // Asignar la lista de productos al objeto de respuesta
        productOverviewCollection.products = productList;
        productOverviewCollection.total = productList.size();
        
        return productOverviewCollection;
    }

    public static ConnectApi.ProductOverviewCollection getMockProductOverviewCollectionMezcla() {
        ConnectApi.ProductOverviewCollection productOverviewCollection = new ConnectApi.ProductOverviewCollection();
        
        // Lista de productos
        List<ConnectApi.ProductOverview> productList = new List<ConnectApi.ProductOverview>();
    
        // Tercer producto
        ConnectApi.ProductOverview product3 = new ConnectApi.ProductOverview();
        product3.id = '01t8C000002EzAaQAK';
        product3.sku = '9999-9999';
        product3.success = true;
        
        ConnectApi.ProductMedia media3 = new ConnectApi.ProductMedia();
        media3.id = '2pm8C0000008fe6QAA';
        media3.mediaType = ConnectApi.ProductMediaType.Image;
        media3.title = 'Delaware';
        media3.url = '/cms/delivery/media/MC2UQS5L5WDRFBBM5GXF7I74GT2I?version=1.1&channelId=0ap740000004CEd&oid=00D8C0000000Mmd';
        product3.defaultImage = media3;
        
        Map<String, String> fields3 = new Map<String, String>();
        fields3.put('Description', 'Sabores 1.5 Retornable BU');
        fields3.put('StockKeepingUnit', '9999-9999');
        product3.fields = fields3;

        productList.add(product3);

        
        // Asignar la lista de productos al objeto de respuesta
        productOverviewCollection.products = productList;
        productOverviewCollection.total = productList.size();
        
        return productOverviewCollection;
    }
    
    public static PRV_Pedido_RICA__c crearPedidoRica(Id clienteId, Id conexionId){
        PRV_Pedido_RICA__c pedidoTest = new PRV_Pedido_RICA__c(
            Nombre_del_Cliente__c = clienteId,
            Estatus_de_Pedido__c = 'Creado',
            Visita_M__c = conexionId,
            Fecha_de_Entrega__c = Date.today().addDays(7),
            Fecha_hora_de_creacion__c = Date.today()
        );
        INSERT pedidoTest;
        return pedidoTest;
    }
    
    public static PRV_Pedido_RICA__c crearPedidoRicaAgrupador(Id clienteId, Id conexionId,Id rutaClienteId){
        PRV_Pedido_RICA__c pedidoTest = new PRV_Pedido_RICA__c(
            Nombre_del_Cliente__c = clienteId,
            Estatus_de_Pedido__c = 'Creado',
            Visita_M__c = conexionId,
            Fecha_de_Entrega__c = Date.today().addDays(7),
            Fecha_hora_de_creacion__c = Date.today(),
            Id_App__c = 'R1-000001',
            Ruta_Cliente_lk__c = rutaClienteId
        );
        INSERT pedidoTest;
        return pedidoTest;
    }
    
    public static PRV_Prod_Pedido__c crearProductoPedido (Id pedidoId, Id productoId){
        PRV_Prod_Pedido__c producto = new PRV_Prod_Pedido__c (
            Pedido_M__c= pedidoId,
            cantidad__c= 10,
            Producto_RICA_Lk__c= productoId,
            Name = '899999',
            Precio__c = 0,
            Total_SAP__c = 0,
            Iva__c = 0,
            UM__c = 'BOT',
            Tipo_origen__c = 'Portafolio',
            Tipo_de_Posicion__c = 'PAG',
            Monto_de_descuento__c = 0,
            Monto_de_Bonificacion__c = 0
        );
        INSERT producto;
        return producto;
    }

    public static AlternativePaymentMethod crearPagoAlternativo(){
        
        AlternativePaymentMethod pago = new AlternativePaymentMethod (
        	Status = 'Active',
            ProcessingMode = 'External'
        );
        INSERT pago;
        return pago;
    }
    
    public static WebCart crearCarritoConPago(String idTienda, String idCliente, String idPago){
        WebCart carrito = new WebCart(
        	Name = 'Carrito Prueba',
            WebStoreId = idTienda,
            AccountId = idCliente,
            PaymentMethodId = idPago,
            PoNumber='1234567'
        );
        INSERT carrito;
        return carrito;
    }
    
    public static Order crearOrden (String idCuenta){
        Order pedido = new Order(
			Status = 'Draft',
            AccountId = idCuenta,
            EffectiveDate = System.Today(),
            PoNumber='1234567'
        );  
        INSERT pedido;
        return pedido;
    }
    
    public static OrderDeliveryGroup crearOrderDeliveryGroup (String idPedido, String nombre){
        OrderDeliveryGroup grupoEntrega = new OrderDeliveryGroup(
			OrderId = idPedido,
            DeliverToName = nombre
        );  
        INSERT grupoEntrega;
        return grupoEntrega;
    }
    
    public static ProcessException crearExcepcion(String idCarrito){
        ProcessException excepcion = new ProcessException(
        	AttachedToId = idCarrito,
            Status = 'Nuevo',
            Message = 'ERROR'
        );
        INSERT excepcion;
        return excepcion;
    }

    public static PRV_Pedido_RICA__c crearPedidoRicaSinAgrupador(Id clienteId, Id conexionId,Id rutaClienteId){
        PRV_Pedido_RICA__c pedidoTest = new PRV_Pedido_RICA__c(
            Nombre_del_Cliente__c = clienteId,
            Estatus_de_Pedido__c = 'Creado',
            Visita_M__c = conexionId,
            Fecha_de_Entrega__c = Date.today().addDays(7),
            Fecha_hora_de_creacion__c = Date.today(),
            Ruta_Cliente_lk__c = rutaClienteId
        );
        INSERT pedidoTest;
        return pedidoTest;
    }
    
    public static PRV_Pedido_RICA__c crearPedidoRicaPromocion(Id clienteId, Id conexionId,Id rutaClienteId, Id promocionId){
        PRV_Pedido_RICA__c pedidoTest = new PRV_Pedido_RICA__c(
            Nombre_del_Cliente__c = clienteId,
            Estatus_de_Pedido__c = 'Creado',
            Visita_M__c = conexionId,
            Fecha_de_Entrega__c = Date.today().addDays(7),
            Fecha_hora_de_creacion__c = Date.today(),
            Id_App__c = 'R1-000001',
            Ruta_Cliente_lk__c = rutaClienteId,
            Promocion_lk__c = promocionId
        );
        INSERT pedidoTest;
        return pedidoTest;
    }

    public static Producto_RICA__c crearProductoRicaCamposLlenos(String codigoProducto,Id idEnvaseRetornable,Id idCategoria,Id idMarca){
        Producto_RICA__c productoRica= new Producto_RICA__c();
        productoRica.Name=codigoProducto;
        productoRica.Codigo_de_Producto__c=codigoProducto;
       	productoRica.Descripcion_de_Producto__c='test';
         if(idEnvaseRetornable!=null || idEnvaseRetornable!=''){
        	productoRica.Producto_RICA_Embalaje_Lk__c=idEnvaseRetornable; 
            productoRica.Envase__c=idEnvaseRetornable;
            productoRica.Retornabilidad__c='R1';
        }
        productoRICA.Nombre_del_Material__c = 'Producto Test';
        productoRICA.Activo__c = true;
        productoRICA.Tamanio__c = 'T1';
        productoRICA.Catalogo_de_Presentaciones_picklist__c = 'F4';
        productoRICA.Factor_de_Conversion_Botella__c = 1;
        productoRICA.Nivel1_Categoria_Lk__c = idCategoria;
        productoRICA.Nivel_2_Marca_Lk__c = idMarca;
       
        
        insert productoRica;
        return productoRica;
    }
    
    public static Categoria__c crearCategoria(String nombreCategoria, String jerarquia){
        Categoria__c categoriaTest = new Categoria__c(
        	Name = nombreCategoria,
            Jerarquia__c = jerarquia,
            Descripcion__c = nombreCategoria,
            Tipo__c = '01',
            Categoria_2__c = 'Colas'
        );
        insert categoriaTest;
        return categoriaTest;
    }
    
    public static ProductCategory crearCategoriaCommerce (String nombre ,String idCatalogo){
        ProductCategory categoriaTest = new ProductCategory (
        	Name = nombre,
            CatalogId = idCatalogo
        );
        insert categoriaTest;
        return categoriaTest;
    }

    public static CommerceEntitlementPolicy crearPoliticaAsignacion(String name){
        CommerceEntitlementPolicy pAsignacion = new CommerceEntitlementPolicy(
        	IsActive = true,
            Name = name,
            CanViewPrice = true,
            CanViewProduct = true
        );
        INSERT pAsignacion;
        return pAsignacion;
    }

    public static PRV_Mezcla__c crearMezclaTomorrow (Id canal){
        PRV_Mezcla__c mezcla = new PRV_Mezcla__c(
            Nombre_de_Mezcla__c = 'Mezcla TEST',
            Canal_de_Distribucion_Lk__c = canal,
            Clave_SAP__c = '9999-9999',
            Folio_RICA__c = '9999',
            Descripcion_de_la_Mezcla__c = 'Sabores 1.5 Retornable BU',
            Fecha_Inicio__c = Date.newInstance(2025, 12, 12),
            Fecha_Fin__c = Date.newInstance(4000, 01, 01),
            Fecha_fin_de_Liquidacion__c = Date.newInstance(4000, 01, 02),
            Maximo_por_Cliente__c = 8,
            Maximo_por_Mezcla__c = 12,
            Programas_manejantes__c = '04'
        );
        INSERT mezcla;
        return mezcla;
    }

    public static ContactPointAddress crearPuntoEntrega(Id accountId){
        ContactPointAddress puntoEntregaTest = new ContactPointAddress (
        	ParentId = accountId,
            Name = 'Home',
            IsDefault = true,
            AddressType = 'Envío'
        );
        insert puntoEntregaTest;
        return puntoEntregaTest;
    }
    
    public static PRV_Prod_de_Portafolio__c crearProdPortafolioMarcas(Id portafolioId, String productoRICA, String Sku) {
        PRV_Prod_de_Portafolio__c prodPortafolio = new PRV_Prod_de_Portafolio__c(
            ID_Portafolio__c = portafolioId,
            Name_Unico__c = '502-1115198-'+Sku,
            Name = Sku,
            Precio_de_Venta__c = 252.00,
            Fecha_de_Fin__c = Date.newInstance(2024, 01, 01),
            Precio_de_Venta_2__c = 252.00,
            Fecha_de_Fin_2__c = Date.newInstance(4000, 01, 01),
            Monto_Iva__c = 34.76,
            IEPS__c = 13.41,
            Monto_Iva_2__c = 34.76,
            IEPS_2__c = 13.41,
            Producto_RICA_M__c = productoRICA,
            Activo__c = TRUE,
            UM__c = 'BOT',
            IVA_2__c = 34.76, 
            IVA__c = 34.76,
            NoVentaIndividual__c=False,
            Fin_Vigencia__c = Date.newInstance(2029, 01, 01),
            Inicio_Vigencia__c = Date.newInstance(2020, 01, 01)
        );
        INSERT prodPortafolio;	
        return prodPortafolio;
    }
    
    public static ProductCategory crearChildCategory (String nombre ,String idCatalogo, String idCategoriaPadre){
        ProductCategory categoriaTest = new ProductCategory (
        	Name = nombre,
            CatalogId = idCatalogo,
            ParentCategoryId = idCategoriaPadre,
            SortOrder = 1
        );
        insert categoriaTest;
        return categoriaTest;
    }
    
    public static BuyerGroup crearBuyerGroup(){
        BuyerGroup b = new BuyerGroup(
        	Name='BG Test'
        );
        insert b;
        return b;
    }
    
    public static BuyerGroupMember crearBuyerGroupMember(String BuyerGroupId, String idCliente){
        BuyerGroupMember b = new BuyerGroupMember(
        	BuyerGroupId=BuyerGroupId,
            BuyerId = idCliente
        );
        insert b;
        return b;
    }
    
    public static BuyerAccount crearBuyerAccount(Account acc){
        BuyerAccount accB=new BuyerAccount(
            BuyerId = acc.Id,
            BuyerStatus = 'Activo',
            CommerceType = 'Comprador',
            IsActive = True,
            Name = acc.Name,
            PayerId = acc.Id,
            SendToId = acc.Id
        );
        insert accB;
        return accB;
    }
    
    public static WebStore creaEstablecimiento2(String nombre){
        WebStore est = new WebStore (
            Name = nombre
        );
        INSERT est;
        return est;
    }
    
    public static Caso_RICA__c crearCasoRICA(Id idUsuario){
        Caso_RICA__c c = new Caso_RICA__c (
            Cuenta_Lk__c = idUsuario
        );
        INSERT c;
        return c;
    }
    
    public static PRV_Pedido_Sugerido__c crearPedidoSugerido(Id idUsuario,Id idRuta){
        PRV_Pedido_Sugerido__c p = new PRV_Pedido_Sugerido__c (
            Cliente_lk__c = idUsuario,
            Ruta_de_Cliente_M__c = idRuta
        );
        INSERT p;
        return p;
    }
    
    public static Coberturas_Cliente__c crearCobertura (Id idUsuario, Id idCoberturaRica){
        Coberturas_Cliente__c c = new Coberturas_Cliente__c(
            Cliente__c = idUsuario,
            Coberturas_RICA__c = idCoberturaRica
        );
        Insert c;
        return c;
    }
    
    public static PRV_Evaluacion_ICE__c crearEvaluacion (Id idUsuario){
        PRV_Evaluacion_ICE__c e = new PRV_Evaluacion_ICE__c(
            Cuenta_Lk__c = idUsuario
        );
        Insert e;
        return e;
    }
    
    public static Coberturas_RICA__c crearCobertura (Id categoriaId){
        Coberturas_RICA__c cR = new Coberturas_RICA__c (
            Name = 'Cobertura RICA Test',
            Cant_Mini__c = 10,
            Cant_Chico__c = 10, 
            Cant_Mediano__c = 10, 
            Cant_Grande__c = 10, 
            C1_Marca_Nivel2_Lk__c = categoriaId, 
            C1_Sub_Marca_Nivel3_Lk__c = categoriaId
        );
        Insert cR;
        return cR;
    }
    
    public static Conexion__c creaConexTeleventa (Id idCliente,Id tipoRegistro){
        Conexion__c conex = new Conexion__c(
            Cuenta_Lk__c = idCliente,
            Fecha__c = Date.today(),
            Tipo_Conexion__c = '01',
            Fecha_de_Entrega__c = Date.newInstance(2024, 12, 12),
            Fecha_Hora_In__c = null,
            Fecha_Hora_Out__c=null,
            RecordTypeId = tipoRegistro
        );
        INSERT conex;
        return conex;
    }

    public static Task creaTarea (Id idCliente){
        Task tarea = new Task(
            Subject = 'Call',
            WhatId = idCliente
        );
        INSERT tarea;
        return tarea;
    }
    
    public static PRV_Equipo_de_Cliente__c crearEquipoCliente (Id idCliente){
        PRV_Equipo_de_Cliente__c equipo = new PRV_Equipo_de_Cliente__c (
        	Cliente__c = idCliente
        );
        INSERT equipo;
        return equipo;
    }
    
    public static Tamano_Nacional__c crearTamanio (){
        Tamano_Nacional__c tamanio = new Tamano_Nacional__c (
        	Name='Tamaño Test',
            Name_Unico__c = 'T2'
        );
        INSERT tamanio;
        return tamanio;
    }

	public static Account crearCuentaConTamanio( Id idTamanio) {
        Account cuenta = new Account(
            Name = 'GG-Name',
            BillingCity = 'BillingCity',
            BillingCountry = 'Mexico',
            BillingState = 'Jalisco',
            BillingStreet = 'BillingStreet',
            BillingPostalCode  = 'BillingPostalCode',
            No_De_Cliente__c = '1115198',
            CorreoElectronico__c = 'pruebadataset@gmail.com',
            Calle__c = 'A',
            Colonia__c = 'A',
            Cd_Pob__c = 'A',
            Mun_Del__c = 'A',
            Ent_Fed__c = 'A',
            Codigo_Postal__c = 42084,
            Phone = '7713810229',
            Nombre_R_Social__c = 'A',
            Calle_Fis__c = 'A',
            Colonia_Fiscal__c = 'A',
            Mun_Del_Fis__c = 'A',
            RFC__c = 'A',
            Cd_Pob_Fis__c = 'A',
            Nombre_del_Establecimiento__c = 'A',
            Tamano_Rica_Lk__c = idTamanio
        );
        INSERT cuenta;
        return cuenta;
    }    
    public static ZVC__Zoom_Call_Log__c crearLogZoom (Id idTarea,String numCliente){
        Date myDate = System.Today(); // Año, Mes, Día
        Time myTime = Time.newInstance(10, 30, 0, 0); // Hora, Minutos, Segundos, Milisegundos
		Time myTimeEnd = Time.newInstance(10, 30, 40, 0);        
        DateTime dateTimeStart = DateTime.newInstance(myDate, myTime);
        DateTime dateTimeEnd = DateTime.newInstance(myDate, myTimeEnd);
        
        ZVC__Zoom_Call_Log__c log = new ZVC__Zoom_Call_Log__c(
        	ZVC__Answer_Start_Time__c = dateTimeStart, 
            ZVC__Call_End_Time__c = dateTimeEnd,
            ZVC__Call_Duration__c = '00:40',                               
            ZVC__Callee_Phone_Number__c = numCliente, 
            ZVC__Caller_Phone_Number__c = '7716543210',
            ZVC__Call_Type__c ='outbound',
            ZVC__Task_Id__c = idTarea 
        );
        INSERT log;
        return log;
    }
    
    public static Region__c crearRegion2(String zdedis){
        Region__c region = new Region__c(
            Name = 'NORTE TEST',
            Zona_de_Distribucion__c = zdedis
        );
        INSERT region;
        return region;
    }
    
    public static Zona_de_Distribucion__c crearZdeD2(){
        Zona_de_Distribucion__c zdedis = new Zona_de_Distribucion__c(
            Name = 'NORTE TEST'
        );
        INSERT zdedis;
        return zdedis;
    }
    
    public static 	REP_Colaboradores__c crearColaborador (){
        REP_Colaboradores__c colaborador = new REP_Colaboradores__c(
        	Activo__c = True,
            Funcion__c = '1',
            Name = 'Colaborador Test'
        );
        INSERT colaborador;
        return colaborador;
    }
    
    public static REP_Unidad__c crearUnidad (){
        REP_Unidad__c unidad =new REP_Unidad__c (
        	Activo__c = True,
            No_de_Unidad__c = '503',
            Name = 'Unidad Test'
        );
        INSERT unidad;
        return unidad;
    }
    
    public static REP_Colaborador_en_Ruta__c crearColaboradorRuta (Id idUnidad, Id idVendedor){
        REP_Colaborador_en_Ruta__c colaborador = new REP_Colaborador_en_Ruta__c (
            Unidad__c = idUnidad,
            Vendedor__c = idVendedor,
        	Activa__c = True
        );
        INSERT colaborador;
        return colaborador;
    }
    
    public static Sucursal__c crearSucursalCodSAP(String region){
        Sucursal__c sucursal = new Sucursal__c(
            Name = 'C.D.TEST',
            Region_M__c = region,
            Estado_Sucursal__c = 'Hidalgo',
            Name_Unico__c = '2222',
            Codigo_SAP_Centro__c = '2222'
        );
        INSERT sucursal;
        return sucursal;
    }
    
    public static Ruta_de_Cliente__c crearRutaClienteTiemposPreventa(Id cuentaId, Id rutaId) {
        Ruta_de_Cliente__c rutaCliente = new Ruta_de_Cliente__c(
            Name = '1111-02-1115199',
            Cuenta_Lk__c = cuentaId,
            Ruta_M__c = rutaId,
            Fecha_Inicio__c = Date.newInstance(2024, 01, 01),
            Fecha_Fin__c = Date.newInstance(2099, 01, 01),
            Condicion_de_Pago__c = 'D001',
            Venta_Nueva_a_Credito__c=true,
            Lunes__c=true,
            Martes__c=true,
            Miercoles__c=true,
            Jueves__c=true,
            Viernes__c=true,
            Sabado__c= true,
            Domingo__c=true,
            TELE_Ruta_de_Reparto_Lk__c = rutaId,
            TELE_Nombre_del_Vendedor__c = 'ABC',
            Metodo_de_Pago_Principal__c = 'E'
        );
        INSERT rutaCliente;	
        return rutaCliente;
    }
    
    public static Ruta_de_Cliente__c crearRutaClienteCokeNet(Id cuentaId, Id rutaId , String conPago,String distintivo) {
        Ruta_de_Cliente__c rutaCliente = new Ruta_de_Cliente__c(
            Name = '1111-02-1115199',
            Cuenta_Lk__c = cuentaId,
            Ruta_M__c = rutaId,
            Fecha_Inicio__c = Date.newInstance(2024, 01, 01),
            Fecha_Fin__c = Date.newInstance(2099, 01, 01),
            Condicion_de_Pago__c = conPago,
            Venta_Nueva_a_Credito__c=true,
            Lunes__c=true,
            Martes__c=true,
            Miercoles__c=true,
            Jueves__c=true,
            Viernes__c=true,
            Sabado__c= true,
            Domingo__c=true,
            TELE_Ruta_de_Reparto_Lk__c = rutaId,
            TELE_Nombre_del_Vendedor__c = 'ABC',
            Metodo_de_Pago_Principal__c = 'E'
        );
        if(distintivo != ''){INSERT rutaCliente;}	
        return rutaCliente;
    }
    
    public static Ruta__c crearRutaTiemposPreventa(Sucursal__c sucursal, Id canal, Id rutaTipo, Id rutSuc){
        Ruta__c ruta = new Ruta__c(
            Name = '2222-503',
            Canal_distribucion__c = canal,
            Sucursal_Lk__c = sucursal.Id,
            Tipo_de_Ruta_Lk__c = rutaTipo,
            Ruta_de_Sucursal__c = rutSuc
        );
        INSERT ruta;
        return ruta;
    } 

    public static Conexion__c creaConexTiemposPreventa (Id rutC, Id suc,Date fecha,Decimal inLatitud,Decimal inLongitud){
        Conexion__c conex = new Conexion__c(
            Ruta_de_Cliente_Lk__c = rutC,
            Fecha__c = fecha,
            Tipo_Conexion__c = '11',
            Fecha_de_Entrega__c = Date.newInstance(2024, 12, 12),
            TELE_SucursalReparto_lk__c  = suc,
            Check_In_Latitud__c = inLatitud,
            Check_In_Longitud__c = inLongitud
        );
        INSERT conex;
        return conex;
    }
    
    public static PRV_Pedido_RICA__c pedTiempos (Id cnx, Id rutC,Date fecha,Decimal pedLatitud,Decimal pedLongitud,String clssPed){
        PRV_Pedido_RICA__c ped = new PRV_Pedido_RICA__c(
            Ruta_Cliente_lk__c = rutC,
            Visita_M__c = cnx,
            Fecha_Preventa_SAP__c = fecha,
            Tipo_de_Pedido_PList__c = 'ZTA1',
            Estatus_de_Pedido__c = 'Creado',
            Clase_de_Pedido__c  = clssPed,
            Pendiente_a_SAP_chk__c = True,
            Id_App__c = 'R1-1234560002',
            Creacion_Pedido_Latitud__c = pedLatitud,
            Creacion_Pedido_Longitud__c = pedLongitud,
            Fecha_hora_de_creacion__c = fecha
            
        );
        INSERT ped;
        return ped;
    }
    

    
    /*public static PRV_Pedido_RICA__c pedCokeNet (Id cnx, Id rutC){
        PRV_Pedido_RICA__c ped = new PRV_Pedido_RICA__c(
            Ruta_Cliente_lk__c = rutC,
            Visita_M__c = cnx,
            Fecha_Preventa_SAP__c = Date.Today(),
            Tipo_de_Pedido_PList__c = 'ZTA1',
            Estatus_de_Pedido__c = 'Creado',
            Clase_de_Pedido__c = 'CNET',
            Pendiente_a_SAP_chk__c = True,
            Id_App__c = '123456000'
            
        );
        INSERT ped;
        return ped;
    }*/
    
    public static Levantamiento__c crearLevantamiento (Id idUsuario,Id idCliente,Id tipo){
        Levantamiento__c levantamiento = new Levantamiento__c(
        	Cliente__c = idCliente,
            Auditor_Asignado__c = idUsuario,
            RecordTypeId = tipo
        );
        INSERT levantamiento;
        return levantamiento;
        
    }
    
    public static SKU_Ticket_Inventario__c crearSkuStoreCheck (){
        SKU_Ticket_Inventario__c sku = new SKU_Ticket_Inventario__c(
        	Agrupador_RICA__c = 'Colas',
            Categoria_RICA__c = 'Colas',
            Codigo_de_barras__c = '1111',
            Compania__c = 'TCCC',
            Presentacion_RICA__c = 'Vidrio Ret',
            Empaque_RICA__c = 'Coca-Cola/355 ml/Vidrio Ret',
            Fondos__c = 8,
            Litraje__c = '355 ml',
            Litros__c = 0.355,	
            Marca_RICA__c = 'Coca-Cola',
            Name = '6',
            Precio_Nielsen__c = 0,
            Precio_consumidor__c = 13,
            Submarca_RICA__c = 'Cola',
            Tamano_RICA__c = 'Single Serve' 
        );
        INSERT sku;
        return sku;
        
    }

}