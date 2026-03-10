%% --GAME WIN SCREEN FUNCTION--

function choice = gameWinFunction(spriteH, spriteW, zoomF)
winScene = simpleGameEngine('retro_pack.png', spriteH, spriteW, zoomF);

% Size of Screen
winRows = 10;
winCols = 14;
winBg = ones(winRows, winCols);   % Black Screen

% WIN
winBg(4,6)  = 1021;   
winBg(4,7)  = 988;  
winBg(4,8)  = 1012;   
winBg(4,9)  = 152;   

% R = Restart 
winBg(8,3) = 414;
winBg(8,4) = 1016;
winBg(8,5) = 439;
winBg(8,6) = 1016;
winBg(8,7) = 984;
winBg(8,8) = 1017;
winBg(8,9) = 1018;
winBg(8,10) = 980;
winBg(8,11) = 1016;
winBg(8,12) = 1018;

% Tint all sprites Aqua
for i = 1:length(winScene.sprites)
    spriteImg = winScene.sprites{i};
    spriteImg(:,:,1) = 0;
    spriteImg(:,:,2) = 255;
    spriteImg(:,:,3) = 255;
    winScene.sprites{i} = uint8(spriteImg);
end

winScene.drawScene(winBg);

title('YOU WIN – Press R to Restart or Q to Quit');

%% Key input logic
choice = '';

% While a choice is not selected
while isempty(choice)
    % Get key input
    key = winScene.getKeyboardInput();
    % Sets variable "choice" based on user input
    if strcmp(key, 'r')
        choice = "restart";
    elseif strcmp(key, 'q') || strcmp(key, 'escape')
        choice = "quit";
    end
end

close;

end
