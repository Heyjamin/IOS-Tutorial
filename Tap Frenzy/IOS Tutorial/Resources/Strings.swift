//
//  Strings.swift
//  IOS Tutorial
//
//  Created by G P M A Nuwan Jeewantha on 2026-07-12.
//
import Foundation
import SwiftUI

struct Const {

  // App Navigation
  static let Home = "Home"
  static let Status = "Status"
  static let Map = "Map"
  static let Settings = "Settings"

  static let txtNeonArcade = "NEON ARCADE"
  static let txtWelcome = "Welcome to the Neon Arcade"
  static let txtEnterName = "Enter your name"
  static let txtSavePlayer = "SAVE PLAYER"

  // Keys
  static let txtLightItUpHighestScore = "LightItUpHighestScore"
  static let txtCurrentPlayer = "currentPlayer"
  static let txtHighestScore = "HighestScore"
  static let txtSfxEnabled = "audioSfxEnabled"
  static let txtMusicEnabled = "audioMusicEnabled"
  static let txtVolume = "audioVolume"
  static let txtStorageKey = "dailyChallengeStore"
  static let txtLevelProgressStore = "levelProgressStore"
  static let txtDailyChallengeId = "dailyChallenge"
  static let txtGameSessions = "gameSessions"
  static let txtDailyChallengeEnabled = "dailyChallengeEnabled"
  static let txtDailyChallengeHour = "dailyChallengeHour"
  static let txtDailyChallengeMinutes = "dailyChallengeMinutes"

  // Icons
  static let tapFrenzyIcon = "bolt.fill"
  static let lightItUpIcon = "square.grid.3x3.fill"
  static let quizRushIcon = "questionmark.circle.fill"

  static let playIcon = "play.fill"
  static let checkmarkIcon = "checkmark.seal.fill"
  static let checkmarkIcon2 = "checkmark"
  static let targetIcon = "target"
  static let flameFillIcon = "flame.fill"
  static let xmarkIcon = "xmark.seal"
  static let calendarBadgeIcon = "calendar.badge.clock"
  static let starCircleIcon = "star.circle.fill"
  static let starFillIcon = "star.fill"
  static let starIcon = "star"
  static let boltFillIcon = "bolt.fill"
  static let trophyIcon = "trophy.fill"
  static let trapsIcon = "exclamationmark.triangle.fill"
  static let hintIcon = "lightbulb.fill"
  static let guideIcon = "book.fill"
  static let squareAndArrowIcon = "square.and.arrow.up"
  static let timerIcon = "timer"
  static let plusCircleIcon = "plus.circle"
  static let minusCircleIcon = "minus.circle"
  static let wiFiExclamationIcon = "wifi.exclamationmark"
  static let listNumberIcon = "list.number"
  static let sparklesIcon = "sparkles"
  static let gameControllerIcon = "gamecontroller"
  static let chartBarIcon = "chart.bar"
  static let mapIcon = "map"
  static let gearIcon = "gear"
  static let flagIcon = "flag.checkered"
  static let arrowRightCircleIcon = "arrow.right.circle.fill"
  static let arrowClockwiseIcon = "arrow.clockwise"
  static let mappingElepseIcon = "mappin.and.ellipse"
  static let speekerFillIcon = "speeker.fill"
  static let sumIcon = "sum"
  

  // Music Icons
  static let musicIcon = "music.note"
  static let speakerIcon = "speaker.wave.2"
  static let speakerFillIcon = "speaker.fill"
  static let speakerMuteIcon = "speaker.slash.fill"
  // Text

  // Guide Titles
  static let txtHowToWin = "How to Win"
  static let txtBonuses = "Bonuses"
  static let txtBonus = "🌟 Bonus"
  static let txtHints = "Hints"
  static let txtTraps = "Traps"  
  static let txtGuide = "Guide"
  static let txtTrap = "💣 Trap"

  // Home
  static let txtHomeTitle = "NEON ARCADE"

  // Level Worlds
  static let world1 = "Neon Meadow"
  static let world2 = "Crystal cian"
  static let world3 = "Sunset Arena"
  static let world4 = "Volcano Core"
  static let world5 = "Cosmos Void"

