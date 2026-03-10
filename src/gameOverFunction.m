%% --GAME OVER SCREEN --

function choice = gameOverFunction(spriteH, spriteW, zoomF)
endScene = simpleGameEngine('retro_pack.png', spriteH, spriteW, zoomF);

% Size of Screen
endRows = 10;
endCols = 14;
endBg = ones(endRows, endCols);   % Black Screen

% Game over tile IDs
endBg(4,3)  = 986;
endBg(4,4)  = 980;
endBg(4,5)  = 992;
endBg(4,6)  = 984;
endBg(4,7)  = 729;
endBg(4,8)  = 729;
endBg(4,9)  = 1013;
endBg(4,10) = 1020;
endBg(4,11) = 984;
endBg(4,12) = 1016;

endBg(6,7)  = 336;
endBg(6,8)  = 336;

% R = Restart
endBg(8,3) = 414;
endBg(8,4) = 1016;
endBg(8,5) = 439;
endBg(8,6) = 1016;
endBg(8,7) = 984;
endBg(8,8) = 1017;
endBg(8,9) = 1018;
endBg(8,10) = 980;
endBg(8,11) = 1016;
endBg(8,12) = 1018;

% Tint all sprites red
for i = 1:length(endScene.sprites)
    spriteImg = endScene.sprites{i};
    spriteImg(:,:,1) = 255;
    spriteImg(:,:,2) = 0;
    spriteImg(:,:,3) = 0;
    endScene.sprites{i} = uint8(spriteImg);
end

endScene.drawScene(endBg);

title('GAME OVER – Press R to Restart or Q to Quit');

%% Key input logic
choice = '';

% While a choice is not selected
while isempty(choice)
    % Get key input
    key = endScene.getKeyboardInput();
    % Sets variable "choice" based on user input
    if strcmp(key, 'r')
        choice = "restart";
    elseif strcmp(key, 'q') || strcmp(key, 'escape')
        choice = "quit";
    end
end

close;

end
