import { LightningElement, api } from 'lwc';
import { updateRecord } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class RicaLevantamientoPerfilCategorias extends LightningElement {

    @api cliente;

    //variable del valor seleccionado del motivo de no levantamiento
    motivoNoLevantamiento = '';
    opcionesCategorias = [];
    opcionesCategoriasConfiteria = [];

    connectedCallback() {
        // Cargar valores de categorías del localStorage
        try {
            const stored = localStorage.getItem('categoriasManjenatesEncuesta');
            if (stored) {
                this.opcionesCategorias = JSON.parse(stored);
                console.log('Valores del picklist cargados desde localStorage:', this.opcionesCategorias);
            } else {
                console.warn(`No se encontraron valores en localStorage con la clave: ${STORAGE_KEY}`);
            }
        } catch (e) {
            console.error('Error al leer localStorage:', e);
        }

        // Cargar valores de categorías de confiteria del localStorage
        try {
            const stored = localStorage.getItem('categoriasConfiteriaEncuesta');
            if (stored) {
                this.opcionesCategoriasConfiteria = JSON.parse(stored);
                console.log('Valores del picklist cargados desde localStorage:', this.opcionesCategoriasConfiteria);
            } else {
                console.warn(`No se encontraron valores en localStorage con la clave: ${STORAGE_KEY}`);
            }
        } catch (e) {
            console.error('Error al leer localStorage:', e);
        }
        console.log('REGISTRO DE CLIENTE QUE LLEGA A LA ENCUESTA: ', this.cliente);
        this.guardarFechaInicio();
    }


    async guardarFechaInicio() {
        const fields = {
            Id: this.cliente.IdLevantamientoPerfil,
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

    async guardarEncuesta() {
        // Categorías de abarrotes
        const categorias = [...this.template.querySelectorAll('input[name="categorias"]:checked')]
            .map(input => input.value);

        // Categorías de confitería
        const confiterias = [...this.template.querySelectorAll('input[name="confiterias"]:checked')]
            .map(input => input.value);

        // Bebidas alcohólicas (Sí o No)
        const bebidasAlcoholicas = this.template.querySelector('input[name="bebidasAlcoholicas"]:checked')?.value;

        // Porcentaje de ventas alcohólicas (Sí o No)
        const porcentajeVentas = this.template.querySelector('input[name="porcentajeVentas"]:checked')?.value;

        // Puedes hacer lo que necesites con los datos:
        console.log('Categorías:', categorias);
        console.log('Confiterías:', confiterias);
        console.log('¿Maneja bebidas alcohólicas?:', bebidasAlcoholicas === 'true');
        console.log('¿Más del 50% de ventas son bebidas alcohólicas?:', porcentajeVentas === 'true');

        if (categorias == '' || confiterias == '' ||
            (bebidasAlcoholicas == null || porcentajeVentas == null)) {
            this.mostrarToast('Error', 'Contesta la encuesta para continuar', 'error');
            return;
        }

        const fields = {
            Id: this.cliente.IdLevantamientoPerfil,
            Categorias_de_Abarrotes_Manejantes__c: categorias.join(';'),
            Categorias_de_Confiteria_Manejantes__c: confiterias.join(';'),
            p50_ventas_en_bebidas_alcoholicas__c: bebidasAlcoholicas === 'true',
            Maneja_bebidas_alcoholicas__c: porcentajeVentas === 'true',

        };

        console.log('REGISTRO A ACTUALIZAR: ', fields);
        const recordInput = { fields };
        // Verificar si hay conexión
        if (navigator.onLine) {
            // Si hay conexión, actualizar en Salesforce
            //await updateRecord(recordInput);
            try {
                await updateRecord(recordInput);

                this.mostrarToast('Correcto', 'Se envió la información de la encuesta.', 'success');

            } catch (error) {
                console.error('Error al actualizar el registro:', error);

                this.mostrarToast('Error', 'No se envió la información de la encuesta.', 'error');
            }
            //console.log('REGISTRO ACTUALIZADO: ', this.clienteSeleccionado.idRegistroARelacionarArchivos);
        } else {
            // Si no hay conexión, guardar en caché para actualizar después
            let registrosPendientes = JSON.parse(localStorage.getItem('registrosAActualizar')) || [];
            registrosPendientes.push(recordInput);
            localStorage.setItem('registrosAActualizar', JSON.stringify(registrosPendientes));
            this.mostrarToast('Información', 'No hay conexión. Los registros se guardarán localmente.', 'info');
            console.log('Registro almacenado en caché:', recordInput);
        }

        this.cerrarModalGeneral();

    }

    mostrarToast(title, message, variant) {
        this.dispatchEvent(new ShowToastEvent({ title, message, variant }));
    }

    cerrarModalGeneral() {
        // Datos que quieres enviar
        const datosExtra = {
            idRegistroAActualizar: this.cliente.IdLevantamientoPerfil,
            campo: 'IdLevantamientoPerfil'
        };

        // Emitir evento con información adicional
        this.dispatchEvent(new CustomEvent('cerrar', {
            detail: datosExtra
        }));
    }

    cerrarModalGeneralSinAcciones() {
        console.log('Cerrando modal sin acciones');
        this.dispatchEvent(new CustomEvent('cerrarsinacciones'));
    }
}