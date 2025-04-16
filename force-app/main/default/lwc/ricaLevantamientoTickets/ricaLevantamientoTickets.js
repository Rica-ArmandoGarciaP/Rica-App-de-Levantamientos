import { LightningElement, api, track } from 'lwc';
import { createRecord, updateRecord } from 'lightning/uiRecordApi';
import obtenerOpcionesPorFabricante from '@salesforce/apex/RICA_ClientesAuditores.obtenerOpcionesPorFabricante';
import guardarImagenBase64 from '@salesforce/apex/RICA_ClientesAuditores.guardarImagenBase64';
import { getBarcodeScanner } from 'lightning/mobileCapabilities';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import LOGO from '@salesforce/resourceUrl/IconoContinuar';
import LOGO2 from '@salesforce/resourceUrl/sinTickets';
import LOGO3 from '@salesforce/resourceUrl/iconoGuardar';
import LOGO4 from '@salesforce/resourceUrl/iconoResumen';
import LOGO5 from '@salesforce/resourceUrl/iconoNuevoTicket';
import LOGO6 from '@salesforce/resourceUrl/iconoSubirImagen';
import LOGO7 from '@salesforce/resourceUrl/iconoAdvertencia';

const STORAGE_KEY = 'motivosNoLevantamiento';

export default class RicaLevantamientoTickets extends LightningElement {

    @api cliente;
    idRegistroARelacionarArchivos = '';

    //URLs de los iconos utilizados en el componente
    urlIconoSiguiente = LOGO;
    urlIconoSinTickets = LOGO2;
    urlGuardarProducto = LOGO3;
    urlIconoResumen = LOGO4;
    urlIconoNuevoTicket = LOGO5;
    urlIconoSubirImagen = LOGO6;
    urlIconoAdvertencia = LOGO7;

    //Variables para los valores de los selectores e inputs
    barcodeScanner;
    @track scannedBarcodes;
    @track codEscaneado = '';
    @track empaque = '';
    @track fabricante = '';
    @track categoria = '';
    @track subMarca = '';
    @track cantidad = '';
    @track fechaTicket = '';
    @track precioProd = '';
    @track opcionesFabricanteFiltradas = [];
    @track opcionesFabricante = [];
    @track opcionesPorFabricante = {};

    @track opcionesEmpaque = [];
    @track opcionesCategoria = [];
    @track opcionesSubMarca = [];
    @track opcionesEmpaqueFiltradas = [];
    @track opcionesCategoriaFiltradas = [];
    @track opcionesSubMarcaFiltradas = [];
    @track conteoRegistros = [];
    @track totalesGenerales = [];
    @track filaSeleccionada = null;
    @track registrosSeleccionados = [];
    @track registrosPorFabricante = [];
    @track isOnline = navigator.onLine;
    @track imagenesPreview = [];
    key = '';
    barcodeScanner;
    fechaTicketSeleccionado = '';

    //variables para mostrar o no un formulario o elemento
    mostrarOpciones = true;
    mostrarSelectorNoLevantamiento = false;
    informacionTicketNoCargada = true;
    informacionTicketCargada = false;
    mostrarSelectorFabricante = false;
    mostrarSelectorEmpaque = false;
    mostrarSelectorCategoria = false;
    mostrarSelectorSubMarca = false;
    mostrarTablaResumen = false;
    fabricanteSeleccionado = false;
    mostrarModal = false;
    mostrarResumen = false;
    subioImagen = false;


    //variable del valor seleccionado del motivo de no levantamiento
    motivoNoLevantamiento = '';

    picklistOptions = [];

