// i am just following this tutorial
// the documentation from zig its quite op, i like reading it, i have learned a lot while reading it
// but i will be following this video just to learn some other stuff
//https://www.youtube.com/watch?v=E-MPhgtC_2s
// much thanks to CallousCoder

const std = @import("std");
pub fn main() !void {
    const x: i32 = 4;
    var t: [x]std.Thread = undefined;

    var list: [x]std.ArrayList(u8) = undefined;

    var i: u32 = 0;
    while (i < x) : (i += 1) {
        list[i] = std.ArrayList(u8).init(std.heap.page_allocator);
        defer list[i].deinit();
        t[i] = try std.Thread.spawn(.{}, count_it, .{ i, &list[i] });
    }
    i = 0;
    while (i < x) : (i += 1) {
        t[i].join();
        try print_list(&list[i]);
        list[i].clearAndFree();
    }
}
fn count_it(id: u32, list: *std.ArrayList(u8)) !void {
    var addr: usize = 0;
    if (id == 3) addr += 1;
    var index: usize = id * 250_000;
    while (index < (id * 250_000 + 250_000 + addr)) : (index += 1) {
        if (index == 0) continue;
        if (index % 10 == 7 or index % 7 == 0) {
            try list.writer().print("SMAC {}\n", .{id});
            continue;
        }
        try list.writer().print("{}\n", .{index});
    }
}
fn print_list(list: *std.ArrayList(u8)) !void {
    var iter = std.mem.split(u8, list.items, "\n");
    while (iter.next()) |item| {
        std.debug.print("{s}\n", .{item});
    }
}
