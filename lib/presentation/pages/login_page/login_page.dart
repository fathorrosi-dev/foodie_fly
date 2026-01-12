import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodie_fly/main.dart';
import 'package:foodie_fly/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'package:foodie_fly/presentation/components/custom_button.dart';
import 'package:foodie_fly/presentation/components/custom_textfield.dart';
import 'package:foodie_fly/utils/helpers/auth_validator.dart';
import 'package:foodie_fly/utils/helpers/helper_function.dart';
import 'package:go_router/go_router.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:lottie/lottie.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is Authenticated) {
          context.go('/navbar');
        } else if (state is AuthError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      child: Scaffold(
        // Add resizeToAvoidBottomInset
        resizeToAvoidBottomInset: false,
        body: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: $styles.insets.sm,
                      vertical: $styles.insets.xs,
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          // Use Expanded for flexible spacing
                          SizedBox(
                            height: 277,
                            child: Lottie.asset(
                              HelperFunction.isDarkMode(context)
                                  ? 'assets/animations/truck.json'
                                  : 'assets/animations/truck2.json',
                              fit: BoxFit.contain,
                            ),
                          ),
                          Text(
                            'Foodie Fly',
                            style: $styles.text.headlineSmall.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: $styles.insets.md),
                          CustomTextfield(
                            controller: _emailController,
                            hintText: 'Email',
                            validator: AuthValidator.validateEmail,
                            obscureText: false,
                            textInputAction: TextInputAction.next,
                          ),
                          SizedBox(height: $styles.insets.xs),
                          CustomTextfield(
                            controller: _passwordController,
                            hintText: 'Password',
                            validator: AuthValidator.validatePassword,
                            obscureText: true,
                            textInputAction: TextInputAction.done,
                            onFieldSubmitted: (value) {
                              if (_formKey.currentState!.validate()) {
                                context.read<AuthBloc>().add(
                                  LoginEvent(
                                    email: _emailController.text,
                                    password: _passwordController.text,
                                  ),
                                );
                              }
                            },
                          ),
                          SizedBox(height: $styles.insets.md),
                          BlocBuilder<AuthBloc, AuthState>(
                            builder: (context, state) {
                              return CustomButton(
                                onPressed: state is AuthLoading
                                    ? null
                                    : () {
                                        if (_formKey.currentState!.validate()) {
                                          context.read<AuthBloc>().add(
                                            LoginEvent(
                                              email: _emailController.text,
                                              password:
                                                  _passwordController.text,
                                            ),
                                          );
                                        }
                                      },
                                child: state is AuthLoading
                                    ? LoadingAnimationWidget.staggeredDotsWave(
                                        color:
                                            HelperFunction.isDarkMode(context)
                                            ? $styles.colors.darkBackground
                                            : $styles.colors.lightBackground,
                                        size: 24,
                                      )
                                    : const Text('Sign In'),
                              );
                            },
                          ),
                          // Registration link at bottom
                          Padding(
                            padding: EdgeInsets.only(
                              bottom: $styles.insets.sm,
                              top: $styles.insets.xs,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Not a member?',
                                  style: $styles.text.bodyLarge,
                                ),
                                SizedBox(width: $styles.insets.xs),
                                GestureDetector(
                                  onTap: () => context.go('/register'),
                                  child: Text(
                                    'Register Now',
                                    style: $styles.text.bodyLarge.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
