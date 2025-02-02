import 'dart:ffi';
import 'package:ffi/ffi.dart';
import 'binding.dart';

class Chatbot {
  late Pointer<Void> model;

  void init(String modelPath) {
    model = initModel(modelPath.toNativeUtf8());
    if (model == nullptr) {
      throw Exception("Failed to load SentencePiece model");
    }
  }

  Map<String, dynamic> encode(String question) {
    final resultPtr = encodeInput(model, question.toNativeUtf8());
    final result = resultPtr.ref;

    List<int> inputIds = result.input_ids.asTypedList(result.input_length).toList();
    List<int> attentionMask = result.attention_mask.asTypedList(result.input_length).toList();
    List<int> decoderInputIds = result.decoder_input_ids.asTypedList(result.decoder_length).toList();

    freeEncodeResult(resultPtr);

    return {
      'input_ids': inputIds,
      'attention_mask': attentionMask,
      'decoder_input_ids': decoderInputIds,
    };
  }

  String decode(List<int> tokens) {
    final tokensPtr = calloc<Int32>(tokens.length);
    tokensPtr.asTypedList(tokens.length).setAll(0, tokens);

    final outputPtr = decodeOutput(model, tokensPtr, tokens.length);
    final decoded = outputPtr.toDartString();

    freeCharPtr(outputPtr);
    calloc.free(tokensPtr);

    return decoded;
  }
}