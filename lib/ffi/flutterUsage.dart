import 'dart:io';

import 'package:biologychatbot/ffi/wrapper.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

Future<String> copyModelToAppDirectory() async {
  // Get the app's documents directory
  final appDir = await getApplicationDocumentsDirectory();
  final modelPath = '${appDir.path}/spiece.model';

  // Check if the file already exists
  if (File(modelPath).existsSync()) {
    return modelPath; // Return the path if the file already exists
  }

  // Load the asset from the Flutter bundle
  final byteData = await rootBundle.load('models/spiece.model');

  // Write the asset to the app's documents directory
  final file = File(modelPath);
  await file.writeAsBytes(byteData.buffer.asUint8List());

  return modelPath;
}

void maigvg() async{
  final chatbot = Chatbot();
  String path = await copyModelToAppDirectory();
  chatbot.init(path);  // Adjust path accordingly

  final encoded = chatbot.encode("What is an mitochondria?");
  print("Input IDs: ${encoded['input_ids']}");
  print("Attention Mask: ${encoded['attention_mask']}");
  print("Decoder Input IDs: ${encoded['decoder_input_ids']}");

  final decoded = chatbot.decode([0,1311,32,17128,26,52,23,9,33,3640,3167,435,16,8,28642,5,328,33,1966,21,8,999,13,17320,11,827,5,328,33,1381,16,8,24893]);
  print("Decoded Answer: $decoded");
}

Future<Map<String, dynamic>> encode({required String question}) async{
  final chatbot = Chatbot();
  String path = await copyModelToAppDirectory();
  chatbot.init(path);  // Adjust path accordingly

  final encoded = chatbot.encode(question);

  List<List<int>> input_ids = [encoded['input_ids']];
  List<List<int>> attention_mask = [encoded['attention_mask']];
  List<List<int>> decoder_input_ids = [encoded['decoder_input_ids']];

  return {
    "input_ids" : input_ids,
    "attention_mask" : attention_mask,
    "decoder_input_ids" : decoder_input_ids
  };
}

Future<String> decode({required List<int> encoded}) async{
  final chatbot = Chatbot();
  String path = await copyModelToAppDirectory();
  chatbot.init(path);  // Adjust path accordingly
  final decoded = chatbot.decode(encoded);
  return decoded.toString();
}


