import 'package:firebase_auth/firebase_auth.dart';

class AuthServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Sign In
  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result =
          await _auth.signInWithEmailAndPassword(email: email, password: password);

      // Optionally check if email is verified
      if (!result.user!.emailVerified) {
        print("Email not verified");
        await sendEmailVerification();
        return null;
      }

      return result.user;
    } on FirebaseAuthException catch (e) {
      print("Sign-in error: ${e.message}");
      return null;
    }
  }

  // Sign Up
  Future<User?> registerWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result =
          await _auth.createUserWithEmailAndPassword(email: email, password: password);

      await sendEmailVerification(); // Send verification email after sign-up
      return result.user;
    } on FirebaseAuthException catch (e) {
      print("Registration error: ${e.message}");
      return null;
    }
  }

  // Send Email Verification
  Future<void> sendEmailVerification() async {
    try {
      User? user = _auth.currentUser;
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
        print("Verification email sent.");
      }
    } catch (e) {
      print("Error sending email verification: ${e.toString()}");
    }
  }

  // Password Reset
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      print("Password reset email sent.");
    } catch (e) {
      print("Password reset error: ${e.toString()}");
    }
  }

  // Sign Out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print("Sign-out error: ${e.toString()}");
    }
  }

  // Getter for current user
  User? get currentUser => _auth.currentUser;
}
