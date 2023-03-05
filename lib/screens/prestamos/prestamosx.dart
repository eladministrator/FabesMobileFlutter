import 'package:fabes/models/prestamos_card_response.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// Importaciones locales del proyecto
import 'package:fabes/widgets/bearer_widgets.dart';

class PrestamosxScreen extends StatefulWidget {
  const PrestamosxScreen({Key? key}) : super(key: key);

  @override
  State<PrestamosxScreen> createState() => _PrestamosxScreenState();
}

class _PrestamosxScreenState extends State<PrestamosxScreen> {
  String rfc = '-';
  String nombre = '-';

  @override
  void initState() {
    super.initState();

    setState(() {
      obtenerUsuarios();
    });
  }

  void obtenerUsuarios() async {
    const storage = FlutterSecureStorage();

    rfc = await storage.read(key: 'rfc') as String;
    nombre = await storage.read(key: 'nombre') as String;

    //debugPrint('rfc: $rfc');
    //debugPrint('nombre: $nombre');
  }

  @override
  Widget build(BuildContext context) {
    final List<Datum> args = ModalRoute.of(context)!.settings.arguments as List<Datum>;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Regresar a inicio'),
        backgroundColor: const Color.fromRGBO(255, 102, 0, 1),
      ),
      backgroundColor: Colors.brown[100],
      body: Stack(
        children: [
          const ContenedorColor(),
          SafeArea(top: true, minimum: const EdgeInsets.all(40), child: SizedBox(width: double.infinity, height: 73, child: Image.asset('assets/fabes_master.png'))),
          Column(
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 100, bottom: 20),
                child: Text(''),
              ),
              const Padding(
                  padding: EdgeInsets.only(top: 10, bottom: 20),
                  child: Text(
                    'Historial de Prestamos',
                    style: TextStyle(color: Color.fromRGBO(62, 39, 35, 1), fontSize: 20),
                  )),
              Expanded(
                  child: ListView.builder(
                      itemCount: args.length, // Cantidad de elementos a generar
                      prototypeItem: CardPrestamos(datum: args.first),
                      itemBuilder: (context, index) {
                        return CardPrestamos(datum: args[index]);
                      }))
            ],
          )
        ],
      ),
    );
  }
}
