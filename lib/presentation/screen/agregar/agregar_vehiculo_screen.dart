import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AgregarVehiculoScreen extends StatefulWidget {
  @override
  _AgregarVehiculoScreenState createState() => _AgregarVehiculoScreenState();
}

class _AgregarVehiculoScreenState extends State<AgregarVehiculoScreen> {
  final CollectionReference _vehiculosRef =
      FirebaseFirestore.instance.collection('vehiculos');
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _marcaController = TextEditingController();
  final TextEditingController _modeloController = TextEditingController();
  final TextEditingController _anioController = TextEditingController();
  final TextEditingController _precioController = TextEditingController();
  final TextEditingController _fotoUrlController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agregar Vehículo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _marcaController,
                decoration: InputDecoration(labelText: 'Marca'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor ingresa la marca del vehículo';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _modeloController,
                decoration: InputDecoration(labelText: 'Modelo'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor ingresa el modelo del vehículo';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _anioController,
                decoration: InputDecoration(labelText: 'Año'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor ingresa el año del vehículo';
                  }
                  try {
                    int.parse(value);
                    return null; // Valid year format
                  } catch (e) {
                    return 'El año debe ser un número válido';
                  }
                },
              ),
              TextFormField(
                controller: _precioController,
                decoration: InputDecoration(labelText: 'Precio'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor ingresa el precio del vehículo';
                  }
                  try {
                    double.parse(value);
                    return null; // Valid price format
                  } catch (e) {
                    return 'El precio debe ser un número válido';
                  }
                },
              ),
              TextFormField(
                controller: _fotoUrlController,
                decoration: InputDecoration(labelText: 'URL de la foto'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor ingresa la URL de la foto del vehículo';
                  }
                  // Validar la URL de la foto (opcional)
                  return null;
                },
              ),
              const SizedBox(height: 20),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _guardarVehiculo(context);
                  }
                },
                child: Text('Guardar'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _guardarVehiculo(BuildContext context) async {
    try {
      // Crea un mapa con la información del vehículo
      Map<String, dynamic> vehiculo = {
        'marca': _marcaController.text,
        'modelo': _modeloController.text,
        'anio': int.parse(_anioController.text),
        'precio': double.parse(_precioController.text),
        'fotoUrl': _fotoUrlController.text,
      };

      // Agrega el vehículo a Cloud Firestore usando async/await para mayor claridad
      await _vehiculosRef.add(vehiculo);

      // Limpiar los campos del formulario y mostrar un mensaje de éxito
      _marcaController.clear();
      _modeloController.clear();
      _anioController.clear();
      _precioController.clear();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Vehículo guardado correctamente'),
          duration: Duration(seconds: 2),
        ),
      );
    } on FirebaseException catch (error) {
      // Manejar excepciones específicas de Firebase (por ejemplo, permiso denegado)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al guardar el vehículo: ${error.message}'),
          duration: Duration(seconds: 2),
        ),
      );
    } catch (error) {
      // Manejar otras excepciones que no sean de Firebase (por ejemplo, errores de análisis)
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error al guardar el vehículo: $error'),
        duration: Duration(seconds: 2),
      ));
    }
    ;
  }
}
