import { api, LightningElement, track } from 'lwc';
import { getBarcodeScanner } from 'lightning/mobileCapabilities';
import { createRecord, getRecord, updateRecord } from 'lightning/uiRecordApi';
import LOGO from '@salesforce/resourceUrl/iconoGuardar';
import LOGO2 from '@salesforce/resourceUrl/iconoResumen';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import PRODUCTO_LEVANTAMIENTO_OBJECT from '@salesforce/schema/Producto_de_Levantamiento__c';
import CANTIDAD_FIELD from '@salesforce/schema/Producto_de_Levantamiento__c.Cantidad__c';
import CATEGORIA_FIELD from '@salesforce/schema/Producto_de_Levantamiento__c.Categoria__c';
import CODIGO_BARRAS_FIELD from '@salesforce/schema/Producto_de_Levantamiento__c.Codigo_de_Barras__c';
import EMPAQUE_FIELD from '@salesforce/schema/Producto_de_Levantamiento__c.Empaque__c';
import FABRICANTE_FIELD from '@salesforce/schema/Producto_de_Levantamiento__c.Fabricante__c';
import LEVANTAMIENTO_FIELD from '@salesforce/schema/Producto_de_Levantamiento__c.Levantamiento__c';
import SUBMARCA_FIELD from '@salesforce/schema/Producto_de_Levantamiento__c.Submarca__c';

export default class RicaLevantamientoInventario extends LightningElement {
    mostrarSelectorFabricante = false;
    mostrarSelectorEmpaque = false;
    mostrarSelectorCategoria = false;
    mostrarSelectorSubMarca = false;
    @track opcionesEmpaqueFiltradas = [];
    @track opcionesCategoriaFiltradas = [];
    @track opcionesSubMarcaFiltradas = [];
    @track mostrarModal = false;
    @track filaSeleccionada = null;

    barcodeScanner;
    @track scannedBarcodes;
    @track codEscaneado = '';
    @track empaque = '';
    @track fabricante = '';
    @track categoria = '';
    @track subMarca = '';
    @track cantidad = '';
    @track fabricanteSeleccionado = '';
    @track opcionesFabricanteFiltradas = [];

    @track opcionesFabricante = [];
    @track opcionesEmpaque = [];
    @track opcionesCategoria = [];
    @track opcionesSubMarca = [];


    @api cliente;

    urlIconoGuardar = LOGO;
    urlIconoResumen = LOGO2;

    mostrarFormulario = true;
    @track conteoRegistros = []; // Array para la tabla

