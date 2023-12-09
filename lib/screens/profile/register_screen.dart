import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yugioh_api_flutter/colors/colors.dart';
import 'package:yugioh_api_flutter/providers/login_form_provider.dart';
import 'package:yugioh_api_flutter/services/auth_service.dart';
import 'package:yugioh_api_flutter/services/notification_service.dart';
import 'package:yugioh_api_flutter/widgets/form_field.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ChangeNotifierProvider(
      create: (_) => LoginFormProvider(),
      child: _RegisterForm(),
    ));
  }
}

class _RegisterForm extends StatefulWidget {
  _RegisterForm({super.key});
  static final RegExp emailRegex = RegExp(
    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.([a-zA-Z]{2,})+",
  );
  static final RegExp passwordRegex = RegExp(
    r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$#!%*?&_])[A-Za-z\d@#$!%*?&_].{7,}$',
  );

  @override
  State<_RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<_RegisterForm> {
  bool isObscure = true;

  bool isConfirmPasswordObscure = true;

  final _formKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();

  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  TextEditingController confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final loginForm = Provider.of<LoginFormProvider>(context);

    final size = MediaQuery.of(context).size;
    return Form(
      key: loginForm.formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: ListView(
        children: [
          Container(
            height: size.height * 0.24,
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.lightBlue,
                  AppColors.blue,
                  AppColors.darkBlue,
                ],
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    top: 15,
                  ),
                  child: IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                    ),
                  ),
                ),
                Column(
                  children: [
                    Text(
                      'Registrar',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: AppColors.grey,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    Text(
                      'Crea tu cuenta',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.grey,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 30,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                AppTextFormField(
                  labelText: 'Email',
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  onChanged: (value) => loginForm.email = value,
                  validator: (value) {
                    return value!.isEmpty
                        ? 'Por favor ingrese su correo'
                        : _RegisterForm.emailRegex.hasMatch(value)
                            ? null
                            : 'Email invalido';
                  },
                  controller: emailController,
                ),
                AppTextFormField(
                  labelText: 'Contraseña',
                  keyboardType: TextInputType.visiblePassword,
                  textInputAction: TextInputAction.next,
                  onChanged: (value) => loginForm.password = value,
                  validator: (value) {
                    return value!.isEmpty
                        ? 'Por favor ingrese su contraseña'
                        : _RegisterForm.passwordRegex.hasMatch(value)
                            ? null
                            : 'Contraseña invalida';
                  },
                  controller: passwordController,
                  obscureText: isObscure,
                  suffixIcon: Padding(
                    padding: const EdgeInsets.only(right: 15),
                    child: Focus(
                      descendantsAreFocusable: false,
                      child: IconButton(
                        onPressed: () => setState(() {
                          isObscure = !isObscure;
                        }),
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
                ),
                AppTextFormField(
                  labelText: 'Confirmar contraseña',
                  keyboardType: TextInputType.visiblePassword,
                  textInputAction: TextInputAction.done,
                  onChanged: (value) {
                    _formKey.currentState?.validate();
                  },
                  validator: (value) {
                    return value!.isEmpty
                        ? 'Por favor, reingrese su contraseña'
                        : _RegisterForm.passwordRegex.hasMatch(value)
                            ? passwordController.text ==
                                    confirmPasswordController.text
                                ? null
                                : 'Contraseña no identica'
                            : 'Contraseña invalida';
                  },
                  controller: confirmPasswordController,
                  obscureText: isConfirmPasswordObscure,
                  suffixIcon: Padding(
                    padding: const EdgeInsets.only(right: 15),
                    child: Focus(
                      descendantsAreFocusable: false,
                      child: IconButton(
                        onPressed: () {
                          setState(() {
                            isConfirmPasswordObscure =
                                !isConfirmPasswordObscure;
                          });
                        },
                        style: ButtonStyle(
                          minimumSize: MaterialStateProperty.all(
                            const Size(48, 48),
                          ),
                        ),
                        icon: Icon(
                          isConfirmPasswordObscure
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
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
                          final String? errorMessage = await authService
                              .createUser(loginForm.email, loginForm.password);

                          if (errorMessage == null) {
                            Navigator.pushReplacementNamed(context, '/home');
                            emailController.clear();
                            passwordController.clear();
                            confirmPasswordController.clear();
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
                    loginForm.isLoading ? 'Espere' : 'Registrar',
                  ),
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
                  'Tengo una cuenta',
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: Colors.black),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/login');
                  },
                  style: Theme.of(context).textButtonTheme.style,
                  child: Text(
                    'Login',
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
