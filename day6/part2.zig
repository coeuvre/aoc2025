const std = @import("std");

const input = @embedFile("input.txt");

fn isDigit(c: u8) bool {
    return c >= '0' and c <= '9';
}

fn calc(rows: []const []const u8, op: u8, begin: usize, end: usize) i64 {
    var total: i64 = 0;
    const len = end - begin;
    for (0..len) |k| {
        const at = end - 1 - k;
        var number: i64 = 0;
        for (rows) |row| {
            if (at < row.len and isDigit(row[at])) {
                number = number * 10 + row[at] - '0';
            }
        }
        // std.debug.print("{d} ", .{number});
        if (k == 0) {
            total = number;
        } else {
            switch (op) {
                '*' => {
                    total *= number;
                },
                '+' => {
                    total += number;
                },
                else => unreachable,
            }
        }
    }
    // std.debug.print("{c}\n", .{op});
    return total;
}

pub fn main() !void {
    var gpa = std.heap.DebugAllocator(.{}).init;
    const allocator = gpa.allocator();

    var reader = std.Io.Reader.fixed(input);
    var rows = std.ArrayList([]const u8).empty;
    var max_len: usize = 0;
    var ops: []const u8 = undefined;
    while (try reader.takeDelimiter('\n')) |line| {
        if (line[0] == '*' or line[0] == '+') {
            ops = line;
            break;
        }
        try rows.append(allocator, line);
        max_len = @max(max_len, line.len);
    }

    var grand_total: i64 = 0;
    var begin: usize = 0;
    while (std.mem.indexOfNone(u8, ops[begin + 1 ..], " ")) |j| {
        const end = begin + j;
        grand_total += calc(rows.items, ops[begin], begin, end);
        begin = end + 1;
    }
    grand_total += calc(rows.items, ops[begin], begin, max_len);
    std.debug.print("{d}\n", .{grand_total});
}
