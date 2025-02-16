#include "encode_result.h"               // The struct definition above
#include <sentencepiece_processor.h>
#include <string>
#include <vector>
#include <cstring>   // For memcpy, strcpy
#include <cstdlib>   // For malloc/free if needed

extern "C" {

// 1) Initialize the SentencePiece model
sentencepiece::SentencePieceProcessor* init_model(const char* model_path) {
    auto* sp = new sentencepiece::SentencePieceProcessor();
    if (!sp->Load(model_path).ok()) {
        return nullptr;
    }
    return sp;
}

// 2) Encode the input, replicating your Python logic
//    - "Please answer this biology question: <question>"
//    - Add EOS
//    - Truncate to 64 tokens
//    - Pad up to 64 tokens
//    - Build attention mask
//    - Set decoder_input_ids = [pad_id]
EncodeResult* encode_input(sentencepiece::SentencePieceProcessor* sp, const char* question) {
    const int MAX_LENGTH = 128;

    // Allocate an EncodeResult struct on the heap for returning via FFI
    EncodeResult* result = new EncodeResult();

    // Create the prompt
    std::string prompt = std::string("Please answer this biology question: ") + question;

    // Encode (no direct "add_eos" param in C++ API, so we manually push_back eos_id)
    std::vector<int> input_ids;
    sp->Encode(prompt, &input_ids);

    // Add EOS token
    input_ids.push_back(sp->eos_id());

    // Truncate if > 64
    if (static_cast<int>(input_ids.size()) > MAX_LENGTH) {
        input_ids.resize(MAX_LENGTH);
    }

    // Prepare a 64-length vector padded with pad_id
    std::vector<int> padded_ids(MAX_LENGTH, sp->pad_id());
    for (int i = 0; i < (int)input_ids.size() && i < MAX_LENGTH; i++) {
        padded_ids[i] = input_ids[i];
    }

    // Create attention_mask (1 = not pad, 0 = pad)
    std::vector<int> attention_mask(MAX_LENGTH, 0);
    for (int i = 0; i < MAX_LENGTH; i++) {
        if (padded_ids[i] != sp->pad_id()) {
            attention_mask[i] = 1;
        }
    }

    // Create decoder_input_ids. Python code does [[sp.pad_id()]], i.e. shape [1,1].
    // We'll store just a single int array of length=1 => [pad_id].
    std::vector<int> decoder_ids(1, sp->pad_id());

    // Copy data into the EncodeResult struct's arrays
    result->input_length = MAX_LENGTH;
    result->decoder_length = 1;

    // Allocate memory for each array
    result->input_ids         = new int[MAX_LENGTH];
    result->attention_mask    = new int[MAX_LENGTH];
    result->decoder_input_ids = new int[1];

    // Copy data from std::vectors into raw arrays
    std::memcpy(result->input_ids, padded_ids.data(),      sizeof(int) * MAX_LENGTH);
    std::memcpy(result->attention_mask, attention_mask.data(), sizeof(int) * MAX_LENGTH);
    std::memcpy(result->decoder_input_ids, decoder_ids.data(), sizeof(int) * 1);

    return result;
}

// 3) Decode output tokens to text (like your Python decode_output).
//    This function expects a flat array `tokens` of length = `length`.
//    It removes pad_id and eos_id, then calls sp->Decode.
char* decode_output(sentencepiece::SentencePieceProcessor* sp, const int* tokens, int length) {
    std::vector<int> filtered_tokens;
    filtered_tokens.reserve(length);
    for (int i = 0; i < length; i++) {
        if (tokens[i] != sp->pad_id() && tokens[i] != sp->eos_id()) {
            filtered_tokens.push_back(tokens[i]);
        }
    }

    // Decode into a std::string
    std::string decoded;
    sp->Decode(filtered_tokens, &decoded);

    // Return a *heap-allocated* C-string for FFI
    // (Make sure your Flutter side frees this using free_char_ptr below)
    char* output = (char*)std::malloc(decoded.size() + 1);
    std::strcpy(output, decoded.c_str());
    return output;
}

// 4) Free the EncodeResult struct
//    This cleans up all the memory we allocated in encode_input.
void free_encode_result(EncodeResult* result) {
    if (!result) return;
    delete[] result->input_ids;
    delete[] result->attention_mask;
    delete[] result->decoder_input_ids;
    delete result;
}

// 5) Free any C-string allocated by decode_output
void free_char_ptr(char* ptr) {
    if (ptr) std::free(ptr);
}

} // extern "C"
