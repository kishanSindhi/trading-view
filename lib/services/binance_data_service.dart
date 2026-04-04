import 'dart:async';
import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../app_constants.dart';

class BinanceDataService {
  WebSocketChannel? _channel;
  StreamSubscription? _subscription;
  final _priceController = StreamController<Map<String, double>>.broadcast();
  bool _isConnected = false;
  bool _isDisposed = false;

  Stream<Map<String, double>> get priceStream => _priceController.stream;
  bool get isConnected => _isConnected;

  void connect() {
    if (_isConnected || _isDisposed) return;
    _connectAsync();
  }

  Future<void> _connectAsync() async {
    final uri = Uri.parse(AppConstants.binanceWsUrl);

    try {
      _channel = WebSocketChannel.connect(uri);

      await _channel!.ready;

      _isConnected = true;

      _subscription = _channel!.stream.listen(
        _onMessage,
        onError: _onError,
        onDone: _onDone,
      );
    } catch (e) {
      _isConnected = false;
      _channel = null;
      if (!_isDisposed) {
        Future.delayed(const Duration(seconds: 10), connect);
      }
    }
  }

  void disconnect() {
    _subscription?.cancel();
    _channel?.sink.close();
    _isConnected = false;
    _channel = null;
  }

  void dispose() {
    _isDisposed = true;
    disconnect();
    _priceController.close();
  }

  void _onMessage(dynamic message) {
    try {
      final json = jsonDecode(message as String) as Map<String, dynamic>;
      final data = json['data'] as Map<String, dynamic>?;
      if (data == null) return;

      final symbol = data['s'] as String?;
      final price = double.tryParse(data['c'] as String? ?? '');

      if (symbol != null && price != null && !_priceController.isClosed) {
        _priceController.add({symbol: price});
      }
    } catch (_) {}
  }

  void _onError(Object error) {
    _isConnected = false;
    if (!_isDisposed) {
      Future.delayed(const Duration(seconds: 5), connect);
    }
  }

  void _onDone() {
    _isConnected = false;
    if (!_isDisposed) {
      Future.delayed(const Duration(seconds: 5), connect);
    }
  }
}
