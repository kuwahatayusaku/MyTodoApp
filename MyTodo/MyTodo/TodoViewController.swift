//
//  TodoViewController.swift
//  MyTodo
//
//  Created by User on 2020/02/15.
//  Copyright © 2020 Yusaku Kuwahata. All rights reserved.
//

import UIKit

class TodoViewController: UIViewController {

    @IBOutlet weak var todoLabel: UILabel!
    var todoText = ""
    var selectedRowNumber = 0
    var doneArray = [Bool]()
    let doneArrayKey = "doneArrayKey"
    let userDefaults = UserDefaults.standard
    let checkImage = "checkImage"
    let tappedTodo = "tappedTodo"
    @IBOutlet weak var doneImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let array = userDefaults.array(forKey: doneArrayKey) as? [Bool] {
            doneArray = array
        }
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        todoLabel.text = todoText
        // セルがタップされたflgを保存
        userDefaults.set(true, forKey: tappedTodo)
        if doneArray[selectedRowNumber] {
            // 画像を設定
            doneImageView.image = UIImage(named: checkImage)
        }
    }
    
    @IBAction func tapDone(_ sender: Any) {
        // 画像を設定
        doneImageView.image = UIImage(named: checkImage)
        // 完了フラグを更新
        doneArray[selectedRowNumber] = true
        // userDefaultsに保存
        userDefaults.set(doneArray, forKey: doneArrayKey)
        userDefaults.synchronize()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
