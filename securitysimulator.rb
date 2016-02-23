# Security Simulator
#
# $Id$
#
# $Revision$
#
# This program allows you to use a large amount of virtual machines and install vulnerable software to create a learning environment.
#
# By: Lewis Ardern (Leeds Metropolitan University)

require 'getoptlong'
require 'fileutils'
require_relative 'system.rb'
require_relative 'filecreator.rb'
require_relative 'systemreader.rb'
require_relative 'vagrant.rb'

# coloured logo
puts "\e[34m"
File.open('lib/commandui/logo/logo.txt', 'r') do |f1|
	while line = f1.gets
		puts line
	end
end
puts "\e[0m"

# Display help menu
def usage
	puts 'Usage:
   ' + $0 + ' [options]

   OPTIONS:
   --run, -r: builds vagrant config and then builds the VMs
   --build-config, -c: builds vagrant config, but does not build VMs
   --build-vms, -v: builds VMs from previously generated vagrant config
   --help, -h: shows this usage information
'
	exit
end


# Grab all system information from boxes.xml and create vagrant file from that information
#
# Creates systems variable from systemReader.rb, systemReader class, systems method
# Systems variable contains all valid vulnerabilities, services and networks specified by user.
#
# returns build number
# build number contains a file  
#
#
def build_config
	puts 'Reading configuration file for virtual machines you want to create'

	# uses nokogoiri to grab all the system information from boxes.xml
	systems = SystemReader.new(BOXES_XML).systems
	  
	puts 'Creating vagrant file'
	# create's vagrant file / report a starts the vagrant installation'
	create_files = FileCreator.new(systems)
	build_number = create_files.generate(systems)
	return build_number
end

# 
def build_vms(build_number)
	vagrant = VagrantController.new
	vagrant.vagrant_up(build_number)
end

#
def run
	build_number = build_config()
	build_vms(build_number)
end

if ARGV.length < 1
	puts 'Please enter a command option.'
	puts
	usage
end

opts = GetoptLong.new(
	[ '--help', '-h', GetoptLong::NO_ARGUMENT ],
	[ '--run', '-r', GetoptLong::NO_ARGUMENT ],
	[ '--build-config', '-c', GetoptLong::NO_ARGUMENT ],
	[ '--build-vms', '-v', GetoptLong::NO_ARGUMENT ]  
)

opts.each do |opt, arg|
	case opt
		when '--help'
			usage
		when '--run'
			run
		when '--build-config'
			build_config()
		when '--build-vms'
			build_vms()
	end
end


