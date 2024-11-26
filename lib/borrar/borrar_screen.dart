import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BorrarVehiculoScreen extends StatefulWidget {
  @override
  _BorrarVehiculoScreenState createState() => _BorrarVehiculoScreenState();
}

class _BorrarVehiculoScreenState extends State<BorrarVehiculoScreen> {
  final CollectionReference _vehiculosRef =
      FirebaseFirestore.instance.collection('vehiculos');

  late TextEditingController _idController;

  @override
  void initState() {
    super.initState();
    _idController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Borrar Vehículo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _idController,
              decoration: InputDecoration(
                labelText: 'ID del vehículo a borrar',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _borrarVehiculo();
              },
              child: Text('Borrar'),
            ),
          ],
        ),
      ),
    );
  }

  void _borrarVehiculo() async {
    String id = _idController.text.trim();

    if (id.isNotEmpty) {
      try {
        await _vehiculosRef.doc(id).delete();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Vehículo borrado correctamente'),
            duration: Duration(seconds: 2),
          ),
        );
        _idController.clear();
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al borrar el vehículo: $error'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Por favor ingresa el ID del vehículo a borrar'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  void dispose() {
    _idController.dispose();
    super.dispose();
  }
}

class CollectionReference {
}

class FirebaseFirestore {
  static var instance;
}