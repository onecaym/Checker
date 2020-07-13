require 'csv'
require 'fileutils'
require 'digest/sha1'

class Checker
  def initialize(folder)
    @folder = folder
  end

  def content_of_given_folder
    Dir.children(@folder)
  end

  def file_reader(dir,file_name)
    File.read("#{dir}#{file_name}")
  end

  def sha1_encoder(dir,file_name)
    Digest::SHA1.hexdigest file_reader(dir,file_name)
  end

  def hash_converter
      content_of_given_folder.map do |file_name|
        { file_name => sha1_encoder(@folder,file_name)}
      end
  end

  def repetitive_value
    uniq_value = hash_converter.map { |hash| hash.values.join }
    uniq_value.detect { |code| uniq_value.count(code) > 1 }
  end


  def check
      hash_converter.map do |hash|
        if repetitive_value == hash.values.first
          puts "#{hash.keys.first} - Использован несколько раз"
        else
          puts "#{hash.keys.first} - Повторений нет"
        end
      end
  end
end
