#!/usr/bin/ruby
argv = ARGV[0].to_s

i = 0;

fd = open(argv,"r")
fo = open("result/#{argv.delete("log/"+"/.txt")}.csv","w")
fo.puts "x,y,z"
while l = fd.gets
	data = l.chomp.split(":")
	if i > 2
		i = 0;
	end
	case i
		when 0
			x = data[1]
		when 1
			y = data[1]
		when 2
			z = data[1]
	end
	if i == 2
		fo.puts "#{x},#{y},#{z}"
	end
	i = i + 1
end
