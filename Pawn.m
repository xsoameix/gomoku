classdef Pawn < handle

    properties
        png
        row
        col
        rgb_handle
        padded_rgb
        padded_alpha
    end

    methods
        function set.png(obj, filename)
            obj.png = Singleton.get.png(filename);
        end

        function overlay(obj, border, width, height, row, col)
            obj.row = row;
            obj.col = col;
            left = border + col * obj.png.width;
            top = border + row * obj.png.height;
            [obj.rgb_handle, obj.padded_rgb, obj.padded_alpha] =...
                obj.png.overlay(width, height, left, top);
        end

        function clear(obj)
            obj.png.clear(obj.rgb_handle, obj.padded_alpha);
        end

        function pawn = next(obj)
            switch class(obj)
            case 'BlackPawn'
                pawn = WhitePawn;
            case 'WhitePawn'
                pawn = BlackPawn;
            end
        end
    end
end