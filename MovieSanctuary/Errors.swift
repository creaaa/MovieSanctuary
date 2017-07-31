
import UIKit

class CollctionViewController: UIViewController {
    
    fileprivate let cellid = "cellid"
    
    lazy var collectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 20  // 行の中で隣り合うアイテムの間隔
        layout.minimumLineSpacing      = 40  // 行の間隔
        // layout.sectionInset = UIEdgeInsets(top: 10, left: 20, bottom: 30, right: 40)
        layout.itemSize = CGSize(width: 50, height: 50)
        layout.headerReferenceSize = CGSize(width: 0, height: 50)
        
        return UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        
    }()
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        collectionView.backgroundColor = .cyan
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        collectionView.delegate   = self
        collectionView.dataSource = self
        
        collectionView.register(CategoryCell.self, forCellWithReuseIdentifier: cellid)
        collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "header")
        
        
        self.view.addSubview(self.collectionView)
        
        collectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
    }
    
}


extension CollctionViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellid, for: indexPath) as! CategoryCell
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    // 2.ヘッダー
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let headerReusableView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "header", for: indexPath) as UICollectionReusableView
        
        headerReusableView.backgroundColor = .blue
        
        return headerReusableView
        
    }
    
}


class CategoryCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpViews(){
        
        self.backgroundColor = .yellow
        
        let _: UILabel = {
            
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.text = "hoge"
            
            self.addSubview(label)
            
            label.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
            label.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive   = true
            
            return label
            
        }()
        
    }
}

