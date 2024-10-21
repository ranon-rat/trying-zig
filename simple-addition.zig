// its actually quite cool that i ca  import functions like this, tho i think that it could become quite big
const std = @import("std");

const os = std.os;

const print = @import("std").debug.print;
// this just aborts if nothing its okay so

const assert = @import("std").debug.assert;
pub fn main() void {
    const a: u8 = 1 + 1;
    // first addition
    print("1 + 1 -> {}\n", .{a});
    const div_float: f32 = 7.0 / 3.0;
    // so it can print any value, including floats
    print("7 / 3 -> {}\n", .{div_float});
    // and booleans
    print("{}\n{}\n{}\n", .{ true and false, true or false, !true });
    //its quite interesting to have things like this, it seems quite simple, quite rust like//
    // so i can have optional values thats interesting
    var optional_value: ?[]const u8 = null;
    // first time that i hear of an optional value
    assert(optional_value == null);
    // its quite interesting that its using the typeOf capabilities
    print("----testing with optional values---\n", .{});
    print("----the value will be null      ---\n", .{});

    print("optional 1\ntype: {}\nvalue: {?s}\n", .{
        @TypeOf(optional_value), optional_value,
    });
    optional_value = "hi";
    assert(optional_value != null);
    print("---i have defined the value now---\n", .{});

    // tengo que especificar el tipo?
    print("\noptional 2\ntype: {}\nvalue: {?s}\n", .{
        @TypeOf(optional_value), optional_value,
    });

    // i can define simple unions
    var number_or_error: anyerror!i32 = error.ArgNotFound;
    print("---these are unions---\n", .{});
    print("---in this case i will be testing with a simple argNotFound---\n", .{});

    //it seems that unions are quite simple, this will come handly when trying to test some stuff, so thats actually great
    print("\nerror union 1\ntype: {}\nvalue: {!}\n", .{
        @TypeOf(number_or_error),
        number_or_error,
    });

    number_or_error = 1234;
    //i change the value of number_or_error
    print("---changing the value---", .{});

    print("\nerror union 2\ntype: {}\nvalue: {!}\n", .{
        @TypeOf(number_or_error), number_or_error,
    });

    // okay me agrada puedo trabajar con esto
}
