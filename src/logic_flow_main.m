%% --Open world game with movement and scrolling map--

% Engine setup
spriteHeight = 16; 
spriteWidth  = 16;
zoomFactor   = 4;

choice = gameStartFunction(spriteHeight, spriteWidth, zoomFactor);

%% --Game Setup--

% Establish game scene
gameScene = simpleGameEngine('retro_pack.png', spriteHeight, spriteWidth, zoomFactor);

%% World Setup

% Tile Sprite IDs
baseGrassTileId  = 65;     % normal grass
baseGrassTileId2 = 7;      % normal grass type 2
baseGrassTileId3 = 8;      % normal grass type 3
redGrassTileId   = 2;      % red grass
treeTileId       = 35;     % trees (not walkable)
lakeTileId       = 169;    % lake (not walkable)
playerTileId     = 28;     % player sprite
fullHeart        = 728;    % Player Life
brokenHeart      = 729;    % Player life broken

% Biome floor tiles Sprite IDs
andBiomeTileId = 17;       % AND biome floor
orBiomeTileId  = 120;      % OR biome floor
xorBiomeTileId = 177;      % XNOR biome floor 
notBiomeTileId = 455;      % NAND biome floor 

% Game Aspect Sprite IDs
doorClosedTileId    = 289;   % CLOSED door
doorOpenTileId      = 291;   % OPEN door
keyTileId           = 753;   % KEY tile 
leverOffTileId      = 324;   % lever OFF
leverOnTileId       = 325;   % lever ON
confirmLeverTileId  = 396;   % CONFIRM lever
lightOffTileId      = 468;   % light OFF
lightOnTileId       = 471;   % light ON

% Arrow Sprite IDs
arrowUpTileId    = 696;   % UP arrow
arrowDownTileId  = 698;   % DOWN arrow
arrowLeftTileId  = 699;   % LEFT arrow
arrowRightTileId = 697;   % RIGHT arrow

% World Map size
worldRows = 100;
worldCols = 100;

% Set all to grass
worldBg = baseGrassTileId * ones(worldRows, worldCols);

% Set Different Grass to see movement
for i = 1:worldRows
    for k = 1:worldCols
        if (mod(i,3) == 0)
            if(mod(k,2) == 0)
                worldBg(i,k) = baseGrassTileId2; 
            else
                worldBg(i,k) = baseGrassTileId3; 
            end
        elseif (mod(i,3) == 1)
            if(mod(k,2) == 0)
                worldBg(i,k) = baseGrassTileId3; 
            else
                worldBg(i,k) = baseGrassTileId; 
            end
        else
            if(mod(k,2) == 0)
                worldBg(i,k) = baseGrassTileId; 
            else
                worldBg(i,k) = baseGrassTileId2; 
            end
        end
    end
end

% Add trees as map border
worldBg(1,:)        = treeTileId;
worldBg(end,:)      = treeTileId;
worldBg(:,1)        = treeTileId;
worldBg(:,end)      = treeTileId;

% Player initial WORLD position (center of map)
playerRowWorld = round(worldRows / 2);
playerColWorld = round(worldCols / 2);

% Door position
doorRow = playerRowWorld - 2;
doorCol = playerColWorld;
worldBg(doorRow, doorCol) = doorClosedTileId;

% Biome center positions
andCenterRow = 20; andCenterCol = 20;  % AND biome
orCenterRow  = 20; orCenterCol  = 80;  % OR biome
xorCenterRow = 80; xorCenterCol = 20;  % XNOR biome
notCenterRow = 80; notCenterCol = 80;  % NAND biome

%% Biome design

biomeRadius = 5; 

% AND biome
for r = andCenterRow-biomeRadius:andCenterRow+biomeRadius
    for c = andCenterCol-biomeRadius:andCenterCol+biomeRadius
        worldBg(r,c) = andBiomeTileId;
    end
end
% Game Aspects in AND biome 
worldBg(andCenterRow, andCenterCol-3) = leverOffTileId;     % input A
worldBg(andCenterRow, andCenterCol-1) = leverOffTileId;     % input B
worldBg(andCenterRow, andCenterCol+1) = confirmLeverTileId; % confirm
worldBg(andCenterRow, andCenterCol+3) = lightOffTileId;     % light

% OR biome
for r = orCenterRow-biomeRadius:orCenterRow+biomeRadius
    for c = orCenterCol-biomeRadius:orCenterCol+biomeRadius
        worldBg(r,c) = orBiomeTileId;
    end
end
% Game Aspects in OR biome 
worldBg(orCenterRow-1, orCenterCol-3) = leverOffTileId;      % input A
worldBg(orCenterRow+1, orCenterCol-3) = leverOffTileId;      % input B
worldBg(orCenterRow,   orCenterCol+1) = confirmLeverTileId;  % confirm
worldBg(orCenterRow,   orCenterCol+3) = lightOffTileId;      % light

% XNOR biome 
for r = xorCenterRow-biomeRadius:xorCenterRow+biomeRadius
    for c = xorCenterCol-biomeRadius:xorCenterCol+biomeRadius
        worldBg(r,c) = xorBiomeTileId;
    end
end
% Game Aspects in XNOR biome 
worldBg(xorCenterRow-1, xorCenterCol-3) = leverOffTileId;    % input A
worldBg(xorCenterRow+1, xorCenterCol-3) = leverOffTileId;    % input B
worldBg(xorCenterRow,   xorCenterCol+1) = confirmLeverTileId;% confirm
worldBg(xorCenterRow,   xorCenterCol+3) = lightOffTileId;    % light

