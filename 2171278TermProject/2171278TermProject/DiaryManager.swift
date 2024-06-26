//
//  DiaryManager.swift
//  
//
//  Created by 남기철 on 2024/06/07.
//

import Foundation
import CoreData
import UIKit

class DiaryManager {
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext = CoreDataStack.shared.context) {
        self.context = context
    }
    
    func createDiary(date: Date, title: String, content: String, image: UIImage?) -> Bool {
        if getDiary(for: date) != nil {
            return false
        }

        let diary = Diary(context: context)
        diary.date = date
        diary.title = title
        diary.content = content
        if let imageData = image?.jpegData(compressionQuality: 1.0) {
            diary.image = imageData
        }

        saveContext()
        print("Diary created: \(diary)")
        return true
    }
    
    private func saveContext() {
        do {
            try context.save()
        } catch {
            print("Failed to save context: \(error)")
        }
    }
    
    func getDiarys() -> [Diary]? {
        let request: NSFetchRequest<Diary> = Diary.fetchRequest()
        do {
            let diaries = try context.fetch(request)
            return diaries
        } catch {
            print("Failed to get Diarys: \(error)")
            return nil
        }
    }
    
    func updateDiary(diary: Diary, withTitle title: String, withContent content: String, andImage image: UIImage?) {
        diary.title = title
        diary.content = content
        if let imageData = image?.jpegData(compressionQuality: 1.0) {
            diary.image = imageData
        }
        
        saveContext()
    }
    
    func deleteDiary(for date: Date) {
        let request: NSFetchRequest<Diary> = Diary.fetchRequest()
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: date)
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)

        request.predicate = NSPredicate(format: "date >= %@ AND date < %@", startOfDay as NSDate, endOfDay! as NSDate)

        do {
            let diaries = try context.fetch(request)
            if let diaryToDelete = diaries.first {
                context.delete(diaryToDelete)
                saveContext()
                print("Diary deleted: \(diaryToDelete)")
            } else {
                print("No diary found for the date: \(date)")
            }
        } catch {
            print("Failed to delete Diary for date: \(error)")
        }
    }
    
    func deleteAllDiaries() {
            let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Diary")
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            
            do {
                try context.execute(deleteRequest)
                try context.save()
                print("모든 일기 삭제 완료")
            } catch {
                print("모든 일기 삭제 실패: \(error.localizedDescription)")
            }
        }
    
    func getDiary(for date: Date) -> Diary? {
        let request: NSFetchRequest<Diary> = Diary.fetchRequest()
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: date)
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)
        
        request.predicate = NSPredicate(format: "date >= %@ AND date < %@", startOfDay as NSDate, endOfDay! as NSDate)
        
        do {
            let diaries = try context.fetch(request)
            return diaries.first
        } catch {
            print("Failed to get Diary for date: \(error)")
            return nil
        }
    }
}
