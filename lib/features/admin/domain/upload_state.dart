/// Estado del proceso de subida de un PDF.
sealed class UploadState {
  const UploadState();
}

class UploadIdle extends UploadState {
  const UploadIdle();
}

class UploadLoading extends UploadState {
  const UploadLoading();
}

class UploadSuccess extends UploadState {
  const UploadSuccess();
}

class UploadError extends UploadState {
  const UploadError(this.message);
  final String message;
}
