//
//  ViewController.swift
//  MyTodo
//
//  Created by User on 2020/02/15.
//  Copyright © 2020 Yusaku Kuwahata. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    // セルの文言を格納する配列
    var todoStringArray = [String]()
    // 完了しているかを管理するの配列
    var doneArray = [Bool]()
    let checkImage = "checkImage"
    let memoImage = "taskMemo"
    let userDefaults = UserDefaults.standard
    let todoArrayKey = "todoStringArray"
    let doneArrayKey = "doneArrayKey"
    let tappedTodo = "tappedTodo"
    // 初回起動フラグを参照するためのkey
    let isFirstKey = "isFirst"
    // textFealdを入力中かどうか
    var isWriting = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // デリゲートの設定
        textField.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        // ナビゲーションバーを非表示
        navigationController?.setNavigationBarHidden(true, animated: true)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // キーボードの改行ボタンを完了というひ表記に変更
        textField.returnKeyType = .done
        // ナビゲーションバーを非表示
        navigationController?.setNavigationBarHidden(true, animated: true)
        // 初回起動の処理
        if userDefaults.bool(forKey: isFirstKey) {
            // userDefaultsからtodoリストを取得
            if let array = userDefaults.array(forKey: todoArrayKey) {
                todoStringArray = array as! [String]
            }
            // userDefaultsから完了フラグリストを取得
            if let array = userDefaults.array(forKey: doneArrayKey) as? [Bool] {
                doneArray = array
            }
        }
        // セルが一度タップされたかどうか
        if userDefaults.bool(forKey: tappedTodo) {
            // 画面更新
            tableView.reloadData()
        }
        userDefaults.set(true, forKey: isFirstKey)
    }
    
    // セルの数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoStringArray.count
    }
    
    // セルの値
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoCell", for: indexPath) as! MyTodoCell
        cell.textLabel?.text = todoStringArray[indexPath.row]
        // 画像の出しわけ
        if userDefaults.bool(forKey: tappedTodo) {
            if doneArray[indexPath.row] {
                cell.imageView?.image = UIImage(named: checkImage)
            } else{
                cell.imageView?.image = UIImage(named: memoImage)
            }
        } else {
            cell.imageView?.image = UIImage(named: memoImage)
        }
        cell.selectionStyle = .none
        return cell
    }
 
    // セルの高さ
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.size.height / 6
    }
    
    // セルの編集を許可
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // セルがさ削除された時の処理
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // todoリストから削除
            todoStringArray.remove(at: indexPath.row)
            // 完了フラグリストから削除
            doneArray.remove(at: indexPath.row)
            // todoリストを更新
            userDefaults.set(todoStringArray, forKey: todoArrayKey)
            // 完了フラグリストを更新
            userDefaults.set(doneArray, forKey: doneArrayKey)
            userDefaults.synchronize()
            // 画面の更新
            self.tableView.reloadData()
        }
    }
    
    // セルがタップされた時の処理
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // セルのハイライトを消す
        tableView.deselectRow(at: indexPath, animated: true)
        // 遷移先に値を渡す
        let todoVC = self.storyboard?.instantiateViewController(identifier: "TodoViewController") as! TodoViewController
        todoVC.todoText = todoStringArray[indexPath.row]
        todoVC.selectedRowNumber = indexPath.row
        // 画面遷移
        navigationController?.pushViewController(todoVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if isWriting {
            return nil
        } else {
            return indexPath
        }
    }
    
    // textFieldのリターンボタンが押された時の処理
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.text == "" {
            // キーボードを閉じる
            textField.resignFirstResponder()
            return true
        }
        if let text = textField.text {
            // 入力された文字を保存
            todoStringArray.append(text)
            // 完了フラグを追加
            doneArray.append(false)
        }
        // tableViewのリロード
        tableView.reloadData()
        textField.text = ""
        // todoを追加
        userDefaults.set(todoStringArray, forKey: todoArrayKey)
        // 完了フラグリストを追加
        userDefaults.set(doneArray, forKey: doneArrayKey)
        // userDefaultsに保存
        userDefaults.synchronize()
        // 入力中フラグをfalseに変更
        isWriting = false
        // キーボードを閉じる
        textField.resignFirstResponder()
        return true
    }
    
    // キーボードがタップされて入力可能になった後
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // 入力中フラグをtrueに変更
        isWriting = true
    }
    
    // キーボード以外をタップした時にキーボードを閉じる
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // 入力中フラグをfalseに変更
        isWriting = false
        self.view.endEditing(true)
    }
    
}

