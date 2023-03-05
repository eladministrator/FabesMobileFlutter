import 'package:fabes/screens/pre_registro/pre_registro_form_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../ui/input_decorations_ui.dart';
import '../../ui/messages_ui.dart';
import '../../utils/regular_expressions.dart';

class PreRegistroFormChildProvider extends StatefulWidget {
  const PreRegistroFormChildProvider({Key? key}) : super(key: key);

  @override
  State<PreRegistroFormChildProvider> createState() =>
      PreRegistroFormChildProviderState();
}

class PreRegistroFormChildProviderState
    extends State<PreRegistroFormChildProvider> {
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
      key: theform.formkey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        TextFormField(
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
              hintText: '000000',
              prefixIcon: Icons.monetization_on),
          onChanged: (value) => theform.liquido = value,
          validator: (value) {
            debugPrint('value: $value');
            if (value == '') return 'Cant obligatoria';
            //if (int.parse(value!) == -1) return 'Cant obligatoria';

            RegExp regExp = RegExp(RegularExpressions.erf6Numeros);
            return regExp.hasMatch(value!) ? null : 'Monto incorrecto';
          },
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
            // if (itemValueMonto != '' || itemValueQuincena != '') {
            //   postListaCapitalDisponible();
            // }
          },
          //child: const SizedBox(width: double.infinity, child: Center(child: Text('ingresar con huella')))
        ),
      ]),
    );
  }
}
