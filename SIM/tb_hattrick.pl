#!c:/perl64/bin/perl.exe

# declared a variable and set to nothing ""
$cmd = "";

# read from a standard input file (<>)
# perl tb_hattrick.pl tb_hattrick.pp.v > tb_hattrick.v

while (<>) {
  # read each line into a hidden default variable $_
  if (/^;/) {   # find the first ; in any line  (special character ^: first in line, $: last in line)
    s/^;//;     # substitue(replace) initial ^ with nothing
    $cmd .= $_; # concatenate $cmd with the current line
  }
  else {
    s/\"/\\\"/g;
    $cmd .= "printf\(\"$_\"\);";
  }
}
eval $cmd;
