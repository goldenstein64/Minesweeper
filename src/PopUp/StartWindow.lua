local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Roact: Roact = require(ReplicatedStorage.Roact)

local StartWindow = Roact.Component:extend("StartWindow")

function StartWindow:render()
  return Roact.createFragment({
    UIListLayout = Roact.createElement("UIListLayout", {
      HorizontalAlignment = Enum.HorizontalAlignment.Center,
      VerticalAlignment = Enum.VerticalAlignment.Center,
      FillDirection = Enum.FillDirection.Vertical,
      Padding = UDim.new(0.1, 0)
    }),

    Start = Roact.createElement("TextButton", {
      Size = UDim2.new(0.8, 0, 0.2, 0),

      Text = "Start",

      BackgroundColor3 = Color3.fromRGB(255, 255, 255),

      [Roact.Event.Activated] = function(_rbxButton)
        self.props.startGame()
      end
    }),

    SetSize = Roact.createElement("Frame", {
      Size = UDim2.new(0.8, 0, 0.2, 0)
    }, {
      UIListLayout = Roact.createElement("UIListLayout", {
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        VerticalAlignment = Enum.VerticalAlignment.Center,
        FillDirection = Enum.FillDirection.Horizontal,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0.1, 0)
      }),
      SetX = Roact.createElement("TextBox", {
        Size = UDim2.new(0.2, 0, 0.8, 0),

        Text = "",
        PlaceholderText = self.props.size:map(function(size)
          return size.X
        end),

        BackgroundColor3 = Color3.fromRGB(255, 255, 255),

        LayoutOrder = 1,

        [Roact.Event.FocusLost] = function(rbxTextBox, pressedEnter)
          if not pressedEnter then return end

          local newValue = tonumber(rbxTextBox.Text)
          rbxTextBox.Text = ""
          if not newValue then return end

          newValue = math.round(newValue)
          newValue = math.clamp(newValue, 5, 30)

          self.props.changeSize(self.size:getValue())
        end
      }),
      xLabel = Roact.createElement("TextLabel", {
        Size = UDim2.new(0.1, 0, 1, 0),

        Text = "x",
        TextScaled = true,

        LayoutOrder = 2,

        BackgroundTransparency = 1
      }),
      SetY = Roact.createElement("TextBox", {
        Size = UDim2.new(0.2, 0, 0.8, 0),
        
        Text = "",
        PlaceholderText = self.props.size:map(function(size)
          return size.Y
        end),

        BackgroundColor3 = Color3.fromRGB(255, 255, 255),

        LayoutOrder = 3,

        [Roact.Event.FocusLost] = function(rbxTextBox, pressedEnter)
          if not pressedEnter then return end

          local newValue = tonumber(rbxTextBox.Text)
          rbxTextBox.Text = ""
          if not newValue then return end

          newValue = math.round(newValue)
          newValue = math.clamp(newValue, 5, 30)

          self.props.changeSize(self.size:getValue())
        end
      })
    }),

    SetMineCount = Roact.createElement("Frame", {
      Size = UDim2.new(0.8, 0, 0.2, 0),

      BackgroundColor3 = Color3.fromRGB(255, 255, 255),
    }, {
      Label = Roact.createElement("TextLabel", {
        Size = UDim2.new(0.2, 0, 1, 0),

        Text = "Size:",
        TextScaled = true,

        BackgroundTransparency = 1,
      }),
      SizeBox = Roact.createElement("TextBox", {
        Position = UDim2.new(0.2, 0, 0.5, 0),
        Size = UDim2.new(0.8, 0, 0.8, 0),
        AnchorPoint = Vector2.new(0, 0.5),

        BackgroundColor3 = Color3.fromRGB(255, 255, 255),

        Text = "",
        PlaceholderText = self.props.mineCount,

        [Roact.Event.FocusLost] = function(rbxTextBox, pressedEnter)
          if not pressedEnter then return end

          local newValue = tonumber(rbxTextBox.Text)
          rbxTextBox.Text = ""
          if not newValue then return end

          local maxCount = math.floor(self.props.size:getValue()/2)

          newValue = math.round(newValue)
          newValue = math.clamp(newValue, 1, maxCount)

          self.props.setMineCount(newValue)
        end
      })
    })
  })
end

return StartWindow