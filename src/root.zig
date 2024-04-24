const std = @import("std");

const nanos_in_nanos = 1;
const nanos_in_micros = nanos_in_nanos * 1000;
const nanos_in_millis = nanos_in_micros * 1000;
const nanos_in_second = nanos_in_millis * 1000;
const nanos_in_minute = nanos_in_second * 60;
const nanos_in_hour = nanos_in_minute * 60;
const nanos_in_day = nanos_in_hour * 24;
const nanos_in_week = nanos_in_day * 7;

const nanos_in_milliminute = nanos_in_minute / 1000;
const nanos_in_millihour = nanos_in_hour / 1000;
const nanos_in_milliday = nanos_in_day / 1000;
const nanos_in_milliweek = nanos_in_week / 1000;

/// Time represents a duration of time in nanoseconds.
pub const Time = struct {
    nanos: u64,

    /// Returns the current time as a `Time` value.
    pub fn now() Time {
        const zero = std.time.Instant{
            .timestamp = if (switch (@import("builtin").os.tag) {
                .windows, .uefi, .wasi => false,
                else => true,
            }) std.os.timespec{ .tv_nsec = 0, .tv_sec = 0 } else 0,
        };
        var time = std.time.Instant.now() catch std.debug.panic("Unable to access system clock", .{});
        return Time{ .nanos = time.since(zero) };
    }

    /// Creates a `Time` value from the given number of nanoseconds.
    pub inline fn fromNanosecs(count: u64) Time {
        return Time{ .nanos = count * nanos_in_nanos };
    }

    /// Creates a `Time` value from the given number of microseconds.
    pub inline fn fromMicrosecs(count: u64) Time {
        return Time{ .nanos = count * nanos_in_micros };
    }

    /// Creates a `Time` value from the given number of milliseconds.
    pub inline fn fromMillisecs(count: u64) Time {
        return Time{ .nanos = count * nanos_in_millis };
    }

    /// Creates a `Time` value from the given number of seconds.
    pub inline fn fromSeconds(count: u64) Time {
        return Time{ .nanos = count * nanos_in_second };
    }

    /// Creates a `Time` value from the given number of minutes.
    pub inline fn fromMinutes(count: u64) Time {
        return Time{ .nanos = count * nanos_in_minute };
    }

    /// Creates a `Time` value from the given number of hours.
    pub inline fn fromHours(count: u64) Time {
        return Time{ .nanos = count * nanos_in_hour };
    }

    /// Creates a `Time` value from the given number of days.
    pub inline fn fromDays(count: u64) Time {
        return Time{ .nanos = count * nanos_in_day };
    }

    /// Creates a `Time` value from the given number of weeks.
    pub inline fn fromWeeks(count: u64) Time {
        return Time{ .nanos = count * nanos_in_week };
    }

    pub inline fn fromMilliminutes(count: u64) Time {
        return Time{ .nanos = count * nanos_in_milliminute };
    }

    pub inline fn fromMillihours(count: u64) Time {
        return Time{ .nanos = count * nanos_in_millihour };
    }

    pub inline fn fromMillidays(count: u64) Time {
        return Time{ .nanos = count * nanos_in_milliday };
    }

    pub inline fn fromMilliweeks(count: u64) Time {
        return Time{ .nanos = count * nanos_in_milliweek };
    }

    /// Predefined `Time` values for convenience.
    pub const nanosecond = Time.fromNanosecs(1);
    pub const microsecond = Time.fromMicrosecs(1);
    pub const millisecond = Time.fromMillisecs(1);
    pub const second = Time.fromSeconds(1);
    pub const minute = Time.fromMinutes(1);
    pub const hour = Time.fromHours(1);
    pub const day = Time.fromDays(1);
    pub const week = Time.fromWeeks(1);

    /// Returns the nanosecond part of the `Time` value.
    pub inline fn nanoseconds(self: Time) u64 {
        return self.nanos % 1000;
    }

    /// Returns the microsecond part of the `Time` value.
    pub inline fn microseconds(self: Time) u64 {
        return (self.nanos / nanos_in_micros) % 1000;
    }

    /// Returns the millisecond part of the `Time` value.
    pub inline fn milliseconds(self: Time) u64 {
        return (self.nanos / nanos_in_millis) % 1000;
    }

    /// Returns the second part of the `Time` value.
    pub inline fn seconds(self: Time) u64 {
        return (self.nanos / nanos_in_second) % 60;
    }

    /// Returns the minute part of the `Time` value.
    pub inline fn minutes(self: Time) u64 {
        return (self.nanos / nanos_in_minute) % 60;
    }

    /// Returns the hour part of the `Time` value.
    pub inline fn hours(self: Time) u64 {
        return (self.nanos / nanos_in_hour) % 24;
    }

    /// Returns the day part of the `Time` value.
    pub inline fn days(self: Time) u64 {
        return (self.nanos / nanos_in_day) % 7;
    }

    /// Returns the week part of the `Time` value.
    pub inline fn weeks(self: Time) u64 {
        return self.nanos / nanos_in_week;
    }

    pub inline fn milliminutes(self: Time) u64 {
        return (self.nanos / nanos_in_milliminute) % 1000;
    }

    pub inline fn millihours(self: Time) u64 {
        return (self.nanos / nanos_in_millihour) % 1000;
    }

    pub inline fn millidays(self: Time) u64 {
        return (self.nanos / nanos_in_milliday) % 1000;
    }

    pub inline fn milliweeks(self: Time) u64 {
        return (self.nanos / nanos_in_milliweek) % 1000;
    }

    /// Converts the `Time` value to nanoseconds.
    pub inline fn toNanoseconds(self: Time) u64 {
        return self.nanos % 1000;
    }

    /// Converts the `Time` value to microseconds.
    pub inline fn toMicroseconds(self: Time) u64 {
        return self.nanos / nanos_in_micros;
    }

    /// Converts the `Time` value to milliseconds.
    pub inline fn toMilliseconds(self: Time) u64 {
        return self.nanos / nanos_in_millis;
    }

    /// Converts the `Time` value to seconds.
    pub inline fn toSeconds(self: Time) u64 {
        return self.nanos / nanos_in_second;
    }

    /// Converts the `Time` value to minutes.
    pub inline fn toMinutes(self: Time) u64 {
        return self.nanos / nanos_in_minute;
    }

    /// Converts the `Time` value to hours.
    pub inline fn toHours(self: Time) u64 {
        return self.nanos / nanos_in_hour;
    }

    /// Converts the `Time` value to days.
    pub inline fn toDays(self: Time) u64 {
        return self.nanos / nanos_in_day;
    }

    /// Converts the `Time` value to weeks.
    pub inline fn toWeeks(self: Time) u64 {
        return self.nanos / nanos_in_week;
    }

    pub inline fn toMilliminutes(self: Time) u64 {
        return self.nanos / nanos_in_milliminute;
    }

    pub inline fn toMillihours(self: Time) u64 {
        return self.nanos / nanos_in_millihour;
    }

    pub inline fn toMillidays(self: Time) u64 {
        return self.nanos / nanos_in_milliday;
    }

    pub inline fn toMilliweeks(self: Time) u64 {
        return self.nanos / nanos_in_milliweek;
    }

    pub fn print(self: Time, writer: anytype) !void {
        const info = switch (self.nanos) {
            0...nanos_in_micros - 1 => .{ @as(u64, 0), self.toNanoseconds(), "ns" },
            nanos_in_micros...nanos_in_millis - 1 => .{ self.nanoseconds(), self.toMicroseconds(), "μs" },
            nanos_in_millis...nanos_in_second - 1 => .{ self.microseconds(), self.toMilliseconds(), "ms" },
            nanos_in_second...nanos_in_minute - 1 => .{ self.milliseconds(), self.toSeconds(), "s" },
            nanos_in_minute...nanos_in_hour - 1 => .{ self.milliminutes(), self.toMinutes(), "minutes" },
            nanos_in_hour...nanos_in_day - 1 => .{ self.millihours(), self.toHours(), "hours" },
            nanos_in_day...nanos_in_week - 1 => .{ self.millidays(), self.toDays(), "days" },
            nanos_in_week...std.math.maxInt(u64) => .{ self.milliweeks(), self.toWeeks(), "weeks" },
        };
        var fraction = info[0];
        const integer = info[1];
        const suffix = info[2];
        var digits: [3]u8 = "000".*;
        var i: usize = 3;
        while (fraction > 0) {
            digits[i - 1] = '0' + @as(u8, @intCast(fraction % 10));
            fraction /= 10;
            i -= 1;
        }
        _ = try writer.print("{d}.{s} {s}", .{ integer, digits[@min(i, 2)..3], suffix });
    }

    /// Multiplies the `Time` value by the given factor.
    pub inline fn mul(self: Time, by: u64) Time {
        return Time{ .nanos = self.nanos * by };
    }
    pub const times = mul;

    /// Divides the `Time` value by the given divisor.
    pub inline fn div(self: Time, by: u64) Time {
        return Time{ .nanos = self.nanos / by };
    }

    /// Adds two `Time` values together.
    pub inline fn add(self: Time, other: Time) Time {
        return Time{ .nanos = self.nanos + other.nanos };
    }

    /// Subtracts one `Time` value from another.
    pub inline fn sub(self: Time, other: Time) Time {
        return Time{ .nanos = self.nanos - other.nanos };
    }

    /// Alias for `sub` function, calculates the duration between two `Time` values.
    pub const since = sub;

    /// Multiplies the `Time` value by the given factor in-place.
    pub inline fn mulAssign(self: *Time, by: u64) void {
        self.nanos *= by;
    }

    /// Adds another `Time` value to this `Time` value in-place.
    pub inline fn addAssign(self: *Time, other: Time) void {
        self.nanos += other.nanos;
    }

    /// Subtracts another `Time` value from this `Time` value in-place.
    pub inline fn subAssign(self: *Time, other: Time) void {
        self.nanos -= other.nanos;
    }

    /// Compares this `Time` value with another `Time` value.
    pub inline fn order(self: Time, other: Time) std.math.Order {
        return std.math.order(self.nanos, other.nanos);
    }

    /// Returns true if this `Time` value is greater than the given `Time` value.
    pub inline fn gt(self: Time, other: Time) bool {
        return self.nanos > other.nanos;
    }

    /// Returns true if this `Time` value is less than the given `Time` value.
    pub inline fn lt(self: Time, other: Time) bool {
        return self.nanos < other.nanos;
    }

    /// Returns true if this `Time` value is greater than or equal to the given `Time` value.
    pub inline fn ge(self: Time, other: Time) bool {
        return self.nanos >= other.nanos;
    }

    /// Returns true if this `Time` value is less than or equal to the given `Time` value.
    pub inline fn le(self: Time, other: Time) bool {
        return self.nanos <= other.nanos;
    }

    /// Sleeps for the duration specified by this `Time` value.
    pub inline fn sleep(self: Time) void {
        std.time.sleep(self.nanos);
    }
};

