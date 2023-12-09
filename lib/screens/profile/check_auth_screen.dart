import 'package:flutter/material.dart';
import 'package:yugioh_api_flutter/providers/login_form_provider.dart';
import 'package:yugioh_api_flutter/services/auth_service.dart';
import 'package:yugioh_api_flutter/services/notification_service.dart';
import 'package:provider/provider.dart';
import 'package:yugioh_api_flutter/providers/login_form_provider.dart';

import 'package:yugioh_api_flutter/widgets/form_field.dart';
import 'package:yugioh_api_flutter/colors/colors.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: ChangeNotifierProvider(
          create: (_) => LoginFormProvider(),
          child: const _LoginForm(),
        ),
      ),
    );
  }
}

class _LoginForm extends StatefulWidget {
  const _LoginForm({super.key});
  static final RegExp emailRegex = RegExp(
    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.([a-zA-Z]{2,})+",
  );
  static final RegExp passwordRegex = RegExp(
    r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$#!%*?&_])[A-Za-z\d@#$!%*?&_].{6,}$',
  );
  @override
  State<_LoginForm> createState() => __LoginFormState();
}

class __LoginFormState extends State<_LoginForm> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool isObscure = true;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final loginForm = Provider.of<LoginFormProvider>(context);

    return Form(
      key: loginForm.formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        children: [
          Container(
            height: size.height * 0.24,
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xff1E2E3D),
                  Color(0xff152534),
                  Color(0xff0C1C2E),
                ],
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Ingrese a su\nCuenta',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: AppColors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(
                  height: 6,
                ),
                Text(
                  'Ingrese a su cuenta',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                AppTextFormField(
                  labelText: 'Email',
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  onChanged: (value) => loginForm.email = value,
                  validator: (value) {
                    return value!.isEmpty
                        ? 'Por favor ingrese su Email'
                        : _LoginForm.emailRegex.hasMatch(value)
                            ? null
                            : 'Email invalido';
                  },
                  controller: emailController,
                ),
                AppTextFormField(
                  labelText: 'Contraseña',
                  keyboardType: TextInputType.visiblePassword,
                  textInputAction: TextInputAction.done,
                  onChanged: (value) => loginForm.password = value,
                  validator: (value) {
                    return value!.isEmpty
                        ? 'Por favor ingrese su contraseña'
                        : _LoginForm.passwordRegex.hasMatch(value)
                            ? null
                            : 'Contraseña invalida';
                  },
                  controller: passwordController,
                  obscureText: isObscure,
                  suffixIcon: Padding(
                    padding: const EdgeInsets.only(right: 15),
                    child: IconButton(
                      onPressed: () {
                        setState(() {
                          isObscure = !isObscure;
                        });
                      },
                      style: ButtonStyle(
                        minimumSize: MaterialStateProperty.all(
                          const Size(48, 48),
                        ),
                      ),
                      icon: Icon(
                        isObscure
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  style: Theme.of(context).textButtonTheme.style,
                  child: Text(
                    '¿Olvidó su contraseña?',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                FilledButton(
                  onPressed: loginForm.isLoading
                      ? null
                      : () async {
                          FocusScope.of(context).unfocus();
                          final authService =
                              Provider.of<AuthService>(context, listen: false);

                          if (!loginForm.isValidForm()) return;

                          loginForm.isLoading = true;

                          // TODO: validar si el login es correcto
                          final String? errorMessage = await authService.login(
                              loginForm.email, loginForm.password);

                          if (errorMessage == null) {
                            emailController.clear();
                            passwordController.clear();
                            Navigator.pushReplacementNamed(context, '/home');
                          } else {
                            // TODO: mostrar error en pantalla
                            NotificationsService.showSnackbar(errorMessage);
                            loginForm.isLoading = false;
                          }
                        },
                  style: const ButtonStyle().copyWith(
                    backgroundColor: MaterialStateProperty.all(null),
                  ),
                  child: Text(
                    loginForm.isLoading ? 'Espere' : 'Login',
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                const SizedBox(
                  height: 30,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "¿No tiene una cuenta?",
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: Colors.black),
                ),
                TextButton(
                  onPressed: () => Navigator.pushNamed(context, '/registrar'),
                  style: Theme.of(context).textButtonTheme.style,
                  child: Text(
                    'Registrar',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
