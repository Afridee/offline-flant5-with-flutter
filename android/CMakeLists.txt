cmake_minimum_required(VERSION 3.18.1)
project(MyChatbotProject CXX)

# If needed, specify your C++ standard
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# 1) Add subdirectory for SentencePiece. This will build SentencePiece
#    along with your project if you have not prebuilt it.
#    Replace the second argument with a custom build folder if you like.
add_subdirectory(
    ../external/sentencepiece
    sentencepiece_build
)

# 2) Define your own library
add_library(chatbot
    SHARED
    ../lib/ffi/chatbot.cpp
)

# 3) Link SentencePiece to your chatbot library
target_link_libraries(
    chatbot
    PRIVATE
        sentencepiece  # The target name defined by SentencePiece’s CMakeLists
)

# 4) (Optional) If needed, explicitly add include directories
#    (In most cases, linking to the sentencepiece target will do this for you.)
target_include_directories(
    chatbot
    PRIVATE
        ../external/sentencepiece/src
        # Or wherever "sentencepiece_processor.h" is found
)
