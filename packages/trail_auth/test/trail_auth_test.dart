import 'package:flutter_test/flutter_test.dart';
import 'package:trail_auth/trail_auth.dart';

void main() {
  group("Trail Auth Tests", () {
    test("Sign in status", () {
      var auth = TrailAuth();
      expect(auth.signinStatus, SigninStatus.NOT_SIGNED_IN);
    });
  });
}