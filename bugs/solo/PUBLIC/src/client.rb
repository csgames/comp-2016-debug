#                 UQAM ON STRIKE PUBLIC LICENSE
#                    Version 2, December 2004
#
# Copyright (C) 2017
# Alexandre Terrasa <@>,
# Jean Privat <@>,
# Philippe Pepos Petitclerc <@>
#
# Everyone is permitted to copy and distribute verbatim or modified
# copies of this license document, and changing it is allowed as long
# as the name is changed.
#
#                 UQAM ON STRIKE PUBLIC LICENSE
#   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
#
#  0. You just do what the fuck you want to as long as you're on strike.
#
# aHR0cDovL2NzZ2FtZXMub3JnLzIwMTYvCg==

require 'socket'
require 'optparse'
require_relative 'utils'

# This challenge is ran with arguments (see tests/testX.args for argument lists)
options = {}
OptionParser.new do |opts|
	opts.banner = "Usage: server.rb [OPTIONS]"

	opts.on("-b", "--binary", "Encode data stream to binary") do |v|
		options[:binary] = v
	end

	opts.on("-r", "--runlength", "Encode data stream to binary and run-length encode") do |v|
		options[:runlength] = v
	end
end.parse!

s = UNIXSocket.open('./solo.sock')

data = ''
while line = s.gets
	data << line
end
s.close

if options[:runlength]
	data = data.split().map { |x| x.to_i }
	enc = RunLengthEncoder.new
	data = enc.decode data
	# p data
end

if options[:binary] || options[:runlength]
	enc = BitStreamEncoder.new
	data = enc.decode data
	# p data
end

if not data.nil?
	print data
end