  // Result Message
  static let msgPerfect = "🏆 Perfect Quiz!"
  static let msgExcellent = "🎉 Excellent!"
  static let msgWellDone = "🎈 Well Done!"
  static let msgLevelCleared = "👍 Level Cleared!"
  static let msgKeepPracticing = "💪 Keep Practicing!"

  // Tap Frenzy

  static let txtTapFrenzy = "TAP FRENZY"
  static let txtTapFrenzySubTitile = "Speed challenge"
  static let txtTapFrenzyInfo = "tapFrenzy"

  static let tapFrenzyHowToWin = [
      "Tap the emoji target as fast as you can before the timer hits zero.",
      "Each correct tap adds points based on your combo multiplier.",
      "Tap quickly in a row (within 0.5s) to build combo up to ×10.",
      "Earn ⭐⭐⭐ (3 stars) or more to unlock the next level.",
      "Higher score = more stars — check the target on screen.",
  ]

  static let tapFrenzyBonuses = [
      "✨ 🌟 💎 🎯 💫 ⚡ 🚀 🪎 🏆 👑 — bonus emojis give extra points on top of combo.",
      "Bonus emojis appear randomly — tap them quickly!",
  ]

  static let tapFrenzyTraps = ["☠️ 😡 🧨 💥 💀 😈 👹— trap emojis subtract your combo value from score.",
                        "The emoji moves around and shrinks as time runs out — stay focused!",
                        "Missing taps costs nothing, but traps will pull your score down.",]

  // Game Levels
  static let txtTFSubL1 = "Warm Up"
  static let txtTFSubL2 = "Getting Faster"
  static let txtTFSubL3 = "Combo Zone"
  static let txtTFSubL4 = "Chaos Mode"
  static let txtTFSubL5 = "Speed Rush"
  static let txtTFSubL6 = "Hyper Tap"
  static let txtTFSubL7 = "Blur Speed"
  static let txtTFSubL8 = "Frenzy Mode"
  static let txtTFSubL9 = "Insane Combo"
  static let txtTFSubL10 = "Ultimate Legend"


  // Light It Up

  static let txtLightItUp = "Light It Up"
  static let txtLightItUpSubTitle = "Memory Game"
  static let txtLightItUpInfo = "lightItUp"

  static let lightItUpHowToWin = [
                        "Tap the lit cell when an emoji appears on the grid.",
                        "Normal cells 🖐️ give +1 point each.",
                        "Score as much as you can before the countdown ends.",
                        "Earn ⭐⭐⭐ (3 stars) or more to unlock the next level.",
                    ]

  static let lightItUpBonuses = [
                        "🌟 Bonus cells give extra points (varies by level).",
                        "They glow green — tap them before they disappear!",
                    ]

  static let lightItUpTraps =  [
                        "💣 Trap cells subtract points — they glow red.",
                        "Tapping a dark / unlit cell costs −1 point.",
                        "Cells only stay visible for a short time — react fast!",
                        "Higher levels add more traps and a bigger grid.",
                    ]

   static let txtPointOne = "+1 🖐️"
   static let txtBonusPoint = "🌟 BONUS +"
   static let txtTrapPenalty = "💣 TRAP -"

   // Game Levels
  static let txtLIUSubL1 = "First Lights"
  static let txtLIUSubL2 = "Quick Hands"
  static let txtLIUSubL3 = "Soft Glow"
  static let txtLIUSubL4 = "Trap Alley"
  static let txtLIUSubL5 = "Danger Grid"
  static let txtLIUSubL6 = "Speed Grid"
  static let txtLIUSubL7 = "Flash Matrix"
  static let txtLIUSubL8 = "Inferno Titles"
  static let txtLIUSubL9 = "Nightmare Grid"
  static let txtLIUSubL10 = "Master Grid"

  // Quiz Rush 

  static let txtQuizRush = "Quiz Rush"
  static let txtQuizRushSubTitle = "Live Trivia"
  static let txtQuizRushInfo = "quizRush"

  static let quizRushHowToWin = [
                        "Pick the correct answer for each trivia question.",
                        "Correct answer: 10 base pts + streak bonus (streak × 2).",
                        "Answer faster to earn a speed bonus — watch the timer bar!",
                        "Complete all questions with the highest score you can.",
                        "Earn ⭐⭐⭐ (3 stars) or more to unlock the next level.",
                    ]

