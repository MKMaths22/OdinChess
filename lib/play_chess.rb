#frozen_string_literal: true

require './game.rb'
require 'yaml'
require 'minitest'

puts "Welcome to Chess!"
sleep(2)

def games_saved?
  Dir.mkdir('saved_games') unless Dir.exist?('saved_games')
  Dir.empty?('saved_games') ? false : true
end

def offer_reload
  Dir.chdir('saved_games')
  names_available = Dir['./*'].map { |string| string[2..-5] }
  # which removes "./" and ".txt" just outputting the names chosen when games were saved
  puts "I have found #{game_or_games(names_available.size) }."
  list(names_available)
  puts "Type the number of a saved game to reload it, or anything else for a new game."
  Dir.chdir('..')
  value = gets.strip
  reload_or_new(names_available, value)
end

def reload_or_new(array, string)
  number = string.to_i - 1
  # if the string was not of numerical form, number will be -1 which is not valid for reloading anyway!
  if array[number] && number.between?(0,array.size - 1)
  # needed because otherwise ruby interprets array[-1] as last item in array
    reload(array, number)
  else
    Game.new.play_game
  end
end

def reload(array, number)
  # the number is the actual place in the array enumerated from 0, not the number displayed (which is 1 higher)
  Dir.chdir('saved_games')
  puts "Reloading..."
  sleep(2)
  name_of_file = "#{array[number]}.txt"
  file_for_loading = File.open(name_of_file, 'r')
  yaml_string = file_for_loading.read
  File.delete(file_for_loading)
  Dir.chdir('..')
  reloaded_game = YAML.unsafe_load(yaml_string)
  reloaded_game.play_game
end

def game_or_games(num)
  num > 1 ? 'some saved games' : 'a saved game'
end

def list(array)
  array.each_with_index do |name, index|
  puts "#{index.to_i + 1}.  #{name}"
  end
end

def stop_chess_boolean
  puts "Press Y to play again, or anything else to leave the Chess program."
  text = gets.strip.upcase
  text == 'Y' ? false : true
end

bye = false

until bye
  game = Game.new(Board.new, ['player_one', 'player_two', 'e2e4', 'e7e5', 'd1f3', 'a7a6', 'f1c4', 'h7h6', 'f3f7'])
  games_saved? ? offer_reload : game.play_game
  bye = stop_chess_boolean
end

puts "Thanks for playing Chess. Goodbye."

class ChessTest < Minitest::Test


end

