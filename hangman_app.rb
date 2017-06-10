require 'sinatra'
require 'sinatra/reloader' if development?

configure do
  enable :sessions
  set :sessions_secret, "secret"
end

get '/' do
  @session = session
  word = params['word']
  set_game if session[:game].nil?
  if params['game'] == "new"
    set_game
  end
  erb :index, :locals => {:game => @session['game'], :word => params['word'], :guess_counter => session[:game].guess_counter }
end



helpers do
  def set_game
    session[:game] = Game.new
  end
end

class Game
  attr_accessor :word_choice, :print_guess, :guess_counter, :guess, :guess_word
  def initialize
    @word_choice = File.readlines('./lib/movies.txt').sample.strip
    @word_choice = @word_choice.upcase!
    @guess_word = @word_choice.scan(/\w|\s/)
    @print_guess = @guess_word.inject([]) { |a,element| a << element.dup }
    @print_guess.each { |letter| letter.gsub!((/\w/), '_') }
    @guess_counter = 8
    @guess = []
  end

  def check_guess(let)
    @guess_word.each_with_index do |letter, i|
      @print_guess.each_with_index do |l, j|
        j = i
        if let =~ /#{letter}/
          @print_guess[j] = let
          @swapped = true
          break
        else
          break
        end
      end
    end
    if @swapped != true
      @guess_counter -= 1
    end
    @swapped = false
  end
end