    //Funciones de funcionamiento
    connectedCallback() {
        this.cargarFabricantesDesdeLocalStorage();
        this.cargaOpcionesFabricantesDesdeLocalStorage();

        window.addEventListener('online', this.handleOnlineStatus);
        window.addEventListener('offline', this.handleOnlineStatus);

        if (this.cliente === '' || this.cliente === null) {
            console.log('Recuperando el cliente');
            this.cliente = localStorage.getItem('clienteSeleccionado');
        }
        localStorage.setItem('clienteSeleccionado', JSON.stringify(this.cliente));
        this.barcodeScanner = getBarcodeScanner();
        console.log('CLIENTE: ', JSON.stringify(this.cliente));
        this.idRegistroARelacionarArchivos = this.cliente.IdLevantamientoTickets;
        console.log('idRegistroARelacionarArchivos: ', JSON.stringify(this.idRegistroARelacionarArchivos));

        // Cargar valores del localStorage
        try {
            const stored = localStorage.getItem(STORAGE_KEY);
            if (stored) {
                this.picklistOptions = JSON.parse(stored);
                console.log('Valores del picklist cargados desde localStorage:', this.picklistOptions);
            } else {
                console.warn(`No se encontraron valores en localStorage con la clave: ${STORAGE_KEY}`);
            }
        } catch (e) {
            console.error('Error al leer localStorage:', e);
        }

        const registrosGuardadosDeLevantamiento = localStorage.getItem('levantamientosDeTickets');
        console.log('REGISTROS GUARDADOS DEL LEVANTAMIENTO ENCONTRADOS: ', registrosGuardadosDeLevantamiento);
        if (registrosGuardadosDeLevantamiento) {
            this.registrosPorFabricante = JSON.parse(registrosGuardadosDeLevantamiento);
            this.mostrarToast('CORRECTO', 'Se restauraron tus registros', 'success');
            this.obtenerConteoRegistros();
            console.log('Entra en la validación para mostrar el componente de formulario')
            const mostrarDeNuevoElFormulario = localStorage.getItem('mostrarFormularioDeProductosTickets');
            if (mostrarDeNuevoElFormulario) {
                console.log('Entra en la validación donde encontró el valor')
                this.mostrarOpciones = false;
                this.informacionTicketNoCargada = false;
                this.mostrarFormulario = true;
                this.informacionTicketCargada = true;
                this.key = localStorage.getItem('claveDelTicekt');
                //this.fabricanteSeleccionado = localStorage.getItem('fabricanteSeleccionadoTickets');
                this.fabricante = localStorage.getItem('fabricanteSeleccionadoTickets');
                this.actualizarOpcionesSegunFabricante();
            }
        }
        this.guardarFechaInicio();
    }

    disconnectedCallback() {
        window.removeEventListener('online', this.handleOnlineStatus);
        window.removeEventListener('offline', this.handleOnlineStatus);
    }

    handleOnlineStatus = () => {
        this.isOnline = navigator.onLine;
    };

    /*async guardarInfoTicketSalesforce() {
        const fields = {
            Id: this.idRegistroARelacionarArchivos,
            Fecha_del_ticket__c: this.fechaTicket
        };

        console.log('REGISTRO A ACTUALIZAR: ', fields);
        const recordInput = { fields };
        // Verificar si hay conexión
        if (navigator.onLine) {
            // Si hay conexión, actualizar en Salesforce
            await updateRecord(recordInput);
            //console.log('REGISTRO ACTUALIZADO: ', this.clienteSeleccionado.idRegistroARelacionarArchivos);
        } else {
            // Si no hay conexión, guardar en caché para actualizar después
            let registrosPendientes = JSON.parse(localStorage.getItem('registrosAActualizar')) || [];
            registrosPendientes.push(recordInput);
            localStorage.setItem('registrosAActualizar', JSON.stringify(registrosPendientes));

            console.log('Registro almacenado en caché:', recordInput);
        }

        this.actualizarOpcionesSegunFabricante();
        this.inicializarLevantamientosLocalStorage();

    }*/

    async guardarMotivoNoLevantamiento() {

        if(this.motivoNoLevantamiento === ''){
            this.mostrarToast('Error', 'Debe seleccionar un motivo para continuar.', 'error');
            return;
        }

        const fields = {
            Id: this.idRegistroARelacionarArchivos,
            Motivo_de_no_levantamiento_de_tickets__c: this.motivoNoLevantamiento
        };

        console.log('REGISTRO A ACTUALIZAR: ', fields);
        const recordInput = { fields };
        // Verificar si hay conexión
        if (navigator.onLine) {
            // Si hay conexión, actualizar en Salesforce
            //await updateRecord(recordInput);
            try {
                await updateRecord(recordInput);

                this.mostrarToast('Correcto', 'Se envió el motivo de no levantamiento.', 'success');
                this.motivoNoLevantamiento = '';
            } catch (error) {
                console.error('Error al actualizar el registro:', error);

                this.mostrarToast('Error', 'No se envió el motivo de no levantamiento.', 'error');
            }
            //console.log('REGISTRO ACTUALIZADO: ', this.clienteSeleccionado.idRegistroARelacionarArchivos);
        } else {
            // Si no hay conexión, guardar en caché para actualizar después
            let registrosPendientes = JSON.parse(localStorage.getItem('registrosAActualizar')) || [];
            registrosPendientes.push(recordInput);
            localStorage.setItem('registrosAActualizar', JSON.stringify(registrosPendientes));

            console.log('Registro almacenado en caché:', recordInput);
        }

        this.cerrarModalGeneral();
    }

