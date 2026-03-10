%% Function to show a message as the title
function showMessage(gameScene, messageText)

title(messageText);

%% Key input logic
key = '';

% While enter is not pressed
while ~strcmp(key, 'return')  
    % Get Key input
    key = gameScene.getKeyboardInput();
end

% Reset title
title('');

end
