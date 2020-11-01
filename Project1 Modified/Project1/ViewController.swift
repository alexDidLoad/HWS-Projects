//
//  ViewController.swift
//  Project1
//
//  Created by Alexander Ha on 9/16/20.
//  Copyright © 2020 Alexander Ha. All rights reserved.
//

import UIKit

class ViewController: UICollectionViewController {
    
    var pictures = [String]()
    var savedViewCount = [String : Int]()
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Stormviewer"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font : UIFont(name: "Menlo", size: 20)!]
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(recommendTapped))
        performSelector(inBackground: #selector(loadPictures), with: nil)
        self.collectionView.backgroundColor = .white
        collectionView.performSelector(onMainThread: #selector(UICollectionView.reloadData), with: nil, waitUntilDone: false)
        
        let defaults = UserDefaults.standard
        if let savedCount = defaults.object(forKey: "savedViewCount") as? Data {
            let jsonDecoder = JSONDecoder()
            do {
                savedViewCount = try jsonDecoder.decode([String: Int].self, from: savedCount)
            } catch {
                print("Error loading data")
            }
            
            
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pictures.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? StormCell else {
            fatalError("Unable to dequeue reusable cell.")
        }
        
        cell.imageView.image = UIImage(named: pictures[indexPath.item])
        cell.imageView.layer.borderColor = UIColor.darkGray.cgColor
        cell.imageView.layer.borderWidth = 1
        cell.imageView.layer.cornerRadius = 7
        cell.imageView.layer.masksToBounds = true
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(identifier: "Detail") as? DetailViewController {
            vc.selectedImage = pictures[indexPath.item]
            vc.selectedImageNumber = indexPath.item + 1
            vc.totalImages = pictures.count
            navigationController?.pushViewController(vc, animated: true)
        }
        let picture = pictures[indexPath.item]
        savedViewCount[picture]! += 1
        save()
        print(savedViewCount[picture]!)
        collectionView.reloadData()
    }
    
    //    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    //        return pictures.count
    //    }
    
    //    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    //        let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath)
    //
    //        cell.accessoryType = .disclosureIndicator
    //        cell.textLabel?.text = pictures[indexPath.row]
    //        cell.textLabel?.font = UIFont.systemFont(ofSize: 25)
    //        return cell
    //    }
    
    //    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    //        if let vc = storyboard?.instantiateViewController(identifier: "Detail") as? DetailViewController {
    //            vc.selectedImage = pictures[indexPath.row]
    //            vc.selectedImageNumber = indexPath.row + 1
    //            vc.totalImages = pictures.count
    //            navigationController?.pushViewController(vc, animated: true)
    //        }
    //    }
    
    @objc func recommendTapped() {
        
        let shareLink = "https://artisticscoreengraving.wordpress.com/2019/02/23/hacking-with-swift-challenge-3/"
        
        let vc = UIActivityViewController(activityItems: [shareLink], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }
    
    @objc func loadPictures() {
        
        let fm = FileManager.default
        let path = Bundle.main.resourcePath!
        let items = try! fm.contentsOfDirectory(atPath: path)
        
        
        for item in items {
            if item.hasPrefix("nssl") {
                pictures.append(item)
                savedViewCount[item] = 0
            }
            pictures = pictures.sorted()
        }
    }
    
    func save() {
        let jsonEncoder = JSONEncoder()
        
        if let savedData = try? jsonEncoder.encode(savedViewCount), let savedPictures = try? jsonEncoder.encode(pictures) {
            let defaults = UserDefaults.standard
    
            defaults.set(savedData, forKey: "savedViewCount")
            defaults.set(savedPictures, forKey: "pictures")
        } else {
            print("Failed to save")
        }
        
    }
    
}

