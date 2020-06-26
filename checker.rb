require 'csv'
require 'fileutils'
require 'digest/sha1'

class Checker
	include Enumerable
	def initialize(folder)
		@lib = folder
	end

	def check
		massive1 = Dir.entries(@lib).reject {|name| !name.include?("txt")}
		@secur = massive1.map do |name| 
			{ name => (Digest::SHA1.hexdigest (File.read("#{@lib}#{name}")))}
		end
		value =  @secur.map {|hsh| hsh.values.join}
		founded_sym = value.detect {|f| value.count(f) > 1}
		@secur.map do |hash|
			if founded_sym == hash.values.first
				puts "#{hash.keys.first} - Использован несколько раз"
			else
				puts "#{hash.keys.first} - Повторений нет"
			end
		end
	end
end
