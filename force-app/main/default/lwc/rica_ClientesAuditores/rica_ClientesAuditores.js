import { LightningElement, track,wire } from 'lwc';
import obtenerClientes from '@salesforce/apex/RICA_ClientesAuditores.obtenerClientes';
import obtenerFabricantes from '@salesforce/apex/RICA_ClientesAuditores.obtenerFabricantes';
import obtenerOpcionesPorFabricante from '@salesforce/apex/RICA_ClientesAuditores.obtenerOpcionesPorFabricante';
import obtenerProductosConCodigoBarras from '@salesforce/apex/RICA_ClientesAuditores.obtenerProductosConCodigoBarras';
import { createRecord, updateRecord } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';
import { getPicklistValues } from 'lightning/uiObjectInfoApi';
import USER_ID from '@salesforce/user/Id';
import LOGO from '@salesforce/resourceUrl/iconoLevantamientoTickets';
import LOGO2 from '@salesforce/resourceUrl/iconoLevantamientoInventario';
import LOGO3 from '@salesforce/resourceUrl/iconoLevantamientoUbicacion';
import LOGO4 from '@salesforce/resourceUrl/iconoLevantamientoPerfil';
import TICKET_OBJECT from '@salesforce/schema/Levantamiento__c';
import MOTIVO_FIELD from '@salesforce/schema/Levantamiento__c.Motivo_de_no_levantamiento_de_tickets__c';
import CATEGORIAS_MANEJANTES from '@salesforce/schema/Levantamiento__c.Categorias_de_Abarrotes_Manejantes__c';
import CATEGORIAS_CONFITERIA from '@salesforce/schema/Levantamiento__c.Categorias_de_Confiteria_Manejantes__c';
const STORAGE_KEY = 'motivosNoLevantamiento';
const CATEGORIAS_KEY = 'categoriasManjenatesEncuesta';
const CATEGORIAS_CONFITERIA_KEY = 'categoriasConfiteriaEncuesta';

export default class Rica_ClientesAuditores extends LightningElement {
    @track items = [];
    fabricantes = [];
    mostrarMenu = false;
    urlLogoTickets = LOGO;
    urlLogoInventario = LOGO2;
    urlLogoUbicacion = LOGO3;
    urlLogoPerfil = LOGO4;
    mostrarComponenteInventario = false;
    mostrarComponenteTicket = false;
    mostrarComponenteEncuesta = false;
    mostrarComponenteEncuesta = false;
    latitudCLienteSeeccionado = '';
    longitudClienteSeleccionado = '';
    clienteSeleccionado = {};

    latitudInventario = '';
    longitudInventario = '';

    @track searchTerm = ''; // Almacena el término de búsqueda
    @track items = []; // Lista original de clientes
    allItems = []; // Copia de seguridad de la lista original
    imagenesFaltantes = [];



    connectedCallback() {
        window.addEventListener('online', this.procesarRegistrosOffline.bind(this));
        //window.addEventListener('online', this.subirArchivosPendientes.bind(this));
        const registrosCache = localStorage.getItem('registrosPorFabricante');
        const registrosTicketsCache = localStorage.getItem('levantamientosDeTickets');

        //Validación que regresa al usuario al levantamiento de inventario si no se finlizó el proceso
        if (registrosCache) {
            const clienteGuardado = localStorage.getItem('clienteSeleccionado');
            if (clienteGuardado) {
                this.clienteSeleccionado = JSON.parse(clienteGuardado);
                console.log('CLIENTE SELECCIONADO RECUPERADO DE CACHE: ', this.clienteSeleccionado);
            }
            this.mostrarComponenteInventario = true;
        }

        //Validación que regresa al usuario al levantamiento de tickets si no se finlizó el proceso
        if(registrosTicketsCache){
            const clienteGuardado = localStorage.getItem('clienteSeleccionado');
            if (clienteGuardado) {
                this.clienteSeleccionado = JSON.parse(clienteGuardado);
                console.log('CLIENTE SELECCIONADO RECUPERADO DE CACHE: ', this.clienteSeleccionado);
            }
            this.mostrarComponenteTicket = true;
        }

        this.cargarClientes();
        this.cargarFabricantes();
        this.cargarOpcionesPorFabricantes();
        this.cargarProductosPorCodigosDeBarrar();
        //this.validarImagenesFaltantes();
        localStorage.removeItem('imagenesFaltantes');
    }

