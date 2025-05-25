//
//  mockdata.swift
//  ResursKollen
//
//  Created by Daniel A on 2025-05-21.
//
import Foundation

// Här finns en samling med mockData för olika klasserna


//MARK: Mockdata för klassen UserData
extension UserData{
    
    
    static let UserDataMockData = UserData(status: .employee,
                                           name: "Anna Svensson",
                                           email: "anna@test.se",
                                           employmentDate: Date(timeIntervalSince1970: 1581292800),
                                           employmentNumber: "EMP001",
                                           phoneNumber: "+46 8 123 456 789",
                                           detailedInfo: DetailedInfo(employmentType: .permanent,
                                                          personNummer: "19541214-1524",
                                                          bankkonto: "123.456.23",
                                                          
                                                          salary: 32000,
                                                          emergencyContact: "Mamma 046-305689",
                                                          extraInfo: "Duktig på att laga bilar"))
    
    
    
    
    
    
    /*UserData(id: "hdjdjlkj89357jjjf",
                 status: .employee,
                 name: "Anna Svensson",
                 email: "anna.svensson@example.com",
                 employmentDate: Date(timeIntervalSince1970: 1581292800),
                 employmentNumber: "EMP001",
                 phoneNumber: "+46701234567"),
               detailedInfo: DetailedInfo( employmentType: .permanent, personNummer: "19541214-1524", bankkonto: "123.456.23", bank: "Nordea", salary: 32000, emergencyContact: "Mamma 046-305689", extraInfo: "Duktig på att laga bilar")
    
       UserData(id: "fgdjgfjnkgfjk2232",
        status: .manager,
                name: "Björn Karlsson",
                email: "bjorn@example.com",
                employmentDate: Date(timeIntervalSince1970: 1527811200),
                employmentNumber: "EMP002",
                //createdDate: Date(timeIntervalSince1970: 1581292800),
                phoneNumber: "+46709876543"),
        
        UserData(id: "iodoemer858595",
                 status: .employee,
                 name: "Carina Ek",
                 email: "carina@example.com",
                 employmentDate: Date(timeIntervalSince1970: 1527811200),
                 employmentNumber: "EMP003",
                // createdDate: Date(timeIntervalSince1970: 1526774400),
                 phoneNumber: "+46701112233")] as [Any] */
    
}

//MARK: MockData för klassen MaterialSheetView

extension MaterialEditSheetView{
    
