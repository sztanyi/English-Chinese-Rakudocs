# Date and time functions

Processing date and time in Perl 6



Perl 6 includes several classes that deal with temporal information: [Date](https://docs.perl6.org/type/Date), [DateTime](https://docs.perl6.org/type/DateTime), [Instant](https://docs.perl6.org/type/Instant) and [Duration](https://docs.perl6.org/type/Duration). The three first are *dateish*, so they mix in the [Dateish](https://docs.perl6.org/type/Dateish) role, which defines all methods and properties that classes that deal with date should assume. It also includes a class hierarchy of exceptions rooted in [X::Temporal](https://docs.perl6.org/type/X::Temporal).

We will try to illustrate these classes in the next (somewhat extended) example, which can be used to process all files in a directory (by default `.`) with a particular extension (by default `.p6`) in a directory, sort them according to their age, and compute how many files have been created per month and how many were modified in certain periods expressed in ranges of months:

```
sub MAIN( $path = ".", $extension = "p6" ) {
    my DateTime $right = DateTime.now;
    my %metadata;
    my %files-month;
    my %files-period;
    for dir($path).grep( / \.$extension $/ ) -> $file {
        CATCH {
            when X::Temporal { say "Date-related problem", .payload }
            when X::IO { say "File-related problem", .payload }
            default { .payload.say }
        }
        my Instant $modified = $file.modified;
        my Instant $accessed = $file.accessed;
        my Duration $duration = $accessed - $modified;
        my $age = $right - DateTime($accessed);
        my $time-of-day = $file.changed.DateTime.hh-mm-ss but Dateish;
        my $file-changed-date =  $file.changed.Date;
        %metadata{$file} = %( modified => $modified,
                              accessed => $accessed,
                              age => $age,
                              difference => $duration,
                              changed-tod => $time-of-day,
                              changed-date => $file-changed-date);
        %files-month{$file-changed-date.month}++;
        given $file-changed-date {
            when Date.new("2018-01-01")..^Date.new("2018-04-01") { %files-period<pre-grant>++}
            when Date.new("2018-04-01")..Date.new("2018-05-31") { %files-period<grant>++}
            default { %files-period<post-grant>++};
        }
    }
 
    %metadata.sort( { $^a.value<age> <=> $^b.value<age> } ).map: {
        say $^x.key, ", ",
        $^x.value<accessed modified age difference changed-tod changed-date>.join(", ");
    };
    %files-month.keys.sort.map: {
        say "Month $^x → %files-month{$^x}"
    };
 
    %files-period.keys.map: {
        say "Period $^x → %files-period{$^x}"
    };
}
```

`DateTime` is used in line 6 to contain the current date and time returned by [`now`](https://docs.perl6.org/routine/now).

A CATCH phaser is declared in lines 11 to 15. Its main mission is to distinguish between `DateTime`-related exceptions and other types. These kind of exception can arise from [invalid formats](https://docs.perl6.org/type/X::Temporal::InvalidFormat) or [timezone clashes](https://docs.perl6.org/type/X::DateTime::TimezoneClash). Barring some corruption of the file attributes, both are impossible, but in any case they should be caught and separated from other types of exceptions.

We use [Instant](https://docs.perl6.org/type/Instant)s in lines 16-17 to represent the moment in which the files where accessed and modified. An Instant is measured in atomic seconds, and is a very low-level description of a time event; however, the [Duration](https://docs.perl6.org/type/Duration) declared in line 18 represent the time transcurred among two different `Instant`s, and we will be using it to represent the age.

For some variables we might be interested in dealing with them with some *dateish* traits. `$time-of-day` contains the time of the day the file was changed; `changed` will return an Instant, but it is converted into a Date (which is `Dateish` while `Instant` is not) and then the time of day is extracted from that. `$time-of-day` will have `«Str+{Dateish}␤» `type.

We will use the date in this variable to find out the period when the files were changed.

```
Date.new("2018-01-01")..^Date.new("2018-04-01")
```

creates a date [Range](https://docs.perl6.org/type/Range) and `$file-changed-date` is smartmatched against it. Dates can be used this way; in this case it creates a `Range` that excludes its last element.

This very variable is also used to compute the month of the year when the file was modified. [Date](https://docs.perl6.org/type/Date) is obviously `Dateish` and then has the `month` method to extract that property from it.

`Duration` objects can be compared. This is used in

```
%metadata.sort({
    $^a.value<age> <=> $^b.value<age>
});
```

to sort the files by age.