    cargarClientes() {
        // Intentar obtener datos almacenados en localStorage
        const cachedData = localStorage.getItem('clientes_auditores');

        if (cachedData && !navigator.onLine) {
            // Si hay datos almacenados, usarlos
            this.items = JSON.parse(cachedData);
            this.allItems = [...this.items]; // Guardar copia original
        }

        // Hacer la llamada a Apex para obtener datos actualizados
        obtenerClientes({ idUsuarioAuditor: USER_ID })
            .then(result => {
                console.log('RESULTADO DE LA CLASE: ', result);
                console.log('PRIMER REGISTRO: ', result[0].IdLevantamiento);
                this.items = result.map(cliente => ({
                    id: cliente.IdLevantamientoInventario,
                    IdLevantamientoTickets: cliente.IdLevantamientoTickets,
                    IdLevantamientoPerfil: cliente.IdLevantamientoPerfilCategorias,
                    idCliente: cliente.IdCliente,
                    nombre: cliente.NombreCliente,
                    //phone: cliente.PersonMobilePhone || cliente.Celular__c || 'Sin teléfono',
                    address: `${cliente.Calle}, ${cliente.NoExterior}, CP. ${cliente.CodigoPostal}, ${cliente.Ciudad}`,
                    nombreEstablecimiento: cliente.NombreEstablecimiento,
                    numeroCliente: cliente.NoCliente,
                    latitud: cliente.Latitud,
                    longitud: cliente.Longitud,
                    colorEstatusInventario: `indicador-inventario ${cliente.ColorEstatusInventario}`,
                    colorEstatusTicket: `indicador-tickets ${cliente.ColorEstatusTickets}`,
                    colorEstatusPerfil: `indicador-perfil ${cliente.ColorEstatusPerfil}`
                }));

                // Guardar datos en localStorage para uso sin conexión
                localStorage.setItem('clientes_auditores', JSON.stringify(this.items));
                this.allItems = [...this.items]; // Guardar copia original

                const valoresAEliminar = new Set([
                    'indicador-inventario verde',
                    'indicador-tickets verde',
                    'indicador-perfil verde'
                ]);
                
                this.allItems = this.allItems.filter(item => {
                    return !(
                        valoresAEliminar.has(item.colorEstatusInventario) &&
                        valoresAEliminar.has(item.colorEstatusTicket) &&
                        valoresAEliminar.has(item.colorEstatusPerfil)
                    );
                });
            })
            .catch(error => {
                console.log('Error', error);
                this.mostrarToast('Error', error, 'error');
            });

        console.log('ITEMS REALIZADOS: ', JSON.stringify(this.items));

    }

    cargarFabricantes() {
        obtenerFabricantes()
            .then(result => {
                this.fabricantes = result;
                localStorage.setItem('fabricantes', JSON.stringify(result));
                console.log('Fabricantes guardados en localStorage:', result);
            })
            .catch(error => {
                console.error('Error al obtener los fabricantes:', error);
            });
    }

    cargarOpcionesPorFabricantes(){
        obtenerOpcionesPorFabricante()
                .then(result => {
                    localStorage.setItem('opcionesPorFabricante', JSON.stringify(result));
                    console.log('Datos cargados de Apex:', result);
                })
                .catch(error => {
                    console.error('Error al obtener datos:', error);
                });
    }

    cargarProductosPorCodigosDeBarrar(){
        obtenerProductosConCodigoBarras()
                .then(result => {
                    localStorage.setItem('productosPorCodigosDeBarras', JSON.stringify(result));
                    console.log('Datos cargados de Apex:', result);
                })
                .catch(error => {
                    console.error('Error al obtener datos:', error);
                });
    }

    mostrarToast(title, message, variant) {
        this.dispatchEvent(new ShowToastEvent({ title, message, variant }));
    }

    redirigir(event) {
        console.log('EVENTO DE REDIRIGIR: ', event);
        const clienteId = event.currentTarget.dataset.id;
        console.log('ID DEL CLIENTE: ', clienteId);
        const cliente = this.filteredItems.find(item => item.id === clienteId);
        console.log('ID DEL CLIENTE: ', cliente);

        if (cliente) {
            this.clienteSeleccionado = { ...cliente };
            this.mostrarMenu = true;
        }
    }

    /*redirigir() {
        this.mostrarMenu = true;
        this.latitudCLienteSeeccionado = '';
        this.longitudClienteSeleccionado = '';
        this.mostrarToast('CLICK', 'Se dio click en la tarjeta del cliente.', 'error');
    }*/

    cerrarModal() {
        this.mostrarMenu = false;
        this.clienteSeleccionado = {};
    }

