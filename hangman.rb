# frozen_string_literal: true

require './hangman_drawer'
require 'msgpack'

# Main game class
class Hangman
  include HangmanDrawer

  attr_accessor :guesses, :lives, :word

  def initialize
    @guesses = []
    @lives = 6
    @word = random_word
  end

  def hangman
    print_man(@lives)
  end

  def random_word
    lines = File.readlines('word-list.txt')
    # 13 and 6 because of the newline character and strip to remove newline
    lines.select do |line|
      line.length <= 12 && line.length >= 5
    end.sample.strip
  end

  def game_over?
    lost? || won?
  end

  def lost?
    @lives.zero?
  end

  def won?
    @word.each_char do |c|
      return false unless @guesses.include?(c)
    end
    true
  end

  def clue
    clue = []
    @word.each_char do |c|
      if @guesses.include?(c)
        clue.push(c)
      else
        clue.push('_')
      end
      clue.push(' ')
    end
    clue.join('')
  end

  def guess(guess)
    guess = guess.downcase
    return false if @guesses.include?(guess) || @lives.zero? || guess.length != 1

    @lives -= 1 unless @word.include?(guess)
    @guesses.push(guess)
  end

  def save(filename)
    msgpack = MessagePack.dump({
                                 guesses: @guesses,
                                 lives: @lives,
                                 word: @word
                               })
    Dir.mkdir('saves') unless Dir.exist?('saves')
    File.open("saves/#{filename}.save", 'w') do |file|
      file.puts(msgpack)
    end
  end

  def load(filename)
    if File.exist?("saves/#{filename}.save")
      msgpack = File.read("saves/#{filename}.save").chomp
      data = MessagePack.load msgpack
      @guesses = data['guesses']
      @lives = data['lives']
      @word = data['word']
    else
      false
    end
  end

  def list_saves
    Dir.glob('saves/*').map { |location| location[6..-6] } if Dir.exist?('saves')
  end
end

game = Hangman.new
puts 'Hangman initialized, write \'save\' for saving and \'load\' for loading and \'exit\' for exiting'
until game.game_over?
  puts game.hangman
  puts game.clue
  puts "Your guesses: #{game.guesses}"
  print 'Your guess: '
  input = gets.chomp
  if input == 'save'
    print 'Save name: '
    game.save(gets.chomp)
  elsif input == 'load'
    puts "Saves: #{game.list_saves}"
    print 'Load file: '
    game.load(gets.chomp)
  elsif input == 'exit'
    exit
  elsif !game.guess(input)
    puts "Please type only one character and only one you haven't already guessed"
  end
end
puts game.hangman
if game.lost?
  puts "Nice try, but hangman is dead. The correct word was \"#{game.word}\""
else
  puts 'Well done you saved hangman!'
end
