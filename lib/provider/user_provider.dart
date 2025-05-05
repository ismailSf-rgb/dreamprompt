import 'package:flutter/material.dart';
import '../service/user_service.dart';
import '../model/user.dart';
import '../model/interest.dart';
import '../util/subscription_manager.dart'; // Assuming you have a SubscriptionManager class

class UserProvider with ChangeNotifier {
  final UserService _userService;
  final SubscriptionManager _subscriptionManager = SubscriptionManager();
  User? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;

  UserProvider(this._userService);

  // Getters
  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Fetch the current authenticated user
  Future<void> fetchCurrentUser() async {
    if (_isLoading) return;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final userStream = _userService.getCurrentUser();
      _subscriptionManager.addSubscription(
        'fetchCurrentUser',
        userStream.listen(
          (user) {
            _currentUser = user;
            _isLoading = false;
            notifyListeners();
          },
          onError: (err) {
            _errorMessage = 'Failed to fetch current user: $err';
            _isLoading = false;
            notifyListeners();
          },
        ),
      );
    } catch (error) {
      _errorMessage = 'An error occurred: $error';
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  // Login with Google
  Future<void> loginWithGoogle() async {
    if (_isLoading) return;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final user = await _userService.loginWithGoogle();
      _currentUser = user;
      _isLoading = false;
      notifyListeners();
    } catch (error) {
      _errorMessage = 'Failed to login with Google: $error';
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  // Login with Microsoft
  Future<void> loginWithMicrosoft() async {
    if (_isLoading) return;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final user = await _userService.loginWithMicrosoft();
      _currentUser = user;
      _isLoading = false;
      notifyListeners();
    } catch (error) {
      _errorMessage = 'Failed to login with Microsoft: $error';
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  // Login with Apple
  Future<void> loginWithApple() async {
    if (_isLoading) return;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final user = await _userService.loginWithApple();
      _currentUser = user;
      _isLoading = false;
      notifyListeners();
    } catch (error) {
      _errorMessage = 'Failed to login with Apple: $error';
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  // Logout the current user
  Future<void> logout() async {
    if (_isLoading) return;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _userService.logout();
      _currentUser = null;
      _isLoading = false;
      notifyListeners();
    } catch (error) {
      _errorMessage = 'Failed to logout: $error';
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  // Update the current user's profile
  Future<void> updateUser(User user) async {
    if (_isLoading) return;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final updatedUser = await _userService.updateUser(user);
      _currentUser = updatedUser;
      _isLoading = false;
      notifyListeners();
    } catch (error) {
      _errorMessage = 'Failed to update user: $error';
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  // Delete the current user's account
  Future<void> deleteUser() async {
    if (_isLoading) return;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _userService.deleteUser();
      _currentUser = null;
      _isLoading = false;
      notifyListeners();
    } catch (error) {
      _errorMessage = 'Failed to delete user: $error';
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  // Fetch a user by ID
  Future<void> fetchUser(String id) async {
    if (_isLoading) return;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final userStream = _userService.fetchUser(id);
      _subscriptionManager.addSubscription(
        'fetchUser',
        userStream.listen(
          (user) {
            _currentUser = user;
            _isLoading = false;
            notifyListeners();
          },
          onError: (err) {
            _errorMessage = 'Failed to fetch user: $err';
            _isLoading = false;
            notifyListeners();
          },
        ),
      );
    } catch (error) {
      _errorMessage = 'An error occurred: $error';
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  // Add interests to the current user's profile
  Future<void> addInterests(List<Interest> interests) async {
    if (_isLoading) return;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final updatedUser = await _userService.addInterests(interests);
      _currentUser = updatedUser;
      _isLoading = false;
      notifyListeners();
    } catch (error) {
      _errorMessage = 'Failed to add interests: $error';
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  // Update the current user's alias
  Future<void> updateAlias(String newAlias) async {
    if (_isLoading) return;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final updatedUser = await _userService.updateAlias(newAlias);
      _currentUser = updatedUser;
      _isLoading = false;
      notifyListeners();
    } catch (error) {
      _errorMessage = 'Failed to update alias: $error';
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  // Update the current user's profile picture URL
  Future<void> updatePictureUrl(String newPictureUrl) async {
    if (_isLoading) return;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final updatedUser = await _userService.updatePictureUrl(newPictureUrl);
      _currentUser = updatedUser;
      _isLoading = false;
      notifyListeners();
    } catch (error) {
      _errorMessage = 'Failed to update picture URL: $error';
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  @override
  void dispose() {
    // Cancel all subscriptions when the provider is disposed
    _subscriptionManager.cancelAll();
    super.dispose();
  }
}