// i am just following this tutorial
// the documentation from zig its quite op, i like reading it, i have learned a lot while reading it
// but i will be following this video just to learn some other stuff
//https://www.youtube.com/watch?v=E-MPhgtC_2s
// much thanks to CallousCoder

const std = @import("std");
pub fn main() !void {
    var biglist = std.ArrayList(u8).init(std.heap.page_allocator);
    defer biglist.deinit();

    var index: u32 = 0;
    while (index < 1000001) : (index += 1) {
        if (index % 10 == 7 or index % 7 == 0) {
            try biglist.writer().print("SMAC\n", .{});
            continue;
        }
        try biglist.writer().print("{}\n", .{index});
    }
    try print_list(&biglist);
    biglist.clearAndFree();
}

fn print_list(list: *std.ArrayList(u8)) !void {
    var iter = std.mem.split(u8, list.items, "\n");
    while (iter.next()) |item| {
        std.debug.print("{s}\n", .{item});
    }
}
