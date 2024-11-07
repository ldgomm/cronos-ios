//
//  liquor.swift
//  Sales
//
//  Created by José Ruiz on 8/7/24.
//

import Foundation

let liquor: Categories = [
    Mi(name: "Liquor"): [
        Ni(name: "Wine"): [
            Xi(name: "Red Wine"),
            Xi(name: "White Wine"),
            Xi(name: "Rosé Wine"),
            Xi(name: "Sparkling Wine"),
            Xi(name: "Dessert Wine"),
            Xi(name: "Fortified Wine"),
            Xi(name: "Organic Wine"),
            Xi(name: "Non-Alcoholic Wine"),
            Xi(name: "Boxed Wine"),
            Xi(name: "Wine Accessories")
        ],
        Ni(name: "Beer"): [
            Xi(name: "Lager"),
            Xi(name: "Ale"),
            Xi(name: "Stout"),
            Xi(name: "Porter"),
            Xi(name: "Pilsner"),
            Xi(name: "Wheat Beer"),
            Xi(name: "Pale Ale"),
            Xi(name: "IPA"),
            Xi(name: "Sour Beer"),
            Xi(name: "Craft Beer")
        ],
        Ni(name: "Spirits"): [
            Xi(name: "Whiskey"),
            Xi(name: "Vodka"),
            Xi(name: "Rum"),
            Xi(name: "Tequila"),
            Xi(name: "Gin"),
            Xi(name: "Brandy"),
            Xi(name: "Cognac"),
            Xi(name: "Liqueur"),
            Xi(name: "Absinthe"),
            Xi(name: "Mezcal")
        ],
        Ni(name: "Cocktails"): [
            Xi(name: "Martini"),
            Xi(name: "Margarita"),
            Xi(name: "Mojito"),
            Xi(name: "Old Fashioned"),
            Xi(name: "Manhattan"),
            Xi(name: "Daiquiri"),
            Xi(name: "Whiskey Sour"),
            Xi(name: "Bloody Mary"),
            Xi(name: "Cosmopolitan"),
            Xi(name: "Negroni")
        ]
    ]
]
