//
//  DataPersistence.swift
//  Task
//
//  Created by Łukasz Sypniewski on 20/02/2018.
//  Copyright © 2018 Łukasz Sypniewski. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class DataPersistence {
    static private func persistSaveArticle(_ article: Article) -> CachedArticles {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let entity = CachedArticles(context: context)
        entity.author = article.author
        entity.articleDescription = article.description
        entity.publishedAt = article.publishedAt
        entity.sourceID = article.sourceID
        entity.sourceName = article.sourceName
        entity.title = article.title
        entity.url = article.url
        entity.urlToImage = article.urlToImage
        return entity
        
    }
    
    static func persistSaveArticle(_ article: Article, imageData: Data) {
        //let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let entity = persistSaveArticle(article)
        entity.image = imageData
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
    }
    
    /*func static persistSaveArticle(_ article: Article, image: UIImage) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let entity = CachedArticles(context: context)
        entity.author = article.author
        entity.articleDescription = article.description
        entity.publishedAt = article.publishedAt
        entity.sourceID = article.sourceID
        entity.sourceName = article.sourceName
        entity.title = article.title
        entity.url = article.url
        entity.urlToImage = article.urlToImage
        entity.image = imageData
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
    }*/
    
    static func persistLoadAtricle(_ articles: inout [Article]) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        do {
            let articleCacheArray = try context.fetch(CachedArticles.fetchRequest())
            articles = [Article]()
            print(articleCacheArray.count)
            for i in 0..<articleCacheArray.count {
                let entity: CachedArticles = articleCacheArray[i] as! CachedArticles
                let source = Source(id: entity.sourceID, name: entity.sourceName)
                let articleData = ArticleData(source: source, author: entity.author, title: entity.title, description: entity.articleDescription,
                                              url: entity.url, urlToImage: entity.url, publishedAt: entity.publishedAt)
                articles.append(Article(with: articleData, image: UIImage(data: entity.image!)!))
            }
        } catch {
            fatalError("Fetching articles failed!")
        }
    }
    
    static func persistDeleteData(_ articles: inout [Article]) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        do {
            let articleCacheArray = try context.fetch(CachedArticles.fetchRequest())
            articles = [Article]()
            for i in 0..<articleCacheArray.count {
                context.delete(articleCacheArray[i] as! NSManagedObject)
                (UIApplication.shared.delegate as! AppDelegate).saveContext()
            }
        } catch {
            fatalError("Deleting articles failed!")
        }
    }
}
