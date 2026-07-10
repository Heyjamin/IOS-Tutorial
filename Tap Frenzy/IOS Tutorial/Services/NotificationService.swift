//
//  NotificationService.swift
//  IOS Tutorial
//
//  Created by G P M A Nuwan Jeewantha on 2026-07-10.
//

import UserNotifications

class NotificationService {
    static let shared = NotificationService()
    
    private init () {}
    
    func requestPermission() async -> Bool {
        do {
            return try await UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge])
        }catch{
            return false
        }
    }
    
    func scheduleDaily(hour: Int, minute: Int){
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
        
        var dateComponents = DateComponents()
        dateComponents.hour = hour
        dateComponents.minute = minute
        
        let content = UNMutableNotificationContent()
        content.title = "Daily Archade Challenge"
        content.body = "Your daily arcade challenge is waiting! 🎮"
        content.sound = .default
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        let request = UNNotificationRequest(identifier: "dailyChallenge", content: content, trigger: trigger)
        
        center.add(request)
    }
    
    func cancelAll(){
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
    
}
