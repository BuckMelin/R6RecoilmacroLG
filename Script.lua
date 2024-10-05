-- /////////// 后坐力控制设置  /////////

-- //// SMG == 低后坐力且快速连射的枪支 
-- //// AR == 高后坐力且慢速连射的枪支

-- //// 后坐力是通过移动的像素数（SMGRecoilMouseMoveAmount）处理的， 
-- //// 以及每次移动之间的延迟（SMGRapidFireDelayBetweenShots）

-- //// 后坐力通过开启 Numlock 启用，控制设置中可进行更改，鼠标的第 4 个按钮是快速连射。通过右键启用。

-- //// 更改以下信息 --
-- //// 当 {SMGorARtoggle/默认 Scrolllock} 开启时，使用 SMG 设置
-- //// 当 {SMGorARtoggle/默认 Scrolllock} 关闭时，使用 AR 设置

-- //////////////////////////////////////// 后坐力补偿设置 -- ////////////////////////////////////////////////

SMGRecoilMouseMoveAmount    = 8  --           // 鼠标向下移动的距离用于补偿后坐力，不能使用小数
ARRecoilMouseMoveAmount     = 10 --           // 更大值 == 鼠标向下拉得更多。1 次鼠标移动 == 100 毫秒延迟

SMGMouseMoveDelaySleep      = 8  --           // 每次鼠标移动的延迟（毫秒）
ARMouseMoveDelaySleep       = 8  --           // 延迟越多，鼠标下拉越少。1 次鼠标移动 == 100 毫秒延迟

HorizontalRecoilModifier    = 0  --           // -1 表示在射击时稍微向左拉鼠标以进行补偿
--                                            // 如果后坐力向右移动，尝试设为 1。0 == 不进行左右移动

-- //////////////////////////////////////// 快速连射设置 -- ////////////////////////////////////////////////

SMGRapidFireDelayBetweenShots   = 80 --      // 每次 SMG/AR/后坐力移动鼠标之间的延迟（大致）毫秒数
ARRapidFireDelayBetweenShots    = 110 --     // 使鼠标每次移动的延迟

SMGRapidFireRecoilCompensation  = 16 --      // 每次快速连射之间，鼠标将向下拉
ARRapidFireRecoilCompensation   = 9  --      // 更大值 == 每次连射之间向下拉得更多

RapidFireMousePressDurationSMG  = 9  --      // 快速连射时左键按住的时间（毫秒）
RapidFireMousePressDurationAR   = 9  --      // 以毫秒为单位。1 == 1 次点击

-- ///////////////////////////////////////////////////////////////////////////////////////////////////// 
-- //////////////////////////////////////// 控制设置 -- ////////////////////////////////////////////////
-- ///////////////////////////////////////////////////////////////////////////////////////////////////// 

-- //// 绑定的选项包括 "scrolllock" "capslock" 和 "numlock" 

LockKey = "numlock"             --    // （启用/禁用整个脚本）
--                                    // 可用于绑定的选项包括 "scrolllock" "capslock" 和 "numlock"

SMGorARtoggle = "capslock"    --    // 在 AR 和 SMG 之间切换 
--                                    //  （或大后坐力枪支和小后坐力枪支）

RapidFireButton = 5 --          https://i.imgur.com/WinEVPi.png 查看罗技鼠标键的列表。 
--                               我使用的是 G602/g604，拥有 11 个键。第一个拇指按钮 == 4，一直到 10

-- //////////////////////////////////////// 下面部分仅限 Lua 开发者修改 -- ////////////////////////////////////////////////

RapidFireSleepMin = 0
RapidFireSleepMax = 0
MouseMove = 0
NRMin = 0
NRMax = 0
Countx = 0
CountY = 0

-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- //////////////////////////////////////// 下面部分仅限 Lua 开发者修改 -- ////////////////////////////////////////////////
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- //////////////////////////////////////// 此部分为 (SMGorARtoggle){当 Scrolllock 开启时}  ///////////////////////////
-- //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// 