    desplegarAccion() {
        //this.crearAccount();
        if(this.clienteSeleccionado.colorEstatusInventario === 'indicador-inventario verde'){
            this.mostrarToast('ATENCION', 'Ya realizaste este levantamiento.', 'warning');
            return;
        }
        this.mostrarMenu = false;
        this.mostrarComponenteInventario = true;
    }

    desplegarLevantamientoTickets() {
        if(this.clienteSeleccionado.colorEstatusTicket === 'indicador-tickets verde'){
            this.mostrarToast('ATENCION', 'Ya realizaste este levantamiento.', 'warning');
            return;
        }
        this.mostrarMenu = false;
        this.mostrarComponenteTicket = true;
    }

    desplegarEncuesta(){
        if(this.clienteSeleccionado.colorEstatusPerfil === 'indicador-perfil verde'){
            this.mostrarToast('ATENCION', 'Ya realizaste este levantamiento.', 'warning');
            return;
        }
        this.mostrarMenu = false;
        this.mostrarComponenteEncuesta = true;
    }

    abrirMaps() {
        if (this.clienteSeleccionado) {
            const url = 'https://maps.google.com/?q=' + this.clienteSeleccionado.latitud + ',' + this.clienteSeleccionado.longitud;
            window.open(url, '_blank');
        } else {
            console.error('No hay dirección disponible para este cliente.');
        }
    }


    handleSearch(event) {
        this.searchTerm = event.target.value.toLowerCase(); // Guarda el input en minúsculas
        console.log('SEARCHTERM: ', this.searchTerm);
    }

    async procesarRegistrosOffline() {
        const registrosPendientes = JSON.parse(localStorage.getItem('registrosPendientes')) || [];
        let actualizacionesPendientes = JSON.parse(localStorage.getItem('registrosAActualizar')) || [];

        if (actualizacionesPendientes.length > 0) {
            actualizacionesPendientes.forEach(async (recordInput, index) => {
                try {
                    await updateRecord(recordInput);
                    console.log(`Registro sincronizado: `, recordInput);

                    actualizacionesPendientes.splice(index, 1); // Eliminar de la lista tras actualizar
                    localStorage.setItem('registrosPendientes', JSON.stringify(actualizacionesPendientes));
                } catch (error) {
                    this.mostrarToast('ERROR', 'NO SE ACTUALIZO EL REGISTRO.', 'error');
                    console.error('Error sincronizando registro:', error);
                }
            });
        }

        if (registrosPendientes.length === 0) {
            console.log('No hay registros pendientes.');
            return;
        }

        console.log('Intentando subir registros pendientes...');

        let registrosExitosos = 0;
        let registrosFallidos = [];

        registrosPendientes.forEach((recordInput) => {
            createRecord(recordInput)
                .then(() => {
                    registrosExitosos++;
                    this.mostrarToast('Éxito', 'Registro pendiente guardado correctamente.', 'success');

                    // Si todos los registros fueron exitosos, limpiamos el localStorage
                    if (registrosExitosos === registrosPendientes.length) {
                        localStorage.removeItem('registrosPendientes');
                        console.log('Todos los registros pendientes han sido procesados.');
                    }
                })
                .catch((error) => {
                    console.error('Error al guardar registro pendiente:', error);
                    registrosFallidos.push(recordInput);
                })
                .finally(() => {
                    // Si algunos registros fallaron, los volvemos a guardar en localStorage
                    if (registrosFallidos.length > 0) {
                        localStorage.setItem('registrosPendientes', JSON.stringify(registrosFallidos));
                    }
                });
        });
        //this.validarImagenesFaltantes();
    }

    /*validarImagenesFaltantes(){
        if(!navigator.onLine){
            return;
        }
        
        this.imagenesFaltantes = localStorage.getItem('imagenesFaltantes') || [];
        if(this.imagenesFaltantes){
            this.mostrarToast('Info','Se encontraron imagenes faltantes que debes subir.','info');
            this.mostrarModalImagenes = true;
        }
    }*/

