import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';

class AuthController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();
  final RxBool isLoading = false.obs;
  final RxBool isAuthenticated = false.obs;

  @override
  void onInit() {
    super.onInit();
    ever(_authService.user, _handleAuthChanged);
  }

  void _handleAuthChanged(User? user) {
    isAuthenticated.value = user != null;
  }

  Future<bool> signIn(String email, String password) async {
    isLoading.value = true;
    try {
      final result = await _authService.signInWithEmailAndPassword(email, password);
      return result != null;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> signUp(String email, String password) async {
    isLoading.value = true;
    try {
      final result = await _authService.signUpWithEmailAndPassword(email, password);
      return result != null;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signOut() async {
    isLoading.value = true;
    try {
      await _authService.signOut();
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> resetPassword(String email) async {
    isLoading.value = true;
    try {
      final result = await _authService.resetPassword(email);
      return result;
    } finally {
      isLoading.value = false;
    }
  }

  String? get userEmail => _authService.currentUser?.email;
} 