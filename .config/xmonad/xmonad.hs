-- IMPORTS

-- Base
import XMonad                                   -- base Xmonad module
import System.Exit (exitSuccess)                -- allows system exits with code
import System.IO (hClose, hPutStr, hPutStrLn)   -- allows for Input Output, needed?
import qualified XMonad.StackSet as W           -- defines workspaces, windows and stacks



-- Actions

import XMonad.Actions.CopyWindow (kill1)                                                              -- needed to kill windows in workspaces
import XMonad.Actions.CycleWS (Direction1D(..), moveTo, shiftTo, WSType(..), nextScreen, prevScreen)    -- workspace management
import XMonad.Actions.GridSelect                                                                        -- enable gridselect programs or apps
import XMonad.Actions.MouseResize                                                                       -- allows windows to be resized by mouse
import XMonad.Actions.Promote                                                                           -- focus on master window
import XMonad.Actions.RotSlaves (rotSlavesDown, rotAllDown)                                             -- rotate windows that arent master
import XMonad.Actions.WindowGo (runOrRaise)
import XMonad.Actions.WithAll (sinkAll, killAll)                                                        -- multi action with all windows
import qualified XMonad.Actions.Search as S                                                             -- enable search with browser straight from WM

-- Data
import Data.Monoid
import qualified Data.Map        as M
import Data.Char (toUpper)
import Data.Maybe (fromJust)
import Data.Maybe (isJust)
import Data.Char (isSpace)


-- not sure if the modules below are needed, uncomment as see fit
-- import Data.Tree


-- Hooks
-- import XMonad.Hooks.DynamicLog  (dynamicLogWithPP, wrap, xmobarPP, xmobarColor, shorten, PP(..))-- wrapper for StatusBar and Statusbar.PP hooks
import XMonad.Hooks.StatusBar
import XMonad.Hooks.StatusBar.PP
import XMonad.Hooks.ManageDocks (avoidStruts, docks, manageDocks, ToggleStruts(..))         -- allow windows respect docks like xmobar
import XMonad.Hooks.EwmhDesktops                                                            -- for some fullscreen events, also for xcomposite in obs.
import XMonad.Hooks.ServerMode                                                              -- works together with ewhm
import XMonad.Hooks.ManageHelpers (isFullscreen, doFullFloat, doCenterFloat)                -- manage fullscreen, float helpers
import XMonad.Hooks.WindowSwallowing                                                        -- handles event hooks
import XMonad.Hooks.SetWMName                                                               -- allows setting window manager name
import XMonad.Hooks.FadeInactive
import XMonad.Hooks.WorkspaceHistory                                                        -- gives history of workspace navigations


-- Layouts
import XMonad.Layout.Accordion
import XMonad.Layout.GridVariants (Grid(Grid))
import XMonad.Layout.SimplestFloat
import XMonad.Layout.Spiral
import XMonad.Layout.ResizableTile
import XMonad.Layout.Tabbed
import XMonad.Layout.ThreeColumns
import XMonad.Layout.CenteredMaster
import XMonad.Layout.CenteredIfSingle


-- Layout modifiers
import XMonad.Layout.LayoutModifier                                                         -- allows writing custom layouts
import XMonad.Layout.LimitWindows (limitWindows, increaseLimit, decreaseLimit)              -- allows max limit for windows
import XMonad.Layout.MultiToggle (mkToggle, single, EOT(EOT), (??))                         -- allows dynamically applying transformations to layouts
import XMonad.Layout.MultiToggle.Instances (StdTransformers(NBFULL, MIRROR, NOBORDERS))     -- convienent instance of transformer class, use with MultiToggle
import XMonad.Layout.NoBorders                                                              -- allows no boreders in windows
import XMonad.Layout.Renamed                                                                -- allows modify of desciription of underlying layout
import XMonad.Layout.ShowWName                                                              -- shows workspace name
import XMonad.Layout.Simplest                                                               -- allows for a very simple layout
import XMonad.Layout.Spacing                                                                -- adds configurable spaces around windows
import XMonad.Layout.SubLayouts                                                             -- allows layouts to be nested
import XMonad.Layout.WindowArranger (windowArrange, WindowArrangerMsg(..))                  -- allows move and resize windows with keyboard
import XMonad.Layout.WindowNavigation                                                       -- allows easy navigation of workspace
import qualified XMonad.Layout.ToggleLayouts as T (toggleLayouts, ToggleLayout(Toggle))     -- allows toggling between layouts
import qualified XMonad.Layout.MultiToggle as MT (Toggle(..))

-- Prompt
import XMonad.Prompt
import XMonad.Prompt.Input
import XMonad.Prompt.FuzzyMatch
import XMonad.Prompt.Man
import XMonad.Prompt.Pass
import XMonad.Prompt.Shell (shellPrompt)
import XMonad.Prompt.Ssh
import XMonad.Prompt.XMonad
import Control.Arrow (first)


-- Utilities
import XMonad.Util.Dmenu                                                    -- convienent bindings for dmenu
import XMonad.Util.EZConfig (additionalKeysP, mkNamedKeymap)                -- allows for writing keybindings in a easier format
-- import XMonad.Util.Hacks (windowedFullscreenFixEventHook, javaHack, trayerAboveXmobarEventHook, trayAbovePanelEventHook, trayerPaddingXmobarEventHook, trayPaddingXmobarEventHook, trayPaddingEventHook)
-- looks like only two hacks are referenced below, if doesnt work uncomment the line above instead
import XMonad.Util.Hacks (windowedFullscreenFixEventHook, trayerPaddingXmobarEventHook)
import XMonad.Util.NamedActions                                             -- works together with EZConfig to allow keybinding configuration that can list available bindings
import XMonad.Util.NamedScratchpad                                          -- allow for scratchpads
import XMonad.Util.NamedWindows (getName)                                   -- allows associate titles of windows with them
import XMonad.Util.Run (runProcessWithInput, safeSpawn, spawnPipe)          -- helper functions to run processes
import XMonad.Util.SpawnOnce                                                -- another helper function to run process

   -- ColorScheme module (SET ONLY ONE!)
      -- Possible choice are:
      -- DoomOne
      -- Dracula
      -- GruvboxDark
      -- MonokaiPro
      -- Nord
      -- OceanicNext
      -- Palenight
      -- SolarizedDark
      -- SolarizedLight
      -- TomorrowNight
