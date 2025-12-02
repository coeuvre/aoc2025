const std = @import("std");

const input = @embedFile("input.txt");

fn isInvalid(id: []const u8) bool {
    var n: usize = 1;
    while (n <= id.len / 2) : (n += 1) {
        var i = n;
        while (i < id.len) : (i += n) {
            if (i + n > id.len or
                !std.mem.eql(u8, id[0..n], id[i .. i + n]))
            {
                break;
            }
        }
        if (i == id.len) {
            return true;
        }
    }
    return false;
}

pub fn main() !void {
    var reader = std.Io.Reader.fixed(input);
    var buf: [256]u8 = undefined;
    var answer: i64 = 0;
    while (try reader.takeDelimiter(',')) |range| {
        var it = std.mem.splitAny(u8, range, "-\n");
        const first_id = try std.fmt.parseInt(i64, it.next().?, 10);
        const last_id = try std.fmt.parseInt(i64, it.next().?, 10);
        var id = first_id;
        while (id <= last_id) : (id += 1) {
            const id_str = try std.fmt.bufPrint(&buf, "{d}", .{id});
            if (isInvalid(id_str)) {
                answer += id;
            }
        }
    }
    std.debug.print("{d}\n", .{answer});
}
