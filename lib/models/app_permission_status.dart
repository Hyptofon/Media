enum AppPermissionStatus {
  granted,

  denied,

  permanentlyDenied;

  bool get isGranted => this == AppPermissionStatus.granted;

  bool get isPermanentlyDenied => this == AppPermissionStatus.permanentlyDenied;
}
