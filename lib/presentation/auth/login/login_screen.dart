import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:online_exam/presentation/utlis/resources/StringManager.dart';
import 'package:online_exam/presentation/auth/login/cubit/login_screen_view_model.dart';
import 'package:online_exam/presentation/auth/register/register_screen.dart';
import 'package:online_exam/presentation/utlis/resources/color_manager.dart';
import 'package:online_exam/presentation/utlis/resources/custom_elevated_button.dart';
import 'package:online_exam/presentation/utlis/resources/main_text_field.dart';
import 'package:online_exam/presentation/utlis/resources/values_manager.dart';
import '../../../core/di.dart';
import '../../forgotPassword/forgot_password_screen.dart';
import '../../utlis/dialog_utlis.dart';
import 'cubit/states.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  static const String routeName = 'Login Screen';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final LoginScreenViewModel viewModel = getIt<LoginScreenViewModel>();

  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  bool rememberMe = false;

  @override
  void initState() {
    super.initState();
    _loadRememberMe();
  }

  void _loadRememberMe() async {
    String? remember = await secureStorage.read(key: 'rememberMe');
    setState(() {
      rememberMe = remember == 'true';
      if (rememberMe) {
        secureStorage.read(key: 'email').then((value) {
          viewModel.emailController.text = value ?? '';
        });
        secureStorage.read(key: 'password').then((value) {
          viewModel.passwordController.text = value ?? '';
        });
      }
    });
  }

  void _saveRememberMe() async {
    if (rememberMe) {
      await secureStorage.write(key: 'rememberMe', value: 'true');
      await secureStorage.write(
          key: 'email', value: viewModel.emailController.text);
      await secureStorage.write(
          key: 'password', value: viewModel.passwordController.text);
    } else {
      await secureStorage.deleteAll();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: viewModel,
      listener: (context, state) {
        if (state is SignInLoadingState) {
          DialogUtlis.showLoadingDialog(context, message: StringManager.loading);
        } else if (state is SignInSuccessState) {
          DialogUtlis.hideLoadingDialog(context);
          DialogUtlis.showMessageDialog(
            context,
            message: "${StringManager.loginSuccess}\n${state.authResultEntity.userEntity?.username}",
            posTitle: StringManager.ok,
            posAction: () {},
          );
        } else if (state is SignInErrorState) {
          DialogUtlis.hideLoadingDialog(context);
          DialogUtlis.showMessageDialog(
            context,
            message: '${state.errorMessage}${StringManager.pleaseTryAgain}',
            posTitle: StringManager.ok,
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(StringManager.login),
          backgroundColor: ColorManager.primary,
        ),
        body: Padding(
          padding: const EdgeInsets.all(PaddingManager.p16),
          child: Form(
            key: viewModel.formKey,
            child: ListView(
              children: <Widget>[
                CustomTextFormField(
                  label: StringManager.email,
                  textInputType: TextInputType.emailAddress,
                  controller: viewModel.emailController,
                  validation: (value) {
                    if (value == null || value.isEmpty) {
                      return StringManager.enterYourEmail;
                    }
                    return null;
                  },
                ),
                CustomTextFormField(
                  label: StringManager.password,
                  isObscured: true,
                  controller: viewModel.passwordController,
                  validation: (value) {
                    if (value == null || value.isEmpty) {
                      return StringManager.enterYourPassword;
                    }
                    return null;
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Checkbox(
                          value: rememberMe,
                          onChanged: (value) {
                            setState(() {
                              rememberMe = value ?? false;
                            });
                          },
                        ),
                        const Text(StringManager.rememberMe),
                      ],
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pushNamed(
                            context, ForgotPasswordScreen.routeName);
                      },
                      child: const Text(
                        StringManager.forgetPassword,
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          fontSize: SizeManager.s16,

                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: SizeManager.s20),
                CustomElevatedButton(
                  onPressed: () {
                    if (viewModel.formKey.currentState!.validate()) {
                      _saveRememberMe();
                      viewModel.signIn();
                    }
                  },
                  label: StringManager.login,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(StringManager.doNotHaveAccount),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, RegisterScreen.routeName);
                      },
                      child:  Text(
                        StringManager.signup,
                        style: TextStyle(
                          color: ColorManager.primary,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
