import 'package:easy_order/app/firebase_services/model/market_model.dart';
import 'package:easy_order/app/firebase_services/model/user_model.dart';
import 'package:easy_order/app/firebase_services/services/user_service.dart';
import 'package:easy_order/core/storage/app_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

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
    List<MarketModel>? markets,
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
      await AppStorage.clearUser();
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
    required String marketId,
  }) async {
    try {
      state = state.copyWith(isLoading: true, error: '');

      final currentUser = _auth.currentUser;
      if (currentUser == null) {
        throw Exception('No authenticated user found');
      }

      final newUser = UserModel(
        uid: const Uuid().v4(),
        name: name,
        email: currentUser.email ?? '',
        phone: phone,
        marketId: marketId,
      );

      await UserService.createUser(newUser);
      state = state.copyWith(
        isLoading: false,
        user: newUser,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to create user: ${e.toString()}',
      );
      rethrow;
    }
  }
}

final loginStateProvider =
    StateNotifierProvider<LoginStateNotifier, LoginState>((ref) {
  return LoginStateNotifier();
});
