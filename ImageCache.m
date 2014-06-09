classdef ImageCache < handle

    properties
        map = containers.Map;
    end

    methods
        function value = png(obj, key)
            if obj.map.isKey(key)
                value = obj.map(key);
            else
                value = PNG(key);
                obj.map(key) = value;
            end
        end
    end
end