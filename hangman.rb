require 'yaml'
class Hangman 
  def initialize(file='5desk.txt')
    if Dir.glob('games/*.yaml').size > 0 && play_saved_game?
      load_saved_game
    else
      @file = file
      @word_to_guess = get_random_word_from_file(@file)
      @misses = ''
      @word = ''
      @word_to_guess.length.times {@word << '-'}
    end
    play_game
  end

  private

  def load_saved_game
    the_files = Dir.glob('games/*.yaml')
    the_files.each_with_index {|fname, index| puts "#{(index + 65).chr} -- #{fname}"}
    print 'Enter letter of game you wish to load: '

    chosen_file_letter = get_character
    until chosen_file_letter.ord-65 < the_files.size && chosen_file_letter != '1'
      chosen_file_letter = get_character
    end
    file_to_load = the_files[chosen_file_letter.ord-65]
    data = YAML.load(File.open(file_to_load, "r"){ |file| file.read })
    @word_to_guess = data[0]
    @word = data[1]
    @misses = data[2]
  end

  def play_saved_game?
    print 'Do you want to play a saved game? (y/n)? '
    get_character == 'Y' ? true : false
  end

  def save_game
    data = [@word_to_guess, @word, @misses]
    filename = Time.now.to_s[0...-6]
    while File.exist?(filename)
      filename = Time.now.to_s
    end
    filename = "hangman#{filename}.yaml"
    Dir.mkdir("games") unless Dir.exist?("games")
    File.open("games/#{filename}", "w"){ |somefile| somefile.puts YAML.dump(data)}
    puts
    puts "File games/#{filename} created"
    puts
  end

  def quit_and_or_save
    print 'Do you want to save the current game (y/n)? '
    if get_character == 'Y'
      save_game
    else
      exit
    end
  end

  def get_random_word_from_file(word_file)
    # Loads the file and returns a random word betwee 5 and 12 characters
    unless File.exist?(word_file)
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

  def build_hangman(part)
    case part
    when 2
      puts 'O'.rjust(75)
    when 4
      puts 'O'.rjust(75)
      puts '|'.rjust(75)
    when 6
      puts 'O'.rjust(75)
      puts "\\|".rjust(75)
    when 8
      puts 'O'.rjust(75)
      puts "\\|/".rjust(76)
    when 10
      puts 'O'.rjust(75)
      puts "\\|/".rjust(76)
      puts "/".rjust(74)
    when 12
      puts 'O'.rjust(75)
      puts "\\|/".rjust(76)
      puts "/ \\".rjust(76)
    else
    end
  end

  def get_character
    # gets a character from the keyboard without pressing return
    character = ''
    until character.match(/^[[:alpha:]]$/) || character == '1'
      begin
        system("stty raw -echo")
        character = STDIN.getc.upcase
      ensure
        system("stty -raw echo")
      end
    end
    puts character
    character
  end

  def play_game
    loop do
      puts "Debugging only ---> #{@word_to_guess}  <--- Debugging only" if $VERBOSE
      build_hangman(@misses.length) 

      puts "Word: #{@word}     misses (6 allowed): #{@misses}"
      if @word == @word_to_guess.upcase 
        puts "You win! You correctly guessed that the word is #{@word_to_guess.upcase}"
        exit
      elsif @misses.length >= 12
        puts 'You lose!'
        puts "The word was #{@word_to_guess.upcase}"
        exit
      end
      print "Guess (1 to quit): "
      guess_char = get_character
      if guess_char == '1'
        print 'Are you sure you want to quit? (y/n)? '
        if get_character == 'Y'
          quit_and_or_save
        else
          next
        end
      elsif @word_to_guess.upcase.include?(guess_char)
        # return array of all index positions of guess_char wihtin @word_to_guess
        (0 ... @word_to_guess.length).find_all { |i| @word_to_guess.upcase[i,1] == guess_char }.each { |index| @word[index] = guess_char}
      else
        @misses << guess_char + ' ' unless @misses.include?(guess_char)
      end
    end
  end

end

Hangman.new