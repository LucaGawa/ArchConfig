import System.IO
import System.Exit

import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers(doFullFloat, doCenterFloat, isFullscreen, isDialog)
import XMonad.Config.Desktop
import XMonad.Config.Azerty
import XMonad.Util.Run(spawnPipe)
import XMonad.Actions.SpawnOn
import XMonad.Util.SpawnOnce
import XMonad.Actions.OnScreen
import XMonad.Util.EZConfig (additionalKeys, additionalMouseBindings)
import XMonad.Actions.CycleWS
import XMonad.Hooks.UrgencyHook
import qualified Codec.Binary.UTF8.String as UTF8

import XMonad.Layout.Spacing
import XMonad.Layout.Gaps
import XMonad.Layout.ResizableTile
import XMonad.Layout.NoBorders
-- import XMonad.Layout.Fullscreen (fullscreenFull)
import XMonad.Layout.Cross(simpleCross)
import XMonad.Layout.Spiral(spiral)
import XMonad.Layout.ThreeColumns
import XMonad.Layout.MultiToggle
import XMonad.Layout.MultiToggle.Instances
import XMonad.Layout.IndependentScreens

import XMonad.Hooks.DynamicProperty (dynamicTitle)

import XMonad.Layout.CenteredMaster(centerMaster)

import Graphics.X11.ExtraTypes.XF86
import qualified XMonad.StackSet as W
import qualified Data.Map as M
import qualified Data.ByteString as B
import Control.Monad (liftM2)
import qualified DBus as D
import qualified DBus.Client as D 

import XMonad.Actions.Navigation2D

myStartupHook = do
      spawn "$HOME/.config/xmonad/scripts/autostart.sh"
    -- initial workspaces on specific screens
      windows (viewOnScreen 0 "1") --todo make dynamical with loop
      windows (viewOnScreen 1 "2")
      windows (viewOnScreen 2 "3")
      windows (viewOnScreen 3 "4")
      spawnOnOnce "10" "spotify" --spawn just on start not on rebuild
      spawnOnOnce "9" "thunderbird" --spawn just on start not on rebuild
      spawnOnOnce "9" "rambox" --spawn just on start not on rebuild


-- colours
normBord = "#4c566a"
focdBord = "#5e81ac"
fore     = "#DEE3E0"
back     = "#282c34"
winType  = "#c678dd"

--mod4Mask= super key
--mod1Mask= alt key
--controlMask= ctrl key
--shiftMask= shift key

myModMask = mod4Mask
encodeCChar = map fromIntegral . B.unpack
myFocusFollowsMouse = True
myBorderWidth = 2
--myWorkspaces    = ["\61612","\61899","\61947","\61635","\61502","\61501","\61705","\61564","\62150","\61872"]


--myWorkspaces    = ["I","II","III","IV","V","VI","VII","VIII","IX","X"]

myBaseConfig = desktopConfig

