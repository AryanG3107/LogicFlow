% ---- Clickable Tile Browser for simpleGameEngine ----
spriteH = 16;
spriteW = 16;
my_scene = simpleGameEngine('retro_pack.png', spriteH, spriteW, 4, [0 0 0]);

% grid display settings
rowsPerPage = 8;
colsPerPage = 8;
tilesPerPage = rowsPerPage * colsPerPage;

% calculate total tiles on sheet
S = imread('retro_pack.png');
[H, W, ~] = size(S);
colsOnSheet = (W+1)/(spriteW+1);
rowsOnSheet = (H+1)/(spriteH+1);
totalTiles  = rowsOnSheet * colsOnSheet;
escapePressed = false;
page = 0;
while not(escapePressed)
    % tile IDs for this page
    ids = (page*tilesPerPage+1):(page+1)*tilesPerPage;
    grid = zeros(rowsPerPage, colsPerPage);
    grid(1:numel(ids)) = ids;
    
    % draw scene
    my_scene.drawScene(grid);
    title(sprintf('Tile IDs %d to %d (page %d)', ids(1), ids(end), page)); drawnow;
    
    % wait for either key or mouse click
    w = waitforbuttonpress;
    if w == 1
        % key pressed
        k = my_scene.getKeyboardInput();
        if strcmp(k, 'escape')
            escapePressed = true;
        elseif strcmp(k, 'rightarrow')
            if page < ceil(totalTiles/tilesPerPage)-1
              page = page + 1;
            end
        elseif strcmp(k, 'leftarrow')
            if page > 0
              page = page - 1;
            end
        end
        
        
    else
        % mouse clicked
        [r, c, ~] = my_scene.getMouseInput();
            % compute ID of clicked tile
            idx = r + (c-1)*rowsPerPage;
            tileID = ids(idx);
            fprintf('Clicked tile ID: %d\n', tileID);
            end
end
close;
            
            

   

