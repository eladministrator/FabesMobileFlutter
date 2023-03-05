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
        title: Text('Folio:      ${datum.folio}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Color.fromRGBO(255, 102, 0, 1))),
        subtitle: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            'Plazo:      ${datum.plazo} qnas. ',
            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
            textAlign: TextAlign.left,
          ),
          Text('Capital:   \$${formatear.format(datum.capital)}', style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15)),
          Text('Estatus:   ${datum.estatus}', style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15)),
          Text('Tipo:        ${datum.tipoDescuento}', style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15)),
          //Text('Pagado:        ${datum.pagado}', style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15)),
        ]),

        trailing: const Icon(Icons.arrow_forward_ios_rounded, color: Color.fromRGBO(255, 102, 0, 1), size: 35),
        onTap: () async {
          const storage = FlutterSecureStorage();

          final rfc = await storage.read(key: 'rfc') as String;
          final nombre = await storage.read(key: 'nombre') as String;

          debugPrint('rfc: $rfc');
          debugPrint('nombre: $nombre');

          //MisPrestamosDetalle s = MisPrestamosDetalle(idCredito: datum.id, capital: datum.capital, interes: datum.interes, fondoGarantia: datum.fg, total: datum.total, descuentoQuincenal: datum.descuentoquincenal);

          debugPrint('MisPrestamosDetalle: ${datum.id},${datum.capital}');

          // ignore: use_build_context_synchronously
          Navigator.pushNamed(context, "prestamos_detalle",
              arguments: MisPrestamosDetalle(idCredito: datum.id, capital: datum.capital, interes: datum.interes, fondoGarantia: datum.fg, total: datum.total, descuentoQuincenal: datum.descuentoquincenal, fkckmododedescuento: datum.fkckmododedescuento, saldo: datum.saldo, pagado: datum.pagado));
        },
      ),
    );
  }
}
