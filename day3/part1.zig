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
        const v0, const i = max(line[0 .. line.len - 1]);
        const v1 = max(line[i + 1 ..]).@"0";
        sum += (v0 - '0') * 10 + (v1 - '0');
    }
    std.debug.print("{d}\n", .{sum});
}