  static let quizRushBonuses = [
                        "Each question has a countdown timer.",
                        "More time left = bigger speed bonus on correct answers.",
                        "Higher levels give less time but bigger max bonuses.",
                    ]

  static let quizRushHints = [
                        "Easy (L1–3): 3 hints — tap Use Hint on any question you choose.",
                        "1st hint = category · 2nd = first letter · 3rd = 50/50 answers.",
                        "Medium (L4–7): 3 random hints appear automatically on random questions.",
                        "Hard (L8–10): No hints — you're on your own!",
                    ]

  static let quizRushTraps = [
                        "Wrong answer: −5 points and your streak resets to zero.",
                        "Timer runs out: counts as wrong (−5 pts), correct answer shown.",
                        "Don't rush blindly — a wrong tap hurts more than a slow correct one.",
                    ]

  static let txtQuizCompleted = "Quiz Completed"
  static let txtLoadingQuestions = "Loading Questions..."
  static let txtUnableToLoadQuiz = "Unable to load questions"
  static let txtRetry = "Retry"
  static let txtUseHint = "Use Hint"
  static let txtLeft = "left"
   
  static let txtQRInstructions = "💡 Check the answer choices carefully"
  static let txtStartsWith = "💡 Starts with"
  static let txtCharactors = "characters"
  static let txtCategory = "💡 Category:"
  static let txtFifyFifty = "💡 50/50 — two wrong answers removed"

  // Game Levels
  static let txtQRSubL1 = "Warm-Up Quiz"
  static let txtQRSubL2 = "Brain Boost"
  static let txtQRSubL3 = "Think Fast"
  static let txtQRSubL4 = "Quick Recall"
  static let txtQRSubL5 = "Expert Round"
  static let txtQRSubL6 = "Brain Storm"
  static let txtQRSubL7 = "Rapid Fire"
  static let txtQRSubL8 = "Genius Only"
  static let txtQRSubL9 = "Mind Blitz"
  static let txtQRSubL10 = "Ultimate Quiz"

  // Share Card
  static let txtIErned = "I earned "
  static let txtIScored = "I scored "
  static let txtStarOn = "⭐ on"
  static let txtOn = "on"
  static let txtLevel = "lvel"
  static let txtWith = "with"
  static let txtPtsInNeonArc = "pts in Neon Archade! 🎮"
  static let txtInNeonArc = " in Neon Archade! 🎮"
  static let txtPoints = " points"
  static let txtShareCardFooter = "Neon Archade . iOS"
  static let txtShare = "Share"
  static let txtShareScore = "Share Score"
  static let txtLevelCompleted = "level completed"
  static let txtToKeepStreak = "to keep streak"
  static let txtBase = "base"
  static let txtSpeedBonus = "speed bonus!"
  static let txtTimesUp = "⏰ Time's up! −5 pts"
  static let txtWrong = "❌ Wrong! −5 pts"
  static let txtLocationError = "❌ Location Error:"

  // Game worlds
  static let sunsetArena = "Sunset Arena"

  // Game World Subtitles
  static let comboZone = "Combo Zone"

  // General Text
  static let txtDailyChallenge = "Daily Challenge"
  static let txtDailyChallenges = "Daily Challenges"
  static let txtCompleteStrak = "Complete! \(flame) Streak: "
  static let txtDays = "days"
  static let txtTarget = "Target"
  static let txtReachedStreak = "reached! Streak: "
  static let txtNeeded = "Needed"
  static let txtPtsHortBy = "pts . hort by"
  static let txtD = "d"
  static let txtQ = "Q"
  static let txtL = "L"
  static let txt3CompletedToday = "/3 completed today"
  static let txtAllDayChallengesCompleted = "all daily challenges colpleted! 🎉"
  static let txtDone = "Done"
  static let txtGameGuide = "Game guide"
  static let txtScore = "Score"
  static let txtTime = "time"
  static let txtTimer = "Timer"
  static let txtStreak = "Streak"
  static let txtLevelComplete = "Level Complete"
  static let txtNewRecord = "New Record!"
  static let txtComboX = "COMBO ×"
  static let txtNormal = "normal"
  static let txtLevels = "levels"
  static let txtStarsEarned = " STARS EARNED"
  static let txtStarsToUnlock = "+ for ⭐⭐⭐ to unlock next level"
  static let txtNextLevelUnlocked = "Next level unlocked! Tap Next Level to continue."
  static let txtNextLevel = "Next Level"
  static let txtPlayAgain = "Play Again"
  static let txtFinalScore = "FINAL SCORE"
  static let txtBest = "BEST"
  static let txtGameOver = "GAME OVER"
  static let txtNiceRun = "Nice run!"
  static let txtReadyToPlay = "Ready to play,"
  static let txtArcadeGames = "Arcade Games"
  static let txtGames = "Games"
  static let txtSriLanka = "Sri Lanka"
  static let txtMapDescription = "Play a game to score pins on the map"
  static let txtPts = "pts"
  static let txtStats = "Stats"
  static let txtNoStatsYet = "No Stats Yet"
  static let txtNoStatsMsg = "Complete a game to see your stats here"
  static let txtPersonalBests = "Personal Bests"
  static let txtScoresBySession = "Scores by Session"
  static let txtMode = "Mode"
  static let txtRecentGames = "Recent Games"