% NAND biome
for r = notCenterRow-biomeRadius:notCenterRow+biomeRadius
    for c = notCenterCol-biomeRadius:notCenterCol+biomeRadius
        worldBg(r,c) = notBiomeTileId;
    end
end
% Game Aspects in NAND biome 
worldBg(notCenterRow, notCenterCol-3) = leverOffTileId;      % input A
worldBg(notCenterRow, notCenterCol-1) = leverOffTileId;      % input B
worldBg(notCenterRow, notCenterCol+1) = confirmLeverTileId;  % confirm
worldBg(notCenterRow, notCenterCol+3) = lightOffTileId;      % light

%% View Window Setup (11x11)

viewRows = 11;
viewCols = 11;
halfViewRows = floor(viewRows / 2); 
halfViewCols = floor(viewCols / 2);  

centerRowScreen = ceil(viewRows / 2);  
centerColScreen = ceil(viewCols / 2);

% Initial camera window
camTopWorldRow  = playerRowWorld - halfViewRows;
camLeftWorldCol = playerColWorld - halfViewCols;

camTopWorldRow  = max(1, min(camTopWorldRow,  worldRows - viewRows + 1));
camLeftWorldCol = max(1, min(camLeftWorldCol, worldCols - viewCols + 1));

camBottomWorldRow = camTopWorldRow  + viewRows - 1;
camRightWorldCol  = camLeftWorldCol + viewCols - 1;

% Player window position
playerRowScreen = playerRowWorld - camTopWorldRow  + 1;
playerColScreen = playerColWorld - camLeftWorldCol + 1;

% Per-axis border locks:
% -1 = locked at top/left border, 0 = no lock, +1 = locked at bottom/right
borderLockRow = 0;
borderLockCol = 0;

% Initial draw
viewBg = worldBg(camTopWorldRow:camBottomWorldRow,camLeftWorldCol:camRightWorldCol);
viewFg = viewBg;
viewFg(playerRowScreen, playerColScreen) = playerTileId;
viewFg(1,viewCols-2:viewCols) = fullHeart;

% Initial Quit on start Screen
if strcmp(choice, "quit")
    close;
elseif strcmp(choice,"start")
    gameScene.drawScene(viewBg, viewFg);

    %% --GAME LOOP--

    gameStatus = gameLoop( ...
        gameScene, worldBg, worldRows, worldCols, ...
        treeTileId, lakeTileId, playerTileId, fullHeart, brokenHeart, ...
        keyTileId, doorClosedTileId, doorOpenTileId, ...
        leverOffTileId, leverOnTileId, confirmLeverTileId, ...
        lightOffTileId, lightOnTileId, ...
        andCenterRow, andCenterCol, ...
        orCenterRow, orCenterCol, ...
        xorCenterRow, xorCenterCol, ...
        notCenterRow, notCenterCol, ...
        doorRow, doorCol, ...
        viewRows, viewCols, halfViewRows, halfViewCols, ...
        centerRowScreen, centerColScreen, ...
        playerRowWorld, playerColWorld, ...
        camTopWorldRow, camLeftWorldCol, ...
        borderLockRow, borderLockCol, ...
        andBiomeTileId, orBiomeTileId, xorBiomeTileId, notBiomeTileId, ...
        arrowUpTileId, arrowDownTileId, arrowLeftTileId, arrowRightTileId);

    % Gets choice of user when game loop is not running
    if gameStatus == "win"
        choice = gameWinFunction(spriteHeight, spriteWidth, zoomFactor);
    else
        choice = gameOverFunction(spriteHeight, spriteWidth, zoomFactor);
    end

    % While Quit is not the choice entered
    while (choice ~= "quit")
        % If choose to restart the game
        if choice == "restart"
            % Reset initial draw
            gameScene.drawScene(viewBg, viewFg);

            gameStatus = gameLoop( ...
                gameScene, worldBg, worldRows, worldCols, ...
                treeTileId, lakeTileId, playerTileId, fullHeart, brokenHeart, ...
                keyTileId, doorClosedTileId, doorOpenTileId, ...
                leverOffTileId, leverOnTileId, confirmLeverTileId, ...
                lightOffTileId, lightOnTileId, ...
                andCenterRow, andCenterCol, ...
                orCenterRow, orCenterCol, ...
                xorCenterRow, xorCenterCol, ...
                notCenterRow, notCenterCol, ...
                doorRow, doorCol, ...
                viewRows, viewCols, halfViewRows, halfViewCols, ...
                centerRowScreen, centerColScreen, ...
                playerRowWorld, playerColWorld, ...
                camTopWorldRow, camLeftWorldCol, ...
                borderLockRow, borderLockCol, ...
                andBiomeTileId, orBiomeTileId, xorBiomeTileId, notBiomeTileId, ...
                arrowUpTileId, arrowDownTileId, arrowLeftTileId, arrowRightTileId);

            % Gets choice of user again when game loop is not running
            if gameStatus == "win"
                choice = gameWinFunction(spriteHeight, spriteWidth, zoomFactor);
            else
                choice = gameOverFunction(spriteHeight, spriteWidth, zoomFactor);
            end
        end
    end
    close;
end
