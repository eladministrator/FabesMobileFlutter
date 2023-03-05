// region  [ IMPORTS ]
import 'dart:convert';
import 'dart:io';
import 'package:fabes/models/mappeed/pre_registro/capital_disponible_mapped.dart';
import 'package:fabes/models/mappeed/pre_registro/quincenas_pre_registro_data_mapped.dart';
import 'package:fabes/screens/pre_registro/pre_registro_form_provider.dart';
import 'package:fabes/providers/quincenas_validas.dart';
import 'package:fabes/screens/pre_registro/pre_registro_futures.dart';
import 'package:fabes/services/uri_constants.dart';
import 'package:fabes/theme/texts_app/global_texts_app.dart';
import 'package:fabes/utils/bearer_utils.dart';
import 'package:fabes/utils/parse_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:fabes/arguments/bearer_args.dart';
import 'package:fabes/widgets/bearer_widgets.dart';
import 'package:fabes/ui/bearer_ui.dart';
import '../../models/mappeed/pre_registro/quincenas_pre_registro_mapped.dart';
//endregion

//region [ VARIABLES ]
var data;
var listaCapitalDisponible;
String message = "";
bool error = false;
bool regresaCapital = false;
String liquido = "";
String itemValueQuincena = "";
String itemValueMonto = "";
MenssagesUI menssagesUI = MenssagesUI();
const storage = FlutterSecureStorage();
//endregion

class PreregistroScreen extends StatefulWidget {
  const PreregistroScreen({Key? key}) : super(key: key);

  @override
  State<PreregistroScreen> createState() => _PreregistroScreenState();
}

class _PreregistroScreenState extends State<PreregistroScreen> {
  // Se integra para cargar el ddl
  @override
  void initState() {
    super.initState();
    //postListaSemanas();
  }