/// Timer is a utility struct for managing a single countdown timer.
pub const Timer = struct {
    end: Time,

    const Self = @This();

    /// Creates a new timer that has already expired (immediate timer).
    ///
    /// This method creates a `Timer` instance whose expiration time is set to the current time,
    /// effectively making it an expired timer from the moment it is created.
    ///
    /// Returns: A new `Timer` instance that has already expired.
    ///
    /// Example:
    ///
    /// ```zig
    /// const immediate_timer = Timer.immadiate();
    /// std.debug.print("{any}\n", .{immediate_timer.ended()}); // Output: true
    /// ```
    pub fn immadiate() Timer {
        return Self{ .end = Time.now() };
    }

    /// Creates a new timer that will expire after the given duration.
    pub fn start(for_time: Time) Timer {
        return Self{ .end = Time.now().add(for_time) };
    }

    /// Adds time to the timer's expiration.
    pub fn addTime(self: *Self, time: Time) void {
        self.end.nanos += time.nanos;
    }

    /// Subtracts time from the timer's expiration.
    pub fn subTime(self: *Self, time: Time) void {
        self.end.nanos -= time.nanos;
    }

    /// Returns true if the timer has expired.
    pub fn ended(self: *Self) bool {
        return Time.now().ge(self.end);
    }

    /// Restarts the timer with a new duration.
    pub fn restart(self: *Self, for_time: Time) void {
        self.end = Time.now().add(for_time);
    }

    pub inline fn reset(self: *Self) void {
        self.* = Timer.immadiate();
    }

    /// Returns the time left until the end of the timer, or `null` if the timer has already ended.
    pub inline fn timeLeft(self: *Self) ?Time {
        const now = Time.now();
        return if (self.end.ge(now))
            self.end.sub(now)
        else
            null;
    }

    pub fn waitTilEnded(self: *Self) void {
        while (self.timeLeft()) |left| { // Repeat until the timer has ended
            left.div(2).add(left.div(4)).sleep(); // Sleep 75% of the time left
        }
    }
};