    async guardarFechaInicio() {
        const fields = {
            Id: this.idRegistroARelacionarArchivos,
            Inicio_del_Levantamiento__c: new Date().toISOString()
        };

        console.log('REGISTRO A ACTUALIZAR: ', fields);
        const recordInput = { fields };
        // Verificar si hay conexión
        if (navigator.onLine) {
            // Si hay conexión, actualizar en Salesforce
            await updateRecord(recordInput);
            //console.log('REGISTRO ACTUALIZADO: ', this.clienteSeleccionado.idRegistroARelacionarArchivos);
        } else {
            // Si no hay conexión, guardar en caché para actualizar después
            let registrosPendientes = JSON.parse(localStorage.getItem('registrosAActualizar')) || [];
            registrosPendientes.push(recordInput);
            localStorage.setItem('registrosAActualizar', JSON.stringify(registrosPendientes));

            console.log('Registro almacenado en caché:', recordInput);
        }
    }

    inicializarLevantamientosLocalStorage() {
        this.key = `${this.fabricante}_${this.fechaTicket}`;
        localStorage.setItem('claveDelTicekt', this.key);
        localStorage.setItem('fabricanteSeleccionadoTickets', this.fabricante);
        let almacen = JSON.parse(localStorage.getItem('levantamientosDeTickets')) || {};

        // Solo si no existe el key, lo inicializamos con una lista vacía
        if (!almacen[this.key]) {
            almacen[this.key] = [];
            localStorage.setItem('levantamientosDeTickets', JSON.stringify(almacen));
            console.log(`Inicializado en localStorage clave: ${this.key}`);
        } else {
            console.log(`Ya existe en localStorage la clave: ${this.key}`);
        }
    }


    handleChangeFechaTicket(event) {
        this.fechaTicket = event.target.value;
        console.log('Fecha seleccionada:', this.fechaTicket);
    }


    cargarFabricantesDesdeLocalStorage() {
        const locales = this.leerFabricantesDesdeLocalStorage();
        if (locales.length > 0) {
            this.opcionesFabricante = locales;
            this.opcionesFabricanteFiltradas = locales;
            console.log('opcionesFabricanteFiltradas: ', this.opcionesFabricanteFiltradas);
        } else {
            console.error('No se encontraron fabricantes en localStorage');
        }
    }

    cargaOpcionesFabricantesDesdeLocalStorage() {
        const cache = localStorage.getItem('opcionesPorFabricante');
        if (cache) {
            this.opcionesPorFabricante = JSON.parse(cache);
            console.log('Cargado desde localStorage:', this.opcionesPorFabricante);
        } else {
            obtenerOpcionesPorFabricante()
                .then(result => {
                    this.opcionesPorFabricante = result;
                    localStorage.setItem('opcionesPorFabricante', JSON.stringify(result));
                    console.log('Datos cargados de Apex:', result);
                })
                .catch(error => {
                    console.error('Error al obtener datos:', error);
                });
        }
    }

    leerFabricantesDesdeLocalStorage() {
        const datos = localStorage.getItem('fabricantes');
        if (datos) {
            const lista = JSON.parse(datos);
            return lista.map(fab => ({ label: fab, value: fab }));
        }
        return [];
    }

    actualizarOpcionesSegunFabricante() {
        console.log('ACTUALIZANDO LAS OPCIONES SEGUN EL FABRICANTE: ', this.fabricante);
        const opciones = this.opcionesPorFabricante[this.fabricante];
        console.log('ACTUALIZANDO LAS OPCIONES SEGUN EL FABRICANTE OPCIONES: ', opciones);
        if (opciones) {
            this.opcionesEmpaque = this.formatearParaSelector(opciones.Empaques);
            this.opcionesCategoria = this.formatearParaSelector(opciones.Categorias);
            this.opcionesSubMarca = this.formatearParaSelector(opciones.Submarcas);
            this.opcionesEmpaqueFiltradas = [...this.opcionesEmpaque];
            this.opcionesCategoriaFiltradas = [...this.opcionesCategoria];
            this.opcionesSubMarcaFiltradas = [...this.opcionesSubMarca];
        } else {
            this.opcionesCategoria = [];
            this.opcionesSubMarca = [];
            this.opcionesEmpaque = [];
        }
    }

    formatearParaSelector(lista) {
        if (!Array.isArray(lista)) return [];
        return lista.map(item => ({ label: item, value: item }));
    }

    handleChangeSelectorMotivo(event) {
        this.motivoNoLevantamiento = event.target.value;
        console.log('MOTIVO DE NO LEVANTAMIENTO: ', this.motivoNoLevantamiento);
    }

    handleChange(event) {
        const fieldName = event.target.dataset.field;
        console.log('fieldName: ', fieldName);
        if (!fieldName) {
            console.error('data-field no está definido en el elemento input');
            return;
        }

        this[fieldName] = event.target.value;

        const capitalizedField = fieldName.charAt(0).toUpperCase() + fieldName.slice(1);
        const opcionesKey = `opciones${capitalizedField}`;
        const opcionesFiltradasKey = `opciones${capitalizedField}Filtradas`;

        if (this[opcionesKey]) {
            this[opcionesFiltradasKey] = this[opcionesKey].filter((opcion) =>
                opcion.label.toLowerCase().includes(this[fieldName].toLowerCase())
            );

            if (!this[fieldName]) {
                this[opcionesFiltradasKey] = this[opcionesKey];
            }
        }
    }

