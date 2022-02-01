require './hangman_drawer.rb'
require 'msgpack'

class Hangman
  include HangmanDrawer

  attr_accessor :guesses, :lives, :word
  def initialize
    @guesses = Array.new
    @lives = 6
    @word = random_word
  end

  def hangman
    print_man(@lives)
  end

  def random_word
    lines = File.readlines('word-list.txt')
    lines.select { |line| line.length <= 12 && line.length >= 5 }.sample.strip # 13 and 6 because of the newline character and strip to remove newline
  end

  def game_over?
    lost? || won?
  end

  def lost?
    @lives == 0
  end

  def won?
    @word.each_char do |c|
      return false unless @guesses.include?(c)
    end
    return true
  end

  def clue
    clue = ""
    @word.each_char do |c|
      if @guesses.include?(c)
        clue = clue.concat(c)
      else
        clue = clue.concat('_')
      end
      clue = clue.concat(' ')
    end
    clue
  end

  def guess(guess)
    guess = guess.downcase
    if @guesses.include?(guess) || @lives == 0 || guess.length != 1 then return false end
    @lives -= 1 unless @word.include?(guess)
    @guesses.push(guess)
  end

  def save(filename)
    msgpack = MessagePack.dump ({
      :guesses => @guesses,
      :lives => @lives,
      :word => @word
    })
    Dir.mkdir('saves') unless Dir.exist?('saves')
    File.open("saves/#{filename}.save", 'w') do |file|
      file.puts(msgpack)
    end
  end

  def load(filename)
    unless File.exist?("saves/#{filename}.save")
      return false
    else
      msgpack = File.read("saves/#{filename}.save").chomp
      data = MessagePack.load msgpack
      @guesses = data['guesses']
      @lives = data['lives']
      @word = data['word']
    end
  end
end

game = Hangman.new
puts 'Hangman initialized, write \'save\' for saving and \'load\' for loading and \'exit\' for exiting'
until game.game_over?
  puts game.print_man(game.lives)
  puts game.clue
  puts "Your guesses: #{game.guesses}"
  puts 'Your guess:'
  input = gets.chomp
  if input == 'save'
    puts 'Save name:'
    game.save(gets.chomp)
  elsif input == 'load'
    puts 'Load file:'
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