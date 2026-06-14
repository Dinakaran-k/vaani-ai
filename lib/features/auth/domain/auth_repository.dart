abstract interface class AuthRepository {
  Future<void> signInWithEmail({
    required String email,
    required String password,
  });

  Future<void> signInWithGoogle();

  Future<void> sendPhoneOtp({
    required String phoneNumber,
    required void Function(String verificationId) onCodeSent,
  });

  Future<void> verifyPhoneOtp({
    required String verificationId,
    required String smsCode,
  });

  Future<void> signOut();
}