import Colors.Dracula




-- set font
myFont :: String
myFont = "xft:UbuntuMono Nerd Font Mono Regular:pixelsize=12"


-- set modkey
myModMask :: KeyMask
myModMask = mod4Mask        -- modkey to super/windows key


-- set terminal
myTerminal :: String
myTerminal = "alacritty"


-- set browser
myBrowser :: String
myBrowser = "qutebrowser"

-- set editor
myEditor :: String
myEditor = myTerminal ++ " -- nvim "

-- set sound player, feature not needed, ffmpeg and ffplay available though.
-- mySoundPlayer :: String
-- mySoundPlayer = "ffplay -nodisp -autoexit " -- plays system sound


-- Width of the window border in pixels.
myBorderWidth :: Dimension
myBorderWidth   = 2


-- Border color of normal windows
myNormColor :: String
myNormColor   = colorBack   -- This variable is imported from Colors.THEME

-- Border color of focused windows
myFocusColor :: String
myFocusColor  = color15     -- This variable is imported from Colors.THEME


-- Whether focus follows the mouse pointer.
myFocusFollowsMouse :: Bool
myFocusFollowsMouse = False


altMask :: KeyMask
altMask = mod1Mask         -- Setting this for use in xprompts


-- counting windows
windowCount :: X (Maybe String)
windowCount = gets $ Just . show . length . W.integrate' . W.stack . W.workspace . W.current . windowset



-- Applications to start with xmonad
myStartupHook :: X ()
myStartupHook = do
   -- making sure current LXDE File manager doesnt set wallpaper and make sure panels not there
   spawn "killall trayer"  -- kill current trayer on each restart

   spawnOnce "lxsession"     -- allows for X11 sessions
   spawnOnce "picom"           -- X compositor, handles transparency and other animation
   spawnOnce "nm-applet"          -- network manager applet, shows status
   spawnOnce "pnmixer"           -- sound mix applet
   -- spawnOnce "trayer --edge top --align right --widthtype request --padding 6 --SetDockType true --SetPartialStruct true --expand true --monitor primary --transparent true --alpha 0 --tint 0x282c34 --height 22"

   -- spawn "sleep 2 && killall pcmanfm" -- this kills desktop manager, and no mouse will be avail
   spawn "sleep 2 && killall lxpanel"
   -- wallpapers for dual monitors, comment out if having trouble
   spawn "sleep 3 && xwallpaper --output DP-1-1.2 --stretch /usr/share/backgrounds/earth.jpg --output DP-1-1.3 --center /usr/share/backgrounds/earth.jpg"  -- draws background image
   spawn ("sleep 2 && trayer --edge top --align right --widthtype request --padding 4 --SetDockType true --SetPartialStrut true --expand true --monitor primary --transparent true --alpha 255 --tint 0x000000 " ++ colorTrayer ++ " --height 22")


   -- uncomment if using nitrogen to do backgrounds instead
   -- spawnOnce "nitrogen --restore &"
   setWMName "LG3D"





-- -- GRIDSELECT SETTINGS

-- Navigation settings for grid select
myNavigation :: TwoD a (Maybe a)
myNavigation = makeXEventhandler $ shadowWithKeymap navKeyMap navDefaultHandler
 where navKeyMap = M.fromList [
          ((0,xK_Escape), cancel)
         ,((0,xK_Return), select)
         ,((0,xK_slash) , substringSearch myNavigation)
         ,((0,xK_Left)  , move (-1,0)  >> myNavigation)
         ,((0,xK_h)     , move (-1,0)  >> myNavigation)
         ,((0,xK_Right) , move (1,0)   >> myNavigation)
         ,((0,xK_l)     , move (1,0)   >> myNavigation)
         ,((0,xK_Down)  , move (0,1)   >> myNavigation)
         ,((0,xK_j)     , move (0,1)   >> myNavigation)
         ,((0,xK_Up)    , move (0,-1)  >> myNavigation)
         ,((0,xK_k)     , move (0,-1)  >> myNavigation)
         ,((0,xK_y)     , move (-1,-1) >> myNavigation)
         ,((0,xK_i)     , move (1,-1)  >> myNavigation)
         ,((0,xK_n)     , move (-1,1)  >> myNavigation)
         ,((0,xK_m)     , move (1,-1)  >> myNavigation)
         ,((0,xK_space) , setPos (0,0) >> myNavigation)
         ]
       navDefaultHandler = const myNavigation


-- Color settings for grid select
myColorizer :: Window -> Bool -> X (String, String)
myColorizer = colorRangeFromClassName
                (0x28,0x2c,0x34) -- lowest inactive bg
                (0x28,0x2c,0x34) -- highest inactive bg
                (0xc7,0x92,0xea) -- active bg
                (0xc0,0xa7,0x9a) -- inactive fg
                (0x28,0x2c,0x34) -- active fg



-- gridSelect menu layout
mygridConfig :: p -> GSConfig Window
mygridConfig colorizer = (buildDefaultGSConfig myColorizer)
    { gs_cellheight   = 40
    , gs_cellwidth    = 200
    , gs_cellpadding  = 6
    , gs_navigate    = myNavigation
    , gs_originFractX = 0.5
    , gs_originFractY = 0.5
    , gs_font         = myFont
    }


-- gridSelect to spawn categories on what is selected
-- with the following config for grid cell for the secondary menu
spawnSelected' :: [(String, String)] -> X ()
spawnSelected' lst = gridselect conf lst >>= flip whenJust spawn
    where conf = def
                   { gs_cellheight   = 40
                   , gs_cellwidth    = 180
                   , gs_cellpadding  = 6
                   , gs_originFractX = 0.5
                   , gs_originFractY = 0.5
                   , gs_font         = myFont
                   }



