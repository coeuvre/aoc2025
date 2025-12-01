const std = @import("std");

const input = @embedFile("input.txt");

pub fn main() !void {
    var reader = std.Io.Reader.fixed(input);
    const len: i64 = 100;
    var pos: i64 = 50;
    var password: i64 = 0;
    while (try reader.takeDelimiter('\n')) |line| {
        const dir: i64 = if (line[0] == 'L') -1 else 1;
        const dist = try std.fmt.parseInt(i64, line[1..], 10);
        const pos_before = pos;
        pos += dir * @rem(dist, len);
        pos = @rem(pos + len, len);

        password += @divTrunc(dist, len);
        if (pos_before != 0) {
            if (pos == 0) {
                password += 1;
            } else if (dir > 0) {
                if (pos < pos_before) {
                    password += 1;
                }
            } else {
                if (pos > pos_before) {
                    password += 1;
                }
            }
        }
        //std.debug.print("{s}: {d} -> {d}, {d}\n", .{ line, pos_before, pos, password });
    }
    std.debug.print("{d}\n", .{password});
}
