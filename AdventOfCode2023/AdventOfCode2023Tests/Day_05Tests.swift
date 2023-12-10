//
//  Day_05Tests.swift
//  AdventOfCode2023Tests
//
//  Created by David Taylor on 08/12/2023.
//

import Foundation
import XCTest
@testable import AdventOfCode2023

final class Day05Tests: XCTestCase {
    // seeds: Seeds that need to be planted
    // maps: source (e.g. seed number) to destination category (e.g. soil number)
    // ranges: destination range start, source range start, range length
    // e.g. 50 98 2 -> source range is 98, 99, destination range is 50 and 51
    // seed 98 -> soil 50, seed 99 -> soil 51
    //
    // e.g. 52 50 48
    // seed 50 -> soil 52, seed 97 -> soil 99
    //
    // soil numbers not mapped correspond to the same number
    // seed 10 -> soil 10
    let sampleData = """
    seeds: 79 14 55 13

    seed-to-soil map:
    50 98 2
    52 50 48

    soil-to-fertilizer map:
    0 15 37
    37 52 2
    39 0 15

    fertilizer-to-water map:
    49 53 8
    0 11 42
    42 0 7
    57 7 4

    water-to-light map:
    88 18 7
    18 25 70

    light-to-temperature map:
    45 77 23
    81 45 19
    68 64 13

    temperature-to-humidity map:
    0 69 1
    1 0 69

    humidity-to-location map:
    60 56 37
    56 93 4
    """
    
    // Find the lowest location number that corresponds to any of the initial seeds
    //
    // Seed 79, soil 81, fertilizer 81, water 81, light 74, temperature 78, humidity 78, location 82.
    // Seed 14, soil 14, fertilizer 53, water 49, light 42, temperature 42, humidity 43, location 43.
    // Seed 55, soil 57, fertilizer 57, water 53, light 46, temperature 82, humidity 82, location 86.
    // Seed 13, soil 13, fertilizer 52, water 41, light 34, temperature 34, humidity 35, location 35.
    func test_part1_sampleData() {
        XCTAssertEqual(35, day05_part1(sampleData))
    }
    
    func test_part1_extractSeeds() {
        XCTAssertEqual([79, 14, 55, 13], extractSeeds("seeds: 79 14 55 13"))
    }
    
    func test_part1_extractSeedMaps() {
        let seedMaps = extractSeedMaps(sampleData)
        XCTAssertEqual(7, seedMaps.count)
        
        // seed-to-soil map:
        // 50 98 2
        // 52 50 48
        let seedToSoil = seedMaps[0]
        XCTAssertEqual(2, seedToSoil.count)
        XCTAssertEqual(SeedMap(sourceStart: 98, destinationStart: 50, rangeLength: 2), seedToSoil[0])
        XCTAssertEqual(SeedMap(sourceStart: 50, destinationStart: 52, rangeLength: 48), seedToSoil[1])
        
        // soil-to-fertilizer map:
        // 0 15 37
        // 37 52 2
        // 39 0 15
        let soilToFertilizer = seedMaps[1]
        XCTAssertEqual(3, soilToFertilizer.count)
        XCTAssertEqual(SeedMap(sourceStart: 15, destinationStart: 0, rangeLength: 37), soilToFertilizer[0])
        XCTAssertEqual(SeedMap(sourceStart: 52, destinationStart: 37, rangeLength: 2), soilToFertilizer[1])
        XCTAssertEqual(SeedMap(sourceStart: 0, destinationStart: 39, rangeLength: 15), soilToFertilizer[2])
        
        // fertilizer-to-water map:
        // 49 53 8
        // 0 11 42
        // 42 0 7
        // 57 7 4
        let fertilizerToWater = seedMaps[2]
        XCTAssertEqual(4, fertilizerToWater.count)
        XCTAssertEqual(SeedMap(sourceStart: 53, destinationStart: 49, rangeLength: 8), fertilizerToWater[0])
        XCTAssertEqual(SeedMap(sourceStart: 11, destinationStart: 0, rangeLength: 42), fertilizerToWater[1])
        XCTAssertEqual(SeedMap(sourceStart: 0, destinationStart: 42, rangeLength: 7), fertilizerToWater[2])
        XCTAssertEqual(SeedMap(sourceStart: 7, destinationStart: 57, rangeLength: 4), fertilizerToWater[3])
        
        // water-to-light map:
        // 88 18 7
        // 18 25 70
        let waterToLight = seedMaps[3]
        XCTAssertEqual(2, waterToLight.count)
        XCTAssertEqual(SeedMap(sourceStart: 18, destinationStart: 88, rangeLength: 7), waterToLight[0])
        XCTAssertEqual(SeedMap(sourceStart: 25, destinationStart: 18, rangeLength: 70), waterToLight[1])

        // light-to-temperature map:
        // 45 77 23
        // 81 45 19
        // 68 64 13
        let lightToTemperature = seedMaps[4]
        XCTAssertEqual(3, lightToTemperature.count)
        XCTAssertEqual(SeedMap(sourceStart: 77, destinationStart: 45, rangeLength: 23), lightToTemperature[0])
        XCTAssertEqual(SeedMap(sourceStart: 45, destinationStart: 81, rangeLength: 19), lightToTemperature[1])
        XCTAssertEqual(SeedMap(sourceStart: 64, destinationStart: 68, rangeLength: 13), lightToTemperature[2])

        // temperature-to-humidity map:
        // 0 69 1
        // 1 0 69
        let temperatureToHumidity = seedMaps[5]
        XCTAssertEqual(2, temperatureToHumidity.count)
        XCTAssertEqual(SeedMap(sourceStart: 69, destinationStart: 0, rangeLength: 1), temperatureToHumidity[0])
        XCTAssertEqual(SeedMap(sourceStart: 0, destinationStart: 1, rangeLength: 69), temperatureToHumidity[1])

        // humidity-to-location map:
        // 60 56 37
        // 56 93 4
        let humidityToLocation = seedMaps[6]
        XCTAssertEqual(2, humidityToLocation.count)
        XCTAssertEqual(SeedMap(sourceStart: 56, destinationStart: 60, rangeLength: 37), humidityToLocation[0])
        XCTAssertEqual(SeedMap(sourceStart: 93, destinationStart: 56, rangeLength: 4), humidityToLocation[1])
    }
    
