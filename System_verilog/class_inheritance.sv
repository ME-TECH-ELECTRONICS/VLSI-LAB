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

    function real calculate_area();
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

    function real calculate_area();
        return length * width;
    endfunction
endclass

module test;
    initial begin
        Circle c = new(5.0);
        c.display();
        $display("Area of %s: %0.2f", c.name, c.calculate_area());

        Rectangle r = new(4.0, 7.0);
        r.display();
        $display("Area of %s: %0.2f", r.name, r.calculate_area());
    end
endmodule