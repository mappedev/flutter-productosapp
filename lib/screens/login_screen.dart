import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:productosapp/screens/screens.dart';
import 'package:productosapp/widgets/widgets.dart';

import 'package:productosapp/services/services.dart';
import 'package:productosapp/providers/providers.dart';
import 'package:productosapp/ui/input_decorations.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  static const routeName = 'login';

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
                        'Login',
                        style: Theme.of(context).textTheme.headline5,
                      ),
                      ChangeNotifierProvider(
                        create: (_) => LoginFromProvider(),
                        child: const _LoginForm(),
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
                  RegisterScreen.routeName,
                ),
                child: const Text(
                  'Crear cuenta',
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

class _LoginForm extends StatelessWidget {
  const _LoginForm({Key? key}) : super(key: key);

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

                    final String? errorMessage = await authService.login(
                      loginFormProvider.email,
                      loginFormProvider.password,
                    );

                    if (errorMessage != null) {
                      late String message;

                      switch (errorMessage) {
                        case 'EMAIL_NOT_FOUND':
                          message = 'Correo inválido';
                          break;

                        case 'INVALID_PASSWORD':
                          message = 'Contraseña inválida';
                          break;

                        case 'USER_DISABLED':
                          message = 'Usuario deshabilitado';
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
