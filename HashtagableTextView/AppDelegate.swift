//
//  AppDelegate.swift
//  HashtagableTextView
//
//  Created by Albert Bori on 12/8/15.
//  Copyright © 2015 albertbori. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}



let hashtagDatabase = [ "Aardwolf", "Admiral", "Adouri", "African", "Agama", "Agile", "Agouti", "Albatross", "Alligator", "Alpaca", "Amazon", "American", "Anaconda", "Andean", "Ant", "Anteater", "Antechinus", "Antelope", "Arboral", "Arctic", "Argalis", "Armadillo", "Asian", "Asiatic", "Australian", "Avocet", "Azara", "Baboon", "Badger", "Bahama", "Bald", "Baleen", "Banded", "Bandicoot", "Barasingha", "Barbet", "Bare", "Barking", "Barrows", "Bat", "Bateleur", "Bear", "Beaver", "Bee", "Beisa", "Bengal", "Bennett", "Bent", "Bettong", "Bird", "Bison", "Black", "Blackbird", "Blackbuck", "Blackish", "Blacksmith", "Bleeding", "Blesbok", "Bleu", "Blue", "Boa", "Boar", "Boat", "Bobcat", "Bohor", "Bonnet", "Bontebok", "Booby", "Bottle", "Boubou", "Brazilian", "Brindled", "Brocket", "Brolga", "Brown", "Brush", "Buffalo", "Bulbul", "Bunting", "Burchell", "Burmese", "Burrowing", "Bush", "Bushbaby", "Bushbuck", "Bushpig", "Bustard", "Butterfly", "Buttermilk", "Caiman", "California", "Camel", "Campo", "Canada", "Canadian", "Cape", "Capuchin", "Capybara", "Caracal", "Caracara", "Cardinal", "Caribou", "Carmine", "Carpet", "Cat", "Catfish", "Cattle", "Cereopsis", "Chacma", "Chameleon", "Cheetah", "Chestnut", "Chickadee", "Chilean", "Chimpanzee", "Chipmunk", "Chital", "Chuckwalla", "Civet", "Clark", "Cliffchat", "Coatimundi", "Cobra", "Cockatoo", "Coke", "Collared", "Colobus", "Columbian", "Comb", "Common", "Constrictor", "Cook", "Coot", "Coqui", "Corella", "Cormorant", "Cottonmouth", "Cougar", "Cow", "Coyote", "Crab", "Crake", "Crane", "Creeper", "Crested", "Crimson", "Crocodile", "Crow", "Crown", "Crowned", "Cuis", "Curlew", "Currasow", "Curve", "Dabchick", "Dama", "Dark", "Darter", "Darwin", "Dassie", "Deer", "Defassa", "Denham", "Desert", "Devil", "Dik", "Dingo", "Dog", "Dolphin", "Dove", "Downy", "Dragon", "Dragonfly", "Dromedary", "Drongo", "Duck", "Duiker", "Dunnart", "Dusky", "Eagle", "Eastern", "Echidna", "Egret", "Egyptian", "Eland", "Elegant", "Elephant", "Eleven", "Elk", "Emerald", "Emu", "Eurasian", "Euro", "European", "Fairy", "Falcon", "Fat", "Feathertail", "Feral", "Ferret", "Ferruginous", "Field", "Finch", "Fisher", "Flamingo", "Flicker", "Flightless", "Flycatcher", "Flying", "Fork", "Four", "Fowl", "Fox", "Francolin", "Frilled", "Fringe", "Frog", "Frogmouth", "Galah", "Galapagos", "Gambel", "Gaur", "Gazelle", "Gazer", "Gecko", "Gelada", "Gemsbok", "Genet", "Genoveva", "Gerbil", "Gerenuk", "Giant", "Gila", "Giraffe", "Glider", "Glossy", "Gnu", "Goanna", "Goat", "Godwit", "Golden", "Goldeneye", "Goliath", "Gonolek", "Goose", "Gorilla", "Grant", "Gray", "Great", "Greater", "Grebe", "Green", "Grenadier", "Grey", "Greylag", "Griffon", "Grison", "Grizzly", "Ground", "Groundhog", "Grouse", "Guanaco", "Guerza", "Gull", "Gulls", "Hanuman", "Harbor", "Hare", "Hartebeest", "Hawk", "Hedgehog", "Helmeted", "Hen", "Heron", "Herring", "Hippopotamus", "Hoary", "Hoffman", "Honey", "Hoopoe", "Hornbill", "Horned", "Hottentot", "House", "Hudsonian", "Hummingbird", "Huron", "Hyena", "Hyrax", "Ibex", "Ibis", "Iguana", "Impala", "Indian", "Insect", "Jabiru", "Jacana", "Jackal", "Jackrabbit", "Jaeger", "Jaguar", "Jaguarundi", "Japanese", "Javan", "Javanese", "Jungle", "Kaffir", "Kafue", "Kalahari", "Kangaroo", "Kelp", "Killer", "King", "Kingfisher", "Kinkajou", "Kirk", "Kiskadee", "Kite", "Klipspringer", "Knob", "Koala", "Komodo", "Kongoni", "Kookaburra", "Kori", "Kudu", "Land", "Langur", "Lappet", "Lapwing", "Large", "Lark", "Laughing", "Lava", "Leadbeateri", "Least", "Lechwe", "Legaan", "Lemming", "Lemur", "Leopard", "Lesser", "Levaillant", "Lilac", "Lily", "Lion", "Little", "Lizard", "Llama", "Long", "Lorikeet", "Loris", "Lory", "Lourie", "Lynx", "Macaque", "Macaw", "Madagascar", "Magellanic", "Magistrate", "Magnificent", "Magpie", "Malabar", "Malachite", "Malagasy", "Malay", "Mallard", "Malleefowl", "Manatee", "Mandras", "Mara", "Marabou", "Margay", "Marine", "Marmot", "Marshbird", "Marten", "Masked", "Meerkat", "Mexican", "Miner", "Mississippi", "Moccasin", "Mocking", "Mockingbird", "Mongoose", "Monitor", "Monkey", "Monster", "Moorhen", "Moose", "Mouflon", "Mountain", "Mourning", "Mouse", "Mudskipper", "Mule", "Musk", "Mynah", "Native", "Nelson", "Neotropic", "Netted", "Nighthawk", "Nile", "Nilgai", "Nine", "North", "Northern", "Nubian", "Numbat", "Nutcracker", "Nuthatch", "Nyala", "Ocelot", "Old", "Olive", "Onager", "Openbill", "Opossum", "Orca", "Oribi", "Oriental", "Ornate", "Oryx", "Osprey", "Ostrich", "Otter", "Ovenbird", "Owl", "Ox", "Oystercatcher", "Paca", "Pacific", "Paddy", "Pademelon", "Painted", "Pale", "Pallas", "Palm", "Pampa", "Paradoxure", "Parakeet", "Parrot", "Partridge", "Peacock", "Peccary", "Pelican", "Penguin", "Peregrine", "Phalarope", "Phascogale", "Pheasant", "Pie", "Pied", "Pig", "Pigeon", "Pine", "Pintail", "Plains", "Platypus", "Plover", "Pocket", "Polar", "Polecat", "Porcupine", "Possum", "Potoroo", "Prairie", "Praying", "Prehensile", "Pronghorn", "Puffin", "Puku", "Puma", "Puna", "Purple", "Pygmy", "Python", "Quail", "Quoll", "Rabbit", "Raccoon", "Racer", "Radiated", "Rainbow", "Rat", "Rattlesnake", "Raven", "Red", "Reedbuck", "Reindeer", "Rhea", "Rhesus", "Rhinoceros", "Richardson", "Ring", "Ringtail", "River", "Roadrunner", "Roan", "Robin", "Rock", "Roe", "Roller", "Rose", "Roseat", "Roseate", "Royal", "Rufous", "Russian", "Sable", "Sacred", "Saddle", "Sage", "Sally", "Salmon", "Sambar", "Sandgrouse", "Sandhill", "Sandpiper", "Sarus", "Savanna", "Savannah", "Scaly", "Scarlet", "Scottish", "Screamer", "Sea", "Seal", "Secretary", "Serval", "Seven", "Shark", "Sheathbill", "Sheep", "Shelduck", "Short", "Shrew", "Shrike", "Sidewinder", "Sifaka", "Silver", "Siskin", "Skimmer", "Skink", "Skua", "Skunk", "Slender", "Sloth", "Small", "Smith", "Snake", "Snow", "Snowy", "Sociable", "Sockeye", "South", "Southern", "Sparrow", "Spectacled", "Spider", "Spoonbill", "Sportive", "Spotted", "Springbok", "Springbuck", "Springhare", "Spur", "Spurfowl", "Square", "Squirrel", "Stanley", "Starfish", "Starling", "Steenbok", "Steenbuck", "Steller", "Stick", "Stilt", "Stone", "Stork", "Striated", "Striped", "Sugar", "Sulfur", "Sun", "Sunbird", "Sungazer", "Superb", "Suricate", "Swainson", "Swallow", "Swamp", "Swan", "Tailless", "Tamandua", "Tammar", "Tapir", "Tarantula", "Tasmanian", "Tawny", "Tayra", "Teal", "Tenrec", "Tern", "Thirteen", "Thomson", "Thrasher", "Three", "Tiger", "Timber", "Tinamou", "Toddy", "Tokay", "Topi", "Tortoise", "Toucan", "Tree", "Tropical", "Trotter", "Trumpeter", "Tsessebe", "Turaco", "Turkey", "Turtle", "Two", "Tyrant", "Uinta", "Urial", "Verreaux", "Vervet", "Vicuna", "Vine", "Violet", "Viper", "Vulture", "Wagtail", "Wallaby", "Wallaroo", "Wambenger", "Wapiti", "Warthog", "Water", "Waterbuck", "Wattled", "Waved", "Waxbill", "Weaver", "Weeper", "Western", "Whale", "Whip", "White", "Wild", "Wildebeest", "Wolf", "Wombat", "Wood", "Woodchuck", "Woodcock", "Woodpecker", "Woodrat", "Woolly", "Worm", "Woylie", "Yak", "Yellow", "Zebra", "Zorilla", "Zorro"]