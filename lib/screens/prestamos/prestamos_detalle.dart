import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
// Importaciones locales del proyecto
import 'package:fabes/arguments/bearer_args.dart';
import 'package:fabes/providers/bearer_providers.dart';
import 'package:fabes/widgets/bearer_widgets.dart';

import '../../providers/grid_rechazos_provider.dart';

class PrestamosDetalleScreen extends StatefulWidget {
  const PrestamosDetalleScreen({Key? key}) : super(key: key);
  @override
  State<PrestamosDetalleScreen> createState() => _PrestamosDetalleScreenState();
}

class _PrestamosDetalleScreenState extends State<PrestamosDetalleScreen> {
  @override
  Widget build(BuildContext context) {
    final MisPrestamosDetalle args = ModalRoute.of(context)!.settings.arguments as MisPrestamosDetalle;
    // ignore: unused_local_variable
    var formatear = NumberFormat('###,###.00', 'en_US');
    final pantalla = MediaQuery.of(context).size;



    return MaterialApp(
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
            appBar: AppBar(
              leading: BackButton(
                  color: Colors.white,
                  onPressed: () {
                    Navigator.of(context).pop();
                  }),
              //automaticallyImplyLeading: true,
              elevation: 10,
              bottom: TabBar(
                indicatorWeight: 3,
                indicatorPadding: EdgeInsets.all(10),
                indicatorColor: Colors.white,
                tabs: [
                  //Tab(icon: Icon(Icons.credit_card)),
                  const Tab(text: 'Resumen', icon: Icon(Icons.credit_card)),
                  const Tab(text: 'Pagos', icon: Icon(Icons.payments)),
                  if ( args.tipo != 'NOMINA')
                   const Tab(text: 'Rechazos', icon: Icon(Icons.developer_board_off_outlined, color: Colors.white))
                ],
              ),
              title: const Text('Regresar a Prestamos'),
              backgroundColor: const Color.fromRGBO(255, 102, 0, 1),
            ),
            backgroundColor: Colors.brown[100],
            body: TabBarView(
              children: [
                // TAB 1: Tarjeta del Prestamo
                BackgroundWidget(
                  topLogo: 30, // ajusta el top del logotipo
                  topChild2: 120, // ajusta el top de la tarjeta
                  child2: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: SizedBox(
                          height: 245, // Alto de la tarjeta de los prestamos
                          width: pantalla.width, // Ancho de la tarjeta de prestamos
                          child: Card(
                            margin: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
                            shape: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Color.fromRGBO(255, 102, 0, 1), width: 2)),
                            shadowColor: Colors.brown[300],
                            elevation: 8,
                            child: ListTile(
                              title: const Padding(
                                padding: EdgeInsets.only(top: 10, bottom: 10, left: 10),
                                child: Text('Detalle del Préstamo', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Color.fromRGBO(255, 102, 0, 1))),
                              ),
                              subtitle: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
                                        '\$${formatear.format(args.capital)}',
                                        style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16, letterSpacing: 1),
                                        textAlign: TextAlign.right,
                                      ),
                                    )
                                  ],
                                ),
                                const SizedBox(height: 2),
                                Row(
                                  children: [
                                    const Expanded(
                                      child: Text(
                                        'Interés: ',
                                        style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16, letterSpacing: 1),
                                        textAlign: TextAlign.left,
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        '\$${formatear.format(args.interes)}',
                                        style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16, letterSpacing: 1),
                                        textAlign: TextAlign.right,
                                      ),
                                    )
                                  ],
                                ),
                                const SizedBox(height: 2),
                                Row(
                                  children: [
                                    const Expanded(child: Text('Fdo. garantía:', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16, letterSpacing: 1))),
                                    Expanded(child: Text('\$${formatear.format(args.fondoGarantia)}', textAlign: TextAlign.right, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16, letterSpacing: 1)))
                                  ],
                                ),
                                const SizedBox(height: 2),
                                const Divider(
                                  color: Colors.orange,
                                  thickness: 1,
                                ),
                                //Text('Interes:    \$${formatear.format(args.interes)}', style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15)),
                                Row(
                                  children: [
                                    const Expanded(
                                      child: Text('Total:', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16, letterSpacing: 1)),
                                    ),
                                    Expanded(
                                      child: Text('\$${formatear.format(args.total)}', textAlign: TextAlign.right, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16, letterSpacing: 1)),
                                    )
                                  ],
                                ),
                                const SizedBox(height: 20),
                                const Divider(
                                  color: Colors.orange,
                                  thickness: 1,
                                ),
                                Row(
                                  children: [
                                    const Expanded(
                                      child: Text('Des. quincenal:', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16, letterSpacing: 1)),
                                    ),
                                    Expanded(
                                      child: Text('\$${formatear.format(args.descuentoQuincenal)}', textAlign: TextAlign.right, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16, letterSpacing: 1)),
                                    )
                                  ],
                                )
                              ]),
                              trailing: const Icon(Icons.monetization_on, color: Color.fromRGBO(255, 102, 0, 1), size: 45),
                              onTap: () async {
                                ////debugPrint('${args.capital}, ${args.idCredito}');
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  child: const SizedBox(height: 95),
                ),
                // TAB 2: Detalle de los pagos
                Stack(
                  alignment: AlignmentDirectional.topCenter,
                  children: [
                    const ContenedorColor(),
                    Positioned(
                      top: 30,
                      child: Image.asset('assets/fabes_master.png', height: 70),
                    ),
                    // const SizedBox(height: 115),
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          // Ajusta el de la tarjeta con el detalle
                          const SizedBox(height: 115),
                          CardContainer(
                              child: Column(
                            children: [
                              const SizedBox(height: 15),
                              Text('Detalle de Prestamos', style: TextStyle(color: Colors.brown[900], fontWeight: FontWeight.bold, fontSize: 20)),
                              const SizedBox(height: 20),
                              Row(
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 0),
                                      child: Text(
                                        'Pagado: ',
                                        textAlign: TextAlign.end,
                                        style: TextStyle(color: Colors.brown[900], fontWeight: FontWeight.bold, fontSize: 18),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(right: 30),
                                      child: Text(
                                        '\$${formatear.format(args.pagado)}',
                                        textAlign: TextAlign.end,
                                        style: TextStyle(color: Colors.brown[900], fontWeight: FontWeight.bold, fontSize: 18),
                                      ),
                                    ),
                                  )
                                ],
                              ),

                              Row(
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 0),
                                      child: Text(
                                        'Saldo: ',
                                        textAlign: TextAlign.end,
                                        style: TextStyle(color: Colors.brown[900], fontWeight: FontWeight.bold, fontSize: 18),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(right: 30),
                                      child: Text(
                                        '\$${formatear.format(args.saldo)}',
                                        textAlign: TextAlign.end,
                                        style: TextStyle(color: Colors.brown[900], fontWeight: FontWeight.bold, fontSize: 18),
                                      ),
                                    ),
                                  )
                                ],
                              ),

                              //Text('Saldo \$${formatear.format(args.saldo)}', style: TextStyle(color: Colors.brown[900], fontWeight: FontWeight.bold, fontSize: 20)),

                              // Manejo de estado
                              ChangeNotifierProvider(
                                create: (context) => GridPagosProvider(),
                                child: Consumer<GridPagosProvider>(builder: (context, provider, child) {
                                  // ignore: unnecessary_null_comparison
                                  if (provider.data == null) {
                                    provider.getData(context, args.idCredito);
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
                                            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
                                          )),
                                          DataColumn(
                                              label: Text(
                                            'Movimiento',
                                            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
                                          )),
                                          DataColumn(
                                              label: Text(
                                                'Monto',
                                                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
                                              ),
                                              numeric: true)
                                        ],
                                        rows: provider.data!.data
                                            .map((data) => DataRow(cells: [
                                                  DataCell(Text(data.quincenadeaplicacion.toString(), style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 17))),
                                                  DataCell(Text(data.nombre.substring(0, (data.nombre.length <= 12 ? data.nombre.length : 12)), style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 17, color: Colors.brown))),
                                                  DataCell(Text('\$${formatear.format(data.descuentototal)}', style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 17))),
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
                    ),
                  ],
                ),
                // TAB 3: Detalle de los rechazos
                Stack(
                  alignment: AlignmentDirectional.topCenter,
                  children: [
                    const ContenedorColor(),
                    Positioned(
                      top: 30,
                      child: Image.asset('assets/fabes_master.png', height: 70),
                    ),
                    SingleChildScrollView(
                      // padding: const EdgeInsets.only(top: 120),
                      child: Column(
                        //verticalDirection: VerticalDirection.up,
                        children: [
                          // Ajusta el de la tarjeta con el detalle
                          const SizedBox(height: 115),
                          CardContainer(
                              child: Column(
                            //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              const SizedBox(height: 10),
                              Text('Detalle de Rechazos', style: TextStyle(color: Colors.brown[900], fontWeight: FontWeight.bold, fontSize: 20)),
                              // Manejo de estado
                              if (args.fkckmododedescuento == 2)
                                ChangeNotifierProvider(
                                  create: (context) => GridRechazosProvider(),
                                  child: Consumer<GridRechazosProvider>(builder: (context, provider, child) {
                                    // ignore: unnecessary_null_comparison
                                    if (provider.data == null) {
                                      provider.getData(context, args.idCredito);
                                      return const Center(
                                          child: CircularProgressIndicator(
                                        color: Colors.orange,
                                      ));
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
                                              'Fecha.',
                                              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
                                            )),
                                            DataColumn(
                                                label: Text(
                                              'Movimiento',
                                              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
                                            )),
                                            DataColumn(
                                                label: Text(
                                                  'Monto',
                                                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
                                                ),
                                                numeric: true)
                                          ],
                                          rows: provider.data!.data
                                              .map((data) => DataRow(cells: [
                                                    DataCell(Text(data.fecha, style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 17))),
                                                    DataCell(Text(data.nombre.substring(0, (data.nombre.length <= 12 ? data.nombre.length : 12)), style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 17, color: Colors.brown))),
                                                    DataCell(Text('\$${formatear.format(data.monto)}', style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 17))),
                                                  ]))
                                              .toList()),
                                    );
                                  }),
                                  //child: const _InicioForm(),
                                ),
                              if (args.fkckmododedescuento == 1)
                                Padding(
                                  padding: const EdgeInsets.only(top: 30, left: 10, right: 10, bottom: 20),
                                  child: Text('No se cuenta con pagos rechazados.',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.brown[900],
                                        fontSize: 20,
                                      )),
                                ),
                              const SizedBox(height: 10),
                            ],
                          )),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            )),
      ),
    );
  }
}
