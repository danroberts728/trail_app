import 'package:firebase_auth/firebase_auth.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trail_auth/app_user.dart';

class FirebaseUserMock extends Mock implements User {}
class FirebaseMockUserMetaData extends Mock implements UserMetadata {}

FirebaseUserMock mockUser = FirebaseUserMock();
FirebaseMockUserMetaData mockUserMetaData = FirebaseMockUserMetaData();

void main() {
  setUp(() {
    when(mockUserMetaData.creationTime).thenReturn(DateTime.parse("2002-02-27T14:00:00-0500"));
    when(mockUser.email).thenReturn('mock@email.com');
    when(mockUser.uid).thenReturn('mockuid');
    when(mockUser.isAnonymous).thenReturn(false);
    when(mockUser.metadata).thenReturn(mockUserMetaData);
  });

  group("Constructor tests", () {
    test("Default constructor", () {
      var user = AppUser(
        createdDate: 'mockdate',
        email: 'mock@email.com',
        isAnonymous: false,
        uid: 'mockuid'
      );
      expect(user.createdDate, 'mockdate');
      expect(user.email, 'mock@email.com');
      expect(user.isAnonymous, false);
      expect(user.uid, 'mockuid');
    });

    test("From firebase constructor", () {
      var user = AppUser.fromFirebase(mockUser);
      expect(user.createdDate, 'Feb 27, 2002');
      expect(user.email, 'mock@email.com');
      expect(user.isAnonymous, false);
      expect(user.uid, 'mockuid');
    });
  });
}