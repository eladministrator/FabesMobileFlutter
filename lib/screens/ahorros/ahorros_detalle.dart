import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

// Importaciones locales del proyecto
import 'package:fabes/arguments/bearer_args.dart';
import 'package:fabes/providers/bearer_providers.dart';
import 'package:fabes/widgets/bearer_widgets.dart';

class AhorrosDetalleScreen extends StatefulWidget {
  const AhorrosDetalleScreen({Key? key}) : super(key: key);
  @override
  State<AhorrosDetalleScreen> createState() => _AhorrosDetalleScreenState();
}

class _AhorrosDetalleScreenState extends State<AhorrosDetalleScreen> {
  var formatear = NumberFormat('###,###.00', 'en_US');
  @override
  Widget build(BuildContext context) {
    final AhorrosDetalleArgs args = ModalRoute.of(context)!.settings.arguments as AhorrosDetalleArgs;
    return Scaffold(
        appBar: AppBar(
          title: const Text('Regresar a inicio'),
          backgroundColor: const Color.fromRGBO(255, 102, 0, 1),
        ),
        backgroundColor: Colors.brown[100],
        body: BackgroundWidget(
            topLogo: 17,
            topChild2: 100,
            child2: Column(
              children: [
                Center(
                  widthFactor: 1.5,
                  child: Text(
                    args.nombre,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.brown),
                  ),
                ),
                Center(
                    child: Text(
                  args.rfc,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, fontFamily: 'Roboto', color: Colors.brown),
                ))
              ],
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 150),
                  CardContainer(
                      child: Column(
                    children: [
                      const SizedBox(height: 10),

                      Text('Detalle de ahorros', style: TextStyle(color: Colors.brown[900], fontSize: 20)),
                      const SizedBox(height: 10),
                      Text('Total ahorrado: \$${formatear.format(double.tryParse(args.totalAhorrado))}', style: TextStyle(color: Colors.brown[900], fontSize: 17, fontWeight: FontWeight.w600)),

                      // Manejo de estado
                      ChangeNotifierProvider(
                        create: (context) => GridAhorrosProvider(),
                        child: Consumer<GridAhorrosProvider>(builder: (context, provider, child) {
                          // ignore: unnecessary_null_comparison
                          if (provider.data == null) {
                            provider.getData(context, args.idEmpleo);
                            return const Center(child: CircularProgressIndicator());
                          }
                          return SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: DataTable(
                                dividerThickness: 1,
                                dataRowHeight: 18,
                                columnSpacing: 10,
                                columns: const [
                                  DataColumn(
                                      label: Text(
                                    'Qna.',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 17),
                                  )),
                                  DataColumn(
                                      label: Text(
                                    'Mov.',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 17),
                                  )),
                                  DataColumn(
                                      label: Text(
                                        'Monto',
                                        style: TextStyle(fontWeight: FontWeight.w500, fontSize: 17),
                                      ),
                                      numeric: true),
                                  DataColumn(
                                      label: Text(
                                        'Interés',
                                        style: TextStyle(fontWeight: FontWeight.w500, fontSize: 17),
                                      ),
                                      numeric: true)
                                ],
                                rows: provider.data!.data
                                    .map((data) => DataRow(cells: [
                                          DataCell(Text(data.quincena.toString(), style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 15, color: Colors.black))),
                                          DataCell(Text(data.tipo.substring(0, (data.tipo.length >= 10 ? 10 : data.tipo.length)), style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 15, color: Colors.brown))),
                                          DataCell(Text('\$${formatear.format(double.tryParse(data.monto.toString()))}', style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 15))),
                                          DataCell(Text('\$${formatear.format(double.tryParse(data.interes.toString()))}', style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 15)))
                                        ]))
                                    .toList()),
                          );
                        }),
                        //child: const _InicioForm(),
                      ),

                      const SizedBox(height: 10),
                    ],
                  )),
                ],
              ),
            )));
  }
}
