import 'dart:io';

import 'package:grpc/grpc.dart';
import '../generated/pos_service.pbgrpc.dart';

/// Singleton client that manages the gRPC channel to the C++ daemon.
class PosClient {
  static PosClient? _instance;

  late final ClientChannel _channel;
  late final PosServiceClient stub;

  PosClient._internal(String socketPath) {
    // Connect over a Unix domain socket for minimal latency and
    // zero network exposure.
    _channel = ClientChannel(
      InternetAddress(socketPath, type: InternetAddressType.unix),
      port: 0,
      options: const ChannelOptions(
        credentials: ChannelCredentials.insecure(),
      ),
    );

    stub = PosServiceClient(_channel);
  }

  /// Initialize once at app start.
  static void init({String socketPath = '/run/viewtouch/pos.sock'}) {
    _instance ??= PosClient._internal(socketPath);
  }

  /// Access the singleton.
  static PosClient get instance {
    assert(
        _instance != null, 'Call PosClient.init() before accessing instance');
    return _instance!;
  }

  Future<void> shutdown() async {
    await _channel.shutdown();
  }
}