    handleOptionSelect(event) {
        const fieldName = event.target.dataset.field;
        console.log('Campo seleccionado: ', fieldName);
        if (!fieldName) {
            console.error('data-field no está definido en el elemento <li>');
            return;
        }

        this[fieldName] = event.target.innerText;
        console.log('CAMPO CON EL PROCESO: ', `mostrarSelector${fieldName.charAt(0).toUpperCase() + fieldName.slice(1)}`);
        this[`mostrarSelector${fieldName.charAt(0).toUpperCase() + fieldName.slice(1)}`] = false;
        this.actualizarOpcionesSegunFabricante();
    }

    handleChangeInputCodigoBarras(event) {
        this.codEscaneado = event.target.value;
        console.log('Nuevo código escaneado:', this.codEscaneado);
    }

    handleChangeCantidad(event) {
        this.cantidad = event.target.value;
    }

    handleChangePrecio(event) {
        this.precioProd = event.target.value;
    }

    guardarRegistroPorFechaYFabricante() {
        if (!this.fabricante) {
            this.mostrarToast('Error', 'Debe seleccionar un fabricante antes de guardar.', 'error');
            return;
        }

        /*if (!this.fechaTicket) {
            this.mostrarToast('Error', 'Debe seleccionar una fecha del ticket antes de guardar.', 'error');
            return;
        }*/

        if (!this.empaque) {
            this.mostrarToast('Error', 'Debe seleccionar un empaque antes de guardar.', 'error');
            return;
        }

        if (!this.categoria) {
            this.mostrarToast('Error', 'Debe seleccionar una categoría antes de guardar.', 'error');
            return;
        }

        if (!this.subMarca) {
            this.mostrarToast('Error', 'Debe seleccionar una submarca antes de guardar.', 'error');
            return;
        }

        if (!this.cantidad || this.cantidad === '0') {
            this.mostrarToast('Error', 'Debe de ingresar una cantidad diferente a 0 para guardar.', 'error');
            return;
        }
        if (!this.precioProd || this.precioProd === '0') {
            this.mostrarToast('Error', 'Debe de ingresar una precio diferente a 0 para guardar.', 'error');
            return;
        }

        const nuevoRegistro = {
            fabricante: this.fabricante,
            codEscaneado: this.codEscaneado,
            empaque: this.empaque,
            categoria: this.categoria,
            subMarca: this.subMarca,
            cantidad: this.cantidad,
            precio: this.precioProd,
        };

        const storageKey = 'levantamientosDeTickets';
        const compositeKey = this.key;
        console.log('KEY A LA QUE VA A RELACIONAR EL REGISTRO: ' + compositeKey);

        let levantamientos = JSON.parse(localStorage.getItem(storageKey)) || {};

        if (!Array.isArray(levantamientos[compositeKey])) {
            levantamientos[compositeKey] = [];
        }

        const registros = levantamientos[compositeKey];
        const index = registros.findIndex(reg => reg.codEscaneado === this.codEscaneado);

        if (index !== -1) {
            const confirmacion = window.confirm('Este código ya existe para esta fecha y fabricante. ¿Desea actualizar el registro?');
            if (confirmacion) {
                registros[index] = nuevoRegistro;
            } else {
                return;
            }
        } else {
            registros.push(nuevoRegistro);
        }

        localStorage.setItem(storageKey, JSON.stringify(levantamientos));
        this.registrosPorFabricante = levantamientos;

        // Limpiar campos
        this.codEscaneado = '';
        this.empaque = '';
        this.categoria = '';
        this.subMarca = '';
        this.cantidad = '';
        this.precioProd = '';
        // Puedes dejar fabricante y fecha si quieres seguir con el mismo flujo

        this.obtenerConteoRegistros();

        console.log(`Registros actualizados para ${compositeKey}:`, JSON.stringify(this.registrosPorFabricante, null, 2));
    }

    beginScanning() {
        const scanningOptions = {
            barcodeTypes: [this.barcodeScanner.barcodeTypes.EAN_13,this.barcodeScanner.barcodeTypes.EAN_8,this.barcodeScanner.barcodeTypes.UPC_A,this.barcodeScanner.barcodeTypes.UPC_E],
            scannerSize: "FULLSCREEN",
            cameraFacing: "BACK",
            showSuccessCheckMark: true,
            enableBulkScan: false,
            enableMultiScan: false,
        };

        if (this.barcodeScanner != null && this.barcodeScanner.isAvailable()) {
            this.scannedBarcodes = [];

            this.barcodeScanner
                .scan(scanningOptions)
                .then((results) => {
                    this.processScannedBarcodes(results);
                })
                .catch((error) => {
                    this.processError(error);
                })
                .finally(() => {
                    this.barcodeScanner.dismiss();
                });
        } else {
            console.log("BarcodeScanner unavailable. Non-mobile device?");
        }
    }

