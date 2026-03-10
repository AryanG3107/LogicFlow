function [viewBg, viewFg] = buildFrame( ...
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
    arrowUpTileId, arrowDownTileId, arrowLeftTileId, arrowRightTileId)

    % Camera bottom/right based on top/left and view size
    camBottomWorldRow = camTopWorldRow  + viewRows - 1;
    camRightWorldCol  = camLeftWorldCol + viewCols - 1;

    % Background slice
    viewBg = worldBg(camTopWorldRow:camBottomWorldRow,camLeftWorldCol:camRightWorldCol);

    % Player position on screen
    playerRowScreen = playerRowWorld - camTopWorldRow + 1;
    playerColScreen = playerColWorld - camLeftWorldCol + 1;

    % Clamp screen coordinates
    playerRowScreen = max(1, min(viewRows, playerRowScreen));
    playerColScreen = max(1, min(viewCols, playerColScreen));

    % Foreground starts as background
    viewFg = viewBg;
    viewFg(playerRowScreen, playerColScreen) = playerTileId;

    % Hearts
    col1 = viewCols - 2;
    col2 = viewCols - 1;
    col3 = viewCols;

    if lives >= 1
        viewFg(1,col1) = fullHeart;
    else
        viewFg(1,col1) = brokenHeart;
    end
    if lives >= 2
        viewFg(1,col2) = fullHeart;
    else
        viewFg(1,col2) = brokenHeart;
    end
    if lives >= 3
        viewFg(1,col3) = fullHeart;
    else
        viewFg(1,col3) = brokenHeart;
    end

    % Keys dropped on ground 
    if andKey == 1
        if andCenterRow >= camTopWorldRow && andCenterRow <= camBottomWorldRow && ...
           andCenterCol >= camLeftWorldCol && andCenterCol <= camRightWorldCol
            rScr = andCenterRow - camTopWorldRow + 1;
            cScr = andCenterCol - camLeftWorldCol + 1;
            viewFg(rScr,cScr) = keyTileId;
        end
    end
    if orKey == 1
        if orCenterRow >= camTopWorldRow && orCenterRow <= camBottomWorldRow && ...
           orCenterCol >= camLeftWorldCol && orCenterCol <= camRightWorldCol
            rScr = orCenterRow - camTopWorldRow + 1;
            cScr = orCenterCol - camLeftWorldCol + 1;
            viewFg(rScr,cScr) = keyTileId;
        end
    end
    if xorKey == 1
        if xorCenterRow >= camTopWorldRow && xorCenterRow <= camBottomWorldRow && ...
           xorCenterCol >= camLeftWorldCol && xorCenterCol <= camRightWorldCol
            rScr = xorCenterRow - camTopWorldRow + 1;
            cScr = xorCenterCol - camLeftWorldCol + 1;
            viewFg(rScr,cScr) = keyTileId;
        end
    end
    if notKey == 1
        if notCenterRow >= camTopWorldRow && notCenterRow <= camBottomWorldRow && ...
           notCenterCol >= camLeftWorldCol && notCenterCol <= camRightWorldCol
            rScr = notCenterRow - camTopWorldRow + 1;
            cScr = notCenterCol - camLeftWorldCol + 1;
            viewFg(rScr,cScr) = keyTileId;
        end
    end

    % Keys in inventory (State 2)
    if andKey == 2
        viewFg(viewRows,1) = keyTileId;
    end
    if orKey == 2
        viewFg(viewRows,2) = keyTileId;
    end
    if xorKey == 2
        viewFg(viewRows,3) = keyTileId;
    end
    if notKey == 2
        viewFg(viewRows,4) = keyTileId;
    end

    % Direction arrows toward door
    if doorRow < playerRowWorld
        viewFg(2, centerColScreen) = arrowUpTileId;
    elseif doorRow > playerRowWorld
        viewFg(viewRows, centerColScreen) = arrowDownTileId;
    end

    if doorCol < playerColWorld
        viewFg(centerRowScreen, 2) = arrowLeftTileId;
    elseif doorCol > playerColWorld
        viewFg(centerRowScreen, viewCols-1) = arrowRightTileId;
    end
end