-- grid select primary window
gsCategories =
  [ ("Games",      "xdotool key super+alt+1")
  , ("Education",  "xdotool key super+alt+2")
  , ("Internet",   "xdotool key super+alt+3")
  , ("Multimedia", "xdotool key super+alt+4")
  , ("Office",     "xdotool key super+alt+5")
  , ("Settings",   "xdotool key super+alt+6")
  , ("System",     "xdotool key super+alt+7")
  , ("Utilities",  "xdotool key super+alt+8")
  ]


-- grid select, secondary menus
gsGames =
  [ ("Steam", "steam") ]

gsEducation =
  [ ("Scratch", "scratch") ]

gsInternet =
  [ ("Discord", "discord")
  , ("Firefox", "firefox")
  , ("Chrome", "google-chrome")
  , ("Qutebrowser", "qutebrowser")
  ]

gsMultimedia =
  [ ("Audacity", "audacity")
  , ("OBS Studio", "obs")
  , ("VLC", "vlc")
  ]

gsOffice =
  [ ("Document Viewer", "evince")
  , ("LibreOffice", "libreoffice")
  , ("LO Base", "lobase")
  , ("LO Calc", "localc")
  , ("LO Draw", "lodraw")
  , ("LO Impress", "loimpress")
  , ("LO Math", "lomath")
  , ("LO Writer", "lowriter")
  ]

gsSettings =
  [ ("ARandR", "arandr")
  , ("Gnome Tweak Tool (care)", "gnome-tweaks")
  , ("Gnome Settings (care)", "gnome-control-center")
  , ("Firewall Configuration", "sudo gufw")
  ]

gsSystem =
  [
  -- ("Alacritty", "alacritty")
   ("Bash", (myTerminal ++ " -- bash"))
  , ("Htop", (myTerminal ++ " -- htop"))
  , ("Fish", (myTerminal ++ " -- fish"))
  , ("Fish", (myTerminal ++ " -- conky"))
  ]

gsUtilities = [
   ("Calculator", "gnome-calculator")
  , ("Vim", (myTerminal ++ " -e vim"))
  ]


------------------------------------------------------------------------
-- XPROMPT SETTINGS
------------------------------------------------------------------------
dtXPConfig :: XPConfig
dtXPConfig = def
      { font                = myFont
      , bgColor             = "#292d3e"
      , fgColor             = "#d0d0d0"
      , bgHLight            = "#c792ea"
      , fgHLight            = "#000000"
      , borderColor         = "#535974"
      , promptBorderWidth   = 0
      , promptKeymap        = dtXPKeymap
      , position            = Top
--    , position            = CenteredAt { xpCenterY = 0.3, xpWidth = 0.3 }
      , height              = 20
      , historySize         = 256
      , historyFilter       = id
      , defaultText         = []
      , autoComplete        = Just 100000  -- set Just 100000 for .1 sec
      , showCompletionOnTab = False
      -- , searchPredicate     = isPrefixOf
      , searchPredicate     = fuzzyMatch
      , alwaysHighlight     = True
      , maxComplRows        = Nothing      -- set to Just 5 for 5 rows
      }

-- The same config above minus the autocomplete feature which is annoying
-- on certain Xprompts, like the search engine prompts.
dtXPConfig' :: XPConfig
dtXPConfig' = dtXPConfig
      { autoComplete        = Nothing
      }

-- A list of all of the standard Xmonad prompts and a key press assigned to them.
-- These are used in conjunction with keybinding I set later in the config.
promptList :: [(String, XPConfig -> X ())]
promptList = [ ("m", manPrompt)          -- manpages prompt
             , ("p", passPrompt)         -- get passwords (requires 'pass')
             , ("g", passGeneratePrompt) -- generate passwords (requires 'pass')
             , ("r", passRemovePrompt)   -- remove passwords (requires 'pass')
             , ("s", sshPrompt)          -- ssh prompt
             , ("x", xmonadPrompt)       -- xmonad prompt
             ]

-- Same as the above list except this is for my custom prompts.
promptList' :: [(String, XPConfig -> String -> X (), String)]
promptList' = [ ("c", calcPrompt, "qalc")         -- requires qalculate-gtk
              ]

------------------------------------------------------------------------
-- CUSTOM PROMPTS
------------------------------------------------------------------------
-- calcPrompt requires a cli calculator called qalcualte-gtk.
-- You could use this as a template for other custom prompts that
-- use command line programs that return a single line of output.
calcPrompt :: XPConfig -> String -> X ()
calcPrompt c ans =
    inputPrompt c (trim ans) ?+ \input ->
        liftIO(runProcessWithInput "qalc" [input] "") >>= calcPrompt c
    where
        trim  = f . f
            where f = reverse . dropWhile isSpace

