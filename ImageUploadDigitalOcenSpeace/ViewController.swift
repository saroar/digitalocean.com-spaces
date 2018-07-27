//
//  ViewController.swift
//  ImageUploadDigitalOcenSpeace
//
//  Created by Alif on 27/7/18.
//  Copyright © 2018 Alif. All rights reserved.
//

import UIKit
import AWSS3

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    let bucketName = "addaapi"
    var contentUrl: URL!
    var s3Url: URL!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        s3Url = AWSS3.default().configuration.endpoint.url
    }
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var uploadButton: UIButton!
    @IBOutlet var imageUpLoadProgressView: UIView!
    @IBOutlet weak var progressLabel: UILabel!
    
    @IBAction func uploadButtonTapped(_ sender: Any) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = UIImagePickerControllerSourceType.photoLibrary
        
        self.present(pickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        profileImage.image = image
        
        profileImage.backgroundColor = UIColor.clear
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func uploadImageToAWS(_ sender: Any) {
        
        guard let image = profileImage.image else { return }
        uploadData(image: image)
        
    }
    
    func getCurrentMillis() -> Int64 {
        return Int64(Date().timeIntervalSince1970 * 1000)
    }
    
    func uploadData(image: UIImage) {
        //  let img = UIImage(named: "bob.jpg") // to upload the image from the project folder
        let data:Data = UIImagePNGRepresentation(image)!
        
        let expression = AWSS3TransferUtilityUploadExpression()
        //        let upload = AWSS3TransferManager.upload()
        expression.progressBlock = {(task, progress) in
            DispatchQueue.main.async(execute: {
                // Do something e.g. Update a progress bar.
                print("upload in process \(progress)")
            })
        }
        
        var completionHandler: AWSS3TransferUtilityUploadCompletionHandlerBlock?
        completionHandler = { (task, error) -> Void in
            DispatchQueue.main.async(execute: {
                // Do something e.g. Alert a user for transfer completion.
                // On failed uploads, `error` contains the error object.
                
                print("upload completed1 \(task.bucket)")
                print("upload completed2 \(String(describing: task.response))")
                print("upload completed3 \(task.key)")
                print("upload url \(String(describing: task.response?.url?.path))")
                
            })
        }
        
        let transferUtility = AWSS3TransferUtility.default()
        let currentTime = getCurrentMillis()
        var imageKey = String(format: "%ld", currentTime)
        imageKey = "uploads/\(UUID().uuidString)_\(imageKey).jpg"
        
        transferUtility.uploadData(
            data,
            bucket: "adda",
            key: imageKey,
            contentType: "image/jpeg",
            expression: expression,
            completionHandler: completionHandler
            ).continueWith { (task) -> AnyObject? in
                if let error = task.error {
                    print("Error: \(error.localizedDescription)")
                }
                
                if let _ = task.result {
                    // Do something with uploadTask.
                    
                    print("something upload completed \(String(describing: task.result.debugDescription))")
                    
                }
                return nil
        }
    }


}

