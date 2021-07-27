class TrailTabPlacesSettings {
  double minDistanceToCheckIn = 0.15;
  bool showNonMemberTapList = false;
  String membershipLogoAsset = '';

  /// Singleton Pattern
  factory TrailTabPlacesSettings() {
    return _instance;
  }
  static final TrailTabPlacesSettings _instance = TrailTabPlacesSettings._privateConstructor();  
  TrailTabPlacesSettings._privateConstructor();
}