  //Lista de capital disponible
  Future<void> postListaCapitalDisponible() async {
    MenssagesUI menssagesUI = MenssagesUI();
    try {
      error = false;
      final url = Uri.http(UriConstants.root, UriConstants.postCapitalDisponible);

      debugPrint('DP liquido: $liquido idPlazo: $itemValueQuincena');

      final Map<String, dynamic> envio = {
        'liquido': checkInt(liquido),
        'idPlazo': checkInt(itemValueQuincena)
      };

      final response = await http.post(url, body: json.encode(envio), headers: {
        "Content-Type": "application/json",
        "Accept": "application/json"
      });
      listaCapitalDisponible = json.decode(response.body);
      // Si el servicios
      if (response.statusCode == 200) {
        setState(() {
          listaCapitalDisponible = json.decode(response.body);
          debugPrint('DP SegundoDDL: ${listaCapitalDisponible["data"]}');
          debugPrint('DP SegundoDDLssss: ${listaCapitalDisponible["data"].length}');
          if (listaCapitalDisponible["data"].length == 0) {
            regresaCapital = false;
            Platform.isIOS
                ? menssagesUI.displayDialogIos(
                    context, GlobalTextsApp.tagTituloMensaje, GlobalTextsApp.tagSinPrestamo)
                : menssagesUI.displayDialogAndroid(
                context, GlobalTextsApp.tagTituloMensaje, GlobalTextsApp.tagSinPrestamo);
          }else{
            regresaCapital = true;
          }

          error = false;

        });
      } else {
        setState(() {
          error = true;
          message = "Error during fetching data";
        });
      }
    } catch (e) {
      setState(() {
        error = true;
        message = 'CATCH: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as MensajesArgs;

    return Scaffold(
        backgroundColor: Colors.brown[100],
        body: BackgroundWidget(
          topLogo: 60,
          topChild2: 150,
          // INFO: Child2, primer seccion del BackgroundWidget
          child2: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.center,
                // INFO: Nombre del profesor
                child: Text(
                  args.nombre,
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.brown),
                ),
              ),
              Center(
                  // INFO: RFC del profesor
                  child: Text(
                args.rfc,
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    fontFamily: 'Roboto',
                    color: Colors.brown),
              ))
            ],
          ),
          // INFO: Child, segunda seccion del BackgroundWidget
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 200),
                CardContainerSmWidget(
                    child: Column(
                  children: [
                    const SizedBox(height: 5),
                    Text('Pre-Registro',
                        style:
                            TextStyle(color: Colors.brown[900], fontSize: 20)),
                    const SizedBox(height: 10),
                    Text(GlobalTextsApp.tagPreregistro,
                        textAlign: TextAlign.center,
                        style:
                            TextStyle(color: Colors.brown[900], fontSize: 15)),
                    const SizedBox(height: 10),
                    // Provider para cargar el combo de plazo por quincenas disponibles
                    ChangeNotifierProvider(
                      create: (context) => QuincenasValidasProvider(),
                      child: Consumer<QuincenasValidasProvider>(
                          builder: (context, provider, child) {
                        if (provider.data == null) {
                          provider.getData(context);
                          return const Center(
                              child: CircularProgressIndicator(
                            color: Colors.orange,
                          ));
                        }

                        if (provider.data!.data.length > 1) {
                          return DropdownButton(
                            isExpanded: true,
                            value: itemValueQuincena == ""
                                ? null
                                : itemValueQuincena,
                            hint: const Text("Seleccione una quincena"),
                            icon: const Icon(
                              Icons.arrow_downward,
                              color: Color.fromRGBO(255, 102, 0, 1),
                            ),
                            underline: Container(
                              height: 2,
                              color: const Color.fromRGBO(255, 102, 0, 1),
                            ),
                            items: provider.data!.data.map((data) {
                              return DropdownMenuItem(
                                value: data.id.toString(),
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 25),
                                  child: Text(data.nombre),
                                ),
                              );
                            }).toList(),
                            onChanged: (String? value) {
                              setState(() {
                                //postListaCapitalDisponible();
                                itemValueQuincena = value!;
                              });
                            },
                          );
                        } else {
                          return const SizedBox(height: 10);
                        }
                      }),
                    ),

                    ChangeNotifierProvider(
                      create: (_) => PreRegistroFormProvider(),
                      child:  _RecuperarContrasenaForm(),
                    ),

                    // TextFormField: Ingresar el liquido
                    const SizedBox(height: 10),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.checklist_sharp),
                      label: const SizedBox(
                          width: double.infinity,
                          child:
                              Center(child: Text('Consultar montos para mi'))),
                      style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 67, 68, 71),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30))),
                      onPressed: () async {
                        if (itemValueMonto != '' || itemValueQuincena != '') {
                          postListaCapitalDisponible();
                        }
                      },
                      //child: const SizedBox(width: double.infinity, child: Center(child: Text('ingresar con huella')))
                    ),

                    ChangeNotifierProvider(
                      create: (_) => PreRegistroFormProvider(),
                      child: listaCapitalDisponible == null
                          ? const Text("Seleccione un monto")
                          : const _DropdownButtonCapital(),
                    ),

                    const SizedBox(height: 10),
                    // ElevatedButton: Boton para iniciar la solicitud del prestamos
                    if (regresaCapital)
                    ElevatedButton.icon(
                      icon:
                          const Icon(Icons.switch_access_shortcut_add_rounded),
                      label: const SizedBox(
                          width: double.infinity,
                          child: Center(
                              child: Text('Iniciar solicitud prestamo'))),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromRGBO(255, 102, 0, 1),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30))),
                      onPressed: () async {
                        // Validar monto seleccionado
                        if(itemValueMonto == "")
                          {
                            Platform.isIOS? menssagesUI.displayDialogIos(
                                context,
                                GlobalTextsApp.tagTituloMensaje,
                                GlobalTextsApp.tagSeleccionarCredito)
                                : menssagesUI.displayDialogAndroid(
                                context,
                                GlobalTextsApp.tagTituloMensaje,
                                GlobalTextsApp.tagSeleccionarCredito);
                          }else{
                          Future<String> respuesta = postRegistrarSolicitudPrestamo(itemValueMonto);
                          respuesta.then((String respuesta) async {
                            if (respuesta == 'err'){
                              Platform.isIOS? menssagesUI.displayDialogIos(
                                  context,
                                  GlobalTextsApp.tagTituloMensaje,
                                  GlobalTextsApp.tagVerificarCredenciales)
                                  : menssagesUI.displayDialogAndroid(
                                  context,
                                  GlobalTextsApp.tagTituloMensaje,
                                  GlobalTextsApp.tagVerificarCredenciales);
                            }
                            else{
                              String? rfc = await storage.read(key: 'rfc');
                              String? nombre = await storage.read(key: 'nombre');
                              String? solPrestamo = await storage.read(key: 'solPrestamo');
                              setState(() {
                                Navigator.pushReplacementNamed(
                                    context, 'inicio',
                                    arguments: InicioArgs(rfc ?? '',
                                        nombre ?? '', solPrestamo ?? ''));
                              });
                            }
                          });
                        }

                      },
                      //child: const SizedBox(width: double.infinity, child: Center(child: Text('ingresar con huella')))
                    ),
                    // ElevatedButton: Boton para cancelar
                    ElevatedButton.icon(
                      icon: const Icon(Icons.cancel),
                      label: const SizedBox(
                          width: double.infinity,
                          child: Center(child: Text('Cancelar'))),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 253, 0, 0),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30))),
                      onPressed: () async {
                        // Resetear los valores de las selecciones
                        itemValueQuincena = "";
                        itemValueMonto = "";

                        //--
                        Navigator.pop(context);
                      },
                      //child: const SizedBox(width: double.infinity, child: Center(child: Text('ingresar con huella')))
                    ),
                  ],
                )),
              ],
            ),
          ),
        ));
  }
}