    processError(error) {
        // Check to see if user ended scanning
        if (error.code == "USER_DISMISSED") {
            console.log("User terminated scanning session.");
        } else {
            console.error(error);
        }
    }

    processScannedBarcodes(barcodes) {
        if (barcodes && barcodes.length > 0) {
            this.codEscaneado = barcodes[0].value;

            // Obtener los productos del localStorage
            const productosPorCodigosDeBarras = JSON.parse(localStorage.getItem('productosPorCodigosDeBarras')) || {};

            // Buscar el producto con la clave que coincida con el código de barras escaneado
            const producto = productosPorCodigosDeBarras[this.codEscaneado];

            if (producto) {
                // Asignar los valores a los campos de selección
                this.fabricante = producto.Compania__c || '';
                this.empaque = producto.Empaque_RICA__c || '';
                this.categoria = producto.Categoria_RICA__c || '';
                this.subMarca = producto.Submarca_RICA__c || '';

                // Asignar valores a los select (suponiendo que tienes estos métodos para manejarlos)
                this.handleChangeFabricante({ target: { value: this.fabricante } });
                this.handleChangeEmpaque({ target: { value: this.empaque } });
                this.handleChangeCategoria({ target: { value: this.categoria } });
                this.handleChangeSubMarca({ target: { value: this.subMarca } });

                // Mostrar mensaje de éxito si el producto fue encontrado
                console.log('Producto encontrado:', producto);
                this.actualizarOpcionesSegunFabricante();
            } else {
                // Si no se encuentra el producto, mostrar un mensaje de error
                this.mostrarToast('ERROR', 'Producto no encontrado en el localStorage.', 'error');
            }
        }
    }

    obtenerConteoRegistros() {
        const meses = [
            'Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio',
            'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'
        ];

        console.log('registrosPorFabricante ANTES DE HACER EL CONTEO: ', JSON.stringify(this.registrosPorFabricante, null, 2));

        this.conteoRegistros = Object.keys(this.registrosPorFabricante).map(clave => {
            const identificador = clave;
            const [fabricante, fecha] = clave.split('_');
            const registros = this.registrosPorFabricante[clave];

            const sumaPrecios = registros.reduce((total, item) => {
                const precioNumerico = Number(item.precio);
                return total + (isNaN(precioNumerico) ? 0 : precioNumerico);
            }, 0);

            console.log('FECHA QUE LLEGA PARA FORMATEAR: ' + fecha);
            const fechaFormateada = this.formatearFecha(fecha);

            return {
                identificador: identificador,
                fabricante,
                fecha: fechaFormateada,
                cantidad: registros.length,
                sumaPrecios
            };
        });

        // Calcular los totales generales
        this.totalesGenerales = this.conteoRegistros.reduce(
            (acumulador, item) => {
                acumulador.totalCantidad += item.cantidad;
                acumulador.totalPrecios += item.sumaPrecios;
                return acumulador;
            },
            { totalCantidad: 0, totalPrecios: 0 }
        );

        console.log('conteoRegistros: ', this.conteoRegistros);
        console.log('totalesGenerales: ', this.totalesGenerales);
    }

    formatearFecha(fechaString) {
        const meses = [
            'Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio',
            'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'
        ];
        const [year, month, day] = fechaString.split('-');
        const nombreMes = meses[parseInt(month, 10) - 1];
        return `${day} ${nombreMes} ${year}`; // Ejemplo: 01 Abril 2025
    }


    seleccionarFabricante(event) {
        this.mostrarTablaResumen = false;
        const clave = event.currentTarget.dataset.identificador;
        const [fabricante, fecha] = clave.split('_');
        this.identificadorSeleccionado = clave;
        this.fabricanteSeleccionado = fabricante;
        this.fechaTicketSeleccionado = this.formatearFecha(fecha);
        this.registrosSeleccionados = this.registrosPorFabricante[clave] || [];
        console.log(`Registros para ${fabricante}:`, JSON.stringify(this.registrosSeleccionados, null, 2));
        console.log('clave SELECCIONADA: ', clave);
    }

