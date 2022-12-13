//
//  WordListViewBuilder.swift
//  Project5
//
//  Created by Меньков Д.В. on 20/11/22.
//

import UIKit

protocol WordListViewBuilder {
    static func createWordListView() -> UIViewController
}

final class WordListViewBuilderImpl: WordListViewBuilder {
    static func createWordListView() -> UIViewController {
        let presenter = WordListPresenterImpl()
        let view = WordListViewController(presenter: presenter)
        presenter.view = view
        return view
    }
}
