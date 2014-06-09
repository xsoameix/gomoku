classdef Board < handle

    properties
        hObject
        pane
        pawns = {};
        board
        border = 10;
        pawn_sample = BlackPawn;
        game_ready = 1;
    end

    methods
        function obj = Board(hObject)
            obj.hObject = hObject;
            obj.pane = PNG('board.png');
            obj.change_window_title;
            obj.change_window_icon;
            obj.create_empty_board;
            obj.resize_pane;
            obj.fill_window;
            axis off;
        end

        function change_window_title(obj)
            set(obj.hObject, 'Name', 'Gomoku');
        end

        function change_window_icon(obj)
            warning('off','MATLAB:HandleGraphics:ObsoletedProperty:JavaFrame');
            jframe = get(obj.hObject,'JavaFrame');
            jframe.setFigureIcon(javax.swing.ImageIcon('images/icon.png'));
        end

        function create_empty_board(obj)
            width = obj.pane.width;
            height = obj.pane.height;
            pawn = obj.pawn_sample;
            rows = (height - obj.border.* 2)./ pawn.png.height;
            cols = (width - obj.border.* 2)./ pawn.png.width;
            obj.board = cell(rows, cols);
        end

        function resize_pane(obj)
            width = obj.pane.width;
            height = obj.pane.height;
            set(obj.hObject, 'units', 'pixels', ...
                             'Position', [0 0 width, height]);
        end

        function fill_window(obj)
            subplot('position', [0 0 1 1]);
            obj.pane.fill;
        end

        function place(obj, left, top)
            if obj.game_ready
                [row, col] = obj.floor_point(left, top);
                if isempty(obj.board{row + 1, col + 1})
                    pawn = obj.gen_pawn;
                    obj.place_pawn(pawn, row, col);
                    if obj.game_over
                        obj.show_slogan;
                        obj.clear_board;
                    end
                end
            end
        end

        function [row, col] = floor_point(obj, left, top)
            pawn = obj.pawn_sample;
            row = floor((top  - obj.border)./ pawn.png.height);
            col = floor((left - obj.border)./ pawn.png.width);
        end

        function pawn = gen_pawn(obj)
            if isempty(obj.pawns)
                pawn = BlackPawn;
            else
                pawn = obj.pawns{end};
                pawn = pawn.next;
            end
            obj.pawns{end + 1} = pawn;
        end

        function place_pawn(obj, pawn, row, col)
            pawn.overlay(obj.border,...
                         obj.pane.width, obj.pane.height, row, col);
            obj.board{row + 1, col + 1} = pawn;
        end

        function bool = game_over(obj)
            pawn = obj.pawns{end};
            front = [pawn.row + 1, pawn.col + 1];
            bool = (obj.spread_top_to_bottom(front, pawn) ||...
                    obj.spread_left_to_right(front, pawn) ||...
                    obj.spread_left_top_to_right_bottom(front, pawn) ||...
                    obj.spread_left_bottom_to_right_top(front, pawn));
        end

        function bool = spread_top_to_bottom(obj, front, pawn)
            tail = front;

            in_boundary = @(front) front(1) > 1;
            step        = @(front) deal(front(1) - 1, front(2));
            front = obj.spread_on_board(front, pawn, in_boundary, step);

            in_boundary = @(front) front(1) < size(obj.board, 1);
            step        = @(front) deal(front(1) + 1, front(2));
            tail = obj.spread_on_board(tail, pawn, in_boundary, step);

            bool = tail(1) - front(1) == 4;
        end

        function bool = spread_left_to_right(obj, front, pawn)
            tail = front;

            in_boundary = @(front) front(2) > 1;
            step        = @(front) deal(front(1), front(2) - 1);
            front = obj.spread_on_board(front, pawn, in_boundary, step);

            in_boundary = @(front) front(2) < size(obj.board, 2);
            step        = @(front) deal(front(1), front(2) + 1);
            tail = obj.spread_on_board(tail, pawn, in_boundary, step);

            bool = tail(2) - front(2) == 4;
        end

        function bool = spread_left_top_to_right_bottom(obj, front, pawn)
            tail = front;

            in_boundary = @(front) front(1) > 1 && front(2) > 1;
            step        = @(front) deal(front(1) - 1, front(2) - 1);
            front = obj.spread_on_board(front, pawn, in_boundary, step);

            in_boundary = @(front) front(1) < size(obj.board, 1) &&...
                                   front(2) < size(obj.board, 2);
            step        = @(front) deal(front(1) + 1, front(2) + 1);
            tail = obj.spread_on_board(tail, pawn, in_boundary, step);

            bool = tail(1) - front(1) == 4 &&...
                   tail(2) - front(2) == 4;
        end

        function bool = spread_left_bottom_to_right_top(obj, front, pawn)
            tail = front;

            in_boundary = @(front) front(1) < size(obj.board, 1) && front(2) > 1;
            step        = @(front) deal(front(1) + 1, front(2) - 1);
            front = obj.spread_on_board(front, pawn, in_boundary, step);

            in_boundary = @(front) front(1) > 1 && front(2) < size(obj.board, 2);
            step        = @(front) deal(front(1) - 1, front(2) + 1);
            tail = obj.spread_on_board(tail, pawn, in_boundary, step);

            bool = front(1) - tail(1) == 4 &&...
                   tail(2) - front(2) == 4;
        end

        function front = spread_on_board(obj, front, pawn, in_boundary, step)
            if in_boundary(front)
                [row, col] = step(front);
                next = obj.board{row, col};
                while ~isempty(next) && strcmp(class(next), class(pawn))
                    [front(1), front(2)] = step(front);
                    if in_boundary(front)
                        [row, col] = step(front);
                        next = obj.board{row, col};
                    else
                        break;
                    end
                end
            end
        end

        function show_slogan(obj)
            obj.game_ready = 0;
            pawn = obj.pawns{end};
            switch class(pawn)
            case 'BlackPawn'
                filename = 'you win.png';
            case 'WhitePawn'
                filename = 'you lose.png';
            end
            png = Singleton.get.png(filename);
            rgb_handle = png.overlay_all;
            pause(4);
            png.clear(rgb_handle, png.alpha);
        end

        function clear_board(obj)
            for ii = 1:length(obj.pawns)
                pawn = obj.pawns{ii};
                pawn.clear;
                obj.board{pawn.row + 1, pawn.col + 1} = [];
            end
            obj.pawns = {};
            obj.game_ready = 1;
        end
    end
end