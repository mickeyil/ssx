#!/usr/bin/env ruby
#
# SSX - SSH over colorful terminal.
#       Uses consisten colors over the same host names to for better navigation
#       over multiple hosts/windows.
#

require 'zlib'

# Defaults
DEFAULT_FONT     = "9x15"
DEFAULT_GEOMETRY = "120x25"

FG_COLORS = %w[White Yellow White Yellow White]
BG_COLORS = %w[
                rgb:15/15/15
                rgb:46/46/46
                DarkBlue
                rgb:10/10/30
                rgb:10/30/50
              ]


# This method maps hostname to pair of colors
# Given a hostname (string), and two arrays containing color names
# it returns an array of two, with the first element be fg color
# and the second element the background color
def get_colors_by_hostname hostname, fg_array, bg_array
  n = [fg_array.size, bg_array.size].min
  idx = Zlib.crc32(hostname) % n
  [fg_array[idx], bg_array[idx]]
end


# Extract hostname from SSH args. Search for the first argument not without
# a '-' prefix, while skipping those options that have such argument before
# the hostname: i.e. in -l username, discard 'username'.
# Expects: input parameter args to be an array of strings
# Returns: hostname or nil if didn't find one
def extract_hostname_from_args args
  opts_with_arg = %w[b c D e F I i L l m O o p R S W w]
  a = args.dup
  while a.size > 0
    opt = a[0]
    unless opt.chars.first == "-"
      opt.gsub(/^\w+@/,"")
      return opt
    end
    opt_char = opt.chars.to_a[1]
    if opts_with_arg.include? opt_char
      a.shift
      a.shift if a.size > 0
    else
      a.shift
    end
  end
  nil
end


hostname = extract_hostname_from_args ARGV
fg_color, bg_color = get_colors_by_hostname hostname, FG_COLORS, BG_COLORS
args_str = ARGV.join ' '
ssh_cmd  = "ssh #{args_str}"
font     = DEFAULT_FONT
geometry = DEFAULT_GEOMETRY

xterm_cmd = "xterm -font #{font} -geometry #{geometry} -fg #{fg_color}" \
            " -bg #{bg_color} -title #{hostname} -n #{hostname} -e #{ssh_cmd} &"

system xterm_cmd

