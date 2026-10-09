import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../configs/app.dart';
import '../../../configs/configs.dart';
import '../../../model/controllers/profile_controller.dart';
import '../../widgets/design/design.dart';
import 'bloc/authentication_bloc.dart';

class AuthenticationScreen extends StatefulWidget {
  const AuthenticationScreen({super.key});

  @override
  State<AuthenticationScreen> createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {
  AuthenticationBloc? _bloc;
  StreamSubscription? _subscription;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  int _mode = 0; // 0 = login, 1 = sign up

  @override
  void dispose() {
    _subscription?.cancel();
    _bloc?.close();
    super.dispose();
  }

  void _showChangePasswordSheet() {
    final userNameCtrl = TextEditingController();
    final passwordCtrl = TextEditingController();
    final key = GlobalKey<FormState>();

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: key,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Reset credentials',
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 21,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Update your username and password.',
                  style: GoogleFonts.manrope(
                    fontSize: 13,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 18),
                AppTextField(
                  controller: userNameCtrl,
                  label: 'Username',
                  prefixIcon: Icons.person_outline_rounded,
                  validator: (v) =>
                      (v == null || v.trim().length < 4) ? 'Min 4 characters' : null,
                ),
                const SizedBox(height: 14),
                AppTextField(
                  controller: passwordCtrl,
                  label: 'New password',
                  obscure: true,
                  prefixIcon: Icons.lock_outline_rounded,
                  validator: (v) =>
                      (v == null || v.trim().length < 4) ? 'Min 4 characters' : null,
                ),
                const SizedBox(height: 20),
                GlowButton(
                  label: 'Save changes',
                  gradient: true,
                  onPressed: () {
                    if (key.currentState?.validate() ?? false) {
                      _bloc?.add(AuthenticationSaveChanges(
                        userName: userNameCtrl.text.trim(),
                        password: passwordCtrl.text.trim(),
                      ));
                      Get.back();
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    App.init(context);
    final scheme = Theme.of(context).colorScheme;
    final profileController = Get.find<ProfileController>();
    final isLogin = _mode == 0;

    return BlocProvider(
      create: (context) {
        final bloc = AuthenticationBloc();
        bloc.add(AuthenticationStart());
        _subscription = bloc.stream.listen((state) {
          if (state is SignSuccess || state is LoginSuccess) {
            Get.snackbar(
              state is SignSuccess ? 'Welcome!' : 'Welcome back!',
              state is SignSuccess
                  ? 'Your account is ready.'
                  : 'Signed in successfully.',
              snackPosition: SnackPosition.BOTTOM,
              margin: const EdgeInsets.all(12),
              backgroundColor: scheme.primary,
              colorText: Colors.white,
            );
            Get.back();
          } else if (state is ChangeInformation) {
            _showChangePasswordSheet();
          } else if (state is UserHaveNoAccount) {
            Get.snackbar(
              'No account',
              'We couldn’t find that username.',
              snackPosition: SnackPosition.BOTTOM,
              margin: const EdgeInsets.all(12),
              backgroundColor: scheme.error,
              colorText: Colors.white,
            );
          } else if (state is LoginUnSuccess) {
            Get.snackbar(
              'Incorrect details',
              'Username or password didn’t match.',
              snackPosition: SnackPosition.BOTTOM,
              margin: const EdgeInsets.all(12),
              backgroundColor: scheme.error,
              colorText: Colors.white,
            );
          }
        });
        _bloc = bloc;
        return bloc;
      },
      child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          final busy = state is AuthenticationLoading;
          final error = state is AuthenticationError;

          return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                onPressed: Get.back,
                icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
              ),
            ),
            body: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 40),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ------------------------------------------------ header
                    Text(
                      AppStrings.brandName,
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 20,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w600,
                        color: scheme.primary,
                      ),
                    ),
                    const SizedBox(height: 24),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 280),
                      transitionBuilder: (child, anim) => FadeTransition(
                        opacity: anim,
                        child: SlideTransition(
                          position: Tween(
                            begin: const Offset(0, 0.15),
                            end: Offset.zero,
                          ).animate(anim),
                          child: child,
                        ),
                      ),
                      child: Column(
                        key: ValueKey(_mode),
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isLogin
                                ? 'Welcome back,\ngorgeous'
                                : 'Let’s create\nyour account',
                            style: GoogleFonts.playfairDisplay(
                              fontSize: 34,
                              fontWeight: FontWeight.w600,
                              height: 1.15,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            isLogin
                                ? 'Your bag, favourites and orders are waiting.'
                                : 'Join malkiab and keep your glow in sync.',
                            style: GoogleFonts.manrope(
                              fontSize: 14.5,
                              height: 1.5,
                              color: scheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),

                    // ------------------------------------------------ fields
                    if (error)
                      Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: scheme.error.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.error_outline_rounded,
                                color: scheme.error, size: 20),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'Something went wrong — please try again.',
                                style: GoogleFonts.manrope(
                                    fontSize: 13, color: scheme.error),
                              ),
                            ),
                          ],
                        ),
                      ),

                    AnimatedSize(
                      duration: const Duration(milliseconds: 260),
                      curve: Curves.easeOutCubic,
                      alignment: Alignment.topCenter,
                      child: Column(
                        children: [
                          if (!isLogin) ...[
                            AppTextField(
                              controller: nameController,
                              label: 'Full name',
                              hint: 'Layla Haddad',
                              prefixIcon: Icons.badge_outlined,
                              validator: (v) => (v == null || v.trim().length < 3)
                                  ? 'Enter your full name'
                                  : null,
                            ),
                            const SizedBox(height: 16),
                          ],
                          AppTextField(
                            controller: userNameController,
                            label: 'Username or email',
                            hint: 'you@malkiab.com',
                            prefixIcon: Icons.person_outline_rounded,
                            keyboardType: TextInputType.emailAddress,
                            validator: (v) => (v == null || v.trim().length < 4)
                                ? 'Min 4 characters'
                                : null,
                          ),
                          const SizedBox(height: 16),
                          Obx(() => AppTextField(
                                controller: passwordController,
                                label: 'Password',
                                hint: '••••••••',
                                obscure: profileController.obscureText,
                                prefixIcon: Icons.lock_outline_rounded,
                                textInputAction: TextInputAction.done,
                                validator: (v) =>
                                    (v == null || v.trim().length < 4)
                                        ? 'Min 4 characters'
                                        : null,
                                suffix: IconButton(
                                  onPressed: () => profileController
                                      .obscureTextInstance.value = !profileController
                                      .obscureText,
                                  icon: Icon(
                                    profileController.obscureText
                                        ? Icons.visibility_off_outlined
                                        : Icons.visibility_outlined,
                                    size: 20,
                                  ),
                                ),
                              )),
                          ],
                      ),
                    ),
                    const SizedBox(height: 8),

                    // ------------------------------------------------ extras
                    if (isLogin)
                      Row(
                        children: [
                          Obx(() => Checkbox(
                                value: profileController.rememberMeStatus,
                                activeColor: scheme.primary,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5)),
                                onChanged: (v) {
                                  if (v != null) {
                                    profileController
                                        .rememberMeStatusInstance.value = v;
                                  }
                                },
                              )),
                          Text(
                            'Remember me',
                            style: GoogleFonts.manrope(
                                fontSize: 13.5,
                                fontWeight: FontWeight.w600),
                          ),
                          const Spacer(),
                          TextButton(
                            onPressed: () => _bloc?.add(
                                AuthenticationChangeInformation()),
                            child: const Text('Forgot password?'),
                          ),
                        ],
                      )
                    else
                      const SizedBox(height: 4),

                    const SizedBox(height: 14),
                    GlowButton(
                      label: busy
                          ? (isLogin ? 'Signing in…' : 'Creating account…')
                          : (isLogin ? 'Sign in' : 'Create account'),
                      gradient: true,
                      loading: busy,
                      onPressed: () {
                        if (!(formKey.currentState?.validate() ?? false)) {
                          return;
                        }
                        if (isLogin) {
                          _bloc?.add(AuthenticatioLogin(
                            userName: userNameController.text.trim(),
                            password: passwordController.text.trim(),
                            isRemember: profileController.rememberMeStatus,
                          ));
                        } else {
                          _bloc?.add(AuthenticationSignUp(
                            name: nameController.text.trim(),
                            userName: userNameController.text.trim(),
                            password: passwordController.text.trim(),
                            isRemember: profileController.rememberMeStatus,
                          ));
                        }
                      },
                    ),

                    const SizedBox(height: 26),
                    // ------------------------------------------------ switch
                    Center(
                      child: Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Text(
                            isLogin
                                ? 'New to malkiab?'
                                : 'Already have an account?',
                            style: GoogleFonts.manrope(
                              fontSize: 13.5,
                              color: scheme.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(width: 6),
                          GestureDetector(
                            onTap: busy
                                ? null
                                : () {
                                    setState(() =>
                                        _mode = isLogin ? 1 : 0);
                                    _bloc?.add(isLogin
                                        ? AuthenticationSignUpMode()
                                        : AuthenticationLoginMode());
                                  },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 7),
                              decoration: BoxDecoration(
                                color: scheme.primary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(100),
                                border:
                                    Border.all(color: scheme.primary),
                              ),
                              child: Text(
                                isLogin ? 'Create account' : 'Sign in',
                                style: GoogleFonts.manrope(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w800,
                                  color: scheme.primary,
                                ),
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
          );
        },
      ),
    );
  }
}