function CheckForSMGorAR()
    if IsKeyLockOn(SMGorARtoggle) then
 
        NoRecoilMouseMoveVert = SMGRecoilMouseMoveAmount -- 自动枪支的后坐力处理程度。值越大==鼠标向下拉得更多
        if (SMGRapidFireDelayBetweenShots > 7) then
            RapidFireSleepMin = SMGRapidFireDelayBetweenShots - 7
            RapidFireSleepMax = SMGRapidFireDelayBetweenShots + 7
        else
            RapidFireSleepMin = SMGRapidFireDelayBetweenShots - SMGRapidFireDelayBetweenShots + 5
            RapidFireSleepMax = SMGRapidFireDelayBetweenShots + 10
        end
        MouseMove = SMGRapidFireRecoilCompensation
        SleepNoRecoilMin = SMGMouseMoveDelaySleep - 1
        SleepNoRecoilMax = SMGMouseMoveDelaySleep + 1
        -- // 此 if-else 创建了一个范围供随机生成器使用
        if (RapidFireMousePressDurationSMG > 1) then
            PressSpeedMin = RapidFireMousePressDurationSMG - 1
            PressSpeedMax = RapidFireMousePressDurationSMG + 1
        else
            PressSpeedMin = RapidFireMousePressDurationSMG
            PressSpeedMax = RapidFireMousePressDurationSMG + 1
        end
    -- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    -- /////////////////////// 以下是 AR 或高后坐力枪支的设置 {当 Scrolllock 关闭时} ///////////////////////
    -- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
 
    else
        NoRecoilMouseMoveVert = ARRecoilMouseMoveAmount
 
        SleepNoRecoilMin = ARMouseMoveDelaySleep - 1
        SleepNoRecoilMax = ARMouseMoveDelaySleep + 1
        if (ARRapidFireDelayBetweenShots > 10) then
            RapidFireSleepMin = ARRapidFireDelayBetweenShots - 5
            RapidFireSleepMax = ARRapidFireDelayBetweenShots + 5
        else
            RapidFireSleepMin = ARRapidFireDelayBetweenShots - ARRapidFireDelayBetweenShots + 5
            RapidFireSleepMax = ARRapidFireDelayBetweenShots + 5
        end
        MouseMove = ARRapidFireRecoilCompensation
        if (RapidFireMousePressDurationAR > 1) then
            PressSpeedMin = RapidFireMousePressDurationAR - 1
            PressSpeedMax = RapidFireMousePressDurationAR + 1
        else
            PressSpeedMin = RapidFireMousePressDurationAR
            PressSpeedMax = RapidFireMousePressDurationAR + 1
        end
    end
end
LC = 1 -- 更改此项   // 1 = 左键点击, 2= 中键点击, 3= 右键点击
RC = 3 -- 更改此项   // LC = 开火键, RC = 瞄准键
 
-- 
function Resetter()
    Countx = 0
end
 
-- //////////////////////////////////////////////////////////////
 
function RapidFire()
    repeat
        PressMouseButton(LC)
        Sleep(math.random(PressSpeedMin, PressSpeedMax))
        ReleaseMouseButton(LC)
        Sleep(math.random(2, 4))
        MoveMouseRelative(0, MouseMove)
        Sleep(math.random(RapidFireSleepMin, RapidFireSleepMax))
    until not IsMouseButtonPressed(RC)
end
 
-- //////////////////////////////////////////////////////////////
 
function NoRecoil()
    repeat
        MoveMouseRelative(HorizontalRecoilModifier, NoRecoilMouseMoveVert)
        Sleep(math.random(SleepNoRecoilMin, SleepNoRecoilMax))
    until not IsMouseButtonPressed(LC)
end
 
-- //////////////////////////////////////////////////////////////
 
function OnEvent(event, arg)
    EnablePrimaryMouseButtonEvents(true);
    if (event == "MOUSE_BUTTON_PRESSED" and arg == LC) then
        Sleep(25)
        if IsMouseButtonPressed(RC) then
            if IsKeyLockOn(LockKey) then
                CheckForSMGorAR()
                NoRecoil()
                Resetter()
            end
        else
            while IsMouseButtonPressed(LC) do
                Sleep(15)
                if IsMouseButtonPressed(RC) then
                    CheckForSMGorAR()
                    NoRecoil()
                    Resetter()
                end
            end
        end
    end
 
    if (event == "MOUSE_BUTTON_PRESSED" and arg == 4) then
        Sleep(25)
        if IsMouseButtonPressed(RC) then
            CheckForSMGorAR()
            RapidFire()
            Resetter()
        else
            Sleep(25)
            if IsMouseButtonPressed(RC) then
                CheckForSMGorAR()
                RapidFire()
                Resetter()
            end
        end
    end
    if (event == "MOUSE_BUTTON_PRESSED" and arg == 3) then
        repeat
            if IsMouseButtonPressed(1) then
                CheckForSMGorAR()
                NoRecoil()
                Resetter()
            elseif IsMouseButtonPressed(4) then
                CheckForSMGorAR()
                RapidFire()
                Resetter()
            else
                Sleep(15)
            end
        until not IsMouseButtonPressed(3)
    end
end