    func test_part1_sourceToDestination() {
        // seed-to-soil map:
        // 50 98 2
        // 52 50 48
        let seedToSoilOne = SeedMap(sourceStart: 98, destinationStart: 50, rangeLength: 2)
        let seedToSoilTwo = SeedMap(sourceStart: 50, destinationStart: 52, rangeLength: 48)
        
        // In range -> should map to destination
        XCTAssertTrue(seedToSoilOne.inRange(98))
        XCTAssertTrue(seedToSoilOne.inRange(99))
        XCTAssertEqual(50, seedToSoilOne.destination(98))
        XCTAssertEqual(51, seedToSoilOne.destination(99))
        
        // Not in range -> should return source
        XCTAssertFalse(seedToSoilOne.inRange(49))
        XCTAssertFalse(seedToSoilOne.inRange(52))
        XCTAssertEqual(49, seedToSoilOne.destination(49))
        XCTAssertEqual(52, seedToSoilOne.destination(52))
        
        // In range -> should map to destination
        XCTAssertTrue(seedToSoilTwo.inRange(50))
        XCTAssertTrue(seedToSoilTwo.inRange(97))
        XCTAssertEqual(52, seedToSoilTwo.destination(50))
        XCTAssertEqual(99, seedToSoilTwo.destination(97))
        
        // Not in range -> should return source
        XCTAssertFalse(seedToSoilTwo.inRange(49))
        XCTAssertFalse(seedToSoilTwo.inRange(98))
        XCTAssertEqual(49, seedToSoilTwo.destination(49))
        XCTAssertEqual(98, seedToSoilTwo.destination(98))
    }
    
    func test_part1_sourceToDestination_Array() {
        // seed-to-soil map:
        // 50 98 2
        // 52 50 48
        let seedMaps = [
            SeedMap(sourceStart: 98, destinationStart: 50, rangeLength: 2),
            SeedMap(sourceStart: 50, destinationStart: 52, rangeLength: 48)
        ]
        XCTAssertEqual(81, seedMaps.destination(79))
        XCTAssertEqual(14, seedMaps.destination(14))
        XCTAssertEqual(57, seedMaps.destination(55))
        XCTAssertEqual(13, seedMaps.destination(13))
    }
    
    func test_part1_puzzleInput() {
        XCTAssertEqual(389_056_265, day05_part1(puzzleInput))
    }
    
//    func test_part2_sampleData() {
//        XCTAssertEqual(46, day05_part2(sampleData))
//    }
    
    func test_part2_puzzleInput() {
//        XCTAssertEqual(-1, day05_part2(puzzleInput))
    }
    
