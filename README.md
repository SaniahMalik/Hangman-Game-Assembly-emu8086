
#  Hangman Game - 8086 Assembly Language (emu8086)

##  Project Overview
This project is a fully functional, interactive **Hangman Game** developed in **8086 Assembly Language** using the **emu8086 emulator** for the COAL curriculum. Players guess a hidden word letter by letter within a limited number of attempts.

##  What's Included
* **hangman.asm / hangman.txt:** Core source code containing string comparison, game loop, and interrupt logic.
* **Project Documentation:** Comprehensive report covering flowcharts, register tracking, and algorithm details.

## 🚀 Key Features & Implementation Logic
* **Dynamic String Matching:** Implemented custom logic to compare user input letters against characters of the secret word.
* **Game State Management:** Tracks remaining attempts, correct guesses, and winning/losing states using processor registers.
* **Interrupt Handling (INT 21h & INT 10h):** Used system calls for reading keyboard inputs instantly and rendering the text output on the emulator console.
* **Low-Level Controls:** Handled screen updating and conditional branches (`CMP`, `JE`, `JNE`, `LOOP`) to manage the game flow.
