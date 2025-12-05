const std = @import("std");

const input = @embedFile("input.txt");

const Grid = struct {
    cells: []u8,
    width: usize,
    height: usize,

    fn get(self: *const Grid, x: usize, y: usize) u8 {
        std.debug.assert(x < self.width and y < self.height);
        return self.cells[y * self.width + x];
    }

    fn set(self: *Grid, x: usize, y: usize, val: u8) void {
        std.debug.assert(x < self.width and y < self.height);
        self.cells[y * self.width + x] = val;
    }
};

fn countAdjacentRolls(grid: *const Grid, x: usize, y: usize) usize {
    var count: usize = 0;
    const min_x = if (x > 0) x - 1 else x;
    const min_y = if (y > 0) y - 1 else y;
    const max_x = if (x + 1 < grid.width) x + 1 else x;
    const max_y = if (y + 1 < grid.height) y + 1 else y;
    for (min_y..max_y + 1) |yy| {
        for (min_x..max_x + 1) |xx| {
            if ((xx != x or yy != y) and grid.get(xx, yy) != '.') {
                count += 1;
            }
        }
    }
    return count;
}

fn solve(grid: *Grid) !void {
    var count: usize = 0;
    for (0..grid.height) |y| {
        for (0..grid.width) |x| {
            if (grid.get(x, y) != '.') {
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
