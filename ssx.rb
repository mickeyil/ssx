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

# Base colors from which color combinations are created.
FG_BASE = %w[
              White
              Yellow
            ]

BG_BASE = %w[
                rgb:0/0/0
                rgb:15/15/15
                rgb:30/30/30
                rgb:45/45/45
                rgb:60/60/60
                rgb:75/75/75

                rgb:30/0/0
                rgb:45/0/0
                rgb:60/0/0
                rgb:75/0/0
                
                rgb:0/30/0
                rgb:0/45/0
                rgb:0/60/0
                rgb:0/75/0

                rgb:0/0/30
                rgb:0/0/45
                rgb:0/0/60
                rgb:0/0/75

                rgb:0/30/30
                rgb:0/45/45
                rgb:0/60/60
                rgb:0/75/75

                rgb:30/30/0
                rgb:45/45/0
                rgb:60/60/0
                rgb:75/75/0

                rgb:30/0/30
                rgb:45/0/45
                rgb:60/0/60
                rgb:75/0/75

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
    return opt.gsub(/^\w+@/,"") unless opt.chars.first == "-"
    opt_char = opt.chars.to_a[1]
    a.shift
    if opts_with_arg.include? opt_char
      a.shift if a.size > 0
    end
  end
  nil
end



# Generate all possible combinations between fg_base and bg_base colors.
# Returns two arrays of the same size, first contains fg colors, second
# contains bg colors.
def generate_color_combinations fg_base, bg_base
  combinations = fg_base.product(bg_base)
  fg_colors = []
  bg_colors = []
  combinations.each do |c|
    fg_colors.push c[0]
    bg_colors.push c[1]
  end
  [fg_colors, bg_colors]
end



hostname = extract_hostname_from_args ARGV
fg_array, bg_array = generate_color_combinations FG_BASE, BG_BASE
fg_color, bg_color = get_colors_by_hostname hostname, fg_array, bg_array
args_str = ARGV.join ' '
ssh_cmd  = "ssh #{args_str}"
font     = DEFAULT_FONT
geometry = DEFAULT_GEOMETRY

xterm_cmd = "xterm -font #{font} -geometry #{geometry} -fg #{fg_color}" \
            " -bg #{bg_color} -title #{hostname} -n #{hostname} -e #{ssh_cmd} &"

system xterm_cmd