-- window manipulations
myManageHook = composeAll . concat $
    [ [isDialog --> doCenterFloat]
    , [className =? c --> doCenterFloat | c <- myCFloats]
    , [title =? t --> doFloat | t <- myTFloats]
    , [resource =? r --> doFloat | r <- myRFloats]
    , [resource =? i --> doIgnore | i <- myIgnores]
    
    -- , [(className =? x <||> title =? x <||> resource =? x) --> doShiftAndGo "\61612" | x <- my1Shifts]
    -- , [(className =? x <||> title =? x <||> resource =? x) --> doShiftAndGo "\61899" | x <- my2Shifts]
    -- , [(className =? x <||> title =? x <||> resource =? x) --> doShiftAndGo "\61947" | x <- my3Shifts]
    -- , [(className =? x <||> title =? x <||> resource =? x) --> doShiftAndGo "\61635" | x <- my4Shifts]
    -- , [(className =? x <||> title =? x <||> resource =? x) --> doShiftAndGo "\61502" | x <- my5Shifts]
    -- , [(className =? x <||> title =? x <||> resource =? x) --> doShiftAndGo "\61501" | x <- my6Shifts]
    -- , [(className =? x <||> title =? x <||> resource =? x) --> doShiftAndGo "\61705" | x <- my7Shifts]
    --, [(className =? x <||> title =? x <||> resource =? x) --> doShiftAndGo "8" | x <- my8Shifts]
    --, [(className =? x <||> title =? x <||> resource =? x) --> doShiftAndGo "9" | x <- my9Shifts]
    --, [(className =? x <||> title =? x <||> resource =? x) --> doShiftAndGo "10" | x <- my10Shifts]
    ]
    where
    --doShiftAndGo = doF . liftM2 (.) W.greedyView W.shift
    myCFloats = ["Arandr", "Arcolinux-calamares-tool.py", "Archlinux-tweak-tool.py", "Arcolinux-welcome-app.py", "Galculator", "feh", "mpv", "Xfce4-terminal", "Xfce4-appfinder", "Xfce4-settings-manager", "Pavucontrol", "Archlinux-logout.py"] --todo set logout size to fullscreen
    myTFloats = ["Downloads", "Save As..."]
    myRFloats = []
    myIgnores = ["desktop_window"]
    -- my1Shifts = ["Chromium", "Vivaldi-stable", "Firefox"]
    -- my2Shifts = []
    -- my3Shifts = ["Inkscape"]
    -- my4Shifts = []
    -- my5Shifts = ["Gimp", "feh"]
    -- my6Shifts = ["vlc", "mpv"]
    -- my7Shifts = ["Virtualbox"]
    --my8Shifts = ["Xournalpp"]
    --my9Shifts = ["spotify"]
    --my10Shifts = ["thunderbird"]


manageZoomHook =
  composeAll $
    [ (className =? zoomClassName) <&&> shouldFloat <$> title --> doFloat,
      (className =? zoomClassName) <&&> shouldSink <$> title --> doSink
    ]
  where
    zoomClassName = "zoom"
    tileTitles =
      [ "Zoom - Free Account", -- main window
        "Zoom - Licensed Account", -- main window
        "Zoom", -- meeting window on creation
        "Zoom Meeting" -- meeting window shortly after creation
      ]
    shouldFloat title = title `notElem` tileTitles
    shouldSink title = title `elem` tileTitles
    doSink = (ask >>= doF . W.sink) <+> doF W.swapDown




myLayout = avoidStruts $ smartBorders  (spacingRaw False (Border 0 5 5 5) False (Border 5 5 5 5) True $ mkToggle (NBFULL ?? FULL ?? NOBORDERS ?? SMARTBORDERS ?? EOT) $ tiled ||| Mirror tiled |||  ThreeColMid 1 (3/100) (1/2) ||| Full)
    where
        tiled = Tall nmaster delta tiled_ratio
        nmaster = 1
        delta = 3/100
        tiled_ratio = 1/2


myMouseBindings (XConfig {XMonad.modMask = modMask}) = M.fromList $

    -- mod-button1, Set the window to floating mode and move by dragging and Raise the window to the top of the stack
    [ ((modMask, 1), (\w -> focus w >> windows W.shiftMaster) >> (\w -> focus w >> mouseMoveWindow w >> windows W.shiftMaster) )

    -- mod-button2, 
    ,((modMask, 2), (\w -> focus w >> withFocused(windows . W.sink))) -- set floating window back in tiling
    
    -- mod-button3, Set the window to floating mode and resize by dragging
    , ((modMask, 3), (\w -> focus w >> mouseResizeWindow w >> windows W.shiftMaster))

    ]


-- keys config

