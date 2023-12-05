//
//  Drafts.swift
//  MA
//
//  Created by Aliaksandr Yashchuk on 11/13/23.
//

import Foundation

// появляющееся меню

//       let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addBarButton))
//     navigationItem.setRightBarButton(add, animated: true)
//    @objc
//    private func addBarButton() {
//        alertForAddAndUpdates()
//    }
//


//    private func alertForAddAndUpdates(currentList: TextVC? = nil, indexPath: IndexPath? = nil) {
//        let title = currentList == nil ? "New list" : "Edit List"
//        let messege = "Please insert a list name"
//        let doneButtonName = currentList == nil ? "Save" : "Update"
//        let alertController = UIAlertController(title: title, message: messege, preferredStyle: .alert)
//        var alertTextField: UITextField!
//        let saveAction = UIAlertAction(title: doneButtonName, style: .default) { [weak self] _ in
//                        guard let self,
//                              let newListName = alertTextField.text,
//                              !newListName.isEmpty else { return }
        //
        //            if let currentList = currentList,
        //            let indexPath = indexPath {
        //              StorageManager.editTasksList(tasksList: currentList, newListName: newListName)
        //              self.tableView.reloadRows(at: [indexPath], with: .automatic)
        //
        //            } else {
        //                let taskList = TasksList()
        //                taskList.name = newListName
        //                StorageManager.saveTasksList(tasksList: taskList)
        //                self.tableView.reloadData()
        //            }
//                    }
//            //
//                    let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
//
//                    alertController.addAction(saveAction)
//                    alertController.addAction(cancelAction)
//                    alertController.addTextField { textField in
//                        alertTextField = textField
//                        alertTextField.text = ""
//                        alertTextField.placeholder = "List name"
//            //        }
//
//            self.present(alertController, animated: true)
        
//        }
//
//    }
//    

// всплывающее меню
//        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
//        let cameraAction = UIAlertAction(title: "Сделать фото", style: .default) { (action) in
//            self.openCamera()
//        }
//        let galleryAction = UIAlertAction(title: "Открыть галерею", style: .default) { (action) in
//            self.openGallery()
//        }
//        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
//
//        alertController.addAction(cameraAction)
//        alertController.addAction(galleryAction)
//        alertController.addAction(cancelAction)
//
//        present(alertController, animated: true, completion: nil)
