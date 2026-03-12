import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:meshcore_open/connector/meshcore_protocol.dart';

void main() {
  group('buildTraceReq', () {
    test('rejects trace payloads larger than firmware path capacity', () {
      expect(
        () => buildTraceReq(
          123,
          0,
          0,
          payload: Uint8List(maxPathSize + 1),
        ),
        throwsArgumentError,
      );
    });

    test('rejects trace payloads that do not match the flag path stride', () {
      expect(
        () => buildTraceReq(
          123,
          0,
          1,
          payload: Uint8List(3),
        ),
        throwsArgumentError,
      );
    });

    test('accepts trace payloads within firmware limits', () {
      final frame = buildTraceReq(
        123,
        0,
        0,
        payload: Uint8List(maxPathSize),
      );

      expect(frame.length, 1 + 4 + 4 + 1 + maxPathSize);
      expect(frame.first, cmdSendTracePath);
    });
  });
}
