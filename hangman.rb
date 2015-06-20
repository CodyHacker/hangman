def get_random_word_from_file(word_file)
  unless File.exists?(word_file)
    puts "The file: #{word_file} does not exist!"
    exit
  end
  word_list = File.read(word_file).split(/\r\n/)
  random_word = ''
  until random_word.length >= 5 && random_word.length <= 12
    random_word = word_list.sample
  end
  random_word
end


class Hangman 
  def initialize(file='5desk.txt')
    @file = file
    @word_to_guess = get_random_word_from_file(@file)
    puts @word_to_guess
  end
  
end

Hangman.new