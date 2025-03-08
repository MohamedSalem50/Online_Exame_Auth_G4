import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:online_exam/presentation/auth/register/cubit/register_screen_view_model.dart';
import 'package:online_exam/presentation/utlis/resources/color_manager.dart';
import 'package:online_exam/presentation/utlis/resources/custom_elevated_button.dart';
import 'package:online_exam/presentation/utlis/resources/main_text_field.dart';
import 'package:online_exam/presentation/utlis/resources/values_manager.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/di.dart';
import '../../utlis/dialog_utlis.dart';
import '../login/login_screen.dart';
import 'cubit/states.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  static const String routeName = 'Register Screen';

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final RegisterScreenViewModel viewModel = getIt<RegisterScreenViewModel>();

  @override
  Widget build(BuildContext context) {
    return BlocListener<RegisterScreenViewModel, RegisterState>(
      bloc: viewModel,
      listener: (context, state) {
        if (state is RegisterLoadingState) {
          DialogUtlis.showLoadingDialog(context, message: StringManager.loading);
        } else if (state is RegisterSuccessState) {
          DialogUtlis.hideLoadingDialog(context);
          DialogUtlis.showMessageDialog(
            context,
            message: "${StringManager.registerSuccess}, ${state.authResultEntity.userEntity?.username}",
            posTitle: StringManager.ok,
            posAction: () {},
          );
        } else if (state is RegisterErrorState) {
          DialogUtlis.hideLoadingDialog(context);
          DialogUtlis.showMessageDialog(
            context,
            message: '${StringManager.registerError}, ${state.errorMessage}\n${StringManager.pleaseTryAgain}',
            posTitle: StringManager.ok,
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(StringManager.signup),
          backgroundColor: ColorManager.primary,

        ),
        body: Padding(
          padding: const EdgeInsets.all(PaddingManager.p16),
          child: Form(
            key: viewModel.formKey,
            child: ListView(
              children: <Widget>[
                CustomTextFormField(
                  label: StringManager.userName,
                  controller: viewModel.userNameController,
                  validation: (value) => value?.isEmpty ?? true
                      ? StringManager.enterYourUserName
                      : null,
                ),
                Row(
                  children: [
                    Expanded(
                      child: CustomTextFormField(
                        label: StringManager.firstName,
                        controller: viewModel.firstNameController,
                        validation: (value) => value?.isEmpty ?? true
                            ? StringManager.enterYourFirstName
                            : null,
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: CustomTextFormField(
                        label: StringManager.lastName,
                        controller: viewModel.lastNameController,
                        validation: (value) => value?.isEmpty ?? true
                            ? StringManager.enterYourLastName
                            : null,
                      ),
                    ),
                  ],
                ),
                CustomTextFormField(
                  label: StringManager.email,
                  textInputType: TextInputType.emailAddress,
                  controller: viewModel.emailController,
                  validation: (value) {
                    if (value == null || value.isEmpty) {
                      return StringManager.enterYourEmail;
                    }
                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                        return StringManager.emailError;
                    }
                    return null;
                  },
                ),
                Row(
                  children: [
                    Expanded(
                      child: CustomTextFormField(
                        label: StringManager.password,
                        isObscured: true,
                        controller: viewModel.passwordController,
                        validation: (value) {
                          if (value == null || value.isEmpty) {
                            return StringManager.enterYourPassword;
                          }
                          if (!RegExp(
                              r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&*-]).{8,}$')
                              .hasMatch(value)) {
                            return StringManager.passwordError;
                          }
                          return null;
                        },

                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: CustomTextFormField(
                        label: StringManager.confirmPassword,
                        isObscured: true,
                        controller: viewModel.confirmPasswordController,
                        validation: (value) => value != viewModel.passwordController.text
                            ? StringManager.rePasswordError
                            : null,
                      ),
                    ),
                  ],
                ),
                CustomTextFormField(
                  label: StringManager.phoneNumber,
                  textInputType: TextInputType.phone,
                  controller: viewModel.phoneNumberController,
                  validation: (value) {
                    if (value == null || value.isEmpty) {
                      return StringManager.enterYourPhoneNumber;
                    }
                    if (!RegExp(r'^01[0125][0-9]{8}$').hasMatch(value)) {
                      return StringManager.phoneNumberError;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                CustomElevatedButton(
                  onPressed: () {
                    if (viewModel.formKey.currentState?.validate() ?? false) {
                      viewModel.register();
                    }
                  },
                  label: StringManager.signup,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(StringManager.alreadyHaveAccount),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, LoginScreen.routeName);
                      },
                      child:  Text(
                        StringManager.login,
                        
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
