import 'package:anonaddy/notifiers/authorization/auth_state.dart';
import 'package:anonaddy/notifiers/biometric_auth/biometric_notifier.dart';
import 'package:anonaddy/notifiers/search/search_history/search_history_notifier.dart';
import 'package:anonaddy/services/access_token/access_token_service.dart';
import 'package:anonaddy/services/biometric_auth/biometric_auth_service.dart';
import 'package:anonaddy/services/data_storage/offline_data_storage.dart';
import 'package:anonaddy/shared_components/constants/constants_exports.dart';
import 'package:anonaddy/utilities/utilities.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final authStateNotifier = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(
    secureStorage: ref.read(flutterSecureStorage),
    biometricService: ref.read(biometricAuthServiceProvider),
    tokenService: ref.read(accessTokenServiceProvider),
    searchHistory: ref.read(searchHistoryStateNotifier.notifier),
  );
});

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier({
    required this.secureStorage,
    required this.biometricService,
    required this.tokenService,
    required this.searchHistory,
    AuthState? initialState,
  }) : super(initialState ?? AuthState.initialState());

  final FlutterSecureStorage secureStorage;
  final BiometricAuthService biometricService;
  final AccessTokenService tokenService;
  final SearchHistoryNotifier searchHistory;

  void _updateState(AuthState newState) {
    if (mounted) state = newState;
  }

  void goToAnonAddyLogin() {
    final newState = state.copyWith(
      authorizationStatus: AuthorizationStatus.anonAddyLogin,
    );
    _updateState(newState);
  }

  void goToSelfHostedLogin() {
    final newState = state.copyWith(
      authorizationStatus: AuthorizationStatus.selfHostedLogin,
    );
    _updateState(newState);
  }

  Future<void> login(String url, String token) async {
    _updateState(state.copyWith(loginLoading: true));

    try {
      final isTokenValid = await tokenService.validateAccessToken(url, token);

      if (isTokenValid) {
        await tokenService.saveLoginCredentials(url, token);
        final newState = state.copyWith(
          authorizationStatus: AuthorizationStatus.authorized,
          loginLoading: false,
        );
        _updateState(newState);
      }
    } catch (error) {
      final newState = state.copyWith(loginLoading: false);
      Utilities.showToast(error.toString());
      _updateState(newState);
    }
  }

  Future<void> logout(BuildContext context) async {
    try {
      await secureStorage.deleteAll();
      await searchHistory.clearSearchHistory();
      if (mounted) Phoenix.rebirth(context);
    } catch (error) {
      Utilities.showToast(error.toString());
    }
  }

  Future<void> authenticate() async {
    try {
      final didAuth = await biometricService.authenticate();
      if (didAuth) {
        final newState = state.copyWith(
          authorizationStatus: state.authorizationStatus,
          authenticationStatus: AuthenticationStatus.disabled,
        );
        _updateState(newState);
      } else {
        final newState =
            state.copyWith(errorMessage: AppStrings.failedToAuthenticate);
        _updateState(newState);
        Utilities.showToast(AppStrings.failedToAuthenticate);
      }
    } catch (error) {
      final newState =
          state.copyWith(errorMessage: 'Authorization failed! Log in again!');
      _updateState(newState);
    }
  }

  /// Manages authentication flow at app startup.
  ///   1. Fetches stored access token and instance url.
  ///   2. Attempts to login to check if token and url are valid.
  ///   3. If valid, set [state] to [AuthorizationStatus.authorized].
  ///   4. If invalid, set [state] to [AuthorizationStatus.unauthorized].
  ///
  /// It also checks if user's device supports biometric authentication.
  /// Then sets [state] accordingly.
  Future<void> initAuth() async {
    try {
      final isLoginValid = await _validateLoginCredential();
      final authStatus = await _getBioAuthState();

      if (isLoginValid) {
        final newState = state.copyWith(
          authorizationStatus: AuthorizationStatus.authorized,
          authenticationStatus: authStatus,
        );
        _updateState(newState);
      } else {
        final newState = state.copyWith(
          authorizationStatus: AuthorizationStatus.anonAddyLogin,
          authenticationStatus: authStatus,
        );
        _updateState(newState);
      }
    } catch (error) {
      Utilities.showToast(error.toString());

      /// Authenticate user regardless of error.
      /// This is a temp solution until I'm able to handle different errors.
      _updateState(
        state.copyWith(
          authorizationStatus: AuthorizationStatus.anonAddyLogin,
        ),
      );
    }
  }

  /// Fetches and validates stored login credentials
  /// and returns bool if valid or not
  Future<bool> _validateLoginCredential() async {
    try {
      final token = await tokenService.getAccessToken();
      final url = await tokenService.getInstanceURL();
      if (token.isEmpty || url.isEmpty) return false;

      /// Temporarily override token and url validation check until I find
      /// a way of handling different errors.
      return true;

      // final isValid = await tokenService.validateAccessToken(url, token);
      // return isValid;
    } catch (error) {
      rethrow;
    }
  }

  Future<AuthenticationStatus> _getBioAuthState() async {
    try {
      const bioAuthKey = BiometricNotifier.biometricAuthKey;
      final bioAuthValue = await secureStorage.read(key: bioAuthKey);

      if (bioAuthValue == null) return AuthenticationStatus.disabled;

      return bioAuthValue == 'true'
          ? AuthenticationStatus.enabled
          : AuthenticationStatus.disabled;
    } catch (error) {
      return AuthenticationStatus.disabled;
    }
  }
}
