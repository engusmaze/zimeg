const std = @import("std");

const nanos_in_nanos = 1;
const nanos_in_micros = nanos_in_nanos * 1000;
const nanos_in_millis = nanos_in_micros * 1000;
const nanos_in_second = nanos_in_millis * 1000;
const nanos_in_minute = nanos_in_second * 60;
const nanos_in_hour = nanos_in_minute * 60;
const nanos_in_day = nanos_in_hour * 24;
const nanos_in_week = nanos_in_week * 7;

pub const Time = struct {
    nanos: u64,

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

    pub fn from_ns(nanos: u64) Time {
        return Time{ .nanos = nanos * nanos_in_nanos };
    }
    pub fn from_us(micros: u64) Time {
        return Time{ .nanos = micros * nanos_in_millis };
    }
    pub fn from_ms(millis: u64) Time {
        return Time{ .nanos = millis * nanos_in_millis };
    }
    pub fn from_secs(secs: u64) Time {
        return Time{ .nanos = secs * nanos_in_second };
    }
    pub fn from_minutes(minutes: u64) Time {
        return Time{ .nanos = minutes * nanos_in_minute };
    }
    pub fn from_hours(hours: u64) Time {
        return Time{ .nanos = hours * nanos_in_hour };
    }
    pub fn from_days(days: u64) Time {
        return Time{ .nanos = days * nanos_in_day };
    }
    pub fn from_weeks(weeks: u64) Time {
        return Time{ .nanos = weeks * nanos_in_week };
    }

    pub const NANOSECOND = Time.from_ns(1);
    pub const MICROSECOND = Time.from_us(1);
    pub const MILLISECOND = Time.from_ms(1);
    pub const SECOND = Time.from_secs(1);
    pub const MINUTE = Time.from_minutes(1);
    pub const HOUR = Time.from_hours(1);
    pub const DAY = Time.from_days(1);
    pub const WEEK = Time.from_weeks(1);

    pub fn mul(self: Time, times: u64) Time {
        return Time{ .nanos = self.nanos * times };
    }
    pub fn div(self: Time, by: u64) Time {
        return Time{ .nanos = self.nanos / by };
    }
    pub fn add(self: Time, other: Time) Time {
        return Time{ .nanos = self.nanos + other.nanos };
    }
    pub fn sub(self: Time, other: Time) Time {
        return Time{ .nanos = self.nanos - other.nanos };
    }
    pub const since = sub;

    pub fn mul_assign(self: *Time, times: u64) void {
        self.nanos *= times;
    }
    pub fn add_assign(self: *Time, other: Time) void {
        self.nanos += other.nanos;
    }
    pub fn sub_assign(self: *Time, other: Time) void {
        self.nanos -= other.nanos;
    }

    pub fn order(self: Time, other: Time) std.math.Order {
        return std.math.order(self.nanos, other.nanos);
    }
    pub fn gt(self: Time, other: Time) bool {
        return self.nanos > other.nanos;
    }
    pub fn lt(self: Time, other: Time) bool {
        return self.nanos < other.nanos;
    }
    pub fn ge(self: Time, other: Time) bool {
        return self.nanos >= other.nanos;
    }
    pub fn le(self: Time, other: Time) bool {
        return self.nanos <= other.nanos;
    }

    pub fn sleep(self: Time) void {
        std.time.sleep(self.nanos);
    }
};

pub const Ticker = struct {
    timestamp: Time,
    step: Time,

    const Self = @This();
    /// Creates a new ticker with `step` which is a time between ticks
    ///
    /// ```zig
    /// var ticker = Ticker.start(Time.from_ms(100));
    /// while (true) {
    ///     if (ticker.tick()) {
    ///         std.debug.print("THIS prints every 100 milliseconds!\n", .{});
    ///     }
    /// }
    /// ```
    pub fn start(step: Time) Ticker {
        return Self{
            .timestamp = Time.now(),
            .step = step,
        };
    }
    /// Returns true if a tick has occured
    ///
    /// This is quaranteed to work right after the `Ticker.start`
    ///
    /// ```zig
    /// var ticker = Ticker.start(Time.SECOND);
    /// std.debug.print("{any}\n", .{ticker.tick()}); // true
    /// std.debug.print("{any}\n", .{ticker.tick()}); // false
    /// // After one second...
    /// std.debug.print("{any}\n", .{ticker.tick()}); // true
    /// ```
    pub fn tick(self: *Self) bool {
        const ticked = Time.now().ge(self.timestamp);
        if (ticked) {
            self.next_tick();
        }
        return ticked;
    }
    /// Resets ticker to current time
    ///
    /// It works as `Ticker.start` and also gives one tick right after the invocation
    ///
    /// ```zig
    /// ticker.reset();
    /// std.debug.print("{any}\n", .{ticker.tick()}); // true
    /// std.debug.print("{any}\n", .{ticker.tick()}); // false
    /// // After one second...
    /// std.debug.print("{any}\n", .{ticker.tick()}); // true
    /// ```
    pub fn reset(self: *Self) void {
        self.timestamp = Time.now();
    }
    pub fn next_tick(self: *Self) void {
        self.timestamp.add_assign(self.step);
    }
    pub fn time_left(self: *Self) Time {
        return self.timestamp.sub(Time.now());
    }
};

pub const Timer = struct {
    end: Time,

    const Self = @This();
    pub fn start(for_time: Time) Timer {
        return Self{ .end = Time.now().add(for_time) };
    }
    pub fn add_time(self: *Self, time: Time) void {
        self.end.nanos += time.nanos;
    }
    pub fn sub_time(self: *Self, time: Time) void {
        self.end.nanos -= time.nanos;
    }
    pub fn ended(self: *Self) bool {
        return Time.now().ge(self.end);
    }
    pub fn restart(self: *Self, for_time: Time) Timer {
        self.end = Time.now().add(for_time);
    }
};
