#!/usr/bin/env ruby
# The program takes checkin checkout data from a log file specified as a
# parameter from the command line (or in the absence of a parameter from 
# the first line of standard input reads content from the memory ). 
# The contents are read line by line and parsed to tokens which are 
# processed to show the time and visits related to a room. 
#
# Author::    Rajeev Singh  (mailto:rajdac@yahoo.com)
# Copyright:: Copyright (c) 2014 The Pragmatic Programmer, LLC
# License::   Distributes under the same terms as Ruby
# 
# summary Foot-Traffic Analysis
#
# program that takes a formatted log file that describes the overall gallery's foot-traffic on a minute-to-minute basis. 
# From this data you must compute the average time spent in each room, and how many visitors there were in each room.
# 
# Input Description 
# 
# You will be first given an integer N which represents the following N-number of lines of text. Each line represents either a visitor entering or leaving a room: it starts with an integer, representing a visitor's unique identifier. Next on this line is another integer, representing the room index. Note that there are at most 100 rooms, starting at index 0, and at most 1,024 visitors, starting at index 0. Next is a single character, either 'I' (for "In") for this visitor entering the room, or 'O' (for "out") for the visitor leaving the room. Finally, at the end of this line, there is a time-stamp integer: it is an integer representing the minute the event occurred during the day. This integer will range from 0 to 1439 (inclusive). All of these elements are space-delimited. 
# You may assume that all input is logically well-formed: for each person entering a room, he or she will always leave it at some point in the future. A visitor will only be in one room at a time. 
# Note that the order of events in the log are not sorted in any way; it shouldn't matter, as you can solve this problem without sorting given data. Your output (see details below) must be sorted by room index, ascending.
# 
# Output Description 
#
# For each room that had log data associated with it, print the room index (starting at 0), then print the average length of time visitors have stayed as an integer (round down), and then finally print the total number of visitors in the room. All of this should be on the same line and be space delimited; you may optionally include labels on this text, like in our sample output 1.
# Sample Inputs & Outputs
#
# Sample Input  
#
# 4
# 0 0 I 540
# 1 0 I 540
# 0 0 O 560
# 1 0 O 560
#
# Sample Output  
# Room 0, 20 minute average visit, 2 visitor(s) total
# 
 

# This functionality is there in rails only so added to ruby
# 
class Fixnum
	def ordinalize
		if (11..13).include?(self % 100)
		  "#{self}th"
		else
		  case self % 10
			when 1; "#{self}st"
			when 2; "#{self}nd"
			when 3; "#{self}rd"
			else    "#{self}th"
		  end
		end
	end
end


# The data could be in csv or separated by space which is the default delimiter
#
module Parser 
	def parse string,delimiter=" "
		string.split delimiter
	end 
end	

# Hash utilities similar to array
#	
module HashUtils

 extend self
 
	# The hash is sorted based on the room hash. 
	# This sort will work on the integer hash so in the transformer the string hash is converted to integer.
	#
	def sort data
		nh = {}			
		self.count(data).times do
			nh = {}
			data.keys.sort.each do |k|
				nh[k] = data[k]
			end
		end
		data =  nh;
	end
	     
   	# For the hash there is no count property.
	#
	def count data
		count = 0;
		data.keys.each do 
			count +=1           
		end
		count
	end	
	
end

# Super class to memory and file datasource
#
class DataSource 
    
	attr_reader :source_info, :print_source_info
  	
	# We register adapters into this class variable
    #
    @@adapters = []
    
    # class reader
    #
    def self.register_class( exp )
      @@adapters << [self, exp]
    end
		 
    # Factory method
    #
    def self.instance( datasource , params )
       match = @@adapters.find(nil) {|klass, exp| datasource =~ exp}
       raise 'not implemented' if match.nil?
       match.first.new params
    end
    	
	def initialize params=nil
		@source_info = self.class.name	
		@print_source_info = "\n\n == Data sourced from #{@source_info} on " + Time.now.strftime("#{Time.now.day.ordinalize} of %B, %Y at%l:%M %p" ) + " == \n\n" 
		post_initialize(params) 
	end
	
	# subclasses may override
	#
	# Abstract superclasses use the template method pattern to invite inheritors to supply specializations,
	# and use hook methods to allow these inheritors to contribute these specializations without being forced to send super.
	# Hook methods allow subclasses to contribute specializations without knowing the abstract algorithm. 
	# They remove the need for subclasses to send super and therefore reduce the coupling between 
	# layers of the hierarchy and increase its tolerance for change
	#
    def post_initialize params=nil
       nil
    end
 	
	def get_record_count
      raise NotImplementedError
    end
	
	def get_row
      raise NotImplementedError
    end
	
	def free_resources
      raise NotImplementedError
    end
	
			
end 		

# One of the possible datasource could be a file 
#
class FileSource <  DataSource
    attr_reader :file_path
		 
	def post_initialize params=nil
	    @file_path = params
		raise ArgumentError unless File.exists?( @file_path ) 
		@log = File.open( @file_path )
	end

	def get_record_count 
		self.get_row.to_i
	end
	
	def get_row
		@log.gets
	end
	
	def free_resources 
		@log.close
	end
		
	register_class /file/
		
