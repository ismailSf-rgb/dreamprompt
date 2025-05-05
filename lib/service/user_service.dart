import '../model/user.dart';
import '../model/interest.dart';

abstract class UserService {
  // Fetch the current authenticated user
  Stream<User> getCurrentUser();

  // Login with Google
  Future<User> loginWithGoogle();

  // Login with Microsoft
  Future<User> loginWithMicrosoft();

  // Login with Apple
  Future<User> loginWithApple();

  // Logout the current user
  Future<void> logout();

  // Update the current user's profile
  Future<User> updateUser(User user);

  // Delete the current user's account
  Future<void> deleteUser();

  // Fetch a user by ID
  Stream<User> fetchUser(String id);

  // Add interests to the current user's profile
  Future<User> addInterests(List<Interest> interests);

  // Update the current user's alias
  Future<User> updateAlias(String newAlias);

  // Update the current user's profile picture URL
  Future<User> updatePictureUrl(String newPictureUrl);
}