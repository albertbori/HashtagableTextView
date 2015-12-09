//
//  ViewController.swift
//  HashtagableTextView
//
//  Created by Albert Bori on 12/8/15.
//  Copyright © 2015 albertbori. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var hashtagableTextView: HashtagableTextView!
    
//    override func willRotateToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {
//        hashtagableTextView.updateSuggestedHashtagPosition()
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hashtagableTextView.didStartTypingHashtag = { [weak self] partialHashtag in
            if let this = self {
                let searchableString = partialHashtag.stringByReplacingOccurrencesOfString("#", withString: "")
                this.hashtagableTextView.showSuggestedHashtags(this._hashtagDatabase.filter({ $0.lowercaseString.containsString(searchableString.lowercaseString) }))
            }
        }
        //hashtagableTextView.suggestedHashtagHeaderText = "Suggested Hashtags"
//        hashtagableTextView.text = "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\nLorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris #nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda."
//        hashtagableTextView.highlightHashtags()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
        
        hashtagableTextView.becomeFirstResponder()
    }
    
    
    //MARK - Keyboard events
    
    func keyboardWillShow(notification: NSNotification) {
        let keyboardSize = notification.userInfo![UIKeyboardFrameBeginUserInfoKey]?.CGRectValue.size
        hashtagableTextView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize!.height, right: 0)
    }
    
    func keyboardWillHide(notification: NSNotification) {
        hashtagableTextView.contentInset = UIEdgeInsetsZero
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    private let _hashtagDatabase = [ "Aardwolf", "Admiral", "Adouri", "African", "Agama", "Agile", "Agouti", "Albatross", "Alligator", "Alpaca", "Amazon", "American", "Anaconda", "Andean", "Ant", "Anteater", "Antechinus", "Antelope", "Arboral", "Arctic", "Argalis", "Armadillo", "Asian", "Asiatic", "Australian", "Avocet", "Azara", "Baboon", "Badger", "Bahama", "Bald", "Baleen", "Banded", "Bandicoot", "Barasingha", "Barbet", "Bare", "Barking", "Barrows", "Bat", "Bateleur", "Bear", "Beaver", "Bee", "Beisa", "Bengal", "Bennett", "Bent", "Bettong", "Bird", "Bison", "Black", "Blackbird", "Blackbuck", "Blackish", "Blacksmith", "Bleeding", "Blesbok", "Bleu", "Blue", "Boa", "Boar", "Boat", "Bobcat", "Bohor", "Bonnet", "Bontebok", "Booby", "Bottle", "Boubou", "Brazilian", "Brindled", "Brocket", "Brolga", "Brown", "Brush", "Buffalo", "Bulbul", "Bunting", "Burchell", "Burmese", "Burrowing", "Bush", "Bushbaby", "Bushbuck", "Bushpig", "Bustard", "Butterfly", "Buttermilk", "Caiman", "California", "Camel", "Campo", "Canada", "Canadian", "Cape", "Capuchin", "Capybara", "Caracal", "Caracara", "Cardinal", "Caribou", "Carmine", "Carpet", "Cat", "Catfish", "Cattle", "Cereopsis", "Chacma", "Chameleon", "Cheetah", "Chestnut", "Chickadee", "Chilean", "Chimpanzee", "Chipmunk", "Chital", "Chuckwalla", "Civet", "Clark", "Cliffchat", "Coatimundi", "Cobra", "Cockatoo", "Coke", "Collared", "Colobus", "Columbian", "Comb", "Common", "Constrictor", "Cook", "Coot", "Coqui", "Corella", "Cormorant", "Cottonmouth", "Cougar", "Cow", "Coyote", "Crab", "Crake", "Crane", "Creeper", "Crested", "Crimson", "Crocodile", "Crow", "Crown", "Crowned", "Cuis", "Curlew", "Currasow", "Curve", "Dabchick", "Dama", "Dark", "Darter", "Darwin", "Dassie", "Deer", "Defassa", "Denham", "Desert", "Devil", "Dik", "Dingo", "Dog", "Dolphin", "Dove", "Downy", "Dragon", "Dragonfly", "Dromedary", "Drongo", "Duck", "Duiker", "Dunnart", "Dusky", "Eagle", "Eastern", "Echidna", "Egret", "Egyptian", "Eland", "Elegant", "Elephant", "Eleven", "Elk", "Emerald", "Emu", "Eurasian", "Euro", "European", "Fairy", "Falcon", "Fat", "Feathertail", "Feral", "Ferret", "Ferruginous", "Field", "Finch", "Fisher", "Flamingo", "Flicker", "Flightless", "Flycatcher", "Flying", "Fork", "Four", "Fowl", "Fox", "Francolin", "Frilled", "Fringe", "Frog", "Frogmouth", "Galah", "Galapagos", "Gambel", "Gaur", "Gazelle", "Gazer", "Gecko", "Gelada", "Gemsbok", "Genet", "Genoveva", "Gerbil", "Gerenuk", "Giant", "Gila", "Giraffe", "Glider", "Glossy", "Gnu", "Goanna", "Goat", "Godwit", "Golden", "Goldeneye", "Goliath", "Gonolek", "Goose", "Gorilla", "Grant", "Gray", "Great", "Greater", "Grebe", "Green", "Grenadier", "Grey", "Greylag", "Griffon", "Grison", "Grizzly", "Ground", "Groundhog", "Grouse", "Guanaco", "Guerza", "Gull", "Gulls", "Hanuman", "Harbor", "Hare", "Hartebeest", "Hawk", "Hedgehog", "Helmeted", "Hen", "Heron", "Herring", "Hippopotamus", "Hoary", "Hoffman", "Honey", "Hoopoe", "Hornbill", "Horned", "Hottentot", "House", "Hudsonian", "Hummingbird", "Huron", "Hyena", "Hyrax", "Ibex", "Ibis", "Iguana", "Impala", "Indian", "Insect", "Jabiru", "Jacana", "Jackal", "Jackrabbit", "Jaeger", "Jaguar", "Jaguarundi", "Japanese", "Javan", "Javanese", "Jungle", "Kaffir", "Kafue", "Kalahari", "Kangaroo", "Kelp", "Killer", "King", "Kingfisher", "Kinkajou", "Kirk", "Kiskadee", "Kite", "Klipspringer", "Knob", "Koala", "Komodo", "Kongoni", "Kookaburra", "Kori", "Kudu", "Land", "Langur", "Lappet", "Lapwing", "Large", "Lark", "Laughing", "Lava", "Leadbeateri", "Least", "Lechwe", "Legaan", "Lemming", "Lemur", "Leopard", "Lesser", "Levaillant", "Lilac", "Lily", "Lion", "Little", "Lizard", "Llama", "Long", "Lorikeet", "Loris", "Lory", "Lourie", "Lynx", "Macaque", "Macaw", "Madagascar", "Magellanic", "Magistrate", "Magnificent", "Magpie", "Malabar", "Malachite", "Malagasy", "Malay", "Mallard", "Malleefowl", "Manatee", "Mandras", "Mara", "Marabou", "Margay", "Marine", "Marmot", "Marshbird", "Marten", "Masked", "Meerkat", "Mexican", "Miner", "Mississippi", "Moccasin", "Mocking", "Mockingbird", "Mongoose", "Monitor", "Monkey", "Monster", "Moorhen", "Moose", "Mouflon", "Mountain", "Mourning", "Mouse", "Mudskipper", "Mule", "Musk", "Mynah", "Native", "Nelson", "Neotropic", "Netted", "Nighthawk", "Nile", "Nilgai", "Nine", "North", "Northern", "Nubian", "Numbat", "Nutcracker", "Nuthatch", "Nyala", "Ocelot", "Old", "Olive", "Onager", "Openbill", "Opossum", "Orca", "Oribi", "Oriental", "Ornate", "Oryx", "Osprey", "Ostrich", "Otter", "Ovenbird", "Owl", "Ox", "Oystercatcher", "Paca", "Pacific", "Paddy", "Pademelon", "Painted", "Pale", "Pallas", "Palm", "Pampa", "Paradoxure", "Parakeet", "Parrot", "Partridge", "Peacock", "Peccary", "Pelican", "Penguin", "Peregrine", "Phalarope", "Phascogale", "Pheasant", "Pie", "Pied", "Pig", "Pigeon", "Pine", "Pintail", "Plains", "Platypus", "Plover", "Pocket", "Polar", "Polecat", "Porcupine", "Possum", "Potoroo", "Prairie", "Praying", "Prehensile", "Pronghorn", "Puffin", "Puku", "Puma", "Puna", "Purple", "Pygmy", "Python", "Quail", "Quoll", "Rabbit", "Raccoon", "Racer", "Radiated", "Rainbow", "Rat", "Rattlesnake", "Raven", "Red", "Reedbuck", "Reindeer", "Rhea", "Rhesus", "Rhinoceros", "Richardson", "Ring", "Ringtail", "River", "Roadrunner", "Roan", "Robin", "Rock", "Roe", "Roller", "Rose", "Roseat", "Roseate", "Royal", "Rufous", "Russian", "Sable", "Sacred", "Saddle", "Sage", "Sally", "Salmon", "Sambar", "Sandgrouse", "Sandhill", "Sandpiper", "Sarus", "Savanna", "Savannah", "Scaly", "Scarlet", "Scottish", "Screamer", "Sea", "Seal", "Secretary", "Serval", "Seven", "Shark", "Sheathbill", "Sheep", "Shelduck", "Short", "Shrew", "Shrike", "Sidewinder", "Sifaka", "Silver", "Siskin", "Skimmer", "Skink", "Skua", "Skunk", "Slender", "Sloth", "Small", "Smith", "Snake", "Snow", "Snowy", "Sociable", "Sockeye", "South", "Southern", "Sparrow", "Spectacled", "Spider", "Spoonbill", "Sportive", "Spotted", "Springbok", "Springbuck", "Springhare", "Spur", "Spurfowl", "Square", "Squirrel", "Stanley", "Starfish", "Starling", "Steenbok", "Steenbuck", "Steller", "Stick", "Stilt", "Stone", "Stork", "Striated", "Striped", "Sugar", "Sulfur", "Sun", "Sunbird", "Sungazer", "Superb", "Suricate", "Swainson", "Swallow", "Swamp", "Swan", "Tailless", "Tamandua", "Tammar", "Tapir", "Tarantula", "Tasmanian", "Tawny", "Tayra", "Teal", "Tenrec", "Tern", "Thirteen", "Thomson", "Thrasher", "Three", "Tiger", "Timber", "Tinamou", "Toddy", "Tokay", "Topi", "Tortoise", "Toucan", "Tree", "Tropical", "Trotter", "Trumpeter", "Tsessebe", "Turaco", "Turkey", "Turtle", "Two", "Tyrant", "Uinta", "Urial", "Verreaux", "Vervet", "Vicuna", "Vine", "Violet", "Viper", "Vulture", "Wagtail", "Wallaby", "Wallaroo", "Wambenger", "Wapiti", "Warthog", "Water", "Waterbuck", "Wattled", "Waved", "Waxbill", "Weaver", "Weeper", "Western", "Whale", "Whip", "White", "Wild", "Wildebeest", "Wolf", "Wombat", "Wood", "Woodchuck", "Woodcock", "Woodpecker", "Woodrat", "Woolly", "Worm", "Woylie", "Yak", "Yellow", "Zebra", "Zorilla", "Zorro"]
}

