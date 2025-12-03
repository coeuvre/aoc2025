const std = @import("std");

const input = @embedFile("input.txt");

fn max(slice: []const u8) struct { u8, usize } {
    var index_for_max_value: usize = 0;
    var max_value: u8 = slice[index_for_max_value];
    for (slice[1..], 1..) |v, i| {
        if (v > max_value) {
            max_value = v;
            index_for_max_value = i;
        }
    }
    return .{ max_value, index_for_max_value };
}

pub fn main() !void {
    var reader = std.Io.Reader.fixed(input);
    var sum: i64 = 0;
    while (try reader.takeDelimiter('\n')) |line| {
        var v: i64 = 0;
        var i: usize = 0;
        var j = line.len - 11;
        while (j <= line.len) : (j += 1) {
            const m, const mi = max(line[i..j]);
            v = v * 10 + (m - '0');
            i += mi + 1;
        }
        sum += v;
    }
    std.debug.print("{d}\n", .{sum});
}