/// Ticker is a utility struct for creating periodic events.
pub const Ticker = struct {
    timer: Timer,
    step: Time,

    const Self = @This();

    /// Creates a new ticker with `step` which is the time between ticks.
    ///
    /// Example:
    /// ```zig
    /// var ticker = Ticker.start(Time.fromMillisecs(100));
    /// while (true) {
    ///     ticker.waitNextTick();
    ///     std.debug.print("This prints every 100 milliseconds!\n", .{});
    /// }
    /// ```
    pub fn start(step: Time) Ticker {
        return Self{
            .timer = Timer.immadiate(), // Start with an immediate timer
            .step = step,
        };
    }

    /// Returns true if a tick has occurred.
    pub fn tick(self: *Self) bool {
        if (self.timer.ended()) {
            self.timer.addTime(self.step); // Add the step duration to the timer
            return true;
        }
        return false;
    }

    /// Resets the ticker to the current time.
    ///
    /// It works the same as `Ticker.start` and also gives one tick right after the invocation.
    ///
    /// Example:
    /// ```zig
    /// var ticker = Ticker.start(Time.second);
    /// ticker.reset();
    /// std.debug.print("{any}\n", .{ticker.tick()}); // true
    /// std.debug.print("{any}\n", .{ticker.tick()}); // false
    /// // After one second...
    /// std.debug.print("{any}\n", .{ticker.tick()}); // true
    /// ```
    pub fn reset(self: *Self) void {
        self.timer.reset(); // Reset to an immediate timer
    }

    /// Advances the ticker to the next tick timestamp.
    pub fn nextTick(self: *Self) void {
        self.timer.addTime(self.step);
    }

    /// Waits for the next tick to occur by sleeping until the tick timestamp.
    ///
    /// This method uses a loop to repeatedly check if the next tick has occurred.
    /// If the next tick has not occurred yet, it sleeps for 75% of the remaining time
    /// until the tick timestamp. This approach helps to avoid overshooting the tick
    /// timestamp due to scheduling delays or other factors.
    ///
    /// After the loop exits (because the next tick has occurred), the method advances
    /// the ticker to the next tick timestamp by calling `nextTick()`.
    ///
    /// Example:
    /// ```zig
    /// var ticker = Ticker.start(Time.fromSeconds(1));
    /// while (true) {
    ///     ticker.waitNextTick();
    ///     std.debug.print("Tick!\n", .{});
    /// }
    /// ```
    pub inline fn waitNextTick(self: *Self) void {
        self.timer.waitTilEnded();
        self.nextTick(); // Switch to next tick
    }
};

