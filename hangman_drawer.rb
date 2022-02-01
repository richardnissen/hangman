# frozen_string_literal: true

# Printer for the Hangman Game
module HangmanDrawer
  HANGMAN = ['
    +---+
    |   |
        |
        |
        |
        |
  =========', '
    +---+
    |   |
    O   |
        |
        |
        |
  =========', '
    +---+
    |   |
    O   |
    |   |
        |
        |
  =========', '
    +---+
    |   |
    O   |
   /|   |
        |
        |
  =========', '
    +---+
    |   |
    O   |
   /|\  |
        |
        |
  =========', '
    +---+
    |   |
    O   |
   /|\  |
   /    |
        |
  =========', '
    +---+
    |   |
    O   |
   /|\  |
   / \  |
        |
  ========='].freeze
  def print_man(lives)
    HANGMAN[lives]
  end
end