class _DropdownButtonCapital extends StatefulWidget {
  const _DropdownButtonCapital({Key? key}) : super(key: key);
  @override
  State<_DropdownButtonCapital> createState() => _DropdownButtonCapitalState();
}

class _DropdownButtonCapitalState extends State<_DropdownButtonCapital> {
  @override
  void initState() {
    super.initState();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final theform = Provider.of<PreRegistroFormProvider>(context);
    List<CapitalDisponibleMapped> citylist = List<CapitalDisponibleMapped>.from(
        listaCapitalDisponible["data"].map((i) {
      return CapitalDisponibleMapped.fromJson(i);
    }));


    return Form(
        key: theform.formkey, // Manejo de estado
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child:
        DropdownButton(
        hint: const Text("Seleccione un monto"),
        isExpanded: true,
        value: (itemValueMonto == "" || itemValueMonto.isEmpty) ? null : itemValueMonto,
        items: citylist.map((result) {
          return DropdownMenuItem(
            value: result.id.toString(),
            child: Text(checkDouble(result.nombre).toString()),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            itemValueMonto = value.toString();

          });
        }));
  }
}


//region $Provider para txt liquido
class _RecuperarContrasenaForm extends StatefulWidget {
  const _RecuperarContrasenaForm({Key? key}) : super(key: key);
  @override
  State<_RecuperarContrasenaForm> createState() => _RecuperarContrasenaFormState();
}

class _RecuperarContrasenaFormState extends State<_RecuperarContrasenaForm> {
  @override
  void initState() {
    super.initState();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final theform = Provider.of<PreRegistroFormProvider>(context);
    MenssagesUI menssagesUI = MenssagesUI();

    return Form(
      key: theform.formkey, // Manejo de estado
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: TextFormField(
        maxLength: 6,
        textCapitalization: TextCapitalization.none,
        cursorColor: const Color.fromRGBO(255, 102, 0, 1),
        autocorrect: false,
        keyboardType: TextInputType.number,
        style: const TextStyle(color: Colors.brown),
        //strutStyle: const StrutStyle(fontSize: 10),
        // initialValue: '1',
        decoration: InputDecorationsUI.loginInputDecoration(
            labelText: 'Líquido',
            hintText: '0.00',
            prefixIcon: Icons.monetization_on),
        onChanged: (value) {
          setState(() {
            theform.liquido = value;
            liquido = value;
            regresaCapital = false;
            debugPrint('DP regresaCapital: $regresaCapital');
            listaCapitalDisponible = null;
            itemValueMonto = "";
            listaCapitalDisponible = null;
          });

        },
        validator: (value) {
          debugPrint('DP value: $value');
          if (value == '') return 'Cant obligatoria';
          RegExp regExp = RegExp(RegularExpressions.erf6Numeros);
          return regExp.hasMatch(value!) ? null : 'Monto incorrecto';
        },
      ),
    );
  }
}
//endregion