    async handleCerrarComponente(event) {
        const datosExtra = event.detail;
        try {
            const options = {
                enableHighAccuracy: true,
                timeout: 5000,
                maximumAge: 0,
            };

            // Obtener ubicación antes de continuar
            const position = await this.getCurrentPosition(options);
            const crd = position.coords;

            console.log("Tu ubicación actual es:");
            console.log(`Latitud : ${crd.latitude}`);
            console.log(`Longitud: ${crd.longitude}`);
            console.log(`Más o menos ${crd.accuracy} metros.`);

            this.latitudInventario = parseFloat(crd.latitude);
            this.longitudInventario = parseFloat(crd.longitude);

            console.log('ITEMS EN CERRAR MODAL: ',this.items);
            console.log('Campo por el cual buscar', event.detail.campo)

            if (this.clienteSeleccionado && this.clienteSeleccionado.id) {
                const index = this.items.findIndex(item => item[event.detail.campo] === event.detail.idRegistroAActualizar);
                console.log('INDEX DEL REGISTRO A EDITAR: ', index);

                if (index !== -1) {
                    console.log('ENTRA EN LA VALIDACIÓN DEL INDEX');
                    if (this.items[index].colorEstatusInventario === "indicador-inventario amarillo" && event.detail.campo === 'id') {
                        this.items[index] = {
                            ...this.items[index],
                            colorEstatusInventario: "indicador-inventario verde"
                        };
                        console.log('Registro actualizado: ', this.items);
                        this.clienteSeleccionado.colorEstatusInventario = "indicador-inventario verde";
                    }
                    if (this.items[index].colorEstatusTicket === "indicador-tickets azul" && event.detail.campo === 'IdLevantamientoTickets') {
                        this.items[index] = {
                            ...this.items[index],
                            colorEstatusTicket: "indicador-tickets verde"
                        };
                        console.log('Registro actualizado: ', this.items);
                        this.clienteSeleccionado.colorEstatusTicket = "indicador-tickets verde";
                    }
                    if (this.items[index].colorEstatusPerfil === "indicador-perfil naranja" && event.detail.campo === 'IdLevantamientoPerfil') {
                        this.items[index] = {
                            ...this.items[index],
                            colorEstatusPerfil: "indicador-perfil verde"
                        };
                        console.log('Registro actualizado: ', this.items);
                        this.clienteSeleccionado.colorEstatusPerfil = "indicador-perfil verde";
                    }
                }
            }

            const fields = {
                Id: event.detail.idRegistroAActualizar,
                Realizacion_del_Levantamiento__c: true,
                Fin_del_Levantamiento__c: new Date().toISOString(),
                Latitud_Levantamiento__c: this.latitudInventario,
                Longitud_Levantamiento__c: this.longitudInventario
            };

            console.log('REGISTRO A ACTUALIZAR: ', fields);
            const recordInput = { fields };
            // Verificar si hay conexión
            if (navigator.onLine) {
                // Si hay conexión, actualizar en Salesforce
                await updateRecord(recordInput);
                console.log('REGISTRO ACTUALIZADO: ', this.clienteSeleccionado.id);
            } else {
                // Si no hay conexión, guardar en caché para actualizar después
                let registrosPendientes = JSON.parse(localStorage.getItem('registrosAActualizar')) || [];
                registrosPendientes.push(recordInput);
                localStorage.setItem('registrosAActualizar', JSON.stringify(registrosPendientes));

                console.log('Registro almacenado en caché:', recordInput);
            }

        } catch (error) {
            this.mostrarToast('Error', 'No se pudo actualizar el registro.', 'error');
            console.error('Error en updateRecord o geolocalización:', error);
        }

        // Cerrar el componente
        this.mostrarComponenteInventario = false;
        this.mostrarComponenteTicket = false;
        this.mostrarComponenteEncuesta = false;
        this.mostrarMenu = true;

        // Forzar reactividad reasignando un nuevo array
        this.allItems = [...this.items];

        const valoresAEliminar = new Set([
            'indicador-inventario verde',
            'indicador-tickets verde',
            'indicador-perfil verde'
        ]);
        
        this.allItems = this.allItems.filter(item => {
            return !(
                valoresAEliminar.has(item.colorEstatusInventario) &&
                valoresAEliminar.has(item.colorEstatusTicket) &&
                valoresAEliminar.has(item.colorEstatusPerfil)
            );
        });
    }

    handleCerrarComponenteTickets(){
        // Cerrar el componente
        this.mostrarComponenteTicket = false;
        this.mostrarMenu = true;
    }

    handleCerrarComponenteTickets(){
        // Cerrar el componente
        this.mostrarComponenteTicket = false;
        this.mostrarMenu = true;
    }

    // Función que convierte getCurrentPosition en una Promesa
    getCurrentPosition(options) {
        return new Promise((resolve, reject) => {
            navigator.geolocation.getCurrentPosition(resolve, reject, options);
        });
    }

