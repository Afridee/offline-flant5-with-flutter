import 'dart:math';
import 'package:flutter/services.dart';
import 'package:onnxruntime/onnxruntime.dart';

int argmax(List<double> array) {
  double maxValue = array.reduce(max);
  return array.indexOf(maxValue);
}

Future<List<List<int>>> runInference({required Map<String, dynamic> data}) async {
  final sessionOptions = OrtSessionOptions();
  const assetFileName = './models/flan-t5.onnx';
  final rawAssetFile = await rootBundle.load(assetFileName);
  final bytes = rawAssetFile.buffer.asUint8List();
  final session = OrtSession.fromBuffer(bytes, sessionOptions);

  List<List<int>> inputIds = data["input_ids"];
  List<List<int>> attentionMask = data["attention_mask"];
  List<List<int>> decoderInputIds = data["decoder_input_ids"];  // Typically starts with [0] for <BOS>

  print("inputIds");
  print(inputIds);
  print("attentionMask");
  print(attentionMask);
  print("decoder_input_ids");
  print(decoderInputIds);

  OrtValueTensor inputIdsTensor = OrtValueTensor.createTensorWithDataList(inputIds, [1, inputIds[0].length]);
  OrtValueTensor attentionMaskTensor = OrtValueTensor.createTensorWithDataList(attentionMask, [1, attentionMask[0].length]);
  OrtValueTensor decoderInputIdsTensor = OrtValueTensor.createTensorWithDataList(decoderInputIds, [1, 1]);

  final runOptions = OrtRunOptions();
  bool shouldStop = false;
  int maxNewTokens = 64;
  int generatedTokens = 0;
  int eosTokenId = 1; // You need to set this based on your model's vocabulary

  while (!shouldStop && generatedTokens < maxNewTokens) {
    final outputs = await session.runAsync(runOptions, {
      'input_ids': inputIdsTensor,
      'attention_mask': attentionMaskTensor,
      'decoder_input_ids': decoderInputIdsTensor
    });

    List<dynamic> logitsBatch = outputs![0]!.value as List<dynamic>;
    List<dynamic> logitsSequence = logitsBatch[0] as List<dynamic>;
    List<double> logitsLastToken = logitsSequence.last.cast<double>();
    int nextTokenId = argmax(logitsLastToken);

    if (nextTokenId == eosTokenId) {
      shouldStop = true;
    } else {
      decoderInputIds[0].add(nextTokenId);
      generatedTokens++;  // Increment the generated token counter

      // Update the decoder input tensor
      decoderInputIdsTensor.release();
      decoderInputIdsTensor = OrtValueTensor.createTensorWithDataList(decoderInputIds, [1, decoderInputIds[0].length]);
    }
  }

  inputIdsTensor.release();
  attentionMaskTensor.release();
  decoderInputIdsTensor.release();
  runOptions.release();

  // Cleanup the session and environment
  session.release();
  OrtEnv.instance.release();

  print("output from model:");
  print(decoderInputIds);

  return decoderInputIds;  // This would typically be your function's output
}