const testing = std.testing;

test "Time.now" {
    const now = Time.now();
    try testing.expect(now.nanos > 0);
}

test "Time.fromXXX" {
    try testing.expectEqual(Time.fromNanosecs(1).nanos, nanos_in_nanos);
    try testing.expectEqual(Time.fromMicrosecs(1).nanos, nanos_in_micros);
    try testing.expectEqual(Time.fromMillisecs(1).nanos, nanos_in_millis);
    try testing.expectEqual(Time.fromSeconds(1).nanos, nanos_in_second);
    try testing.expectEqual(Time.fromMinutes(1).nanos, nanos_in_minute);
    try testing.expectEqual(Time.fromHours(1).nanos, nanos_in_hour);
    try testing.expectEqual(Time.fromDays(1).nanos, nanos_in_day);
    try testing.expectEqual(Time.fromWeeks(1).nanos, nanos_in_week);
}

test "Time.toXXX" {
    const time = Time.fromNanosecs(123456789);
    try testing.expectEqual(time.nanoseconds(), 789);
    try testing.expectEqual(time.microseconds(), 456);
    try testing.expectEqual(time.milliseconds(), 123);
    try testing.expectEqual(time.seconds(), 0);
    try testing.expectEqual(time.minutes(), 0);
    try testing.expectEqual(time.hours(), 0);
    try testing.expectEqual(time.days(), 0);
    try testing.expectEqual(time.weeks(), 0);
    try testing.expectEqual(time.toNanoseconds(), 789);
    try testing.expectEqual(time.toMicroseconds(), 123456);
    try testing.expectEqual(time.toMilliseconds(), 123);
    try testing.expectEqual(time.toSeconds(), 0);
    try testing.expectEqual(time.toMinutes(), 0);
    try testing.expectEqual(time.toHours(), 0);
    try testing.expectEqual(time.toDays(), 0);
    try testing.expectEqual(time.toWeeks(), 0);
}

