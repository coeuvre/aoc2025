const std = @import("std");

const input = @embedFile("input.txt");

fn isDigit(c: u8) bool {
    return c >= '0' and c <= '9';
}

pub fn main() !void {
    var gpa = std.heap.DebugAllocator(.{}).init;
    const allocator = gpa.allocator();

    var reader = std.Io.Reader.fixed(input);
    var rows = std.ArrayList([]i64).empty;
    var ops: []u8 = undefined;
    problem_loop: while (try reader.takeDelimiter('\n')) |line| {
        var line_reader = std.Io.Reader.fixed(line);
        var nums = std.ArrayList(i64).empty;
        while (try line_reader.takeDelimiter(' ')) |num| {
            if (num.len == 0) {
                continue;
            }
            if (!isDigit(num[0])) {
                ops = line;
                break :problem_loop;
            }
            try nums.append(allocator, try std.fmt.parseInt(i64, num, 10));
        }
        try rows.append(allocator, try nums.toOwnedSlice(allocator));
    }

    var grand_total: i64 = 0;
    var col: usize = 0;
    var ops_reader = std.Io.Reader.fixed(ops);
    while (try ops_reader.takeDelimiter(' ')) |op| {
        if (op.len == 0) {
            continue;
        }
        var result: i64 = rows.items[0][col];
        for (rows.items[1..]) |nums| {
            switch (op[0]) {
                '+' => {
                    result += nums[col];
                },
                '*' => {
                    result *= nums[col];
                },
                else => unreachable,
            }
        }
        col += 1;
        grand_total += result;
    }
    std.debug.print("{d}\n", .{grand_total});
}