    seleccionarRegistro(event) {
        const codEscaneado = event.currentTarget.dataset.codescaneado; // Obtener el código escaneado
        console.log('CÓDIGO ESCANEADO SELECCIONADO: ', codEscaneado);

        if (codEscaneado) {
            this.filaSeleccionada = this.registrosSeleccionados.find(
                registro => registro.codEscaneado === codEscaneado
            ); // Buscar el registro por codEscaneado

            console.log('FILA SELECCIONADA: ', this.filaSeleccionada);
            if (this.filaSeleccionada) {
                this.mostrarModal = true; // Mostrar modal
                console.log('Registro Seleccionado: ', this.filaSeleccionada);
            }
        }
    }

    eliminarRegistro() {
        const codigo = this.filaSeleccionada.codEscaneado;
        const identificador = this.identificadorSeleccionado;

        console.log('CODIGO DEL REGISTRO A ELIMINAR: ', codigo);
        console.log('IDENTIFICADOR SELECCIONADO: ', identificador);

        const confirmacion = window.confirm('¿Está seguro de eliminar el registro?');

        if (confirmacion) {
            if (this.registrosPorFabricante[identificador]) {
                console.log('Entra a la condicional de la lista por identificador');

                // Encontrar el índice del elemento a eliminar
                const index = this.registrosPorFabricante[identificador].findIndex(
                    item => item.codEscaneado === codigo
                );

                // Si el índice es válido, eliminar el elemento directamente
                if (index !== -1) {
                    console.log('INDEX: ', index);
                    this.registrosPorFabricante[identificador].splice(index, 1);
                }

                // Si no quedan registros en ese identificador, eliminar la clave del objeto
                if (this.registrosPorFabricante[identificador].length === 0) {
                    delete this.registrosPorFabricante[identificador];
                }
            }
            this.obtenerConteoRegistros();
            console.log('REGISTRO ELIMINADO: ', this.registrosPorFabricante);
        }

        this.cerrarModalOpcionesRegistro(); // Cerrar el modal después de eliminar
    }

    subirDatos() {
        const [fabricante, fecha] = this.key.split('_');
        if (!this.registrosPorFabricante || Object.keys(this.registrosPorFabricante).length === 0) {
            this.mostrarToast('Error', 'No hay registros para subir.', 'error');
            return;
        }

        let registrosAGuardar = [];

        // Recorrer cada identificador (ej. "BELTICOS_2025-04-01")
        for (const identificador in this.registrosPorFabricante) {
            if (this.registrosPorFabricante.hasOwnProperty(identificador)) {
                const registros = this.registrosPorFabricante[identificador];
                console.log('REGISTROS QUE SE VAN A UBIR: ',registros);
                // Recorrer cada registro dentro del identificador
                registros.forEach((registro) => {
                    const fields = {
                        Name: registro.empaque,
                        Cantidad__c: parseInt(registro.cantidad),
                        Categoria__c: registro.categoria,
                        Codigo_de_Barras__c: registro.codEscaneado,
                        Empaque__c: registro.empaque,
                        Fabricante__c: registro.fabricante,
                        Levantamiento__c: this.cliente.IdLevantamientoTickets,
                        Submarca__c: registro.subMarca,
                        Fecha_del_ticket__c: new Date(fecha).toISOString(),
                        Precio_del_Producto__c: registro.precio
                    };

                    const recordInput = { apiName: 'Producto_de_Levantamiento__c', fields };

                    registrosAGuardar.push(recordInput);
                });
            }
        }

        if (!navigator.onLine) {
            // Obtener registros existentes del localStorage
            const registrosExistentes = JSON.parse(localStorage.getItem('registrosPendientes')) || [];

            // Agregar los nuevos registros a los existentes
            const registrosActualizados = registrosExistentes.concat(registrosAGuardar);

            // Guardar la lista actualizada en el localStorage
            localStorage.setItem('registrosPendientes', JSON.stringify(registrosActualizados));

            // Eliminar los levantamientos de tickets si es necesario
            localStorage.removeItem('levantamientosDeTickets');

            this.mostrarToast('Información', 'No hay conexión. Los registros se guardarán localmente.', 'info');
            this.cerrarModalGeneral();
            return;
        }

        // Intentar guardar los registros en Salesforce
        let registrosExitosos = 0;
        let registrosFallidos = 0;

        const promesas = registrosAGuardar.map((recordInput) => {
            return createRecord(recordInput)
                .then(() => {
                    registrosExitosos += 1;
                })
                .catch((error) => {
                    registrosFallidos += 1;
                    console.error('Error al guardar registro:', error);
                    this.mostrarToast('Error', 'Hubo un error al guardar un registro.', 'error');

                    // Guardar los fallidos en caché
                    let registrosFallidosGuardados = JSON.parse(localStorage.getItem('registrosPendientes')) || [];
                    registrosFallidosGuardados.push(recordInput);
                    localStorage.setItem('registrosPendientes', JSON.stringify(registrosFallidosGuardados));
                });
        });

        Promise.all(promesas).then(() => {
            this.mostrarToast('Correcto', 'Se cargaron ' + registrosExitosos + ' productos del levantamiento.', 'success');

            if (this.subioImagen === false) {
                const registroFaltanteImagen = this.cliente.IdLevantamientoTickets + '/' + this.key+'/'+this.cliente.nombre+'-'+this.cliente.numeroCliente;

                let imagenesGuardadas = localStorage.getItem('imagenesFaltantes');
                let listaImagenes = [];

                if (imagenesGuardadas) {
                    try {
                        listaImagenes = JSON.parse(imagenesGuardadas);
                    } catch (error) {
                        console.error('Error al parsear imagenesFaltantes:', error);
                        listaImagenes = [];
                    }
                }

                if (!listaImagenes.includes(registroFaltanteImagen)) {
                    listaImagenes.push(registroFaltanteImagen);
                }

                localStorage.setItem('imagenesFaltantes', JSON.stringify(listaImagenes));
            }

            localStorage.removeItem('levantamientosDeTickets');
            this.imagenesPreview = [];
            this.cerrarModalGeneral();
        });
    }


