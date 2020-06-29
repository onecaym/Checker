require 'csv'
require 'fileutils'
require 'digest/sha1'

# This class gives one instrument for finding a few repetitive files inside given folder
# @example
# checker = Checker.new('folder/')
# Every folder shouldn't have a subfolder
class Checker
  def initialize(folder)
    @folder = folder
  end

  private

  # @private
  def file_code
    folder_content = Dir.children(@folder)
      hash_code = folder_content.map do |file_name|
        { file_name => (Digest::SHA1.hexdigest File.read("#{@folder}#{file_name}")) }
      end
  end

  # @private
  def repetitive_value
    uniq_value = file_code.map { |hash| hash.values.join }
    uniq_value.detect { |code| uniq_value.count(code) > 1 }
  end

  public

  # Returns a full list of repetitive files
  # @return [String]
  def check
      file_code.map do |hash|
        if repetitive_value == hash.values.first
          puts "#{hash.keys.first} - Использован несколько раз"
        else
          puts "#{hash.keys.first} - Повторений нет"
        end
      end
  end
end
