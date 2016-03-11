; Clicker Heroes Steam Version AutoHotkey script
; Version: 0.3
; Date: 5/28/2015
; Author: Andrux51 (http://github.com/Andrux51)
;
; This script will auto-click the Clicker Heroes game window while attempting
; to collect all "clickables" (currently Easter Eggs) including the moving one.
; The clicks per second should average roughly 50 consistently.
; (browser version... steam version avg. cps unknown)
; Other scripts may spike higher (I got as high as 90) but that is inconsistent.
; 
; The script will not attempt to use skills in this version.
; These features may be added in the future but are not a priority for now.
;
; Instructions:
; - Run .ahk file
; - F7 will begin (and resume when paused) the clicker
; - F8 will pause the clicker
; - F9 will run at 1/4 speed (makes it easier to click for levels etc)
; - F10 will exit the script entirely
; - F11 will level the 4th character in the list (same position as Brittany by default)
; 
; Change "timing" variable to suit your needs if the script is running too fast or slow.
;

#SingleInstance force ; if script is opened again, replace instance
#Persistent ; script stays in memory until ExitApp is called or script crashes

global title := "Clicker Heroes" ; we will exact match against this for steam version
global stop := false

; change this value to adjust script speed (milliseconds)
global timing := 75

; pass in frequency to check for clickables
; ; higher number means more clicks on moving clickable, less often for other clickables
global frequency := 0

; F7 will begin/resume the auto-clicker
F7::
    frequency := 50
    slacktivate(timing, frequency, false)
    return

; F11 will begin/resume the auto-clicker and level the 4th hero on the list
F11::
    frequency := 15
    slacktivate(timing, frequency, true)
    return

; F8 will pause the auto-clicker
F8::
    stop := true
    return

; F9 will allow for time to buy guys/skills etc without losing combo
F9::
    frequency := 1
    slacktivate(timing * 4, frequency, false)
    return

; F10 will exit the script entirely
F10::
    ExitApp
    return

; pass in milliseconds to adjust click speed
slacktivate(milli, p, levelup) {
    stop := false

    ; We get the title match for the Clicker Heroes game window
    setDefaults()

    i = 0
    ; Send clicks to CH while the script is active (press F8 to stop)
    while(!stop) {
        ; try to catch skill bonus clickable
        ; high priority- this requires a lot of focused clicks
        getSkillBonusClickable()

        ; low priority- other clickables are moderately rare
        if(i > p) {
            ; try to get other clickables
            getClickables()

            ; use abilities to power up
            useAbilities()

            ; if the script is set to level up the hero, do that here
            if(levelup) {
                clickHeroInSlot(4, 25)
                ControlClick,, %title%,,,, x190 y590 NA
                ControlClick,, %title%,,,, x226 y590 NA
                ControlClick,, %title%,,,, x262 y590 NA
                ControlClick,, %title%,,,, x298 y590 NA
            }
            i = 0
        }

        i++
        Sleep milli
    }

    return
}

useAbilities() {
    ; TODO: use abilities at more appropriate times
    ; Combos: 123457, 1234, 12

    useAbility1()
    useAbility2()
    useAbility3()
    useAbility4()
    useAbility8()
    useAbility5()
    ;useAbility9() ; need to not press 5 again after Reload happens (Reload is currently wasted)
    useAbility7()

    return
}

useAbility1() {
    ; 1. Clickstorm
    ControlClick,, %title%,,,, x600 y170 NA
    return
}
useAbility2() {
    ; 2. Powersurge
    ControlClick,, %title%,,,, x600 y220 NA
    return
}
useAbility3() {
    ; 3. Lucky Strikes
    ControlClick,, %title%,,,, x600 y270 NA
    return
}
useAbility4() {
    ; 4. Metal Detector
    ControlClick,, %title%,,,, x600 y325 NA
    return
}
useAbility5() {
    ; 5. Golden Clicks
    ControlClick,, %title%,,,, x600 y375 NA
    return
}
useAbility6() {
    ; 6. Dark Ritual
    ControlClick,, %title%,,,, x600 y425 NA
    return
}
useAbility7() {
    ; 7. Super Clicks
    ControlClick,, %title%,,,, x600 y480 NA
    return
}
useAbility8() {
    ; 8. Energize
    ControlClick,, %title%,,,, x600 y530 NA
    return
}
useAbility9() {
    ; 9. Reload (best after Golden Clicks or Lucky Strikes?)
    ControlClick,, %title%,,,, x600 y580 NA
    return
}

getSkillBonusClickable() {
    ; click in a sequential area to try to catch mobile clickable
    ControlClick,, %title%,,,, x770 y130 NA
    ControlClick,, %title%,,,, x790 y130 NA
    ControlClick,, %title%,,,, x870 y130 NA
    ControlClick,, %title%,,,, x890 y130 NA
    ControlClick,, %title%,,,, x970 y130 NA
    ControlClick,, %title%,,,, x990 y130 NA

    return
}

getClickables() {
    ; clickable positions
    ControlClick,, %title%,,,, x505 y460 NA
    ControlClick,, %title%,,,, x730 y400 NA
    ControlClick,, %title%,,,, x745 y450 NA
    ControlClick,, %title%,,,, x745 y340 NA
    ControlClick,, %title%,,,, x850 y480 NA
    ControlClick,, %title%,,,, x990 y425 NA
    ControlClick,, %title%,,,, x1030 y410 NA

    return
}

F2::
    setDefaults()
    doMidasStart()
    return

setDefaults() {
    SendMode InputThenPlay
    CoordMode, Mouse, Client
    SetKeyDelay, 0, 0
    SetMouseDelay 1 ; anything lower becomes unreliable for scrolling
    SetControlDelay 1 ; anything lower becomes unreliable for scrolling
    SetTitleMatchMode 3 ; window title is an exact match of the string supplied

    return
}

clickDownArrow(times) {
    i = 0
    while(i < times) {
        ControlClick,, %title%,,,, x545 y625 NA
        Sleep 350
        i++
    }

    return
}

clickForwardArrow(times) {
    ControlClick,, %title%,,, %times%, x1035 y40 NA
    return
}

clickZone() {
    ControlClick,, %title%,,,, x980 y40 NA
    return
}

clickHeroInSlot(slot, times) {
    if(slot = 1) {
        ControlClick,, %title%,,, %times%, x50 y250 NA
    }
    if(slot = 2) {
        ControlClick,, %title%,,, %times%, x50 y356 NA
    }
    if(slot = 3) {
        ControlClick,, %title%,,, %times%, x50 y462 NA
    }
    if(slot = 4) {
        ControlClick,, %title%,,, %times%, x50 y568 NA
    }
    return
}

slacktivation() {
    setDefaults()

    return
}

global looper := 0

getNatalia() {
    ; with Khrysos maxed, Natalia is near the bottom of the list after ascension
    scrollToListBottom()

    clickHeroInSlot(2, 1)

    return
}

scrollToFarmZone(zone) {
    ; subtract 3 because zone 3 is already on screen,
    ; so it takes 3 less clicks to get there than the zone number
    clicksToFarmZone := zone - 3
    while(looper < clicksToFarmZone) {
        clickForwardArrow(1)
        Sleep 5
        looper++
    }

    ; let the screen catch up, then go to zone
    Sleep 300
    clickZone()

    ; reset the looping variable so we can reuse it
    looper := 0

    return
}

scrollToMidas() {
    ; the number of clicks to scroll to Midas
    ;clicksToMidas := 9
    ;clickDownArrow(clicksToMidas)

    ; ControlClick,, %title%,,, %times%, x545 y490 NA

    ControlClick,, %title%,,,, x545 y494 NA
    
    ; let the screen catch up, then buy
    Sleep 300
    clickHeroInSlot(4, 1)

    return
}

levelMidasUp() {
    ; since we already have one level for Midas, we only need 99 more
    while(looper < 15) {
        collectGold()
        clickHeroInSlot(4, 10)
        Sleep 1
        looper++
    }

    ; reset the looping variable so we can reuse it
    looper := 0

    return
}

buyMidasUpgrades() {
    ; buy all 5 upgrades to Midas
    ControlClick,, %title%,,,, x190 y570 NA
    Sleep 5
    ControlClick,, %title%,,,, x226 y570 NA
    Sleep 5
    ControlClick,, %title%,,,, x262 y570 NA
    Sleep 5
    ControlClick,, %title%,,,, x298 y570 NA
    Sleep 5
    ControlClick,, %title%,,,, x334 y570 NA
    
    return
}

collectGold() {
    ControlClick,, %title%,,,, d x760 y420 NA
    Sleep 5
    ControlClick,, %title%,,,, d x800 y420 NA
    Sleep 5
    ControlClick,, %title%,,,, d x850 y420 NA
    Sleep 5
    ControlClick,, %title%,,,, d x910 y420 NA
    Sleep 5
    ControlClick,, %title%,,,, u x5 y300 NA

    return
}

; Before running this function, Idle mode should be engaged
; (have Siyalatas & no clicks for 1 minute)
doMidasStart() {
    ; milliseconds to wait before gathering gold
    waitForGold := 10000

    ; 1. Scroll to a (non-boss) level in the 60's to farm some quick gold
    scrollToFarmZone(61)
    Sleep 500

    ; 2. Scroll down to  Natalia and buy a single level
    getNatalia()

    ; 3. Pause for a moment to let gold rack up to buy Midas
    ; *important* You can't scroll down until some gold has been collected
    ; - try not to collect too much or it will skew the scroll bar
    Sleep %waitForGold%
    collectGold()
    Sleep 2000

    ; 4. Scroll down to Midas and buy a single level
    scrollToMidas()

    ; 5. Collect gold so we can buy 100 levels of Midas
    Sleep %waitForGold%/3
    collectGold()
    Sleep 300

    ; 6. Level Midas to 100 and buy his abilities (golden clicks esp.)
    levelMidasUp()
    buyMidasUpgrades()

    ; 7. Turn on Progression Mode to go to the highest available level
    ControlClick,, %title%,,,, x1110 y250 NA

    ; 8. Use Golden Clicks to rack up a ton of gold very quickly
    useAbility5()

    getSkillBonusClickable()
    getClickables()

    Sleep 100

    ; 9. Level up all the early heroes for bonuses like crit clicks, dps %, etc.
    levelAllHeroes()

    Sleep 500
    ControlClick,, %title%,,,, x545 y544 NA
    Sleep 500

    ; 10. Turn on auto-clicker. You should now scroll to your gilded hero and buy it up!
    Send {F11}

    ; 11. This function could be more complete if it scrolled to the gilded hero
    ; but since scroll speed changes with the amount of moneys, it's difficult
    ; (rake it in)
    ; down arrow 19x @555, 650
    ; ctrl-click @ gilded hero position (Frostleaf)
    ; click through upgrades

    return
}

levelAllHeroes() {
    scrollToListTop()

    ; buy 200 levels at a time
    ; something has to be better than doing it this way...
    ; ControlSend messes up other keyboard usage when it's happening
    clickHeroInSlot(1, 100)
    clickHeroInSlot(2, 100)
    clickHeroInSlot(3, 100)
    clickHeroInSlot(4, 100)

    Sleep 500
    ControlClick,, %title%,,,, x545 y298 NA
    Sleep 500
    clickHeroInSlot(1, 100)
    clickHeroInSlot(2, 100)
    clickHeroInSlot(3, 100)
    clickHeroInSlot(4, 100)

    Sleep 500
    ControlClick,, %title%,,,, x545 y350 NA
    Sleep 500
    clickHeroInSlot(1, 100)
    clickHeroInSlot(2, 100)
    clickHeroInSlot(3, 100)
    clickHeroInSlot(4, 100)

    Sleep 500
    ControlClick,, %title%,,,, x545 y402 NA
    Sleep 500
    clickHeroInSlot(1, 100)
    clickHeroInSlot(2, 100)
    clickHeroInSlot(3, 100)
    clickHeroInSlot(4, 25) ; Midas

    Sleep 500
    ControlClick,, %title%,,,, x545 y454 NA
    Sleep 500
    clickHeroInSlot(1, 125)
    clickHeroInSlot(2, 100)
    clickHeroInSlot(3, 100)
    clickHeroInSlot(4, 150)

    Sleep 500
    ControlClick,, %title%,,,, x545 y506 NA
    Sleep 500
    clickHeroInSlot(1, 100)
    clickHeroInSlot(2, 100)
    clickHeroInSlot(3, 100)
    clickHeroInSlot(4, 100)

    Sleep 500
    scrollToListBottom()
    clickHeroInSlot(1, 100)
    clickHeroInSlot(2, 100)



    ; at this point everyone is leveled down to Atlas

    ; Buy all available upgrades
    Sleep 300
    ControlClick,, %title%,,,, x280 y550 NA

    return
}

scrollToListTop() {
    ; scroll to the top of the hero list
    ControlClick,, %title%,,,, x545 y208 NA
    ; This pause is needed so the screen can catch up
    Sleep 350
    return
}

scrollToListBottom() {
    ; Scroll to far bottom of the hero list
    ControlClick,, %title%,,,, x545 y605 NA
    ; This pause is needed so the screen can catch up
    Sleep 350
    return
}