------------------------------------------------------------------------
-- XPROMPT KEYMAP (emacs-like key bindings for xprompts)
------------------------------------------------------------------------
dtXPKeymap :: M.Map (KeyMask,KeySym) (XP ())
dtXPKeymap = M.fromList $
     map (first $ (,) controlMask)   -- control + <key>
     [ (xK_z, killBefore)            -- kill line backwards
     , (xK_k, killAfter)             -- kill line forwards
     , (xK_a, startOfLine)           -- move to the beginning of the line
     , (xK_e, endOfLine)             -- move to the end of the line
     , (xK_m, deleteString Next)     -- delete a character foward
     , (xK_b, moveCursor Prev)       -- move cursor forward
     , (xK_f, moveCursor Next)       -- move cursor backward
     , (xK_BackSpace, killWord Prev) -- kill the previous word
     , (xK_y, pasteString)           -- paste a string
     , (xK_g, quit)                  -- quit out of prompt
     , (xK_bracketleft, quit)
     ]
     ++
     map (first $ (,) altMask)       -- meta key + <key>
     [ (xK_BackSpace, killWord Prev) -- kill the prev word
     , (xK_f, moveWord Next)         -- move a word forward
     , (xK_b, moveWord Prev)         -- move a word backward
     , (xK_d, killWord Next)         -- kill the next word
     , (xK_n, moveHistory W.focusUp')   -- move up thru history
     , (xK_p, moveHistory W.focusDown') -- move down thru history
     ]
     ++
     map (first $ (,) 0) -- <key>
     [ (xK_Return, setSuccess True >> setDone True)
     , (xK_KP_Enter, setSuccess True >> setDone True)
     , (xK_BackSpace, deleteString Prev)
     , (xK_Delete, deleteString Next)
     , (xK_Left, moveCursor Prev)
     , (xK_Right, moveCursor Next)
     , (xK_Home, startOfLine)
     , (xK_End, endOfLine)
     , (xK_Down, moveHistory W.focusUp')
     , (xK_Up, moveHistory W.focusDown')
     , (xK_Escape, quit)
     ]



-- Search feature settings
-- Xmonad has several search engines available to use located in
-- XMonad.Actions.Search. Additionally, you can add other search engines
-- such as those listed below.
-- archwiki, ebay, news, reddit, urban :: S.SearchEngine

-- archwiki = S.searchEngine "archwiki" "https://wiki.archlinux.org/index.php?search="
-- ebay     = S.searchEngine "ebay" "https://www.ebay.com/sch/i.html?_nkw="
-- news     = S.searchEngine "news" "https://news.google.com/search?q="
-- reddit   = S.searchEngine "reddit" "https://www.reddit.com/search/?q="
-- urban    = S.searchEngine "urban" "https://www.urbandictionary.com/define.php?term="

-- This is the list of search engines that I want to use. Some are from
-- XMonad.Actions.Search, and some are the ones that I added above.
searchList :: [(String, S.SearchEngine)]
searchList = [ ("d", S.duckduckgo)
             , ("g", S.google)
             , ("h", S.hoogle)
             , ("i", S.images)
             , ("t", S.thesaurus)
             , ("v", S.vocabulary)
             , ("w", S.wikipedia)
             , ("y", S.youtube)
             , ("z", S.amazon)
             ]




-- scracth pad settings
myScratchPads :: [NamedScratchpad]
myScratchPads = [ NS "terminal" spawnTerm findTerm manageTerm
                , NS "mocp" spawnMocp findMocp manageMocp
                , NS "calculator" spawnCalc findCalc manageCalc]
  where
    spawnTerm  = myTerminal ++ " -t scratchpad"
    findTerm   = title =? "scratchpad"
    manageTerm = customFloating $ W.RationalRect l t w h
               where
                 h = 0.9
                 w = 0.9
                 t = 0.95 -h
                 l = 0.95 -w

    spawnMocp  = myTerminal ++ " -t mocp -e mocp"
    findMocp   = title =? "mocp"
    manageMocp = customFloating $ W.RationalRect l t w h
               where
                 h = 0.9
                 w = 0.9
                 t = 0.95 -h
                 l = 0.95 -w

    spawnCalc  = "gnome-calculator"
    findCalc   = className =? "gnome-calculator"
    manageCalc = customFloating $ W.RationalRect l t w h
               where
                 h = 0.5
                 w = 0.4
                 t = 0.75 -h
                 l = 0.70 -w


-- spacing between windows, settings straight from distrotube

--Makes setting the spacingRaw simpler to write. The spacingRaw module adds a configurable amount of space around windows.
mySpacing :: Integer -> l a -> XMonad.Layout.LayoutModifier.ModifiedLayout Spacing l a
mySpacing i = spacingRaw False (Border i i i i) True (Border i i i i) True

-- Below is a variation of the above except no borders are applied
-- if fewer than two windows. So a single window has no gaps.
mySpacing' :: Integer -> l a -> XMonad.Layout.LayoutModifier.ModifiedLayout Spacing l a
mySpacing' i = spacingRaw True (Border i i i i) True (Border i i i i) True





-- Layouts settings

-- Defining a bunch of layouts, many that I don't use.
-- limitWindows n sets maximum number of windows displayed for layout.
-- mySpacing n sets the gap size around the windows.
tall     = renamed [Replace "tall"]
           $ limitWindows 5
           $ smartBorders
           $ windowNavigation
           $ addTabs shrinkText myTabTheme
           $ subLayout [] (smartBorders Simplest)
           $ mySpacing 8
           $ ResizableTall 1 (3/100) (1/2) []
monocle  = renamed [Replace "monocle"]
           $ smartBorders
           $ windowNavigation
           $ addTabs shrinkText myTabTheme
           $ subLayout [] (smartBorders Simplest)
           $ Full
floats   = renamed [Replace "floats"]
           $ smartBorders
           $ simplestFloat
grid     = renamed [Replace "grid"]
           $ limitWindows 9
           $ smartBorders
           $ windowNavigation
           $ addTabs shrinkText myTabTheme
           $ subLayout [] (smartBorders Simplest)
           $ mySpacing 8
           $ mkToggle (single MIRROR)
           $ Grid (16/10)
centered = renamed [Replace "centerMaster"]
           $ smartBorders
           $ centerMaster grid
centeredSingle = renamed [Replace "centeredIfSingle"]
           $ smartBorders
           $ centeredIfSingle 0.7 0.8 grid
spirals  = renamed [Replace "spirals"]
           $ limitWindows 9
           $ smartBorders
           $ windowNavigation
           $ addTabs shrinkText myTabTheme
           $ subLayout [] (smartBorders Simplest)
           $ mySpacing' 8
           $ spiral (6/7)
threeCol = renamed [Replace "threeCol"]
           $ limitWindows 7
           $ smartBorders
           $ windowNavigation
           $ addTabs shrinkText myTabTheme
           $ subLayout [] (smartBorders Simplest)
           $ ThreeCol 1 (3/100) (1/2)
threeColMid = renamed [Replace "threeColMid"]
           $ limitWindows 7
           $ smartBorders
           $ windowNavigation
           $ addTabs shrinkText myTabTheme
           $ subLayout [] (smartBorders Simplest)
           $ ThreeColMid 1 (3/100) (1/2)
threeRow = renamed [Replace "threeRow"]
           $ limitWindows 7
           $ smartBorders
           $ windowNavigation
           $ addTabs shrinkText myTabTheme
           $ subLayout [] (smartBorders Simplest)
           -- Mirror takes a layout and rotates it by 90 degrees.
           -- So we are applying Mirror to the ThreeCol layout.
           $ Mirror
           $ ThreeCol 1 (3/100) (1/2)
tabs     = renamed [Replace "tabs"]
           -- I cannot add spacing to this layout because it will
           -- add spacing between window and tabs which looks bad.
           $ tabbed shrinkText myTabTheme
tallAccordion  = renamed [Replace "tallAccordion"]
           $ Accordion
wideAccordion  = renamed [Replace "wideAccordion"]
           $ Mirror Accordion

-- setting colors for tabs layout and tabs sublayout.
myTabTheme = def { fontName            = myFont
                 , activeColor         = color15
                 , inactiveColor       = color08
                 , activeBorderColor   = color15
                 , inactiveBorderColor = colorBack
                 , activeTextColor     = colorBack
                 , inactiveTextColor   = color16
                 }







-- Theme for showWName which prints current workspace when you change workspaces.
myShowWNameTheme :: SWNConfig
myShowWNameTheme = def
  { swn_font              = "xft:Ubuntu:bold:size=60"
  , swn_fade              = 1.0
  , swn_bgcolor           = "#1c1f24"
  , swn_color             = "#ffffff"
  }




-- The layout hook
myLayoutHook = avoidStruts
               $ mouseResize
               $ windowArrange
               $ T.toggleLayouts floats
               $ mkToggle (NBFULL ?? NOBORDERS ?? EOT) myDefaultLayout
  where
    myDefaultLayout =  centeredSingle
                       ||| withBorder myBorderWidth tall
                       ||| noBorders monocle
                       ||| floats
                       ||| noBorders tabs
                       ||| grid
                       ||| spirals
                       ||| threeCol
                       ||| threeColMid
                       ||| threeRow
                       ||| tallAccordion
                       ||| wideAccordion
                       ||| centered



-- Loghook, setts opacity for inactive unfocused windows
myLogHook :: X ()
myLogHook = fadeInactiveLogHook fadeAmount
   where fadeAmount = 0.9




-- Workspaces, can be configured to show names instead
-- can configure by commenting out the second line, after seeing what workspace is really for what
myWorkspaces    = ["1","2","3","4","5","6","7","8","9"]
-- myWorkspaces = ["1: dev", "2: www", "3: sys", "4: doc", "5: vbox", "6: chat", "7: mus", "8: vid", "9: gfx"]

myWorkspaceIndices = M.fromList $ zipWith (,) myWorkspaces [1..] -- (,) == \x y -> (x,y)

clickable ws = "<action=xdotool key super+"++show i++">"++ws++"</action>"
    where i = fromJust $ M.lookup ws myWorkspaceIndices


-- ManageHook settings: Window rules:

-- Execute arbitrary actions and WindowSet manipulations when managing
-- a new window. You can use this to, for example, always float a
-- particular program, or have a client always appear on a particular
-- workspace.
--
-- To find the property name associated with a program, use
-- > xprop | grep WM_CLASS
-- and click on the client you're interested in.
--
-- To match on the WM_NAME, you can use 'title' in the same way that
-- 'className' and 'resource' are used below.
myManageHook :: XMonad.Query (Data.Monoid.Endo WindowSet)
myManageHook = composeAll
    [ className =? "vlc"               --> doFloat
    , className =? "confirm"           --> doFloat
    , className =? "file_progress"     --> doFloat
    , className =? "dialog"            --> doFloat
    , className =? "download"          --> doFloat
    , className =? "Conky"             --> doFloat
    , className =? "Postman"           --> doShift ( myWorkspaces !! 2 ) -- always send postman to workspace 2
    , resource  =? "desktop_window"    --> doIgnore
    , resource  =? "kdesktop"          --> doIgnore
    , (className =? "firefox" <&&> resource =? "Dialog") --> doFloat  -- Float Firefox Dialog
    , (className =? "Google-chrome" <&&> resource =? "Dialog") --> doFloat  -- Float Chrome Dialog
    , isFullscreen -->  doFullFloat

    ] <+> namedScratchpadManageHook myScratchPads



-- Keybinding settings
subtitle' ::  String -> ((KeyMask, KeySym), NamedAction)
subtitle' x = ((0,0), NamedAction $ map toUpper
                      $ sep ++ "\n-- " ++ x ++ " --\n" ++ sep)
  where
    sep = replicate (6 + length x) '-'

showKeybindings :: [((KeyMask, KeySym), NamedAction)] -> NamedAction
showKeybindings x = addName "Show Keybindings" $ io $ do
  h <- spawnPipe $ "yad --text-info --fontname=\"SauceCodePro Nerd Font Mono 12\" --fore=#46d9ff back=#282c36 --center --geometry=1200x800 --title \"XMonad keybindings\""
  --hPutStr h (unlines $ showKm x) -- showKM adds ">>" before subtitles
  hPutStr h (unlines $ showKmSimple x) -- showKmSimple doesn't add ">>" to subtitles
  hClose h
  return ()


myKeys :: XConfig l0 -> [((KeyMask, KeySym), NamedAction)]
myKeys c =
  --(subtitle "Custom Keys":) $ mkNamedKeymap c $
  let subKeys str ks = subtitle' str : mkNamedKeymap c ks in
  subKeys "Xmonad Essentials"
  [ ("M-C-r", addName "Recompile XMonad"       $ spawn "xmonad --recompile")
  , ("M-S-r", addName "Restart XMonad"         $ spawn "xmonad --restart")
  , ("M-S-q", addName "Quit XMonad"            $ io exitSuccess)
  --, ("M-S-q", addName "Quit XMonad"            $ spawn "dm-logout")
  , ("M-S-c", addName "Kill focused window"    $ kill1)
  , ("M-S-a", addName "Kill all windows on WS" $ killAll)
  , ("M-S-<Return>", addName "Run prompt"      $ spawn "dmenu_run -bw 3 -c -l 20 -h 24")
  , ("M-S-b", addName "Toggle bar show/hide"   $ sendMessage ToggleStruts)]
 -- not needed, for ArchLinux DT's post installation script help , ("M-/", addName "DTOS Help"                $ spawn "~/.local/bin/dtos-help")]

  ^++^ subKeys "Switch to workspace"
  [ ("M-1", addName "Switch to workspace 1"    $ (windows $ W.greedyView $ myWorkspaces !! 0))
  , ("M-2", addName "Switch to workspace 2"    $ (windows $ W.greedyView $ myWorkspaces !! 1))
  , ("M-3", addName "Switch to workspace 3"    $ (windows $ W.greedyView $ myWorkspaces !! 2))
  , ("M-4", addName "Switch to workspace 4"    $ (windows $ W.greedyView $ myWorkspaces !! 3))
  , ("M-5", addName "Switch to workspace 5"    $ (windows $ W.greedyView $ myWorkspaces !! 4))
  , ("M-6", addName "Switch to workspace 6"    $ (windows $ W.greedyView $ myWorkspaces !! 5))
  , ("M-7", addName "Switch to workspace 7"    $ (windows $ W.greedyView $ myWorkspaces !! 6))
  , ("M-8", addName "Switch to workspace 8"    $ (windows $ W.greedyView $ myWorkspaces !! 7))
  , ("M-9", addName "Switch to workspace 9"    $ (windows $ W.greedyView $ myWorkspaces !! 8))]

  ^++^ subKeys "Send window to workspace"
  [ ("M-S-1", addName "Send to workspace 1"    $ (windows $ W.shift $ myWorkspaces !! 0))
  , ("M-S-2", addName "Send to workspace 2"    $ (windows $ W.shift $ myWorkspaces !! 1))
  , ("M-S-3", addName "Send to workspace 3"    $ (windows $ W.shift $ myWorkspaces !! 2))
  , ("M-S-4", addName "Send to workspace 4"    $ (windows $ W.shift $ myWorkspaces !! 3))
  , ("M-S-5", addName "Send to workspace 5"    $ (windows $ W.shift $ myWorkspaces !! 4))
  , ("M-S-6", addName "Send to workspace 6"    $ (windows $ W.shift $ myWorkspaces !! 5))
  , ("M-S-7", addName "Send to workspace 7"    $ (windows $ W.shift $ myWorkspaces !! 6))
  , ("M-S-8", addName "Send to workspace 8"    $ (windows $ W.shift $ myWorkspaces !! 7))
  , ("M-S-9", addName "Send to workspace 9"    $ (windows $ W.shift $ myWorkspaces !! 8))]

  ^++^ subKeys "Move window to WS and go there"
  [ ("M-S-<Page_Up>", addName "Move window to next WS"   $ shiftTo Next nonNSP >> moveTo Next nonNSP)
  , ("M-S-<Page_Down>", addName "Move window to prev WS" $ shiftTo Prev nonNSP >> moveTo Prev nonNSP)]

  ^++^ subKeys "Window navigation"
  [ ("M-j", addName "Move focus to next window"                $ windows W.focusDown)
  , ("M-k", addName "Move focus to prev window"                $ windows W.focusUp)
  , ("M-m", addName "Move focus to master window"              $ windows W.focusMaster)
  , ("M-S-j", addName "Swap focused window with next window"   $ windows W.swapDown)
  , ("M-S-k", addName "Swap focused window with prev window"   $ windows W.swapUp)
  , ("M-S-m", addName "Swap focused window with master window" $ windows W.swapMaster)
  , ("M-<Backspace>", addName "Move focused window to master"  $ promote)
  , ("M-S-,", addName "Rotate all windows except master"       $ rotSlavesDown)
  , ("M-S-.", addName "Rotate all windows current stack"       $ rotAllDown)]

  -- Dmenu scripts (dmscripts)
  -- In Xmonad and many tiling window managers, M-p is the default keybinding to
  -- launch dmenu_run, so I've decided to use M-p plus KEY for these dmenu scripts.
  -- need additional scripts for this to work, will need to look into this
  -- ^++^ subKeys "Dmenu scripts"
  -- [ ("M-p h", addName "List all dmscripts"     $ spawn "dm-hub")
  -- , ("M-p a", addName "Choose ambient sound"   $ spawn "dm-sounds")
  -- , ("M-p b", addName "Set background"         $ spawn "dm-setbg")
  -- , ("M-p c", addName "Pick color from scheme" $ spawn "dm-colpick")
  -- , ("M-p e", addName "Edit config files"      $ spawn "dm-confedit")
  -- , ("M-p i", addName "Take a screenshot"      $ spawn "dm-maim")
  -- , ("M-p k", addName "Kill processes"         $ spawn "dm-kill")
  -- , ("M-p m", addName "View manpages"          $ spawn "dm-man")
  -- , ("M-p n", addName "Store and copy notes"   $ spawn "dm-note")
  -- , ("M-p o", addName "Browser bookmarks"      $ spawn "dm-bookman")
  -- , ("M-p p", addName "Passmenu"               $ spawn "passmenu -p \"Pass: \"")
  -- , ("M-p q", addName "Logout Menu"            $ spawn "dm-logout")
  -- , ("M-p r", addName "Listen to online radio" $ spawn "dm-radio")
  -- , ("M-p s", addName "Search various engines" $ spawn "dm-websearch")
  -- , ("M-p t", addName "Translate text"         $ spawn "dm-translate")]

  ^++^ subKeys "Favorite programs"
  [ ("M-<Return>", addName "Launch terminal"   $ spawn (myTerminal))
  , ("M-b", addName "Launch web browser"       $ spawn (myBrowser))
  , ("M-M1-h", addName "Launch htop"           $ spawn (myTerminal ++ " -e htop"))
  , ("M-M1-f", addName "Launch vifm"           $ spawn (myTerminal ++ " -e vifm"))]
  ^++^ subKeys "Monitors"
  [ ("M-.", addName "Switch focus to next monitor" $ nextScreen)
  , ("M-,", addName "Switch focus to prev monitor" $ prevScreen)]

  -- Switch layouts
  ^++^ subKeys "Switch layouts"
  [ ("M-<Tab>", addName "Switch to next layout"   $ sendMessage NextLayout)
  , ("M-<Space>", addName "Toggle noborders/full" $ sendMessage (MT.Toggle NBFULL) >> sendMessage ToggleStruts)]

  -- Window resizing
  ^++^ subKeys "Window resizing"
  [ ("M-h", addName "Shrink window"               $ sendMessage Shrink)
  , ("M-l", addName "Expand window"               $ sendMessage Expand)
  , ("M-M1-j", addName "Shrink window vertically" $ sendMessage MirrorShrink)
  , ("M-M1-k", addName "Expand window vertically" $ sendMessage MirrorExpand)]

  -- Floating windows
  ^++^ subKeys "Floating windows"
  [ ("M-f", addName "Toggle float layout"        $ sendMessage (T.Toggle "floats"))
  , ("M-t", addName "Sink a floating window"     $ withFocused $ windows . W.sink)
  , ("M-S-t", addName "Sink all floated windows" $ sinkAll)]

  -- Increase/decrease spacing (gaps)
  ^++^ subKeys "Window spacing (gaps)"
  [ ("C-M1-j", addName "Decrease window spacing" $ decWindowSpacing 4)
  , ("C-M1-k", addName "Increase window spacing" $ incWindowSpacing 4)
  , ("C-M1-h", addName "Decrease screen spacing" $ decScreenSpacing 4)
  , ("C-M1-l", addName "Increase screen spacing" $ incScreenSpacing 4)]

  -- Increase/decrease windows in the master pane or the stack
  ^++^ subKeys "Increase/decrease windows in master pane or the stack"
  [ ("M-S-<Up>", addName "Increase clients in master pane"   $ sendMessage (IncMasterN 1))
  , ("M-S-<Down>", addName "Decrease clients in master pane" $ sendMessage (IncMasterN (-1)))
  , ("M-=", addName "Increase max # of windows for layout"   $ increaseLimit)
  , ("M--", addName "Decrease max # of windows for layout"   $ decreaseLimit)]

  -- Sublayouts
  -- This is used to push windows to tabbed sublayouts, or pull them out of it.
  ^++^ subKeys "Sublayouts"
  [ ("M-C-h", addName "pullGroup L"           $ sendMessage $ pullGroup L)
  , ("M-C-l", addName "pullGroup R"           $ sendMessage $ pullGroup R)
  , ("M-C-k", addName "pullGroup U"           $ sendMessage $ pullGroup U)
  , ("M-C-j", addName "pullGroup D"           $ sendMessage $ pullGroup D)
  , ("M-C-m", addName "MergeAll"              $ withFocused (sendMessage . MergeAll))
  -- , ("M-C-u", addName "UnMerge"               $ withFocused (sendMessage . UnMerge))
  , ("M-C-/", addName "UnMergeAll"            $  withFocused (sendMessage . UnMergeAll))
  , ("M-C-.", addName "Switch focus next tab" $  onGroup W.focusUp')
  , ("M-C-,", addName "Switch focus prev tab" $  onGroup W.focusDown')]

  -- Scratchpads
  -- Toggle show/hide these programs. They run on a hidden workspace.
  -- When you toggle them to show, it brings them to current workspace.
  -- Toggle them to hide and it sends them back to hidden workspace (NSP).
  ^++^ subKeys "Scratchpads"
  [ ("M-s t", addName "Toggle scratchpad terminal"   $ namedScratchpadAction myScratchPads "terminal")
  , ("M-s m", addName "Toggle scratchpad mocp"       $ namedScratchpadAction myScratchPads "mocp")
  , ("M-<Escape>", addName "Toggle scratchpad calculator" $ namedScratchpadAction myScratchPads "calculator")]

  -- Controls for mocp music player (SUPER-u followed by a key)
  ^++^ subKeys "Mocp music player"
  [ ("M-u p", addName "mocp play"                $ spawn "mocp --play")
  , ("M-u l", addName "mocp next"                $ spawn "mocp --next")
  , ("M-u h", addName "mocp prev"                $ spawn "mocp --previous")
  , ("M-u <Space>", addName "mocp toggle pause"  $ spawn "mocp --toggle-pause")]

  ^++^ subKeys "GridSelect"
  -- , ("C-g g", addName "Select favorite apps"     $ runSelectedAction' defaultGSConfig gsCategories)
  [ ("M-M1-<Return>", addName "Select favorite apps" $ spawnSelected'
       $ gsGames ++ gsEducation ++ gsInternet ++ gsMultimedia ++ gsOffice ++ gsSettings ++ gsSystem ++ gsUtilities)
  , ("M-M1-c", addName "Select favorite apps"    $ spawnSelected' gsCategories)
  , ("M-M1-t", addName "Goto selected window"    $ goToSelected $ mygridConfig myColorizer)
  , ("M-M1-b", addName "Bring selected window"   $ bringSelected $ mygridConfig myColorizer)
  , ("M-M1-1", addName "Menu of games"           $ spawnSelected' gsGames)
  , ("M-M1-2", addName "Menu of education apps"  $ spawnSelected' gsEducation)
  , ("M-M1-3", addName "Menu of Internet apps"   $ spawnSelected' gsInternet)
  , ("M-M1-4", addName "Menu of multimedia apps" $ spawnSelected' gsMultimedia)
  , ("M-M1-5", addName "Menu of office apps"     $ spawnSelected' gsOffice)
  , ("M-M1-6", addName "Menu of settings apps"   $ spawnSelected' gsSettings)
  , ("M-M1-7", addName "Menu of system apps"     $ spawnSelected' gsSystem)
  , ("M-M1-8", addName "Menu of utilities apps"  $ spawnSelected' gsUtilities)]

  -- Multimedia Keys
  ^++^ subKeys "Multimedia keys"
  [ ("<XF86AudioPlay>", addName "mocp play"           $ spawn "mocp --play")
  , ("<XF86AudioPrev>", addName "mocp next"           $ spawn "mocp --previous")
  , ("<XF86AudioNext>", addName "mocp prev"           $ spawn "mocp --next")
  , ("<XF86AudioMute>", addName "Toggle audio mute"   $ spawn "amixer set Master toggle")
  , ("<XF86AudioLowerVolume>", addName "Lower vol"    $ spawn "amixer set Master 5%- unmute")
  , ("<XF86AudioRaiseVolume>", addName "Raise vol"    $ spawn "amixer set Master 5%+ unmute")
  , ("<XF86HomePage>", addName "Open home page"       $ spawn (myBrowser ++ " https://www.google.com/"))
  , ("<XF86Search>", addName "Web search (dmscripts)" $ spawn "dm-websearch")
  , ("<XF86Mail>", addName "Email client"             $ runOrRaise "thunderbird" (resource =? "thunderbird"))
  , ("<XF86Calculator>", addName "Calculator"         $ runOrRaise "gnome-calculator" (resource =? "gnome-calculator"))
  , ("<XF86Eject>", addName "Eject /dev/cdrom"        $ spawn "eject /dev/cdrom")
  , ("<Print>", addName "Take screenshot (dmscripts)" $ spawn "dm-maim")
  ]

  -- ^++^ [("M-s-" ++ k, addName "promptSearch"  $ S.promptSearch dtXPConfig' f ) | (k,f) <- searchList ]
  ^++^ subKeys "prompSearch"
  [("M-s g", addName "promptSearch google"  $ S.promptSearch dtXPConfig' S.google)
  ,("M-S-s g", addName "selectSearch google" $ S.selectSearch S.google)
  ]
  -- Appending search engine prompts to keybindings list.
  -- Look at "search engines" section of this config for values for "k".
 --   need to figure how to get this running
  -- ++ [("M-S-s " ++ k, S.selectSearch f) | (k,f) <- searchList ]
  -- ++ [("M-s " ++ k, S.promptSearch dtXPConfig' f) | (k,f) <- searchList ]

  -- The following lines are needed for named scratchpads.
    where nonNSP          = WSIs (return (\ws -> W.tag ws /= "NSP"))
          nonEmptyNonNSP  = WSIs (return (\ws -> isJust (W.stack ws) && W.tag ws /= "NSP"))



-- StatusBar (xmobar, provided by StatusBar and StatusBar.PP
-- used by property logging where the status bar such as xmobar needs to pick up at the root window
mySB = statusBarProp "xmobar" (pure xmobarPP)

------------------------------------------------------------------------
-- Now run xmonad with all the settings we set up.

main :: IO ()
main = do


  -- xmproc0 <- spawnPipe ("xmobar ~/.config/xmobar/xmobarrc")

  -- the xmonad, ya know...what the WM is named after!
  -- xmonad $ addDescrKeys' ((mod4Mask, xK_F1), showKeybindings) myKeys $ ewmh $ docks $ def
  xmonad . addDescrKeys' ((mod4Mask, xK_F1), showKeybindings) myKeys . withSB mySB . ewmh . docks $ def
    { manageHook         = myManageHook <+> manageDocks
    , handleEventHook    = windowedFullscreenFixEventHook <> swallowEventHook (className =? "Alacritty"  <||> className =? "Gnome-terminal" <||> className =? "XTerm") (return True) <> trayerPaddingXmobarEventHook
    , modMask            = myModMask

    , focusFollowsMouse  = myFocusFollowsMouse
    , terminal           = myTerminal
    , startupHook        = myStartupHook
    , layoutHook         = showWName' myShowWNameTheme $ myLayoutHook
    , workspaces         = myWorkspaces
    , borderWidth        = myBorderWidth
    , normalBorderColor  = myNormColor
    , focusedBorderColor = myFocusColor
    -- , logHook = dynamicLogWithPP $  filterOutWsPP [scratchpadWorkspaceTag] $ xmobarPP
    --     { ppOutput = \x -> hPutStrLn xmproc0 x   -- xmobar on monitor 1
    --     , ppCurrent = xmobarColor color06 "" . wrap
    --                   ("<box type=Bottom width=2 mb=2 color=" ++ color06 ++ ">") "</box>"
    --       -- Visible but not current workspace
    --     , ppVisible = xmobarColor color06 "" . clickable
    --       -- Hidden workspace
    --     , ppHidden = xmobarColor color05 "" . wrap
    --                  ("<box type=Top width=2 mt=2 color=" ++ color05 ++ ">") "</box>" . clickable
    --       -- Hidden workspaces (no windows)
    --     , ppHiddenNoWindows = xmobarColor color05 ""  . clickable
    --       -- Title of active window
    --     , ppTitle = xmobarColor color16 "" . shorten 60
    --       -- Separator character
    --     , ppSep =  "<fc=" ++ color09 ++ "> <fn=1>|</fn> </fc>"
    --       -- Urgent workspace
    --     , ppUrgent = xmobarColor color02 "" . wrap "!" "!"
    --       -- Adding # of windows on current workspace to the bar
    --     , ppExtras  = [windowCount]
    --       -- order of things in xmobar
    --     , ppOrder  = \(ws:l:t:ex) -> [ws,l]++ex++[t]
    --     }
     }
