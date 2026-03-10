%% --Start Screen--

function choice = gameStartFunction(spriteH, spriteW, zoomF)
startScene = simpleGameEngine('retro_pack.png', spriteH, spriteW, zoomF);

% Size of Screen
menuRows = 12;
menuCols = 20;
menuBg = ones(menuRows,menuCols);    % Black Screen

% Logic 
menuBg(3, 6)  = 991;
menuBg(3, 7)  = 1013;
menuBg(3, 8)  = 986;
menuBg(3, 9)  = 988;
menuBg(3,10)  = 982;

% Flow
menuBg(3,13)  = 985;
menuBg(3,14)  = 991;
menuBg(3,15)  = 1013;
menuBg(3,16)  = 1021;

menuBg(3,11)  = 324;
menuBg(3,12)  = 325;

% START 
menuBg(6, 9) = 1017;
menuBg(6, 10) = 1018;
menuBg(6, 11) = 980;
menuBg(6, 12) = 1016;
menuBg(6, 13) = 1018;

% QUIT
menuBg(8, 9) = 1015;
menuBg(8, 10) = 1019;  
menuBg(8, 11) = 988;
menuBg(8, 12) = 1018;

% Player
menuBg(10,11) = 28;

% Recolors Sprites Green
for i = 1:length(startScene.sprites)
    sprite = startScene.sprites{i};
    sprite(:,:,1) = 0;   
    sprite(:,:,2) = 255; 
    sprite(:,:,3) = 0;   
    startScene.sprites{i} = uint8(sprite);
end

startScene.drawScene(menuBg);

title('LOGIC FLOW  -  S: Start   Q: Quit');

%% Key input logic
choice = '';

% While a choice is not selected
while isempty(choice)
    % Get key input
    key = startScene.getKeyboardInput();
    % Sets variable "choice" based on user input
    if (key == 's')
        choice = "start";
    elseif strcmp(key, 'q') || strcmp(key,'escape')
        choice = "quit";
    end
end

close;

end
