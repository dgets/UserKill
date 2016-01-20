#!/usr/bin/ruby1.9.1

#just a little script to kill any browsers that the little man may
#decide to push the boundaries with, when he's managed to stay up
#a little bit later than myself.

require 'sys/proctable'
require 'optparse'
include Sys

#defaults (feel free to modify; should be self-explanatory)
DEF_USER = "deschain"
DEF_SIGNAL = 15
VERBOSE = true

def lookup_uid(username)
    require 'etc'

    begin
	user = Etc.getpwnam(username)
    rescue ArgumentError
	raise ArgumentError, "No such user: #{username}"
    end

    return user.uid
end

if (ARGV[0] == "root")
    if (VERBOSE)
	puts "Unable to slaughter all of root's processes; this will\n"
    	puts "bring down the system!"
    end
    exit
end

if (VERBOSE)
    begin
    	puts "Attempting to slaughter processes for #{username}"
    rescue
	puts "Attempting to slaughter processes for #{DEF_USER}"
    end
end

if (ARGV.size < 1)
    uid = lookup_uid(DEF_USER)
else if (ARGV.size > 1 and VERBOSE)
    	puts "Usage:\n\tKill all processes for hardcoded default user"
    	puts "\n\tif not specified, or takes 1 argument as a username"
    	puts "\n\tfor whose processes to slay."
    exit
else
    uid = lookup_uid(ARGV[0])
end

ProcTable.ps{ |proc|
    if (proc.uid == uid)
	if (VERBOSE)
	    puts "Attempting to kill #{uid}"
	end

	begin
	    Process.kill(DEF_SIGNAL, proc.pid)
	rescue SystemCallError => e
	    raise e unless (e.errno == Errno::ESRCH)
	end
    end
}

end
