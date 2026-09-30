abstract final class AppConstants {
  static const String supabaseUrl = String.fromEnvironment('SUPABASE_URL');
  static const String supabaseAnonKey = String.fromEnvironment('SUPABASE_ANON_KEY');

  // Offline sync
  static const int syncRetryDelaySeconds = 30;
  static const int maxOfflineIncidents = 100;

  // Pagination
  static const int pageSize = 20;

  // Image
  static const int thumbnailQuality = 40;
  static const int thumbnailMaxDimension = 200;
  static const int mediumQuality = 70;
  static const int mediumMaxDimension = 800;

  // Map
  static const double defaultLat = 0.0;
  static const double defaultLng = 0.0;
  static const double defaultZoom = 13.0;
  static const double clusterRadius = 80.0;

  // Risk score
  static const int riskRadiusKm = 5;
  static const int riskWindowHours = 48;
}
