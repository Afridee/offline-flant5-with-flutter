import 'dart:ffi';
import 'dart:io';
import 'package:ffi/ffi.dart';

// 1) Load the shared library
//    Adjust the filename and extension as appropriate for your platform.
final chatbotLib = Platform.isMacOS
    ? DynamicLibrary.open('libchatbot.dylib')
    : DynamicLibrary.open('libchatbot.so');

// 2) Define a Dart struct that mirrors EncodeResult (C struct).
final class EncodeResult extends Struct {
  external Pointer<Int32> input_ids;         // array[64]
  external Pointer<Int32> attention_mask;    // array[64]
  @Int32()
  external int input_length;                         // should be 64

  external Pointer<Int32> decoder_input_ids; // array[1]
  @Int32()
  external int decoder_length;                       // should be 1
}

// 3) Define the signatures for the native functions (C side).
//
//   C++ side:
//     sentencepiece::SentencePieceProcessor* init_model(const char* model_path);
//     EncodeResult* encode_input(SentencePieceProcessor*, const char* question);
//     char* decode_output(SentencePieceProcessor*, const int* tokens, int length);
//     void free_encode_result(EncodeResult*);
//     void free_char_ptr(char*);
//

// -- init_model --
typedef InitModelNative = Pointer<Void> Function(
    Pointer<Utf8>,
    );
typedef InitModelDart = Pointer<Void> Function(Pointer<Utf8>,
);

// -- encode_input --
typedef EncodeInputNative = Pointer<EncodeResult> Function(
    Pointer<Void>,
    Pointer<Utf8>,
    );
typedef EncodeInputDart = Pointer<EncodeResult> Function(
    Pointer<Void>,
    Pointer<Utf8>,
    );

// -- decode_output --
typedef DecodeOutputNative = Pointer<Utf8> Function(
    Pointer<Void>,
    Pointer<Int32>,
    Int32,
    );
typedef DecodeOutputDart = Pointer<Utf8> Function(
    Pointer<Void>,
    Pointer<Int32>,
    int,
    );

// -- free_encode_result --
typedef FreeEncodeResultNative = Void Function(
    Pointer<EncodeResult>,
    );
typedef FreeEncodeResultDart = void Function(
    Pointer<EncodeResult>,
    );

// -- free_char_ptr --
typedef FreeCharPtrNative = Void Function(
    Pointer<Utf8>,
    );
typedef FreeCharPtrDart = void Function(
    Pointer<Utf8>,
    );

// 4) Look up each native function and expose a Dart function.
final InitModelDart initModel = chatbotLib
    .lookup<NativeFunction<InitModelNative>>('init_model')
    .asFunction<InitModelDart>();

final EncodeInputDart encodeInput = chatbotLib
    .lookup<NativeFunction<EncodeInputNative>>('encode_input')
    .asFunction<EncodeInputDart>();

final DecodeOutputDart decodeOutput = chatbotLib
    .lookup<NativeFunction<DecodeOutputNative>>('decode_output')
    .asFunction<DecodeOutputDart>();

final FreeEncodeResultDart freeEncodeResult = chatbotLib
    .lookup<NativeFunction<FreeEncodeResultNative>>('free_encode_result')
    .asFunction<FreeEncodeResultDart>();

final FreeCharPtrDart freeCharPtr = chatbotLib
    .lookup<NativeFunction<FreeCharPtrNative>>('free_char_ptr')
    .asFunction<FreeCharPtrDart>();
