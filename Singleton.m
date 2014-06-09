classdef Singleton < handle

    properties (Constant)
        get = ImageCache;
    end

    methods (Access = private)
        function obj = Singleton
        end
    end
end