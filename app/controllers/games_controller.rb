require "open-uri"

class GamesController < ApplicationController
  def new
    @letters = []
    10.times { @letters << ('A'..'Z').to_a.sample }
    @letters
  end

  def score
    @word = params[:user_input]
    @letters = params[:letters]
    run_game(@word, @letters)
  end

  private

  def run_game(word, letters)
    @message = message(word.upcase, letters)
    @score = user_score(word.upcase, letters)
  end

  def message(word, letters)
    message = ''
    api = api_test("https://wagon-dictionary.herokuapp.com/#{word}")
    if word_exist(word, letters) && api && letter_repeat(word, letters)
      message = 'well done'
    elsif word_exist(word, letters) == false || letter_repeat(word, letters) == false
      message = 'not in the letters'
    else
      message = 'not an english word'
    end
    message
  end

  def letter_repeat(word, letters)
    try = word.upcase.split(//)
    letter_repeat = try.all? { |letter| try.count(letter) <= letters.count(letter) }
    letter_repeat
  end

  def word_exist(word, letters)
    try = word.upcase.split(//)
    word_exist = try.all? { |letter| letters.include?(letter) }
    word_exist
  end

  def user_score(word, letters)
    if message(word.upcase, letters) == 'well done'
      score = word.length**3
    else
      score = 0
    end
    score
  end

  def api_test(url)
    word_serialized = open(url).read
    word = JSON.parse(word_serialized)
    word['found']
  end
end
