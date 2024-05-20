require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = Array.new(10) { ('A'..'Z').to_a.sample }
    @letters.shuffle!
  end

  def score
    @letters = params[:letters].split(" ")
    @word = params[:word].upcase
    @included = included?(@word, @letters)
    @valid = valid_word?(@word)

    if @included && @valid
      @message = "Valid: #{@word}"
      @score = @word.length
    elsif @included
      @message = "Invalid: #{@word}"
      @score = 0
    else
      @message = "Invalid: #{@word} -> matchin</b> none of these letters: #{@letters.join(', ')}."
      @score = 0
    end
  end

  private

  def included?(word, letters)
    word.chars.all? { |letter| letters.count(letter) >= word.count(letter) }
  end

  def valid_word?(word)
    response = URI.open("https://dictionary.lewagon.com/#{word}")
    json = JSON.parse(response.read)
    json['found']
  end
end