    func test_part2_sourceToDestinationRange_Array() {// 52 50 48
        let seedMap = SeedMap(sourceStart: 82, destinationStart: 50, rangeLength: 2)
        
        // No overlap
        XCTAssertEqual([55..<68], seedMap.destinationRanges(55..<68))
        
        // Partial overlap with lower bound (50..<52 mapped from 82..<84)
        // 79..<93
        // -> [79..<82, 82..<84, 84..<93]
        // -> [79..<82, 50..<52, 84..<93] -> sort
        XCTAssertEqual([50..<52, 79..<82, 84..<93], seedMap.destinationRanges(79..<93))
        
        // Contained within range
        let seedMap2 = SeedMap(sourceStart: 82, destinationStart: 50, rangeLength: 6)
        XCTAssertEqual([50..<52], seedMap.destinationRanges(82..<84))
        
        // Partial overlap with upper bound (50..<56 mapped from 84..<90)
        // 84..<110
        // -> [84..<90, 90..<110]
        // -> [50..<56, 90..<110]
        XCTAssertEqual([52..<56, 88..<110], seedMap2.destinationRanges(84..<110))
    }
    
    func test_part2_soilRangeMapping() {
        // seeds: 79 14 55 13
        //
        // seed-to-soil map:
        // 50 98 2
        // 52 50 48
        let seedMaps = [
            SeedMap(sourceStart: 98, destinationStart: 50, rangeLength: 2),
            SeedMap(sourceStart: 50, destinationStart: 52, rangeLength: 48)
        ]
        XCTAssertEqual([79..<93], seedMaps[0].destinationRanges(79..<93)) // identity map
        XCTAssertEqual([81..<95], seedMaps[1].destinationRanges(79..<93)) // all in range +2 offset
        XCTAssertEqual([55..<68], seedMaps[0].destinationRanges(55..<68)) // identity map
        XCTAssertEqual([57..<70], seedMaps[1].destinationRanges(55..<68)) // all in range +2 offset
        
        XCTAssertEqual([79..<93, 81..<95], seedMaps.destinationRanges(79..<93))
        XCTAssertEqual([55..<68, 57..<70], seedMaps.destinationRanges(55..<68))
        
        // [55..<68, 57..<70, 79..<93, 81..<95]
        // Should merge ranges to minimise input to next stage
        XCTAssertEqual([55..<70, 79..<95], seedMaps.destinationRanges([79..<93, 55..<68]))
    }
    
    func test_part2_soilToFertilizerMapping() {
        // input ranges: [55..<70, 79..<95]
        //
        // soil-to-fertilizer map:
        // 0 15 37
        // 37 52 2
        // 39 0 15
        let seedMaps = [
            SeedMap(sourceStart: 15, destinationStart: 0, rangeLength: 37),
            SeedMap(sourceStart: 52, destinationStart: 37, rangeLength: 2),
            SeedMap(sourceStart: 0, destinationStart: 39, rangeLength: 15)
        ]
        XCTAssertEqual([55..<70], seedMaps[0].destinationRanges(55..<70)) // identity map
        XCTAssertEqual([55..<70], seedMaps[1].destinationRanges(55..<70)) // identity map
        XCTAssertEqual([55..<70], seedMaps[2].destinationRanges(55..<70)) // identity map
        
        XCTAssertEqual([79..<95], seedMaps[0].destinationRanges(79..<95)) // identity map
        XCTAssertEqual([79..<95], seedMaps[1].destinationRanges(79..<95)) // identity map
        XCTAssertEqual([79..<95], seedMaps[2].destinationRanges(79..<95)) // identity map
        
        XCTAssertEqual([55..<70, 55..<70, 55..<70], seedMaps.destinationRanges(55..<70))
        XCTAssertEqual([79..<95, 79..<95, 79..<95], seedMaps.destinationRanges(79..<95))
        
        XCTAssertEqual([55..<70, 79..<95], seedMaps.destinationRanges([55..<70, 79..<95]))
    }
    
    func test_part2_fertilizerToWaterMapping() {
        // input ranges: [55..<70, 79..<95]
        //
        // fertilizer-to-water map:
        // 49 53 8
        // 0 11 42
        // 42 0 7
        // 57 7 4
        let seedMaps = [
            SeedMap(sourceStart: 53, destinationStart: 49, rangeLength: 8),
            SeedMap(sourceStart: 11, destinationStart: 0, rangeLength: 42),
            SeedMap(sourceStart: 0, destinationStart: 42, rangeLength: 7),
            SeedMap(sourceStart: 7, destinationStart: 57, rangeLength: 4),
        ]
        
        XCTAssertEqual([51..<70, 79..<95], seedMaps.destinationRanges([55..<70, 79..<95]))
    }
    
