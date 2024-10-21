const print = @import("std").debug.print;

pub fn main() void {

    // aqui obtenemos x
    var x: i32 = undefined;
    // lo definimos le ponemos todo, parece que podemos inicializarlo de manera relativamente sencilla

    x = 1;
    // y simplemente lo imprimimos :)
    print("{}\n", .{x});
}
