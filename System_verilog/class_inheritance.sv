class Shape;
    string name;

    function new(string name);
        this.name = name;
    endfunction

    function void print();
        $display("Shape: %s", name);
    endfunction
endclass

class Circle extends Shape;
    real radius;

    function new(real radius);
        super.new("Circle");
        this.radius = radius;
    endfunction

    function real calc_area();
        return 3.1416 * radius * radius;
    endfunction
endclass

class Rectangle extends Shape;
    real length, width;

    function new(real length, real width);
        super.new("Rectangle");
        this.length = length;
        this.width = width;
    endfunction

    function real calc_area();
        return length * width;
    endfunction
endclass

module test;
    Circle c;
    Rectangle r;
    initial begin
        c = new(5.89);
        c.print();
        $display("Area of %s: %0.2f", c.name, c.calc_area());
        
        r = new(4.25, 7.16);
        r.print();
        $display("Area of %s: %0.2f", r.name, r.calc_area());
    end
endmodule


// OUTPUT
// # KERNEL: Shape: Circle
// # KERNEL: Area of Circle: 108.99
// # KERNEL: Shape: Rectangle
// # KERNEL: Area of Rectangle: 30.43