//
//  ViewController.swift
//  TechtaGram
//
//  Created by Yui Ogawa on 2022/08/29.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet var cameraImageView: UIImageView!
    
    // 画像を加工するための元となる画像
    var originalImage: UIImage!
    
    // 画像を加工するフィルターの宣言
    var filter: CIFilter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    // カメラ、カメラロールを使ったときに選択した画像をアプリ内に表示するメソッド
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        cameraImageView.image = info[.editedImage] as? UIImage
        // カメラで撮った写真を「加工する前の元の画像」として記憶
        originalImage = cameraImageView.image
        dismiss(animated: true, completion: nil)
    }
    // 撮影するボタンを押した時のメソッド
    @IBAction func takePhoto(){
        // カメラが使えるかどうかの確認
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            // カメラを起動
            let picker = UIImagePickerController()
            picker.sourceType = .camera
            picker.delegate = self
            
            picker.allowsEditing = true
            present(picker, animated: true, completion: nil)
        } else {
            // カメラが使えないときは、エラーをコンソールに出力
            print("error")
        }
    }
    @IBAction func savePhoto(){
        UIImageWriteToSavedPhotosAlbum(cameraImageView.image!, nil, nil, nil)
    }
    // 表示している画像にフィルター加工をするメソッド
    @IBAction func colorFilter(){
        let filterImage: CIImage = CIImage(image: originalImage)!
        
        // フィルターの設定
        filter = CIFilter(name: "CIColorControls")!
        filter.setValue(filterImage, forKey: kCIInputImageKey)
        // 彩度の調整
        filter.setValue(1.0, forKey: "inputSaturation")
        // 明度の調整
        filter.setValue(0.5, forKey: "inputBrightness")
        // コントラストの調整
        filter.setValue(2.5, forKey: "inputContrast")
        
        let ctx = CIContext(options: nil)
        let cgImage = ctx.createCGImage(filter.outputImage!, from: filter.outputImage!.extent)
        cameraImageView.image = UIImage(cgImage: cgImage!)
    }
    // カメラロールにある画像を読み込むときのメソッド
    @IBAction func openAlbum(){
        // カメラロールを使えるかの確認
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            // カメラロールの画像を選択して画像を表示するまでの一連の流れ
            let picker = UIImagePickerController()
            picker.sourceType = .photoLibrary
            picker.delegate = self
            
            picker.allowsEditing = true
            present(picker, animated: true, completion: nil)
        }
    }
    // SNSに編集した画像を投稿したいときのメソッド
    @IBAction func snsPhoto(){
        // 投稿するときに一緒に載せるコメント
        let shareText = "写真加工いぇい"
        
        // 投稿する画像の選択
        let shareImage = cameraImageView.image!
        
        // 投稿するコメントと画像の準備
        let activityItems: [Any] = [shareText, shareImage]
        let activityViewController = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        let excludedActivityTypes = [UIActivity.ActivityType.postToWeibo, .saveToCameraRoll, .print]
        
        activityViewController.excludedActivityTypes = excludedActivityTypes
        
        present(activityViewController, animated: true, completion: nil)
    }

}

