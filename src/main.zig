const std = @import("std");
const zimeg = @import("zimeg");
const Time = zimeg.Time;
const Ticker = zimeg.Ticker;

pub fn main() !void {
    var ticker = Ticker.start(Time.fromMillisecs(1000));
    std.debug.print("{any}\n", .{ticker.tick()}); // true
    std.debug.print("{any}\n", .{ticker.tick()}); // false
    ticker.reset();
    std.debug.print("{any}\n", .{ticker.tick()}); // true
    std.debug.print("{any}\n", .{ticker.tick()}); // false

    // Do like this
    while (true) {
        ticker.waitNextTick();
        std.debug.print("This prints every second. Seconds: {d}\n", .{ticker.timestamp.toSeconds()});
    }
}