myKeys conf@(XConfig {XMonad.modMask = modMask}) = M.fromList $
  ----------------------------------------------------------------------
  -- SUPER + FUNCTION KEYS

  [ ((modMask, xK_e), spawn $ "thunar " )
  , ((modMask, xK_s), spawn $ "spotify" )
  , ((modMask, xK_w), spawn $ "brave" )
  , ((modMask, xK_m), spawn $ "Mathematica" )
  , ((modMask, xK_c), spawn $ "conky-toggle" )
  , ((modMask, xK_f), sendMessage $ Toggle NBFULL) --todo same key than toggle polybar
  , ((modMask, xK_b), spawn "polybar-msg cmd toggle")
  , ((modMask, xK_n), sendMessage $ Toggle SMARTBORDERS) --todo work not for spacing
  , ((mod1Mask, xK_F4), kill )
  , ((modMask, xK_x), spawn $ "archlinux-logout" )
  , ((modMask, xK_Escape), spawn $ "xkill" )
  , ((modMask, xK_Return), spawn $ "kitty" ) 
  -- rofi themes from: https://github.com/adi1090x/rofi/tree/master
  , ((modMask, xK_F12), spawn $ "$HOME/.config/rofi/launchers/type-3/launcher.sh" )
  , ((modMask .|. shiftMask, xK_Return), spawn $ "$HOME/.config/rofi/launchers/type-3/launcher.sh" )
  , ((modMask, xK_F11), spawn $ "xfce4-settings-manager" )
  , ((modMask, xK_z), spawn $ "xournalpp" ) 
  , ((modMask, xK_g), spawn $ "$HOME/.config/rofi/launchers/type-3/launcher_window.sh" )

  -- FUNCTION KEYS

  -- SUPER + SHIFT KEYS
  , ((modMask .|. shiftMask , xK_r ), spawn $ "xmonad --recompile && xmonad --restart")
  , ((modMask, xK_t), spawn "autorandr --cycle")
  , ((modMask .|. mod1Mask, xK_t), spawn "bash ~/.config/xmonad/scripts/cycle_layouts.sh --default")
  , ((modMask , xK_q ), kill)
  -- , ((modMask .|. shiftMask , xK_x ), io (exitWith ExitSuccess))

  -- CONTROL + ALT KEYS

  , ((controlMask .|. mod1Mask , xK_k ), spawn $ "archlinux-logout")
  , ((controlMask .|. mod1Mask , xK_l ), spawn $ "archlinux-logout")
  , ((controlMask .|. mod1Mask , xK_m ), spawn $ "xfce4-settings-manager")
  , ((controlMask .|. mod1Mask , xK_o ), spawn $ "$HOME/.config/xmonad/scripts/picom-toggle.sh")
  , ((controlMask .|. mod1Mask , xK_p ), spawn $ "pamac-manager")
  , ((controlMask .|. mod1Mask , xK_u ), spawn $ "pavucontrol")

  -- , ("M-g",           moveTo Next HiddenNonEmptyWS) cycle through not empty ws


  --CONTROL + SHIFT KEYS

  , ((controlMask .|. mod1Mask , xK_Delete ), spawn $ "xfce4-taskmanager")

  --SCREENSHOTS
  , ((0, xK_Print), spawn $ "scrot -s 'ArcoLinux-%Y-%m-%d-%s_screenshot_$wx$h.jpg' -e 'mv $f $$(xdg-user-dir PICTURES)'")
  , ((modMask, xK_Print), spawn $ "xfce4-screenshooter" )


  --MULTIMEDIA KEYS
  --Audio
  , ((0, xF86XK_AudioMute), spawn $ "amixer -q set Master toggle")
  , ((0, xF86XK_AudioLowerVolume), spawn $ "amixer -q set Master 5%-")
  , ((0, xF86XK_AudioRaiseVolume), spawn $ "amixer -q set Master 5%+")
  --Brightness
  , ((0, xF86XK_MonBrightnessUp),  spawn $ "xbacklight -inc 2") -- alternative: brightnesssct s 5%+
  , ((0, xF86XK_MonBrightnessDown), spawn $ "xbacklight -dec 2")
  --Media control
  , ((0, xF86XK_AudioPlay), spawn $ "playerctl play-pause") -- alternative: mpc toggle mpc next mpc prev...
  , ((0, xF86XK_AudioNext), spawn $ "playerctl next")
  , ((0, xF86XK_AudioPrev), spawn $ "playerctl previous")
  , ((0, xF86XK_AudioStop), spawn $ "playerctl stop")


  --------------------------------------------------------------------
  --  XMONAD LAYOUT KEYS

  -- Cycle through the available layout algorithms.
  , ((modMask, xK_space), sendMessage NextLayout)

  --Focus selected desktop
  , ((mod1Mask, xK_Tab), nextWS)

  --Focus selected desktop
  , ((modMask, xK_Tab), nextWS)

  --Focus selected desktop
  , ((controlMask .|. mod1Mask , xK_Left ), prevWS)

  --Focus selected desktop
  , ((controlMask .|. mod1Mask , xK_Right ), nextWS)

  --  Reset the layouts on the current workspace to default.
  , ((modMask .|. shiftMask, xK_space), setLayout $ XMonad.layoutHook conf)

  -- Navigate Windows
  , ((modMask, xK_j), windowGo D False)
  , ((modMask, xK_h), windowGo L False)
  , ((modMask, xK_k), windowGo U False)
  , ((modMask, xK_l), windowGo R False)


  -- Swap Windows
  , ((modMask .|. shiftMask, xK_j), windowSwap D False)
  , ((modMask .|. shiftMask, xK_h), windowSwap L False)
  , ((modMask .|. shiftMask, xK_k), windowSwap U False)
  , ((modMask .|. shiftMask, xK_l), windowSwap R False)

  -- Shrink the master area.
  , ((controlMask .|. modMask , xK_h), sendMessage Shrink)

  -- Expand the master area.
  , ((controlMask .|. modMask , xK_l), sendMessage Expand)

  -- Push window back into tiling.
  , ((controlMask .|. shiftMask , xK_t), withFocused $ windows . W.sink)

  -- Increment the number of windows in the master area.
  , ((controlMask .|. modMask, xK_Left), sendMessage (IncMasterN 1))

  -- Decrement the number of windows in the master area.
  , ((controlMask .|. modMask, xK_Right), sendMessage (IncMasterN (-1)))

  ]
  ++

  -- mod-[1..9], Switch to workspace N
  -- mod-shift-[1..9], Move client to workspace N
  [((m .|. modMask, k), windows $ f i)

  --Keyboard layouts
   | (i, k) <- zip (XMonad.workspaces conf) [xK_1,xK_2,xK_3,xK_4,xK_5,xK_6,xK_7,xK_8,xK_9,xK_0]

      , (f, m) <- [(W.view, 0), (W.shift, shiftMask)
      , (\i -> W.view i . W.shift i, shiftMask) -- follow the window to the screen
      ]]
  -- ++
  -- [((m .|. modMask, k), windows $ f i)

  -- --Keyboard layouts
  --  | (i, k) <- zip (XMonad.workspaces conf) [xK_1,xK_2,xK_3,xK_4,xK_5,xK_6,xK_7,xK_8,xK_9,xK_0]

  --     , (f, m) <- [(W.greedyView, 0), (W.shift, controlMask)
  --     , (\i -> W.greedyView i . W.shift i, controlMask) -- follow the window to the screen
  --     ]] todo ctrl for greedyView

  -- ++
  -- ctrl-shift-{w,e,r}, Move client to screen 1, 2, or 3
  -- [((m .|. controlMask, key), screenWorkspace sc >>= flip whenJust (windows . f))
  --    | (key, sc) <- zip [xK_w, xK_e] [0..]
  --    , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]


main :: IO ()
main = do


    dbus <- D.connectSession
    -- Request access to the DBus name
    D.requestName dbus (D.busName_ "org.xmonad.Log")
        [D.nameAllowReplacement, D.nameReplaceExisting, D.nameDoNotQueue]

-- disableEwmhManageDesktopViewport . as soon as avalible 

    xmonad $  ewmhFullscreen . ewmh$ withNavigation2DConfig def $
            myBaseConfig

                {startupHook = myStartupHook
, layoutHook =  myLayout ||| layoutHook myBaseConfig
, manageHook = manageSpawn <+> myManageHook <+> manageZoomHook <+> manageHook myBaseConfig
, modMask = myModMask
, borderWidth = myBorderWidth
, handleEventHook = mconcat[
  dynamicTitle manageZoomHook,
  handleEventHook myBaseConfig
] -- <+> ewmhFullscreen
, focusFollowsMouse = myFocusFollowsMouse
, workspaces = ["1","2","3","4","5","6","7","8","9","10"]
, focusedBorderColor = focdBord
, normalBorderColor = normBord
, keys = myKeys
, mouseBindings = myMouseBindings
}
