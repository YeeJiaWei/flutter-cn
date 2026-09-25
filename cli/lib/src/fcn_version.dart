/// The `fcn` CLI's version, baked in at compile time with
/// `-DFCN_VERSION=vX.Y.Z`; `dev` when built without it.
const String fcnVersion = String.fromEnvironment('FCN_VERSION', defaultValue: 'dev');