    connectedCallback() {
        this.guardarFechaInicio();
        this.barcodeScanner = getBarcodeScanner();
        if (this.cliente === '' || this.cliente === null) {
            console.log('Recuperando el cliente');
            this.cliente = localStorage.getItem('clienteSeleccionado');
        }
        //this.cargarOpciones();
        localStorage.setItem('clienteSeleccionado', JSON.stringify(this.cliente));
        const registrosCache = localStorage.getItem('registrosPorFabricante');
        if (registrosCache) {
            this.registrosPorFabricante = JSON.parse(registrosCache);
            this.mostrarToast('CORRECTO', 'Se restauraron tus registros', 'success');
            this.obtenerConteoRegistros();
        }
        this.cargarFabricantesDesdeLocalStorage();
        this.cargaOpcionesFabricantesDesdeLocalStorage();
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
    leerFabricantesDesdeLocalStorage() {
        const datos = localStorage.getItem('fabricantes');
        if (datos) {
            const lista = JSON.parse(datos);
            return lista.map(fab => ({ label: fab, value: fab }));
        }
        return [];
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

    /*cargarOpciones() {
        console.log('OBTENIENDO LAS OPCIONES DE LOS SELECTOREEES');
        obtenerOpciones()
            .then((data) => {
                console.log('OPCIONES DE LOS SELECTOREEES', data);
                if (data) {
                    this.opcionesFabricante = this.formatearOpciones(data.Fabricantes);
                    this.opcionesFabricanteFiltradas = this.opcionesFabricante;
                    this.opcionesEmpaque = this.formatearOpciones(data.Empaques);
                    this.opcionesEmpaqueFiltradas=this.opcionesEmpaque;
                    this.opcionesCategoria = this.formatearOpciones(data.Categorias);
                    this.opcionesCategoriaFiltradas = this.opcionesCategoria;
                    this.opcionesSubMarca = this.formatearOpciones(data.Submarcas);
                    this.opcionesSubMarcaFiltradas = this.opcionesSubMarca;
                }
                console.log('CATEGORIAAAAAAAAAS: ',this.opcionesCategoria);
            })
            .catch((error) => {
                console.error('Error al obtener opciones:', error);
                this.mostrarToast('ERROR', 'Error al cargar opciones.', 'error');
            });
    }*/

    formatearOpciones(lista) {
        console.log('LISTA QUE LLEGA AL FORMATEADOR: ', lista);
        if (!lista || lista.length === 0) {
            return [{ label: 'No disponible', value: '' }];
        }
        return [{ label: 'Elige una opción...', value: '' },
        ...lista.map(item => ({ label: item, value: item }))];
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

    handleChangeInputCodigoBarras(event) {
        this.codEscaneado = event.target.value;
        console.log('Nuevo código escaneado:', this.codEscaneado);
    }

    handleCLickFabricante() {
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

    handleChange(event) {
        const fieldName = event.target.dataset.field;
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

    actualizarOpcionesSegunFabricante() {
        const opciones = this.opcionesPorFabricante[this.fabricante];
        console.log('opciones: ', opciones);
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

    processError(error) {
        // Check to see if user ended scanning
        if (error.code == "USER_DISMISSED") {
            console.log("User terminated scanning session.");
        } else {
            console.error(error);
        }
    }

    /*Métodos de acción de SELECTS*/
    handleChangeFabricante(event) {
        this.fabricante = event.target.value;
    }

    handleChangeEmpaque(event) {
        this.empaque = event.target.value;
    }

    handleChangeSubMarca(event) {
        this.subMarca = event.target.value;
    }

    handleChangeCategoria(event) {
        this.categoria = event.target.value;
    }

    handleChangeCantidad(event) {
        this.cantidad = event.target.value;
    }

    get scannedBarcodesAsString() {
        return this.scannedBarcodes.map((barcode) => barcode.value).join("\n");
    }

    get opcionesFabricante() {
        return this.opcionesFabricante;
    }

    get opcionesEmpaque() {
        return this.opcionesEmpaque;
    }

    get opcionesCategoria() {
        return this.opcionesCategoria;
    }

    get opcionesSubMarca() {
        return this.opcionesSubMarca;
    }


    mostrarToast(title, message, variant) {
        this.dispatchEvent(new ShowToastEvent({ title, message, variant }));
    }

    /*obtenerValorSeleccionado(nombreCampo) {
        const elemento = this.template.querySelector(`[name="${nombreCampo}"]`);
        console.log('ELEMENTO PARA OBTENER EL VALOR: ', elemento);
        console.log('VALOR SELECCIONADO:', elemento.value);
        return elemento ? elemento.value : null;
    }*/

    guardarRegistro() {
        if (!this.fabricante) {
            this.mostrarToast('Error', 'Debe seleccionar un fabricante antes de guardar.', 'error');
            return;
        }

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

        if (!this.cantidad) {
            this.mostrarToast('Error', 'Debe de ingresar una cantidad diferente a 0 para guardar.', 'error');
            return;
        }

        const nuevoRegistro = {
            fabricante: this.fabricante,
            codEscaneado: this.codEscaneado,
            empaque: this.empaque,
            categoria: this.categoria,
            subMarca: this.subMarca,
            cantidad: this.cantidad
        };

        // Cargar registros desde localStorage si existen
        let registrosPorFabricante = JSON.parse(localStorage.getItem('registrosPorFabricante')) || {};

        // Verifica si la lista del fabricante existe, si no, la inicializa como un array vacío
        if (!Array.isArray(registrosPorFabricante[this.fabricante])) {
            registrosPorFabricante[this.fabricante] = [];
        }

        // Busca si ya existe un registro con el mismo codEscaneado
        const registros = registrosPorFabricante[this.fabricante];
        const index = registros.findIndex(reg => reg.codEscaneado === this.codEscaneado);

        if (index !== -1) {
            // Si existe, mostrar una confirmación antes de actualizar
            const confirmacion = window.confirm('Este código ya existe. ¿Desea actualizar el registro?');
            if (confirmacion) {
                registros[index] = nuevoRegistro;
            } else {
                return; // No continúa si el usuario cancela
            }
        } else {
            // Si no existe, lo agrega
            registros.push(nuevoRegistro);
        }

        // Guardar en localStorage
        localStorage.setItem('registrosPorFabricante', JSON.stringify(registrosPorFabricante));

        // Actualizar la variable local
        this.registrosPorFabricante = registrosPorFabricante;

        // Limpiar los campos
        this.fabricante = '';
        this.codEscaneado = '';
        this.empaque = '';
        this.categoria = '';
        this.subMarca = '';
        this.cantidad = '';

        // Actualizar el conteo de registros
        this.obtenerConteoRegistros();

        console.log('Registros por fabricante guardados en caché:', JSON.stringify(this.registrosPorFabricante, null, 2));
    }


    redirigirResumen() {
        this.mostrarFormulario = false;
        this.mostrarResumen = true;
        this.mostrarTablaResumen = true;
    }

    obtenerConteoRegistros() {
        // Convertir el objeto en un array [{ fabricante: 'TCC', cantidad: 10 }, ...]
        this.conteoRegistros = Object.keys(this.registrosPorFabricante).map(fabricante => {
            return {
                fabricante: fabricante,
                cantidad: this.registrosPorFabricante[fabricante].length
            };
        });

        console.log('Conteo de registros:', this.conteoRegistros);
    }

    seleccionarFabricante(event) {
        this.mostrarTablaResumen = false;
        const fabricante = event.currentTarget.dataset.fabricante;
        this.fabricanteSeleccionado = fabricante;
        this.registrosSeleccionados = this.registrosPorFabricante[fabricante] || [];
        console.log(`Registros para ${fabricante}:`, JSON.stringify(this.registrosSeleccionados, null, 2));
    }

    regresarFormulario() {
        if (this.fabricanteSeleccionado !== '') {
            this.fabricanteSeleccionado = '';
            this.registrosSeleccionados = [];
            this.mostrarTablaResumen = true;
        } else {
            this.mostrarResumen = false;
            this.mostrarFormulario = true;
        }

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


    cerrarModalOpcionesRegistro() {
        this.mostrarModal = false; // Cierra el modal
        this.filaSeleccionada = null;
    }

    eliminarRegistro() {
        const fabricante = this.filaSeleccionada.fabricante;
        const codigo = this.filaSeleccionada.codEscaneado;
        console.log('CODIGO DEL REGISTRO A ELIMINAR: ', codigo);
        console.log('FABRICANTE: ', this.fabricanteSeleccionado);

        const confirmacion = window.confirm('¿Está seguro de eliminar el registro?');

        if (confirmacion) {
            if (this.registrosPorFabricante[this.fabricanteSeleccionado]) {
                console.log('Entra a la condicional de la lista por fabricante');

                // Encontrar el índice del elemento a eliminar
                const index = this.registrosPorFabricante[this.fabricanteSeleccionado].findIndex(
                    item => item.codEscaneado === codigo
                );

                // Si el índice es válido, eliminar el elemento directamente
                if (index !== -1) {
                    console.log('INDEX: ', index);
                    this.registrosPorFabricante[this.fabricanteSeleccionado].splice(index, 1);
                }

                // Si no quedan registros en ese fabricante, lo eliminamos del objeto
                if (this.registrosPorFabricante[this.fabricanteSeleccionado].length === 0) {
                    delete this.registrosPorFabricante[this.fabricanteSeleccionado];
                }
            }
            this.obtenerConteoRegistros();
            console.log('REGISTRO ELIMINADO: ', this.registrosPorFabricante);
        }

        this.cerrarModalOpcionesRegistro(); // Cerrar el modal después de eliminar
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

        this.mostrarFormulario = true;


    }

    async guardarFechaInicio() {
        const fields = {
            Id: this.cliente.id,
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

    /*subirDatos() {
        if (!this.registrosPorFabricante || Object.keys(this.registrosPorFabricante).length === 0) {
            this.mostrarToast('Error', 'No hay registros para subir.', 'error');
            return;
        }
    
        let registrosAGuardar = [];
    
        // Recorrer los fabricantes
        for (const fabricante in this.registrosPorFabricante) {
            if (this.registrosPorFabricante.hasOwnProperty(fabricante)) {
                const registros = this.registrosPorFabricante[fabricante];
    
                // Recorrer cada registro dentro del fabricante
                registros.forEach((registro) => {
                    const fields = {
                        Name: registro.empaque,
                        Cantidad__c: parseInt(registro.cantidad),
                        Categoria__c: registro.categoria,
                        Codigo_de_Barras__c: registro.codEscaneado,
                        Empaque__c: registro.empaque,
                        Fabricante__c: registro.fabricante,
                        Levantamiento__c: this.cliente.id,
                        Submarca__c: registro.subMarca
                    };
    
                    const recordInput = { apiName: 'Producto_de_Levantamiento__c', fields };
    
                    registrosAGuardar.push(recordInput);
                });
            }
        }
    
        /*if (!navigator.onLine) {
            // Si no hay conexión, guardar en caché
            localStorage.setItem('registrosPendientes', JSON.stringify(registrosAGuardar));
            localStorage.removeItem('registrosPorFabricante');
            this.mostrarToast('Información', 'No hay conexión. Los registros se guardarán localmente.', 'info');
            this.cerrarModalGeneral();
            return;
        }*/

    /*if (!navigator.onLine) {
        // Obtener registros existentes del localStorage
        const registrosExistentes = JSON.parse(localStorage.getItem('registrosPendientes')) || [];
    
        // Agregar los nuevos registros a los existentes
        const registrosActualizados = registrosExistentes.concat(registrosAGuardar);
    
        // Guardar la lista actualizada en el localStorage
        localStorage.setItem('registrosPendientes', JSON.stringify(registrosActualizados));
    
        // Eliminar los levantamientos de tickets si es necesario
        localStorage.removeItem('registrosPorFabricante');
    
        this.mostrarToast('Información', 'No hay conexión. Los registros se guardarán localmente.', 'info');
        this.cerrarModalGeneral();
        return;
    }
    
 
    // Intentar guardar cada registro en Salesforce
    let registrosExitosos = 0;
    let registrosFallidos = 0;
 
    registrosAGuardar.forEach((recordInput) => {
        createRecord(recordInput)
            .then(() => {
                registrosExitosos++;
                this.mostrarToast('Éxito', 'Registro guardado correctamente.', 'success');
            })
            .catch((error) => {
                registrosFallidos++;
                console.error('Error al guardar registro:', error);
                this.mostrarToast('Error', 'Hubo un error al guardar un registro.', 'error');
 
                // Guardar en caché los registros que fallaron
                let registrosFallidosGuardados = JSON.parse(localStorage.getItem('registrosPendientes')) || [];
                registrosFallidosGuardados.push(recordInput);
                localStorage.setItem('registrosPendientes', JSON.stringify(registrosFallidosGuardados));
            });
    });
    localStorage.removeItem('registrosPorFabricante');
    this.cerrarModalGeneral();
}*/


    subirDatos() {
        if (!this.registrosPorFabricante || Object.keys(this.registrosPorFabricante).length === 0) {
            this.mostrarToast('Error', 'No hay registros para subir.', 'error');
            return;
        }

        let registrosAGuardar = [];

        // Recorrer los fabricantes
        for (const fabricante in this.registrosPorFabricante) {
            if (this.registrosPorFabricante.hasOwnProperty(fabricante)) {
                const registros = this.registrosPorFabricante[fabricante];

                registros.forEach((registro) => {
                    const fields = {
                        Name: registro.empaque,
                        Cantidad__c: parseInt(registro.cantidad),
                        Categoria__c: registro.categoria,
                        Codigo_de_Barras__c: registro.codEscaneado,
                        Empaque__c: registro.empaque,
                        Fabricante__c: registro.fabricante,
                        Levantamiento__c: this.cliente.id,
                        Submarca__c: registro.subMarca
                    };

                    const recordInput = { apiName: 'Producto_de_Levantamiento__c', fields };
                    registrosAGuardar.push(recordInput);
                });
            }
        }

        if (!navigator.onLine) {
            const registrosExistentes = JSON.parse(localStorage.getItem('registrosPendientes')) || [];
            const registrosActualizados = registrosExistentes.concat(registrosAGuardar);
            localStorage.setItem('registrosPendientes', JSON.stringify(registrosActualizados));
            localStorage.removeItem('registrosPorFabricante');
            this.mostrarToast('Información', 'No hay conexión. Los registros se guardarán localmente.', 'info');
            this.cerrarModalGeneral();
            return;
        }

        let registrosExitosos = 0;
        let registrosFallidos = 0;

        const promesas = registrosAGuardar.map((recordInput) => {
            return createRecord(recordInput)
                .then(() => {
                    registrosExitosos++;
                })
                .catch((error) => {
                    registrosFallidos++;
                    console.error('Error al guardar registro:', error);

                    let registrosFallidosGuardados = JSON.parse(localStorage.getItem('registrosPendientes')) || [];
                    registrosFallidosGuardados.push(recordInput);
                    localStorage.setItem('registrosPendientes', JSON.stringify(registrosFallidosGuardados));
                });
        });

        Promise.all(promesas).then(() => {
            if (registrosExitosos > 0) {
                this.mostrarToast('Correcto', `Se cargaron ${registrosExitosos} productos correctamente.`, 'success');
            }

            if (registrosFallidos > 0) {
                this.mostrarToast('Advertencia', `${registrosFallidos} registros no se pudieron guardar y fueron enviados a caché.`, 'warning');
            }

            localStorage.removeItem('registrosPorFabricante');
            this.cerrarModalGeneral();
        });
    }


    /*cerrarModalGeneral() {
        // Emitir evento para cerrar el modal
        this.dispatchEvent(new CustomEvent('cerrar'));
    }*/

    cerrarModalGeneral() {
        // Datos que quieres enviar
        const datosExtra = {
            idRegistroAActualizar: this.cliente.id,
            campo: 'id'
        };

        // Emitir evento con información adicional
        this.dispatchEvent(new CustomEvent('cerrar', {
            detail: datosExtra
        }));
    }

    cerrarModalGeneralSinAcciones() {
        this.dispatchEvent(new CustomEvent('cerrarsinacciones'));
    }
}