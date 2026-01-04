part of 'app_theme.dart';

class ThemeState extends Equatable {
  final bool isDark;

  const ThemeState({required this.isDark});

  ThemeData get themeData => isDark ? AppTheme.dark : AppTheme.light;

  @override
  List<Object> get props => [isDark];
}