    mostrarToast(title, message, variant) {
        this.dispatchEvent(new ShowToastEvent({ title, message, variant }));
    }


    /*handleImageUpload(event) {
        const file = event.target.files[0];
        if (!file) return;

        const reader = new FileReader();
        reader.onload = () => {
            const base64 = reader.result.split(',')[1];
            const idRegistroARelacionar = this.cliente?.IdLevantamientoTickets;
            const nombreArchivo = this.key;

            if (!idRegistroARelacionar) {
                console.error('No se encontró número de cliente');
                return;
            }

            const estaEnLinea = navigator.onLine;

            this.subirArchivoAServer(base64, nombreArchivo, idRegistroARelacionar);
        };

        reader.readAsDataURL(file);
    }*/

    handleImageUpload(event) {
        const files = event.target.files;
        if (!files || files.length === 0) return;

        const idRegistroARelacionar = this.cliente?.IdLevantamientoTickets;
        if (!idRegistroARelacionar) {
            console.error('No se encontró número de cliente');
            return;
        }

        // Limpiar miniaturas anteriores
        //this.imagenesPreview = [];

        Array.from(files).forEach((file, index) => {
            const reader = new FileReader();
            reader.onload = () => {
                const result = reader.result;
                const base64 = result.split(',')[1];

                const mimeType = file.type;
                let extension = '';

                if (mimeType === 'image/png') {
                    extension = 'png';
                } else if (mimeType === 'image/jpeg') {
                    extension = 'jpg';
                } else if (mimeType === 'application/pdf') {
                    extension = 'pdf';
                } else {
                    console.warn(`Tipo de archivo no soportado: ${mimeType}`);
                    return;
                }

                const nombreArchivo = `${this.fabricante}_${this.fechaTicket}_${index + 1}.${extension}`;
                this.subirArchivoAServer(base64, nombreArchivo, idRegistroARelacionar);

                // Solo mostrar miniatura si es imagen
                if (mimeType.startsWith('image/')) {
                    this.imagenesPreview = [
                        ...this.imagenesPreview,
                        { src: result, nombre: nombreArchivo }
                    ];
                }
            };

            reader.readAsDataURL(file);
        });
        this.mostrarToast('CORRECTO', 'Se subieron las imágenes', 'success');
        this.subioImagen = true;
    }

    subirArchivoAServer(base64, nombre, clienteId) {
        guardarImagenBase64({ base64Data: base64, nombreArchivo: nombre, levantamientoId: clienteId })
            .then(() => {
                console.log('Archivo subido correctamente al servidor');
            })
            .catch(error => {
                console.error('Error al subir archivo:', error);
                // Si falla por otra razón, también podrías guardar en cache
            });
    }


    //Funciones para determinar qué mostrar
    mostrarSelectorMotivos() {
        console.log('Función disparada');
        this.mostrarOpciones = false;
        this.mostrarSelectorNoLevantamiento = true;
    }

    mostrarFormularioLevantamiento() {
        this.mostrarOpciones = false;
        this.mostrarFormulario = true;
    }

    guardarInfoTicket() {
        if (!this.fabricante) {
            this.mostrarToast('Error', 'Debe seleccionar un fabricante antes de guardar.', 'error');
            return;
        }

        if (!this.fechaTicket) {
            this.mostrarToast('Error', 'Debe seleccionar una fecha del ticket antes de guardar.', 'error');
            return;
        }

        console.log('Función disparada');
        //this.guardarInfoTicketSalesforce();

        this.informacionTicketNoCargada = false;
        this.informacionTicketCargada = true;
        localStorage.setItem('mostrarFormularioDeProductosTickets', true);
        this.actualizarOpcionesSegunFabricante();
        this.inicializarLevantamientosLocalStorage();
    }

