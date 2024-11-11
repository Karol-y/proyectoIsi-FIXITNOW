import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:FIXITNOW/controllers/controlador_api.dart'; // Asegúrate de que este sea el nombre correcto
import 'registroexito.dart';

class DocTrabajador extends StatefulWidget {
  const DocTrabajador({super.key});

  @override
  _DocTrabajadorState createState() => _DocTrabajadorState();
}

class _DocTrabajadorState extends State<DocTrabajador> {
  final ControladorAPI api = ControladorAPI(); // Instancia del controlador API
  String? certificadoPath;
  String? antecedentesPath;
  bool isLoading = false; // para manejar el estado de carga

  Future<void> pickDocument(String type) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'docx'], //asegúrate de que solo se permitan estos tipos
    );
     
    if (result != null && result.files.isNotEmpty) {

      print('Tipo de documento seleccionado: $type');

      PlatformFile file = result.files.first;

      print('Detalles del archivo seleccionado: ${file.toString()}');

      if(file.path != null) {
        setState(() {
          if (type == 'certificado') {
            certificadoPath = file.path; // Guarda la ruta del certificado
          } else if (type == 'antecedente') {
            antecedentesPath = file.path; // Guarda la ruta de antecedentes
          }
        });
        print('Archivo seleccionado para $type: ${file.path}');  
      } else {
        print('El archivo seleccionado no tiene una ruta válida');
      }  
    } else {
      print('Selección de archivo cancelada');
    }

    Text(certificadoPath != null ? 'Certificado seleccionado' : 'Certificado no seleccionado');
    Text(antecedentesPath != null ? 'Antecedentes seleccionados' : 'Antecedentes no seleccionados');
  }

  void _subirDocumentos() async {
    print('certificadoPath: $certificadoPath');
    print('antecedentesPath: $antecedentesPath');

    if (certificadoPath != null && antecedentesPath != null) {
      setState(() {
        isLoading = true; //comienza la carga
      });
      try {
        await api.subirDocumentos(certificadoPath!, antecedentesPath!); // Llama al método del controlador para subir documentos
        Registroexito.mostrarDialogoExitoso(context, '¡El registro ha sido exitoso!'); // Muestra el diálogo de éxito
        
        //regresa las rutas de los docs al formulario anterior
        Navigator.pop(context, {
          'certificado': certificadoPath,
          'antecedente': antecedentesPath,
        });

        setState(() {
          certificadoPath = null; //limpia la ruta del certificado
          antecedentesPath = null; //limpia la ruta de antecedentes
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error al subir documentos: $e')));
      } finally{
        setState(() {
          isLoading = false; //termina la carga
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Por favor selecciona ambos documentos.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trabajador'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Center(
              child: Text(
                'Certificado de Trabajo',
                style: TextStyle(fontSize: 18),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => pickDocument('certificado'), // Llama a pickDocument con tipo certificado
              child: const Text('Seleccionar Certificado'),
            ),
            const SizedBox(height: 20),
            const Center(
              child: Text(
                'Antecedentes Penales',
                style: TextStyle(fontSize: 18),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => pickDocument('antecedente'), // Llama a pickDocument con tipo antecedentes
              child: const Text('Seleccionar Antecedentes'),
            ),
            const SizedBox(height: 50),
            if(isLoading)//muestra el indicador de carga
              const Center(child: CircularProgressIndicator()),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Cerrar el diálogo
                  },
                  child: const Text('Atrás'),
                ),
                ElevatedButton(
                  onPressed: isLoading ? null : _subirDocumentos, // Llama al método para subir documentos
                  child: const Text('Registrarse'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}