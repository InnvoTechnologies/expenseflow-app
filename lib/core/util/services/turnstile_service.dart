import 'dart:developer';

import 'package:cloudflare_turnstile/cloudflare_turnstile.dart';

class TurnstileService {
  /// Retrieves the CloudFlare Turnstile token using invisible mode.
  static Future<String?> get token async {
    final TurnstileOptions options = TurnstileOptions(
      size: TurnstileSize.normal,
      theme: TurnstileTheme.auto,
      language: 'en',
      retryAutomatically: true,
      refreshTimeout: TurnstileRefreshTimeout.auto,
    );
    // Initialize an instance of invisible Cloudflare Turnstile with your site key
    final turnstile = CloudflareTurnstile.invisible(
      siteKey: '0x4AAAAAACKngW0k8__-cf-n', // Replace with your actual site key
      baseUrl: 'http://localhost/',
      options: options,
    );

    try {
      // Get the Turnstile token
      final token = await turnstile.getToken();
      return token; // Return the token upon success
    } on TurnstileException catch (e) {
      // Handle Turnstile failure
      log('Challenge failed: ${e.message}');
    } finally {
      // Ensure the Turnstile instance is properly disposed of
      turnstile.dispose();
    }

    // Return null if the token couldn't be generated
    return null;
  }
}