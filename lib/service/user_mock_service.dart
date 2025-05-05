import 'dart:async';
import '../model/user.dart';
import '../model/interest.dart';
import 'user_service.dart';

class MockUserService implements UserService {
  // Private static instance of the class
  static final MockUserService _instance = MockUserService._internal();

  // Factory constructor to return the singleton instance
  factory MockUserService() {
    return _instance;
  }

  // Private internal constructor
  MockUserService._internal();

  User? _currentUser;

  @override
  Stream<User> getCurrentUser() async* {
    await Future.delayed(const Duration(seconds: 1)); // Simulate delay
    if (_currentUser != null) {
      yield _currentUser!;
    } else {
      throw Exception('No user is currently logged in');
    }
  }

  @override
  Future<User> loginWithGoogle() async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate delay
    _currentUser = User(
      id: 'google-user-123',
      createdDate: DateTime.now(),
      lastModifiedDate: DateTime.now(),
      interests: [],
      alias: 'GoogleUser', // Add alias
      pictureUrl: 'https://example.com/google-user.jpg', // Add pictureUrl
    );
    return _currentUser!;
  }

  @override
  Future<User> loginWithMicrosoft() async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate delay
    _currentUser = User(
      id: 'microsoft-user-123',
      createdDate: DateTime.now(),
      lastModifiedDate: DateTime.now(),
      interests: [],
      alias: 'MicrosoftUser', // Add alias
      pictureUrl: 'https://example.com/microsoft-user.jpg', // Add pictureUrl
    );
    return _currentUser!;
  }

  @override
  Future<User> loginWithApple() async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate delay
    _currentUser = User(
      id: 'apple-user-123',
      createdDate: DateTime.now(),
      lastModifiedDate: DateTime.now(),
      interests: [],
      alias: 'AppleUser', // Add alias
      pictureUrl: 'https://example.com/apple-user.jpg', // Add pictureUrl
    );
    return _currentUser!;
  }

  @override
  Future<void> logout() async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate delay
    _currentUser = null;
  }

  @override
  Future<User> updateUser(User user) async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate delay
    _currentUser = user;
    return _currentUser!;
  }

  @override
  Future<void> deleteUser() async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate delay
    _currentUser = null;
  }

  @override
  Stream<User> fetchUser(String id) async* {
    await Future.delayed(const Duration(seconds: 1)); // Simulate delay
    yield User(
      id: id,
      createdDate: DateTime.now(),
      lastModifiedDate: DateTime.now(),
      interests: [],
      alias: 'User$id', // Add alias
      pictureUrl: 'https://example.com/user$id.jpg', // Add pictureUrl
    );
  }

  @override
  Future<User> addInterests(List<Interest> interests) async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate delay
    if (_currentUser == null) {
      throw Exception('No user is currently logged in');
    }

    _currentUser = _currentUser!.copyWith(
      interests: [..._currentUser!.interests, ...interests],
    );
    return _currentUser!;
  }

  @override
  Future<User> updateAlias(String newAlias) async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate delay
    if (_currentUser == null) {
      throw Exception('No user is currently logged in');
    }

    _currentUser = _currentUser!.copyWith(alias: newAlias);
    return _currentUser!;
  }

  @override
  Future<User> updatePictureUrl(String newPictureUrl) async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate delay
    if (_currentUser == null) {
      throw Exception('No user is currently logged in');
    }

    _currentUser = _currentUser!.copyWith(pictureUrl: newPictureUrl);
    return _currentUser!;
  }
}