    handleCerrarFormulario() {
        console.log('RECIBIENDO EL EVENTOO');
        localStorage.removeItem('registrosPorFabricante');
        localStorage.removeItem('clienteSeleccionado');
        this.mostrarComponenteInventario = false;
        this.mostrarComponenteTicket = false;
        this.mostrarComponenteEncuesta = false;
        this.mostrarMenu = true;
    }


    get filteredItems() {
        if (!this.searchTerm) {
            return this.allItems;
        }
        return this.allItems.filter(item =>
            (item.nombre && item.nombre.toLowerCase().includes(this.searchTerm)) ||
            (item.numeroCliente && item.numeroCliente.toString().includes(this.searchTerm))
        );
    }


    //FUNCIONES PARA EL ALMACENAMIENTO DE LA INFORMACIÓN EN EL LOCAL STORAGE
    //Función get para llenar las opciones del selector de no levantamiento
    picklistOptions = [];
    opcionesCategoriasManejantes = [];
    opcionesCategoriasConfiteria = [];
    recordTypeId;

    @wire(getObjectInfo, { objectApiName: TICKET_OBJECT })
    objectInfo({ data, error }) {
        if (data) {
            this.recordTypeId = data.defaultRecordTypeId;
        }
    }

    @wire(getObjectInfo, { objectApiName: TICKET_OBJECT })
    objectInfo({ data, error }) {
        if (data) {
            this.recordTypeId = data.defaultRecordTypeId;
        }
    }

    @wire(getPicklistValues, {
        recordTypeId: '$recordTypeId',
        fieldApiName: MOTIVO_FIELD
    })
    picklistHandler({ data, error }) {
        if (data) {
            this.picklistOptions = [...data.values];

            // Guardar en localStorage
            try {
                localStorage.setItem(STORAGE_KEY, JSON.stringify(this.picklistOptions));
            } catch (e) {
                console.error('No se pudo guardar en localStorage', e);
            }

        } else if (error) {
            // Si falla, intentar obtener del localStorage
            /*try {
                const stored = localStorage.getItem(STORAGE_KEY);
                if (stored) {
                    this.picklistOptions = JSON.parse(stored);
                    console.warn('Cargando valores desde localStorage');
                }
            } catch (e) {
                console.error('Error al leer localStorage', e);
            }*/
           console.error('ERROR AL OBTENER LOS VALORES DEL PICKLIST: ',error);
        }
    }

    @wire(getPicklistValues, {
        recordTypeId: '$recordTypeId',
        fieldApiName: CATEGORIAS_MANEJANTES
    })
    picklistHandlerCategorias({ data, error }) {
        if (data) {
            this.opcionesCategoriasManejantes = [...data.values];
            console.log('CATEGORIAS: ',this.opcionesCategoriasManejantes);
            // Guardar en localStorage
            try {
                localStorage.setItem(CATEGORIAS_KEY, JSON.stringify(this.opcionesCategoriasManejantes));
            } catch (e) {
                console.error('No se pudo guardar en localStorage', e);
            }

        } else if (error) {
            // Si falla, intentar obtener del localStorage
            /*try {
                const stored = localStorage.getItem(STORAGE_KEY);
                if (stored) {
                    this.picklistOptions = JSON.parse(stored);
                    console.warn('Cargando valores desde localStorage');
                }
            } catch (e) {
                console.error('Error al leer localStorage', e);
            }*/
           console.error('ERROR AL OBTENER LOS VALORES DEL PICKLIST: ',error);
        }
    }

    @wire(getPicklistValues, {
        recordTypeId: '$recordTypeId',
        fieldApiName: CATEGORIAS_CONFITERIA
    })
    picklistHandlerCategoriasConfiteria({ data, error }) {
        if (data) {
            this.opcionesCategoriasConfiteria = [...data.values];
            console.log('CONFITERIAS: ',this.opcionesCategoriasConfiteria);
            // Guardar en localStorage
            try {
                localStorage.setItem(CATEGORIAS_CONFITERIA_KEY, JSON.stringify(this.opcionesCategoriasConfiteria));
            } catch (e) {
                console.error('No se pudo guardar en localStorage', e);
            }

        } else if (error) {
            // Si falla, intentar obtener del localStorage
            /*try {
                const stored = localStorage.getItem(STORAGE_KEY);
                if (stored) {
                    this.picklistOptions = JSON.parse(stored);
                    console.warn('Cargando valores desde localStorage');
                }
            } catch (e) {
                console.error('Error al leer localStorage', e);
            }*/
           console.error('ERROR AL OBTENER LOS VALORES DEL PICKLIST: ',error);
        }
    }

}