test "Time.mul/div" {
    const time = Time.fromSeconds(10);
    try testing.expectEqual(time.mul(2).nanos, nanos_in_second * 20);
    try testing.expectEqual(time.div(2).nanos, nanos_in_second * 5);
}

test "Time.add/sub" {
    const time1 = Time.fromSeconds(10);
    const time2 = Time.fromMinutes(2);
    try testing.expectEqual(time1.add(time2).nanos, nanos_in_second * 10 + nanos_in_minute * 2);
    try testing.expectEqual(time2.sub(time1).nanos, nanos_in_minute * 2 - nanos_in_second * 10);
    try testing.expectEqual(time2.since(time1).nanos, nanos_in_minute * 2 - nanos_in_second * 10);
}

test "Time.order" {
    const time1 = Time.fromSeconds(10);
    const time2 = Time.fromMinutes(2);
    try testing.expect(time1.order(time2) == .lt);
    try testing.expect(time2.order(time1) == .gt);
    try testing.expect(time1.order(time1) == .eq);
}

test "Time.gt/lt/ge/le" {
    const time1 = Time.fromSeconds(10);
    const time2 = Time.fromMinutes(2);
    try testing.expect(time1.lt(time2));
    try testing.expect(time2.gt(time1));
    try testing.expect(time1.le(time2));
    try testing.expect(time2.ge(time1));
}

test "Ticker" {
    var ticker = Ticker.start(Time.fromMillisecs(100));
    try testing.expect(ticker.tick());
    try testing.expect(!ticker.tick());
    ticker.reset();
    try testing.expect(ticker.tick());
    try testing.expect(!ticker.tick());
}

test "Timer" {
    var timer = Timer.start(Time.fromSeconds(1));
    try testing.expect(!timer.ended());
    Time.fromMillisecs(1100).sleep();
    try testing.expect(timer.ended());
    timer.restart(Time.fromSeconds(2));
    try testing.expect(!timer.ended());
    timer.addTime(Time.fromSeconds(1));
    Time.fromSeconds(2).sleep();
    try testing.expect(!timer.ended());
    Time.fromSeconds(1).sleep();
    try testing.expect(timer.ended());
}
