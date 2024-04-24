# Zimeg

Zimeg is a powerful time library for the Zig programming language that provides a convenient way to work with time durations and intervals. It offers a comprehensive set of features for managing time-related tasks, including timers, tickers.

## Features

- **Time Struct**: Represents a duration of time in nanoseconds, with support for various time units such as seconds, minutes, hours, days, and weeks.
- **Time Manipulation**: Perform various operations on time values, including addition, subtraction, multiplication, division, and comparison.
- **Current Time**: Retrieve the current clock time with `Time.now()`.
- **Ticker**: Create periodic events with a specified time interval using the `Ticker` struct.
- **Timer**: Manage countdown timers with the `Timer` struct, allowing you to start, restart, and check if a timer has expired.

## Installation Steps:

### Adding the Library URL:

Use `zig fetch` command to save the library's URL and its hash to a `build.zig.zon` file.

```sh
zig fetch --save https://github.com/engusmaze/zimeg/archive/d6ad7e346c8c867068fd01fcb3dea4631608f983.tar.gz
```

### Adding the Dependency:

After saving the library's URL, you need to make it importable by your code in the `build.zig` file. This involves specifying the dependency and adding it to an executable or library.

```zig
pub fn build(b: *std.Build) void {
    // ...
    const zimeg = b.dependency("zimeg", .{
        .target = target,
        .optimize = optimize,
    });
    exe.root_module.addImport("zimeg", zimeg.module("zimeg"));
}
```

### Importing the Library:

Once the dependency is specified in the `build.zig` file, you can import the library into your Zig code using the `@import` directive.

```zig
const zimeg = @import("zimeg");

const Time = zimeg.Time;
const Timer = zimeg.Timer;
const Ticker = zimeg.Ticker;
```

## Examples

### Time Manipulation

```zig
const one_second = zimeg.Time.fromSeconds(1);
const two_minutes = zimeg.Time.fromMinutes(2);
const duration = one_second.add(two_minutes);
std.debug.print("Duration: {} seconds\n", .{duration.toSeconds()});
```

### Ticker

```zig
var ticker = zimeg.Ticker.start(zimeg.Time.fromMillisecs(100));
while (true) {
    ticker.waitNextTick();
    std.debug.print("This prints every 100 milliseconds!\n", .{});
}
```

### Timer

```zig
var timer = zimeg.Timer.start(zimeg.Time.fromSeconds(10));
timer.waitNextTick();
std.debug.print("Timer expired!\n", .{});
```

## Contributing

Contributions to zimeg are welcome! If you find any issues or have suggestions for improvements, please open an issue or submit a pull request on the project's repository.
