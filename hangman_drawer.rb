# frozen_string_literal: true

# Printer for the Hangman Game
module HangmanDrawer
  def print_man(lives)
    hangman = ['
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
    =========']
    hangman[lives]
  end
end
