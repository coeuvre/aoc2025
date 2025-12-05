const std = @import("std");

const input = @embedFile("input.txt");

const Range = struct {
    begin: i64,
    end: i64,

    fn lessThan(_: void, lhs: Range, rhs: Range) bool {
        return lhs.begin < rhs.begin;
    }
};

fn solve(ranges: []Range) !void {
    var count: i64 = 0;
    std.sort.pdq(Range, ranges, {}, Range.lessThan);
    var i = ranges[0].begin;
    for (ranges) |range| {
        const begin = @max(range.begin, i);
        const end = @max(range.end, i);
        count += end - begin;
        i = end;
    }
    std.debug.print("{d}\n", .{count});
}

pub fn main() !void {
    var gpa = std.heap.DebugAllocator(.{}).init;
    const allocator = gpa.allocator();

    var reader = std.Io.Reader.fixed(input);
    var ranges = std.ArrayList(Range).empty;
    while (try reader.takeDelimiter('\n')) |line| {
        if (line.len == 0) {
            break;
        }
        var it = std.mem.splitScalar(u8, line, '-');
        const min = try std.fmt.parseInt(i64, it.next().?, 10);
        const max = try std.fmt.parseInt(i64, it.next().?, 10);
        try ranges.append(allocator, .{ .begin = min, .end = max + 1 });
    }

    try solve(ranges.items);
}
