require 'set'
require 'byebug'

class WordChainer

  def initialize(dictionary_file_name = "dictionary.txt")
    words = File.readlines(dictionary_file_name).map(&:chomp)
    @dictionary = Set.new(words)
  end

  def adjacent_words(word)
    selected = @dictionary.select {|el| el.length == word.length}
    selected.select { |el| adjacent_words_helper(word, el) }
  end

  def adjacent_words_helper(source, word)
    counter = 0
    idx = 0
    while idx < source.length
      counter += 1 if word[idx] != source[idx]
      idx += 1
    end
    return false if counter > 1
    true
  end

  def run(source, target)
    @current_words = [source]
    @all_seen_words = {source => nil}
    until @current_words.empty? || @all_seen_words.include?(target)
      explore_current_words
      end
    return build_path(target)
  end

  def explore_current_words
    new_current_words = []
    @current_words.each do |current_word|
      adjacent_words(current_word).each do |adjacent_word|
        next if @all_seen_words.include?(adjacent_word)
        new_current_words << adjacent_word
        @all_seen_words[adjacent_word] = current_word
        #reminder: current_word is word we came from, adjacent_word is from function with current_word as input
      end
    end
    @new_current_words
    @current_words = new_current_words
  end

  def build_path(target)
    path = []
    current_word = target
    until current_word.nil?
      path << current_word
      current_word = @all_seen_words[current_word]
    end
    path.reverse
  end

end

if __FILE__ == $PROGRAM_NAME
  new_game = WordChainer.new
  p new_game.run("duck", "ruby")
end
