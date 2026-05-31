import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:quick_actions/quick_actions.dart';
import 'package:app_links/app_links.dart';

class ShortcutService {
  ShortcutService._privateConstructor();
  static final ShortcutService instance = ShortcutService._privateConstructor();

  final _quickActions = const QuickActions();
  final _appLinks = AppLinks();
  StreamSubscription<Uri>? _linkSubscription;

  String? _pendingAction;
  void Function(String)? _listener;

  void init() {
    // 1. Initialize Quick Actions
    _quickActions.initialize((String type) {
      _handleAction(type);
    });

    _quickActions.setShortcutItems(<ShortcutItem>[
      const ShortcutItem(
        type: 'action_expense',
        localizedTitle: 'Add Expense',
        icon: 'shortcut_expense',
      ),
      const ShortcutItem(
        type: 'action_income',
        localizedTitle: 'Add Income',
        icon: 'shortcut_income',
      ),
      const ShortcutItem(
        type: 'action_transfer',
        localizedTitle: 'Add Transfer',
        icon: 'shortcut_transfer',
      ),
    ]);

    // 2. Initialize Deep Links (App Links / Custom URL Schemes)
    _initDeepLinks();
  }

  void _initDeepLinks() async {
    // Check initial link if app was opened via link
    try {
      final initialUri = await _appLinks.getInitialLink();
      if (initialUri != null) {
        _handleDeepLink(initialUri);
      }
    } catch (e) {
      debugPrint('Failed to get initial deep link: $e');
    }

    // Listen to subsequent links
    _linkSubscription = _appLinks.uriLinkStream.listen((uri) {
      _handleDeepLink(uri);
    }, onError: (err) {
      debugPrint('Failed to handle deep link stream: $err');
    });
  }

  void _handleDeepLink(Uri uri) {
    // Expected format: expenseflow://add-transaction?type=expense
    if (uri.scheme == 'expenseflow' && uri.host == 'add-transaction') {
      final type = uri.queryParameters['type'] ?? 'expense';
      _handleAction('action_$type');
    }
  }

  void _handleAction(String type) {
    if (_listener != null) {
      _listener!(type);
    } else {
      _pendingAction = type;
    }
  }

  void registerListener(void Function(String) listener) {
    _listener = listener;
    if (_pendingAction != null) {
      listener(_pendingAction!);
      _pendingAction = null;
    }
  }

  void unregisterListener() {
    _listener = null;
  }

  void dispose() {
    _linkSubscription?.cancel();
  }
}