end

# The other possible data source is from memory. One of the possibilities is all data from various sources in any format could be converted to this format of memory data 
#	
class MemorySource <  DataSource
    
	def post_initialize params=nil		   
		@arr =  [
    			    "0 11 I 347", "1 13 I 307", "2 15 I 334", "3 6 I 334", "4 9 I 334", "5 2 I 334", "6 2 I 334", "7 11 I 334", "8 1 I 334", "0 11 O 376", 
					"1 13 O 321", "2 15 O 389", "3 6 O 412", "4 9 O 418", "5 2 O 414", "6 2 O 349", "7 11 O 418", "8 1 O 418", "0 12 I 437", "1 28 I 343",
					"2 32 I 408", "3 15 I 458", "4 18 I 424", "5 26 I 442", "6 7 I 435", "7 19 I 456", "8 19 I 450", "0 12 O 455", "1 28 O 374",
					"2 32 O 495", "3 15 O 462", "4 18 O 500", "5 26 O 479", "6 7 O 493", "7 19 O 471", "8 19 O 458"
				]
	end
		
	def get_record_count 
		count = @arr.count
	end
	
	def get_row
		@arr.shift
	end 
	
	def free_resources 
		@arr.delete("")
	end
	
	register_class /memory/
		
end


# The data from file or memory source is injected by dependency injection and transformed to hashes grouped by room
#	
class Transformer
    
	# Include parser module
	# Each row of data is parsed to tokens. This parsing algorithm could be a simple split based on delimiters.
	# 
	include Parser
	
	# The datasource for the object is set to file of memory object 
	#
	def initialize data_source
		@data_source =  data_source 
		@no_of_lines_to_process = data_source.get_record_count
		@result = {}
	end
			
	# The consumer of this class would use this method to get the 
	#
	def get_data
		self.process
		@result 
	end
		
	# Aggregate the results based on room hash
	#
	def process
	    room_info_arr = {}					
		@no_of_lines_to_process.times{
			while (line = @data_source.get_row)
				tokens = parse line  # parse function from the parser module
				visitor_index = tokens[0]
				room_number = tokens[1].to_i # will sort properly later      
				room_checkinout_time = tokens[3].to_i 
				
				if room_info_arr[room_number].nil?  # Is it a new room? 
					room_info_arr[room_number] = {}		
					room_info_arr[room_number][:total_time] = 0
					room_info_arr[room_number][:visitor_count] = 0
				end
				
				if  room_info_arr[room_number][visitor_index].nil?   # Is the visitor visiting the room first time?
					room_info_arr[room_number][visitor_index] =  room_checkinout_time
					room_info_arr[room_number][:visitor_count] +=1   # new visitor increment the count
				else # The visitor has exit the room
				    room_info_arr[room_number][:total_time] += room_checkinout_time - room_info_arr[room_number][visitor_index] 
					room_info_arr[room_number].delete(visitor_index)
				end
			end # end while  
		}			
			@data_source.free_resources 
			@result = room_info_arr
			 		
		end 	

	end

	
# Generate a report of room statistics data on the screen
#	
module Report
	
	require 'pp' # Printing variable dump for debug purposes  
    require 'active_support/inflector'  # Need for pluralizing
   	
	extend self	
	
	# Return the plural form 
	#
	def pluralize count, noun, text = nil
		if count != 0
			count == 1 ? "#{noun}#{text}" : "#{noun.pluralize}#{text}"
		end
	end
		 
	# Show log info room visited statistics
	#
	def show header, data
		# use pp @data to inspect any array or hash during debug 
		puts header # Show the data source   	
		data = HashUtils.sort data
		data.each do |key, record|
		
			# Return pural form of minute text
 		    # 
			minute_text = self.pluralize(record[:total_time],'minute') 
		
			# Return pural form of visitor text
		    #
			visitor_text = self.pluralize(record[:visitor_count],'visitor') 
		
			# unformatted display  
			# puts  "       Room #{key}, #{record[:total_time]} #{minute_text} average visit, #{record[:visitor_count]}  #{visitor_text} total "
			  
			# Formatted display
			#
			printf " Room %3s, %3s %5s average visit, %s %8s total \n", key,record[:total_time],minute_text,record[:visitor_count],visitor_text
			  
		end
		  
	end

end

# Main class which fetches the data , converts to to hash and displays the data on the screen
#
class Application 
    
   	attr_reader :params, :result, :data_source
	
	def initialize params=nil
	    @params = params
	end 
	  
	def get_data_source 
	    		
		if @params.nil?
		    source = 'memory'			
		else
		    source = 'file'			
	    end
		
		@data_source = DataSource.instance(source,params) 
	end 
		
	def process_data 
		transformer =  Transformer.new @data_source
		@result = transformer.get_data
	end
		
	def display 
	    # using the module namespace to avoid namespace collision  
	    #
		Report.show @data_source.print_source_info, @result
	end
	
	def run
	    self.get_data_source
		self.process_data
		self.display
	end
	   
end

#if __FILE__ == $0
	app = Application.new( *ARGV )
	app.run
#end
