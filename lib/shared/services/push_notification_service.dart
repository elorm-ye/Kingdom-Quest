import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart';

class PushNotificationService {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<void> initialize() async {
    // Request permission (especially for iOS)
    NotificationSettings settings = await _fcm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      debugPrint('User granted push notification permissions.');

      // Get the token and save it to Supabase
      String? token = await _fcm.getToken();
      if (token != null) {
        await _saveTokenToSupabase(token);
      }

      // Listen for token refreshes
      _fcm.onTokenRefresh.listen(_saveTokenToSupabase);

      // Handle foreground messages
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        debugPrint('Got a message whilst in the foreground!');
        debugPrint('Message data: ${message.data}');
        if (message.notification != null) {
          debugPrint(
            'Message also contained a notification: ${message.notification}',
          );
          // Note: Flutter handles foreground notifications differently.
          // You might want to use flutter_local_notifications here to show a heads-up UI.
        }
      });
    } else {
      debugPrint(
        'User declined or has not accepted push notification permissions.',
      );
    }
  }

  Future<void> _saveTokenToSupabase(String token) async {
    final user = _supabase.auth.currentUser;
    if (user == null) return;

    final platform = kIsWeb ? 'web' : (Platform.isAndroid ? 'android' : 'ios');

    try {
      await _supabase.from('fcm_tokens').upsert({
        'user_id': user.id,
        'token': token,
        'platform': platform,
      }, onConflict: 'user_id, token');
      debugPrint('FCM token saved to Supabase: $token');
    } catch (e) {
      debugPrint('Error saving FCM token: $e');
    }
  }

  /// Use this when a user logs out to remove their FCM token
  Future<void> deleteToken() async {
    final user = _supabase.auth.currentUser;
    if (user == null) return;

    String? token = await _fcm.getToken();
    if (token != null) {
      try {
        await _supabase
            .from('fcm_tokens')
            .delete()
            .eq('user_id', user.id)
            .eq('token', token);
      } catch (e) {
        debugPrint('Error deleting FCM token: $e');
      }
    }
    await _fcm.deleteToken();
  }
}