  // Quiz Rush Quize Category 
  static let txtGeneralKonwledge = "General Knowledge"

  // Music Control

  static let txtSoundSettings = "Sound Settings"
  static let txtBackgroundMusic = "Background Music"
  static let txtSoundEffects = "Sound Effects"
  static let txtAudioError = "Audio session error: "
  static let txtMissingMusicFile = "Missing music file: "
  static let txtMusicPlaybackError = "Music playback error:"
  static let txtSfxError = "SFX Error:"

  // Session Store

  static let txtSessionSaveError = "SessionStore save error: "

  // Notification

  static let msgDailyChallenge = "Daily Archade Challenge"
  static let msgDailyChallengeBody = "Your daily arcade challenge is waiting! 🎮"

  // Timer Formats
  static let timerFormat = "%.1fs"
  static let timerCountDownFormat = "%02d.%02d"
  static let dateFormat = "%04d-%02d-%02d"

  // HtmlDecodingPatten
  static let selfPattern = "&#x([0-9A-Fa-f]+);"
  static let resultPattern = "&#(\\d+);"

  // Coordinate Format
  static let coodinateFormat = "%.4f°, %.4f°"

  // Settings Tab
  static let txtAudio = "Audio"
  static let txtVolumeSetting = "Volume"
  static let txtPlayer = "Player"
  static let txtCurrentPlayerName = "Current Player"
  static let txtChangePlayer = "Change Player"
  static let txtMasterStreak = "Master Streak"
  static let txtResetDailyChallenges = "Reset Daily Challenges"
  static let txtEnableNotifications = "Enable Notifications" 
  static let txtChallengeTime = "Challenge Time"
  static let txtData = "Data"
  static let txtResetAllStats = "Reset All Stats"
  static let txtResetChallenges = "Reset Challenges"
  static let txtResetLevelProg = "Reset Level Progress"
  static let txtResetLevels = "Reset Levels"
  static let txtAbout = "About"
  static let txtGameDescription = "Mini-Game Collection"
  static let txtVersion = "Version"
  static let txtCreatedBy = "Nuwan Jeewantha"
  static let txtIndexNo = "COBSCCOMP251P-045"
  static let txtStudentModule = "Student - NIBM iOS Module"
  static let txtSettings = "Settings"
  static let txtCancel = "Cancel"
  static let txtTotal = "Total"

  // Confirmations
  static let txtResetStatConf = "Reset all game stats?"
  static let txtPermenetDeletConfMsg = "This permenetly deletes all saved game sessions."
  static let txtResetDailyChallengeConf = "Reset daily challenges?"
  static let txtResetStreakResetConfMsg = "All streaks and today's progress will restart from zero."
  static let txtResetAllLevelProgConf = "Reset all level progress?"
  static let txtResetLevelConfMsg = "All level stars and unlocks will be reset. Level 1 stays open."


  // Color Name
  static let txtYellow = "yellow"
  static let txtBlue = "blue"
  static let txtPurple = "purple"
  static let txtGreen = "green"