    func test_part2_waterToLightMapping() {
        // input ranges: [51..<70, 79..<95]
        //
        // water-to-light map:
        // 88 18 7
        // 18 25 70
        let seedMaps = [
            SeedMap(sourceStart: 18, destinationStart: 88, rangeLength: 7),
            SeedMap(sourceStart: 25, destinationStart: 18, rangeLength: 70)
        ]
        
        XCTAssertEqual([44..<70, 72..<95], seedMaps.destinationRanges([51..<70, 79..<95]))
    }
    
    func test_part2_lightToTemperatureMapping() {
        // input ranges: [44..<70, 72..<95]
        //
        // light-to-temperature map:
        // 45 77 23
        // 81 45 19
        // 68 64 13
        let seedMaps = [
            SeedMap(sourceStart: 77, destinationStart: 45, rangeLength: 23),
            SeedMap(sourceStart: 45, destinationStart: 81, rangeLength: 19),
            SeedMap(sourceStart: 64, destinationStart: 68, rangeLength: 13),
        ]
        
        XCTAssertEqual([44..<63, 64..<100], seedMaps.destinationRanges([44..<70, 72..<95]))
    }
    
    func test_part2_temperatureToHumidityMapping() {
        // input ranges: [44..<63, 64..<100]
        //
        // temperature-to-humidity map:
        // 0 69 1
        // 1 0 69
        let seedMaps = [
            SeedMap(sourceStart: 69, destinationStart: 0, rangeLength: 1),
            SeedMap(sourceStart: 0, destinationStart: 1, rangeLength: 69)
        ]
        
        XCTAssertEqual([0..<1, 44..<64, 64..<100], seedMaps.destinationRanges([44..<63, 64..<100]))
    }
    
    func test_part2_humidityToLocationMapping() {
        // input ranges: [0..<1, 44..<64, 64..<100]
        //
        // humidity-to-location map:
        // 60 56 37
        // 56 93 4
        let seedMaps = [
            SeedMap(sourceStart: 56, destinationStart: 60, rangeLength: 37),
            SeedMap(sourceStart: 93, destinationStart: 56, rangeLength: 4)
        ]
        
        XCTAssertEqual([0..<1, 44..<60, 60..<100], seedMaps.destinationRanges([0..<1, 44..<64, 64..<100]))
    }
    
    // Find lowest possible offset
    // -> seed value that yields most negative outcome in batch
    // Find closest seed to offset (below range or reducing location)
    // Where are biggest negative offsets?
    //
    // Seed 13, soil 13, fertilizer 52, water 41, light 34, temperature 34, humidity 35, location 35 -> offset +22
    // Seed 14, soil 14, fertilizer 53, water 49, light 42, temperature 42, humidity 43, location 43 -> offset +29
    // Seed 55, soil , fertilizer , water , light , temperature , humidity , location
    // Seed 79, soil 81, fertilizer 81, water 81, light 74, temperature 78, humidity 78, location 82 -> offset +2
    // Seed 80, soil , fertilizer , water , light , temperature , humidity , location
    // Seed 81, soil 83, fertilizer , water , light , temperature , humidity , location
    // Seed 82, soil 84, fertilizer 84, water 84, light 77, temperature 45, humidity 46, location 46 -> offset -36
    // Seed 83, soil , fertilizer , water , light , temperature , humidity , location
    func test_part2_extractSeedRanges() {
        XCTAssertEqual([79 ..< 93, 55 ..< 68], extractSeedRanges("seeds: 79 14 55 13"))
    }
    
    // 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 92 <-- max
    // 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67
    // process 7 seedMaps eah with multiple rows to find
    
