const std = @import("std");
const zimeg = @import("zimeg");
const Time = zimeg.Time;
const Ticker = zimeg.Ticker;

pub fn main() !void {
    var ticker = Ticker.start(Time.from_ms(100));
    std.debug.print("{any}\n", .{ticker.tick()}); // true
    std.debug.print("{any}\n", .{ticker.tick()}); // false
    ticker.reset();
    std.debug.print("{any}\n", .{ticker.tick()}); // true
    std.debug.print("{any}\n", .{ticker.tick()}); // false
    // ticker.step = Time.MILLISECOND;

    // But don't do tickers like this
    // while (true) {
    //     if (ticker.tick()) {
    //         std.debug.print("This prints every second\n", .{});
    //     }
    // }

    var checks: usize = 0;

    // Do like this
    while (true) {
        checks += 1;
        while (ticker.tick()) {
            std.debug.print("This prints every second. Checks: {any}\n", .{checks});
            checks = 0;
        }
        var left = ticker.time_left();
        left.div(2).add(left.div(4)).add(left.div(8)).add(left.div(16)).add(left.div(32)).sleep();
    }
}
