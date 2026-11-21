local PuzzleSpawn = game["Environment"]["SlidePuzzle"]["SlidePuzzleSpawn"].Position
local TilePart = game["Hidden"]["Tile"]
local Pieces = {}
local AcceptedMove = false

--top left tile is (0, 0) and at PuzzleSpawn

local function Move(Piece, Empty)
	local pX = Piece.X
	local pY = Piece.Y
	local eX = Empty.X
	local eY = Empty.Y
	Piece.X = eX
	Piece.Y = eY
	Empty.X = pX
	Empty.Y = pY
	Tween:TweenPosition(Piece.Part, PuzzleSpawn + Vector3.New(eY*4.2, 0, -eX*4.2), .1, TweenType.easeInQuad)
	AcceptedMove = true
end

for x = 0, 3 do
	for y = 0, 3 do
		local newPart = TilePart:Clone()
		newPart.Position = PuzzleSpawn + Vector3.New(y*4.2, 0, -x*4.2)
		newPart["Decal"].TextureOffset = Vector2.New(y*.25, (-x-1)*.25)
		local newDict = {
			X = x,
			Y = y,
			Part = newPart
		}
		table.insert(Pieces, newDict)
		newPart.Parent = game["Environment"]
		--newPart.SurfaceGui.TextLabel.Text = #Pieces
		if #Pieces == 16 then
            newPart.Name = "TileButFakeLol"
			newPart.Parent = game["Hidden"]
		end
	end
end

local AvailableNumbers = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15}

for i = 1, 32 do
	local R1 = AvailableNumbers[math.random(1, 15)]
	table.remove(AvailableNumbers, R1)
	local R2 = AvailableNumbers[math.random(1, 14)]
	local P1 = Pieces[R1].Part.Position
	local X1 = Pieces[R1].X
	local Y1 = Pieces[R1].Y
	local P2 = Pieces[R2].Part.Position
	local X2 = Pieces[R2].X
	local Y2 = Pieces[R2].Y
	Pieces[R1].X = X2
	Pieces[R1].Y = Y2
	Pieces[R1].Part.Position = P2
	Pieces[R2].X = X1
	Pieces[R2].Y = Y1
	Pieces[R2].Part.Position = P1
	AvailableNumbers = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15}
end

for i = 1, #Pieces-1 do
	if Pieces[i].Part.Parent then
        spawn(function()
            Pieces[i].Part["Brick"].Clicked:Connect(function()
                for i2 = 1, #Pieces do
                    if Pieces[i].X == Pieces[i2].X-1 or Pieces[i].X == Pieces[i2].X+1 then
                        if Pieces[i].Y == Pieces[i2].Y and Pieces[i2].Part.Parent == game["Hidden"] then
                            Move(Pieces[i], Pieces[i2])
                        end
                    end
                    if Pieces[i].Y == Pieces[i2].Y-1 or Pieces[i].Y == Pieces[i2].Y+1 then
                        if Pieces[i].X == Pieces[i2].X and Pieces[i2].Part.Parent == game["Hidden"] then
                            Move(Pieces[i], Pieces[i2])
                        end
                    end
					if AcceptedMove then
						AcceptedMove = false
						for i3 = 1, #Pieces do
							if Pieces[i3].X == math.floor(i3/4) and Pieces[i3].Y == (i3-1) % 3 then
								print(i3)
							end
						end
					end
                end
		    end)
        end)
	end
end
