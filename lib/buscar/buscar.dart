import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BuscarVehiculoScreen extends StatefulWidget {
  @override
  _BuscarVehiculoScreenState createState() => _BuscarVehiculoScreenState();
}

class _BuscarVehiculoScreenState extends State<BuscarVehiculoScreen> {
  final CollectionReference _vehiculosRef =
      FirebaseFirestore.instance.collection('vehiculos');

  late TextEditingController _marcaController;
  String _marca = '';

  @override
  void initState() {
    super.initState();
    _marcaController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Buscar Vehículo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _marcaController,
              decoration: InputDecoration(
                labelText: 'Buscar por marca',
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    setState(() {
                      _marca = _marcaController.text.trim();
                    });
                  },
                ),
              ),
            ),
            SizedBox(height: 20),
            _marca.isNotEmpty
                ? Expanded(
                    child: StreamBuilder<QuerySnapshot>(
                      stream: _vehiculosRef
                          .where('marca', isEqualTo: _marca)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (snapshot.hasError) {
                          return Center(
                            child: Text('Error: ${snapshot.error}'),
                          );
                        }
                        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                          return Center(
                            child: Text('No se encontraron vehículos'),
                          );
                        }
                        return ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            var vehiculo =
                                snapshot.data!.docs[index].data() as Map;
                            return ListTile(
                              title: Text(
                                '${vehiculo['marca']} ${vehiculo['modelo']} (${vehiculo['anio']})',
                              ),
                              subtitle: Text('\$${vehiculo['precio']}'),
                              leading: Image.network(vehiculo['fotoUrl']),
                            );
                          },
                        );
                      },
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _marcaController.dispose();
    super.dispose();
  }
}