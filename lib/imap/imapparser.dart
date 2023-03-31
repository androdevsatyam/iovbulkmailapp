import 'dart:convert';

class IMAPParser extends Converter<String, dynamic> {
  final _buffer = StringBuffer();
  final _responses = <dynamic>[];

  @override
  dynamic convert(String input) {
    _buffer.write(input);

    final lines = _buffer.toString().split('\r\n');
    _buffer.clear();

    for (final line in lines) {
      final response = _parseResponse(line);
      if (response != null) {
        _responses.add(response);
      }
    }

    return _responses.isNotEmpty ? _responses.removeAt(0) : null;
  }

  @override
  Sink<String> startChunkedConversion(Sink<dynamic> sink) => _IMAPSink(this, sink);

  dynamic _parseResponse(String line) {
    if (line.startsWith('* ')) {
      return IMAPResponse(line.substring(2));
    } else if (line.startsWith('+ ')) {
      return IMAPContinuationResponse(line.substring(2));
    } else {
      return IMAPTaggedResponse(line);
    }
  }
}

class _IMAPSink extends ChunkedConversionSink<String> {
  final IMAPParser _parser;
  final Sink<dynamic> _sink;

  _IMAPSink(this._parser, this._sink);

  @override
  void add(String chunk) {
    final response = _parser.convert(chunk);
    if (response != null) {
      _sink.add(response);
    }
  }

  @override
  void close(){
    try{
      _sink.close();
    }catch(e){
      print('Cant close sink $e');
      throw Exception('Cant close sink $e');
    }
  }
}

class IMAPResponse {
  final String message;

  IMAPResponse(this.message);

  @override
  String toString() => '* $message\r\n';
}

class IMAPContinuationResponse {
  final String message;

  IMAPContinuationResponse(this.message);

  @override
  String toString() => '+ $message\r\n';
}

class IMAPTaggedResponse {
  final String message;

  IMAPTaggedResponse(this.message);

  @override
  String toString() => '$message\r\n';
}

class IMAPClient {}