    regresarAAcciones() {
        console.log('Función disparada');
        this.mostrarFormulario = false;
        this.mostrarOpciones = true;
    }

    nuevoTicket() {
        console.log('Función disparada');
        this.imagenesPreview = [];
        this.informacionTicketCargada = false;
        this.informacionTicketNoCargada = true;
    }

    redirigirResumen() {
        console.log('REDIRIGIR RSUMEN');
        this.mostrarFormulario = false;
        this.informacionTicketCargada = false;
        this.informacionTicketNoCargada = false;
        this.mostrarResumen = true;
        this.mostrarTablaResumen = true;
    }

    handleUploadFinished(event) {
        const uploadedFiles = event.detail.files;
        console.log('Archivos subidos:', uploadedFiles);

        uploadedFiles.forEach(file => {
            this.mostrarToast('CORRECTO', 'Se subieron los archivos', 'success');
            console.log('ARCHIVO CREADO: ', JSON.stringify(file));
            console.log(`Archivo: ${file.name}, ID en Salesforce: ${file.documentId}`);
        });
    }

    handleCLickFabricante() {
        console.log('Acción de despliegue de selector');
        this.mostrarSelectorFabricante = true;
    }

    handleCLickEmpaque() {
        this.mostrarSelectorEmpaque = true;
    }

    handleCLickCategoria() {
        this.mostrarSelectorCategoria = true;
    }
    handleCLickSubmarca() {
        this.mostrarSelectorSubMarca = true;
    }

    cerrarModalOpcionesRegistro() {
        this.mostrarModal = false; // Cierra el modal
        this.filaSeleccionada = null;
    }

    modificarRegistro() {
        this.mostrarResumen = false;
        this.fabricanteSeleccionado = '';
        this.mostrarModal = false;

        console.log('FILA SELECCIONADA PARA MODIFICAR: ' + this.filaSeleccionada);
        this.fabricante = this.filaSeleccionada.fabricante;
        this.codEscaneado = this.filaSeleccionada.codEscaneado;
        this.empaque = this.filaSeleccionada.empaque;
        this.categoria = this.filaSeleccionada.categoria;
        this.subMarca = this.filaSeleccionada.subMarca;
        this.cantidad = this.filaSeleccionada.cantidad;
        this.precioProd = this.filaSeleccionada.precio;
        this.key = this.identificadorSeleccionado;
        this.actualizarOpcionesSegunFabricante();

        this.informacionTicketCargada = true;
        this.mostrarFormulario = true;

    }

    regresarFormulario() {
        console.log('this.fabricanteSeleccionado: ', this.fabricanteSeleccionado);
        console.log('this.registrosSeleccionados: ', this.registrosSeleccionados);
        console.log('this.registrosSeleccionados: ', this.registrosSeleccionados);
        if (this.fabricanteSeleccionado !== '' && this.fabricanteSeleccionado !== false) {
            console.log('ENTRA EN LA VALIDACIÓN DEL FABRICANTE');
            this.fabricanteSeleccionado = '';
            this.registrosSeleccionados = [];
            this.mostrarTablaResumen = true;
        } else {
            console.log('ENTRA EN LA OTRA VALIDACIÓN');
            this.mostrarFormulario = true;
            this.informacionTicketCargada = true;
            this.mostrarResumen = false;
            this.mostrarOpciones = false;
            this.mostrarSelectorNoLevantamiento = false;
            console.log('this.mostrarResumen: ', this.mostrarResumen);
            console.log('this.mostrarFormulario: ', this.mostrarFormulario);
            console.log('this.informacionTicketCargada: ', this.informacionTicketCargada);
        }
    }

    //Funciones para cerrar el modal
    cerrarModalGeneral() {
        // Datos que quieres enviar
        const datosExtra = {
            idRegistroAActualizar: this.cliente.IdLevantamientoTickets,
            campo: 'IdLevantamientoTickets'
        };

        // Emitir evento con información adicional
        this.dispatchEvent(new CustomEvent('cerrar', {
            detail: datosExtra
        }));
    }

    cerrarModalGeneralSinAcciones() {
        this.dispatchEvent(new CustomEvent('cerrarsinacciones'));
    }


    //Funciones para cargar información.
    get options() {
        return this.picklistOptions;
    }

    get mostrarBotonParaContinuarConElLevantamiento() {
        if (this.subioImagen && navigator.onLine) {
            return true;
        }
        if (!this.subioImagen && !navigator.onLine) {
            return true;
        }
    }

    get mostrarInputImagen() {
        if (this.isOnline) {
            return true;
        } else {
            return false;
        }
    }
}