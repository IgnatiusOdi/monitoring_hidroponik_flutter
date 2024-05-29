import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../bloc/login/login_bloc.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.inversePrimary,
      body: BlocListener<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state.status) {
            context.goNamed('home');
          }
        },
        child: BlocBuilder<LoginBloc, LoginState>(
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/icon.png', height: 200),
                  const SizedBox(height: 16),
                  EmailInput(theme: theme),
                  const SizedBox(height: 16),
                  PasswordInput(theme: theme),
                  MessageText(theme: theme),
                  LoginButton(theme: theme),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class EmailInput extends StatelessWidget {
  final ThemeData theme;

  const EmailInput({super.key, required this.theme});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (previous, current) => previous.email != current.email,
      builder: (context, state) {
        return TextField(
          onChanged: (value) {
            context.read<LoginBloc>().add(EmailChangedEvent(value));
          },
          decoration: InputDecoration(
            hintText: 'Email',
            prefixIcon: const Icon(Icons.email),
            filled: true,
            fillColor: theme.colorScheme.primaryContainer,
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
          ),
        );
      },
    );
  }
}

class PasswordInput extends StatefulWidget {
  final ThemeData theme;

  const PasswordInput({super.key, required this.theme});

  @override
  State<PasswordInput> createState() => _PasswordInputState();
}

class _PasswordInputState extends State<PasswordInput> {
  bool _obscure = true;

  void _toggleObscure() {
    setState(() {
      _obscure = !_obscure;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (previous, current) => previous.password != current.password,
      builder: (context, state) {
        return TextField(
          onChanged: (value) {
            context.read<LoginBloc>().add(PasswordChangedEvent(value));
          },
          obscureText: _obscure,
          decoration: InputDecoration(
            hintText: 'Password',
            prefixIcon: const Icon(Icons.password),
            suffixIcon: IconButton(
              icon: Icon(_obscure ? Icons.visibility : Icons.visibility_off),
              onPressed: () => _toggleObscure(),
            ),
            filled: true,
            fillColor: widget.theme.colorScheme.primaryContainer,
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
          ),
        );
      },
    );
  }
}

class MessageText extends StatelessWidget {
  final ThemeData theme;

  const MessageText({super.key, required this.theme});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(0, 8, 0, 16),
        child: Text(
          state.error,
          style: TextStyle(
            fontSize: 18,
            color: theme.colorScheme.error,
          ),
        ),
      );
    });
  }
}

class LoginButton extends StatelessWidget {
  final ThemeData theme;

  const LoginButton({super.key, required this.theme});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        return ElevatedButton(
          onPressed: () {
            context.read<LoginBloc>().add(LoginEmailPassword());
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: theme.colorScheme.primary,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 12,
              horizontal: 24,
            ),
            child: state.loading
                ? const CircularProgressIndicator(color: Colors.white)
                : Text(
                    'LOGIN',
                    style: TextStyle(
                      color: theme.colorScheme.surface,
                      fontSize: 16,
                    ),
                  ),
          ),
        );
      },
    );
  }
}
