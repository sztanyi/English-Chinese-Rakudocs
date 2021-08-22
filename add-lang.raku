#!/usr/bin/env raku

sub MAIN(Str $file) {
    my Int $count = 0;

    for $file.IO.lines -> Str $line {
        my Str $new_line = "";
        if $line.starts-with('```') {
            $count++;
            if $count % 2 {
                if not $line.contains('Raku') {
                    $new_line = "{$line}Raku";
                }
            }
        }

        if $line.starts-with('#') and $line.ends-with('#___top)') {
            $new_line = remove_link($line)
        }

        if not $new_line {
            $new_line = $line;
        }

        say $new_line;
    }
}

sub remove_link (Str $l --> Str) {
    my $line = $l;
    $line ~~ s/^ ('#'+ \s) \[ /$0/;
    $line ~~ s/\] \( https .* \) $//;
    return $line;
}

