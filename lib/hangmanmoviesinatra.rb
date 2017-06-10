class Game
  attr_accessor :word_choice
  def initialize
    @word_choice = File.readlines('movies.txt').sample.strip
    @word_choice = @word_choice.upcase!
    @guess_word = @word_choice.scan(/\w|\s/)
    @print_guess = @guess_word.inject([]) { |a,element| a << element.dup }
    @print_guess.each { |letter| letter.gsub!((/\w/), '_ ') }
    @guess_counter = 0
    @guess = []
  end

  def check_guess
    @guess_word.each_with_index do |letter, i|
      @print_guess.each_with_index do |l, j|
        j = i
        if @player_guess =~ /#{letter}/
          @print_guess[j] = @player_guess
          @swapped = true
          break
        else
          break
        end
      end
    end
    if @swapped != true
      @guess_counter += 1
    end
    @swapped = false
  end
end