    static let premadeMaterialsMockData = [
        Material(name: "Kabelskor", price: 2.50),
        Material(name: "Bräda", price: 15.00),
        Material(name: "LED-list", price: 7.25),
        Material(name: "Skruv", price: 12.99),
        Material(name: "Kabel", price: 3.75),
        Material(name: "Mutter", price: 4.50),
        Material(name: "Silikon", price: 6.00),
        Material(name: "Avkalkningsmedel", price: 8.99),
        Material(name: "Hammare", price: 2.20),
        Material(name: "Plåt", price: 25.50),
        Material(name: "Kabelskor", price: 2.50),
        Material(name: "Bräda", price: 15.00),
        Material(name: "LED-list", price: 7.25),
        Material(name: "Skruv", price: 12.99),
        Material(name: "Kabel", price: 3.75),
        Material(name: "Mutter", price: 4.50),
        Material(name: "Silikon", price: 6.00),
        Material(name: "Avkalkningsmedel", price: 8.99),
        Material(name: "Hammare", price: 2.20),
        Material(name: "Plåt", price: 25.50),
        Material(name: "Kabelskor", price: 2.50),
        Material(name: "Bräda", price: 15.00),
        Material(name: "LED-list", price: 7.25),
        Material(name: "Skruv", price: 12.99),
        Material(name: "Kabel", price: 3.75),
        Material(name: "Mutter", price: 4.50),
        Material(name: "Silikon", price: 6.00),
        Material(name: "Avkalkningsmedel", price: 8.99),
        Material(name: "Hammare", price: 2.20),
        Material(name: "Plåt", price: 25.50),
        Material(name: "Kabelskor", price: 2.50),
        Material(name: "Bräda", price: 15.00),
        Material(name: "LED-list", price: 7.25),
        Material(name: "Skruv", price: 12.99),
        Material(name: "Kabel", price: 3.75),
        Material(name: "Mutter", price: 4.50),
        Material(name: "Silikon", price: 6.00),
        Material(name: "Avkalkningsmedel", price: 8.99),
        Material(name: "Hammare", price: 2.20),
        Material(name: "Plåt", price: 25.50),
        Material(name: "Kabelskor", price: 2.50),
        Material(name: "Bräda", price: 15.00),
        Material(name: "LED-list", price: 7.25),
        Material(name: "Skruv", price: 12.99),
        Material(name: "Kabel", price: 3.75),
        Material(name: "Mutter", price: 4.50),
        Material(name: "Silikon", price: 6.00),
        Material(name: "Avkalkningsmedel", price: 8.99),
        Material(name: "Hammare", price: 2.20),
        Material(name: "Plåt", price: 25.50),
        Material(name: "Kabelskor", price: 2.50),
        Material(name: "Bräda", price: 15.00),
        Material(name: "LED-list", price: 7.25),
        Material(name: "Skruv", price: 12.99),
        Material(name: "Kabel", price: 3.75),
        Material(name: "Mutter", price: 4.50),
        Material(name: "Silikon", price: 6.00),
        Material(name: "Avkalkningsmedel", price: 8.99),
        Material(name: "Hammare", price: 2.20),
        Material(name: "Plåt", price: 25.50),
    ]
}
//Mark: Mockdata för klassen Order
    
    extension Order{
        
        static let orderMockUpData = Order(
            id: "1",
            title: "Laga låskista",
            description:
                "Dynastin styrdes av mycket vidskepliga kungar från den mytologiska stammen Shang. Dynastin grundades efter att kung Cheng Tang störtat den föregående Xiadynastin. Dynastin präglades av många krig och oroligheter, men även av stora tekniska framsteg, inte minst inom bronsgjutning som upplevde en guldålder under Shangdynastin. Shangdynastins guldålder var under kung Wu Dings regeringstid. Wu Ding bedrev många militära kampanjer mot de omgivande stammarna såsom Tufang (土方) och Guifang (鬼方) vilket resulterade i territoriella erövringar. Efter Wu Ding följde flera kungar som prioriterade nöje före stadsaffärer, vilket gjorde att kungamakten blev alltmer isolerad och tidigare underlydande grupper blev självständiga och aggressiva. Den långlivade dynastin föll slutligen efter slaget vid Muye då huset Zhou tog makten och bildade Zhoudynastin. Shangdynastin är den äldsta kinesiska dynastin med samtida skriftliga källor",
            orderNumber: "244-2359-12",
            timeConsumption: 3.5,
            materialConsumption: [
                Material(name: "Copper Wire", quantity: 50, price: 2.50),
                Material(name: "Oak Plank", quantity: 10, price: 15.00),
                Material(name: "Steel Handle", quantity: 8, price: 7.25),
                Material(name: "Rose Bush", quantity: 5, price: 12.99),
                Material(name: "PVC Pipe", quantity: 20, price: 3.75),
                Material(name: "Brass Knob", quantity: 12, price: 4.50),
                Material(name: "Mulch Bag", quantity: 15, price: 6.00),
                Material(name: "LED Bulb", quantity: 25, price: 8.99),
                Material(name: "Ceramic Tile", quantity: 30, price: 2.20),
                Material(name: "Paint Can", quantity: 3, price: 25.50),
            ],
            status: .registered,
            dueDate: Date(),
            customer: Customer(
                name: "Saga Andersson",
                phoneNumber: "070-2358914",
                orders: [],
                streetName: "Kungsgatan 61",
                city: "Uppsala",
                postalCode: "75579",
                emailAddress: "saga.andersson@gmail.com"
            )
        )
        
    
    
}
