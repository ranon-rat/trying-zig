const print = @import("std").debug.print;
const Complex = struct {
    real: f32,
    imaginary: f32,
    /// this will initialize the complex number
    pub fn init(r: f32, i: f32) Complex {
        return Complex{ .real = r, .imaginary = i };
    }
    /// this just adds in a complex plane
    pub fn add(self: Complex, n: Complex) Complex {
        return Complex{
            .real = self.real + n.real,
            .imaginary = self.imaginary + n.imaginary,
        };
    }
    ///this is a simple multiplication of pulinomials
    /// (a+bi)(c+di)=a*c+adi+cbi-bd=(ac-bd)+(adi+cbi)
    /// R=ac-bd
    /// I=ad+cb
    pub fn multiply(self: Complex, n: Complex) Complex {
        return Complex{
            .real = self.real * n.real - self.imaginary * n.imaginary,
            .imaginary = self.real * n.imaginary + self.imaginary * n.real,
        };
    }

    ///squared hypothenus
    pub fn beforeAbs(self: Complex) f32 {
        return self.real * self.real + self.imaginary * self.imaginary;
    }
    /// this will squared the value
    pub fn pow2(self: Complex) Complex {
        return self.multiply(self);
    }
};
//with this i just scale the pixels
fn scale(i: i32, max: i32, out_min: f32, out_max: f32) f32 {
    const n: f32 = (@as(f32, @floatFromInt(i))) / @as(f32, @floatFromInt(max));
    const out: f32 = n * (out_max - out_min) + out_min;
    return out;
}

const width: i32 = 30;
const height: i32 = 30;
const maxIter: i32 = 80;

/// so with this we have just learned the next
/// how to make simple functions
/// how structs look
/// how to make functions
/// convertion of types
/// and the usage of another libraries.
/// now with this its beginning to be quite op
pub fn main() void {
    var px: i32 = 0;
    while (px <= width) : (px += 1) {
        var py: i32 = 0;
        while (py <= height) : (py += 1) {
            const cx = scale(px, width, -2.111, 1.0);
            const cy = scale(py, height, -1, 1);
            const c: Complex = Complex.init(cx, cy);
            var z: Complex = Complex.init(0, 0);
            var i: i32 = 0;
            while (z.beforeAbs() <= 4 and i < maxIter) : (i += 1) {
                z = z.pow2().add(c);
            }
            if (i < maxIter) {
                print("#", .{});
            } else {
                print(" ", .{});
            }
        }
        print("\n", .{});
    }
}
