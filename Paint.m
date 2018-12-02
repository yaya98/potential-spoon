function [] = Paint()
width = 600;
height = 600;
window = figure('Position' ,[0 0 width height], 'Name' , 'TheBestWindowEver');
graphics = axes('Units', 'Pixels', 'Position', [0 0 width height]);
axis([0 width 0 height])
set(graphics, 'Ytick', []);
set(graphics, 'Xtick', []);
set(window, 'KeyPressFcn' , @KeyPress);
set(window, 'WindowButtonDownFcn' , @MouseDown);
set(window, 'WindowButtonUpFcn' , @MouseUp);
set(window, 'WindowButtonMotionFcn' , @MouseMove);
color = [0 0 0];
pen = [3 3];
isMouseDown = false;
moves = [];
function [] = MouseDown(~,~)
    isMouseDown = true;
end
    function [] = MouseUp(~,~)
        isMouseDown = false;
    end
    function [] = MouseMove(~,~)
        pos = get(window,'CurrentPoint');
        if isMouseDown
            rectangle('Position',[pos-pen/2 pen],'EdgeColor',color/255,'FaceColor',color/255,'Curvature',[1 1]);
            moves = [moves; pos color pen];
            if size(moves,1) > 50
                moves(1,:) = [];
            end
        end
    end
    function [] = KeyPress(~,event)
        key = event.Character;
        if key =='y'
            color = [255 255 0];
        elseif key =='r'
            color = [255 0 0];
        elseif key == 'g'
            color = [0 255 0];
        elseif key == 'b'
            color = [0 0 255];
        elseif key == 'p'
            color = [128 0 128];
        elseif key == 'c'
            color = [210 105 30]; 
        elseif key == 'd'
            color = [0 0 0];
        elseif key == '1'
            pen = [1 1];
        elseif key == '2'
            pen = [2 2];
        elseif key == '3'
            pen = [3 3];
        elseif key == '4'
            pen = [4 4];
        elseif key == '5'
            pen = [5 5];
        elseif key == '6'
            pen = [6 6];
        elseif key == '7'
            pen = [7 7];
        elseif key == 'u'
            if size(moves,1) > 0
                pos = moves(end,[1 2]);
                rectangle('Position', [pos-pen/2 pen],'EdgeColor',[1 1 1], 'FaceColor', [1 1 1], 'Curvature', [1 1]);
                color = moves(end, [3 4 5]);
                pen = moves(end, [6 7]);
                moves(end,:) = [];
            end
        end
    end
end
