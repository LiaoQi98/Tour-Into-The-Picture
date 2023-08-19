classdef gui < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                       matlab.ui.Figure
        GridLayout                     matlab.ui.container.GridLayout
        LeftPanel                      matlab.ui.container.Panel
        commentTextAreaLabel           matlab.ui.control.Label
        commentTextArea                matlab.ui.control.TextArea
        authorLiMingcongLiaoQiLyuRunanYuboMinXiaoLiLabel  matlab.ui.control.Label
        selectonephotoButtonGroup      matlab.ui.container.ButtonGroup
        yourimageButton                matlab.ui.control.RadioButton
        picture6uhrenturmButton        matlab.ui.control.RadioButton
        picture5simpleroomButton       matlab.ui.control.RadioButton
        picture4shoppingmallButton     matlab.ui.control.RadioButton
        picture3sagradafamiliaButton   matlab.ui.control.RadioButton
        picture2oilpaintingButton      matlab.ui.control.RadioButton
        picture1metrostationButton     matlab.ui.control.RadioButton
        CenterPanel                    matlab.ui.container.Panel
        Image                          matlab.ui.control.Image
        Label_7                        matlab.ui.control.Label
        TripintothepictureLabel        matlab.ui.control.Label
        RightPanel                     matlab.ui.container.Panel
        yesButton                      matlab.ui.control.Button
        goButton                       matlab.ui.control.Button
        startButton_2                  matlab.ui.control.Button
        startButton                    matlab.ui.control.Button
        noButton                       matlab.ui.control.Button
        Step1pleasechoose1picturefromtheboxontheleftsideLabel  matlab.ui.control.Label
        Step4nowyoucanchangetheangleofthecameraLabel  matlab.ui.control.Label
        Step3pleasechoosethevanishingpointLabel  matlab.ui.control.Label
        Step2pleasechoose2pointsLabel  matlab.ui.control.Label
        InstructionsLabel              matlab.ui.control.Label
    end

    % Properties that correspond to apps with auto-reflow
    properties (Access = private)
        onePanelWidth = 576;
        twoPanelWidth = 768;
    end


    

    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app)
            filep = mfilename('fullpath');
            [pathstr,namestr]=fileparts(filep);
            currentFolder = pathstr;
            if currentFolder(1,end-3) == '\'
                nextFolder = '\lib\';
            else
                nextFolder = '/lib/';
            end
            im = imread([currentFolder, nextFolder,'metro-station.png']);
            app.Image.ImageSource = im;
        end

        % Selection changed function: selectonephotoButtonGroup
        function selectonephotoButtonGroupSelectionChanged(app, event)

            selectedButton = app.selectonephotoButtonGroup.SelectedObject;
            app.commentTextArea.Value = "";
            app.Step2pleasechoose2pointsLabel.Visible = "off";
            app.startButton.Visible = "off";
            app.Step3pleasechoosethevanishingpointLabel.Visible = "off";
            app.startButton_2.Visible = "off";
            app.Step4nowyoucanchangetheangleofthecameraLabel.Visible = "off";
            app.goButton.Visible = "off";

            filep = mfilename('fullpath');
            [pathstr,namestr]=fileparts(filep);
            currentFolder = pathstr;

            if currentFolder(1,end-3) == '\'
                nextFolder = '\lib\';
            else
                nextFolder = '/lib/';
            end
            switch selectedButton.Text
                case "picture1: metro station"
                    im = imread([currentFolder, nextFolder,'metro-station.png']);
                    app.Image.ImageSource = im;
                case "picture2: oil painting"
                    im = imread([currentFolder, nextFolder,'oil-painting.png']);
                    app.Image.ImageSource = im;
                case "picture3: sagrada familia"
                    im = imread([currentFolder, nextFolder,'sagrada_familia.png']);
                    app.Image.ImageSource = im;
                case "picture4: shopping mall"
                    im = imread([currentFolder, nextFolder,'shopping-mall.png']);
                    app.Image.ImageSource = im;
                case "picture5: simple room"
                    im = imread([currentFolder, nextFolder,'simple-room.png']);
                    app.Image.ImageSource = im;
                case "picture6: uhren turm"
                    im = imread([currentFolder, nextFolder,'uhren-turm.jpg']);
                    app.Image.ImageSource = im;
                case "your image"

                    cd([currentFolder, nextFolder]); 

                    [imfile,impath] = uigetfile({'*.jpg; *.png;*.ppm','All Image files'},'Choose the Image');
                    if impath == 0
                        app.commentTextArea.Value = "You haven't choose an image! Please switch to another image and switch back to choose your image!";
                        im = imread("metro-station.png");
                        app.Image.ImageSource = im;
                    else
                        im = imread([impath,imfile]);
                        app.Image.ImageSource = im;
                    end
                    cd ..
            end

        end

        % Button pushed function: yesButton
        function yesButtonPushed(app, event)
            [foreground,im2] = get_foreground_new(im2double(app.Image.ImageSource));
            app.commentTextArea.Value = "done!";
            assignin("base","foreground",foreground);
            assignin("base","im2",im2)
            app.Step2pleasechoose2pointsLabel.Visible = "on";
            app.startButton.Visible = "on";
        end

        % Button pushed function: noButton
        function noButtonPushed(app, event)
            app.commentTextArea.Value = "";
            try
                [foreground,im2] = get_foreground(im2double(app.Image.ImageSource));
                app.commentTextArea.Value = "";
                assignin("base","foreground",foreground);      
                assignin("base","im2",im2); 
                app.Step2pleasechoose2pointsLabel.Visible = "on";
                app.startButton.Visible = "on";
            catch error
                app.commentTextArea.Value = "You haven't chosen any points! Please do this step again or switch to the yes button!"
            end
              
        end

        % Button pushed function: startButton
        function startButtonPushed(app, event)
            app.commentTextArea.Value = "";
            im2 = evalin("base","im2");
            try
                app.commentTextArea.Value = "";
                [irx, iry] = gui_4points(im2);
                assignin("base","irx",irx);
                assignin("base","iry",iry);
                app.Step3pleasechoosethevanishingpointLabel.Visible = "on";
                app.startButton_2.Visible = "on";
            catch error
                app.commentTextArea.Value = "You haven't chosen the points! Please do this step again!";
            end

        end

        % Button pushed function: startButton_2
        function startButton_2Pushed(app, event)
            irx = evalin("base","irx");
            iry = evalin("base","iry");
            im2 = evalin("base","im2");
            app.commentTextArea.Value = "";
            try
                [cpOutx, cpOuty, vp_x,vp_y,cpx,cpy] = gui_vanishing_point(im2,irx,iry);
                app.commentTextArea.Value = "";
                assignin("base","cpOutx",cpOutx);
                assignin("base","cpOuty",cpOuty);
                assignin("base","vp_x",vp_x);
                assignin("base","vp_y",vp_y);
                assignin("base","cpx",cpx);
                assignin("base","cpy",cpy);
                app.Step4nowyoucanchangetheangleofthecameraLabel.Visible = "on";
                app.goButton.Visible = "on";
            catch error
                app.commentTextArea.Value = "You haven't choose the vanishing point! Please do this step again!"
            end
            
        end

        % Button pushed function: goButton
        function goButtonPushed(app, event)
            app.commentTextArea.Value = "";
            irx = evalin("base","irx");
            iry = evalin("base","iry");
            cpOutx = evalin("base","cpOutx");
            cpOuty = evalin("base","cpOuty");
            vp_x = evalin("base","vp_x");
            vp_y = evalin("base","vp_y");
            cpx = evalin("base","cpx");
            cpy = evalin("base","cpy");
            foreground = evalin("base","foreground");
            im2 = evalin("base","im2");
            try
                face_genrator(app.Image.ImageSource,vp_x,vp_y,irx,iry,foreground,im2,cpOutx,cpOuty,cpx,cpy)
                app.commentTextArea.Value = "";
            catch error
                app.commentTextArea.Value = "There is an error!";
            end
        end

        % Changes arrangement of the app based on UIFigure width
        function updateAppLayout(app, event)
            currentFigureWidth = app.UIFigure.Position(3);
            if(currentFigureWidth <= app.onePanelWidth)
                % Change to a 3x1 grid
                app.GridLayout.RowHeight = {480, 480, 480};
                app.GridLayout.ColumnWidth = {'1x'};
                app.CenterPanel.Layout.Row = 1;
                app.CenterPanel.Layout.Column = 1;
                app.LeftPanel.Layout.Row = 2;
                app.LeftPanel.Layout.Column = 1;
                app.RightPanel.Layout.Row = 3;
                app.RightPanel.Layout.Column = 1;
            elseif (currentFigureWidth > app.onePanelWidth && currentFigureWidth <= app.twoPanelWidth)
                % Change to a 2x2 grid
                app.GridLayout.RowHeight = {480, 480};
                app.GridLayout.ColumnWidth = {'1x', '1x'};
                app.CenterPanel.Layout.Row = 1;
                app.CenterPanel.Layout.Column = [1,2];
                app.LeftPanel.Layout.Row = 2;
                app.LeftPanel.Layout.Column = 1;
                app.RightPanel.Layout.Row = 2;
                app.RightPanel.Layout.Column = 2;
            else
                % Change to a 1x3 grid
                app.GridLayout.RowHeight = {'1x'};
                app.GridLayout.ColumnWidth = {201, '1x', 220};
                app.LeftPanel.Layout.Row = 1;
                app.LeftPanel.Layout.Column = 1;
                app.CenterPanel.Layout.Row = 1;
                app.CenterPanel.Layout.Column = 2;
                app.RightPanel.Layout.Row = 1;
                app.RightPanel.Layout.Column = 3;
            end
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.AutoResizeChildren = 'off';
            app.UIFigure.Position = [100 100 860 480];
            app.UIFigure.Name = 'MATLAB App';
            app.UIFigure.SizeChangedFcn = createCallbackFcn(app, @updateAppLayout, true);

            % Create GridLayout
            app.GridLayout = uigridlayout(app.UIFigure);
            app.GridLayout.ColumnWidth = {201, '1x', 220};
            app.GridLayout.RowHeight = {'1x'};
            app.GridLayout.ColumnSpacing = 0;
            app.GridLayout.RowSpacing = 0;
            app.GridLayout.Padding = [0 0 0 0];
            app.GridLayout.Scrollable = 'on';

            % Create LeftPanel
            app.LeftPanel = uipanel(app.GridLayout);
            app.LeftPanel.ForegroundColor = [0.949 0.9569 0.9608];
            app.LeftPanel.BackgroundColor = [1 1 1];
            app.LeftPanel.Layout.Row = 1;
            app.LeftPanel.Layout.Column = 1;

            % Create selectonephotoButtonGroup
            app.selectonephotoButtonGroup = uibuttongroup(app.LeftPanel);
            app.selectonephotoButtonGroup.SelectionChangedFcn = createCallbackFcn(app, @selectonephotoButtonGroupSelectionChanged, true);
            app.selectonephotoButtonGroup.ForegroundColor = [0 0 1];
            app.selectonephotoButtonGroup.TitlePosition = 'centertop';
            app.selectonephotoButtonGroup.Title = 'select one photo';
            app.selectonephotoButtonGroup.BackgroundColor = [0.902 0.9412 1];
            app.selectonephotoButtonGroup.FontName = 'Arial';
            app.selectonephotoButtonGroup.FontWeight = 'bold';
            app.selectonephotoButtonGroup.FontSize = 18;
            app.selectonephotoButtonGroup.Position = [12 157 173 292];

            % Create picture1metrostationButton
            app.picture1metrostationButton = uiradiobutton(app.selectonephotoButtonGroup);
            app.picture1metrostationButton.Text = 'picture1: metro station';
            app.picture1metrostationButton.FontName = 'Arial';
            app.picture1metrostationButton.FontSize = 13;
            app.picture1metrostationButton.Position = [12 228 151 22];
            app.picture1metrostationButton.Value = true;

            % Create picture2oilpaintingButton
            app.picture2oilpaintingButton = uiradiobutton(app.selectonephotoButtonGroup);
            app.picture2oilpaintingButton.Text = 'picture2: oil painting';
            app.picture2oilpaintingButton.FontName = 'Arial';
            app.picture2oilpaintingButton.FontSize = 13;
            app.picture2oilpaintingButton.Position = [12 190 138 22];

            % Create picture3sagradafamiliaButton
            app.picture3sagradafamiliaButton = uiradiobutton(app.selectonephotoButtonGroup);
            app.picture3sagradafamiliaButton.Text = 'picture3: sagrada familia';
            app.picture3sagradafamiliaButton.FontName = 'Arial';
            app.picture3sagradafamiliaButton.FontSize = 13;
            app.picture3sagradafamiliaButton.Position = [12 155 164 22];

            % Create picture4shoppingmallButton
            app.picture4shoppingmallButton = uiradiobutton(app.selectonephotoButtonGroup);
            app.picture4shoppingmallButton.Text = 'picture4: shopping mall';
            app.picture4shoppingmallButton.FontName = 'Arial';
            app.picture4shoppingmallButton.FontSize = 13;
            app.picture4shoppingmallButton.Position = [12 119 156 22];

            % Create picture5simpleroomButton
            app.picture5simpleroomButton = uiradiobutton(app.selectonephotoButtonGroup);
            app.picture5simpleroomButton.Text = 'picture5: simple room';
            app.picture5simpleroomButton.FontName = 'Arial';
            app.picture5simpleroomButton.FontSize = 13;
            app.picture5simpleroomButton.Position = [12 83 146 22];

            % Create picture6uhrenturmButton
            app.picture6uhrenturmButton = uiradiobutton(app.selectonephotoButtonGroup);
            app.picture6uhrenturmButton.Text = 'picture6: uhren turm';
            app.picture6uhrenturmButton.FontName = 'Arial';
            app.picture6uhrenturmButton.FontSize = 13;
            app.picture6uhrenturmButton.Position = [12 48 138 22];

            % Create yourimageButton
            app.yourimageButton = uiradiobutton(app.selectonephotoButtonGroup);
            app.yourimageButton.Text = 'your image';
            app.yourimageButton.FontName = 'Arial';
            app.yourimageButton.FontSize = 13;
            app.yourimageButton.Position = [12 15 86 22];

            % Create authorLiMingcongLiaoQiLyuRunanYuboMinXiaoLiLabel
            app.authorLiMingcongLiaoQiLyuRunanYuboMinXiaoLiLabel = uilabel(app.LeftPanel);
            app.authorLiMingcongLiaoQiLyuRunanYuboMinXiaoLiLabel.HorizontalAlignment = 'center';
            app.authorLiMingcongLiaoQiLyuRunanYuboMinXiaoLiLabel.FontName = 'Baoli TC';
            app.authorLiMingcongLiaoQiLyuRunanYuboMinXiaoLiLabel.FontSize = 1;
            app.authorLiMingcongLiaoQiLyuRunanYuboMinXiaoLiLabel.FontColor = [0.5686 0.549 0.549];
            app.authorLiMingcongLiaoQiLyuRunanYuboMinXiaoLiLabel.Position = [18 20 167 28];
            app.authorLiMingcongLiaoQiLyuRunanYuboMinXiaoLiLabel.Text = {'@author:Li, Mingcong  Liao, Qi '; 'Lyu, Runan  Yubo, Min  Xiao, Li'};

            % Create commentTextArea
            app.commentTextArea = uitextarea(app.LeftPanel);
            app.commentTextArea.Position = [18 61 163 64];

            % Create commentTextAreaLabel
            app.commentTextAreaLabel = uilabel(app.LeftPanel);
            app.commentTextAreaLabel.HorizontalAlignment = 'right';
            app.commentTextAreaLabel.Position = [17 124 60 22];
            app.commentTextAreaLabel.Text = 'comment:';

            % Create CenterPanel
            app.CenterPanel = uipanel(app.GridLayout);
            app.CenterPanel.BackgroundColor = [0.902 0.9412 1];
            app.CenterPanel.Layout.Row = 1;
            app.CenterPanel.Layout.Column = 2;

            % Create TripintothepictureLabel
            app.TripintothepictureLabel = uilabel(app.CenterPanel);
            app.TripintothepictureLabel.FontName = 'Arial';
            app.TripintothepictureLabel.FontSize = 25;
            app.TripintothepictureLabel.FontWeight = 'bold';
            app.TripintothepictureLabel.Position = [103 436 248 33];
            app.TripintothepictureLabel.Text = 'Trip into the picture ';

            % Create Label_7
            app.Label_7 = uilabel(app.CenterPanel);
            app.Label_7.FontWeight = 'bold';
            app.Label_7.Position = [29 415 397 22];
            app.Label_7.Text = '    ----------------------------------------------------------------------------';

            % Create Image
            app.Image = uiimage(app.CenterPanel);
            app.Image.Position = [9 47 421 327];

            % Create RightPanel
            app.RightPanel = uipanel(app.GridLayout);
            app.RightPanel.BackgroundColor = [1 1 1];
            app.RightPanel.Layout.Row = 1;
            app.RightPanel.Layout.Column = 3;

            % Create InstructionsLabel
            app.InstructionsLabel = uilabel(app.RightPanel);
            app.InstructionsLabel.BackgroundColor = [0.902 0.9412 1];
            app.InstructionsLabel.HorizontalAlignment = 'center';
            app.InstructionsLabel.FontName = 'Arial';
            app.InstructionsLabel.FontSize = 18;
            app.InstructionsLabel.FontWeight = 'bold';
            app.InstructionsLabel.FontColor = [0 0 1];
            app.InstructionsLabel.Position = [52 425 116 24];
            app.InstructionsLabel.Text = 'Instructions';

            % Create Step2pleasechoose2pointsLabel
            app.Step2pleasechoose2pointsLabel = uilabel(app.RightPanel);
            app.Step2pleasechoose2pointsLabel.BackgroundColor = [1 1 1];
            app.Step2pleasechoose2pointsLabel.FontName = 'Arial';
            app.Step2pleasechoose2pointsLabel.FontSize = 14;
            app.Step2pleasechoose2pointsLabel.FontWeight = 'bold';
            app.Step2pleasechoose2pointsLabel.Visible = 'off';
            app.Step2pleasechoose2pointsLabel.Position = [6 205 207 22];
            app.Step2pleasechoose2pointsLabel.Text = {'Step2: please choose 2 points'; ''};

            % Create Step3pleasechoosethevanishingpointLabel
            app.Step3pleasechoosethevanishingpointLabel = uilabel(app.RightPanel);
            app.Step3pleasechoosethevanishingpointLabel.FontName = 'Arial';
            app.Step3pleasechoosethevanishingpointLabel.FontSize = 14;
            app.Step3pleasechoosethevanishingpointLabel.FontWeight = 'bold';
            app.Step3pleasechoosethevanishingpointLabel.Visible = 'off';
            app.Step3pleasechoosethevanishingpointLabel.Position = [6 124 211 34];
            app.Step3pleasechoosethevanishingpointLabel.Text = {'Step 3: please choose the van-'; 'ishing point'};

            % Create Step4nowyoucanchangetheangleofthecameraLabel
            app.Step4nowyoucanchangetheangleofthecameraLabel = uilabel(app.RightPanel);
            app.Step4nowyoucanchangetheangleofthecameraLabel.FontName = 'Arial';
            app.Step4nowyoucanchangetheangleofthecameraLabel.FontSize = 14;
            app.Step4nowyoucanchangetheangleofthecameraLabel.FontWeight = 'bold';
            app.Step4nowyoucanchangetheangleofthecameraLabel.Visible = 'off';
            app.Step4nowyoucanchangetheangleofthecameraLabel.Position = [6 47 198 36];
            app.Step4nowyoucanchangetheangleofthecameraLabel.Text = {'Step 4: now you can change '; 'the angle of the camera'};

            % Create Step1pleasechoose1picturefromtheboxontheleftsideLabel
            app.Step1pleasechoose1picturefromtheboxontheleftsideLabel = uilabel(app.RightPanel);
            app.Step1pleasechoose1picturefromtheboxontheleftsideLabel.BackgroundColor = [1 1 1];
            app.Step1pleasechoose1picturefromtheboxontheleftsideLabel.FontName = 'Arial';
            app.Step1pleasechoose1picturefromtheboxontheleftsideLabel.FontSize = 14;
            app.Step1pleasechoose1picturefromtheboxontheleftsideLabel.FontWeight = 'bold';
            app.Step1pleasechoose1picturefromtheboxontheleftsideLabel.Position = [3 271 235 136];
            app.Step1pleasechoose1picturefromtheboxontheleftsideLabel.Text = {'Step1: please choose 1 pictu-'; 're from the box on the left side'; ''; 'Do you want to skip the step of'; 'cutting out the foreground?'; ''; 'If you press yes, you need to '; 'wait for a few seconds'; ''};

            % Create noButton
            app.noButton = uibutton(app.RightPanel, 'push');
            app.noButton.ButtonPushedFcn = createCallbackFcn(app, @noButtonPushed, true);
            app.noButton.Position = [137 240 68 22];
            app.noButton.Text = 'no!';

            % Create startButton
            app.startButton = uibutton(app.RightPanel, 'push');
            app.startButton.ButtonPushedFcn = createCallbackFcn(app, @startButtonPushed, true);
            app.startButton.Visible = 'off';
            app.startButton.Position = [137 172 68 22];
            app.startButton.Text = 'start!';

            % Create startButton_2
            app.startButton_2 = uibutton(app.RightPanel, 'push');
            app.startButton_2.ButtonPushedFcn = createCallbackFcn(app, @startButton_2Pushed, true);
            app.startButton_2.Visible = 'off';
            app.startButton_2.Position = [137 93 68 22];
            app.startButton_2.Text = 'start!';

            % Create goButton
            app.goButton = uibutton(app.RightPanel, 'push');
            app.goButton.ButtonPushedFcn = createCallbackFcn(app, @goButtonPushed, true);
            app.goButton.Visible = 'off';
            app.goButton.Position = [137 23 68 22];
            app.goButton.Text = 'go!';

            % Create yesButton
            app.yesButton = uibutton(app.RightPanel, 'push');
            app.yesButton.ButtonPushedFcn = createCallbackFcn(app, @yesButtonPushed, true);
            app.yesButton.Position = [6 240 68 22];
            app.yesButton.Text = 'yes!';

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = gui

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            % Execute the startup function
            runStartupFcn(app, @startupFcn)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end
end