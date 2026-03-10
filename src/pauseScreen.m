%% Pause Screen
function pauseScreen(gameScene, viewBg, viewFg)

    pauseFg = viewFg;
    
    % Pause lettering indecies
    row = 5;        
    cStart = 3; 

    title('PAUSED - Press S to Resume');

    pauseFg(row, cStart)     = 1014;   % P
    pauseFg(row, cStart + 1) = 980;    % A
    pauseFg(row, cStart + 2) = 1019;   % U
    pauseFg(row, cStart + 3) = 1017;   % S
    pauseFg(row, cStart + 4) = 984;    % E
    pauseFg(row, cStart + 5) = 983;    % D
    pauseFg(row, cStart + 6) = 439;    % =

    pinkIDs = [1014, 980, 1019, 1017, 984, 983, 439];

    % Save a copy of sprites so we can restore
    

    % Tints All Fg sprites pink
    for id = pinkIDs
        spriteImg = gameScene.sprites{id};
        spriteImg(:,:,1) = 255;
        spriteImg(:,:,2) = 0;
        spriteImg(:,:,3) = 255; % magenta so it pops on green
        gameScene.sprites{id} = uint8(spriteImg);
    end


    gameScene.drawScene(viewBg, pauseFg);

    %% Key input logic
    key = '';

    % While key input is not 's'
    while ~strcmp(key, 's')
        % Get key input
        key = gameScene.getKeyboardInput();
    end

    % Restore sprites and redraw original screen
    
    gameScene.drawScene(viewBg, viewFg);
    title('');
end
