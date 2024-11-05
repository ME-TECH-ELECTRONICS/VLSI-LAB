// Base class
class Shape;
    // Properties
    string name;

    // Constructor for Shape class
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

    function real calculate_area();
        return 3.1416 * radius * radius;
    endfunction
endclass

// Derived class: Rectangle
class Rectangle extends Shape;
    real length, width;

    // Constructor for Rectangle class
    function new(real length, real width);
        super.new("Rectangle");
        this.length = length;
        this.width = width;
    endfunction

    // Override the calculate_area method for Rectangle
    function real calculate_area();
        return length * width;
    endfunction
endclass

// Test Program
module test;
    initial begin
        // Create an instance of Circle
        Circle c = new(5.0);
        c.display();
        $display("Area of %s: %0.2f", c.name, c.calculate_area());

        // Create an instance of Rectangle
        Rectangle r = new(4.0, 7.0);
        r.display();
        $display("Area of %s: %0.2f", r.name, r.calculate_area());
    end
endmodule