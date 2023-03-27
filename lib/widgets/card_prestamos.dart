import 'package:fabes/models/prestamos_card_response.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fabes/arguments/bearer_args.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class CardPrestamos extends StatelessWidget {
  // PARAMETROS PARA EL WIDGET
  // required this.folio: hace requerida como parametro para el widget la
  // variables de final String folio
  CardPrestamos({
    Key? key,
    required this.datum,
  }) : super(key: key);

  Datum datum = Datum(estatus: 'estatus', folio: 'folio', plazo: 0, capital: 0, interes: 0, fg: 0, descuentoquincenal: 0, fecha: 'fecha', quincenainicial: 0, quincenafinal: 0, total: 0, pagado: 0, saldo: 0, id: 0, fkckmododedescuento: 0, tipoDescuento: '');

  @override
  Widget build(BuildContext context) {
    var formatear = NumberFormat('###,###.00', 'en_US');

    return Card(
      margin: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
      shape: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Color.fromRGBO(255, 102, 0, 1), width: 2)),
      shadowColor: Colors.brown[300],
      elevation: 8,
      child: ListTile(
        minVerticalPadding: 15,
        //leading: FlutterLogo(size: 56.0),
        title:
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Folio: ',
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18, letterSpacing: 1),
                  textAlign: TextAlign.left,
                ),
              ),
              Expanded(
                child: Text(
                  datum.folio,
                  style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 18, letterSpacing: 1),
                  textAlign: TextAlign.right,
                ),
              )
            ],
          ),

        subtitle: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
         // Plazo
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Plazo: ',
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16, letterSpacing: 1),
                  textAlign: TextAlign.left,
                ),
              ),
              Expanded(
                child: Text(
                  '${datum.plazo} quincenas',
                  style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16, letterSpacing: 1),
                  textAlign: TextAlign.right,
                ),
              )
            ],
          ),
          //const SizedBox(height: 2),
          // Capital
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Capital: ',
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16, letterSpacing: 1),
                  textAlign: TextAlign.left,
                ),
              ),
              Expanded(
                child: Text(
                  '\$${formatear.format(datum.capital)}',
                  style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16, letterSpacing: 1),
                  textAlign: TextAlign.right,
                ),
              )
            ],
          ),
          //const SizedBox(height: 2),
          //Estatus
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Estatus: ',
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16, letterSpacing: 1),
                  textAlign: TextAlign.left,
                ),
              ),
              Expanded(
                child: Text(
                  style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16, letterSpacing: 1),
                  datum.estatus,
                  textAlign: TextAlign.right,
                ),
              )
            ],
          ),
          //const SizedBox(height: 2),
          //Tipo
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Tipo: ',
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16, letterSpacing: 1),
                  textAlign: TextAlign.left,
                ),
              ),
              Expanded(
                child: Text(
                  style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16, letterSpacing: 1),
                  datum.tipoDescuento,
                  textAlign: TextAlign.right,
                ),
              )
            ],
          ),
          // Quincena inicial
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Qna. inicial: ',
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16, letterSpacing: 1),
                  textAlign: TextAlign.left,
                ),
              ),
              Expanded(
                child: Text(
                  style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16, letterSpacing: 1),
                  datum.quincenainicial.toString(),
                  textAlign: TextAlign.right,
                ),
              )
            ],
          ),
          // Quincena inicial
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Qna. final: ',
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16, letterSpacing: 1),
                  textAlign: TextAlign.left,
                ),
              ),
              Expanded(
                child: Text(
                  style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16, letterSpacing: 1),
                  datum.quincenafinal.toString(),
                  textAlign: TextAlign.right,
                ),
              )
            ],
          ),

        ]),

        trailing: const Icon(Icons.arrow_forward_ios_rounded, color: Color.fromRGBO(255, 102, 0, 1), size: 35),
        onTap: () async {
          const storage = FlutterSecureStorage();

          final rfc = await storage.read(key: 'rfc') as String;
          final nombre = await storage.read(key: 'nombre') as String;

          debugPrint('rfc: $rfc');
          debugPrint('nombre: $nombre');

          //MisPrestamosDetalle s = MisPrestamosDetalle(idCredito: datum.id, capital: datum.capital, interes: datum.interes, fondoGarantia: datum.fg, total: datum.total, descuentoQuincenal: datum.descuentoquincenal);

          debugPrint('tipoDescuento: ${datum.tipoDescuento}');

          // ignore: use_build_context_synchronously
          Navigator.pushNamed(context, "prestamos_detalle",
              arguments: MisPrestamosDetalle(idCredito: datum.id, capital: datum.capital, interes: datum.interes, fondoGarantia: datum.fg, total: datum.total, descuentoQuincenal: datum.descuentoquincenal, fkckmododedescuento: datum.fkckmododedescuento, saldo: datum.saldo, pagado: datum.pagado, tipo: datum.tipoDescuento));
        },
      ),
    );
  }
}
