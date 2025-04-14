import 'package:easy_order/app/firebase_services/model/user_model.dart';
import 'package:easy_order/app/firebase_services/services/user_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginState {
  final bool isLoading;
  final String? error;
  final bool isLoggedIn;
  final UserModel? user;

  LoginState({
    this.isLoading = false,
    this.error,
    this.isLoggedIn = false,
    this.user,
  });

  LoginState copyWith({
    bool? isLoading,
    String? error,
    bool? isLoggedIn,
    UserModel? user,
  }) {
    return LoginState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      user: user ?? this.user,
    );
  }
}

class LoginStateNotifier extends StateNotifier<LoginState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  LoginStateNotifier() : super(LoginState());

  Future<void> signInWithEmailAndPassword(
    BuildContext context,
    String email,
    String password,
  ) async {
    try {
      state = state.copyWith(isLoading: true, error: '');

      final UserCredential userCredential = await _auth
          .signInWithEmailAndPassword(email: email, password: password);

      if (userCredential.user != null) {
        state = state.copyWith(
          isLoading: false,
          isLoggedIn: true,
        );
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage;

      switch (e.code) {
        case 'user-not-found':
          errorMessage = 'No user found with this email.';
          break;
        case 'wrong-password':
          errorMessage = 'Wrong password provided.';
          break;
        case 'invalid-email':
          errorMessage = 'The email address is invalid.';
          break;
        case 'user-disabled':
          errorMessage = 'This user account has been disabled.';
          break;
        case 'invalid-credential':
          errorMessage = 'Invalid email or password.';
          break;
        default:
          errorMessage = 'An error occurred during login: ${e.code}';
      }

      state = state.copyWith(
        isLoading: false,
        error: errorMessage,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'An unexpected error occurred.',
      );
    }
  }

  Future<void> signUpWithEmailAndPassword(
    BuildContext context,
    String email,
    String password,
  ) async {
    try {
      state = state.copyWith(isLoading: true, error: '');

      final UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      if (userCredential.user != null) {
        state = state.copyWith(
          isLoading: false,
          isLoggedIn: true,
        );
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage;

      switch (e.code) {
        case 'weak-password':
          errorMessage = 'The password provided is too weak.';
          break;
        case 'email-already-in-use':
          errorMessage = 'An account already exists with this email.';
          break;
        case 'invalid-email':
          errorMessage = 'The email address is invalid.';
          break;
        case 'operation-not-allowed':
          errorMessage = 'Email/password accounts are not enabled.';
          break;
        default:
          errorMessage = 'An error occurred during registration: ${e.code}';
      }

      state = state.copyWith(
        isLoading: false,
        error: errorMessage,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'An unexpected error occurred during registration.',
      );
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
      state = LoginState();
    } catch (e) {
      state = state.copyWith(
        error: 'Error signing out.',
      );
    }
  }

  void setUser(UserModel user) => state = state.copyWith(user: user);

  Future<void> createUser({
    required String name,
    required String phone,
  }) async {
    try {
      state = state.copyWith(isLoading: true, error: '');

      final currentUser = _auth.currentUser;
      if (currentUser == null) {
        throw Exception('No authenticated user found');
      }

      final userModel = UserModel(
        uid: currentUser.uid,
        name: name,
        email: currentUser.email ?? '',
        phone: phone,
      );

      await UserService.createUser(userModel);
      state = state.copyWith(
        isLoading: false,
        user: userModel,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to create user: ${e.toString()}',
      );
      rethrow;
    }
  }

  // Future<void> checkAuthStatus() async {
  //   final User? currentUser = _auth.currentUser;
  //   if (currentUser != null) {
  //     state = state.copyWith(
  //       isLoggedIn: true,
  //       user: currentUser,
  //     );
  //   }
  // }
}

final loginStateProvider =
    StateNotifierProvider<LoginStateNotifier, LoginState>((ref) {
  return LoginStateNotifier();
});
