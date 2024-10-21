const std = @import("std");
const expect = std.testing.expect;
const builtin = @import("builtin");

test "expect addOne adds one to 41" {
    try expect(addOne(41) == 42);
}

test addOne {
    try expect(addOne(41) == 42);
}

/// The function `addOne` adds one to the number given as its argument.
fn addOne(number: i32) i32 {
    return number + 1;
}
//execute with
//  zig test testing.zig

test "expect this to fail" {
    try expect(false);
}

test "expect this to succeed" {
    try expect(true);
}

test "this will be skipped" {
    return error.SkipZigTest;
}

test "detect leak" {
    var list = std.ArrayList(u21).init(std.testing.allocator);
    // missing `defer list.deinit();`
    try list.append('☔');

    try expect(list.items.len == 1);
}

test "builtin.is_test" {
    try expect(isATest());
    // okay so try its just for checking that it applies, this will only check that its a builtin function
    // actually it helps me to use this so thats good for me
}

fn isATest() bool {
    return builtin.is_test;
}
