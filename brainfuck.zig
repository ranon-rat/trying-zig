// lets analyze how we can do something like this?
// series of rules
// + adds
// - this substracts
// [ this starts a loop, if cell its different to 0 then it executes
// ] this breaks a loop, if cell its equal to 0 then it breaks
// > this moves right
// < this moves left
// . this will print the current cell .
// , this will get the value from your input
// lets try to think on how we can do this uhh.....
const std = @import("std");
const print = std.debug.print;
const ArrayList = std.ArrayList;

const Token = enum {
    add,
    substract,
    start_loop,
    end_loop,
    right,
    left,
    print,
    input,
};
const InstructionType = enum {
    move,
    change,
    loop,
    end_loop,
    print,
    input,
};

const Instruction = struct {
    typeL: InstructionType,
    value: ?i32,
    instructions: ?ArrayList(Instruction), // I hope that once i deinit the array of instructions this also frees.
};
const StructureError = error{NotInLoop};

pub fn main() !void {
    const hello_world_example: []const u8 = "++++++++[>++++[>++>+++>+++>+<<<<-]>+>+>->>+[<]<-]>>.>---.+++++++..+++.>>.<-.<.+++.------.--------.>>+.>++.";

    // okay so we are printing this
    print("{s}\n", .{hello_world_example});
    var tokens = try tokenize(hello_world_example);
    defer tokens.deinit();
    // we have the tokens now, thats good enough right?
    // we have to make a structure of it, just for making it easier to execute :)
    var i: usize = 0;
    const instructions = try structurize(&i, &tokens, false);
    defer instructions.deinit();

    //try print_instructions(ArrayList(u8).init(std.heap.page_allocator), instructions);
    var cells = ArrayList(i32).init(std.heap.page_allocator);
    defer cells.deinit(); // so i just hope that it deinits the rest of arrays inside of this..
    try append_n_elements(&cells, 1);

    var position: usize = 0;
    try evaluate(&cells, &position, false, instructions);
}

fn evaluate(cells: *ArrayList(i32), position: *usize, loop: bool, instructions: ArrayList(Instruction)) !void {
    var index: usize = 0;
    while (index < instructions.items.len) {
        const ins = instructions.items[index];
        // okay switches are quite cool ngl
        switch (ins.typeL) {
            InstructionType.change => cells.items[position.*] += ins.value.?,
            InstructionType.move => {
                // so this will work?
                if (@as(i32, @intCast(position.*)) + ins.value.? + 1 > cells.items.len)
                    try append_n_elements(cells, ins.value.?);
                // it looks quite long but meh its good
                position.* = @as(usize, @intCast(@as(i32, @intCast(position.*)) + ins.value.?));
            },

            // so this will print the cell as a u8 character, thats good enough, i wonder if there is any way to do data conversion
            InstructionType.print => print("{s}", .{[1]u8{@as(u8, @intCast(cells.items[position.*]))}}),
            InstructionType.input => print("not supported yet :(", .{}),
            InstructionType.end_loop => {
                if (!loop) {
                    print("you are not in a loop ", .{});
                    return;
                }
                if (cells.items[position.*] != 0) {
                    index = 0;
                    continue;
                }
            },
            InstructionType.loop => {
                if (cells.items[position.*] != 0)
                    try evaluate(cells, position, true, ins.instructions.?);
            },
        }
        index += 1;
    }
}

// this will append new elements :)
fn append_n_elements(a: *ArrayList(i32), n: i32) !void {
    var i: i32 = 0;
    while (i < n) : (i += 1)
        try a.append(0);
}

fn tokenize(program: []const u8) !ArrayList(Token) {
    var tokens = ArrayList(Token).init(std.heap.page_allocator);
    for (program) |v| {
        // so i can do this???
        const token: ?Token = switch (v) {
            '+' => (Token.add),
            '-' => (Token.substract),
            '<' => (Token.left),
            '>' => (Token.right),
            '[' => (Token.start_loop),
            ']' => (Token.end_loop),
            '.' => (Token.print),
            ',' => Token.input,
            else => undefined,
        };
        if (token == undefined) {
            continue;
        }
        // interesting this is quite based

        try tokens.append(token.?);
    }
    return tokens;
}

fn structurize(i: *usize, tokens: *ArrayList(Token), in_loop: bool) anyerror!ArrayList(Instruction) {
    var move_value: i32 = 0;
    var change_value: i32 = 0;
    var instructions = ArrayList(Instruction).init(std.heap.page_allocator);
    while (i.* < tokens.items.len) {
        const v = tokens.items[i.*];

        switch (v) {
            Token.substract, Token.add => {
                if (move_value != 0)
                    try instructions.append(Instruction{ .typeL = InstructionType.move, .value = move_value, .instructions = undefined });

                move_value = 0;
            },
            Token.right, Token.left => {
                if (change_value != 0)
                    try instructions.append(Instruction{ .typeL = InstructionType.change, .value = change_value, .instructions = undefined });

                change_value = 0;
            },
            Token.start_loop, Token.end_loop, Token.print, Token.input => {
                if (move_value != 0)
                    try instructions.append(Instruction{ .typeL = InstructionType.move, .value = move_value, .instructions = null });

                if (change_value != 0)
                    try instructions.append(Instruction{ .typeL = InstructionType.change, .value = change_value, .instructions = null });

                change_value = 0;
                move_value = 0;
            },
        }
        switch (v) {
            // moving and shit
            Token.substract => change_value -= 1,
            Token.add => change_value += 1,
            Token.left => move_value -= 1,
            Token.right => move_value += 1,
            // io
            Token.print => try instructions.append(Instruction{ .typeL = InstructionType.print, .value = null, .instructions = null }),
            Token.input => try instructions.append(Instruction{ .typeL = InstructionType.input, .value = null, .instructions = null }),
            // the loop shit
            Token.start_loop => {
                i.* += 1;
                try instructions.append(Instruction{
                    .typeL = InstructionType.loop,
                    .value = null,
                    .instructions = try structurize(i, tokens, true),
                });
            },
            Token.end_loop => {
                if (!in_loop) {
                    print("error, you are not in a loop, thats a BIG PROBLEM  ITS SO OVER \n", .{});
                    return error.NotInLoop;
                }
                try instructions.append(Instruction{ .typeL = InstructionType.end_loop, .value = null, .instructions = null });
                return instructions;
            },
        }
        i.* += 1;
    }
    return instructions;
}

fn print_instructions(initial: ArrayList(u8), instructions: ArrayList(Instruction)) !void {
    for (instructions.items) |v| {
        print("{s}{} {?}\n", .{ initial.items, v.typeL, v.value });
        if (v.typeL == InstructionType.loop) {
            var newString = ArrayList(u8).init(std.heap.page_allocator);
            try newString.appendSlice("| ");
            try newString.appendSlice(initial.items);
            try print_instructions(newString, v.instructions.?);
        }
    }
}
