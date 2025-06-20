//
//  OSMIconMapper.swift
//  Mapverse
//
//  Created by Dave Paiva on 19/06/25.
//

import Foundation

/**
 * OpenStreetMap Feature Icon Mapping
 *
 * This utility provides icon mapping functionality for OpenStreetMap features.
 * Each OSM tag combination is mapped to an appropriate emoji icon for display.
 *
 * Based on the official OpenStreetMap Map Features:
 * https://wiki.openstreetmap.org/wiki/Map_features
 */

struct OSMIconMapper {
    
    /// Get an emoji icon for an OSM feature based on its tags
    /// - Parameter tags: Dictionary of OSM tags
    /// - Returns: Emoji string representing the feature
    static func getOSMFeatureIcon(for tags: [String: String]) -> String {
        
        // Aerialway
        if let aerialway = tags["aerialway"] {
            switch aerialway {
            case "cable_car", "gondola":
                return "🚠"
            case "chair_lift":
                return "🎿"
            case "drag_lift", "t-bar", "j-bar":
                return "⛷️"
            case "zip_line":
                return "🎢"
            default:
                return "🚡"
            }
        }
        
        // Aeroway
        if let aeroway = tags["aeroway"] {
            switch aeroway {
            case "aerodrome", "helipad":
                return "🛩️"
            case "runway", "taxiway":
                return "🛫"
            case "terminal":
                return "🏢"
            case "gate":
                return "🚪"
            case "hangar":
                return "🏭"
            default:
                return "✈️"
            }
        }
        
        // Amenity - Comprehensive mapping
        if let amenity = tags["amenity"] {
            switch amenity {
            // Sustenance
            case "restaurant":
                return "🍽️"
            case "fast_food":
                return "🍔"
            case "cafe":
                return "☕"
            case "pub":
                return "🍺"
            case "bar":
                return "🍸"
            case "food_court":
                return "🍴"
            case "biergarten":
                return "🍻"
            case "ice_cream":
                return "🍦"
            
            // Education
            case "school":
                return "🏫"
            case "university", "college":
                return "🎓"
            case "kindergarten":
                return "👶"
            case "library":
                return "📚"
            case "driving_school":
                return "🚗"
            case "music_school":
                return "🎵"
            case "language_school":
                return "🗣️"
            
            // Transportation
            case "parking":
                return "🅿️"
            case "bicycle_parking":
                return "🚲"
            case "fuel":
                return "⛽"
            case "charging_station":
                return "🔌"
            case "car_rental":
                return "🚙"
            case "car_sharing":
                return "🚗"
            case "taxi":
                return "🚕"
            case "bus_station":
                return "🚌"
            case "ferry_terminal":
                return "⛴️"
            
            // Financial
            case "bank":
                return "🏦"
            case "atm":
                return "🏧"
            case "bureau_de_change":
                return "💱"
            
            // Healthcare
            case "hospital":
                return "🏥"
            case "clinic", "doctors":
                return "👨‍⚕️"
            case "dentist":
                return "🦷"
            case "pharmacy":
                return "💊"
            case "veterinary":
                return "🐕‍🦺"
            
            // Entertainment, Arts & Culture
            case "theatre":
                return "🎭"
            case "cinema":
                return "🎬"
            case "nightclub":
                return "🕺"
            case "casino":
                return "🎰"
            case "community_centre":
                return "🏛️"
            case "arts_centre":
                return "🎨"
            case "fountain":
                return "⛲"
            
            // Public Service
            case "townhall":
                return "🏛️"
            case "courthouse":
                return "⚖️"
            case "embassy":
                return "🏛️"
            case "fire_station":
                return "🚒"
            case "police":
                return "👮"
            case "post_office":
                return "📮"
            case "prison":
                return "🏛️"
            
            // Facilities
            case "toilets":
                return "🚻"
            case "shower":
                return "🚿"
            case "telephone":
                return "📞"
            case "internet_cafe":
                return "💻"
            case "post_box":
                return "📫"
            case "drinking_water":
                return "🚰"
            case "water_point":
                return "💧"
            case "bench":
                return "🪑"
            case "shelter":
                return "🏠"
            case "marketplace":
                return "🏪"
            case "vending_machine":
                return "🏪"
            
            // Waste Management
            case "waste_basket":
                return "🗑️"
            case "waste_disposal", "recycling":
                return "♻️"
            
            // Others
            case "place_of_worship":
                return "⛪"
            case "grave_yard", "crematorium":
                return "⚰️"
            case "social_facility":
                return "🏠"
            case "nursing_home":
                return "🏥"
            case "childcare":
                return "👶"
            case "social_centre":
                return "🏛️"
            
            default:
                return "📍"
            }
        }
        
        // Barrier
        if let barrier = tags["barrier"] {
            switch barrier {
            case "fence", "wall":
                return "🧱"
            case "gate":
                return "🚪"
            case "bollard":
                return "🔴"
            case "cycle_barrier":
                return "🚲"
            case "toll_booth":
                return "💰"
            default:
                return "🚧"
            }
        }
        
        // Building
        if let building = tags["building"] {
            switch building {
            case "house", "residential":
                return "🏠"
            case "apartments":
                return "🏢"
            case "commercial", "retail":
                return "🏬"
            case "office":
                return "🏢"
            case "industrial":
                return "🏭"
            case "warehouse":
                return "🏭"
            case "hospital":
                return "🏥"
            case "school":
                return "🏫"
            case "church", "cathedral", "mosque", "temple", "synagogue":
                return "⛪"
            case "hotel":
                return "🏨"
            case "garage":
                return "🏠"
            case "train_station":
                return "🚉"
            case "greenhouse":
                return "🌿"
            case "barn", "farm":
                return "🚜"
            case "stadium":
                return "🏟️"
            case "sports_hall":
                return "🏟️"
            case "fire_station":
                return "🚒"
            case "police":
                return "👮"
            case "prison":
                return "🏛️"
            default:
                return "🏢"
            }
        }
        
        // Craft
        if let craft = tags["craft"] {
            switch craft {
            case "bakery":
                return "🥖"
            case "brewery":
                return "🍺"
            case "carpenter":
                return "🔨"
            case "electrician":
                return "⚡"
            case "gardener":
                return "🌱"
            case "painter":
                return "🎨"
            case "photographer":
                return "📸"
            case "plumber":
                return "🔧"
            case "shoemaker":
                return "👞"
            case "tailor":
                return "✂️"
            case "watchmaker":
                return "⌚"
            default:
                return "🔧"
            }
        }
        
        // Emergency
        if let emergency = tags["emergency"] {
            switch emergency {
            case "ambulance_station":
                return "🚑"
            case "fire_station":
                return "🚒"
            case "police":
                return "👮"
            case "phone":
                return "📞"
            case "fire_hydrant":
                return "🚒"
            case "defibrillator":
                return "⚡"
            case "lifeguard":
                return "🏊"
            case "assembly_point":
                return "🚨"
            default:
                return "🚨"
            }
        }
        
        // Healthcare
        if let healthcare = tags["healthcare"] {
            switch healthcare {
            case "hospital":
                return "🏥"
            case "clinic":
                return "👨‍⚕️"
            case "dentist":
                return "🦷"
            case "pharmacy":
                return "💊"
            case "physiotherapist":
                return "🤸"
            case "psychotherapist":
                return "🧠"
            case "veterinary":
                return "🐕‍🦺"
            case "laboratory":
                return "🔬"
            case "blood_donation":
                return "🩸"
            default:
                return "⚕️"
            }
        }
        
        // Highway
        if let highway = tags["highway"] {
            switch highway {
            case "motorway", "trunk":
                return "🛣️"
            case "primary", "secondary", "tertiary":
                return "🛤️"
            case "residential", "living_street":
                return "🏘️"
            case "pedestrian", "footway":
                return "🚶"
            case "cycleway":
                return "🚲"
            case "path", "track":
                return "🥾"
            case "steps":
                return "🪜"
            case "bus_stop":
                return "🚌"
            case "traffic_signals":
                return "🚦"
            case "stop":
                return "🛑"
            case "crossing":
                return "🚸"
            case "speed_camera":
                return "📷"
            case "motorway_junction":
                return "🛣️"
            default:
                return "🛣️"
            }
        }
        
        // Historic
        if let historic = tags["historic"] {
            switch historic {
            case "castle":
                return "🏰"
            case "monument", "memorial":
                return "🗿"
            case "archaeological_site":
                return "⛏️"
            case "ruins":
                return "🏛️"
            case "church", "cathedral":
                return "⛪"
            case "museum":
                return "🏛️"
            case "fort":
                return "🏰"
            case "manor":
                return "🏘️"
            case "tomb":
                return "⚰️"
            case "wayside_cross":
                return "✝️"
            case "city_gate":
                return "🚪"
            case "tower":
                return "🗼"
            default:
                return "🏛️"
            }
        }
        
        // Landuse
        if let landuse = tags["landuse"] {
            switch landuse {
            case "residential":
                return "🏘️"
            case "commercial":
                return "🏬"
            case "industrial":
                return "🏭"
            case "retail":
                return "🛍️"
            case "forest":
                return "🌲"
            case "farmland", "farmyard":
                return "🚜"
            case "orchard":
                return "🍎"
            case "vineyard":
                return "🍇"
            case "cemetery":
                return "⚰️"
            case "recreation_ground":
                return "⚽"
            case "quarry":
                return "⛏️"
            case "landfill":
                return "🗑️"
            case "construction":
                return "🚧"
            case "grass":
                return "🌱"
            case "meadow":
                return "🌾"
            default:
                return "🌍"
            }
        }
        
        // Leisure
        if let leisure = tags["leisure"] {
            switch leisure {
            case "park":
                return "🌳"
            case "playground":
                return "🛝"
            case "garden":
                return "🌹"
            case "sports_centre", "fitness_centre":
                return "🏋️"
            case "swimming_pool":
                return "🏊"
            case "golf_course":
                return "⛳"
            case "stadium":
                return "🏟️"
            case "pitch":
                return "⚽"
            case "tennis_court":
                return "🎾"
            case "basketball_court":
                return "🏀"
            case "marina":
                return "⛵"
            case "beach_resort":
                return "🏖️"
            case "picnic_table":
                return "🧺"
            case "dog_park":
                return "🐕"
            case "nature_reserve":
                return "🦎"
            case "bird_hide":
                return "🦅"
            case "fishing":
                return "🎣"
            case "amusement_arcade":
                return "🎮"
            case "adult_gaming_centre":
                return "🎰"
            case "dance":
                return "💃"
            case "bowling_alley":
                return "🎳"
            case "escape_game":
                return "🔐"
            case "hackerspace":
                return "💻"
            case "indoor_play":
                return "🎪"
            case "miniature_golf":
                return "⛳"
            case "sauna":
                return "🧖"
            case "water_park":
                return "🌊"
            default:
                return "🎮"
            }
        }
        
        // Man made
        if let manMade = tags["man_made"] {
            switch manMade {
            case "bridge":
                return "🌉"
            case "tower":
                return "🗼"
            case "water_tower":
                return "🌊"
            case "lighthouse":
                return "🗼"
            case "windmill":
                return "💨"
            case "windmill_historic":
                return "🏛️"
            case "pier":
                return "🛥️"
            case "breakwater":
                return "🌊"
            case "chimney":
                return "🏭"
            case "storage_tank":
                return "⛽"
            case "silo":
                return "🏭"
            case "crane":
                return "🏗️"
            case "works":
                return "🏭"
            case "kiln":
                return "🔥"
            case "adit", "mineshaft":
                return "⛏️"
            case "petroleum_well":
                return "🛢️"
            case "water_well":
                return "💧"
            case "surveillance":
                return "📹"
            case "telescope":
                return "🔭"
            case "mast":
                return "📡"
            case "antenna":
                return "📡"
            default:
                return "🏗️"
            }
        }
        
        // Military
        if let military = tags["military"] {
            switch military {
            case "base", "barracks":
                return "🪖"
            case "bunker":
                return "🏰"
            case "checkpoint":
                return "🚧"
            case "naval_base":
                return "⚓"
            case "airfield":
                return "✈️"
            case "training_area":
                return "🎯"
            default:
                return "🪖"
            }
        }
        
        // Natural
        if let natural = tags["natural"] {
            switch natural {
            case "wood", "forest":
                return "🌲"
            case "tree":
                return "🌳"
            case "grassland", "meadow":
                return "🌾"
            case "heath", "scrub":
                return "🌿"
            case "wetland", "marsh":
                return "🐸"
            case "water", "lake":
                return "🏞️"
            case "river", "stream":
                return "🏞️"
            case "spring":
                return "💧"
            case "beach":
                return "🏖️"
            case "coastline":
                return "🌊"
            case "cliff":
                return "⛰️"
            case "peak", "volcano":
                return "🏔️"
            case "hill":
                return "⛰️"
            case "valley":
                return "🏞️"
            case "ridge":
                return "⛰️"
            case "glacier":
                return "❄️"
            case "cave_entrance":
                return "🕳️"
            case "rock", "stone":
                return "🪨"
            case "sand":
                return "🏖️"
            case "bare_rock":
                return "🪨"
            case "scree":
                return "🏔️"
            default:
                return "🌿"
            }
        }
        
        // Office
        if let office = tags["office"] {
            switch office {
            case "company", "corporation":
                return "🏢"
            case "government":
                return "🏛️"
            case "lawyer":
                return "⚖️"
            case "ngo", "association":
                return "🤝"
            case "political_party":
                return "🗳️"
            case "insurance":
                return "🛡️"
            case "estate_agent":
                return "🏘️"
            case "architect":
                return "📐"
            case "employment_agency":
                return "💼"
            case "newspaper":
                return "📰"
            case "advertising_agency":
                return "📢"
            case "educational_institution":
                return "🎓"
            case "research":
                return "🔬"
            case "it":
                return "💻"
            case "telecommunication":
                return "📞"
            case "financial":
                return "💰"
            case "accountant":
                return "📊"
            case "diplomatic":
                return "🏛️"
            case "travel_agent":
                return "✈️"
            default:
                return "🏢"
            }
        }
        
        // Place
        if let place = tags["place"] {
            switch place {
            case "continent":
                return "🌍"
            case "country":
                return "🏴"
            case "state", "province":
                return "🗺️"
            case "region":
                return "🗺️"
            case "county", "district":
                return "🏛️"
            case "municipality":
                return "🏛️"
            case "city":
                return "🏙️"
            case "borough", "suburb":
                return "🏘️"
            case "quarter", "neighbourhood":
                return "🏘️"
            case "town":
                return "🏘️"
            case "village":
                return "🏘️"
            case "hamlet":
                return "🏘️"
            case "isolated_dwelling":
                return "🏠"
            case "farm":
                return "🚜"
            case "locality":
                return "📍"
            case "island":
                return "🏝️"
            case "islet":
                return "🏝️"
            default:
                return "📍"
            }
        }
        
        // Power
        if let power = tags["power"] {
            switch power {
            case "plant", "generator":
                return "⚡"
            case "substation":
                return "🔌"
            case "transformer":
                return "🔌"
            case "tower", "pole":
                return "📡"
            case "line":
                return "⚡"
            case "cable":
                return "🔌"
            case "switch":
                return "🔌"
            case "compensator":
                return "⚡"
            case "converter":
                return "🔌"
            case "portal":
                return "🚪"
            default:
                return "⚡"
            }
        }
        
        // Public transport
        if let publicTransport = tags["public_transport"] {
            switch publicTransport {
            case "stop_position", "platform":
                return "🚏"
            case "station":
                return "🚉"
            case "stop_area":
                return "🚌"
            default:
                return "🚌"
            }
        }
        
        // Railway
        if let railway = tags["railway"] {
            switch railway {
            case "rail", "light_rail":
                return "🚆"
            case "subway":
                return "🚇"
            case "tram":
                return "🚊"
            case "monorail":
                return "🚝"
            case "narrow_gauge":
                return "🚂"
            case "preserved":
                return "🚂"
            case "funicular":
                return "🚡"
            case "station":
                return "🚉"
            case "halt", "tram_stop":
                return "🚏"
            case "subway_entrance":
                return "🚇"
            case "level_crossing":
                return "🚦"
            case "signal":
                return "🚦"
            case "switch":
                return "🔀"
            case "railway_crossing":
                return "🚂"
            case "buffer_stop":
                return "🚧"
            case "derail":
                return "🚧"
            case "turntable":
                return "🔄"
            case "roundhouse":
                return "🏢"
            case "workshop":
                return "🔧"
            case "engine_shed":
                return "🏭"
            case "water_tower":
                return "🌊"
            case "fuel":
                return "⛽"
            case "wash":
                return "🚿"
            default:
                return "🚆"
            }
        }
        
        // Shop - Comprehensive mapping
        if let shop = tags["shop"] {
            switch shop {
            // Food, beverages
            case "supermarket", "convenience":
                return "🛒"
            case "bakery":
                return "🥖"
            case "butcher":
                return "🥩"
            case "cheese":
                return "🧀"
            case "chocolate":
                return "🍫"
            case "coffee":
                return "☕"
            case "confectionery":
                return "🍭"
            case "dairy":
                return "🥛"
            case "deli":
                return "🥪"
            case "farm":
                return "🚜"
            case "frozen_food":
                return "🧊"
            case "greengrocer":
                return "🥕"
            case "health_food":
                return "🥗"
            case "ice_cream":
                return "🍦"
            case "pasta":
                return "🍝"
            case "pastry":
                return "🥐"
            case "seafood":
                return "🐟"
            case "spices":
                return "🌶️"
            case "tea":
                return "🫖"
            case "wine":
                return "🍷"
            case "alcohol":
                return "🍺"
            case "beverages":
                return "🥤"
            
            // General store, department store, mall
            case "department_store":
                return "🏬"
            case "general":
                return "🏪"
            case "kiosk":
                return "🏪"
            case "mall":
                return "🏬"
            case "wholesale":
                return "📦"
            
            // Clothing, shoes, accessories
            case "clothes", "fashion":
                return "👗"
            case "boutique":
                return "👠"
            case "fabric":
                return "🧵"
            case "jewelry":
                return "💎"
            case "leather":
                return "👜"
            case "shoes":
                return "👠"
            case "tailor":
                return "✂️"
            case "watches":
                return "⌚"
            case "bag":
                return "👜"
            
            // Discount store, charity
            case "variety_store":
                return "🏪"
            case "charity", "second_hand":
                return "♻️"
            case "pawnbroker":
                return "💰"
            
            // Health and beauty
            case "beauty", "cosmetics":
                return "💄"
            case "chemist", "pharmacy":
                return "💊"
            case "hairdresser":
                return "💇"
            case "hearing_aids":
                return "👂"
            case "herbalist":
                return "🌿"
            case "massage":
                return "💆"
            case "medical_supply":
                return "🏥"
            case "nutrition_supplements":
                return "💊"
            case "optician":
                return "👓"
            case "perfumery":
                return "🌸"
            case "tattoo":
                return "🎨"
            
            // Do-it-yourself, household, building materials, gardening
            case "doityourself", "hardware":
                return "🔨"
            case "paint":
                return "🎨"
            case "trade":
                return "🔧"
            case "electrical":
                return "⚡"
            case "energy":
                return "🔋"
            case "fireplace":
                return "🔥"
            case "florist":
                return "🌸"
            case "garden_centre":
                return "🌻"
            case "gas":
                return "🔥"
            case "glaziery":
                return "🪟"
            case "groundskeeping":
                return "🌿"
            case "houseware":
                return "🏠"
            case "locksmith":
                return "🔑"
            case "swimming_pool":
                return "🏊"
            
            // Furniture and interior
            case "antiques":
                return "🏺"
            case "bed":
                return "🛏️"
            case "candles":
                return "🕯️"
            case "carpet":
                return "🏠"
            case "curtain":
                return "🏠"
            case "furniture":
                return "🪑"
            case "interior_decoration":
                return "🎨"
            case "kitchen":
                return "🍽️"
            case "lamps":
                return "💡"
            case "tiles":
                return "🏠"
            case "window_blind":
                return "🪟"
            
            // Electronics
            case "computer":
                return "💻"
            case "electronics":
                return "📱"
            case "hifi":
                return "🎵"
            case "mobile_phone":
                return "📱"
            case "radiotechnics":
                return "📻"
            case "vacuum_cleaner":
                return "🧹"
            
            // Outdoors and sport, vehicles
            case "outdoor":
                return "🏕️"
            case "sports":
                return "⚽"
            case "bicycle":
                return "🚲"
            case "car":
                return "🚗"
            case "car_parts":
                return "🔧"
            case "car_repair":
                return "🔧"
            case "fuel":
                return "⛽"
            case "motorcycle":
                return "🏍️"
            case "tyres":
                return "🛞"
            
            // Art, music, hobbies
            case "art":
                return "🎨"
            case "collector":
                return "📦"
            case "craft":
                return "🧵"
            case "frame":
                return "🖼️"
            case "games":
                return "🎲"
            case "model":
                return "✈️"
            case "music":
                return "🎵"
            case "musical_instrument":
                return "🎹"
            case "photo":
                return "📸"
            case "camera":
                return "📷"
            case "trophy":
                return "🏆"
            case "video":
                return "📹"
            case "video_games":
                return "🎮"
            
            // Stationery, gifts, books, newspapers
            case "books":
                return "📚"
            case "gift":
                return "🎁"
            case "lottery":
                return "🎫"
            case "newsagent":
                return "📰"
            case "stationery":
                return "✏️"
            case "ticket":
                return "🎫"
            case "tobacco":
                return "🚬"
            case "toys":
                return "🧸"
            
            // Others
            case "bookmaker":
                return "🎰"
            case "copyshop":
                return "📄"
            case "dry_cleaning":
                return "👔"
            case "e-cigarette":
                return "💨"
            case "funeral_directors":
                return "⚰️"
            case "laundry":
                return "👕"
            case "money_lender":
                return "💰"
            case "party":
                return "🎉"
            case "pet":
                return "🐕"
            case "pet_grooming":
                return "🐕‍🦺"
            case "pyrotechnics":
                return "🎆"
            case "religion":
                return "⛪"
            case "storage_rental":
                return "📦"
            case "travel_agency":
                return "✈️"
            case "vacant":
                return "🏪"
            case "weapons":
                return "🗡️"
            
            default:
                return "🛍️"
            }
        }
        
        // Telecom
        if let telecom = tags["telecom"] {
            switch telecom {
            case "exchange":
                return "📞"
            case "connection_point":
                return "🔌"
            case "service_device":
                return "📡"
            default:
                return "📞"
            }
        }
        
        // Tourism
        if let tourism = tags["tourism"] {
            switch tourism {
            case "hotel":
                return "🏨"
            case "motel":
                return "🏨"
            case "guest_house":
                return "🏠"
            case "hostel":
                return "🏠"
            case "chalet":
                return "🏔️"
            case "alpine_hut":
                return "🏔️"
            case "wilderness_hut":
                return "🏕️"
            case "camp_site":
                return "🏕️"
            case "caravan_site":
                return "🚐"
            case "apartment":
                return "🏢"
            case "attraction":
                return "🎯"
            case "museum":
                return "🏛️"
            case "theme_park":
                return "🎢"
            case "zoo":
                return "🦁"
            case "aquarium":
                return "🐠"
            case "viewpoint":
                return "👁️"
            case "gallery":
                return "🖼️"
            case "artwork":
                return "🎨"
            case "picnic_site":
                return "🧺"
            case "information":
                return "ℹ️"
            default:
                return "🗺️"
            }
        }
        
        // Water
        if let water = tags["water"] {
            switch water {
            case "lake", "pond":
                return "🏞️"
            case "basin", "reservoir":
                return "🌊"
            case "river":
                return "🏞️"
            case "canal":
                return "🚢"
            case "reflecting_pool":
                return "🌊"
            case "swimming_pool":
                return "🏊"
            case "fountain":
                return "⛲"
            case "hot_spring":
                return "♨️"
            case "geyser":
                return "💨"
            default:
                return "💧"
            }
        }
        
        // Waterway
        if let waterway = tags["waterway"] {
            switch waterway {
            case "river", "stream":
                return "🏞️"
            case "canal":
                return "🚢"
            case "drain", "ditch":
                return "🌊"
            case "rapids":
                return "🌊"
            case "waterfall":
                return "🌊"
            case "weir", "dam":
                return "🏗️"
            case "lock_gate":
                return "🚪"
            case "turning_point":
                return "🔄"
            case "water_point":
                return "💧"
            case "fuel":
                return "⛽"
            case "dock", "boatyard":
                return "⛵"
            default:
                return "🌊"
            }
        }
        
        // Default fallback
        return "📍"
    }
    
    /// Get a human-readable label for an OSM feature
    /// - Parameter tags: Dictionary of OSM tags
    /// - Returns: A string label for the feature
    static func getOSMFeatureLabel(for tags: [String: String]) -> String {
        return tags["name"] ??
               tags["amenity"] ??
               tags["tourism"] ??
               tags["shop"] ??
               tags["leisure"] ??
               tags["building"] ??
               tags["natural"] ??
               tags["historic"] ??
               tags["craft"] ??
               tags["office"] ??
               tags["highway"] ??
               tags["railway"] ??
               tags["aeroway"] ??
               tags["aerialway"] ??
               tags["emergency"] ??
               tags["healthcare"] ??
               tags["military"] ??
               tags["barrier"] ??
               tags["man_made"] ??
               tags["place"] ??
               tags["power"] ??
               tags["public_transport"] ??
               tags["telecom"] ??
               tags["water"] ??
               tags["waterway"] ??
               tags["landuse"] ??
               "POI"
    }
}
