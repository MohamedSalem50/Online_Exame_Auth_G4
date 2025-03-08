import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:online_exam/presentation/utlis/resources/color_manager.dart';
import 'package:online_exam/presentation/utlis/resources/custom_elevated_button.dart';
import 'package:online_exam/presentation/utlis/resources/main_text_field.dart';
import 'package:online_exam/presentation/utlis/resources/values_manager.dart';
import '../../core/constants/app_strings.dart';
import '../../core/di.dart';
import '../utlis/dialog_utlis.dart';
import 'cubit/forgot_password_view_model.dart';
import 'cubit/states.dart';

class ForgotPasswordScreen extends StatefulWidget {
  static const String routeName = 'Forgot Password Screen';
   const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final ForgotPasswordViewModel viewModel = getIt<ForgotPasswordViewModel>();

  @override
  Widget build(BuildContext context) {
    return  BlocConsumer<ForgotPasswordViewModel, ForgotState>(
      bloc: viewModel,
      listener: (context, state) {
        if (state is ForgotLoadingState) {
          DialogUtlis.showLoadingDialog(context, message: StringManager.loading);
        } else if (state is ForgotSuccessState) {
          DialogUtlis.hideLoadingDialog(context);
          DialogUtlis.showMessageDialog(
            context,
            message: "${StringManager.forgotPasswordSuccess}, ${state.forgotPasswordEntity.info}",
            posTitle: StringManager.ok,
            posAction: () {

            },
          );
        }
        else if (state is ForgotErrorState) {
          DialogUtlis.hideLoadingDialog(context);
          DialogUtlis.showMessageDialog(
            context,
            message: '${state.errorMessage}\n${StringManager.pleaseTryAgain}',
            posTitle: StringManager.ok,
            posAction: () {
            },
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            elevation: 0,
          backgroundColor: ColorManager.primary,
            title: Text(StringManager.password,
              style: TextStyle(
                color: ColorManager.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),),
            leading: IconButton(
              icon:  Icon(Icons.arrow_back_ios_new, color: ColorManager.black,),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(PaddingManager.p16),
            child: Form(
              key: viewModel.formKey,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children:[
                    const SizedBox(height:  SizeManager.s40),
                    Text(StringManager.forgetPassword,
                      style: TextStyle(
                        color: ColorManager.black,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height:  SizeManager.s14),
                    Text(StringManager.hintEnterEmailToResetPassword,
                      style: TextStyle(
                        color: ColorManager.grey,
                        fontSize: 18,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height:  SizeManager.s40),
                    CustomTextFormField(
                      label:
                      StringManager.email,
                      textInputType: TextInputType.emailAddress, controller: viewModel.emailController,
                      validation:
                          (value) {
                        if (value == null || value.isEmpty) {
                          return StringManager.enterYourEmail;
                        }
                        if (!RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$')
                            .hasMatch(value)) {
                          return StringManager.emailError;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: SizeManager.s14),
                    CustomElevatedButton(onPressed: (){
                      if (viewModel.formKey.currentState?.validate() ?? false) {
                        viewModel.forgotPassword();
                      }
                    }, label: StringManager.resetPassword, backgroundColor: ColorManager.primary),
                   

                  ]
              ),
            ),
          ),

        );
      },
    );
  }
}
