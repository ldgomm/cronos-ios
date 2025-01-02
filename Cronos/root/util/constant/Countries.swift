//
//  Constant.swift
//  Sales
//
//  Created by José Ruiz on 3/4/24.
//

import Foundation

let madeIn = [
    "Alemania",
    "Australia",
    "Brasil",
    "Canadá",
    "China",
    "Corea del Sur",
    "Estados Unidos",
    "India",
    "Indonesia",
    "Italia",
    "Japón",
    "México",
    "Francia",
    "Países Bajos",
    "Rusia",
    "Arabia Saudita",
    "Singapur",
    "Sudáfrica",
    "España",
    "Suecia",
    "Suiza",
    "Tailandia",
    "Turquía",
    "Reino Unido",
    "Vietnam",
    "Argentina",
    "Chile",
    "Colombia",
    "Perú",
    "Venezuela",
    "Uruguay",
    "Paraguay",
    "Bolivia",
    "Ecuador",
    "Costa Rica",
    "Panamá",
    "Guatemala",
    "Honduras",
    "El Salvador",
    "Cuba",
    "República Dominicana",
    "Escocia",
    "Irlanda"
].sorted()


struct Country: Hashable, Identifiable {
    var id = UUID()
    var name: String
    var code: String
    var flag: String
    var phoneNumberPattern: String
}

let countries: [Country] = [
    Country(name: "United States", code: "+1", flag: "🇺🇸", phoneNumberPattern: "^[2-9]\\d{2}[2-9](?!11)\\d{6}$"),
    Country(name: "Canada", code: "+1", flag: "🇨🇦", phoneNumberPattern: "^[2-9]\\d{2}[2-9](?!11)\\d{6}$"),
    Country(name: "Mexico", code: "+52", flag: "🇲🇽", phoneNumberPattern: "^\\d{10}$"),
    Country(name: "Brazil", code: "+55", flag: "🇧🇷", phoneNumberPattern: "^\\d{10,11}$"),
    Country(name: "Argentina", code: "+54", flag: "🇦🇷", phoneNumberPattern: "^\\d{10}$"),
    Country(name: "Colombia", code: "+57", flag: "🇨🇴", phoneNumberPattern: "^\\d{10}$"),
    Country(name: "Chile", code: "+56", flag: "🇨🇱", phoneNumberPattern: "^\\d{9}$"),
    Country(name: "Peru", code: "+51", flag: "🇵🇪", phoneNumberPattern: "^\\d{9}$"),
    Country(name: "Venezuela", code: "+58", flag: "🇻🇪", phoneNumberPattern: "^\\d{10}$"),
    Country(name: "Uruguay", code: "+598", flag: "🇺🇾", phoneNumberPattern: "^\\d{8,9}$"),
    Country(name: "Paraguay", code: "+595", flag: "🇵🇾", phoneNumberPattern: "^\\d{9}$"),
    Country(name: "Bolivia", code: "+591", flag: "🇧🇴", phoneNumberPattern: "^\\d{8}$"),
    Country(name: "Ecuador", code: "+593", flag: "🇪🇨", phoneNumberPattern: "^\\d{9}$"),
    Country(name: "Guyana", code: "+592", flag: "🇬🇾", phoneNumberPattern: "^\\d{7}$"),
    Country(name: "Suriname", code: "+597", flag: "🇸🇷", phoneNumberPattern: "^\\d{6,7}$"),
    Country(name: "Panama", code: "+507", flag: "🇵🇦", phoneNumberPattern: "^\\d{8}$"),
    Country(name: "Costa Rica", code: "+506", flag: "🇨🇷", phoneNumberPattern: "^\\d{8}$"),
    Country(name: "Guatemala", code: "+502", flag: "🇬🇹", phoneNumberPattern: "^\\d{8}$"),
    Country(name: "Honduras", code: "+504", flag: "🇭🇳", phoneNumberPattern: "^\\d{8}$"),
    Country(name: "El Salvador", code: "+503", flag: "🇸🇻", phoneNumberPattern: "^\\d{8}$"),
    Country(name: "Nicaragua", code: "+505", flag: "🇳🇮", phoneNumberPattern: "^\\d{8}$"),
    Country(name: "Cuba", code: "+53", flag: "🇨🇺", phoneNumberPattern: "^\\d{8}$"),
    Country(name: "Dominican Republic", code: "+1", flag: "🇩🇴", phoneNumberPattern: "^\\d{10}$"),
    Country(name: "Haiti", code: "+509", flag: "🇭🇹", phoneNumberPattern: "^\\d{8}$"),
    Country(name: "Jamaica", code: "+1", flag: "🇯🇲", phoneNumberPattern: "^\\d{10}$"),
    Country(name: "Trinidad and Tobago", code: "+1", flag: "🇹🇹", phoneNumberPattern: "^\\d{10}$"),
    Country(name: "Barbados", code: "+1", flag: "🇧🇧", phoneNumberPattern: "^\\d{10}$"),
    Country(name: "Bahamas", code: "+1", flag: "🇧🇸", phoneNumberPattern: "^\\d{10}$")
]
