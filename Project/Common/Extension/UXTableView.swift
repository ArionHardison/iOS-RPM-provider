
import Foundation
import UIKit

extension UITableView{
   
    func registerCell(withId id : String){
        self.register(UINib(nibName: id, bundle: Bundle.main), forCellReuseIdentifier: id)
    }
}

extension UICollectionView{
   
    func registerCell(withId id : String){
        self.register(UINib(nibName: id, bundle: Bundle.main), forCellWithReuseIdentifier: id)
    }
}