    let puzzleInput = """
    seeds: 4239267129 20461805 2775736218 52390530 3109225152 741325372 1633502651 46906638 967445712 47092469 2354891449 237152885 2169258488 111184803 2614747853 123738802 620098496 291114156 2072253071 28111202

    seed-to-soil map:
    803774611 641364296 1132421037
    248421506 1797371961 494535345
    1936195648 2752993203 133687519
    2069883167 2294485405 458507798
    2804145277 283074539 358289757
    3162435034 2886680722 1132532262
    2528390965 4019212984 275754312
    766543479 248421506 34653033
    742956851 1773785333 23586628
    801196512 2291907306 2578099

    soil-to-fertilizer map:
    2497067833 718912393 1047592994
    3544660827 4222700866 72266430
    770426288 3365742958 209338740
    3698421476 2775964622 508284117
    1441878450 1818019282 725791090
    417593992 265113557 15217985
    979765028 3760587444 462113422
    2167669540 2543810372 143892547
    3616927257 3284248739 81494219
    4206705593 2687702919 88261703
    2380194851 3575081698 116872982
    0 280331542 15942291
    718912393 1766505387 51513895
    152480435 0 265113557
    2311562087 3691954680 68632764
    15942291 296273833 136538144

    fertilizer-to-water map:
    0 402310798 253353164
    778924681 2773042028 194127973
    2853824225 2967170001 585461563
    3827117536 3909653920 385313376
    4259877071 3552631564 35090225
    973052654 3635167948 222704323
    253353164 0 389964349
    2230088185 778924681 571954391
    1195756977 1490392659 342200935
    2802042576 3857872271 51781649
    643317513 389964349 12346449
    4212430912 3587721789 47446159
    3439285788 2385210280 387831748
    1677471499 1832593594 552616686
    1537957912 1350879072 139513587

    water-to-light map:
    1548505089 767179152 4433418
    3833169479 2956286720 133538400
    2966709060 3309731935 102304094
    1552938507 844050660 203612289
    4257043426 3089825120 37923870
    2862957901 3567999512 28008008
    127112704 319767838 4466599
    840317941 174506417 34039792
    2890965909 3596007520 40520529
    15787022 2007458428 111325682
    2398090681 21771313 152735104
    1094590916 1294380254 4387553
    517844904 840169267 3881393
    2556445662 1535118242 8735340
    1266005567 2376897884 172496096
    874357733 1314885059 220233183
    3696946976 2820064217 136222503
    2271345339 208546209 111221629
    703336145 477538609 136981796
    389299157 1710880680 59057725
    4183266377 2766992510 22982117
    521726297 324234437 53105792
    1438501663 1881931289 110003426
    131579303 1298767807 16117252
    2102535156 614520405 152658747
    0 2549393980 15787022
    1098978469 1543853582 167027098
    3966707879 2789974627 30089590
    2255193903 0 16151436
    1756550796 377340229 100198380
    574832089 2360386712 16511172
    2382566968 1991934715 15523713
    3069013154 3636528049 627933822
    2766992510 3178543922 79332992
    2931486438 3274509313 35222622
    3996797469 4264461871 30505425
    2846325502 3257876914 16632399
    2033978459 771612570 68556697
    4206248494 3127748990 50794932
    2550825785 16151436 5619877
    591343261 1769938405 111992884
    448356882 1047662949 69488022
    4027302894 3412036029 155963483
    147696555 2118784110 241602602
    1856749176 1117150971 177229283

    light-to-temperature map:
    2549521624 1806050718 400234502
    1279003707 1469066403 336984315
    2063720323 2518736018 367281175
    4240496851 236622733 54470445
    3737038415 1201359870 20798035
    1170741345 1222157905 108262362
    1925074187 1330420267 138646136
    3757836450 291093178 323945285
    3424587617 2206285220 312450798
    236622733 2886017193 934118612
    4138496410 1042644754 102000441
    4081781735 1144645195 56714675
    2431001498 615038463 118520126
    1615988022 733558589 309086165
    2949756126 3820135805 474831491

    temperature-to-humidity map:
    725888341 86282489 843183510
    3782717746 1630698708 99613080
    2529768467 2786969418 347392693
    2195908552 2059541517 89214959
    3062107482 2168182310 90554707
    1730470902 3134362111 465437650
    2964061476 2688923412 98046006
    2285123511 2358509211 13167510
    2877161160 3875960109 61807956
    0 929465999 639605852
    3484769060 2148756476 19425834
    2298291021 1730311788 170053852
    639605852 0 86282489
    3504194894 2371676721 119346975
    4275382932 3599799761 19584364
    2468344873 2491023696 61423594
    3623541869 1900365640 159175877
    4138906810 2552447290 136476122
    3918976473 3656029772 219930337
    2938969116 4269874936 25092360
    3882330826 3619384125 36645647
    3152662189 3937768065 332106871
    1630698708 2258737017 99772194

    humidity-to-location map:
    1426868383 2786540732 64165562
    1639911414 2027746720 730664673
    857589555 0 114197007
    2370576087 1887556908 140189812
    3396523523 1265337150 488817864
    1491033945 2850706294 148877469
    3885341387 2999583763 409625909
    0 114197007 857589555
    1293466489 1754155014 133401894
    2510765899 3409209672 885757624
    1265337150 2758411393 28129339
    """
}
