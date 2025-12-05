const std = @import("std");

const input = @embedFile("input.txt");

const Range = struct {
    min: i64,
    max: i64,
};

pub fn main() !void {
    var gpa = std.heap.DebugAllocator(.{}).init;
    const allocator = gpa.allocator();

    var count: i64 = 0;
    var reader = std.Io.Reader.fixed(input);
    var ranges = std.ArrayList(Range).empty;
    while (try reader.takeDelimiter('\n')) |line| {
        if (line.len == 0) {
            break;
        }
        var it = std.mem.splitScalar(u8, line, '-');
        const min = try std.fmt.parseInt(i64, it.next().?, 10);
        const max = try std.fmt.parseInt(i64, it.next().?, 10);
        try ranges.append(allocator, .{ .min = min, .max = max });
    }
    while (try reader.takeDelimiter('\n')) |line| {
        const id = try std.fmt.parseInt(i64, line, 10);
        var fresh = false;
        for (ranges.items) |range| {
            if (range.min <= id and id <= range.max) {
                fresh = true;
                break;
            }
        }
        if (fresh) {
            count += 1;
        }
    }
    std.debug.print("{d}\n", .{count});
}
