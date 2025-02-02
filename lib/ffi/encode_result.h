#ifndef ENCODE_RESULT_H
#define ENCODE_RESULT_H

#ifdef __cplusplus
extern "C" {
#endif

typedef struct {
    int* input_ids;         // Array of size 64
    int* attention_mask;    // Array of size 64
    int  input_length;      // = 64
    int* decoder_input_ids; // Array of size 1
    int  decoder_length;    // = 1
} EncodeResult;

#ifdef __cplusplus
}
#endif

#endif // ENCODE_RESULT_H
