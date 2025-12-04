const std = @import("std");

const input = @embedFile("input.txt");

const Grid = struct {
    cells: []u8,
    width: usize,
    height: usize,

    fn get(self: *const Grid, x: usize, y: usize) ?u8 {
        if (y < self.height and x < self.width) {
            return self.cells[y * self.width + x];
        }
        return null;
    }

    fn set(self: *Grid, x: usize, y: usize, val: u8) void {
        self.cells[y * self.width + x] = val;
    }
};

fn countAdjacentRolls(grid: *const Grid, x: usize, y: usize) usize {
    var count: usize = 0;
    var yy = if (y > 0) y - 1 else y;
    while (yy <= y + 1) : (yy += 1) {
        var xx = if (x > 0) x - 1 else x;
        while (xx <= x + 1) : (xx += 1) {
            if (xx != x or yy != y) {
                if (grid.get(xx, yy)) |cell| {
                    if (cell != '.') {
                        count += 1;
                    }
                }
            }
        }
    }
    return count;
}

fn solve(grid: *Grid) !void {
    var count: usize = 0;
    for (0..grid.height) |y| {
        for (0..grid.width) |x| {
            if (grid.get(x, y).? != '.') {
                const adj = countAdjacentRolls(grid, x, y);
                if (adj < 4) {
                    grid.set(x, y, 'x');
                    count += 1;
                }
            }
        }
    }
    printGrid(grid);
    std.debug.print("{d}\n", .{count});
}

fn printGrid(grid: *const Grid) void {
    for (0..grid.height) |y| {
        const row = grid.cells[y * grid.width .. (y + 1) * grid.width];
        std.debug.print("{s}\n", .{row});
    }
}

pub fn main() !void {
    var gpa = std.heap.DebugAllocator(.{}).init;
    const allocator = gpa.allocator();

    var reader = std.Io.Reader.fixed(input);
    const first_row = (try reader.takeDelimiter('\n')).?;
    const width = first_row.len;
    var height: usize = 1;
    var cells = std.ArrayList(u8).empty;
    try cells.appendSlice(allocator, first_row);
    while (try reader.takeDelimiter('\n')) |row| {
        std.debug.assert(row.len == width);
        try cells.appendSlice(allocator, row);
        height += 1;
    }
    var g = Grid{ .cells = cells.items, .width = width, .height = height };
    try solve(&g);
}
