import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:productosapp/services/services.dart';
import 'package:provider/provider.dart';

import 'package:productosapp/screens/screens.dart';
import 'package:productosapp/widgets/widgets.dart';

import 'package:productosapp/providers/providers.dart';
import 'package:productosapp/ui/input_decorations.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  static const routeName = 'register';

  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: AuthBackground(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              SizedBox(
                  height:
                      (_screenSize.height - (_screenSize.width * 0.85)) / 2),
              // * _ScreenSize.width es el height de Card Container
              // * Se está centrando el CardContainer en cualquier dispositivo
              Center(
                child: CardContainer(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        'Crear cuenta',
                        style: Theme.of(context).textTheme.headline5,
                      ),
                      ChangeNotifierProvider(
                        create: (_) => LoginFromProvider(),
                        child: const _RegisterForm(),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 50),
              TextButton(
                style: ButtonStyle(
                  overlayColor:
                      MaterialStateProperty.all(Colors.indigo.withOpacity(0.1)),
                  shape: MaterialStateProperty.all(const StadiumBorder()),
                ),
                onPressed: () => Navigator.pushReplacementNamed(
                  context,
                  LoginScreen.routeName,
                ),
                child: const Text(
                  'Ya tengo una cuenta',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black87,
                  ),
                ),
              ),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}

class _RegisterForm extends StatelessWidget {
  const _RegisterForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final loginFormProvider = Provider.of<LoginFromProvider>(context);

    return Form(
      key: loginFormProvider.formKey,
      autovalidateMode: loginFormProvider.isFirstValidationPerformed
          ? AutovalidateMode.onUserInteraction
          : AutovalidateMode.disabled,
      child: Column(
        children: [
          TextFormField(
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecorations.authInputDecoration(
                hintText: 'mappedev@gmail.com',
                labelText: 'Correo electrónico',
                prefixIcon: Icons.alternate_email_outlined,
              ),
              onChanged: (value) => loginFormProvider.email = value,
              validator: (value) {
                String pattern =
                    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                RegExp regExp = RegExp(pattern);

                return regExp.hasMatch(value ?? '')
                    ? null
                    : 'El correo tiene un mal formato.';
              }),
          const SizedBox(height: 8),
          TextFormField(
              autocorrect: false,
              obscureText: true,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecorations.authInputDecoration(
                hintText: '********',
                labelText: 'Contraseña',
                prefixIcon: Icons.lock_outline,
              ),
              onChanged: (value) => loginFormProvider.password = value,
              validator: (value) {
                if (value != null && value.length >= 8) return null;

                return value != null && value.length >= 8
                    ? null
                    : 'La contraseña debe ser de 8 caracteres o más.';
              }),
          const SizedBox(height: 24),
          MaterialButton(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            disabledColor: Colors.grey,
            color: Colors.deepPurple,
            onPressed: loginFormProvider.isLoading
                ? null
                : () async {
                    final authService =
                        Provider.of<AuthService>(context, listen: false);

                    FocusScope.of(context).unfocus();

                    if (!loginFormProvider.isValidForm()) return;

                    loginFormProvider.isLoading = true;

                    final String? errorMessage = await authService.createUser(
                      loginFormProvider.email,
                      loginFormProvider.password,
                    );

                    if (errorMessage != null) {
                      late String message;

                      switch (errorMessage) {
                        case 'EMAIL_EXISTS':
                          message = 'El correo ya existe';
                          break;

                        case 'OPERATION_NOT_ALLOWED':
                          message = 'Acceso deshabilitado';
                          break;

                        case 'TOO_MANY_ATTEMPTS_TRY_LATER':
                          message =
                              'Acceso bloqueado por actividad inusual, por favor intente más tarde';
                          break;

                        default:
                          message = 'Ha ocurrido un error inesperado';
                      }

                      NotificationsService.showSnackbar(message);
                    } else {
                      Navigator.pushReplacementNamed(
                        context,
                        HomeScreen.routeName,
                      );
                    }

                    loginFormProvider.isLoading = false;
                  },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 8),
              alignment: Alignment.center,
              child: Text(
                loginFormProvider.isLoading ? 'Espere...' : 'Ingresar',
                style: const TextStyle(color: Colors.white),
              ),
            ),
          )
        ],
      ),
    );
  }
}
