//
//  PersonHomeCell.swift
//  TouTiaoSK17.V2
//
//  Created by SeventeenK17 on 2021/7/5.
//

import UIKit

class PersonHomeCell: UITableViewCell {
    let personData = PersonData()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    lazy var userImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        return image
    }()
        
        lazy var userName: UILabel = {
            let label = UILabel()
            label.numberOfLines = 0
            label.font = .boldSystemFont(ofSize: 14)
            return label
        }()

        lazy var textData: UILabel = {
            let label = UILabel()
            label.numberOfLines = 0
//            label.isUserInteractionEnabled = true
            label.font = .systemFont(ofSize: 16)
            label.text = "耶耶耶这是第一条"
            return label
        }()
        
    override init(style:UITableViewCell.CellStyle , reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            setupUI()
//            setupConstraints()
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let view = super.hitTest(point, with: event)
        return view
    }
        func setupUI() {
            let personimage = personData.personImage
            let personname = personData.personName
            personname.font = .boldSystemFont(ofSize: 14)

            
            self.contentView.addSubview(personname)
            self.contentView.addSubview(personimage)
            self.contentView.addSubview(textData)
            
            personimage.snp.makeConstraints{(make)in
                make.width.height.equalTo(30)
                make.left.top.equalToSuperview().offset(10)
            }
            personname.snp.makeConstraints { (make) in
                make.left.equalTo(personimage.snp_rightMargin).offset(15)
                make.top.equalToSuperview().offset(15)
//                make.bottom.equalTo(textData).offset(10)
            }
            textData.snp.makeConstraints { (make) in
                make.top.equalTo(personimage.snp_bottomMargin).offset(15)
                make.left.right.equalToSuperview().inset(15)
                make.bottom.equalToSuperview().offset(-15)
            }


        }
        
        func setupConstraints() {

            userImage.snp.makeConstraints { (make) in
                make.left.top.equalToSuperview().offset(10)
            }
            userName.snp.makeConstraints { (make) in
                make.left.equalTo(userImage).offset(15)
                make.top.equalToSuperview().offset(15)
//                make.bottom.equalTo(textData).offset(10)
            }

            textData.snp.makeConstraints { (make) in
                make.top.equalTo(userName.snp_bottomMargin).offset(15)
                make.left.right.equalToSuperview().inset(15)
                make.bottom.equalToSuperview().offset(-15)
            }
        }
    
    func configCell(userimage:UIImageView,username:String,textdata:String){
        self.userImage = userimage
        self.userName.text = username
        self.textData.text = textdata
        
    }

    }


