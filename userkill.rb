#!/usr/bin/ruby1.9.1

#just a little script to kill any browsers that the little man may
#decide to push the boundaries with, when he's managed to stay up
#a little bit later than myself.

require 'sys/proctable'
require 'optparse'
include Sys

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
    puts "Unable to slaughter all of root's processes; this will\n"
    puts "bring down the system!"
    exit
end

if (ARGV.size != 1)
    uid = lookup_uid("deschain")
else
    uid = lookup_uid(ARGV[0])
end

ProcTable.ps{ |proc|
    if (proc.uid == uid)
	begin
	    Process.kill(15, proc.pid)
	rescue SystemCallError => e
	    raise e unless (e.errno == Errno::ESRCH)
	end
    end
}


