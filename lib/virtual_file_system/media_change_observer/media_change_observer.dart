abstract interface class MediaChangeObserver {
  void localFileDeleted(String filePath);
  void localFileCreated(String filePath);
  bool registerObserver();
  bool unregisterObserver();
}
