function gameStatus = gameLoop(gameScene, worldBg, worldRows, worldCols, ...
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
                  arrowUpTileId, arrowDownTileId, arrowLeftTileId, arrowRightTileId)

escapePressed = false;
gameStatus = "dead";

% Lives and key state
lives = 3;

% 0 = not solved/no key
% 1 = gate solved/key dropped on ground 
% 2 = key picked up/in inventory
andKey = 0;
orKey  = 0;
xorKey = 0;  
notKey = 0;  

andVisited = 0;
orVisited  = 0;
xorVisited = 0;
notVisited = 0;

% Confirm lever positions 
andConfirmRow = andCenterRow;
andConfirmCol = andCenterCol + 1;

orConfirmRow  = orCenterRow;
orConfirmCol  = orCenterCol + 1;

xorConfirmRow = xorCenterRow;
xorConfirmCol = xorCenterCol + 1;

notConfirmRow = notCenterRow;
notConfirmCol = notCenterCol + 1;

while ~escapePressed
    key = gameScene.getKeyboardInput();

    % Game Over Screen
    if strcmp(key, 'escape')
        escapePressed = true;
        gameStatus = "dead";
        break;
    end

    % Pause Screen overlay
    if strcmp(key, 'p')
        % Build current frame to pass into pauseScreen
        [viewBg, viewFg] = buildFrame( ...
            worldBg, ...
            camTopWorldRow, camLeftWorldCol, ...
            viewRows, viewCols, ...
            playerRowWorld, playerColWorld, ...
            playerTileId, ...
            fullHeart, brokenHeart, lives, ...
            andKey, orKey, xorKey, notKey, keyTileId, ...
            andCenterRow, andCenterCol, ...
            orCenterRow, orCenterCol, ...
            xorCenterRow, xorCenterCol, ...
            notCenterRow, notCenterCol, ...
            doorRow, doorCol, ...
            centerRowScreen, centerColScreen, ...
            arrowUpTileId, arrowDownTileId, arrowLeftTileId, arrowRightTileId);

        pauseScreen(gameScene, viewBg, viewFg); 
        continue;                
    end

    % Space: lever interaction / confirm
    if strcmp(key, 'space')
        % check tiles around the player
        adjRows = [playerRowWorld-1, playerRowWorld+1, playerRowWorld,   playerRowWorld];
        adjCols = [playerColWorld,   playerColWorld,   playerColWorld-1, playerColWorld+1];

        for k = 1:4
            r = adjRows(k);
            c = adjCols(k);

            if r < 1 || r > worldRows || c < 1 || c > worldCols
                continue;
            end

            tile = worldBg(r,c);

            % Toggle any lever tile
            if tile == leverOffTileId
                worldBg(r,c) = leverOnTileId;
            elseif tile == leverOnTileId
                worldBg(r,c) = leverOffTileId;
            end

            % Confirm lever: check logic for that biome (State 1)
            if tile == confirmLeverTileId
                % AND biome confirm: A AND B
                if r == andConfirmRow && c == andConfirmCol
                    aTile = worldBg(andCenterRow, andCenterCol-3);
                    bTile = worldBg(andCenterRow, andCenterCol-1);
                    aVal = (aTile == leverOnTileId);
                    bVal = (bTile == leverOnTileId);
                    if aVal && bVal
                        worldBg(andCenterRow, andCenterCol+3) = lightOnTileId;
                        if andKey == 0
                            andKey = 1; % key dropped on ground
                            showMessage(gameScene,'Correct AND gate! Key dropped. Press Enter.');
                        end
                    else
                        worldBg(andCenterRow, andCenterCol+3) = lightOffTileId;
                        lives = lives - 1;
                        showMessage(gameScene,'Incorrect AND gate. You lost a life. Press Enter.');
                    end
                end

                % OR biome confirm: A OR B
                if r == orConfirmRow && c == orConfirmCol
                    aTile = worldBg(orCenterRow-1, orCenterCol-3);
                    bTile = worldBg(orCenterRow+1, orCenterCol-3);
                    aVal = (aTile == leverOnTileId);
                    bVal = (bTile == leverOnTileId);
                    if aVal || bVal
                        worldBg(orCenterRow, orCenterCol+3) = lightOnTileId;
                        if orKey == 0
                            orKey = 1;
                            showMessage(gameScene,'Correct OR gate! Key dropped. Press Enter.');
                        end
                    else
                        worldBg(orCenterRow, orCenterCol+3) = lightOffTileId;
                        lives = lives - 1;
                        showMessage(gameScene,'Incorrect OR gate. You lost a life. Press Enter.');
                    end
                end

                % XNOR biome confirm: A XNOR B 
                if r == xorConfirmRow && c == xorConfirmCol
                    aTile = worldBg(xorCenterRow-1, xorCenterCol-3);
                    bTile = worldBg(xorCenterRow+1, xorCenterCol-3);
                    aVal = (aTile == leverOnTileId);
                    bVal = (bTile == leverOnTileId);
                    if aVal == bVal
                        worldBg(xorCenterRow, xorCenterCol+3) = lightOnTileId;
                        if xorKey == 0
                            xorKey = 1;
                            showMessage(gameScene,'Correct XNOR gate! Key dropped. Press Enter.');
                        end
                    else
                        worldBg(xorCenterRow, xorCenterCol+3) = lightOffTileId;
                        lives = lives - 1;
                        showMessage(gameScene,'Incorrect XNOR gate. You lost a life. Press Enter.');
                    end
                end

                % NAND biome confirm: A NAND B
                if r == notConfirmRow && c == notConfirmCol
                    aTile = worldBg(notCenterRow, notCenterCol-3);
                    bTile = worldBg(notCenterRow, notCenterCol-1);
                    aVal = (aTile == leverOnTileId);
                    bVal = (bTile == leverOnTileId);
                    if ~(aVal && bVal)
                        worldBg(notCenterRow, notCenterCol+3) = lightOnTileId;
                        if notKey == 0
                            notKey = 1;
                            showMessage(gameScene,'Correct NAND gate! Key dropped. Press Enter.');
                        end
                    else
                        worldBg(notCenterRow, notCenterCol+3) = lightOffTileId;
                        lives = lives - 1;
                        showMessage(gameScene,'Incorrect NAND gate. You lost a life. Press Enter.');
                    end
                end
            end
        end

        % Check lives after logic checks
        if lives <= 0
            gameStatus = "dead";
            break;
        end

        % Redraw after lever changes
        [viewBg, viewFg] = buildFrame( ...
            worldBg, ...
            camTopWorldRow, camLeftWorldCol, ...
            viewRows, viewCols, ...
            playerRowWorld, playerColWorld, ...
            playerTileId, ...
            fullHeart, brokenHeart, lives, ...
            andKey, orKey, xorKey, notKey, keyTileId, ...
            andCenterRow, andCenterCol, ...
            orCenterRow, orCenterCol, ...
            xorCenterRow, xorCenterCol, ...
            notCenterRow, notCenterCol, ...
            doorRow, doorCol, ...
            centerRowScreen, centerColScreen, ...
            arrowUpTileId, arrowDownTileId, arrowLeftTileId, arrowRightTileId);

        gameScene.drawScene(viewBg, viewFg);

        %Lives Check
        if lives <= 0
            break;
        end
        continue;
    end

    % Movement direction 
    dRow = 0; 
    dCol = 0;
    switch key
        case 'uparrow',    dRow = -1;
        case 'downarrow',  dRow =  1;
        case 'leftarrow',  dCol = -1;
        case 'rightarrow', dCol =  1;
        otherwise
            continue;
    end

    % Moving player in world
    newRowWorld = playerRowWorld + dRow;
    newColWorld = playerColWorld + dCol;

    % World bounds
    if newRowWorld < 1 || newRowWorld > worldRows || newColWorld < 1 || newColWorld > worldCols
        continue;
    end

    % Collision: trees, lakes, levers, lights, confirm levers
    newTile = worldBg(newRowWorld, newColWorld);
    if newTile == treeTileId || newTile == lakeTileId || ...
       newTile == leverOffTileId || newTile == leverOnTileId || ...
       newTile == lightOffTileId || newTile == lightOnTileId || ...
       newTile == confirmLeverTileId
        continue;
    end

    % Compute how many keys currently picked up (State 2)
    keysCollected = 0;
    if andKey == 2, keysCollected = keysCollected + 1; end
    if orKey  == 2, keysCollected = keysCollected + 1; end
    if xorKey == 2, keysCollected = keysCollected + 1; end
    if notKey == 2, keysCollected = keysCollected + 1; end

    % Door logic
    if newRowWorld == doorRow && newColWorld == doorCol && newTile == doorClosedTileId
        if keysCollected < 4
            missing = 4 - keysCollected;
            if missing == 1
                msg = 'You need 1 more key to open this door. Press Enter.';
            else
                msg = ['You need ' num2str(missing) ' more keys to open this door. Press Enter.'];
            end
            showMessage(gameScene, msg);
            continue;
        else
            worldBg(doorRow, doorCol) = doorOpenTileId;
            newTile = doorOpenTileId;
        end
    end

    % Accept world move
    playerRowWorld = newRowWorld;
    playerColWorld = newColWorld;

    % Pick up keys when stepping on center tile where key is dropped
    if playerRowWorld == andCenterRow && playerColWorld == andCenterCol && andKey == 1
        andKey = 2; % picked
    end
    if playerRowWorld == orCenterRow && playerColWorld == orCenterCol && orKey == 1
        orKey = 2;
    end
    if playerRowWorld == xorCenterRow && playerColWorld == xorCenterCol && xorKey == 1
        xorKey = 2;
    end
    if playerRowWorld == notCenterRow && playerColWorld == notCenterCol && notKey == 1
        notKey = 2;
    end

    % Recompute keysCollected after possible pickup
    keysCollected = 0;
    if andKey == 2, keysCollected = keysCollected + 1; end
    if orKey  == 2, keysCollected = keysCollected + 1; end
    if xorKey == 2, keysCollected = keysCollected + 1; end
    if notKey == 2, keysCollected = keysCollected + 1; end

    % Win if entering open door
    if playerRowWorld == doorRow && playerColWorld == doorCol && newTile == doorOpenTileId
        gameStatus = "win";
        break;
    end

    %% Vertical Camera movement scrolling vs player movement
    if borderLockRow ~= 0
        % Camera pinned vertically --> player moves on screen
        playerRowScreen = playerRowWorld - camTopWorldRow + 1;

        % Unlock logic: when moving away from border and reaching center
        if borderLockRow == -1  % locked to TOP border
            if dRow > 0 && playerRowScreen >= centerRowScreen
                borderLockRow = 0;
                camTopWorldRow = playerRowWorld - halfViewRows;
                camTopWorldRow = max(1, min(camTopWorldRow, worldRows - viewRows + 1));
                playerRowScreen = centerRowScreen;
            end
        elseif borderLockRow == 1  % locked to BOTTOM border
            if dRow < 0 && playerRowScreen <= centerRowScreen
                borderLockRow = 0;
                camTopWorldRow = playerRowWorld - halfViewRows;
                camTopWorldRow = max(1, min(camTopWorldRow, worldRows - viewRows + 1));
                playerRowScreen = centerRowScreen;
            end
        end
    else
        % Camera follows player vertically
        camTopWorldRow = playerRowWorld - halfViewRows;
        camTopWorldRow = max(1, min(camTopWorldRow, worldRows - viewRows + 1));
        playerRowScreen = playerRowWorld - camTopWorldRow + 1;

        % If camera hits top/bottom border while moving toward it, lock it
        if camTopWorldRow == 1 && dRow < 0
            borderLockRow = -1;  % top
        elseif camTopWorldRow == worldRows - viewRows + 1 && dRow > 0
            borderLockRow = 1;   % bottom
        end
    end

    %% Horizonal Camera movement scrolling vs player movement
    if borderLockCol ~= 0
        % Camera pinned horizontally --> player moves on screen
        playerColScreen = playerColWorld - camLeftWorldCol + 1;

        % Unlock logic: moving away & reaching center
        if borderLockCol == -1  % locked to LEFT border
            if dCol > 0 && playerColScreen >= centerColScreen
                borderLockCol = 0;
                camLeftWorldCol = playerColWorld - halfViewCols;  % FIXED: use playerColWorld
                camLeftWorldCol = max(1, min(camLeftWorldCol, worldCols - viewCols + 1));
                playerColScreen = centerColScreen;
            end
        elseif borderLockCol == 1  % locked to RIGHT border
            if dCol < 0 && playerColScreen <= centerColScreen
                borderLockCol = 0;
                camLeftWorldCol = playerColWorld - halfViewCols;
                camLeftWorldCol = max(1, min(camLeftWorldCol, worldCols - viewCols + 1));
                playerColScreen = centerColScreen;
            end
        end
    else
        % Camera follows player horizontally
        camLeftWorldCol = playerColWorld - halfViewCols;
        camLeftWorldCol = max(1, min(camLeftWorldCol, worldCols - viewCols + 1));
        playerColScreen = playerColWorld - camLeftWorldCol + 1;

        % If camera hits left/right border while moving toward it, lock it
        if camLeftWorldCol == 1 && dCol < 0
            borderLockCol = -1;  % left
        elseif camLeftWorldCol == worldCols - viewCols + 1 && dCol > 0
            borderLockCol = 1;   % right
        end
    end

    % Biome entry text (once per biome)
    if andVisited == 0
        if abs(playerRowWorld - andCenterRow) <= 2 && abs(playerColWorld - andCenterCol) <= 2
            showMessage(gameScene, 'You entered the AND gate biome. Press Enter.');
            andVisited = 1;
        end
    end
    if orVisited == 0
        if abs(playerRowWorld - orCenterRow) <= 2 && abs(playerColWorld - orCenterCol) <= 2
            showMessage(gameScene, 'You entered the OR gate biome. Press Enter.');
            orVisited = 1;
        end
    end
    if xorVisited == 0
        if abs(playerRowWorld - xorCenterRow) <= 2 && abs(playerColWorld - xorCenterCol) <= 2
            showMessage(gameScene, 'You entered the XNOR gate biome. Press Enter.');
            xorVisited = 1;
        end
    end
    if notVisited == 0
        if abs(playerRowWorld - notCenterRow) <= 2 && abs(playerColWorld - notCenterCol) <= 2
            showMessage(gameScene, 'You entered the NAND gate biome. Press Enter.');
            notVisited = 1;
        end
    end

    % Check lives for game over 
    if lives <= 0
        gameStatus = "dead";
        break;
    end

    % Final redraw 
    [viewBg, viewFg] = buildFrame( ...
        worldBg, ...
        camTopWorldRow, camLeftWorldCol, ...
        viewRows, viewCols, ...
        playerRowWorld, playerColWorld, ...
        playerTileId, ...
        fullHeart, brokenHeart, lives, ...
        andKey, orKey, xorKey, notKey, keyTileId, ...
        andCenterRow, andCenterCol, ...
        orCenterRow, orCenterCol, ...
        xorCenterRow, xorCenterCol, ...
        notCenterRow, notCenterCol, ...
        doorRow, doorCol, ...
        centerRowScreen, centerColScreen, ...
        arrowUpTileId, arrowDownTileId, arrowLeftTileId, arrowRightTileId);

    gameScene.drawScene(viewBg, viewFg);
end
end
