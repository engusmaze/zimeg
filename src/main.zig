const std = @import("std");
const zimeg = @import("zimeg");
const Time = zimeg.Time;
const Ticker = zimeg.Ticker;

pub fn main() !void {
    const duration = Time.second.add(Time.millisecond.mul(123));
    var stdout = std.io.getStdOut().writer();
    _ = try stdout.write("One second: ");
    try duration.print(stdout);
    _ = try stdout.write("\n");

    var ticker = Ticker.start(Time.fromMillisecs(1000));
    std.debug.print("{any}\n", .{ticker.tick()}); // true
    std.debug.print("{any}\n", .{ticker.tick()}); // false
    ticker.reset();
    std.debug.print("{any}\n", .{ticker.tick()}); // true
    std.debug.print("{any}\n", .{ticker.tick()}); // false

    // Do like this
    while (true) {
        ticker.waitNextTick();
        std.debug.print("This prints every second. Seconds: {d}\n", .{ticker.timer.end.toSeconds()});
    }
}
