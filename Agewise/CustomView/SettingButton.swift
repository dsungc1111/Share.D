//
//  SettingButton.swift
//  Agewise
//
//  Created by 최대성 on 8/25/24.
//

import UIKit
import SnapKit

final class SettingButton: UIButton {
    
    init(title: String, image: String) {
        super.init(frame: .zero)
        
        var config = UIButton.Configuration.plain()
        
        
        config.image = UIImage(systemName: image)
        config.imagePadding = 8
        config.imagePlacement = .leading
        
        
        config.title = title
        config.baseForegroundColor = .black

        
        
        contentHorizontalAlignment = .left
        
        
        self.configuration = config
        
        let bottomBorder = UIView()
        bottomBorder.backgroundColor = .black
        addSubview(bottomBorder)
        
        bottomBorder.snp.makeConstraints { make in
            make.height.equalTo(0.5) 
            make.leading.trailing.bottom.equalToSuperview()
        }
        
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
