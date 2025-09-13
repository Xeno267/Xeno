# Sekai Hub Ink Game Script
# Sekai Hub | Full Mobile + PC Optimized

Sekai Hub нь Roblox-д зориулсан **mobile & PC-д optimized** player script юм. Энэхүү script нь таны тоглох туршлагыг сайжруулахад тусална.

## Онцлог
- **Player Features**
  - Infinite Jump
  - WalkSpeed / JumpPower adjust
  - Fly + Noclip
- **Teleports**
  - Урьдчилан тогтоосон газрын teleport
- **Visuals / ESP**
  - Player ESP (Rainbow, Custom, Static)
  - Distance display

## Суурилуулалт
1. Roblox Studio эсвэл Roblox тоглоомоо нээнэ.
2. `Sekai Hub` script-ийг copy/paste хийнэ.
3. GUI-ийг `K` товч дарж нээнэ.

## Ашиглах заавар
- **Infinite Jump**: Jump товч дарахад тасралтгүй үсрэнэ.
- **WalkSpeed**: Slider ашиглан хурдыг тохируулна.
- **Fly**: Fly товч дараад **Space** дарж дээш, **Shift** дарж доош ниснэ.
- **Noclip**: Биетээрээ шоо/хавтанг давж өнгөрнө.
- **Teleports**: Тохирсон газрын нэр дээр дарж шууд очно.
- **ESP**: Player-уудын толгой дээр нэр болон зай харагдана.

## Жишээ
```lua
-- Infinite Jump Example
local infiniteJump=false
game:GetService("UserInputService").JumpRequest:Connect(function()
    local hum = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if infiniteJump and hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
end)
