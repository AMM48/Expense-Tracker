import 'package:client/classes/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'auth_test.mocks.dart';

@GenerateMocks([Auth, User])
void main() {
  test("Test Register", () async {
    final mockAuth = MockAuth();
    final mockUser = MockUser();

    when(mockAuth.registerUser(email: "test@test.com", password: "test123"))
        .thenAnswer((_) {
      when(mockAuth.currentUser).thenReturn(mockUser);
      return Future.value("Success");
    });
    var result = await mockAuth.registerUser(
        email: "test@test.com", password: "test123");
    expect(result, "Success");
    expect(mockAuth.currentUser, mockUser);
    expect(mockAuth.currentUser, isNotNull);
    verify(mockAuth.registerUser(email: "test@test.com", password: "test123"))
        .called(1);
  });

  test("Test Login", () async {
    final mockAuth = MockAuth();
    final mockUser = MockUser();

    when(mockAuth.currentUser).thenReturn(null);

    when(mockAuth.loginUser(email: "test@test.com", password: "test123"))
        .thenAnswer((_) {
      when(mockAuth.currentUser).thenReturn(mockUser);
      return Future.value();
    });

    when(mockUser.uid).thenReturn("some-uid");

    await mockAuth.loginUser(email: "test@test.com", password: "test123");

    expect(mockAuth.currentUser, equals(mockUser));
    expect(mockAuth.currentUser!.uid, equals("some-uid"));
    expect(mockAuth.currentUser!.uid, isNotNull);

    verify(mockAuth.loginUser(email: "test@test.com", password: "test123"))
        .called(1);
  });

  test("Test signOut", () async {
    final mockAuth = MockAuth();

    when(mockAuth.signOut()).thenAnswer((_) => Future.value());

    try {
      await mockAuth.signOut();
      expect(true, isTrue);
    } catch (e) {
      expect(e, isNull);
    }

    verify(mockAuth.signOut()).called(1);
  });

  test("Test Reset Password", () async {
    final mockAuth = MockAuth();

    when(mockAuth.resetPassword("test@test.com"))
        .thenAnswer((_) => Future.value());

    try {
      await mockAuth.resetPassword("test@test.com");
      expect(true, isTrue);
    } catch (e) {
      expect(e, isNull);
    }

    verify(mockAuth.resetPassword("test@test.com")).called(1);
  });
}
