// import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:riverpod/riverpod.dart';

// State class to hold login-related data
class LoginState {
  final bool isLoading;
  final String? error;
  final bool isValidNumber;
  final bool isChecked;

  LoginState({
    this.isLoading = false,
    this.error,
    this.isValidNumber = false,
    this.isChecked = false,
  });

  LoginState copyWith({
    bool? isLoading,
    String? error,
    bool? isValidNumber,
    bool? isChecked,
  }) {
    return LoginState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      isValidNumber: isValidNumber ?? this.isValidNumber,
      isChecked: isChecked ?? this.isChecked,
    );
  }
}

// StateNotifier to manage login state
class LoginStateNotifier extends StateNotifier<LoginState> {
  LoginStateNotifier() : super(LoginState());

  // void setTermsChecked(bool value) => state = state.copyWith(isChecked: value);

  // void validatePhoneNumber(String number) =>
  //     state = state.copyWith(isValidNumber: number.length == 10);

  Future<void> handleLogin(
    BuildContext context,
    String phoneNumber,
    Function(String verificationId) onCodeSent,
    Function(User? user, String? accessToken) onVerificationCompleted,
    Function(FirebaseAuthException error) onVerificationFailed,
  ) async {
    /* if (!state.isValidNumber || !state.isChecked) return;

    state = state.copyWith(isLoading: true, error: null);

    try {
      await AuthServices.instance.verifyPhoneNumber(
        phoneNumber,
        onCodeSent: (verificationId) async {
          await Future.delayed(const Duration(milliseconds: 500));
          if (context.mounted) {
            onCodeSent(verificationId);
            state = state.copyWith(isLoading: false);
          }
        },
        onVerificationCompleted: (user, accessToken) {
          if (context.mounted) {
            onVerificationCompleted(user, accessToken);
            state = state.copyWith(isLoading: false);
          }
        },
        onVerificationFailed: (error) {
          if (context.mounted) {
            onVerificationFailed(error);
            state = state.copyWith(isLoading: false);
          }
        },
      );
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isLoading: false,
      );
      if (context.mounted) {
        // context.showToast(message: state.error ?? '');
      }
      
    }*/
  }
}

// Provider
final loginStateProvider =
    StateNotifierProvider<LoginStateNotifier, LoginState>((ref) {
  return LoginStateNotifier();
});
