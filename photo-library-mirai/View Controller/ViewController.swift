//
//  ViewController.swift
//  photo-library-mirai
//
//  Created by Achmad Abdul Aziz on 18/06/20.
//  Copyright © 2020 Achmad Abdul Aziz. All rights reserved.
//

import UIKit
import Photos
import SkeletonView
import JGProgressHUD

enum Filter{
    case day
    case month
    case year
}

class ViewController: UIViewController{
    
    @IBOutlet weak var buttonFilter: UIBarButtonItem!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    let hud = JGProgressHUD(style: .dark)
    
    var imageArray = [UIImage]()
    var imageArrayCreationDate = [String]()
    
    var dateYear = [String]()
    var dateMonth = [String]()
    var dateDay = [String]()
    
    var imageToDisplay = [[UIImage]]()
    var indexForImageToDisplay = [[Int]]()
    
    var filter = Filter.day
    
    var loading = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Start Did Load")
        hud.textLabel.text = "Loading"
        
        collectionView.delegate = self
        collectionView.dataSource = self
        grabPhotos()
    }
    
    func showProgression(){
        self.hud.show(in: self.view)
    }
    
    func dismissProgression(){
        hud.dismiss()
    }
    
    func changeImageToDisplay(){
        
        imageToDisplay.removeAll()
        //        print(imageToDisplay)
        switch filter {
            
        case .day:
            for day in dateDay{
                insertPhotosToImageToDisplay(date: day)
            }
        case .month:
            for month in dateMonth{
                insertPhotosToImageToDisplay(date: month)
            }
        case .year:
            for year in dateYear{
                insertPhotosToImageToDisplay(date: year)
            }
        }
        
        dismissProgression()
        collectionView.reloadData()
    }
    
    func insertPhotosToImageToDisplay(date: String){
        var arrayImageOnDate = [UIImage]()
        var arrayIndexImageOnDate = [Int]()
        
        print(date)
        for i in 0..<imageArrayCreationDate.count{
            let imageCreationDate = imageArrayCreationDate[i]
            
            if imageCreationDate.contains(date){
                arrayImageOnDate.append(imageArray[i])
                arrayIndexImageOnDate.append(i)
            }
        }
        
        imageToDisplay.append(arrayImageOnDate)
        indexForImageToDisplay.append(arrayIndexImageOnDate)
    }
    
    @IBAction func filterAction(_ sender: Any) {
        showProgression()
        switch filter {
            
        case .day:
            buttonFilter.title = "Month"
            filter = .month
            changeImageToDisplay()
        case .month:
            buttonFilter.title = "Year"
            filter = .year
            changeImageToDisplay()
        case .year:
            buttonFilter.title = "Day"
            filter = .day
            changeImageToDisplay()
        }
    }
    
    func grabPhotos(){
        imageArray = []
        
        DispatchQueue.global(qos: .background).async {
            print("This is run on the background queue")
            let imageManager = PHImageManager.default()
            
            let requestOption = PHImageRequestOptions()
            requestOption.isSynchronous = true
            requestOption.deliveryMode = .highQualityFormat
            
            let fetchOption = PHFetchOptions()
            fetchOption.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
            
            let fetchResult: PHFetchResult = PHAsset.fetchAssets(with: .image, options: fetchOption)
            
            print(fetchResult)
            print(fetchResult.count)
            
            if fetchResult.count > 0{
                for i in 0..<fetchResult.count{
                    imageManager.requestImage(for: fetchResult.object(at: i) as PHAsset, targetSize: CGSize(width: 100, height: 100), contentMode: .aspectFill, options: requestOption) { (image, error) in
                        self.imageArray.append(image!)
                        if let asset = fetchResult[i].creationDate{
                            let formatter = DateFormatter()
                            // initially set the format based on your datepicker date / server String
                            formatter.dateFormat = "yyyy-MM-dd"
                            
                            let myString = formatter.string(from: asset) // string purpose I add her
                            let dateComponent =  myString.components(separatedBy: "-")
                            if !self.dateYear.contains(dateComponent[0]){
                                self.dateYear.append(dateComponent[0])
                            }
                            
                            if !self.dateMonth.contains(String.getFullnameMonth(Number: dateComponent[1])+" "+dateComponent[0]){
                                self.dateMonth.append(String.getFullnameMonth(Number: dateComponent[1])+" "+dateComponent[0])
                            }
                            if !self.dateDay.contains(dateComponent[2]+" "+String.getFullnameMonth(Number: dateComponent[1])+" "+dateComponent[0]){
                                self.dateDay.append(dateComponent[2]+" "+String.getFullnameMonth(Number: dateComponent[1])+" "+dateComponent[0])
                            }
                            
                            
                            self.imageArrayCreationDate.append(dateComponent[2]+" "+String.getFullnameMonth(Number: dateComponent[1])+" "+dateComponent[0])
                        }
                        
                    }
                }
            } else {
                print("No Photos")
            }
            
            //            print("Day: ", self.dateDay)
            //            print("Month: ", self.dateMonth)
            //            print("Year: ", self.dateYear)
            
            DispatchQueue.main.async {
                print("This is run on main queue, ater the previous code in outer block")
                self.loading = false
                self.changeImageToDisplay()
                
            }
            
        }
    }
    
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if loading{
            return 5
        } else {
            return imageToDisplay.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if loading{
            return 10
        } else {
            return imageToDisplay[section].count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "ImageLibrary_CollectionReusableView", for: indexPath)
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        if let view = view as? ImageLibrary_CollectionReusableView{
            
            if loading{
                view.lblTitle.showAnimatedGradientSkeleton()
            } else {
                view.lblTitle.hideSkeleton()
                switch filter {
                    
                case .day:
                    view.lblTitle.text = dateDay[indexPath.section]
                case .month:
                    view.lblTitle.text = dateMonth[indexPath.section]
                case .year:
                    view.lblTitle.text = dateYear[indexPath.section]
                }
            }
            
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let cell = cell as? ImageLibrary_CollectionViewCell {
            if loading{
                cell.showAnimatedGradientSkeleton()
            } else {
                cell.hideSkeleton()
                let image = imageToDisplay[indexPath.section][indexPath.row]
                cell.imageCell.contentMode = .scaleAspectFill
                cell.imageCell.image = image
            }
            
        } else {
            return
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = (self.view.frame.width-20)/4
        return CGSize(width: size, height: size)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        showProgression()
        print(indexPath.section, indexPath.row)
        
        let width = self.view.frame.width
        DispatchQueue.global(qos: .background).async {
            print("This is run on the background queue")
            
            var selectedImage: UIImage!
            let imageManager = PHImageManager.default()
            
            let requestOption = PHImageRequestOptions()
            requestOption.isSynchronous = true
            requestOption.deliveryMode = .highQualityFormat
            
            let fetchOption = PHFetchOptions()
            fetchOption.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
            
            let fetchResult: PHFetchResult = PHAsset.fetchAssets(with: .image, options: fetchOption)
            
            print(fetchResult)
            print(fetchResult.count)
            
            
            imageManager.requestImage(for: fetchResult.object(at: self.indexForImageToDisplay[indexPath.section][indexPath.row]) as PHAsset, targetSize: CGSize(width: width, height: width), contentMode: .aspectFill, options: requestOption) { (image, error) in
                selectedImage = image
            }
            
            DispatchQueue.main.async {
                
                self.dismissProgression()
                let view = PreviewImage_ViewController.makeViewController(image: selectedImage ?? UIImage())
                self.navigationController?.pushViewController(view, animated: true)
                
            }
            
        }
        
    }
    
}