  // Emoji
  static let flame = "🔥"
  static let light = "💡"
  static let brain = "🧠"
  static let correct = "✅"
  static let bomb = "💣"
  static let barchart = "📊"
  
  
  // Penalty Emoji
  static let danger = "☠️"
  static let angree = "😡"
  static let tnt = "🧨"
  static let blast = "💥"
  static let zombi = "💀"
  static let hornDevil = "😈"
  static let devil = "👹"

  // Normal Emoji
  static let hand = "🖐️"
  static let smile1 = "😀"
  static let smile2 = "🙂"
  static let smile3 = "😁"
  static let bless = "😇"
  static let happyHand = "🤗"
  static let happy = "☺️"
  static let love = "🥰"
  static let fantastic = "🤩"

  // Bonus Emoji
  static let sparkels = "✨"
  static let starFlash = "🌟"
  static let gem = "💎"
  static let target = "🎯"
  static let starCircle = "💫"
  static let flash = "⚡"
  static let rocket = "🚀"
  static let tresure = "🪎"
  static let trophy = "🏆"
  static let crown = "👑"

  // World Emoji
  static let meadow = "🌾"
  static let ocian = "🌊"
  static let sunset = "🌅"
  static let cosmos = "🌌"
  static let volcano = "🌋"

static let htmlNamedEntities: [(String, String)] = [
        ("&amp;", "&"),
        ("&quot;", "\""),
        ("&apos;", "'"),
        ("&#039;", "'"),
        ("&#39;", "'"),
        ("&lt;", "<"),
        ("&gt;", ">"),
        ("&nbsp;", " "),
        ("&rsquo;", "'"),
        ("&lsquo;", "'"),
        ("&rdquo;", "\""),
        ("&ldquo;", "\""),
        ("&hellip;", "…"),
        ("&mdash;", "—"),
        ("&ndash;", "–"),
        ("&eacute;", "é"),
        ("&Eacute;", "É"),
        ("&egrave;", "è"),
        ("&Egrave;", "È"),
        ("&ecirc;", "ê"),
        ("&Ecirc;", "Ê"),
        ("&euml;", "ë"),
        ("&Euml;", "Ë"),
        ("&aacute;", "á"),
        ("&Aacute;", "Á"),
        ("&agrave;", "à"),
        ("&Agrave;", "À"),
        ("&acirc;", "â"),
        ("&Acirc;", "Â"),
        ("&auml;", "ä"),
        ("&Auml;", "Ä"),
        ("&aring;", "å"),
        ("&Aring;", "Å"),
        ("&iacute;", "í"),
        ("&Iacute;", "Í"),
        ("&igrave;", "ì"),
        ("&Igrave;", "Ì"),
        ("&icirc;", "î"),
        ("&Icirc;", "Î"),
        ("&iuml;", "ï"),
        ("&Iuml;", "Ï"),
        ("&oacute;", "ó"),
        ("&Oacute;", "Ó"),
        ("&ograve;", "ò"),
        ("&Ograve;", "Ò"),
        ("&ocirc;", "ô"),
        ("&Ocirc;", "Ô"),
        ("&ouml;", "ö"),
        ("&Ouml;", "Ö"),
        ("&oslash;", "ø"),
        ("&Oslash;", "Ø"),
        ("&uacute;", "ú"),
        ("&Uacute;", "Ú"),
        ("&ugrave;", "ù"),
        ("&Ugrave;", "Ù"),
        ("&ucirc;", "û"),
        ("&Ucirc;", "Û"),
        ("&uuml;", "ü"),
        ("&Uuml;", "Ü"),
        ("&ntilde;", "ñ"),
        ("&Ntilde;", "Ñ"),
        ("&ccedil;", "ç"),
        ("&Ccedil;", "Ç"),
        ("&yacute;", "ý"),
        ("&Yacute;", "Ý"),
        ("&szlig;", "ß"),
        ("&eth;", "ð"),
        ("&ETH;", "Ð"),
        ("&thorn;", "þ"),
        ("&THORN;", "Þ"),
        ("&pi;", "π"),
        ("&deg;", "°"),
        ("&copy;", "©"),
        ("&reg;", "®"),
        ("&trade;", "™"),
        ("&cent;", "¢"),
        ("&pound;", "£"),
        ("&euro;", "€"),
        ("&yen;", "¥"),
        ("&iquest;", "¿"),
        ("&iexcl;", "¡"),
        ("&bull;", "•"),
        ("&middot;", "·"),
    ]

}

