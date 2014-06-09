classdef PNG < handle

    properties (SetAccess = private)
        filename
        rgb
        alpha
    end

    methods
        function obj = PNG(filename)
            [rgb, map, alpha] = imread(['images/' filename]);
            obj.filename = filename;
            obj.rgb = rgb;
            obj.alpha = alpha;
        end

        function fill(obj)
            image(obj.rgb);
        end

        function rgb_handle = overlay_all(obj)
            hold on;
            rgb_handle = image(obj.rgb);
            set(rgb_handle, 'AlphaData', obj.alpha);
            hold off;
            drawnow;
        end

        function [rgb_handle, padded_rgb, padded_alpha] =...
                overlay(obj, width, height, left, top)
            hold on;
            padded_rgb   = pad(obj, obj.rgb,   width, height, left, top);
            padded_alpha = pad(obj, obj.alpha, width, height, left, top);
            rgb_handle = image(padded_rgb);
            set(rgb_handle, 'AlphaData', padded_alpha);
            hold off;
            drawnow;
        end

        function padded = pad(obj, image, width, height, left, top)
            right = width - (left + obj.width);
            bottom = height - (top + obj.height);
            padded = padarray(image, [top left], 0, 'pre');
            padded = padarray(padded, [bottom right], 0, 'post');
        end

        function clear(obj, rgb_handle, padded_alpha)
            set(rgb_handle, 'AlphaData', padded_alpha.* 0);
        end

        function width = width(obj)
            width = size(obj.rgb, 2);
        end

        function height = height(obj)
            height = size(obj.rgb, 1);
        end
    end
end