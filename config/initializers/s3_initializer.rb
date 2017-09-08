# Load up the S3 connection during initialization so that it will be ready to use
# once the app is loaded.
VpnModule::S3Certificates.instance
