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
    
    // CRUD
    func createDiary(date: Date, title: String, content: String, image: UIImage?) {
        let diary = Diary(context: context)
        diary.date = date
        diary.title = title
        diary.content = content
        if let imageData = image?.jpegData(compressionQuality: 1.0) {
            diary.image = imageData
        }
        
        saveContext()
        print("Diary created: \(diary)")
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
    
    func deleteDiary(diary: Diary) {
        context.delete(diary)
        saveContext()
    }
}