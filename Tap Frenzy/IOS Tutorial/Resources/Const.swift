//
//  Strings.swift
//  IOS Tutorial
//
//  Created by G P M A Nuwan Jeewantha on 2026-07-12.
//
import Foundation
import SwiftUI

struct Const {

  // Keys
  static let txtLightItUpHighestScore = "LightItUpHighestScore"
  static let txtCurrentPlayer = "currentPlayer"

  // Icons
  static let tapFrenzyIcon = "bolt.fill"
  static let lightItUpIcon = "square.grid.3x3.fill"
  static let quizRushIcon = "questionmark.circle.fill"

  static let playIcon = "play.fill"
  static let checkmarkIcon = "checkmark.seal.fill"
  static let checkmarkIcon2 = "checkmark"
  static let targetIcon = "target"
  static let flameIcon = "flame.fill"
  static let xmarkIcon = "xmark.seal"
  static let calendarBadgeIcon = "calendar.badge.clock"
  static let starCircleIcon = "star.circle.fill"
  static let starFillIcon = "star.fill"
  static let starIcon = "star"
  static let boltFill = "bolt.fill"
  static let trophyIcon = "trophy.fill"
  static let trapsIcon = "exclamationmark.triangle.fill"
  static let hintIcon = "lightbulb.fill"
  static let guideIcon = "book.fill"
  static let squareAndArrowIcon = "square.and.arrow.up"
  static let timerIcon = "timer"
  static let plusCircleIcon = "plus.circle"

  // Music Icons
  static let musicIcon = "music.note"
  static let speakerIcon = "speaker.wave.2"
  static let speakerFillIcon = "speaker.fill"
  static let speakerMuteIcon = "speaker.slash.fill"
  // Text

  // Guide Titles
  static let txtHowToWin = "How to Win"
  static let txtBonuses = "Bonuses"
  static let txtBonus = "⭐ Bonus"
  static let txtHints = "Hints"
  static let txtTraps = "Traps"  
  static let txtGuide = "Guide"

  // Home
  static let txtHomeTitle = "NEON ARCADE"

  // Tap Frenzy

  static let txtTapFrenzy = "TAP FRENZY"
  static let txtTapFrenzySubTitile = "Speed challenge"

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

  // Light It Up

  static let txtLightItUp = "Light It Up"
  static let txtLightItUpSubTitle = "Memory Game"

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

  // Quiz Rush 

  static let txtQuizRush = "Quiz Rush"
  static let txtQuizRushSubTitle = "Live Trivia"

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

  // Share Card
  static let txtIErned = "I earned"
  static let txtIScored = "I scored"
  static let txtStarOn = "⭐ on"
  static let txtOn = "on"
  static let txtLevel = "lvel"
  static let txtWith = "with"
  static let txtPtsInNeonArc = "pts in Neon Archade! 🎮"
  static let txtInNeonArc = "in Neon Archade! 🎮"
  static let txtPoints = "points"
  static let txtShareCardFooter = "Neon Archade . iOS"
  static let txtShare = "Share"
  static let txtShareScore = "Share Score"
  static let txtLevelCompleted = "level completed"
  static let txtToKeepStreak = "to keep streak"

  // Game worlds
  static let sunsetArena = "Sunset Arena"

  // Game World Subtitles
  static let comboZone = "Combo Zone"


  static let txtDailyChallenge = "Daily Challenge"
  static let txtDailyChallenges = "Daily Challenges"
  static let txtCompleteStrak = "Complete! \(flame) Streak: "
  static let txtDays = "days"
  static let txtTarget = "Target"
  static let txtReachedStreak = "reached! Streak: "
  static let txtNeeded = "Needed"
  static let txtPtsHortBy = "pts . hort by"
  static let txtD = "d"
  static let txt3CompletedToday = "/3 completed today"
  static let txtAllDayChallengesCompleted = "all daily challenges colpleted! 🎉"
  static let txtDone = "Done"
  static let txtGameGuide = "Game guide"
  static let txtScore = "Score"
  static let txtTime = "time"

  // Music Control

  static let txtSoundSettings = "Sound Settings"
  static let txtBackgroundMusic = "Background Music"
  static let txtSoundEffects = "Sound Effects"


  // Color Name
  static let txtYellow = "yellow"
  static let txtBlue = "blue"
  static let txtPurple = "purple"
  static let txtGreen = "green"

  // Imogis
  static let flame = "🔥"
  static let flash = "⚡"
  static let light = "💡"
}

// Neet to be update String Variables.......